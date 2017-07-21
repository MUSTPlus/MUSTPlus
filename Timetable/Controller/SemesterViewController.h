//
//  SemesterViewController.h
//  MUSTPlus
//
//  Created by Cirno on 26/04/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Semester.h"
@protocol MenuDelegate <NSObject>

- (void)didSelectMenuItem:(NSString *)string;

@end

@interface SemesterViewController : UIViewController
@property (nonatomic, weak) id<MenuDelegate> menuDelegate;
@property (nonatomic, strong)Semester* semester;
@end
