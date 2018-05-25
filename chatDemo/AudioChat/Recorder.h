//
//  Recorder.h
//  Audio_Study
//
//  Created by 翯 on 2018-05-10.
//  Copyright © 2018 翯. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define kNumberAudioQueueBuffers 4  //定义了四个缓冲区
#define kDefaultBufferDurationSeconds .5  //调整这个值使得录音的缓冲区大小为2048bytes
#define kDefaultSampleRate 44100.0   //定义采样率为8000

@class Recorder;

@protocol audioChatDelegate <NSObject>
//悬浮窗点击事件
-(void)recivePCMData:(NSData *) data;
@end

@interface Recorder : NSObject
{
    AudioQueueRef _audioQueue;
    AudioStreamBasicDescription _recordFormat;
    
    AudioQueueBufferRef _audioBuffers[kNumberAudioQueueBuffers];
}

@property (nonatomic, assign) BOOL isRecording;
@property (atomic, assign) NSUInteger sampleRate;
@property (atomic, assign) double bufferDurationSeconds;
@property (nonatomic, weak)id<audioChatDelegate> audioDelegate;


-(void) startRecording;
-(void) stopRecording;


@end
