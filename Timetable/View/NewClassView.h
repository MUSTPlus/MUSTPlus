//
//  NewClassView.h
//  MUST_Plus
//
//  Created by Cirno on 13/02/2017.
//  Copyright © 2017 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicHead.h"
#import "ClassButton.h"
@interface NewClassView : UIView
@property int week;
-(void) addClassesInScrollView:(NSMutableArray<ClassButton*> *)Schoolclasses;
@end
