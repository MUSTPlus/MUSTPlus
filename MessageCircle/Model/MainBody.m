//
//  MainBody.m
//  MUST_Plus
//
//  Created by Cirno on 06/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "MainBody.h"

@implementation MainBody





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
              isLiked:(BOOL)isLiked{
    self.studentID = studentID;
    self.ID        = IDs;
    self.avatarURL = avatarURL;
    self.usermodel = usermodel;
    self.time      = time;
    self.context   = context;
    self.device    = device;
    self.location  = location;
    self.likes     = likes;
    self.comments  = comments;
    self.imageSets = imagesets;
    self.isTop     = top;
    self.isLiked = isLiked;
}

@end
