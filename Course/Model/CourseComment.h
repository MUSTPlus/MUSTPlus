//
//  Comments.h
//  MUST_Plus
//
//  Created by Cirno on 14/03/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseComment : NSObject
@property (nonatomic,strong) NSString* content;
@property (nonatomic,strong) NSString* userID;
@property (nonatomic,strong) NSString* date;
-(instancetype)initWithcontent:(NSString*)content
                       andDate:(NSString*)date
                   andUsername:(NSString*)username;
@end
