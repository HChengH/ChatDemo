//
//  ChatInfoBar.m
//  chatDemo
//
//  Created by 翯 on 2018-05-23.
//  Copyright © 2018 翯. All rights reserved.
//

#import "ChatInfoBar.h"
#import "Masonry.h"

@interface ChatInfoBar()
@property (nonatomic, strong) UILabel *ChatName;
@property (nonatomic, strong) UIButton *disBut;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIButton *audioRoomInfoBut;
@end

@implementation ChatInfoBar

-(id)initWithFrame:(CGRect)frame andName:(NSString *)name{
    if(self = [super initWithFrame:frame]){
        _name = name;
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    }
    [self setup];
    return self;
}

-(void)setup{
    _ChatName = [[UILabel alloc]init];
    _ChatName.text = _name;
    _disBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_disBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_disBut setTitle:@"close" forState:UIControlStateNormal];
    [_disBut addTarget:self action:@selector(dismiss)
      forControlEvents:UIControlEventTouchUpInside];
    _audioRoomInfoBut = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_audioRoomInfoBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_audioRoomInfoBut setTitle:@"\\=.=/" forState:UIControlStateNormal];
    [_audioRoomInfoBut addTarget:self action:@selector(showAudioInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_ChatName];
    [self addSubview:_disBut];
    [self addSubview:_audioRoomInfoBut];
    
    [_ChatName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(10);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [_disBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self).offset(10);
    }];
    
    [_audioRoomInfoBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self).offset(10);
    }];
}

-(void)showAudioInfo{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DismissKeyboard" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showAudioInfo" object:nil];
}

-(void)dismiss{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DismissKeyboard" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissChatView" object:nil];
}

@end
