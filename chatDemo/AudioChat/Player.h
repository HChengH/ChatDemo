//
//  Player.h
//  Audio_Study
//
//  Created by 翯 on 2018-05-10.
//  Copyright © 2018 翯. All rights reserved.
//

// Use notifycation observe msg from server

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


#define kNumberAudioQueueBuffers 4 //队列缓冲个数
#define EVERY_READ_LENGTH 1000 //每次从文件读取的长度
// ????
#define MIN_SIZE_PER_FRAME 2048 //每帧最小数据长度
#define kDefaultSampleRate 48000.0   //定义采样率为8000

@interface Player : NSObject
{
    // 音频参数
    AudioStreamBasicDescription _recordFormat;
    //
    AudioQueueRef _audioQueue;
    //
    AudioQueueBufferRef _audioQueueBuffers[kNumberAudioQueueBuffers];
    BOOL _audioQueueBufferUsed[kNumberAudioQueueBuffers];
    //同步控制
    NSLock *synlock;
    Byte *pcmDataBuffer;
}

-(void) FakeData:(NSData *) pcmData;
-(void) pause;

@property (nonatomic, assign) BOOL isPlaying;
@end
