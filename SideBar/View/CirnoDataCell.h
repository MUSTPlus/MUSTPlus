//
//  CirnoDataCell.h
//  MUST_Plus
//
//  Created by Cirno on 22/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideItem.h"
#import "BasicHead.h"
@interface CirnoDataCell : UITableViewCell
@property (retain,nonatomic) UILabel * mTitle;
@property (strong,nonatomic) UIImageView * icon;
- (void)configureForData:( SideItem*)item;
@end
