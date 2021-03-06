//
//  DDYRadarView.m
//  DDYProject
//
//  Created by ShangHaiSheQuan on 15/12/19.
//  Copyright © 2015年 Starain. All rights reserved.
//

#import "DDYRadarView.h"
#import <QuartzCore/QuartzCore.h>

//----------------------- 点位头像视图 -----------------------//
@implementation DDYRadarPointView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [_image drawInRect:self.bounds];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

@end

//------------------------ 扇形指示器 ------------------------//
@interface DDYRadarIndicatorView ()
/** 半径 */
@property (nonatomic, assign) CGFloat radius;
/** 指示器开始颜色 */
@property (nonatomic, strong) UIColor *startColor;
/** 指示器结束颜色 */
@property (nonatomic, strong) UIColor *endColor;
/** 指示器角度 */
@property (nonatomic, assign) CGFloat angle;
/** 是否是否顺时针 */
@property (nonatomic, assign) BOOL clockwise;

@end

@implementation DDYRadarIndicatorView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // 画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 渐变色
    const CGFloat *startColorComponents = CGColorGetComponents(_startColor.CGColor);
    const CGFloat *endColorComponents = CGColorGetComponents(_endColor.CGColor);
    for (int i=0; i<_angle; i++) {
        CGFloat ratio = (_clockwise?(_angle-i):i)/_angle;
        CGFloat r = startColorComponents[0] - (startColorComponents[0]-endColorComponents[0])*ratio;
        CGFloat g = startColorComponents[1] - (startColorComponents[1]-endColorComponents[1])*ratio;
        CGFloat b = startColorComponents[2] - (startColorComponents[2]-endColorComponents[2])*ratio;
        CGFloat a = startColorComponents[3] - (startColorComponents[3]-endColorComponents[3])*ratio;
        
        // 画扇形
        CGContextSetFillColorWithColor(context, DDYColor(r, g, b, a).CGColor);
        CGContextSetLineWidth(context, 0);
        CGContextMoveToPoint(context, self.center.x, self.center.y);
        CGContextAddArc(context, self.center.x, self.center.y, _radius,  i*M_PI/180, (i + (_clockwise?-1:1))*M_PI/180, _clockwise);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

@end

//------------------------- 雷达视图 -------------------------//
@interface DDYRadarView ()

@property (nonatomic, strong) DDYRadarIndicatorView *indicatorView;

@property (nonatomic, strong) UIView *pointsView;

@end

@implementation DDYRadarView

+ (instancetype)radarView {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepare];
        [self addSubview:self.indicatorView];
    }
    return self;
}

- (void)prepare {
    _radius = self.ddy_w/2.-20;
    _circleNumber = 3;
    _circleColor = DDY_White;
    _indicatorStartColor = DDY_Blue;
    _indicatorEndColor = DDY_ClearColor;
    _indicatorClockwise = YES;
    _indicatorAngle = 360;
    _indicatorSpeed = 90;
    _backgroundImage = [UIImage imageWithColor:DDY_Gray size:DDYSCREENSIZE];
    _showSeparator = YES;
}

- (DDYRadarIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[DDYRadarIndicatorView alloc] initWithFrame:self.bounds];
        _indicatorView.backgroundColor = DDY_ClearColor;
    }
    return _indicatorView;
}

- (void)resetIndicatorView {
    _indicatorView.radius = _radius;
    _indicatorView.angle = _indicatorAngle;
    _indicatorView.clockwise = _indicatorClockwise;
    _indicatorView.startColor = _indicatorStartColor;
    _indicatorView.endColor = _indicatorEndColor;
}

- (UIView *)pointsView {
    if (!_pointsView) {
        _pointsView = [[UIView alloc] initWithFrame:self.bounds].viewBGColor(DDY_ClearColor);
        [self insertSubview:_pointsView aboveSubview:self.indicatorView];
    }
    return _pointsView;
}

- (void)drawCircle {
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i=0; i<_circleNumber; i++) {
        CGContextSetStrokeColorWithColor(context, _circleColor.CGColor);
        CGContextSetLineWidth(context, 1.);
        CGContextAddArc(context, self.center.x, self.center.y, _radius*(i+1)/_circleNumber, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)drawSeparator {
    // 绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _circleColor.CGColor);
    CGContextSetLineWidth(context, .7);
    CGFloat length1[] = {5, 5};
    CGContextSetLineDash(context, 0, length1, 2);
    
    for (int i=0; i<4; i++) {
        CGContextMoveToPoint(context, self.center.x+sinf(i*M_PI_4)*_radius, self.center.y-cosf(i*M_PI_4)*_radius);
        CGContextAddLineToPoint(context, self.center.x+sinf((i+4)*M_PI_4)*_radius, self.center.y-cosf((i+4)*M_PI_4)*_radius);
    }
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [_backgroundImage drawInRect:self.bounds];
    [self resetIndicatorView];
    [self drawCircle];
    if (_showSeparator) [self drawSeparator];
}

- (void)startScanAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:(_indicatorClockwise?1:-1) * M_PI * 2.];
    animation.duration = 360.f/_indicatorSpeed;
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.indicatorView.layer addAnimation:animation forKey:@"rotationAnimation"];
}

