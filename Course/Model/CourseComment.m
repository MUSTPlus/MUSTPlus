//
//  Comments.m
//  MUST_Plus
//
//  Created by Cirno on 14/03/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import "CourseComment.h"

@implementation CourseComment
-(instancetype)initWithcontent:(NSString*)content
                       andDate:(NSString*)date
                   andUsername:(NSString*)username{
    self = [super init];
    if (self){
        self.content=content;
        self.date=date;
        self.userID=username;

    }
    return self;
}
@end
