//
//  ViewController.m
//  UserManagement
//
//  Created by innoplexus india on 06/12/16.
//  Copyright © 2016 innoplexus india. All rights reserved.
//

#import "ViewController.h"
#import "AddUserViewController.h"
#import "UIColor+UserAdditions.h"
#import "UserListTableViewCell.h"
#import "AppDelegate.h"
#import "User.h"




@interface ViewController ()

//Array for holding user Records
@property(nonatomic,strong)NSMutableArray *userListArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set Nav Bar colors
    [self.navigationController.navigationBar setBarTintColor:[UIColor loginNavThemeColor]];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor loginNavTextColor] forKey:NSForegroundColorAttributeName];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //Fetch User Records from core data
    _userListArray = [[NSMutableArray alloc]init];
    [self fetchUserDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview Datasource and Dekegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_userListArray) {
        return [_userListArray count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"UserListCell";
    
    //Set up User Cell
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UserListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.profilePic.layer.masksToBounds = YES;
    cell.profilePic.layer.cornerRadius = 22.0;
    
    User *currentUser = [_userListArray objectAtIndex:indexPath.row];
    cell.userName.text = currentUser.userName;
    cell.userDOB.text = [NSString stringWithFormat:@"Birth date : %@",currentUser.birthDate];
    cell.userContactNo.text = [NSString stringWithFormat:@"Mobile no : %@",currentUser.mobileNo];
    UIImage *userImage = [UIImage imageWithData:currentUser.profilePic];
    cell.profilePic.image = userImage;
    NSLog(@"userid = %@",currentUser.userId);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Send data to add user screen for updation.
    [_delegate sendDataToAddUser:[_userListArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark Method to Fetch User Details from Core data
-(void)fetchUserDetails{
    NSManagedObjectContext *moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Fetch the records and handle an error
    NSError *error;
    _userListArray = [[moc executeFetchRequest:request error:&error] mutableCopy];
    if (!self.userListArray) {
        NSLog(@"Failed to load users from disk");
    }else{
        [_userListTableview reloadData];
    }
}

#pragma mark IBActions
- (IBAction)backButtonAction:(id)sender {
    //Navigate to back screen
    [self.navigationController popViewControllerAnimated:YES];
}
@end
