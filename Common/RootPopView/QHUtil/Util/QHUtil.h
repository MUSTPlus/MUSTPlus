//
//  LWUtil.h
//  QHSimpleFrame
//
//  Created by imqiuhang on 15/3/31.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

/**
 *  @author imqiuhang
 *
 *  @brief  一些常用的公共方法
 */

#import "QHHead.h"

#import "QHUtilAss.h"

typedef enum{
    UIPanDirectionNone  = 0,
    UIPanDirectionLeft  = 1,
    UIPanDirectionRight = 2,
    UIPanDirectionTop   = 3,
    UIPanDirectionDown  = 4
}UIPanDirection;

@interface QHUtil: NSObject


/**
 *  设定width计算string的高度，
 *
 *  @param string 内容
 *  @param width  宽度
 *  @param font   字体
 *
 *  @return 返回高度值
 */
+ (float)countHeightOfString:(NSString *)string WithWidth:(float)width Font:(UIFont *)font;

+ (float)countHeightOfAttributeString:(NSAttributedString *)string WithWidth:(float)width;

+ (float)countWidthOfString:(NSString *)string WithHeight:(float)height Font:(UIFont *)font;

//使文本的左边间距右移一段距离
+ (void)adjustTextFieldLeftView:(NSArray *)textFieldArr andWidth:(CGFloat)width;

/**
 *  验证手机号码、email,邮编是否正确
 *
 *  @return 正确返回yes
 */
+ (BOOL)validatePhoneNumber:(NSString *)phone;

+ (BOOL)validateEmail:(NSString *)email;

+ (BOOL)valiPostCode:(NSString *)postCode;

/**
 *  获取一个手势的滑动方向
 *
 *  @param translation 滑动的转变坐标
 *
 *  @return 方向 @see UIPanDirection
 */
+ (UIPanDirection)calculatePanDirectionWithTranslation:(CGPoint)translation;


/**
 *  得到照片存储路径
 *
 *  @param filename 照片名
 *
 *  @return 路径
 */
+ (NSString *)documentPath:(NSString *)filename;

/**
 *  把照片存到路径中
 *  @param image 图片
 *  @param aPath 路径
 *
 *  @return 是否成功
 */
+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath;
/**
 *  @author imqiuhang
 *
 *  @brief  图片压缩
 *
 *  @param image 原始图片
 *  @param size  压缩后的尺寸
 *
 *  @return 是否压缩成功
 */
+ (UIImage*) originImage:(UIImage *)image scaleToSize:(CGSize)size;
/**
 *  @author imqiuhang
 *
 *  @brief  将一张图片裁剪为圆角
 *
 *  @param image image
 *  @param inset 圆角度
 
 */
+ (UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset ;


/**
 *  @author imqiuhang
 *
 *  @brief  通过hexColor得到一个UIColor
 *
 *  @param color hexColor @example #FFFFFF或者FFFFFF或者0XFFFFFF
 *
 *  @return UIColor alpha为1.f
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

+ (UIColor *) colorWithHexString: (NSString *)color alpha:(float)alpha;


//四舍五入
+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV ;

/**
 *  @author imqiuhang
 *
 *  @brief  把一个HTML的标签转化为富文本
 *
 *  @param html HTML标签
 *
 *  @return 富文本
 */
+ (NSMutableAttributedString*)attributedStringWithHtml:(NSString*)html;


///侏儒13000转成1.3万这样
+ (NSString *)numberCountToStr:(NSInteger)count;

/*!
 *  @author imqiuhang, 15-10-27
 *
 *  @brief  将秒数转化为00：00：00格式
 *
 *  @param seconds   秒
 *  @param separator 分隔符 比如 00'00'00
 *
 *  @return 00：00：00
 */
+ (NSString *)secondsTimeToHHMMSS:(unsigned int)seconds andSeparator:(NSString *)separator;
//00:00
+ (NSString *)secondsTimeToMMSS:(unsigned int)seconds andSeparator:(NSString *)separator;
/**
 *  @author imqiuhang
 *
 *  @brief  得到一个随机不重复的字符串，常用于上传的唯一标示
 *
 *  @param len 长度
 *
 *  @return len长度的随机字符串
 */
+ (NSString *)randomStringWithLength:(int)len;

+ (UIWindow *)currentVisibleWindow;
///!!!!尽量从[QHStaticValueContent currentTopRootViewController] 如果是cell 则用 self.currentTopRootViewController  而少用[QHUtil currentVisibleController]
+ (UIViewController *)currentVisibleController ;

//检查用户是否允许推送
+ (BOOL)pushNotificationsEnabled;

//注册通知
+ (void)resignNotify;

//将服务器返回的时间转化为2015-10-10这样子的简单事件格式字符串
+ (NSString *)defaultSimpleDateFromString:(NSString *)dateString andFormatStr:(NSString *)formatStr;

@end



