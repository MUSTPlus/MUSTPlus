//
//  MessageDetailCellFrame.m
//  MUST_Plus
//
//  Created by zbc on 16/11/2.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "MessageDetailCellFrame.h"
#import "BasicHead.h"
#import "Account.h"
@implementation MessageDetailCellFrame


- (void) setStatus:(CommentDetails *) comemtDetail{
    _status = comemtDetail;
    //利用数据计算所有子控件的frame
    // 整个cell的宽度,需要剪掉两边的间距（2 * kTableBorderWidth）
    
    // 1. 头像
    CGFloat cellWidth = Width - 2 * kTableBorderWidth-50;
    CGFloat iconX = kCellBorderWidth;
    CGFloat iconY = kCellBorderWidth;
    _iconFrame = CGRectMake(iconX, iconY, 40, 40);
    // 头像的大小
    // CirnoLog(@"头像%f,%f,%f",cellWidth,iconX,iconY);
    
    // 2. 昵称
    CGFloat screenNameX = CGRectGetMaxX(_iconFrame) + kCellBorderWidth;
    CGFloat screenNameY = iconY;
    //CGSize screenNameSize = [status.user.screenName sizeWithFont:kScreenNameFont];
    CGSize screenNameSize = X_TEXTSIZE(_status.nickname,kScreenNameFont);
    _screenNameFrame = (CGRect){{screenNameX, screenNameY}, screenNameSize};
    //CirnoLog(@"昵称%f,%f",screenNameX,screenNameY);
    
    
    if([_status.studentID isEqualToString:[[Account shared] getStudentLongID]]){
        CGFloat mbIconX = [[UIScreen mainScreen] bounds].size.width-50;
        CGFloat mbIconY = (screenNameY) + (screenNameSize.height - 40) * 0.5;
        _deleteIconFrame = CGRectMake(mbIconX, mbIconY, 40, 40);
    }
    
    // 3. 昵称背后跟的小图标
//    if (_status.verifiedtype != kVerifiedTypeNone) {
//        CGFloat mbIconX = CGRectGetMaxX(_screenNameFrame) + kCellBorderWidth;
//        CGFloat mbIconY = (screenNameY) + (screenNameSize.height - 14) * 0.5;
//        _mbIconFrame = CGRectMake(mbIconX, mbIconY, 14, 14);
//        CirnoLog(@"mbICONx%f,y%f",mbIconX,mbIconY);
//        CirnoLog(@"nowICON%f,y%f",_mbIconFrame.origin.x,_mbIconFrame.origin.y);
//    }
    
    // 4. 时间
    CGFloat timeX = screenNameX;
    CGFloat timeY = CGRectGetMaxY(_screenNameFrame) + kCellBorderWidth-5;
    CGSize timeSize = X_TEXTSIZE(_status.time, kTimeFont);
    _timeFrame = (CGRect){{timeX, timeY}, timeSize};
    // 5. 来源
//    CGFloat sourceX = CGRectGetMaxX(_timeFrame) + kCellBorderWidth;
//    CGFloat sourceY = timeY;
//    CGSize sourceSize = X_TEXTSIZE(_status.device, kSourceFont);
//    _sourceFrame = (CGRect) {{sourceX, sourceY}, sourceSize};
    //  CirnoLog(@"来源%f,%f",sourceX,sourceY);
    
    
    // 6. 内容
    NSMutableParagraphStyle *style   = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing                = LineSpace;
    CGFloat textX = screenNameX;
    CGFloat maxY = MAX(CGRectGetMaxY(_sourceFrame), CGRectGetMaxY(_iconFrame));
    CGFloat textY = maxY + kCellBorderWidth;
    CGRect textRect = [_status.context boundingRectWithSize:CGSizeMake(cellWidth - 2 * kCellBorderWidth, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:kDetailTextFont,NSParagraphStyleAttributeName:style}
                                                    context:nil];
    
    CGSize textSize = CGSizeMake(textRect.size.width, textRect.size.height) ;
    
    
    _textFrame = (CGRect){{textX, textY}, textSize};
    

    
    // 8 . 整个cell的高度
    _cellHeight = kCellBorderWidth + kCellMargin;
    _cellHeight += CGRectGetMaxY(_textFrame);
    
    //   CirnoLog(@"高度%f",_cellHeight);
    
}


@end
