//
//  TeacherViewController.h
//  Currency
//
//  Created by Cirno on 04/01/2017.
//  Copyright © 2017 Umi. All rights reserved.
//
#import "JDStatusBarNotification.h"
#import <UIKit/UIKit.h>
#import "Teacher.h"
#import "PressButton.h"
@interface TeacherViewController : UIViewController<PressAnimationButtonDelegate>
@property (nonatomic,strong) Teacher* teacher;
@property (nonatomic,strong) PressButton* button;
@property (nonatomic,strong) PressButton* emailbutton;
@property (nonatomic,strong) NSString* teacherName;
@property (nonatomic,strong) UILabel * label;
@property (nonatomic,strong) UILabel * labelen;
@end
