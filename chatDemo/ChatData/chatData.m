//
//  chatData.m
//  chatDemo
//
//  Created by 翯 on 2018-05-17.
//  Copyright © 2018 翯. All rights reserved.
//

#import "chatData.h"
#import "Message.h"

@implementation chatData

-(id)init{
    if(self = [super init]){
        _chatData = [[NSMutableArray alloc]init];
    }
    return self;
}

-(Message *)msgFactory:(NSString *)msg type:(msgType)t{
    Message *newMsg = [[Message alloc]initWithMsg:msg andType:t];
    return newMsg;
}

-(void)sendMessage:(NSString *)msg{
    [_chatData addObject:[self msgFactory:msg type:OUTGOING]];
    //[_chatData addObject:[self msgFactory:msg type:INCOMMING]];
    [self.dataDelegate reciveMsgFromChatData:msg];
    [self NotifyObservers];
}
-(void)resiveMessage:(NSString *)msg{
    [_chatData addObject:[self msgFactory:msg type:INCOMMING]];
    [self NotifyObservers];
}

-(void)NotifyObservers{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MsgUpdate" object:nil];
}
@end
