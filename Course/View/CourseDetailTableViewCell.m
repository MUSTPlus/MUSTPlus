//
//  CourseDetailTableViewCell.m
//  Currency
//
//  Created by Cirno on 02/03/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "CourseDetailTableViewCell.h"

@implementation CourseDetailTableViewCell
-(void)initWithTitle:(NSString*)title
         andSubTitle:(NSString*)subtitle
       andCourseCode:(NSString*)coursecode
          andFaculty:(NSString*)faculty
           andCredit:(NSString*)credit{

    self.TitleName.text=title;
    self.TitleName.adjustsFontSizeToFitWidth=YES;
    self.courseCode.text = coursecode;
    self.courseCode.adjustsFontSizeToFitWidth=YES;
    self.subtitleName.text = subtitle;
    self.subtitleName.adjustsFontSizeToFitWidth = YES;
    self.faculty.text = faculty;
    self.faculty.adjustsFontSizeToFitWidth =YES;
    self.Credit.text = credit;
    self.Credit.adjustsFontSizeToFitWidth = YES;

}
+(CourseDetailTableViewCell*)instanceCell{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CourseDetailCell" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
@end
