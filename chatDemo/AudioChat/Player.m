//
//  Player.m
//  Audio_Study
//
//  Created by 翯 on 2018-05-10.
//  Copyright © 2018 翯. All rights reserved.
//

#import "Player.h"

@implementation Player

-(id) init{
    if(self = [super init]){
        _isPlaying = NO;
        [self setupAudioFormat:kAudioFormatLinearPCM
                    SampleRate:kDefaultSampleRate];
        
        for(int i = 0; i < kNumberAudioQueueBuffers; ++i){
            _audioQueueBufferUsed[i] = false;
        }
    }
    synlock = [[NSLock alloc]init];
    return self;
}

-(void) resetBufferState:(AudioQueueRef)audioQueueRef
                     andQB:(AudioQueueBufferRef)audioQueueBufferRef{
    for(int i = 0; i < kNumberAudioQueueBuffers; ++i){
        if(audioQueueBufferRef == _audioQueueBuffers[i]){
            _audioQueueBufferUsed[i] = false;
        }
    }
}

static void AudioPlayerAQInputCallback(void *input,
                                AudioQueueRef outQ,
                                AudioQueueBufferRef outQB){
    Player *player = (__bridge Player *)input;
    [player resetBufferState:outQ andQB:outQB];
}


// 重构的时候封装出来，player和recorder都用了...
-(void) setupAudioFormat:(UInt32) inFormatID SampleRate:(int)sampleRate{
    // 重置
    memset(&_recordFormat, 0, sizeof(_recordFormat));
    //设置采样率(此处应为系统默认参数...后期替换掉sampleRate)
    _recordFormat.mSampleRate = sampleRate;
    //设置通道数
    _recordFormat.mChannelsPerFrame = 1;
    
    //设置format
    _recordFormat.mFormatID = inFormatID;
    
    if(inFormatID == kAudioFormatLinearPCM){
        //设置某些flag???
        _recordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        //每个通道里，一帧采集的bit数目(8bit = 1 byte 16 = 2bytes)
        _recordFormat.mBitsPerChannel = 16;
        
        // wtf??????
        _recordFormat.mBytesPerPacket
        = _recordFormat.mBytesPerFrame
        = (_recordFormat.mBitsPerChannel/8)*_recordFormat.mChannelsPerFrame;
        
        _recordFormat.mFramesPerPacket = 1;
    }
    
    AudioQueueNewOutput(&_recordFormat,
                        AudioPlayerAQInputCallback,
                        (__bridge void*)(self),
                        nil,
                        nil,
                        0,
                        &_audioQueue);
    
    for(int i = 0; i < kNumberAudioQueueBuffers; ++i){
        AudioQueueFreeBuffer(_audioQueue, _audioQueueBuffers[i]);
        AudioQueueAllocateBuffer(_audioQueue,
                                 MIN_SIZE_PER_FRAME,
                                 &_audioQueueBuffers[i]);
        
    }
}

-(void) pause{
    if(_isPlaying == YES){
        _isPlaying = NO;
        NSLog(@"stop playing\n");
        AudioQueueStop(_audioQueue, true);
        for(int i = 0; i < kNumberAudioQueueBuffers; ++i){
            AudioQueueFreeBuffer(_audioQueue, _audioQueueBuffers[i]);
            _audioQueueBufferUsed[i] = false;
        }
        AudioQueueDispose(_audioQueue, true);
    }
}

-(void) FakeData:(NSData *) pcmData{
    if(_isPlaying == NO){
        _isPlaying = YES;
        [self setupAudioFormat:kAudioFormatLinearPCM
                    SampleRate:kDefaultSampleRate];
        AudioQueueStart(_audioQueue, NULL);
    }
    [synlock lock];
    NSMutableData *tempData = [NSMutableData new];
    [tempData appendData:pcmData];
    
    //得到数据
    NSUInteger len = tempData.length;
    Byte *bytes = (Byte*)malloc(len);
    [tempData getBytes:bytes length: len];
    
    int i = 0;
    while(true){
        if(!_audioQueueBufferUsed[i]){
            _audioQueueBufferUsed[i] = true;
            break;
        }else{
            ++i;
            if(i >= kNumberAudioQueueBuffers){
                i = 0;
            }
        }
    }
    
    _audioQueueBuffers[i] -> mAudioDataByteSize = (unsigned int) len;
    //把bytes的头地址开始的len字节给mAudioData
    memcpy(_audioQueueBuffers[i]->mAudioData, bytes, len);
    free(bytes);
    
    AudioQueueEnqueueBuffer(_audioQueue, _audioQueueBuffers[i], 0, NULL);
    NSLog(@"播放。。。");
    [synlock unlock];
}

@end

