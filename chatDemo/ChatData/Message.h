//
//  Message.h
//  chatDemo
//
//  Created by 翯 on 2018-05-17.
//  Copyright © 2018 翯. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    OUTGOING,
    INCOMMING
}msgType;

@interface Message : NSObject
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) msgType type;
-(id)initWithMsg:(NSString *)msg andType:(msgType) type;
@end
