//
//  DashboardViewController.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()

@property (weak, nonatomic) IBOutlet UITableView *existingsListsTable;

@property (strong, nonatomic, readwrite) MXiConnection *connection;

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
        self.existingsListsTable.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
		
		[self.existingsListsTable setDataSource:self];
		[self.existingsListsTable setDelegate:self];
		
		UIBarButtonItem* addListItem = [[UIBarButtonItem alloc]
				initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
										target:self
										action:@selector(showCreateListView:)];
        self.navigationItem.rightBarButtonItem = addListItem;
		
		UIBarButtonItem* settingsItem = [[UIBarButtonItem alloc]
				initWithTitle:@"Settings"
						style:UIBarButtonItemStylePlain
					   target:self
					   action:@selector(showXMPPSettingsView:)];
        self.navigationItem.leftBarButtonItem = settingsItem;
		
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
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedEntryEditedInfo:)
													 name:NotificationEntryEditedInformed
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedEntryDeletedInfo:)
													 name:NotificationEntryDeletedInformed
												   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UINib* nib = [UINib nibWithNibName:CellTodoList
								bundle:nil];
	
	[self.existingsListsTable registerNib:nib
			  forCellReuseIdentifier:CellTodoList];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.existingsListsTable reloadData];
}

- (NSString *)title
{
    return @"Mobilist";
}

- (void)connectionEstablished:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	self.connection = [userInfo objectForKey:@"connection"];
}

- (void)receivedListAddedNotification:(NSNotification* )notification {
	[self.existingsListsTable reloadData];
}

- (void)receivedListCreationConfirmedNotification:(NSNotification* )notification {
	[self.existingsListsTable reloadData];
}

- (void)receivedListDeletionConfirmedNotification:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	NSString* listId = [userInfo objectForKey:@"listId"];
	
	[[MobiListStore sharedStore] setSyncedStatus:YES forListId:listId];
}

- (void)receivedListEditingConfirmedNotification:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	[[MobiListStore sharedStore] setSyncedStatus:YES forListId:[userInfo objectForKey:@"listId"]];
	
	[self.existingsListsTable reloadData];
}

- (void)receivedListCreatedInfo:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	MobiList* list = [userInfo objectForKey:@"list"];
	
	[[MobiListStore sharedStore] addMobiList:list
								newlyCreated:NO];
	[self.existingsListsTable reloadData];
}

- (void)receivedListEditedInfo:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	MobiList* newList = [userInfo objectForKey:@"list"];
	
	MobiList* oldList = [[MobiListStore sharedStore] listByListId:[newList listId]];
	
	[oldList setListName:[newList listName]];
	[oldList setListEntries:[newList listEntries]];
	
	[self.existingsListsTable reloadData];
}

- (void)receivedListDeletedInfo:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	NSString* listId = [userInfo objectForKey:@"listId"];
	
	MobiList* listToBeDeleted = [[MobiListStore sharedStore] listByListId:listId];
	[[MobiListStore sharedStore] removeMobiList:listToBeDeleted];
	
	[self.existingsListsTable reloadData];
}

- (void)receivedEntryCreatedInfo:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	NSString* listId = [userInfo objectForKey:@"listId"];
	MobiListEntry* entry = [userInfo objectForKey:@"entry"];
	
	MobiList* listForEntry = [[MobiListStore sharedStore] listByListId:listId];
	[listForEntry addListEntry:entry];
	
	[self.existingsListsTable reloadData];
}

- (void)receivedEntryEditedInfo:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	NSString* listId = [userInfo objectForKey:@"listId"];
	MobiListEntry* entry = [userInfo objectForKey:@"entry"];
	
	MobiList* listForEntry = [[MobiListStore sharedStore] listByListId:listId];
	MobiListEntry* oldEntry = [listForEntry entryById:[entry entryId]];
	
	[oldEntry setTitle:[entry title]];
	[oldEntry setDescription:[entry description]];
	[oldEntry setDueDate:[entry dueDate]];
	[oldEntry setDone:[entry done]];
	
	[self.existingsListsTable reloadData];
}

- (void)receivedEntryDeletedInfo:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	NSString* listId = [userInfo objectForKey:@"listId"];
	NSString* entryId = [userInfo objectForKey:@"entryId"];
	
	MobiList* listForEntry = [[MobiListStore sharedStore] listByListId:listId];
	MobiListEntry* entryToBeDeleted = [listForEntry entryById:entryId];
	[listForEntry removeListEntry:entryToBeDeleted];
	
	[self.existingsListsTable reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *) tableView:(UITableView *)tableView
		  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MobiList* list = [[[MobiListStore sharedStore] allLists] objectAtIndex:[indexPath row]];
	
	TodoListCell* cell = [self.existingsListsTable dequeueReusableCellWithIdentifier:CellTodoList];
	
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TodoListViewController* tlvc = [[TodoListViewController alloc]
				initWithMobiList:[[[MobiListStore sharedStore] allLists] objectAtIndex:[indexPath row]]];
	[tlvc setConnection:self.connection];
	
	[[self navigationController] pushViewController:tlvc animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	MobiAppDelegate* delegate = (MobiAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	if (![delegate areXMPPSettingsSufficient]) {
		return @"Go to the settings view and supply your XMPP account information.";
	}
	
	if (![delegate authenticated]) {
		return @"Connecting …";
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
	[ldvc setConnection:self.connection];
	
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
		[self.connection sendBean:request];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationMiddle];
		
		[store setSyncedStatus:NO forListId:[selectedList listId]];
		
		[tableView reloadData];
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

#pragma mark - Navigating to other Views

- (void)showXMPPSettingsView:(id)sender {
	XMPPSettingsViewController* xvc = [[XMPPSettingsViewController alloc] init];
	
	[xvc setDismissBlock:^{
		MobiAppDelegate* appDelegate = (MobiAppDelegate*) [[UIApplication sharedApplication] delegate];
		
		// Delete all local lists
		[[MobiListStore sharedStore] reset];
		
		if ([appDelegate areXMPPSettingsSufficient]) {
			[appDelegate setAuthenticated:NO];
			[self.existingsListsTable reloadData];
			
			NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
			NSString* jabberIdFromDefaults = [userDefaults stringForKey:UserDefaultJabberId];
			NSString* passwordFromDefaults = [userDefaults stringForKey:UserDefaultPassword];
			NSString* hostnameFromDefaults = [userDefaults stringForKey:UserDefaultHostname];
			NSString* coordinatorJIDFromDefaults = [userDefaults stringForKey:UserDefaultCoordinatorJID];
			NSString* serviceNamespaceFromDefaults = [userDefaults stringForKey:UserDefaultServiceNamespace];
			NSInteger portFromDefaults = [userDefaults integerForKey:UserDefaultPort];
			if (portFromDefaults == 0) {
				portFromDefaults = 5222;
			}
			
			[self.connection reconnectWithJabberID:jabberIdFromDefaults
									 password:passwordFromDefaults
									 hostname:hostnameFromDefaults
										 port:portFromDefaults
							   coordinatorJID:coordinatorJIDFromDefaults
							 serviceNamespace:serviceNamespaceFromDefaults];
		}
	}];
	
	[[self navigationController] pushViewController:xvc animated:YES];
}

- (void)showCreateListView:(id)sender {
	ListDetailViewController* nlvc = [[ListDetailViewController alloc] initForNewList:YES];
	
	[nlvc setDismissBlock:^{
		[self.existingsListsTable reloadData];
	}];
	[nlvc setConnection:self.connection];
	
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:nlvc];
	
	[self presentViewController:navController
					   animated:YES
					 completion:nil];
}

@end
