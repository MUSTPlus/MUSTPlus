//
//  ZBCBannerView.h
//  MUST+
//
//  Created by zbc on 16/10/1.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>


//这个delegate负责viewController的翻页效果
@protocol Banner
-(void)Page:(int)num;
-(void)BannerViewDidClick:(NSString *)url
           needToRedirect:(bool)needToRedirect;
@end

@interface ZBCBannerView : UIScrollView<UIScrollViewDelegate>

@property(assign,nonatomic) id<Banner> BannerDeleage;
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSArray<NSArray *> *bArray;

-(void) bannerStartScroll;
-(void) bannerEndScroll;
-(void) addContent;

@end
