//
//  Comments.h
//  MUST_Plus
//
//  Created by Cirno on 07/10/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentDetails.h"
@interface Comments : NSObject
@property (nonatomic,strong) NSMutableArray<CommentDetails *>* comments;
-(int) countOfComments;
-(void) addCommentsDeatils:(CommentDetails*)details;
@end
