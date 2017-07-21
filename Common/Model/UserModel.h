//
//  UserModel.h
//  MUST_Plus
//
//  Created by Cirno on 16/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NSString* MajorType;
typedef NSString* GradeType;
@interface UserModel : NSObject
typedef enum {
    kVerifiedTypeAdministrator  = 3,//创世之神
    kVerifiedTypeNone           = 1 ,    //普通用户
    kVerifiedTypeVIP            = 2      //VIP
    
} VerifiedType;

/**
 "MSB"="商学院";
 "FL"="法学院";
 "FI"="资讯科技学院";
 "FC"="中医药学院";
 "FT"="酒店与旅游管理学院";
 "FH"="健康科学学院";
 "FA"="人文艺术学院";
 "UIC"="国际学院";
 "ISCR"="社会和文化研究所";
 "PREU"="大学先修班";
 "GS"="通识";
 "SP"="药学院";
 "SSI"="太空科学研究院";

 **/
@property (nonatomic,copy) NSString*  studentID;
@property (nonatomic,copy) NSString* nickname;       //昵称
@property (nonatomic,copy) NSString* avatarPicURL;   //头像地址
@property (nonatomic,copy) NSString* gender;
@property (nonatomic) VerifiedType verifiedtype; //用户类型
@property (nonatomic) GradeType    grade;        //年级
@property (nonatomic) MajorType    major;        //专业
@property (nonatomic,strong) NSString* program;
@property (nonatomic,strong) NSString* faculty;
@property (nonatomic,strong) NSString* bgURL;
@property (nonatomic,strong) NSString* whatsup;
@property (nonatomic) NSInteger isVip;
@property BOOL test;
-(UserModel*)getUserModel:(NSString *)studentID;
-(void) initWithNickname:(NSString*)nickname
            andAvatarURL:(NSString*)avatarpicurl
            andGradeType:(GradeType)gradetype
            andMajorType:(MajorType)majortype;

@end
