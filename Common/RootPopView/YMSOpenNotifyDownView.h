//
//  YMSOpenNotifyDownView.h
//  yimashuo
//
//  Created by imqiuhang on 15/12/18.
//  Copyright © 2015年 imqiuhang. All rights reserved.
//

#import "CardDownAnimationView.h"
#import "SchoolClassModel.h"
#import "HeiHei.h"
#import "NSString+AES.h"
#import "AFNetworking.h"

@interface YMSOpenNotifyDownView : CardDownAnimationView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) SchoolClassModel *schoolClass;

-(void) getClassInfo;

@end
