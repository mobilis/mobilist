//
//  XMPPSettingsViewController.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface XMPPSettingsViewController : UIViewController
{
	__weak IBOutlet UITextField *jabberIDTextField;
	__weak IBOutlet UITextField *passwordTextField;
	__weak IBOutlet UITextField *coordinatorServiceTextField;
	__weak IBOutlet UITextField *hostnameTextField;
}

- (IBAction)backgroundTapped:(id)sender;

@end
