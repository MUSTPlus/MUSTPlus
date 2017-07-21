//
//  ZoomHeaderView.h
//  MUST_Plus
//
//  Created by Cirno on 30/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface ZoomHeaderView : UIView

//是否需要向上滑动的时候图片收缩，默认YES
@property (nonatomic, assign) BOOL isNeedNarrow;
@property (nonatomic,assign)BOOL touXiang;
- (instancetype)initWithFrame:(CGRect)frame
                    andImage :(NSString*)image;
- (void)updateHeaderImageViewFrameWithOffsetY:(CGFloat)offsetY;
- (void)initUICodeConstraint:(NSString*)image;
-(UIImageView *) getImage;
-(void) changeImage:(UIImage *)image;

@end
