//
//  UtilityFactory.m
//  UserManagement
//
//  Created by innoplexus india on 06/12/16.
//  Copyright © 2016 innoplexus india. All rights reserved.
//

#import "UtilityFactory.h"

@implementation UtilityFactory

+(UIAlertController *)createAlertWithTitle:(NSString*)alertTitle withMessage:(NSString*)alertMessage withActions:(NSArray*)actionsArr{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:alertTitle
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    for (UIAlertAction *action in actionsArr) {
        [alertController addAction:action];
    }
    
    return alertController;
    
}


@end
