//
//  ViewController.h
//  UserManagement
//
//  Created by innoplexus india on 06/12/16.
//  Copyright © 2016 innoplexus india. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

//Protocol
@protocol SendDataProtocol <NSObject>
-(void)sendDataToAddUser:(User *)userDict;
@end

//User List ViewController
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//IBOutlets
@property (strong, nonatomic) IBOutlet UITableView *userListTableview;

//IBActions
- (IBAction)backButtonAction:(id)sender;

//Exposed Properties (protocol delegate)
@property(nonatomic,assign)id<SendDataProtocol> delegate;

@end

