//
//  Account.h
//  MUST_Plus
//
//  Created by Cirno on 24/12/2016.
//  Copyright © 2016 zbc. All rights reserved.
//
//
//  这个类专门用于管理账号相关。
//  
//
//
//
#import "BasicHead.h"

#import <Foundation/Foundation.h>

@interface Account : NSObject
+ (instancetype)shared;
//  从本地取得学生长ID，短ID
-(NSString*)getStudentLongID;
-(NSString*)getStudentShortID;
-(NSString*)getPassword;
-(NSString*)getAvatar;
-(NSString*)getBgImage;
-(NSString*)getGradeType;
-(NSString*)getMajorType;
-(NSString*)getNickname;
-(NSString*)getVip;
-(NSString*)getWhatsup;
-(NSString*)getGender;
-(NSString*)getPin;
-(NSString*)getFaculty;
-(NSString*)getSemester;
-(NSString*)getAllCourse;
-(NSString*)getMailPw;
-(NSString*)getLoginStatus;
-(void)setStudentLongID:(NSString*)str;
-(void)setStudentShortID:(NSString*)str;
-(void)setPassword:(NSString*)str;
-(void)setAvatar:(NSString*)str;
-(void)setBgImage:(NSString*)str;
-(void)setGradeType:(NSString*)str;
-(void)setMajorType:(NSString*)str;
-(void)setNickname:(NSString*)str;
-(void)setVip:(NSString*)str;
-(void)setWhatsup:(NSString*)str;
-(void)setGender:(NSString*)str;
-(void)setPin:(NSString*)str;
-(void)setProgram:(NSString*)str;
-(void)setFaculty:(NSString*)str;
-(void)setSemester:(NSString*)str;
-(void)setAllCourse:(NSString*)str;
-(void)setMailPw:(NSString*)str;
-(void)setLoginStatus;

@end
