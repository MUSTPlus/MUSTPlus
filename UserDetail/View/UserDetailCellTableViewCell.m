//
//  UserDetailCellTableViewCell.m
//  MUST_Plus
//
//  Created by Cirno on 30/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "UserDetailCellTableViewCell.h"

@implementation UserDetailCellTableViewCell

-(id)initWithFrame:(CGRect)frame andIcon:(UIImage*)image{
    self = [super initWithFrame:frame];
    if (self!=nil){
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15,15, 20, 20)];
        imageview.image=image;
        [self addSubview:imageview];
    }

    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    int cellHeight = self.frame.size.height;
    int cellWidth = self.frame.size.width;
    self.textLabel.frame = CGRectMake(50, 0, cellWidth-50, cellHeight);
    self.textLabel.isCopyable = YES;
}//重写 右移
// 绘制Cell分割线
- (void)drawRect:(CGRect)rect {
    if (self.textLabel.text.length==0) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1].CGColor);
//    CGContextStrokeRect(context, CGRectMake(40, 0, rect.size.width-80, 1));
//    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(40, rect.size.height, rect.size.width-80, 1));
}
@end
