//
//  ChangeIcon.m
//  MUSTPlus
//
//  Created by Cirno on 2017/11/30.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "ChangeIcon.h"

@implementation ChangeIcon
+(void)check{
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
        return;
    }
    NSLog(@"checkstart");
    [[UIApplication sharedApplication] setAlternateIconName:@"Xmas" completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
}
-(void)changeOriginal{

    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
        return;
    }
    [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
}
-(void)changeXmas{
    [[UIApplication sharedApplication] setAlternateIconName:@"Xmas" completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
}
@end
