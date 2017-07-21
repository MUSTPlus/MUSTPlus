//
//  messageDetailTableViewCell.m
//  MUST_Plus
//
//  Created by zbc on 16/11/2.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "messageDetailTableViewCell.h"
#import "BasicHead.h"


@interface messageDetailTableViewCell()<UserDetailsDelegate>{
    UIImageView   *_bg;         // 背景
    UIImageView   *_selectedBg; // 选中时背景
    AvatarView    *_icon;       // 头像
    UIButton      *_delete;     // 删除评论
    UILabel       *_screenName; // 昵称
    UIImageView   *_mbIcon;     // 会员图标
    UILabel       *_text;       // 正文
    UILabel       *_time;       // 时间
}

@end


@implementation messageDetailTableViewCell
-(void)ClickAvatar:(id)button{
    [_avatarDelegate ClickAvatar:button];
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self                             = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackground];
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
        _icon.avatarDelegate=self;
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    frame.origin.x                   = kTableBorderWidth;
//    frame.origin.y                  += kTableBorderWidth;       //使用MJRefresh引入问题，刷新之后tableview的头部y值成立负数，显示不好
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
  //  CGFloat y = self.frame.size.height - kStatusDockHeight;
    
    // 1.头像
    _icon                            = [[AvatarView alloc] init];
    [self.contentView addSubview:_icon];
    _icon.backgroundColor = [UIColor clearColor];
    // 2.昵称
    _screenName                      = [[UILabel alloc] init];
    _screenName.font                 = kScreenNameFont;
    _screenName.backgroundColor      = [UIColor clearColor];
    [self addSubview:_screenName];
    
    //删除
    _delete                          = [[UIButton alloc] init];
    [_delete setImage:[UIImage imageNamed:@"statusdetail_icon_delete"] forState:UIControlStateNormal];
    [_delete addTarget:self action:@selector(deleteComment) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_delete];

//    _mbIcon                          = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_membership.png"]];
//    [self.contentView addSubview:_mbIcon];
    
    // 3.时间
    _time                            = [[UILabel alloc] init];
    _time.font                       = kTimeFont;
    _time.textColor                  = kColor(142, 142, 142);
    //_time.backgroundColor            = [UIColor redColor];
    [self addSubview:_time];
    
    // 4.内容
    _text                            = [[UILabel alloc]init];
    _text.numberOfLines              = 0;
    _text.font                       = kTextFont;
    _text.backgroundColor            = [UIColor clearColor];
    [self.contentView addSubview:_text];
    
}


-(void) deleteComment{
    [_deleteDelegate Clickdelete:_cellFrame.status.commentID];
}

-(void)setCellFrame:(MessageDetailCellFrame *)cellFrame
{
    _cellFrame                     = cellFrame;

    CommentDetails *s              = cellFrame.status;

    // 1.头像
    _icon.frame                    = cellFrame.iconFrame;
    UserModel *t                   = [[UserModel alloc]init];
    t.avatarPicURL                 = s.avatarURL;
    t.nickname                     = s.nickname;
    t.studentID                    = s.studentID;
    
    [_icon setUser:t];

    // 2.昵称
    UILabel *test                  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 500)];
    test.backgroundColor           = [UIColor clearColor];
    test.textColor                 = t.isVip ? kColor(243, 101, 18) : kColor(0, 0, 0);

    [self.contentView addSubview:test];
    _screenName.frame              = cellFrame.screenNameFrame;
    _screenName.text               = s.nickname;

    
    _delete.frame = cellFrame.deleteIconFrame;
    
    // 3.时间
    _time.text                     = s.time;
    _time.frame                    = cellFrame.timeFrame;
    //_time.backgroundColor        = [UIColor redColor];
    // 5.内容
    _text.frame                    = cellFrame.textFrame;
    // _text.text                  = s.context;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing              = LineSpace;
    NSDictionary *dic              = @{NSFontAttributeName:kTextFont, NSParagraphStyleAttributeName:style};
    _text.attributedText           = [[NSAttributedString alloc]initWithString:s.context
                                                                      attributes:dic];
}


@end
