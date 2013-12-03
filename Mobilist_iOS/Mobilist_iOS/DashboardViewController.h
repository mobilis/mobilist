//
//  DashboardViewController.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "XMPPSettingsViewController.h"
#import "ListDetailViewController.h"
#import "TodoListCell.h"
#import "TodoListViewController.h"
#import "DeleteListRequest.h"
#import "MobiAppDelegate.h"
#import <MXiServiceManager.h>

@interface DashboardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MXiServiceManagerDelegate>

- (void)showXMPPSettingsView:(id)sender;
- (void)showCreateListView:(id)sender;

- (void)appIsConnected;

@end
