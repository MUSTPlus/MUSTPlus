//
//  ClassTool.h
//  Currency
//
//  Created by Cirno on 02/03/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
#import "FMDatabase.h"
#import "BasicHead.h"


@interface ClassTool : NSObject
@property (nonatomic,strong) FMDatabase* db;
- (NSMutableArray<Course*>*)search:(NSString*)keyword
                           andPlus:(NSString*)plus;
- (NSMutableArray<Course*>*)searchFaculty:(NSString*)Faculty;
- (NSMutableArray<Course*>*)searchCode:(NSString*)courseCode;
@end
