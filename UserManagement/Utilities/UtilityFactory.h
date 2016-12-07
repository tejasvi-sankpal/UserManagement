//
//  UtilityFactory.h
//  UserManagement
//
//  Created by innoplexus india on 06/12/16.
//  Copyright © 2016 innoplexus india. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UtilityFactory : NSObject

//Method for showing alert
+(UIAlertController *)createAlertWithTitle:(NSString*)alertTitle withMessage:(NSString*)alertMessage withActions:(NSArray*)actionsArr;

@end
