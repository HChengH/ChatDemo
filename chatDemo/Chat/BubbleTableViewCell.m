//
//  BubbleTableViewCell.m
//  chatDemo
//
//  Created by 翯 on 2018-05-16.
//  Copyright © 2018 翯. All rights reserved.
//

#import "BubbleTableViewCell.h"
#import "Masonry.h"

#define gap 5

@interface BubbleTableViewCell()
@property (nonatomic, strong) UILabel *textView;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIView *background;
@end

@implementation BubbleTableViewCell

CGFloat width = 0;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuse andMsg:(Message *)msgG andWidth:(CGFloat)w{
    if(self = [super initWithStyle:style reuseIdentifier:reuse]){
        self.msgText = [[NSString alloc]init];
        //_msgText = msgG.message;
    }
    //msg = msgG;
    
    width = w;
    
    [self setup];
    return self;
}

-(void)setup{
    _textView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _background.backgroundColor = [UIColor colorWithRed:170/255.0 green:207/255.0 blue:82/255.0 alpha:1];
    _background.layer.cornerRadius = 7.f;
    _background.layer.masksToBounds = YES;
    
    _image = [[UIImageView alloc]init];
    _image.backgroundColor = [UIColor grayColor];
    
    //_textView.text = self.msgText;
    
    [self addSubview:self.background];
    [_background addSubview:self.textView];
    [self addSubview:self.image];
    
    _textView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
    _textView.textColor = [UIColor blackColor];
    _textView.lineBreakMode = NSLineBreakByWordWrapping;
    [_textView sizeToFit];
    _textView.numberOfLines = 0;
    [_textView setFont:[UIFont systemFontOfSize:18]];
}

-(void) myUpdateConstraints{
    _textView.font = [UIFont systemFontOfSize:18];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc]init];
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:_textView.font, NSParagraphStyleAttributeName:ps.copy};
    CGSize size = [_textView.text boundingRectWithSize:CGSizeMake(ceilf((width/3)*2), 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ceilf(size.width));
        make.height.mas_equalTo(ceilf(size.height));
        
        if(![self.msgText containsString:@"\n"] && size.height > 21.5){
            make.top.equalTo(self).offset(10);
        }else{
            make.centerY.equalTo(self);
        }
        
        switch (self->msg.type) {
            case INCOMMING:
                make.left.equalTo(self->_image.mas_right).offset(15);
                break;
                
            case OUTGOING:
                make.right.equalTo(self->_image.mas_left).offset(-15);
                break;
                
            default:
                break;
        }
    }];
    
    [_image mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        switch (self->msg.type) {
            case INCOMMING:
                make.left.equalTo(self).offset(gap);
                break;
                
            case OUTGOING:
                make.right.equalTo(self).offset(-gap);
                break;
                
            default:
                break;
        }
        make.top.equalTo(self).offset(5);
    }];
    
    [_background mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_textView).offset(gap);
        make.left.equalTo(self->_textView).offset(-gap);
        make.top.equalTo(self->_textView).offset(-gap);
        make.bottom.equalTo(self->_textView).offset(gap);
    }];
}

-(void)updateMessage:(Message *)msgG{
    msg = msgG;
    self.msgText = msgG.message;
    _textView.text = self.msgText;
    _textView.numberOfLines = 0;
    [self myUpdateConstraints];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
