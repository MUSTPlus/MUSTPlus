//
//  ZBCNewView.h
//  MUST_Plus
//
//  Created by zbc on 16/10/2.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBCNewView : UIView


@property(nonatomic,strong) UILabel *title;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *describe;
@property(nonatomic,strong) UILabel *time;
@property(nonatomic,strong) UIImageView *newsTag;
@property(nonatomic,strong) NSString *url;


-(void) setData:(NSString *)title
        newImage:(NSString *)image
        newDescribe:(NSString *)describe
        time:(NSString *)time
        url:(NSString *)url
        newTag:(int)tag;

@end
