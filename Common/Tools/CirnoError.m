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
    UIAlertController* dummy = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"错误", "")
                                                                    message:text
                                                             preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* action = [UIAlertAction actionWithTitle:NSLocalizedString(@"好", nil)
                                                    style:UIAlertActionStyleCancel
                                                  handler:nil];
                           [dummy addAction:action];
   [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:dummy animated:YES completion:^{}];
    
};
@end
