//
//  XMPPSettingsViewController.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "MobiAppDelegate.h"

@interface XMPPSettingsViewController : UIViewController <UITextFieldDelegate>
{
	__weak IBOutlet UITextField *jabberIDTextField;
	__weak IBOutlet UITextField *passwordTextField;
	__weak IBOutlet UITextField *coordinatorTextField;
	__weak IBOutlet UITextField *hostnameTextField;
	__weak IBOutlet UITextField *serviceNamespaceTextField;
	__weak IBOutlet UITextField *portTextField;
	__weak IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, copy) void (^dismissBlock)(void);

- (IBAction)backgroundTapped:(id)sender;

@end
