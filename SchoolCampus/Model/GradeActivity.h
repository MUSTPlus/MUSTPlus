//
//  GradeActivity.h
//  MUSTPlus
//
//  Created by Cirno on 2017/8/13.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol gradedeleagte <NSObject>
- (void)runjs;
@end
@interface GradeActivity : UIActivity
@property(nonatomic, weak) id<gradedeleagte> delegate;
@end
