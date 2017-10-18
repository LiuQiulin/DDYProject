//
//  DDYMacroTool.h
//  DDYProject
//
//  Created by starain on 15/8/8.
//  Copyright © 2015年 Starain. All rights reserved.
//

////////////////////////// 宏定义 ////////////////////////////

/** 需要横屏或者竖屏，获取屏幕宽度与高度 */
#define DDYSCREENW [UIScreen mainScreen].bounds.size.width
#define DDYSCREENH [UIScreen mainScreen].bounds.size.height
#define DDYNAVBARH self.navigationController.navigationBar.ddy_h
#define DDYSCREENBOUNDS [UIScreen mainScreen].bounds
#define DDYSCREENSIZE [UIScreen mainScreen].bounds.size

/** 根据比例改变不同尺寸上数值 */
#define DDYKW(R) R*(DDYSCREENW)/375
#define DDYKH(R) R*(DDYSCREENH)/667

/** 自定义颜色和随机颜色 */
#define DDYColor(r,g,b,a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]
#define DDYRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define DDYRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0] 
#define DDYBackColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]
#define APP_MAIN_COLOR DDYRGBA(63, 183, 198, 1)
// 深黑
#define DDY_Big_Black [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]
// 中黑
#define DDY_Mid_Black [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0]
// 浅黑
#define DDY_Small_Black [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0]

// 系统黑色 0.0 white
#define DDY_Black [UIColor blackColor]
// 系统白色 1.0 white
#define DDY_White [UIColor whiteColor]
// 系统浅灰 0.667 white
#define DDY_LightGray [UIColor lightGrayColor]
// 系统深灰 0.333 white
#define DDY_DarkGray [UIColor darkGrayColor]
// 系统灰色 0.5 white
#define DDY_Gray [UIColor grayColor]
// 系统红色 1.0, 0.0, 0.0 RGB
#define DDY_Red [UIColor redColor]
// 系统绿色 0.0, 1.0, 0.0 RGB
#define DDY_Green [UIColor greenColor]
// 系统蓝色 0.0, 0.0, 1.0 RGB
#define DDY_Blue [UIColor blueColor]
// 系统无色 0.0 white, 0.0 alpha
#define DDY_ClearColor [UIColor clearColor]


/** 字体 */
#define DDYFont(f) [UIFont systemFontOfSize:(f)]
#define DDYBDFont(f) [UIFont boldSystemFontOfSize:(f)]

/** 本地存储和通知中心 */
#define DDYUserDefaults [NSUserDefaults standardUserDefaults]
#define DDYUserDefaultsGet(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define DDYUserDefaultsSet(objt, key) [[NSUserDefaults standardUserDefaults] setObject:objt forKey:key];

#define DDYNotificationCenter [NSNotificationCenter defaultCenter]

/** 排序规则 */
#define DDYCollation [UILocalizedIndexedCollation currentCollation]
/** 文件管理器 */
#define DDYFileManager [NSFileManager defaultManager]

/** 圆角和边框 */
#define DDYBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

/** 沙盒路径:temp,Document,Cache */
#define DDYPathTemp NSTemporaryDirectory()
#define DDYPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define DDYPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]


/** 获取系统版本 */
#define IOS_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_8_LATER  (IOS_SYS_VERSION >= 8.0)
#define IOS_9_LATER  (IOS_SYS_VERSION >= 9.0)
#define IOS_10_LATER (IOS_SYS_VERSION >= 10.0)

/** 获取当前语言 */
#define DDYCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
/** 国际化 */
#define DDYLocalStr(key)  [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:nil]
#define DDYLocalStrFromTable(key, tbl)  [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:(tbl)]


/**  常数 */
#define DDYPI 3.14159265358979323846


// 定义这个常量,就可以在使用Masonry不必总带着前缀 `mas_`:
#define MAS_SHORTHAND
// 定义这个常量,以支持在 Masonry 语法中自动将基本类型转换为 object 类型:
#define MAS_SHORTHAND_GLOBALS
// 之后才 #import "Masonry.h"

// 字符串格式化
#define DDYStrFormat(s,...) [NSString stringWithFormat:s,##__VA_ARGS__]
// Rect
#define DDYRect(x,y,w,h) CGRectMake(x,y,w,h)
// size
#define DDYSize(w,h) CGSizeMake(w,h)
// point
#define DDYPoint(x,y) CGPointMake(x,y)
// URLWithStr
#define DDYURLStr(str) [NSURL URLWithString:str]

// 处于开发阶段
#ifdef DEBUG
#define DDYLog(...) NSLog(__VA_ARGS__)
#define DDYInfoLog(fmt, ...) NSLog((@"\n[fileName:%s]\n[methodName:%s]\n[lineNumber:%d]\n" fmt),__FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
// 处于发布阶段
#else
#define DDYLog(...)
#define DDYInfoLog(...)
#endif




