//
//  ChatTableViewController.m
//  chatDemo
//
//  Created by 翯 on 2018-05-16.
//  Copyright © 2018 翯. All rights reserved.
//

#import "ChatTableViewController.h"
#import "BubbleTableViewCell.h"
#import "inputBar.h"
#import "Masonry.h"
#import "chatData.h"
#import "Message.h"
#import "FloatingWindow.h"
#import "AppDelegate.h"
#import "ChatInfoBar.h"

#define maxWidth 

@interface ChatTableViewController ()<UITableViewDelegate,UITableViewDataSource,FloatingWindowTouchDelegate>

@property (nonatomic, strong) chatData *dataSource;
@property (nonatomic, strong) ChatInfoBar *topBar;
@property (nonatomic, strong) UITableView *tableView;
@property (atomic, strong) inputBar *textView;
@end

CGFloat mwidth;

@implementation ChatTableViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mwidth = ceilf((self.view.frame.size.width/3)*2);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"MsgUpdate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeChatView) name:@"dismissChatView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapAction:) name:@"DismissKeyboard" object:nil];
    
    UITapGestureRecognizer  * tap = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self
                                     action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    
    self.dataSource = [[chatData alloc]init];
    
    [self createSubView];
}

-(void)createSubView{
    _textView = [[inputBar alloc]init];
    [self.view addSubview:_textView];
    [_textView setSource:_dataSource];
    
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    
    [self.view addSubview:_tableView];
    
    _textView.frame = CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40);
    
    _tableView.frame = CGRectMake(0, 0+64, self.view.frame.size.width, self.view.frame.size.height - _textView.frame.size.height-64);
    
    _topBar = [[ChatInfoBar alloc]initWithFrame:
               CGRectMake(0, 0, 0, 0)andName:@"igames.king"];
    [self.view addSubview:_topBar];
    
    [_topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
}

#pragma mark -close chat view
-(void) closeChatView{
    [self Dismiss];
}

#pragma mark -Floating Window delegate methods
- (void)Dismiss{
    AppDelegate *deleage = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    __weak typeof (self) weakSelf = self;
    deleage.floatWindow.floatDelegate = weakSelf;
    
    [deleage.floatWindow startWithTime:30 presentview:self.view inRect:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height-150, 76, 76)];
    
    [self.navigationController dismissViewControllerAnimated:NO completion:^{

    }];
}

-(void)assistiveTocuhs {
    AppDelegate *deleage = (AppDelegate *)[UIApplication sharedApplication].delegate;
    deleage.floatWindow.windowLevel = UIWindowLevelStatusBar-1;
}

#pragma mark -Dismiss keyboard when touch anywhere else
- (void)tapAction:(id)sender{
    [_textView keyBoardDismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)autoWithAndHeight:(NSString *)string {
    UIFont *font = [UIFont systemFontOfSize:18];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc]init];
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:ps.copy};
    CGSize size = [string boundingRectWithSize:CGSizeMake(mwidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return MAX(ceilf(size.height+20), 50) ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource.chatData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self autoWithAndHeight: ((Message *)_dataSource.chatData[indexPath.row]).message];
}

-(void)updateData{
    self.tableView.hidden = YES;
    [self.tableView reloadData];
    if([self.dataSource.chatData count] > 1){
        // 动画之前先滚动到倒数第二个消息
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataSource.chatData count] - 2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    self.tableView.hidden = NO;
    // 添加向上顶出最后一个消息的动画
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataSource.chatData count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *msg = [self.dataSource.chatData objectAtIndex:indexPath.row];
    BubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgCellReuse"];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(!cell){
        cell = [[BubbleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MsgCellReuse" andMsg:msg andWidth:self.view.frame.size.width];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    };
    [cell updateMessage:msg];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_textView keyBoardDismiss];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //需要拖动cell时隐藏键盘在此处理
    [_textView keyBoardDismiss];
}

#pragma mark --键盘弹起收回动画
-(void)keyboardWillChangeFrame:(NSNotification *)notify{
    NSDictionary *info = notify.userInfo;
    //动画持续时间
    CGFloat anumationDuration = [info[UIKeyboardAnimationDurationUserInfoKey]
                                 floatValue];
    //键盘目标位置
    CGRect keyboardAimFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self keybaordAnimationWithDuration:anumationDuration keyboardOriginY:keyboardAimFrame.origin.y];
}


// keyboardOriginY: is the target Y coordinate when keyboard poped up
- (void)keybaordAnimationWithDuration:(CGFloat)duration keyboardOriginY:(CGFloat)keyboardOriginY{
    //作为视图的键盘，弹出动画也是UIViewAnimationOptionCurveEaseIn的方式
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        //text field
        CGPoint textFieldOrigin = self.textView.frame.origin;
        CGSize  textFieldSize = self.textView.frame.size;
        CGRect  textFieldAimFrame = CGRectMake(textFieldOrigin.x, keyboardOriginY - textFieldSize.height, textFieldSize.width, textFieldSize.height);
        self.textView.frame = textFieldAimFrame;
        
        //table view
        CGPoint tableViewOrigin = self.tableView.frame.origin;
        CGSize  tableViewSize   = self.tableView.frame.size;
        CGRect  tableViewAimFrame = CGRectMake(tableViewOrigin.x, tableViewOrigin.y, tableViewSize.width, textFieldAimFrame.origin.y - tableViewOrigin.y);
        self.tableView.frame = tableViewAimFrame;
        
        //刷新一下当前tableView，为了获取准确的contentHeight
        [self->_tableView layoutIfNeeded];
        CGFloat contentHeight = self->_tableView.contentSize.height;
        
        //显示最后一个cell
        if (contentHeight > tableViewAimFrame.size.height){
            [self->_tableView setContentOffset:CGPointMake(0, contentHeight-tableViewAimFrame.size.height)];
        }
    } completion:^(BOOL finished) {
    }];
}
@end
