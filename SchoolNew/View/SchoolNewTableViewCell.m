//
//  SchoolNewTableViewCell.m
//  MUST_Plus
//
//  Created by zbc on 16/10/6.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "SchoolNewTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BasicHead.h"
@implementation SchoolNewTableViewCell

#define width Width
#define height 90

-(void)initWithTitle:(NSString*)title
             andtime:(NSString*)time
         andimageurl:(NSString*)imageurl{
    self.Title.text = title;
    self.Time.text = time;
    self.Title.numberOfLines = 0;
    self.ImageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.ImageView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
}
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self)
//    {
//        self.backgroundColor = [UIColor clearColor];
//        
//        
//       // NSLog(@"Width=%f",width);
//        
//        _New_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*0.05, height*0.1, 100, 72)];
//        //_New_imageView.contentMode = UIViewContentModeScaleAspectFit;
//        
//        _title = [[UILabel alloc] initWithFrame:CGRectMake(width*0.4, height * 0.1, width * 0.6, height*0.25)];
//    //    _title = [[UILabel alloc] initWithFrame:CGRectMake(151, 6, 225, 22.5)];
//
//     //   _title.numberOfLines = 2;
//       // _title.adjustsFontSizeToFitWidth =YES;
//        _describe = [[UILabel alloc] initWithFrame:CGRectMake(width * 0.4, height*0.35, width*0.6, height*0.4)];
//         //  _describe = [[UILabel alloc] initWithFrame:CGRectMake(150, 31, 225, 36)];
//        
//        _time = [[UILabel alloc] initWithFrame:CGRectMake(width*0.4, height*0.8, width*0.2, height*0.1)];
//       // _time = [[UILabel alloc] initWithFrame:CGRectMake(150,72, 75, 9)];
//        
//        _title.textColor = [UIColor blackColor];
//       // [_title setFont:[UIFont fontWithName:@"yuanti" size: 18]];
//        
//        _describe.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
//        _describe.numberOfLines = 2;
//      //  [_describe setFont:[UIFont fontWithName:@"yuanti" size: 13]];
//        _describe.font = [UIFont systemFontOfSize:13];
//        
//        
//        _time.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
//        _time.font = [UIFont systemFontOfSize:10];
//        
//        
//        //[self addSubview:_New_imageView];
//        [self addSubview:_title];
//        [self addSubview:_describe];
//        [self addSubview:_time];
//        
//    }
//    return self;
//}
//
+(SchoolNewTableViewCell*)instanceCell{
    NSArray* nibView = [[NSBundle mainBundle]loadNibNamed:@"NewsCell" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
//-(void)draw:(NSString *)schoolNew_title
//    getSchoolNew_imageUrl:(NSString *)getSchoolNew_imageUrl
//    getSchoolNew_describe:(NSString *)getSchoolNew_describe
//    getSchoolNew_time:(NSString *)getSchoolNew_time
//    getSchoolNew_Tag:(NSString *)getSchoolNew_Tag
//    getSchoolNew_url:(NSString *)getSchoolNew_url
//{
//  //  dispatch_async(dispatch_get_main_queue(), ^{
//    [_New_imageView sd_setImageWithURL:[NSURL URLWithString:getSchoolNew_imageUrl] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
//   // NSLog(@"urlis %@",getSchoolNew_url);
//    _url = getSchoolNew_url;
//    _title.text = schoolNew_title ;
//    _describe.text = getSchoolNew_describe;
//    _time.text = getSchoolNew_time;
//  //  });
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
