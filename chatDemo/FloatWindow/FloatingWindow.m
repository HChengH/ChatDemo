//
//  FloatingWindow.m
//  chatDemo
//
//  Created by 翯 on 2018-05-22.
//  Copyright © 2018 翯. All rights reserved.
//

//引用网上开源 demo 代码

#import "FloatingWindow.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAAnimation.h>
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height


static const float timeSplit = 1.f / 3.f;
@interface FloatingWindow ()
@property (nonatomic ,strong) UILabel *timeLable;
@property (nonatomic ,copy) NSString *imageNameString;
@property (nonatomic ,strong) UIView *presentView;
@property (nonatomic ,strong) CAAnimation *samllAnimation;
@property (nonatomic ,assign) BOOL isExit;
@property (assign, nonatomic) BOOL timeStart;
@end

@implementation FloatingWindow
{
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame imageName:(NSString *)name
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert + 1;
        [self makeKeyAndVisible];
        _imageView = [[UIImageView alloc]initWithFrame:(CGRect){0, 0,frame.size.width, frame.size.height}];
        _imageView.image = [UIImage imageNamed:name];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.layer.cornerRadius = _imageView.frame.size.width/2;
        _imageView.layer.masksToBounds = YES;
        _imageView.alpha = 1.0;
        self.imageNameString = name;
        
        [self addSubview: _imageView];
        
        //添加点击的手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tap];
        self.hidden = YES;
    }
    return self;
}

#pragma mark--- 开始和结束
- (void)startWithTime:(NSInteger) time presentview:(UIView *)presentView inRect:(CGRect) rect{
    self.hidden = NO;
    _imageView.hidden = YES;
    self.timeLable.hidden = YES;
    self.startFrame = rect;
    [self circleSmallerWithView:presentView];
    self.presentView = presentView;
}

- (void)close {
    self.hidden = YES;
    
    self.presentView = nil;
    self.showImageView = nil;
    self.showImage = nil;
}

#pragma mark ---进去和出去动画
- (void)makeIntoAnimation {
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.image = self.showImage;
    _imageView.hidden = YES;
    self.showImageView = showImageView;
    self.frame = self.startFrame;
    showImageView.frame = CGRectMake(0, 0, self.startFrame.size.width,self.startFrame.size.height);
    [self addSubview:showImageView];
    self.frame = self.startFrame;
    showImageView.hidden = YES;
    _imageView.hidden = NO;
}

- (void)makeOuttoAnimation {
    self.showImageView.hidden = NO;
    _imageView.hidden = YES;
    self.timeLable.hidden = YES;
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = self.startFrame;
        self.showImageView.frame = CGRectMake(0, 0, self.startFrame.size.width, self.startFrame.size.height);
    } completion:^(BOOL finished) {
        self.showImageView.hidden = YES;
        [self circleBigger];
        
    }];
}


/**
 * 动画开始时
 */
- (void)animationDidStart:(CAAnimation *)theAnimation
{
    
}

/**
 * 动画结束时
 */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (self.isExit) {
        self.isExit = NO;
        self.presentView.layer.mask = nil;
        [self.floatDelegate assistiveTocuhs];
    } else {
        [self clipcircleImageFromView:self.presentView inRect:self.startFrame];
        [self.presentView removeFromSuperview];
        [self makeIntoAnimation];
        
    }
}

- (void)circleSmallerWithView:(UIView *)view {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGRect startFrame = self.startFrame;
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:startFrame];
    CGFloat radius = [UIScreen mainScreen].bounds.size.height - 100;
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(startFrame, -radius, -radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskStartBP.CGPath;
    maskLayer.backgroundColor = (__bridge CGColorRef )([UIColor whiteColor]);
    view.layer.mask = maskLayer;
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskFinalBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskStartBP.CGPath));
    maskLayerAnimation.duration = 0.5f;
    maskLayerAnimation.delegate = self;
    self.samllAnimation = maskLayerAnimation;
    //    maskLayerAnimation.fillMode = kCAFillModeForwards;
    maskLayerAnimation.removedOnCompletion = NO;
    [self addSubview:view];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}



- (void)circleBigger {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self addSubview:self.presentView];
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:self.startFrame];
    CGFloat radius = [UIScreen mainScreen].bounds.size.height - 100;
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.startFrame, -radius, -radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath;
    maskLayer.backgroundColor = (__bridge CGColorRef)([UIColor whiteColor]);
    self.presentView.layer.mask = maskLayer;
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = 0.5f;
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
}

#pragma mark -触摸事件监听
- (void)click:(UITapGestureRecognizer*)t
{
    self.isExit = YES;
    [self makeOuttoAnimation];
    
}
#pragma mark -裁剪库


- (UIImage *)imageFromView:(UIView *) theView
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(theView.frame),
                                                      CGRectGetHeight(theView.frame)), NO, 1);
    
    [theView drawViewHierarchyInRect:CGRectMake(0,0,
                                                CGRectGetWidth(theView.frame),
                                                CGRectGetHeight(theView.frame))
                  afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}



-( UIImage *)getEllipseImageWithImage:(UIImage *)originImage size:(CGSize) size frame:(CGRect) rect
{
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextFillPath(UIGraphicsGetCurrentContext());
    CGRect clip = rect;
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:clip];
    [clipPath addClip];
    [originImage drawAtPoint:CGPointMake(0, 0)];
    UIImage *image;
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)clipcircleImageFromView:(UIView *)view inRect:(CGRect)frame {
    UIImage *image = [self imageFromView:view];
    UIImage *secondImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], frame)];
    UIImage *thirdimage = [self getEllipseImageWithImage:secondImage size:frame.size frame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.startFrame = frame;
    self.showImage = thirdimage;
    return thirdimage;
}


@end
