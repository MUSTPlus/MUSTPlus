//
//  Teacher.h
//  Currency
//
//  Created by Cirno on 16/02/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"

@interface Teacher : NSObject
@property (nonatomic,strong) NSString* Name;
@property (nonatomic,strong) NSString* enName;
@property (nonatomic,strong) NSString* ftp;
@property (nonatomic,strong) NSString* ftpPassword;
@property (nonatomic,strong) NSString* email;
@property (nonatomic,strong) NSMutableArray<Course*>* subjects;
@property (nonatomic,strong) NSString* avatar;
@property (nonatomic,strong) NSString* Faculty;
-(instancetype)initWithName:(NSString*)name
                  andEnName:(NSString*)enName
                     andFtp:(NSString*)ftp
             andFtpPassword:(NSString*)ftpPassword
                   andEmail:(NSString*)email
                andSubjects:(NSMutableArray<Course*>*)subjects
                 andFaculty:(NSString*)faculty
                  andAvatar:(NSString*)avatar;
@end
