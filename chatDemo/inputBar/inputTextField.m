//
//  ContainerView.m
//  chatDemo
//
//  Created by 翯 on 2018-05-16.
//  Copyright © 2018 翯. All rights reserved.
//

#import "inputTextField.h"
@interface inputTextField()
@property (nonatomic, assign) int numLines;
@end

@implementation inputTextField

- (instancetype)init{
    if (self = [super init]){
        _numLines = 1;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
