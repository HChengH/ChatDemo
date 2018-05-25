//
//  chatData.h
//  chatDemo
//
//  Created by 翯 on 2018-05-17.
//  Copyright © 2018 翯. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol sendTextMsgDelegate <NSObject>
-(void)reciveMsgFromChatData:(NSString *)msg;
@end

@interface chatData : NSObject

@property (nonatomic, strong) NSMutableArray *chatData;
@property (nonatomic, weak) id<sendTextMsgDelegate> dataDelegate;

-(void)sendMessage:(NSString *)msg;
-(void)resiveMessage:(NSString *)msg;
-(void)NotifyObservers;

@end
