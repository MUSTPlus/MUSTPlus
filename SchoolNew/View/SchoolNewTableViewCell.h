//
//  SchoolNewTableViewCell.h
//  MUST_Plus
//
//  Created by zbc on 16/10/6.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolNewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@property (strong, nonatomic) IBOutlet UILabel *Title;
@property (strong, nonatomic) IBOutlet UILabel *Time;
@property (strong, nonatomic) IBOutlet UIImageView *TimeIcon;
@property (strong, nonatomic) NSString* url;
-(void)initWithTitle:(NSString*)title
             andtime:(NSString*)time
         andimageurl:(NSString*)imageurl;
+(SchoolNewTableViewCell*)instanceCell;
@end
