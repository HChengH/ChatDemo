//
//  BubbleTableViewCell.h
//  chatDemo
//
//  Created by 翯 on 2018-05-16.
//  Copyright © 2018 翯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface BubbleTableViewCell : UITableViewCell{
    Message *msg;
}

@property (nonatomic, strong) NSString *msgText;
@property (nonatomic, assign) CGSize size;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuse andMsg:(Message *)msgG andWidth:(CGFloat)w;
-(void)updateMessage:(Message *)msg;

@end
