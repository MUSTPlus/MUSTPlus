//
//  AttendanceHeaderView.h
//  MUSTPlus
//
//  Created by Cirno on 2017/4/30.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AttendanceDelegate
-(void)didClickSign;
@end
@interface AttendanceHeaderView : UIView
@property (strong, nonatomic) IBOutlet UILabel *Date;
@property (strong, nonatomic) IBOutlet UILabel *Course;
@property (strong, nonatomic) IBOutlet UILabel *Status;
@property (strong, nonatomic) IBOutlet UIButton *Attendance;
@property (strong,nonatomic) id<AttendanceDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *bluetooth;

-(void)initWithDate:(NSString*)date
                  andCourse:(NSString*)course
                  andStatus:(NSString*)status;
@end
