//
//  Recorder.m
//  Audio_Study
//
//  Created by 翯 on 2018-05-10.
//  Copyright © 2018 翯. All rights reserved.
//

#import "Recorder.h"

@implementation Recorder


-(void) setupAudioFormat:(UInt32) inFormatID SampleRate:(int)sampleRate{
    memset(&_recordFormat, 0, sizeof(_recordFormat));
    
    UInt32 size = sizeof(_recordFormat.mSampleRate);
    /*AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate,
                            &size,
                            &_recordFormat.mSampleRate);*/
    _recordFormat.mSampleRate = kDefaultSampleRate;
    
    size = sizeof(_recordFormat.mChannelsPerFrame);
    /*AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels,
                            &size,
                            &_recordFormat.mChannelsPerFrame);*/
    _recordFormat.mFormatID = inFormatID;
    _recordFormat.mChannelsPerFrame = 1;
    
    if (_recordFormat.mFormatID == kAudioFormatLinearPCM){
            _recordFormat.mFormatFlags     = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        
        _recordFormat.mBitsPerChannel  = 16;
        _recordFormat.mBytesPerPacket  = _recordFormat.mBytesPerFrame = (_recordFormat.mBitsPerChannel / 8) * _recordFormat.mChannelsPerFrame;
        _recordFormat.mFramesPerPacket = 1; // 用AudioQueue采集pcm需要这么设置
    }

}

-(id)init{
    if(self = [super init]){
        self.sampleRate = kDefaultSampleRate;
        self.bufferDurationSeconds = kDefaultBufferDurationSeconds;
    }
    [self setupAudioFormat:kAudioFormatLinearPCM
                SampleRate:(int)self.sampleRate];
    //[self setupAudioFormat:kAudioFormatMPEG4AAC SampleRate:(int)self.sampleRate];
    return self;
}

//-(CMSampleBufferRef)createAudioSample:(void *)audioData frames:(UInt32)len{
//
//}

//相当于中断服务函数，每次录取到音频数据就进入这个函数
//inAQ 是调用回调函数的音频队列
//inBuffer 是一个被音频队列填充新的音频数据的音频队列缓冲区，它包含了回调函数写入文件所需要的新数据
//inStartTime 是缓冲区中的一采样的参考时间，对于基本的录制，你的毁掉函数不会使用这个参数
//inNumPackets是inPacketDescs参数中包描述符（packet descriptions）的数量，
//  如果你正在录制一个VBR(可变比特率（variable bitrate））格式, 音频队列将会提供这个参数给你的回调函数，这个参数可以让你传递给
//  AudioFileWritePackets函数. CBR (常量比特率（constant bitrate）) 格式不使用包描述符。对于CBR录制，音频队列会设置这个参数并且将
//  inPacketDescs这个参数设置为NULL，官方解释为The number of packets of audio data sent to the callback in the inBuffer
//  parameter.
void inputBufferHandler(void *inUserData,
                        AudioQueueRef inAQ,
                        AudioQueueBufferRef inBuffer,
                        const AudioTimeStamp *inStartTime,
                        UInt32 inNumPackets,
                        const AudioStreamPacketDescription *inPacketDesc){
    // wtf is __bridge...
    Recorder *recorder = (__bridge Recorder*)inUserData;
    if(inNumPackets >0){
        NSData *data = [NSData dataWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
        [recorder sendData:data];
    }
    
    if(recorder.isRecording){
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    }
    
}

-(void) sendData:(NSData *)data{
    [self.audioDelegate recivePCMData:data];
}

-(void) startRecording{
    
    NSError *error = nil;
    NSLog(@"Start recording");
    //设置audio session
    BOOL rval = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if(!rval){
        NSLog(@"设置声音环境失败: %@", error);
        return;
    }
    rval = [[AVAudioSession sharedInstance]setActive:YES error:&error];
    if(!rval){
        NSLog(@"启动失败: %@", error);
        return;
    }
    
    //设置采样率...
    _recordFormat.mSampleRate = self.sampleRate;
    
    //初始化音频输入队列
    // inputBufferHandler是回调函数
    AudioQueueNewInput(&_recordFormat,
                       inputBufferHandler,
                       (__bridge void *)(self),
                       NULL,
                       NULL,
                       0,
                       &_audioQueue);
    
    //计算估算的缓存区大小 需要多少帧= 持续时间(秒)*采集率(帧/秒)
    //int frames = (int)ceil(self.bufferDurationSeconds * _recordFormat.mSampleRate);
    
    //设置缓存区大小 多少帧*每帧多少bytes
    //int bufferByteSize = frames * _recordFormat.mBytesPerFrame;
    
    //创建缓冲器(4个)
    for(int i = 0; i < kNumberAudioQueueBuffers; ++i){
        AudioQueueAllocateBuffer(_audioQueue,
                512*2*_recordFormat.mChannelsPerFrame, &_audioBuffers[i]);
        //将_audioBuffers[i]添加到队列中
        AudioQueueEnqueueBuffer(_audioQueue, _audioBuffers[i], 0, NULL);
    }
    
    AudioQueueStart(_audioQueue, NULL);
    
    _isRecording = YES;
}
-(void) stopRecording{
    NSLog(@"stop recording\n");
    if(self.isRecording){
        _isRecording = NO;
        
        AudioQueueStop(_audioQueue, true);
        
        for(int i = 0; i < kNumberAudioQueueBuffers; ++i){
            AudioQueueFreeBuffer(_audioQueue, _audioBuffers[i]);
        }
        
        AudioQueueDispose(_audioQueue, true);
        [[AVAudioSession sharedInstance]setActive:NO error:nil];
    }
}

@end
