//
//  Message.m
//  chatDemo
//
//  Created by 翯 on 2018-05-17.
//  Copyright © 2018 翯. All rights reserved.
//

#import "Message.h"

@implementation Message

-(id)initWithMsg:(NSString *)msg andType:(msgType) t{
    if(self = [super init]){
        _message = msg;
        _type = t;
    }
    return self;
}
@end
