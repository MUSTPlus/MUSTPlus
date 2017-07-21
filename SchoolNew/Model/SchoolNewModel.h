//
//  SchoolNewModel.h
//  MUST_Plus
//
//  Created by zbc on 16/10/5.
//  Copyright © 2016年 zbc. All rights reserved.

#import <Foundation/Foundation.h>

@interface SchoolNewModel : NSObject


@property(nonatomic,strong) NSString *schoolNew_title;
@property(nonatomic,strong) NSString *schoolNew_imageUrl;
@property(nonatomic,strong) NSString *schoolNew_describe;
@property(nonatomic,strong) NSString *schoolNew_time;
@property(nonatomic,strong) NSString *schoolNew_Tag;
@property(nonatomic,strong) NSString *schoolNew_url;
@property(nonatomic,strong) NSString *schoolNew_label;
@property(nonatomic,strong) NSString *schoolNews_ID;

-(void) setSchoolNewInfoData:(NSString *) schoolNew_title
          SchoolNew_imageUrl:(NSString *) schoolNew_imageUrl
          SchoolNew_describe:(NSString *) schoolNew_describe
              SchoolNew_time:(NSString *) schoolNew_time
               SchoolNew_Tag:(NSString *) schoolNew_Tag
               SchoolNew_url:(NSString *) schoolNew_url
             SchoolNew_label:(NSString *) schoolNew_label
               SchoolNews_ID:(NSString *) schoolNews_ID;

@end
