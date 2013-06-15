//
//  XMPPSettingsViewController.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "XMPPSettingsViewController.h"

@interface XMPPSettingsViewController ()

@end

@implementation XMPPSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage* bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
															 pathForResource:@"light_toast" ofType:@"png"]];
		self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[jabberIDTextField setText:[userDefaults stringForKey:UserDefaultJabberId]];
	[passwordTextField setText:[userDefaults stringForKey:UserDefaultPassword]];
	[hostnameTextField setText:[userDefaults stringForKey:UserDefaultHostname]];
	[coordinatorServiceTextField setText:[userDefaults stringForKey:UserDefaultCoordinatorService]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:[jabberIDTextField text] forKey:UserDefaultJabberId];
	[userDefaults setObject:[passwordTextField text] forKey:UserDefaultPassword];
	[userDefaults setObject:[hostnameTextField text] forKey:UserDefaultHostname];
	[userDefaults setObject:[coordinatorServiceTextField text] forKey:UserDefaultCoordinatorService];
	
	[userDefaults synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTapped:(id)sender {
	[[self view] endEditing:YES];
}

@end
