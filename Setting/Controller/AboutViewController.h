//
//  AboutViewController.h
//  Currency
//
//  Created by Cirno on 09/02/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "BasicHead.h"
#import "POPNumberAnimation.h"
@interface AboutViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,POPNumberAnimationDelegate>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) UIImageView* logoview;
@property (nonatomic,strong) UIButton* footerview;
@property (nonatomic,strong) UIView* topview;
@property (nonatomic,strong) UILabel* titlelabel;
@property (nonatomic,strong) UILabel* versionlabel;
@property (nonatomic, strong) POPNumberAnimation *numberAnimation;
@end
