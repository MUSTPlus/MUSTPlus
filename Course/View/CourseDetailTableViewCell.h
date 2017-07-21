//
//  CourseDetailTableViewCell.h
//  Currency
//
//  Created by Cirno on 02/03/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailTableViewCell : UITableViewCell
//@property (strong, nonatomic) IBOutlet UILabel *TitleName;
//@property (strong, nonatomic) IBOutlet UILabel *subtitleName;
//@property (strong, nonatomic) IBOutlet UILabel *courseCode;
//@property (strong, nonatomic) IBOutlet UILabel *Credit;
//@property (strong, nonatomic) IBOutlet UILabel *faculty;
@property (strong, nonatomic) IBOutlet UILabel *TitleName;
@property (strong, nonatomic) IBOutlet UILabel *subtitleName;
@property (strong, nonatomic) IBOutlet UILabel *courseCode;
@property (strong, nonatomic) IBOutlet UILabel *faculty;
@property (strong, nonatomic) IBOutlet UILabel *Credit;
+(CourseDetailTableViewCell*)instanceCell;
-(void)initWithTitle:(NSString*)title
         andSubTitle:(NSString*)subtitle
       andCourseCode:(NSString*)coursecode
          andFaculty:(NSString*)faculty
           andCredit:(NSString*)credit;
@end
