//
//  ChatTableViewController.h
//  chatDemo
//
//  Created by 翯 on 2018-05-16.
//  Copyright © 2018 翯. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol containerDelegate <NSObject>
-(void) DismissWindow:(UIView*) target and:(id)weak_self;
-(void) touchJumpPad;
@end

@interface ChatTableViewController : UIViewController
@property(nonatomic, weak)id<containerDelegate> myDelegate;
@end
