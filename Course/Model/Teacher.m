//
//  Teacher.m
//  Currency
//
//  Created by Cirno on 16/02/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "Teacher.h"

@implementation Teacher
-(instancetype)initWithName:(NSString*)name
                  andEnName:(NSString*)enName
                     andFtp:(NSString*)ftp
             andFtpPassword:(NSString*)ftpPassword
                   andEmail:(NSString*)email
                andSubjects:(NSMutableArray<Course*>*)subjects
                 andFaculty:(NSString*)faculty
                  andAvatar:(NSString *)avatar{
    self                 = [super init];
    if (self){
        
        self.Name        =name;
        self.enName      =enName;
        self.ftp         =ftp;
        self.ftpPassword =ftpPassword;
        self.subjects    =subjects;
        self.email       =email;
        self.Faculty     =faculty;
        self.avatar      =avatar;
    }
    return self;
}
@end
