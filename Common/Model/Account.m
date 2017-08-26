//
//  Account.m
//  MUST_Plus
//
//  Created by Cirno on 24/12/2016.
//  Copyright © 2016 zbc. All rights reserved.
//


#import "Account.h"
#import <UIKit/UIKit.h>
#import "objc/runtime.h"

@implementation Account
//共用同一个对象
+ (instancetype)shared {
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [[self class] new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

-(NSString*)getStudentLongID{
    return [[NSUserDefaults standardUserDefaults] objectForKey:LongID];
};
//短ID
-(NSString*)getStudentShortID{
    return [[NSUserDefaults standardUserDefaults] objectForKey:ShortID];
};
-(NSString*)getPassword{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:Password];
};
-(NSString*)getAvatar{
    return [[NSUserDefaults standardUserDefaults] objectForKey:AvaTar];
}
-(NSString*)getBgImage{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Backgroundimage];
}
-(NSString*)getGradeType{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Grade];
}
-(NSString*)getMajorType{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Major];
}
-(NSString*)getNickname{
    return [[NSUserDefaults standardUserDefaults] objectForKey:NickName];
}
-(NSString*)getVip{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Vip];
}
-(NSString*)getWhatsup{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Whatsup];
}
-(NSString*)getGender{
    return [[NSUserDefaults standardUserDefaults] objectForKey:Gender];
}
-(NSString*)getPin{
    return [[NSUserDefaults standardUserDefaults] objectForKey:PinNumber];
}
-(NSString*)getProgram{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Program"];
}
-(NSString*)getFaculty{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Faculty"];
}
-(NSString*)getSemester{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Semester"];
}
-(NSString*)getAllCourse{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"AllCourse"];
}
-(NSString*)getMailPw{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"MailPw"];
}
-(NSString*)getLoginStatus{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginStatus"];
}
-(void)setStudentLongID:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:LongID];
};
-(void)setStudentShortID:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:ShortID];
};
-(void)setPassword:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:Password];
};
-(void)setAvatar:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:AvaTar];
}
-(void)setBgImage:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:Backgroundimage];
}
-(void)setGradeType:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:Grade];
}
-(void)setMajorType:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:Major];
}
-(void)setNickname:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:NickName];
}
-(void)setVip:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:Vip];
}
-(void)setWhatsup:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:Whatsup];
}
-(void)setGender:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:Gender];
}
-(void)setProgram:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"Program"];
}
-(void)setPin:(NSString *)str{
    NSLog(@"设置新的Pin码");
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:PinNumber];
}
-(void)setFaculty:(NSString *)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"Faculty"];
}
-(void)setSemester:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"Semester"];
}
-(void)setAllCourse:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"AllCourse"];
}
-(void)setMailPw:(NSString*)str{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"MailPw"];
}
-(void)setLoginStatus{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"LoginStatus"];

}
@end
