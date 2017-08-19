//
//  AppDelegate.h
//  MUST_Plus
//
//  Created by zbc on 16/10/2.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "JPUSHService.h"
#import "MTA.h"
#import "MTAConfig.h"
#import <RongIMKit/RongIMKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,JPUSHRegisterDelegate,RCIMUserInfoDataSource>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@end

