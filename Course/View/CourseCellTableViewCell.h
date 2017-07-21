//
//  CourseCellTableViewCell.h
//  Currency
//
//  Created by Cirno on 01/03/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *coursecode;
@property (strong, nonatomic) IBOutlet UILabel *credit;
@property (strong, nonatomic) IBOutlet UILabel *faculty;
@property (strong, nonatomic) IBOutlet UIImageView *rare;

//@property (strong, nonatomic) IBOutlet UITextView *title;
//@property (strong, nonatomic) IBOutlet UITextView *coursecode;
//@property (strong, nonatomic) IBOutlet UITextView *faculty;
//@property (strong, nonatomic) IBOutlet UITextView *credit;
-(void)initWithTitle:(NSString*)title
       andCourseCode:(NSString*)coursecode
          andFaculty:(NSString*)faculty
           andCredit:(NSString*)credit;
+(CourseCellTableViewCell*)instanceCell;
@end
