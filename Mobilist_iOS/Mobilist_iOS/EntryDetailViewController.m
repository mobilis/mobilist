//
//  EntryDetailViewController.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 26.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "EntryDetailViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface EntryDetailViewController ()

@property (weak, nonatomic) IBOutlet UIControl *contentView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDatePicker;

@end

@implementation EntryDetailViewController

- (id)initForNewEntry:(BOOL)isNew {
	self = [super initWithNibName:@"EntryDetailViewController" bundle:nil];
	
    if (self) {
		_isForNewItem = isNew;
		
		if (isNew) {
			UIBarButtonItem* saveBarButtonItem = [[UIBarButtonItem alloc]
				initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = saveBarButtonItem;
			
			UIBarButtonItem* cancelBarButtonItem = [[UIBarButtonItem alloc]
				initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
		}
    }
	
    return self;
}

- (id)init {
	return [self initForNewEntry:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
								   reason:@"Use initForNewItem"
								 userInfo:nil];
	return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage* bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                         pathForResource:@"light_toast" ofType:@"png"]];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    [self.descriptionTextField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.descriptionTextField.layer setBorderWidth:1.0];
    self.descriptionTextField.layer.cornerRadius = 5.0;
    self.descriptionTextField.clipsToBounds = YES;
    
	[self.titleTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.titleTextField setText:[self.entry title]];
	[self.descriptionTextField setText:[self.entry description]];
	
	NSDate* dueDate = [self.entry dueDateAsDate];
	if ([self.entry dueDate] != 0) {
		[self.dueDatePicker setDate:dueDate];
	} else {
		[self.dueDatePicker setDate:[NSDate date]];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[self view] endEditing:YES];
	
	if (!_isForNewItem) {
		[self.entry setTitle:[self.titleTextField text]];
		[self.entry setDescription:[self.descriptionTextField text]];
		[self.entry setDueDate:[[self.dueDatePicker date] timeIntervalSince1970]];
		
		EditEntryRequest* request = [[EditEntryRequest alloc] init];
		[request setListId:[self.parent listId]];
		[request setEntry:self.entry];
		[[MXiConnectionHandler sharedInstance].connection sendBean:request];
		
		[[MobiListStore sharedStore] setSyncedStatus:NO
										  forEntryId:[self.entry entryId]];
	}
}

- (void)viewDidLayoutSubviews
{
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.topLayoutGuide.length;
    self.contentView.frame = frame;
}

- (NSString *)title
{
    return _isForNewItem ? @"New ToDo" : @"Edit ToDo";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save:(id)sender {
	[[self navigationController] dismissViewControllerAnimated:YES completion:self.dismissBlock];
	
	[self.entry setTitle:[self.titleTextField text]];
	[self.entry setDescription:[self.descriptionTextField text]];
	[self.entry setDueDate:[[self.dueDatePicker date] timeIntervalSince1970]];
	[self.entry setDone:NO];
	
	CreateEntryRequest* request = [[CreateEntryRequest alloc] init];
	[request setListId:[self.parent listId]];
	[request setEntry:self.entry];
	[[MXiConnectionHandler sharedInstance].connection sendBean:request];
	
	[[MobiListStore sharedStore] setSyncedStatus:NO
									  forEntryId:[self.entry entryId]];
}

- (void)cancel:(id)sender {
	[self.parent removeListEntry:self.entry];
	[[self navigationController] dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (IBAction)backgroundTapped:(id)sender {
	[[self view] endEditing:YES];
}

@end
