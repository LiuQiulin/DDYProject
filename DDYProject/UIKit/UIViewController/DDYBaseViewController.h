//
//  DDYBaseViewController.h
//  NAToken
//
//  Created by LingTuan on 17/7/28.
//  Copyright © 2017年 NAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDYBaseViewController : UIViewController

@property (nonatomic, assign) BOOL navigationBarBottomLineHidden;

- (void)prepare;

- (void)buildUI;

/** 导航栏背景透明度设置 */
- (void)setNavigationBackgroundAlpha:(CGFloat)alpha;

/** leftButton */
- (void)showLeftBarBtnWithTitle:(NSString *)title img:(UIImage *)img;

/** defaultLeftButton */
- (void)showBackBarBtnDefault;

/** rightButton */
- (void)showRightBarBtnWithTitle:(NSString *)title img:(UIImage *)img;

/** leftButtonTouch */
- (void)leftBtnClick:(DDYButton *)button;

/** rightButtonTouch */
- (void)rightBtnClick:(DDYButton *)button;

@end
