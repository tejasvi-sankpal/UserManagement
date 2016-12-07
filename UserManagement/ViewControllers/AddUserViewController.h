//
//  AddUserViewController.h
//  UserManagement
//
//  Created by innoplexus india on 06/12/16.
//  Copyright © 2016 innoplexus india. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AddUserViewController : UIViewController<SendDataProtocol,UITextFieldDelegate,UIImagePickerControllerDelegate>

//IBOutlets
@property (strong, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *userDOBTextfield;
@property (strong, nonatomic) IBOutlet UITextField *userMobileNoTextfield;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIButton *changeProfilePicProp;
@property (strong, nonatomic) IBOutlet UIButton *addUserButtonProp;

//IBActions
- (IBAction)addUserAction:(id)sender;
- (IBAction)cancelUserAction:(id)sender;
- (IBAction)changeProfilePicAction:(id)sender;

@end
