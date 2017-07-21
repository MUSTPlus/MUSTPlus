//
//  SchoolNewModel.m
//  MUST_Plus
//
//  Created by zbc on 16/10/5.
//  Copyright © 2016年 zbc. All rights reserved.
//

//
//  Created by zbc on 16/10/5.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "SchoolNewModel.h"

@implementation SchoolNewModel



-(void) setSchoolNewInfoData:(NSString *) schoolNew_title
          SchoolNew_imageUrl:(NSString *) schoolNew_imageUrl
          SchoolNew_describe:(NSString *) schoolNew_describe
              SchoolNew_time:(NSString *) schoolNew_time
               SchoolNew_Tag:(NSString *) schoolNew_Tag
               SchoolNew_url:(NSString *) schoolNew_url
             SchoolNew_label:(NSString *) schoolNew_label
               SchoolNews_ID:(NSString *) schoolNews_ID{
    self.schoolNew_title = schoolNew_title;
    self.schoolNew_imageUrl = schoolNew_imageUrl;
    self.schoolNew_describe = schoolNew_describe;
    self.schoolNew_time = schoolNew_time;
    self.schoolNew_Tag = schoolNew_Tag;
    self.schoolNew_url = schoolNew_url;
    self.schoolNew_label = schoolNew_label;
    self.schoolNews_ID = schoolNews_ID;
}




@end

