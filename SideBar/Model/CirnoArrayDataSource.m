//
//  LYHArrayDataSource.m
//  LighterTableViewController
//
//  Created by Charles Leo on 14-7-24.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import "CirnoArrayDataSource.h"
#import "CirnoDataCell.h"
@interface CirnoArrayDataSource()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end
@implementation CirnoArrayDataSource

- (id)init
{
    return nil;
}
-(id)initWithItems:(NSArray *)anItems cellItentifier:(NSString *)aCellIdentifier configureCellBlock:(TableViewCellConfigureBlock)aConofigureCellBlock
{
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConofigureCellBlock copy];
    }
    return self;
}

-(id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[(NSUInteger)indexPath.row];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CirnoDataCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if (cell== nil) {
        cell = [[CirnoDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    id  item = [self itemAtIndexPath:indexPath];
    
    self.configureCellBlock(cell,item);
    return cell;
}
@end
