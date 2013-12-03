//
//  XMPPSettingsViewController.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "XMPPSettingsViewController.h"

@interface XMPPSettingsViewController ()
{
	UITextField* currentlyEditingTextField;
	int distanceByWhichViewIsCurrentlyMovedUp;
}

@property (weak, nonatomic) IBOutlet UITextField *hostNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *jabberIDTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *serviceNamespaceTextField;

- (IBAction)backgroundTapped:(id)sender;

@end

@implementation XMPPSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage* bgImage =
			[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"light_toast"
																			 ofType:@"png"]];
		self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
		
		[self.scrollView setContentSize:[[self view] frame].size];
		UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
																					action:@selector(backgroundTapped:)];
		[self.scrollView addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.jabberIDTextField setDelegate:self];
	[self.passwordTextField setDelegate:self];
	[self.hostNameTextField setDelegate:self];
	[self.serviceNamespaceTextField setDelegate:self];
	[self.portTextField setDelegate:self];
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
	[self.jabberIDTextField setText:[userDefaults stringForKey:UserDefaultJabberId]];
	[self.passwordTextField setText:[userDefaults stringForKey:UserDefaultPassword]];
	[self.hostNameTextField setText:[userDefaults stringForKey:UserDefaultHostname]];
	[self.serviceNamespaceTextField setText:[userDefaults stringForKey:UserDefaultServiceNamespace]];
	[self.portTextField setText:[userDefaults stringForKey:UserDefaultPort]];
	
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
	[userDefaults setObject:[self.jabberIDTextField text] forKey:UserDefaultJabberId];
	[userDefaults setObject:[self.passwordTextField text] forKey:UserDefaultPassword];
	[userDefaults setObject:[self.hostNameTextField text] forKey:UserDefaultHostname];
	[userDefaults setObject:[self.serviceNamespaceTextField text] forKey:UserDefaultServiceNamespace];
	[userDefaults setObject:[self.portTextField text] forKey:UserDefaultPort];
	
	[userDefaults synchronize];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardDidShowNotification
												  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardDidHideNotification
												  object:nil];
	
	NSString* jabberIdFromDefaults = [userDefaults stringForKey:UserDefaultJabberId];
	NSString* passwordFromDefaults = [userDefaults stringForKey:UserDefaultPassword];
	NSString* serviceNamespaceFromDefaults = [userDefaults stringForKey:UserDefaultServiceNamespace];
	
	MobiAppDelegate* appDelegate = (MobiAppDelegate*) [[UIApplication sharedApplication] delegate];
	[appDelegate setAreXMPPSettingsSufficient:[appDelegate isSufficientJabberID:jabberIdFromDefaults
																	   password:passwordFromDefaults
															   serviceNamespace:serviceNamespaceFromDefaults]];
	
	self.dismissBlock();
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
