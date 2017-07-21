//
//  CirnoTableDelegate.m
//  MUST_Plus
//
//  Created by Cirno on 22/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "CirnoTableDelegate.h"
#import "CirnoDataCell.h"
@interface CirnoTableDelegate()

@property (assign,nonatomic) NSInteger mCount;
@property (assign,nonatomic) CGFloat  mHeight;
@property (copy,nonatomic) TableViewDelegateConfigureBlock configureBlock;
@end
@implementation CirnoTableDelegate
- (id)initWithCount:(NSInteger)count andHeight:(CGFloat)height andConfigureBlock:(TableViewDelegateConfigureBlock)block
{
    if (self = [super init]) {
        self.mCount = count;
        self.mHeight = height;
        self.configureBlock = [block copy];
    }
    return self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.mHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CirnoDataCell * cell = (CirnoDataCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.configureBlock(cell,indexPath);
}
@end
