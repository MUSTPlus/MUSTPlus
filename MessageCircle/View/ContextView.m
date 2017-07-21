//
//  ContextView.m
//  MUST_Plus
//
//  Created by Cirno on 06/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "ContextView.h"
#import "BasicHead.h"
#import "MainBody.h"
#define TopHeight 85
#define BottomHeight 67
@implementation ContextView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self!=nil){
     //   [self drawContextView];
    }
    return self;
}
- (int) heightForString:(NSString *)value
                 fontSize:(float)fontSize
                 andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}
-(void)drawContextView:(MainBody*)mainBody{
    NSInteger tHeight;
    tHeight = TopHeight;
    tHeight += [self heightForString:mainBody.context fontSize:13 andWidth:Width-20-40];//自适应文本高度
    tHeight += BottomHeight;

//    NSInteger imageCount = [mainBody.imageSets imageCount];
//    switch (imageCount) {
//        case 1:
//            
//            break;
//            
//        default:
//            break;
//    }
    //考虑以后图片增加支持 TODO
    //181 * 218
    
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, tHeight)];
}
@end
