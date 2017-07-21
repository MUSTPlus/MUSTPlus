//
//  macrodefine.h
//  QHSimpleFrame
//
//  Created by imqiuhang on 15/3/31.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//


#import "QHHead.h"


#ifndef macrodefine_h
#define macrodefine_h

//keyWindow,屏幕宽 屏幕高
#define KEY_WINDOW                [[UIApplication sharedApplication] keyWindow]
#define screenWidth               [[UIScreen mainScreen] bounds].size.width
#define screenHeight              [[UIScreen mainScreen] bounds].size.height

///RGB
#define QHRGBA(r, g, b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a]
#define QHRGB(r, g, b) QHRGBA(r,g,b,1)

///请使用 MSLog代替NSLog MSLog在发布的产品不会打印日志
#ifdef DEBUG
#define MSLog(fmt,...) NSLog((@"\n\n[行号]%d\n" "[函数名]%s\n" "[日志]"fmt"\n"),__LINE__,__FUNCTION__,##__VA_ARGS__);
#else
#define MSLog(fmt,...);
#endif


#define IOS_VERSION            [[[UIDevice currentDevice] systemVersion] floatValue]


#define IS_IPAD                (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


#define APPVERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]



#define customErrorDoMain @"imqiuhang_customErrorDoMain"

#define tabBarHeight 49.f

//>>>>>>>>>>>>>>>>>>>>>颜色,字体等公共属性

/*颜色*/

#define YMSViewBackgroundColor         [QHUtil colorWithHexString:@"f5f5f5"]

//app的文本标题颜色
#define YMSTitleColor                  [QHUtil colorWithHexString:@"333333"]

//通用的副标题颜色
#define YMSSubTitleLableColor          [QHUtil colorWithHexString:@"aaaaaa"]

//展位图统一的背景颜色
#define YMSPlaceHolderBgColor           [QHUtil colorWithHexString:@"#F5F5F5"]

//统一的列表线条颜色
#define YMSLineViewColor                [QHUtil colorWithHexString:@"#E8E8E8"]


//品牌色
#define YMSBrandColor                  [QHUtil colorWithHexString:@"ff807a"]

//导航栏的背景颜色
#define YMSNavBarTinkColor              [UIColor  whiteColor]

//导航栏的标题颜色
#define YMSNavTitleColor                [QHUtil colorWithHexString:@"333333"]
//状态栏
#define YMSStatusBarStyle              UIStatusBarStyleDefault

#define YMSTabBarBarTintColor          [UIColor  whiteColor]


/*字体*/

//#define defaultFont(s) [UIFont fontWithName:@"HYQiHei-DZS" size:s]

#define defaultFont(s) [UIFont systemFontOfSize:s]
#define systemFont(s)  [UIFont systemFontOfSize:s]

//>>>>>>>>>>>>>>>>>>>>>通知Name

//为了维护方便,请务必少使用通知，使用时名称务必按照规范书写
//Example
#define ExampleViewControllerDidDoSomethingNotify          @"eeee-xxx-cccc-000100"

#endif







