//
//  AppDelegate.m
//  MUST_Plus
//
//  Created by zbc on 16/10/2.
//  Copyright © 2016年 zbc. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wprotocol"
#pragma clang diagnostic ignored "-Wvector-conversion"
#pragma clang diagnostic ignored "-Wdocumentation"
#import "AppDelegate.h"
#import "WSGetWifi.h"
#import "NSString+AES.h"
#import "HeiHei.h"
#import <AFNetworking.h>
#import "schoolTimetableViewController.h"
#import "CirnoError.h"
#import "CurrencyViewController.h"
#import "WSGetPhoneTypeController.h"
#import "CirnoSideBarViewController.h"
#import "BusStationViewController.h" //公交车页面
#import "Alert.h"
#import "BasicHead.h"
#import <Bugly/Bugly.h>
#import <JSPatchPlatform/JSPatch.h>
#import "MessageController.h"
#import <UserNotifications/UserNotifications.h>

#import <Google/Analytics.h>


@import CoreLocation;

@interface AppDelegate ()<JPUSHRegisterDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation AppDelegate





- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段
     * nil 表示该启动事件不包含来自融云的推送服务
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);

    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

//iOS 7 Remote Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:  (NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"userinfo=%@",userInfo);
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];

    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");

    } else {

    }

    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSString *attendance = [userInfo valueForKey:@"attendance"];
    if (attendance!=NULL){
        [self gotoAttendance];

    }
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    if (application.applicationState == UIApplicationStateActive) {
        Alert *alert = [[Alert alloc]initWithTitle:@"提醒" message:content delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", "") otherButtonTitles: nil];
        [alert show];
    }
    else if(application.applicationState == UIApplicationStateInactive)
    {
        Alert *alert = [[Alert alloc]initWithTitle:@"提醒" message:content delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", "") otherButtonTitles: nil];
        [alert show];

    }
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[RCIM sharedRCIM]setUserInfoDataSource:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
    [[RCIM sharedRCIM] setGroupInfoDataSource:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
    [[RCIM sharedRCIM]setGroupUserInfoDataSource:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
    [[RCIM sharedRCIM]setGroupMemberDataSource:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
     [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [Bugly startWithAppId:@"62d853eb65"];
    [JSPatch startWithAppKey:@"0ce6d775096fc96e"];
    [JSPatch setupRSAPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHgDRAfslCfgURdHAZomQNO52w\nIfHcrhNvmW71DW0GEm21UAUMmTuJs8WbcbDu5nm2/nfExoqQeYATHKVS8glTD36n\nzBTDesfhp4LrmwXUa2kcBeqB9UPdiDyYVuSWHjaVFL73XOAVKTqd/BiEHUCi/xva\no9/TJUTYF+4IAzE7rwIDAQAB\n-----END PUBLIC KEY-----"];
    [JSPatch showDebugView];
    [JSPatch setupDevelopment];
    [JSPatch sync];

    [MTA startWithAppkey:@"ID3AH61T1FZG"];
    [JPUSHService setupWithOption:launchOptions appKey:@"d77ddc38172301d4deec5703"
                          channel:@"mustPlus"
                 apsForProduction:1
            advertisingIdentifier:nil];

    if([[NSUserDefaults standardUserDefaults] valueForKey:@"deviceID"] == nil){
        NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
        NSMutableString *s = [NSMutableString stringWithCapacity:20];
        for (NSUInteger i = 0U; i < 40; i++) {
            u_int32_t r = arc4random() % [alphabet length];
            unichar c = [alphabet characterAtIndex:r];
            [s appendFormat:@"%C", c];
        }
        [[NSUserDefaults standardUserDefaults] setObject:s forKey:@"deviceID"];
    }
    else{
      //  NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceID"]);
    }

    // Google Start ...
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];

    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);

    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-104938440-1"];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release

    // Google End ...

    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
   // MessageController* next = [[MessageController alloc]init];
    UIViewController *next  = [[UIViewController alloc] init];

    if([[Account shared]getPassword] != nil && [[Account shared]getStudentLongID] != nil){
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        next = [storyBoard instantiateViewControllerWithIdentifier:@"Root"];
    }
    else{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        next = [storyBoard instantiateViewControllerWithIdentifier:@"Login"];
    }

    UINavigationController * navCtrl = [[UINavigationController alloc]initWithRootViewController:next];
    navCtrl.navigationBarHidden = YES;
  //  navCtrl.hidesBottomBarWhenPushed=YES;
    [self.window setFrame:[UIScreen mainScreen].bounds];

    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];


    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [MTA trackActiveBegin];
};
- (void)applicationWillResignActive:(UIApplication *)application{
    [MTA trackActiveEnd];

};
-(void)actionWithShortcutItem:(UIApplicationShortcutItem *)item
{
  //  [CirnoError ShowErrorWithText:item.type];
    if ([item.type isEqualToString:@"bus"]){
        BusStationViewController *controller = [[BusStationViewController alloc] init];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:passcodeNavigationController animated:YES completion:^{}];
    } else if ([item.type isEqualToString:@"currency"]){
        // [CirnoError ShowErrorWithText:[url absoluteString]];
        CurrencyViewController * cvc = [[CurrencyViewController alloc]init];
        cvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:cvc];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:nc animated:YES completion:^{}];
    }
}
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler
{
    if (shortcutItem)
    {
        [self actionWithShortcutItem:shortcutItem];
    }

    if (completionHandler)
    {
        completionHandler(YES);
    }
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   // NSLog(@"urlis %@",url);
    [CirnoError ShowErrorWithText:[url absoluteString]];
    if ([[url absoluteString]isEqualToString:@"mustplus://currency"]){
        CurrencyViewController * cvc = [[CurrencyViewController alloc]init];
        cvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:cvc];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:nc animated:YES completion:^{}];
    }
    if ([[url absoluteString]isEqualToString:@"mustplus://bus"]){
        BusStationViewController *controller = [[BusStationViewController alloc] init];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:passcodeNavigationController animated:YES completion:^{}];
    }


    return NO;
}

- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
     [JPUSHService registerDeviceToken:deviceToken];
    /** 融云 **/
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];

    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}
-(void)gotoAttendance{
    AttendanceViewController* controller = [[AttendanceViewController alloc]init];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:passcodeNavigationController animated:YES completion:^{}];
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required

    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([userInfo valueForKey:@"attendance"]!=NULL){
        [self gotoAttendance];
    }
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}




- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}



- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

-(void)applicationDidFinishLaunching:(UIApplication *)application{
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:95.0/255.0 green:167.0/255.0 blue:241.0/255.0 alpha:1]];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "zhangbingchuan.MUSTBEE" in the application's documents directory.
    
    

    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.MUST_Plus"];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MUST_Plus" withExtension:@"momd"];
//
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MUST_Plus" withExtension:@"momd"];
   // NSLog(@"%@",modelURL);

    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MUST_Plus.sqlite"];
    

    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {

    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}



#pragma mark -融云
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    if ([userId hasPrefix:@"ADMIN"]){
        RCUserInfo* userinfo = [[RCUserInfo alloc]initWithUserId:userId
                                                            name:@"系统消息"
                                                        portrait:@"https://must.plus/logo.jpg"];
        return completion(userinfo);
    }
    if ([userId hasPrefix:@"GROUPADMIN"]){
        RCUserInfo* userinfo = [[RCUserInfo alloc]initWithUserId:userId
                                                            name:@"系统消息"
                                                        portrait:@"https://must.plus/logo.jpg"];
        return completion(userinfo);
    }
    NSDictionary *o1 =@{@"ec":@"1032",
                        @"studentID":userId};

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    NSDictionary *parameters = @{@"ec":data};

    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if([json[@"state"] isEqualToString:@"1"]){
            @try {
                NSDictionary *newjson = json[@"info"];
                RCUserInfo* userinfo = [[RCUserInfo alloc]initWithUserId:[newjson objectForKey:@"studentID"]
            name:[newjson objectForKey:@"nickName"]
                                                                portrait:[newjson objectForKey:@"face"]];

                return completion(userinfo);

            } @catch (NSException *exception) {
                RCUserInfo* userinfo = [[RCUserInfo alloc]initWithUserId:userId
                                                                    name:@"未知用户"
                                                                portrait:@"https://must.plus/logo.jpg"];
                return completion(userinfo);
            }
            @finally{
            }
        }
        else{
            RCUserInfo* userinfo = [[RCUserInfo alloc]initWithUserId:userId
                                                                name:@"未知用户"
                                                            portrait:@"https://must.plus/logo.jpg"];
            return completion(userinfo);
        }

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        RCUserInfo* userinfo = [[RCUserInfo alloc]initWithUserId:userId
                                                            name:@"未知用户"
                                                        portrait:@"https://must.plus/logo.jpg"];
        return completion(userinfo);

    }];
    return completion(nil);


}

- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    NSDictionary *o1 =@{@"ec":@"5001",
                        @"groupid":groupId};

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    NSDictionary *parameters = @{@"ec":data};

    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json[@"state"]isEqualToString:@"1"]){
            RCGroup* group = [[RCGroup alloc]initWithGroupId:groupId groupName:json[@"ret"][@"name"] portraitUri:nil];
            return completion(group);
        } else{
            RCGroup* group = [[RCGroup alloc]initWithGroupId:groupId groupName:groupId portraitUri:nil];
            return completion(group);
        }
    }failure:^(NSURLSessionTask *operation, NSError *error){
        RCGroup* group = [[RCGroup alloc]initWithGroupId:groupId groupName:groupId portraitUri:nil];
        return completion(group);
    }];
    RCGroup* group = [[RCGroup alloc]initWithGroupId:groupId groupName:groupId portraitUri:nil];
    return completion(group);
}
- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))resultBlock{
    NSDictionary *o1 =@{@"ec":@"5002",
                        @"groupid":groupId};

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    NSDictionary *parameters = @{@"ec":data};

    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];
        NSMutableArray<NSString*>* r = [[NSMutableArray alloc]init];

        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json[@"state"]isEqualToString:@"1"]){
            id students = json[@"ret"];

            for (NSArray* stu in students)
                [r addObject:[NSString stringWithFormat:@"%@",stu[0]]];
            return resultBlock([r copy]);
        } else
            return resultBlock(nil);

    }failure:^(NSURLSessionTask *operation, NSError *error){
        NSLog(@"erroris%@",error);
        
    }];
    return resultBlock(nil);
}
-(void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId completion:(void (^)(RCUserInfo *))completion{
    if ([userId hasPrefix:@"ADMIN"]){
        RCUserInfo* userinfo = [[RCUserInfo alloc]initWithUserId:userId
                                                            name:@"系统消息"
                                                        portrait:@"https://must.plus/logo.jpg"];
        return completion(userinfo);
    }
    if ([userId hasPrefix:@"GROUPADMIN"]){
        RCUserInfo* userinfo = [[RCUserInfo alloc]initWithUserId:userId
                                                            name:@"系统消息"
                                                        portrait:@"https://must.plus/logo.jpg"];
        return completion(userinfo);
    }
    NSDictionary *o1 =@{@"ec":@"1032",
                        @"studentID":userId};

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:o1
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *secret = jsonString;
    NSString *data = [secret AES256_Encrypt:[HeiHei toeknNew_key]];
    NSDictionary *parameters = @{@"ec":data};

    NSURL *URL = [NSURL URLWithString:BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //转成最原始的data,一定要加
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];

    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSString *result = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] AES256_Decrypt:[HeiHei toeknNew_key]];

        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if([json[@"state"] isEqualToString:@"1"]){
            @try {
                NSDictionary *newjson = json[@"info"];
                RCUserInfo* userinfo = [[RCUserInfo alloc]initWithUserId:[newjson objectForKey:@"studentID"]
                                                                    name:[newjson objectForKey:@"nickName"]
                                                                portrait:[newjson objectForKey:@"face"]];

                return completion(userinfo);

            } @catch (NSException *exception) {
                RCUserInfo* userinfo = [[RCUserInfo alloc]initWithUserId:userId
                                                                    name:@"未知用户"
                                                                portrait:@"https://must.plus/logo.jpg"];
                return completion(userinfo);
            }
            @finally{
            }
        }
        else{
            RCUserInfo* userinfo = [[RCUserInfo alloc]initWithUserId:userId
                                                                name:@"未知用户"
                                                            portrait:@"https://must.plus/logo.jpg"];
            return completion(userinfo);
        }

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        RCUserInfo* userinfo = [[RCUserInfo alloc]initWithUserId:userId
                                                            name:@"未知用户"
                                                        portrait:@"https://must.plus/logo.jpg"];
        return completion(userinfo);
        
    }];
    return completion(nil);
}
#pragma mark -融云End


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
#pragma clang diagnostic pop
