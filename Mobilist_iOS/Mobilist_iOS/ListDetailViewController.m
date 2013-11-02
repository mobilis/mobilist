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
@property (weak, nonatomic) IBOutlet UITextField *listNameTextField;

@end

@implementation ListDetailViewController

- (id)initForNewList:(BOOL)isNew {
	self = [super initWithNibName:@"ListDetailViewController" bundle:nil];
	
    if (self) {
		_isForNewItem = isNew;
		
		if (isNew) {
			UIBarButtonItem* doneItem = [[UIBarButtonItem alloc]
										 initWithBarButtonSystemItem:UIBarButtonSystemItemSave
										 target:self
										 action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
			
			UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
										   target:self
										   action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
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
	
    UIImage* bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                         pathForResource:@"light_toast" ofType:@"png"]];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
	[self.listNameTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (self.list) {
		[self.listNameTextField setText:[self.list listName]];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[self view] endEditing:YES];
	
	if (!_isForNewItem) {
		[self.list setListName:[self.listNameTextField text]];
	
		EditListRequest* request = [[EditListRequest alloc] init];
		[request setList:self.list];
		[self.connection sendBean:request];
		
		[[MobiListStore sharedStore] setSyncedStatus:NO
										   forListId:[self.list listId]];
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
	NSString* listNameText = [self.listNameTextField text];
	
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
	[self.connection sendBean:request];
	
	[[self navigationController] dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender {
	[[self navigationController] dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

@end
