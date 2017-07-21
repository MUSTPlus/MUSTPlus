//
//  ZBCBannerView.m
//  MUST+
//
//  Created by zbc on 16/10/1.
//  Copyright © 2016年 zbc. All rights reserved.
//
#import "BasicHead.h"
#import "ZBCBannerView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking.h>

@implementation ZBCBannerView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self!=nil){
        
    }
    
    return self;
}


-(void) addContent{
    
    self.contentSize=CGSizeMake(self.frame.size.width*[_bArray count],self.frame.size.height);
    self.backgroundColor=[UIColor blackColor];
    self.pagingEnabled=YES;
    
    //取消滚动条
    self.showsVerticalScrollIndicator = FALSE;
    self.showsHorizontalScrollIndicator = FALSE;
    
    
    self.delegate=self;
    self.directionalLockEnabled=NO;
    float _x=0;
    
    for(int index=0;index<[_bArray count];index++){
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0+_x, 0, self.frame.size.width, self.frame.size.height)];
        imageview.userInteractionEnabled  = YES;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[_bArray objectAtIndex:index][0]]];
        [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"sidebar_bgz.png"]
                              options:SDWebImageRefreshCached];
        [self addSubview:imageview];
        _x+=self.frame.size.width;
        imageview.tag = 1000 + index;
        
        //添加点击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidClcik:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [imageview addGestureRecognizer:singleTap];
        
    }
}

-(void) bannerStartScroll{
    _timer =  [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(pageNext) userInfo:nil repeats:YES];
}


-(void) bannerEndScroll{
    [_timer invalidate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //当滚动时把Timer关了
     [_timer invalidate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //当滚动结束时把Timer开启
    _timer =  [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(pageNext) userInfo:nil repeats:YES];
    //滚动完逻辑
    int x = self.contentOffset.x / self.frame.size.width;
    //NSLog(@"%f,%f",self.contentOffset.x,self.frame.size.width);
    [_BannerDeleage Page:x];
}

-(void)viewDidClcik:(UIGestureRecognizer *)tag{
    [_BannerDeleage BannerViewDidClick:_bArray[(int)tag.view.tag - 1000][1] needToRedirect:true];
}

-(void) pageNext{
    int x = self.contentOffset.x / self.frame.size.width;
    CGPoint newOffset = self.contentOffset;

    if(x == [_bArray count] - 1){
        x = 0;
        newOffset.x = 0;
    }
    else{
        x++;
        newOffset.x = newOffset.x +self.frame.size.width;
    }
    [_BannerDeleage Page:x];
    [self setContentOffset:newOffset animated:YES];
}



@end
