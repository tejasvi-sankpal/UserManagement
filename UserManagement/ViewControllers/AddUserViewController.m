//
//  AddUserViewController.m
//  UserManagement
//
//  Created by innoplexus india on 06/12/16.
//  Copyright © 2016 innoplexus india. All rights reserved.
//

#import "AddUserViewController.h"
#import "UIColor+UserAdditions.h"
#import "AppDelegate.h"
#import "UtilityFactory.h"
#import "ViewController.h"
#import "User.h"


@interface AddUserViewController (){
    User *currentSelectedUser;
}

@property(nonatomic) BOOL isDataReceived;


@end

@implementation AddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_addUserButtonProp setTitle:@"Submit" forState:UIControlStateNormal];
    
    //Set Up Nav Bar Colors
    [self.navigationController.navigationBar setBarTintColor:[UIColor loginNavThemeColor]];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor loginNavTextColor] forKey:NSForegroundColorAttributeName];
    _isDataReceived = FALSE;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if (_isDataReceived) {
        //UPDate Mode
         self.navigationItem.title = @"Update User";
        [_addUserButtonProp setTitle:@"Update" forState:UIControlStateNormal];
    }else{
        //Submit Mode
        self.navigationItem.title = @"Add User";
        [_addUserButtonProp setTitle:@"Submit" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark IBActions

//AddUserAction
- (IBAction)addUserAction:(id)sender {
    
    //Validate User Data
    if(![self validateUserData]){
        return;
    }
    
    if ([_addUserButtonProp.titleLabel.text isEqualToString:@"Submit"]) {
        [self addUser];
    }else  if ([_addUserButtonProp.titleLabel.text isEqualToString:@"Update"]){
        [self updateUser];
    }
    
}

//Method to validate User Data
-(BOOL)validateUserData{
    
    UIImage *sampleimage = _profileImageView.image;
    
    NSData *dataImage = UIImageJPEGRepresentation(sampleimage, 0.0);
    
    UIImage *defaultImage = [UIImage imageNamed:@"defualtUser"];
     NSData *defaultDataImage = UIImageJPEGRepresentation(defaultImage, 0.0);

    
    NSInteger Counter = 0 ;
    NSString *alertMessage ;
    
    if ( _userNameTextfield.text == nil || ([_userNameTextfield.text length]<= 0) || ([_userNameTextfield.text isEqualToString:@""])) {
        Counter = Counter + 1;
        alertMessage = @"Please enter user name.";
    }else if( _userDOBTextfield.text == nil || ([_userDOBTextfield.text length]<= 0) || ([_userDOBTextfield.text isEqualToString:@""])){
        Counter = Counter + 1;
        alertMessage = @"Please enter user birth date.";
    }else if(![self isValidateDOB:_userDOBTextfield.text]){
        Counter = Counter + 1;
        alertMessage = @"Please enter a valid birth date.";
    }else if( _userMobileNoTextfield.text == nil || ([_userMobileNoTextfield.text length]<= 0) || ([_userMobileNoTextfield.text isEqualToString:@""])){
        Counter = Counter + 1;
        alertMessage = @"Please enter user mobile no.";
    }else if((_userMobileNoTextfield.text.length < 10) || (_userMobileNoTextfield.text.length > 10)){
        Counter = Counter + 1;
        alertMessage = @"Please enter a valid mobile no.";
    }else if(![self validateNumericString:_userMobileNoTextfield.text]){
        Counter = Counter + 1;
        alertMessage = @"Please enter a valid mobile no.";
    }
    
    if(Counter == 0){
        return true;
    }
    
    if (Counter > 1) {
        alertMessage = @"Please enter all the mandatory fields.";
    }
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                               }];
    
    [self presentViewController:[UtilityFactory createAlertWithTitle:@"Warning!" withMessage:alertMessage withActions:[NSArray arrayWithObjects:okAction, nil]] animated:YES completion:nil];
    
    
    return false;

    
}

//Check for numeric String
-(BOOL)validateNumericString:(NSString*)inputString{
    inputString = [inputString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

//Validation for birth date
-(BOOL) isValidateDOB:(NSString *) dateOfBirth
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    [format setDateFormat:@"dd/MM/yy"];
    NSDate *validateDOB = [format dateFromString:dateOfBirth];
    if (validateDOB != nil)
        return YES;
    else
        return NO;
}

//ADD New user
-(void)addUser{
    
    UIImage *sampleimage = _profileImageView.image;
    
    NSData *dataImage = UIImageJPEGRepresentation(sampleimage, 0.0);
    
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = ad.managedObjectContext;
    
    // Create a new managed object
    NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    [newUser setValue:self.userNameTextfield.text forKey:@"userName"];
    [newUser setValue:self.userDOBTextfield.text forKey:@"birthDate"];
    [newUser setValue:self.userMobileNoTextfield.text forKey:@"mobileNo"];
    [newUser setValue:dataImage forKey:@"profilePic"];
    [newUser setValue:[NSString stringWithFormat:@"%ld",(long)[self getMaxUserID]] forKey:@"userId"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                    [self resetAllFields];
                                   ViewController* userVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"HomeVC"];
                                   userVC.delegate = self;
                                   [self.navigationController pushViewController:userVC animated:YES];
                                   
                               }];
    
    
    [self presentViewController:[UtilityFactory createAlertWithTitle:@"Success!" withMessage:@"User added successfully." withActions:[NSArray arrayWithObjects:okAction, nil]] animated:YES completion:nil];
    
}

