//
//  LogoutLogic.m
//  MUST_Plus
//
//  Created by zbc on 17/1/7.
//  Copyright © 2017年 zbc. All rights reserved.
//

#import "LogoutLogic.h"
#import "MessageCircle_main+CoreDataClass.h"
#import "MyClass+CoreDataClass.h"
#import "MyGrade+CoreDataClass.h"

@implementation LogoutLogic

+(void) deleteALL{
    AppDelegate* myAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSError* error=nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request = [NSFetchRequest fetchRequestWithEntityName:@"MessageCircle_main"];
    NSMutableArray* mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
        
    }
    else{
        for (MessageCircle_main* SchoolAnnounces in mutableFetchResult) {
            [myAppDelegate.managedObjectContext deleteObject:SchoolAnnounces];
        }
        BOOL isSaveSuccess=[myAppDelegate.managedObjectContext save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error:%@",error);
            return;
        }else{
            NSLog(@"delete successful!");
        }
    }
    
    
    request = [NSFetchRequest fetchRequestWithEntityName:@"MyClass"];
    mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
        
    }
    else{
        for (MyClass* a in mutableFetchResult) {
            [myAppDelegate.managedObjectContext deleteObject:a];
        }
        BOOL isSaveSuccess=[myAppDelegate.managedObjectContext save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error:%@",error);
            return;
        }else{
            NSLog(@"delete successful!");
        }
    }
    
    
    request = [NSFetchRequest fetchRequestWithEntityName:@"MyGrade"];
    mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
        
    }
    else{
        for (MyGrade* b in mutableFetchResult) {
            [myAppDelegate.managedObjectContext deleteObject:b];
        }
        BOOL isSaveSuccess=[myAppDelegate.managedObjectContext save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error:%@",error);
            return;
        }else{
            NSLog(@"delete successful!");
        }
    }
    
    
    request = [NSFetchRequest fetchRequestWithEntityName:@"MyClass"];
    mutableFetchResult=[[myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
        
    }
    else{
        for (MyClass* c in mutableFetchResult) {
            [myAppDelegate.managedObjectContext deleteObject:c];
        }
        BOOL isSaveSuccess=[myAppDelegate.managedObjectContext save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error:%@",error);
            return;
        }else{
            NSLog(@"delete successful!");
        }
    }
    
    
    NSString *appDomaion = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomaion];
}


@end
