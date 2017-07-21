//
//  CourseCellTableViewCell.m
//  Currency
//
//  Created by Cirno on 01/03/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import "CourseCellTableViewCell.h"

@implementation CourseCellTableViewCell
-(void)initWithTitle:(NSString*)title
               andCourseCode:(NSString*)coursecode
                  andFaculty:(NSString*)faculty
                   andCredit:(NSString*)credit{

    self.title.text=title;
    self.title.adjustsFontSizeToFitWidth=YES;
    self.coursecode.adjustsFontSizeToFitWidth=YES;
    self.faculty.adjustsFontSizeToFitWidth=YES;
    self.credit.adjustsFontSizeToFitWidth = YES;
    self.coursecode.text=coursecode;
    self.faculty.text =faculty;
    self.credit.text=credit;
    self.rare.contentMode=UIViewContentModeScaleAspectFit;
//    int x = arc4random() % 1000;
//    //500 350 100 50
//    if ((x>=0)&&(x<=50)){
//        self.rare.image = [UIImage imageNamed:@"N"];
//    } else if ((x>=51)&&(x<=150)){
//        self.rare.image = [UIImage imageNamed:@"R"];
//    } else if ((x>=151)&&(x<=500)){
//        self.rare.image = [UIImage imageNamed:@"SR"];
//    } else if ((x>=501)&&(x<=1000)){
//        self.rare.image = [UIImage imageNamed:@"SSR"];
//    }

}
+(CourseCellTableViewCell*)instanceCell{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"coursecell" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}


@end
