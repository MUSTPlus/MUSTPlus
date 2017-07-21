//
//  ContextView.h
//  MUST_Plus
//
//  Created by Cirno on 06/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContextView : UIView
@property (strong,nonatomic) UIImage* avatar;
@property (strong,nonatomic) UILabel* nickname;
@property (strong,nonatomic) UILabel* time;
@property (strong,nonatomic) UILabel* context;
@property (strong,nonatomic) UILabel* location;
@property (strong,nonatomic) UIView* baseView;
- (int) heightForString:(NSString *)value
               fontSize:(float)fontSize
               andWidth:(float)width;

@end