//Update Existing User
-(void)updateUser{
    
    UIImage *sampleimage = _profileImageView.image;
    
    NSData *dataImage = UIImageJPEGRepresentation(sampleimage, 0.0);
    
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = ad.managedObjectContext;
    
    User *selectedUser = [self getPerticularUserwithUserDetails:currentSelectedUser];
    
    // Create a new managed object
   // NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    [selectedUser setValue:self.userNameTextfield.text forKey:@"userName"];
    [selectedUser setValue:self.userDOBTextfield.text forKey:@"birthDate"];
    [selectedUser setValue:self.userMobileNoTextfield.text forKey:@"mobileNo"];
    [selectedUser setValue:dataImage forKey:@"profilePic"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self resetAllFields];
                                   ViewController* userVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"HomeVC"];
                                   userVC.delegate = self;
                                   [self.navigationController pushViewController:userVC animated:YES];
                                   
                               }];
    
    
    [self presentViewController:[UtilityFactory createAlertWithTitle:@"Success!" withMessage:@"User updated successfully." withActions:[NSArray arrayWithObjects:okAction, nil]] animated:YES completion:nil];
    
}

//Cancel User Action
- (IBAction)cancelUserAction:(id)sender {
    [self resetAllFields];
}

//Change ProfilePic Action
- (IBAction)changeProfilePicAction:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
        
        
        [self presentViewController:[UtilityFactory createAlertWithTitle:@"Error" withMessage:@"Device has no camera" withActions:[NSArray arrayWithObjects:okAction, nil]] animated:YES completion:nil];
    }else{
    
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            NSLog(@"action Cancel");
            
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // Distructive button tapped.
            NSLog(@"action Take Photo");
            
            [self takePhotoAction];
            
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Select Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // Distructive button tapped.
            NSLog(@"action Select Photo");
            
            [self selectPhotoAction];
            
        }]];
        
        
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

//Take Photo from Camera
-(void)takePhotoAction{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

//Select any Photo from Gallary
-(void)selectPhotoAction{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark UIImagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark SendDataProtocol Method
-(void)sendDataToAddUser:(User *)userDict{
    
    _isDataReceived = TRUE;
    
    [_addUserButtonProp setTitle:@"Update" forState:UIControlStateNormal];
    
    NSLog(@"userDict = %@",userDict);
    
    currentSelectedUser = userDict;
    
    User *selectedUser = [self getPerticularUserwithUserDetails:userDict];
    
    if (selectedUser) {
        _userNameTextfield.text = selectedUser.userName;
        _userDOBTextfield.text = selectedUser.birthDate;
        _userMobileNoTextfield.text = selectedUser.mobileNo;
        UIImage *userImage = [UIImage imageWithData:selectedUser.profilePic];
        _profileImageView.image = userImage;

    }
    
}

#pragma mark Textfield Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _userNameTextfield) {
        [_userDOBTextfield becomeFirstResponder];
    }else if (textField == _userDOBTextfield) {
        [_userMobileNoTextfield becomeFirstResponder];
    }else if (textField == _userMobileNoTextfield) {
        [_userMobileNoTextfield resignFirstResponder];
    }
    return true;
}

#pragma mark Methods to handle all operations with core data
-(User *)getPerticularUserwithUserDetails:(User *)currentUser{
    
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = ad.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", currentUser.userId];
    [request setPredicate:predicate];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    
    NSError *error = nil;
    NSArray *selectedUserArray = [context executeFetchRequest:request error:&error];
    User *selectedUser;
    if (selectedUserArray && [selectedUserArray count] > 0) {
        selectedUser = [selectedUserArray objectAtIndex:0];
    }
   
    return selectedUser;
    
}

- (NSInteger) getMaxUserID
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = ad.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *res = [NSEntityDescription entityForName:@"User"
                                           inManagedObjectContext:context];
    [request setEntity:res];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userId" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    [request setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (results == nil) {
        NSLog(@"error fetching the results: %@",error);
    }
    
    NSInteger maximumValue = 0;
    if (results.count == 1) {
        User *user = (User *)[results objectAtIndex:0];
        maximumValue =  [user.userId integerValue];
    }
    return maximumValue + 1;
}

#pragma mark Methods to clear all fields
-(void)resetAllFields{
    self.userNameTextfield.text = @"";
    self.userDOBTextfield.text = @"";
    self.userMobileNoTextfield.text = @"";
    self.profileImageView.image = [UIImage imageNamed:@"defualtUser"];
    _isDataReceived = false;
}

@end
