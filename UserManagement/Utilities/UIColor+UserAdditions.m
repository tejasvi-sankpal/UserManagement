//
//  UIColor+UserAdditions.m
//  UserManagement
//
//  Created by innoplexus india on 06/12/16.
//  Copyright © 2016 innoplexus india. All rights reserved.
//

#import "UIColor+UserAdditions.h"

@implementation UIColor (UserAdditions)

//Light Gray
+ (UIColor*)loginNavThemeColor{
    UIColor* navigationBarColor = [UIColor colorWithRed:(float)26/255 green:(float)145/255 blue:(float)142/255 alpha:1.0];
    //rgb 68 74 89
    
    return navigationBarColor;
}

//White
+ (UIColor*)loginNavTextColor{
    UIColor* loginNavTextColor = [UIColor whiteColor];
    return loginNavTextColor;
}

@end
