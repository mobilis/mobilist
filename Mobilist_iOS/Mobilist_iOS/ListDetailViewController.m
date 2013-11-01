//
//  NewListViewController.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "ListDetailViewController.h"

@interface ListDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ListDetailViewController

@synthesize dismissBlock, list, connection;

- (id)initForNewList:(BOOL)isNew {
	self = [super initWithNibName:@"ListDetailViewController" bundle:nil];
	
    if (self) {
		isForNewItem = isNew;
		UIImage* bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
															 pathForResource:@"light_toast" ofType:@"png"]];
		self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
		
		if (isNew) {
			UIBarButtonItem* doneItem = [[UIBarButtonItem alloc]
										 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
										 target:self
										 action:@selector(save:)];
			[[self navigationItem] setRightBarButtonItem:doneItem];
			
			UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
										   target:self
										   action:@selector(cancel:)];
			[[self navigationItem] setLeftBarButtonItem:cancelItem];
		}
    }
	
    return self;
}

- (id)init {
	return [self initForNewList:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
								   reason:@"Use initForNewList"
								 userInfo:nil];
	
	return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[listNameTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (list) {
		[listNameTextField setText:[list listName]];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[self view] endEditing:YES];
	
	if (!isForNewItem) {
		[list setListName:[listNameTextField text]];
	
		EditListRequest* request = [[EditListRequest alloc] init];
		[request setList:list];
		[connection sendBean:request];
		
		[[MobiListStore sharedStore] setSyncedStatus:NO
										   forListId:[list listId]];
	}
}

- (void)viewDidLayoutSubviews
{
    CGRect frame = self.contentView.frame;
    frame.origin.y = self.topLayoutGuide.length;
    self.contentView.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save:(id)sender {
	NSString* listNameText = [listNameTextField text];
	
	if ([listNameText length] < 3) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Name too short"
														message:@"List name must be at least 3 characters long"
													   delegate:nil
											  cancelButtonTitle:@"Change name"
											  otherButtonTitles:nil];
		[alert show];
		
		return;
	}
	
	MobiList* theNewList = [[MobiList alloc] init];
	[theNewList setListName:listNameText];
	NSString *uuidStr = [UUIDCreator createUUID];
	[theNewList setListId:uuidStr];
	
	MobiListStore* sharedStore = [MobiListStore sharedStore];
	[sharedStore addMobiList:theNewList
				newlyCreated:YES];
	
	CreateListRequest* request = [[CreateListRequest alloc] init];
	[request setList:theNewList];
	[connection sendBean:request];
	
	[[self navigationController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)cancel:(id)sender {
	[[self navigationController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

@end
