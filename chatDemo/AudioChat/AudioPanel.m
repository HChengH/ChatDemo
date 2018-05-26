//
//  AudioPanel.m
//  chatDemo
//
//  Created by 翯 on 2018-05-25.
//  Copyright © 2018 翯. All rights reserved.
//

#import "AudioPanel.h"
#import "Masonry.h"
#import "Recorder.h"

@interface AudioPanel()
{
    @private
    BOOL _inRoom;
}
@property (nonatomic, strong) UIButton *userImg;
@property (nonatomic, strong) UIButton *setting;
@property (nonatomic, strong) UIButton *join;
@property (nonatomic, strong) Recorder *rec;

@end

@implementation AudioPanel

-(id) initWithFrame:(CGRect) frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:90/255.f green:200/255.f blue:250/255.f alpha:1];
        _inRoom = NO;
        _rec = [[Recorder alloc]init];
    }
    [self loadSubViews];
    return self;
}

-(void)loadSubViews{
    _userImg = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _userImg.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:_userImg];
    
    _setting = [[UIButton alloc]init];
    [_setting setTitle:@"设置" forState:UIControlStateNormal];
    _setting.titleLabel.font = [UIFont systemFontOfSize:14];
    [_setting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_setting];
    
    _join = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _join.layer.cornerRadius = 5.f;
    _join.layer.masksToBounds = YES;
    _join.backgroundColor = [UIColor colorWithRed:76/255.f green:217/255.f blue:100/255.f alpha:1];
    [_join setTitle:@"加入聊天" forState:UIControlStateNormal];
    _join.titleLabel.font = [UIFont systemFontOfSize:18];
    [_join addTarget:self action:@selector(joinRoom) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_join];
    
    [_userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(100);
        make.width.height.mas_equalTo(70);
    }];
    
    _userImg.layer.cornerRadius = 35;
    _userImg.layer.masksToBounds = YES;
    
    [_setting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(10);
    }];
    
    [_join mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(150);
        make.bottom.equalTo(self->_setting.mas_top).offset(-20);
        
    }];
}

-(void)joinRoom{
    _inRoom = !_inRoom;
    if(_inRoom){
        [UIView animateWithDuration:0.2 animations:^{
            self->_join.backgroundColor = [UIColor colorWithRed:255/255.f
                                                    green:59/255.f
                                                    blue:48/255.f alpha:1];
            [self->_join setTitle:@"退出聊天" forState:UIControlStateNormal];
        }completion:^(BOOL finished) {
            [self->_rec startRecording];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self->_join.backgroundColor = [UIColor colorWithRed:76/255.f
                                                    green:217/255.f
                                                    blue:100/255.f alpha:1];
            [self->_join setTitle:@"加入聊天" forState:UIControlStateNormal];
        }completion:^(BOOL finished) {
            [self->_rec stopRecording];
        }];
    }
}

@end
