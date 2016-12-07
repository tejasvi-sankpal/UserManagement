//
//  UserListTableViewCell.h
//  UserManagement
//
//  Created by innoplexus india on 06/12/16.
//  Copyright © 2016 innoplexus india. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userDOB;
@property (strong, nonatomic) IBOutlet UILabel *userContactNo;

@end
