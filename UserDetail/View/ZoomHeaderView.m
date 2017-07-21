//
//  ZoomHeaderView.m
//  MUST_Plus
//
//  Created by Cirno on 30/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//
//  仿QQ上拉页
//
//
//


#import "ZoomHeaderView.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ZoomHeaderView ()


@property (nonatomic, weak) UIImageView *headerImageView;
//没有约束
@property (nonatomic, assign) CGRect originalHeaderImageViewFrame;
//代码约束
@property (nonatomic, strong) MASConstraint *codeConstraintHeight;
@property (nonatomic, assign) CGFloat originalHeaderImageViewHeight;
//xib约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeightOfHeaderImageView;

@end

@implementation ZoomHeaderView

- (instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isNeedNarrow = YES;
        [self initUI:image];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isNeedNarrow = YES;
        [self initUIXibConstraint];
    }
    return self;
}

- (void)initUI:(NSString*)image
{
    [self initUICodeConstraint:image];
}
- (UIImage *)blurryGPUImage:(UIImage *)image withBlurLevel:(CGFloat)blur {

    // 高斯模糊
    NSLog(@"burr");
    GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = blur;
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];

    return blurredImage;
}

- (void)initUICodeConstraint:(NSString*)image
{
//    NSArray *viewsToRemove = [self subviews];
//    for (UIView *v in viewsToRemove) {
//        [v removeFromSuperview];
//    }

  //  NSLog(@"urlis%@",image);
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.clipsToBounds = YES;
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    NSURL *url = [NSURL URLWithString:image];
    if (image!=nil){
      //  NSLog(@"set%@",image);
        NSLog(@"%d",_touXiang);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
        UIImage *image;
        NSError *error;
        SDImageCache *cacheType;
        NSURL* imageURL;
#pragma clang diagnostic pop
        if (_touXiang)
        [headerImageView sd_setImageWithURL:(NSURL *)url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"success!");
            self.headerImageView.image =[self blurryGPUImage:headerImageView.image withBlurLevel:7.0f];
        }];
        else
            [headerImageView sd_setImageWithURL:url];
    }

    else headerImageView.image=nil;
    [self addSubview:headerImageView];
    self.headerImageView = headerImageView;
    //约束设置为：跟父视图左、下、右贴紧，再约束高度，所以更新高度约束的时候会向上增加，xib约束同理
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self).offset(0);
        self.codeConstraintHeight = make.height.equalTo(@(self.bounds.size.height));
    }];
    self.originalHeaderImageViewHeight = self.bounds.size.height;
    [self layoutIfNeeded];
}

- (void)initUIXibConstraint
{
    self.originalHeaderImageViewHeight = self.bounds.size.height;
}

- (void)updateHeaderImageViewFrameWithOffsetY:(CGFloat)offsetY
{
    //用于实现向上滚动的时候，图片不变窄
    if (!self.isNeedNarrow && offsetY > 0) {
        return;
    }
        //防止height小于0
        if (self.originalHeaderImageViewHeight -offsetY < 0) {
            return;
        }
        [self.headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.originalHeaderImageViewHeight -offsetY));
        }];
         
}

-(void) changeImage:(UIImage *)image{
    _headerImageView.image = image;
}

-(UIImageView *) getImage{
    return _headerImageView;
}

@end

