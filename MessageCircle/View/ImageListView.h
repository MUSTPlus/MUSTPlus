//
//  ImageListView.h
//  MUST_Plus
//
//  Created by Cirno on 13/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCount 9
#define kOneW 100
#define kOneH 100
#define kMultiW 70
#define kMultiH 70
#define kMargin 20
#import "BasicHead.h"
#import "ImageItemView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface ImageListView : UIView
@property (nonatomic, strong) NSArray *imageUrls;
+ (CGSize)imageListSizeWithCount:(int)count;
@end
