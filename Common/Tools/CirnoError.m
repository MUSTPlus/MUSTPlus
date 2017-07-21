//
//  CirnoError.m
//  MUST_Plus
//
//  Created by Cirno on 10/12/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "CirnoError.h"
#import "Alert.h"
@implementation CirnoError
+(void) ShowErrorWithText:(NSString*)text{
    Alert *alert = [[Alert alloc]initWithTitle:NSLocalizedString(@"错误", "")
                                       message:text
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"好", nil)
                             otherButtonTitles:nil, nil];
    alert.contentAlignment = NSTextAlignmentLeft;

    [alert show];
    
};
@end
