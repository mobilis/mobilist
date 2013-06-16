//
//  DashboardViewController.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
			   bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage* bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
										pathForResource:@"light_toast" ofType:@"png"]];
		self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
		
		[existingsListsTable setDataSource:self];
		[existingsListsTable setDelegate:self];
		
		UIBarButtonItem* addListItem = [[UIBarButtonItem alloc]
				initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
										target:self
										action:@selector(showCreateListView:)];
		[[self navigationItem] setRightBarButtonItem:addListItem];
		
		UIBarButtonItem* settingsItem = [[UIBarButtonItem alloc]
				initWithTitle:@"Settings"
						style:UIBarButtonItemStylePlain
					   target:self
					   action:@selector(showXMPPSettingsView:)];
		[[self navigationItem] setLeftBarButtonItem:settingsItem];
		
		[[self navigationItem] setTitle:@"Mobilist"];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedListAddedNotification:)
													 name:NotificationMobiListAdded
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedListCreationConfirmedNotification:)
													 name:NotificationListCreationConfirmed
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedListDeletionConfirmedNotification:)
													 name:NotificationListDeletionConfirmed
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedListEditingConfirmedNotification:)
													 name:NotificationListEditingConfirmed
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedListCreatedInfo:)
													 name:NotificationListCreatedInformed
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedListEditedInfo:)
													 name:NotificationListEditedInformed
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedListDeletedInfo:)
													 name:NotificationListDeletedInformed
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedEntryCreatedInfo:)
													 name:NotificationEntryCreatedInformed
												   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UINib* nib = [UINib nibWithNibName:CellTodoList
								bundle:nil];
	
	[existingsListsTable registerNib:nib
			  forCellReuseIdentifier:CellTodoList];
}

- (void)viewWillAppear:(BOOL)animated {
	[existingsListsTable reloadData];
}

- (void)connectionEstablished:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	connection = [userInfo objectForKey:@"connection"];
}

- (void)receivedListAddedNotification:(NSNotification* )notification {
	[existingsListsTable reloadData];
}

- (void)receivedListCreationConfirmedNotification:(NSNotification* )notification {
	[existingsListsTable reloadData];
}

- (void)receivedListDeletionConfirmedNotification:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	NSString* listId = [userInfo objectForKey:@"listId"];
	
	[[MobiListStore sharedStore] setSyncedStatus:YES forListId:listId];
}

- (void)receivedListEditingConfirmedNotification:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	[[MobiListStore sharedStore] setSyncedStatus:YES forListId:[userInfo objectForKey:@"listId"]];
	
	[existingsListsTable reloadData];
}

- (void)receivedListCreatedInfo:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	MobiList* list = [userInfo objectForKey:@"list"];
	
	[[MobiListStore sharedStore] addMobiList:list
								newlyCreated:NO];
	[existingsListsTable reloadData];
}

- (void)receivedListEditedInfo:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	MobiList* newList = [userInfo objectForKey:@"list"];
	
	MobiList* oldList = [[MobiListStore sharedStore] listByListId:[newList listId]];
	
	[oldList setListName:[newList listName]];
	[oldList setListEntries:[newList listEntries]];
	
	[existingsListsTable reloadData];
}

- (void)receivedListDeletedInfo:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	NSString* listId = [userInfo objectForKey:@"listId"];
	
	MobiList* listToBeDeleted = [[MobiListStore sharedStore] listByListId:listId];
	[[MobiListStore sharedStore] removeMobiList:listToBeDeleted];
	
	[existingsListsTable reloadData];
}

- (void)receivedEntryCreatedInfo:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	NSString* listId = [userInfo objectForKey:@"listId"];
	MobiListEntry* entry = [userInfo objectForKey:@"entry"];
	
	MobiList* listForEntry = [[MobiListStore sharedStore] listByListId:listId];
	[listForEntry addListEntry:entry];
	
	[existingsListsTable reloadData];
}

/*
 * Table view data source
 */

- (UITableViewCell *) tableView:(UITableView *)tableView
		  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MobiList* list = [[[MobiListStore sharedStore] allLists] objectAtIndex:[indexPath row]];
	
	TodoListCell* cell = [existingsListsTable dequeueReusableCellWithIdentifier:CellTodoList];
	
	[[cell listNameLabel] setText:[list listName]];
	if (![[MobiListStore sharedStore] isListSyncedWithService:list]) {
		[[cell syncSpinner] startAnimating];
	} else {
		[[cell syncSpinner] stopAnimating];
	}
	
	return cell;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
	return [[[MobiListStore sharedStore] allLists] count];
}

/*
 * End table view data source
 */

/*
 * Table view delegate
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TodoListViewController* tlvc = [[TodoListViewController alloc]
				initWithMobiList:[[[MobiListStore sharedStore] allLists] objectAtIndex:[indexPath row]]];
	[tlvc setConnection:connection];
	
	[[self navigationController] pushViewController:tlvc animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	MobiAppDelegate* delegate = (MobiAppDelegate*) [[UIApplication sharedApplication] delegate];
	if (![delegate areXMPPSettingsSufficient]) {
		return @"Go to the settings view and supply your XMPP account information.";
	}
	
	if ([[[MobiListStore sharedStore] allLists] count] > 0) {
		return @"Existing lists";
	} else {
		return @"No lists created yet. Click the + button on the right to add one.";
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	MobiList* selectedList = [[[MobiListStore sharedStore] allLists] objectAtIndex:[indexPath row]];
	
	ListDetailViewController* ldvc = [[ListDetailViewController alloc] initForNewList:NO];
	[ldvc setList:selectedList];
	[ldvc setConnection:connection];
	
	[[self navigationController] pushViewController:ldvc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
											forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		MobiListStore* store = [MobiListStore sharedStore];
		NSArray* allLists = [store allLists];
		MobiList* selectedList = [allLists objectAtIndex:[indexPath row]];
		
		[store removeMobiList:selectedList];
		DeleteListRequest* request = [[DeleteListRequest alloc] init];
		[request setListId:[selectedList listId]];
		[connection sendBean:request];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationMiddle];
		
		[store setSyncedStatus:NO forListId:[selectedList listId]];
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

/*
 * End table view delegate
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showXMPPSettingsView:(id)sender {
	XMPPSettingsViewController* xvc = [[XMPPSettingsViewController alloc] init];
	[[self navigationController] pushViewController:xvc animated:YES];
}

- (void)showCreateListView:(id)sender {
	ListDetailViewController* nlvc = [[ListDetailViewController alloc] initForNewList:YES];
	
	[nlvc setDismissBlock:^{
		[existingsListsTable reloadData];
	}];
	[nlvc setConnection:connection];
	
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:nlvc];
	
	[self presentViewController:navController
					   animated:YES
					 completion:nil];
}

@end
