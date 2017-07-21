//
//  CirnoTableDelegate.h
//  MUST_Plus
//
//  Created by Cirno on 22/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^TableViewDelegateConfigureBlock)(id cell,NSIndexPath *indexpath);
@interface CirnoTableDelegate : NSObject<UITableViewDelegate>
- (id)initWithCount:(NSInteger)count andHeight:(CGFloat)height andConfigureBlock:(TableViewDelegateConfigureBlock)block;
@end
