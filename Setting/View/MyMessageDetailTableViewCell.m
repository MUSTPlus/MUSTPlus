//
//  MyMessageDetailTableViewCell.m
//  MUST_Plus
//
//  Created by zbc on 17/1/8.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "MyMessageDetailTableViewCell.h"
#import "BasicHead.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyMessageDetailTableViewCell()<UserDetailsDelegate> {
    UIImageView   *_bg;         // 背景
    UIImageView   *_selectedBg; // 选中时背景
    AvatarView    *_icon;       // 头像
    UILabel       *_screenName; // 昵称
    UIImageView   *_mbIcon;     // 会员图标
    UILabel       *_text;       // 正文
    UILabel       *_time;       // 时间
    UILabel       *_device;     // 发送用设备
    ImageListView *_image;      // 配图
    
}
@end

@implementation MyMessageDetailTableViewCell

-(void)ClickAvatar:(id)button{
    [_avatarDelegate ClickAvatar:button];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self                             = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置bg
        //      CGFloat y = self.frame.size.height - kStatusDockHeight;
        
        
        [self setBackground];
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
        
        //        [self.contentView addSubview:_dock];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    frame.origin.x                   = kTableBorderWidth;
    frame.origin.y                  += kTableBorderWidth;       //使用MJRefresh引入问题，刷新之后tableview的头部y值成立负数，显示不好
    frame.size.width                -= 2 * kTableBorderWidth;
    frame.size.height               -= kCellMargin;
    
    [super setFrame:frame];
}

-(void)setBackground
{
    
    // self.backgroundColor = [UIColor greenColor];
    //    UIImageView *bg                  = [[UIImageView alloc]init];
    //
    //    self.backgroundView              = bg;
    //    _bg                              = bg;
    //    UIImageView *selectedBg          = [[UIImageView alloc]init];
    //    self.selectedBackgroundView      = selectedBg;
    //    _selectedBg                      = selectedBg;
}
-(void)addViews{
    CGFloat y = self.frame.size.height - kStatusDockHeight;
    _dock = [[ButtonDock alloc]initWithFrame:CGRectMake(0, y, 0, 0)];
    // 0.Dock
    
    [self.contentView addSubview:_dock];
    // 1.头像
    _icon                            = [[AvatarView alloc] init];
    [self.contentView addSubview:_icon];
    _icon.backgroundColor = [UIColor clearColor];
    // 2.昵称
    _screenName                      = [[UILabel alloc] init];
    _screenName.font                 = kScreenNameFont;
    _screenName.backgroundColor      = [UIColor clearColor];
    [self addSubview:_screenName];
    
    _mbIcon                          = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_membership.png"]];
    [self.contentView addSubview:_mbIcon];
    
    // 3.时间
    _time                            = [[UILabel alloc]init];
    _time.font                       = kTimeFont;
    _time.textColor                  = kColor(142, 142, 142);
    _time.backgroundColor            = [UIColor clearColor];
    [self.contentView addSubview:_time];
    
    // 4.内容
    _text                            = [[UILabel alloc]init];
    _text.numberOfLines              = 0;
    _text.font                       = kTextFont;
    _text.backgroundColor            = [UIColor clearColor];
    [self.contentView addSubview:_text];
    
    // 5.来源
    _device                          =[[UILabel alloc]init];
    _device.font                     = kSourceFont;
    _device.textColor                = kColor(142, 142, 142);
    _device.backgroundColor          =[UIColor clearColor];
    [self.contentView addSubview:_device];
    
    // 6.配图
    _image                           = [[ImageListView alloc] init];
    [self.contentView addSubview:_image];
}

-(void)setCellFrame:(BaseStatusCellFrame *)cellFrame
{
    _cellFrame                       = cellFrame;
    
    MainBody *s                      = [MainBody alloc];
    s = cellFrame.status;
    
    // 1.头像
    _icon.frame                      = cellFrame.iconFrame;
    [_icon setUser:s.usermodel];
    _icon.avatarDelegate = self;
    // 2.昵称
    UILabel *test = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 500)];
    test.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:test];
    _screenName.frame                = cellFrame.screenNameFrame;
    _screenName.text                 = s.usermodel.nickname;
    // 判断种类
    if (s.usermodel.verifiedtype     == kVerifiedTypeNone) {
        _screenName.textColor        = kScreenNameColor;
        _mbIcon.hidden               = YES;
    } else {
        _screenName.textColor        = kMBScreenNameColor;
        _mbIcon.hidden               = NO;
        _mbIcon.frame                = cellFrame.mbIconFrame;
    }
    
    // 3.时间
    _time.text                       = s.time;
    _time.frame                      = cellFrame.timeFrame;
    // 4.来源
    _device.text                     = s.device;
    _device.frame                    = cellFrame.sourceFrame;
    
    // 5.内容
    _text.frame                      = cellFrame.textFrame;
    // _text.text                       = s.context;
    NSMutableParagraphStyle *style   = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing                = LineSpace;
    NSDictionary *dic = @{NSFontAttributeName:kTextFont, NSParagraphStyleAttributeName:style};
    _text.attributedText             = [[NSAttributedString alloc]initWithString:s.context
                                                                      attributes:dic];
    //行距
    
    // 6.配图
    if (s.imageSets.imageCount) {
        _image.hidden                = NO;
        _image.frame                 = cellFrame.imageFrame;
        _image.imageUrls             = s.imageSets.picUrls;
    } else {
        _image.hidden                = YES;
    }
    
    _dock.status = cellFrame.status;
    
}

@end
