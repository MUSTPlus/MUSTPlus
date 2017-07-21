//
//  ImageSet.h
//  MUST_Plus
//
//  Created by Cirno on 12/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSet : NSObject
@property (nonatomic, strong) NSMutableArray *picUrls;
-(NSInteger) imageCount;
-(void) addPicUrls:(NSString*)url;

@end
