//
//  MessageHeadView.h
//  MUST_Plus
//
//  Created by Cirno on 05/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MessageHeadAddButtonDelegate
-(void)ClickAdd:(id)button;
-(void)Avatar;
@end
@interface MessageHeadView : UIView
@property(assign,nonatomic) id<MessageHeadAddButtonDelegate> messageHeadAddButtonDelegate;
@property(strong,nonatomic) UITableView* tableView;


-(void) changeFace;

@end
