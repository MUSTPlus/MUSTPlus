/*
 id = {'1000':get_campus_area,'1001':upload_campus_area,'1002':commit,'1005':auth_account,'1008':get_timetable,'1009':get_borrowbook,'1010':search_book,
 '1011':get_grade,'1013':sign_class,'1014':get_classcontent,'1015':pulldown_schoolnews,'1016':pullup_schoolnews,'1017':del_schoolnews,
 '1018':pulldown_messagecircle,'1019':pullup_messagecircle,'1020':del_messagecircle,'1021':send_message,'1022':send_comment,'1023':del_comment,
 '1024':like_message,'1025':delete_message,'1026':delete_comment,'1027':change_face,'1028':change_nickname,'1029':change_vip,'1030':change_signtext,
 '1031':change_backgroundimage,'1032':get_userinfo}
 */


///  APP KEY
#define UIKitLocalizedString(key) [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] localizedStringForKey:key value:@"" table:nil]
#import "JPUSHService.h"
#import "Alert.h"
#import "MTA.h"
#import "HeiHei.h"
#import "NSString+AES.h"
#define APP_KEY_WEIXIN            @""

#define APP_KEY_QQ                @""

#define APP_KEY_WEIBO             @""

#define APP_KEY_WEIBO_RedirectURL @"http://www.sina.com"

///  分享图片
#define SHARE_IMG [UIImage imageNamed:@"logo.jpg"]

#define SHARE_IMG_COMPRESSION_QUALITY 0.5


// 宽度
#ifndef BasicHead
#define  Width                             [UIScreen mainScreen].bounds.size.width

// 高度
#define  Height                            [UIScreen mainScreen].bounds.size.height

// 状态栏高度
#define  StatusBarHeight                   20.f
#define NavBarHeight StatusBarHeight+44
// 导航栏高度
#define  NavigationBarHeight               44.f

#define  LineSpace                         6
// 标签栏高度
#define  TabbarHeight                      49.f

// 状态栏高度 + 导航栏高度
#define  StatusBarAndNavigationBarHeight   (20.f + 44.f)

// 3.设置cell的边框宽度
#define kCellBorderWidth 10
// 设置cell的间距
#define kCellMargin 10
// 设置tableView的边框宽度
#define kTableBorderWidth 2
// 设置button的边框宽度
#define kButtonBorderWidth 10
//设置操作条高度
#define kStatusDockHeight 40
//文字左边间距
#define kTitleLeftEdgeInsets 10
//显示最新数量按钮高度
#define kShowStatusCountHeight 35
#define DEBUG 1
#define kScreenNameFont [UIFont systemFontOfSize:16]
#define kTimeFont [UIFont systemFontOfSize:13]
#define kSourceFont kTimeFont
#define kTextFont [UIFont systemFontOfSize:16]
#define kDetailTextFont [UIFont systemFontOfSize:17]


#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define X_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define X_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#define  iPhone4_4s   (Width == 320.f && Height == 480.f ? YES : NO)
#define  iPhone5_5s   (Width == 320.f && Height == 568.f ? YES : NO)
#define  iPhone6      (Width == 375.f && Height == 667.f ? YES : NO)
#define  iPhone6_plus (Width == 414.f && Height == 736.f ? YES : NO)

#define CirnoLog(...) NSLog(@"%s line:%d\n %@ \n\n", __func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])

#define BaseURL @"api"
#define MirrorURL @"api"
#define UploadImageURL @"https://oss-cn-shanghai.aliyuncs.com/"
#define ImageURL @"https://mustplus.oss-cn-shanghai.aliyuncs.com/"
#define oldImageURL @"http://mustplus.img-cn-shanghai.aliyuncs.com/"
#define AttendanceURL @""
//服务器地址

#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//课程表背景
#define timeTableColor [UIColor colorWithRed:230.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]

//ICON COLOR #A9AAB7 169 170 183
#define sidebarDataCellTextColor [UIColor whiteColor];
#define kColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//侧边栏文字颜色
//导航栏颜色
#define navigationTabColor [UIColor colorWithRed:95.0/255.0 green:167.0/255.0 blue:241.0/255.0 alpha:1]
#define sidebarBackGroundColor navigationTabColor;
//侧边栏背景
// 6.cell内部子控件的颜色设置
// 会员昵称颜色
#define kMBScreenNameColor kColor(243, 101, 18)
// 非会员昵称颜色
#define kScreenNameColor kColor(93, 93, 93);
/**
 *  SideBar偏移量
 */
#define ContentOffset (Width / 6 * 5 - 10)
#define LongID @"studentID"
#define ShortID @"username"
#define Password @"password"
#define AvaTar @"face"
#define Backgroundimage @"backgroundimage"
#define Grade @"Gradetype"
#define Major @"Majortype"
#define NickName @"nickName"
#define Vip @"isVip"
#define Whatsup @"signText"
#define Gender @"gender"
#define PinNumber @"pinNumber"



#endif
