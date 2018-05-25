//
//  inputBar.m
//  chatDemo
//
//  Created by 翯 on 2018-05-16.
//  Copyright © 2018 翯. All rights reserved.
//

#import "inputBar.h"
#import "inputTextField.h"
#import "Masonry.h"

#define buttonWidth 50;
#define buttonHeight 30;
#define space 10;

@interface inputBar() <UITextViewDelegate>

@property inputTextField *textField;
@property UIButton *send;
@property UIButton *util;
@property UIButton *emoji;
@property chatData *datasource;

@end

@implementation inputBar

-(id)init{
    if(self = [super init]){
        self.backgroundColor = [UIColor blueColor];
    }
    [self createSubView];
    return self;
}

-(void) createSubView{
    self.send  = [[UIButton alloc]init];
    [_send setTitle:@"发送" forState:UIControlStateNormal];
    _send.backgroundColor = [UIColor whiteColor];
    //_send.tintColor = [UIColor whiteColor];
    [_send setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_send addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    _send.enabled = NO;
    
    self.util = [[UIButton alloc]init];
    _util.backgroundColor = [UIColor whiteColor];
    _util.tintColor = [UIColor blackColor];
    _util.layer.cornerRadius = 15.f;
    _util.clipsToBounds = YES;
    
    self.emoji = [[UIButton alloc]init];
    _emoji.backgroundColor = [UIColor whiteColor];
    _emoji.tintColor = [UIColor blackColor];
    _emoji.layer.cornerRadius = 15.f;
    _emoji.clipsToBounds = YES;
    
    self.textField = [[inputTextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.delegate = self;
    
    [self addSubview:_send];
    [self addSubview:_util];
    [self addSubview:_emoji];
    [self addSubview:_textField];
    
    [_send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(30);
    }];
    
    [_util mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [_emoji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_send.mas_left).offset(-5);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];

    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_util.mas_right).offset(10);
        make.right.equalTo(self->_emoji.mas_left).offset(-10);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(30);
    }];
}

//-(float)heightForTextView: (UITextView *)textView WithText:(NSString *) strText{
//    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
//    CGRect size = [strText boundingRectWithSize:constraint
//                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
//                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
//                                        context:nil];
//    float textHeight = ceilf(size.size.height+13);
//    return textHeight;
//}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
//replacementText:(NSString *)text{
//    CGRect frame = textView.frame;
//    CGRect parFrame = self.frame;
//    float height;
//    if([text isEqual:@""]){
//        if(![textView.text isEqualToString:@""]){
//            height = [self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length]-1]];
//        }else{
//            height = [self heightForTextView:textView WithText:textView.text];
//        }
//    }else{
//        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@", textView.text, text]];
//    }
//    float diff = frame.size.height - height;
//    frame.size.height = height;
//    parFrame.size.height += diff;
//
//    [UIView animateWithDuration:0.5 animations:^{
//        textView.frame = frame;
//        self.frame = parFrame;
//    } completion:^(BOOL finished) {
//        [self->_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self->_util.mas_right).offset(10);
//            make.right.equalTo(self->_emoji.mas_left).offset(-10);
//            make.centerY.equalTo(self);
//            make.height.mas_equalTo(height);
//        }];
//    }];
//    return YES;
//}

-(void)setSource:(chatData *)source{
    _datasource = source;
}

- (void)textViewDidChange:(UITextView *)textView{
    if(![[_textField text]isEqualToString:@""]){
        _send.enabled = YES;
    }else{
        _send.enabled = NO;
    }
}

-(void) sendMsg{
    NSString *msg = [_textField text];
    [self.datasource sendMessage:msg];
    
    _textField.text = @"";
    _send.enabled = NO;
}

-(void) keyBoardDismiss{
    [_textField resignFirstResponder];
}
@end
