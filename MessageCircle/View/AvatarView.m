//
//  AvatarView.m
//  MUST_Plus
//
//  Created by Cirno on 16/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//  头像的View
#import "UIKit/UIKit.h"

#import "AvatarView.h"
#import "BasicHead.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AvatarView()
{
    UIImageView *_icon; // 头像图片
    UIButton * _icon1;
    UIImageView *_vertify; // 认证图标
}

@end
@implementation AvatarView


- (instancetype)init
{
    self = [super init];
    if (self) {
        // 1.用户头像图片
        UIButton * icon1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIImageView* icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];

        [icon1 addSubview:icon];
        [self addSubview:icon1];
        _icon1 = icon1;
        _icon = icon;
        // 2.右下角的认证图标
        UIImageView *vertify = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 14, 14)];
        [self addSubview:vertify];
        _vertify = vertify;
        [icon1 addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

-(void)setUser:(UserModel *)user{
    //设置用户图片

    _user                    = [UserModel alloc];
    _user = user;
    NSString *URLString = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,h_200",user.avatarPicURL];
    NSURL *url = [NSURL URLWithString:URLString];
    [_icon setImage:[UIImage imageNamed:@"defaultFace.png"]];
    [_icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultFace.png"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }
     ];
 //   CirnoLog(@"ggg");
    _icon.layer.cornerRadius = _icon.frame.size.width/2;
    _icon.clipsToBounds      = YES;
    _icon.layer.borderWidth  = 2;
    _icon.layer.borderColor  = kColor(250,250,250).CGColor;
    NSString *z = _user.studentID;
    _icon1.tag=(NSInteger)z;
    //圆形layer
    NSString *verifiedIcon = nil;
    switch (user.verifiedtype) {
        case kVerifiedTypeNone:
            _vertify.hidden = YES;
            break;
        case kVerifiedTypeAdministrator: // 个人
            verifiedIcon = @"avatar_vip";
            break;
        default:
            _vertify.hidden = YES;
            break;
    }
    
    // 如果有认证，显示图标
    if (verifiedIcon) {
        _vertify.hidden = NO;
        _vertify.image = [UIImage imageNamed:verifiedIcon];
    }
}
-(void)Click:(id)button{
  //  CirnoLog(@"点击1");
    [_avatarDelegate ClickAvatar:button];
}

@end
