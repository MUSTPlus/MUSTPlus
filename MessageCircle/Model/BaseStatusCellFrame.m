//
//  BaseStatusCellFrame.m
//  MUST_Plus
//
//  Created by Cirno on 19/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "BaseStatusCellFrame.h"
#import "BasicHead.h"

@implementation BaseStatusCellFrame
- (void) setStatus:(MainBody *) mainbody{
    _status = mainbody;
    _status.usermodel.studentID = mainbody.studentID;
    //利用数据计算所有子控件的frame
    // 整个cell的宽度,需要剪掉两边的间距（2 * kTableBorderWidth）
    
    // 1. 头像
    CGFloat cellWidth = Width - 2 * kTableBorderWidth;
    CGFloat iconX = kCellBorderWidth;
    CGFloat iconY = kCellBorderWidth;
    _iconFrame = CGRectMake(iconX, iconY, 40, 40);
    // 头像的大小
   // CirnoLog(@"头像%f,%f,%f",cellWidth,iconX,iconY);
    
    // 2. 昵称
    CGFloat screenNameX = CGRectGetMaxX(_iconFrame) + kCellBorderWidth;
    CGFloat screenNameY = iconY;
    //CGSize screenNameSize = [status.user.screenName sizeWithFont:kScreenNameFont];
    CGSize screenNameSize = X_TEXTSIZE(_status.usermodel.nickname,kScreenNameFont);
    _screenNameFrame = (CGRect){{screenNameX, screenNameY}, screenNameSize};
    //CirnoLog(@"昵称%f,%f",screenNameX,screenNameY);

    // 3. 昵称背后跟的小图标
    if (_status.usermodel.verifiedtype != kVerifiedTypeNone) {
        CGFloat mbIconX = CGRectGetMaxX(_screenNameFrame) + kCellBorderWidth;
        CGFloat mbIconY = (screenNameY) + (screenNameSize.height - 14) * 0.5;
        _mbIconFrame = CGRectMake(mbIconX, mbIconY, 14, 14);
    }
    
    // 4. 时间
    CGFloat timeX = screenNameX;
    CGFloat timeY = CGRectGetMaxY(_screenNameFrame) + kCellBorderWidth-5;
    CGSize timeSize = X_TEXTSIZE(_status.time, kTimeFont);
    _timeFrame = (CGRect){{timeX, timeY}, timeSize};
  //  CirnoLog(@"时间%f,%f",timeX,timeY);

    // 5. 来源
    CGFloat sourceX = CGRectGetMaxX(_timeFrame) + kCellBorderWidth;
    CGFloat sourceY = timeY;
    CGSize sourceSize = X_TEXTSIZE(_status.device, kSourceFont);
    _sourceFrame = (CGRect) {{sourceX, sourceY}, sourceSize};
  //  CirnoLog(@"来源%f,%f",sourceX,sourceY);
    
    
    // 6. 内容
    NSMutableParagraphStyle *style   = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing                = LineSpace;
    CGFloat textX = iconX+10;
    CGFloat maxY = MAX(CGRectGetMaxY(_sourceFrame), CGRectGetMaxY(_iconFrame));
    CGFloat textY = maxY + kCellBorderWidth;
    CGRect textRect = [_status.context boundingRectWithSize:CGSizeMake(cellWidth - 2 * kCellBorderWidth, MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:kTextFont,NSParagraphStyleAttributeName:style}
                                                    context:nil];
    CGSize textSize = textRect.size;

    _textFrame = (CGRect){{textX, textY}, textSize};

    
    if (_status.imageSets.imageCount){
        // 7. 夫图之缺如，岂不若言之大吊
        CGFloat imageX = textX+10;
        CGFloat imageY = CGRectGetMaxY(_textFrame) + kCellBorderWidth;
        CGSize imageSize = [ImageListView imageListSizeWithCount:(int)_status.imageSets.imageCount];
        _imageFrame = CGRectMake(imageX, imageY, imageSize.width, imageSize.height);
   //     CirnoLog(@"图片%f,%f",imageX,imageY);
    }
    
    // 8 . 整个cell的高度
    _cellHeight = kCellBorderWidth + kCellMargin +kStatusDockHeight;
    if (_status.imageSets.imageCount)
        _cellHeight += CGRectGetMaxY(_imageFrame);
    else
        _cellHeight += CGRectGetMaxY(_textFrame);
   
 //   CirnoLog(@"高度%f",_cellHeight);
    
}
@end
