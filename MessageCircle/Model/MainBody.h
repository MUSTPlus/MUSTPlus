//
//  MainBody.h
//  MUST_Plus
//
//  Created by Cirno on 06/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Comments.h"
#import "ImageSet.h"
#import "UserModel.h"
@interface MainBody : NSObject
@property (nonatomic,strong) NSString * avatarURL;
@property (nonatomic,strong) UserModel* usermodel;
@property (nonatomic,strong) NSString * time;
@property (nonatomic,strong) NSString * context;
@property (nonatomic,strong) NSString * device;
@property (nonatomic,strong) NSString * location;
@property (nonatomic,strong) NSString * studentID;

@property (nonatomic) NSInteger* likes;
@property (nonatomic) long long ID;//唯一标识符
@property (nonatomic) ImageSet* imageSets;
@property (nonatomic) Comments* comments;
@property (nonatomic) BOOL      isTop;
@property (nonatomic) BOOL      isLiked;

-(void) initAvatarURL:(NSString*)avatarURL
            StudentID:(NSString *)studentID
            UserModel:(UserModel*)usermodel
              Time:(NSString*)time
           Context:(NSString*)context
            Device:(NSString*)device
          Location:(NSString*)location
             Likes:(NSInteger*)likes
                ID:(long long)IDs
          Comments:(Comments*)comments
         imageSets:(ImageSet*)imagesets
             isTop:(BOOL)top
           isLiked:(BOOL)isLiked;
@end
