//
//  ContainerViewController.m
//  chatDemo
//
//  Created by 翯 on 2018-05-16.
//  Copyright © 2018 翯. All rights reserved.
//

#import "ContainerViewController.h"
#import "Masonry.h"
#import "ChatTableViewController.h"

@interface ContainerViewController ()<containerDelegate, FloatingWindowTouchDelegate>
@property (nonatomic, strong) UIButton *button;
@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
    
    _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _button.backgroundColor = [UIColor whiteColor];
    [_button setTitle:@"聊天" forState:UIControlStateNormal];
    [_button setTintColor:[UIColor blackColor]];
    [_button addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(100);
        make.centerX.centerY.equalTo(self.view);
    }];
    
    self.floatWindow = [[FloatingWindow alloc] initWithFrame:CGRectMake(100, 100, 76, 76) imageName:@"av_call"];
    [self.floatWindow makeKeyAndVisible];
    self.floatWindow.hidden = YES;
}

#pragma mark -Floating Window delegate methods
- (void)DismissWindow:(UIView*) target and:(id)weak_self{
    self.floatWindow.floatDelegate = weak_self;
    [self.floatWindow startWithTime:30 presentview:target inRect:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height-150, 76, 76)];
}

-(void)touchJumpPad{
    [self assistiveTocuhs];
}

-(void)assistiveTocuhs {
    self.floatWindow.windowLevel = UIWindowLevelStatusBar-1;
}

-(void) jump{
    ChatTableViewController *chatVC = [[ChatTableViewController alloc]init];
    chatVC.myDelegate = self;
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:chatVC];
    [navi setNavigationBarHidden:YES];
    [self presentViewController:navi animated:YES completion:^{
        [self.button removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
