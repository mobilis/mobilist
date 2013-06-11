//
//  EntryDetailViewController.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 26.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "EntryDetailViewController.h"

@interface EntryDetailViewController ()

@end

@implementation EntryDetailViewController

@synthesize entry, dismissBlock, parent, connection;

- (id)initForNewEntry:(BOOL)isNew {
	self = [super initWithNibName:@"EntryDetailViewController" bundle:nil];
	
    if (self) {
		isForNewItem = isNew;
		
		UIImage* bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
															 pathForResource:@"light_toast" ofType:@"png"]];
		self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
		
		if (isNew) {
			[[self navigationItem] setTitle:@"New todo item"];
			
			UIBarButtonItem* doneItem = [[UIBarButtonItem alloc]
				initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
			[[self navigationItem] setRightBarButtonItem:doneItem];
			
			UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc]
				initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
			[[self navigationItem] setLeftBarButtonItem:cancelItem];
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
    
	[titleTextField becomeFirstResponder];
	
	// Make the text view look like a text field
	[descriptionTextField setBackgroundColor:[UIColor clearColor]];
	UIImageView* borderView = [[UIImageView alloc]
							   initWithFrame:CGRectMake(0, 0,
														descriptionTextField.frame.size.width, descriptionTextField.frame.size.height)];
	[borderView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
	UIImage* textFieldImage = [[UIImage imageNamed:@"text_view_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
	[borderView setImage:textFieldImage];
	[descriptionTextField addSubview:borderView];
	[descriptionTextField sendSubviewToBack:borderView];
	// TODO image doesn't grow along with the text view
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[titleTextField setText:[entry title]];
	[descriptionTextField setText:[entry description]];
	
	NSDate* dueDate = [entry dueDateAsDate];
	if ([entry dueDate] != 0) {
		[dueDatePicker setDate:dueDate];
	} else {
		[dueDatePicker setDate:[NSDate date]];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[self view] endEditing:YES];
	
	if (!isForNewItem) {
		[entry setTitle:[titleTextField text]];
		[entry setDescription:[descriptionTextField text]];
		[entry setDueDate:[[dueDatePicker date] timeIntervalSince1970]];
		
		EditEntryRequest* request = [[EditEntryRequest alloc] init];
		[request setListId:[parent listId]];
		[request setEntry:entry];
		[connection sendBean:request];
		
		[[MobiListStore sharedStore] setSyncedStatus:NO
										  forEntryId:[entry entryId]];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save:(id)sender {
	[[self navigationController] dismissViewControllerAnimated:YES completion:dismissBlock];
	
	[entry setTitle:[titleTextField text]];
	[entry setDescription:[descriptionTextField text]];
	[entry setDueDate:[[dueDatePicker date] timeIntervalSince1970]];
	[entry setDone:NO];
	
	CreateEntryRequest* request = [[CreateEntryRequest alloc] init];
	[request setListId:[parent listId]];
	[request setEntry:entry];
	[connection sendBean:request];
	
	[[MobiListStore sharedStore] setSyncedStatus:NO
									  forEntryId:[entry entryId]];
}

- (void)cancel:(id)sender {
	[parent removeListEntry:entry];
	[[self navigationController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (IBAction)backgroundTapped:(id)sender {
	[[self view] endEditing:YES];
}

@end
