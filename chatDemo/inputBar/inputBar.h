//
//  inputBar.h
//  chatDemo
//
//  Created by 翯 on 2018-05-16.
//  Copyright © 2018 翯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chatData.h"

@interface inputBar : UIView
-(void) keyBoardDismiss;
-(void)setSource:(chatData *)source;
@end
