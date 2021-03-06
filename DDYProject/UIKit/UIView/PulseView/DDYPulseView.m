//
//  DDYPulseView.m
//  DDYProject
//
//  Created by LingTuan on 17/10/12.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYPulseView.h"

//------------------------ 圆形视图 ------------------------//
@interface DDYPulseCircleView ()
/** 填充颜色 */
@property (nonatomic, strong) UIColor *fillColor;
/** 线条颜色 */
@property (nonatomic, strong) UIColor *strokeColor;
/** 初始最小半径 */
@property (nonatomic, assign) CGFloat minRadius;

@end

@implementation DDYPulseCircleView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    CGContextAddArc(context, self.center.x, self.center.y, _minRadius, 0, 2*M_PI, 0);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
}

@end

//------------------------ 脉冲视图 ------------------------//
@interface DDYPulseView ()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation DDYPulseView

+ (instancetype)pulseView {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepare];
    }
    return self;
}

- (void)prepare {
    _fillColor = [UIColor colorWithRed:23/255.0 green:1.0 blue:1.0 alpha:1.0];
    _strokeColor = [UIColor colorWithRed:23/255.0 green:1.0 blue:1.0 alpha:1.0];
    _minRadius = 30;
}

#pragma mark 开启定时器 开始动画
- (void)startAnimation {
    [self stopAnimation];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(radarAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark 结束动画
- (void)stopAnimation {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark 扫描动画
- (void)radarAnimation
{
    DDYPulseCircleView *circleView = [[DDYPulseCircleView alloc] initWithFrame:self.bounds];
    circleView.backgroundColor = DDY_ClearColor;
    circleView.fillColor = _fillColor;
    circleView.strokeColor = _strokeColor;
    circleView.minRadius = _minRadius;
    [self addSubview:circleView];
    
    [UIView animateWithDuration:3 animations:^{
        circleView.transform = CGAffineTransformScale(circleView.transform, DDYSCREENW/2/30, DDYSCREENW/2/30);
        circleView.alpha = 0;
    } completion:^(BOOL finished) {
        [circleView removeFromSuperview];
    }];
}

#pragma mark - setter
#pragma mark 填充色
- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self startAnimation];
}

#pragma mark 同心圆线条颜色
- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self startAnimation];
}

#pragma mark 最小圆半径
- (void)setMinRadius:(CGFloat)minRadius {
    _minRadius = minRadius;
    [self startAnimation];
}

- (void)dealloc {
    [self stopAnimation];
}

@end
