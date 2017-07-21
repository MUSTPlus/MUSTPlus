//
//  ButtonDock.h
//  MUST_Plus
//
//  Created by Cirno on 16/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//  三个按钮

#import <UIKit/UIKit.h>
#import "MainBody.h"
typedef enum {
    DockButtonTypeLike,
    DockButtonTypeComment,
    DockButtonTypeShare
} DockButtonType;
@protocol DockDelegate <NSObject>
-(void)optionDock:(long long)ID didClickType:(DockButtonType)type;//此ID即此条信息的唯一ID，自增

@end
@interface ButtonDock : UIView
@property(nonatomic, strong)MainBody* status;

@property(nonatomic, weak)id<DockDelegate> delegate;

-(void) selfDockStyle;
-(void) otherBttonStyle;

@end
