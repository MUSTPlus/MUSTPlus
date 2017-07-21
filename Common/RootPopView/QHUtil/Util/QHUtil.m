//
//  LWUtil.m
//  QHSimpleFrame
//
//  Created by imqiuhang on 15/3/31.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import "QHUtil.h"

@implementation QHUtil



+ (float)countHeightOfString:(NSString *)string WithWidth:(float)width Font:(UIFont *)font {
    if (![string isNotEmptyCtg]) {
        string = @"";
    }
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated"

    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
    CGSize labelSize = [string sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByCharWrapping];
    return labelSize.height;
}


+ (float)countHeightOfAttributeString:(NSAttributedString *)string WithWidth:(float)width {
    UITextView * label = [[UITextView alloc] init];
    label.width = width;
    [label setAttributedText:string];
    
    CGSize size = [label sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
    
}

+ (float)countWidthOfString:(NSString *)string WithHeight:(float)height Font:(UIFont *)font {
    if (![string isNotEmptyCtg]) {
        string = @"";
    }
    CGSize constraintSize = CGSizeMake(MAXFLOAT, height);
    CGSize labelSize = [string sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.width;
    #pragma clang diagnostic pop
}

+ (void)adjustTextFieldLeftView:(NSArray *)textFieldArr andWidth:(CGFloat)width {
    for(UITextField *textField in textFieldArr) {
        textField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
        textField.leftViewMode=UITextFieldViewModeAlways;
    }
}

+ (UIPanDirection)calculatePanDirectionWithTranslation:(CGPoint)translation {
    if (fabs(translation.x/translation.y)>5.0f) {
        if (translation.x>0) {
            return UIPanDirectionRight;
        }else {
            return UIPanDirectionLeft;
        }
    }else {
        if (translation.y>0) {
            return UIPanDirectionTop;
        }else {
            return UIPanDirectionDown;
        }
    }
}

+ (BOOL)validatePhoneNumber:(NSString *)phone {
    if ([phone length]!=11) {
        return NO;
    }
    NSString *regExStr = @"^1\\d{10}$";
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regExStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    
    long result = [regex numberOfMatchesInString:phone options:0 range:NSMakeRange(0, [phone length])];
    if(result>0) {
        return YES;
    }else {
        return NO;
    }
    
}

+ (BOOL)validateEmail:(NSString *)email {
    
    NSString *regExStr = @"^\\w*@\\w*\\.\\w*$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regExStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    long result = [regex numberOfMatchesInString:email options:0 range:NSMakeRange(0, [email length])];
    if(result>0){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)valiPostCode:(NSString *)postCode {

        const char *cvalue = [postCode UTF8String];
        int len = (int)strlen(cvalue);
        if (len != 6) {
            return NO;
        }
        for (int i = 0; i < len; i++) {
            if (!(cvalue[i] >= '0' && cvalue[i] <= '9')) {
                return NO;
            }
        }
        return YES;
}

+ (NSString *)documentPath:(NSString *)filename{
    NSString *result=nil;
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsFolder = [folders objectAtIndex:0];
    result = [documentsFolder stringByAppendingPathComponent:filename];
    
    return result;
}

+ (UIImage *)getImage:(NSString *)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,                                                                          NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath2 = [documentsDirectory stringByAppendingPathComponent:imageName];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath2];
    return img;
}

+ (UIImage*) originImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath {
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
        return NO;
    @try {
        NSData *imageData = nil;
        imageData = UIImagePNGRepresentation(image);
        if ((imageData == nil) || ([imageData length] <= 0))
            return NO;
        
        [imageData writeToFile:aPath atomically:YES];
        return YES;
    }
    @catch (NSException *e) {
        MSLog(@"保存图片失败");
    }
    return NO;
}

+ (NSString *)randomStringWithLength:(int)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

+ (UIColor *) colorWithHexString: (NSString *)color{
    return [QHUtil colorWithHexString:color alpha:1.f];
}

+ (UIColor *) colorWithHexString: (NSString *)color alpha:(float)alpha{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6) {
        MSLog(@"输入的16进制有误，不足6位！");
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+ (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

+ (NSString *)numberCountToStr:(NSInteger)count {
    
    if (count<=0) {
        return @"0";
    }
    
    if (count<10000) {
        return [NSString stringWithFormat:@"%li",(long)count];
    }
    
    
    float num = count/10000.f;
    double zhengshu = 0.00f;
    double yushu =   modf(num,&zhengshu);
    
    return yushu>0.1? [NSString stringWithFormat:@"%.1f万",count/10000.0f]:[NSString stringWithFormat:@"%i万",(int)count/10000];
}

+ (NSString *)secondsTimeToHHMMSS:(unsigned int)seconds andSeparator:(NSString *)separator {
    int h = seconds/3600;
    int m = (seconds - h*3600)/60;
    int s = seconds - h*3600 - m*60;
    
    NSString *sh = [NSString stringWithFormat:@"%i",h];
    NSString *sm = [NSString stringWithFormat:@"%i",m];
    NSString *ss = [NSString stringWithFormat:@"%i",s];
    
    sh = sh.length<=1?[NSString stringWithFormat:@"0%@",sh]:sh;
    sm = sm.length<=1?[NSString stringWithFormat:@"0%@",sm]:sm;
    ss = ss.length<=1?[NSString stringWithFormat:@"0%@",ss]:ss;
    
    return [@[sh,sm,ss] componentsJoinedByString:separator];
}

+ (NSString *)secondsTimeToMMSS:(unsigned int)seconds andSeparator:(NSString *)separator {
    
    int m = (seconds)/60;
    int s = seconds - m*60;
    
    NSString *sm = [NSString stringWithFormat:@"%i",m];
    NSString *ss = [NSString stringWithFormat:@"%i",s];
    
    sm = sm.length<=1?[NSString stringWithFormat:@"0%@",sm]:sm;
    ss = ss.length<=1?[NSString stringWithFormat:@"0%@",ss]:ss;
    
    return [@[sm,ss] componentsJoinedByString:separator];
}

+ (NSMutableAttributedString*)attributedStringWithHtml:(NSString*)html {
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    return attrStr;
}


+ (UIWindow *)currentVisibleWindow {
    NSEnumerator *frontToBackWindows =
    [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            return window;
        }
    }
    return [[[UIApplication sharedApplication] delegate] window];
}

+ (UIViewController *)currentVisibleController {
    UIViewController *topController =
    [QHUtil currentVisibleWindow].rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

+ (BOOL)pushNotificationsEnabled {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
        UIUserNotificationType types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
        return (types & UIUserNotificationTypeAlert);
    }
    else {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        return (types & UIRemoteNotificationTypeAlert);
    }
}


+ (void)resignNotify {
    
    //>>>>>>>>>>>>>>>notify
    
    if (IOS_VERSION>=8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:
                                                UIUserNotificationTypeAlert   //弹出框
                                                | UIUserNotificationTypeBadge //状态栏
                                                | UIUserNotificationTypeSound //声音
                                                
                                                categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }

}


+ (NSString *)defaultSimpleDateFromString:(NSString *)dateString andFormatStr:(NSString *)formatStr {
    if (![dateString isNotEmptyCtg]) {
        return @"";
    }
    
    dateString = [NSString stringWithFormat:@"%@",dateString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    if (date) {
        [formatter setDateFormat:formatStr];
       return  [formatter stringFromDate:date];
    }
    return @"";
}


@end

#pragma clang diagnostic pop