- (void)stopScanAnimation {
    [self.indicatorView.layer removeAnimationForKey:@"rotationAnimation"];
}

#pragma mark 刷新以展示数据
- (void)reloadData
{
    [self.pointsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ([self.dataSource respondsToSelector:@selector(numberOfPointInRadarView:)])
    {
        for (int index=0; index<MIN([self.dataSource numberOfPointInRadarView:self], 8); index++)
        {
            DDYRadarPointView *pointView;
            if ([self.dataSource respondsToSelector:@selector(radarView:viewForIndex:)])
            {
                pointView = [self.dataSource radarView:self viewForIndex:index];
            }
            else if ([self.dataSource respondsToSelector:@selector(radarView:imageForIndex:)])
            {
                if ([self.dataSource radarView:self imageForIndex:index]) {
                    pointView = [[DDYRadarPointView alloc] init];
                    pointView.image = [self.dataSource radarView:self imageForIndex:index];
                }
            }
            if (pointView) {
                pointView.ddy_size = CGSizeMake(40, 40);
                pointView.center = [self pointWithIndex:index];
                pointView.tag = 100+index;
                [pointView addTapTarget:self action:@selector(handleTopPointView:)];
                [self.pointsView addSubview:pointView];
                DDYBorderRadius(pointView, pointView.ddy_w/2., .7, DDY_White);
            }
        }
        
    }
}

#pragma mark 点位数组
- (CGPoint)pointWithIndex:(NSInteger)index {
    CGPoint points[8];
    CGFloat radiusBig = _radius;
    CGFloat radiusMid = ((_circleNumber-1)*_radius/_circleNumber);
    points[0] = CGPointMake(self.center.x+sinf(0*M_PI_4)*radiusBig, self.center.y-cosf(0*M_PI_4)*radiusBig);
    points[1] = CGPointMake(self.center.x+sinf(4*M_PI_4)*radiusBig, self.center.y-cosf(4*M_PI_4)*radiusBig);
    points[2] = CGPointMake(self.center.x+sinf(6*M_PI_4)*radiusBig, self.center.y-cosf(6*M_PI_4)*radiusBig);
    points[3] = CGPointMake(self.center.x+sinf(2*M_PI_4)*radiusBig, self.center.y-cosf(2*M_PI_4)*radiusBig);
    points[4] = CGPointMake(self.center.x+sinf(1*M_PI_4)*radiusMid, self.center.y-cosf(1*M_PI_4)*radiusMid);
    points[5] = CGPointMake(self.center.x+sinf(3*M_PI_4)*radiusMid, self.center.y-cosf(3*M_PI_4)*radiusMid);
    points[6] = CGPointMake(self.center.x+sinf(7*M_PI_4)*radiusMid, self.center.y-cosf(7*M_PI_4)*radiusMid);
    points[7] = CGPointMake(self.center.x+sinf(5*M_PI_4)*radiusMid, self.center.y-cosf(5*M_PI_4)*radiusMid);
    return points[index];
}

- (void)handleTopPointView:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(radarView:didSelectItemAtIndex:)]) {
        [self.delegate radarView:self didSelectItemAtIndex:gesture.view.tag-100];
    }
}

#pragma mark - setter
#pragma mark 同心圆半径
- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self setNeedsDisplay];
}

#pragma mark 同心圆个数
- (void)setCircleNumber:(NSInteger)circleNumber {
    _circleNumber = circleNumber;
    [self setNeedsDisplay];
}
#pragma mark 同心圆边框颜色
- (void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

#pragma mark 指示器开始颜色
- (void)setIndicatorStartColor:(UIColor *)indicatorStartColor {
    _indicatorStartColor = indicatorStartColor;
    [self setNeedsDisplay];
}

#pragma mark 指示器结束颜色
- (void)setIndicatorEndColor:(UIColor *)indicatorEndColor {
    _indicatorEndColor = indicatorEndColor;
    [self setNeedsDisplay];
}

#pragma mark 是否顺时针方向
- (void)setIndicatorClockwise:(BOOL)indicatorClockwise {
    _indicatorClockwise = indicatorClockwise;
    [self setNeedsDisplay];
}

#pragma mark 指示器角度大小
- (void)setIndicatorAngle:(CGFloat)indicatorAngle {
    _indicatorAngle = indicatorAngle;
    [self setNeedsDisplay];
}

#pragma mark 指示器旋转速度
- (void)setIndicatorSpeed:(CGFloat)indicatorSpeed {
    _indicatorSpeed = indicatorSpeed;
    [self setNeedsDisplay];
}

#pragma mark 视图背景图片
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self setNeedsDisplay];
}

#pragma mark 显示虚分割线
- (void)setShowSeparator:(BOOL)showSeparator {
    _showSeparator = showSeparator;
    [self setNeedsDisplay];
}

@end

/**
 http://blog.csdn.net/jeffasd/article/details/50512439
 
 fillMode的作用就是决定当前对象过了非active时间段的行为. 比如动画开始之前,动画结束之后。如果是一个动画CAAnimation,则需要将其removedOnCompletion设置为NO,要不然fillMode不起作用.
 
 下面来讲各个fillMode的意义
 kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
 kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
 kCAFillModeBackwards 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
 */
