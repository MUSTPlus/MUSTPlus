//
//  ImageSet.m
//  MUST_Plus
//
//  Created by Cirno on 12/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "ImageSet.h"

@implementation ImageSet


//init中将Array初始化
-(id) init{
    self = [super init];
    _picUrls = [[NSMutableArray alloc] init];
    return self;
}


-(NSInteger)imageCount{
    return [_picUrls count];
}
-(void) addPicUrls:(NSString*)url{
    [_picUrls addObject:url];
}
@end
