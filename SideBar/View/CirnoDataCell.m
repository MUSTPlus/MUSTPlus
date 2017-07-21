//
//  CirnoDataCell.m
//  MUST_Plus
//
//  Created by Cirno on 22/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "CirnoDataCell.h"
@interface CirnoDataCell()
@end
@implementation CirnoDataCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
        self.icon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.icon];
        self.mTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame) + 10, 10, 200, 40)];
        self.mTitle.textColor = sidebarDataCellTextColor;
        [self.contentView addSubview:self.mTitle];
    }
    return self;
}
- (void)configureForData:( SideItem*)item
{
    self.mTitle.text = item.title;
    self.icon.image= [UIImage imageNamed:item.iconName];
}


@end
