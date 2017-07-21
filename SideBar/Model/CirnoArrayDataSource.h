//
//  CirnoArrayDataSource.h
//  MUST_Plus
//
//  Created by Cirno on 22/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TableViewCellConfigureBlock) (id cell,id item);
@interface CirnoArrayDataSource : NSObject<UITableViewDataSource>


-(id)initWithItems:(NSArray *)anItems cellItentifier:(NSString *)aCellIdentifier configureCellBlock:(TableViewCellConfigureBlock)aConofigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
