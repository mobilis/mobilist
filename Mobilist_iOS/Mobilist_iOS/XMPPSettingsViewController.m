//
//  XMPPSettingsViewController.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "XMPPSettingsViewController.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface XMPPSettingsViewController ()
{
	UITextField* currentlyEditingTextField;
	int distanceByWhichViewIsCurrentlyMovedUp;
}
@end

@implementation XMPPSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage* bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
															 pathForResource:@"light_toast" ofType:@"png"]];
		self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
		
		//[scrollView setContentSize:[[self view] frame].size];
		UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
		[scrollView addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[jabberIDTextField setDelegate:self];
	[passwordTextField setDelegate:self];
	[serviceTextField setDelegate:self];
	[hostnameTextField setDelegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	currentlyEditingTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	currentlyEditingTextField = nil;
}

- (void)keyboardWillShow:(NSNotification* )notification {
	if (!currentlyEditingTextField) {
		return;
	}
	
	NSDictionary* userInfo = [notification userInfo];
	CGRect keyboardOriginalFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	CGRect keyboardTranslatedFrame = [[self view] convertRect:keyboardOriginalFrame toView:nil];
	int keyboardHeight = keyboardTranslatedFrame.size.height;
	
	CGRect viewOriginalFrame = [[self view] frame];
	CGRect viewTranslatedFrame = [[self view] convertRect:viewOriginalFrame toView:nil];
	int viewHeight = viewTranslatedFrame.size.height;
	int upperKeyboardEdge = viewHeight - keyboardHeight;
	int lowerTextFieldEdge = currentlyEditingTextField.frame.origin.y + currentlyEditingTextField.frame.size.height;
	
	if (lowerTextFieldEdge > upperKeyboardEdge)
    {
		int moveDistance = lowerTextFieldEdge - upperKeyboardEdge + 5;
		
        [self setViewMovedUp:YES byDistance:moveDistance];
		distanceByWhichViewIsCurrentlyMovedUp = moveDistance;
    }
}

- (void)keyboardWillHide:(NSNotification* )notification {
	[self setViewMovedUp:NO byDistance:distanceByWhichViewIsCurrentlyMovedUp];
	distanceByWhichViewIsCurrentlyMovedUp = 0;
}

- (void)setViewMovedUp:(BOOL)movedUp
			byDistance:(NSInteger )distance {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
	
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= distance;
        rect.size.height += distance;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += distance;
        rect.size.height -= distance;
    }
    self.view.frame = rect;
	
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[jabberIDTextField setText:[userDefaults stringForKey:UserDefaultJabberId]];
	[passwordTextField setText:[userDefaults stringForKey:UserDefaultPassword]];
	[hostnameTextField setText:[userDefaults stringForKey:UserDefaultHostname]];
	[serviceTextField setText:[userDefaults stringForKey:UserDefaultMobilistService]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:[jabberIDTextField text] forKey:UserDefaultJabberId];
	[userDefaults setObject:[passwordTextField text] forKey:UserDefaultPassword];
	[userDefaults setObject:[hostnameTextField text] forKey:UserDefaultHostname];
	[userDefaults setObject:[serviceTextField text] forKey:UserDefaultMobilistService];
	
	[userDefaults synchronize];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardDidShowNotification
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardDidHideNotification
												  object:nil];
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
