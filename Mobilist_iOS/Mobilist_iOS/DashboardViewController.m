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

@end

@implementation DashboardViewController
{
    BOOL _isConnecting;
}

- (void)setupBeanListeners
{
    [[MXiConnectionHandler sharedInstance].connection addBeanDelegate:self
                                                         withSelector:@selector(receivedListCreationConfirmedNotification:)
                                                         forBeanClass:[CreateListResponse class]];
    [[MXiConnectionHandler sharedInstance].connection addBeanDelegate:self
                                                         withSelector:@selector(receivedListDeletionConfirmedNotification:)
                                                         forBeanClass:[DeleteListResponse class]];
    [[MXiConnectionHandler sharedInstance].connection addBeanDelegate:self
                                                         withSelector:@selector(receivedListEditingConfirmedNotification:)
                                                         forBeanClass:[EditListResponse class]];
    [[MXiConnectionHandler sharedInstance].connection addBeanDelegate:self
                                                         withSelector:@selector(receivedListCreatedInfo:)
                                                         forBeanClass:[ListCreatedInfo class]];
    [[MXiConnectionHandler sharedInstance].connection addBeanDelegate:self
                                                         withSelector:@selector(receivedListEditedInfo:)
                                                         forBeanClass:[ListEditedInfo class]];
    [[MXiConnectionHandler sharedInstance].connection addBeanDelegate:self
                                                         withSelector:@selector(receivedListDeletedInfo:)
                                                         forBeanClass:[ListDeletedInfo class]];
    [[MXiConnectionHandler sharedInstance].connection addBeanDelegate:self
                                                         withSelector:@selector(receivedEntryCreatedInfo:)
                                                         forBeanClass:[EntryCreatedInfo class]];
    [[MXiConnectionHandler sharedInstance].connection addBeanDelegate:self
                                                         withSelector:@selector(receivedEntryEditedInfo:)
                                                         forBeanClass:[EntryEditedInfo class]];
    [[MXiConnectionHandler sharedInstance].connection addBeanDelegate:self
                                                         withSelector:@selector(receivedEntryDeletedInfo:)
                                                         forBeanClass:[EntryDeletedInfo class]];
}

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
        _isConnecting = YES;
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

- (void)viewWillAppear:(BOOL)animated
{
	[self.existingsListsTable reloadData];
}

- (NSString *)title
{
    return @"Mobilist";
}

#pragma mark - MXiServiceManagerDelegate

- (void)serviceDiscoveryFinishedWithError:(NSError *)error
{
    if (!error) {
        _isConnecting = NO;
        [self setupBeanListeners];
        [self.existingsListsTable reloadData];
    }
}

#pragma mark - Bean Actions

- (void)receivedListAddedNotification:(NSNotification* )notification {
	[self.existingsListsTable reloadData];
}

- (void)receivedListCreationConfirmedNotification:(CreateListResponse* )createListResponse {
	[self.existingsListsTable reloadData];
}

- (void)receivedListDeletionConfirmedNotification:(DeleteListResponse* )deleteListResponse {
	NSString* listId = deleteListResponse.listId;
	
	[[MobiListStore sharedStore] setSyncedStatus:YES forListId:listId];
}

- (void)receivedListEditingConfirmedNotification:(EditListResponse* )editListResponse
{
	[[MobiListStore sharedStore] setSyncedStatus:YES forListId:editListResponse.listId];
	
	[self.existingsListsTable reloadData];
}

- (void)receivedListCreatedInfo:(ListCreatedInfo* )listCreatedInfo
{
	MobiList* list = listCreatedInfo.list;
	[[MobiListStore sharedStore] addMobiList:list newlyCreated:NO];

    ListCreatedAccept* accept = [[ListCreatedAccept alloc] init];
    [accept setListId:[[listCreatedInfo list] listId]];
    [[MXiConnectionHandler sharedInstance].connection sendBean:accept];

	[self.existingsListsTable reloadData];
}

- (void)receivedListEditedInfo:(ListEditedInfo* )listEditedInfo
{
	MobiList* newList = listEditedInfo.list;
	MobiList* oldList = [[MobiListStore sharedStore] listByListId:[newList listId]];
	
	[oldList setListName:[newList listName]];
	[oldList setListEntries:[newList listEntries]];

    ListEditedAccept* accept = [[ListEditedAccept alloc] init];
    [accept setListId:[[listEditedInfo list] listId]];
    [[MXiConnectionHandler sharedInstance].connection sendBean:accept];

	[self.existingsListsTable reloadData];
}

- (void)receivedListDeletedInfo:(ListDeletedInfo* )listDeletedInfo
{
	NSString* listId = listDeletedInfo.listId;
	
	MobiList* listToBeDeleted = [[MobiListStore sharedStore] listByListId:listId];
	[[MobiListStore sharedStore] removeMobiList:listToBeDeleted];

    ListDeletedAccept* accept = [[ListDeletedAccept alloc] init];
    [accept setListId:[listDeletedInfo listId]];
    [[MXiConnectionHandler sharedInstance].connection sendBean:accept];

	[self.existingsListsTable reloadData];
}

- (void)receivedEntryCreatedInfo:(EntryCreatedInfo* )entryCreatedInfo {
	NSString* listId = entryCreatedInfo.listId;
	MobiListEntry* entry = entryCreatedInfo.entry;
	
	MobiList* listForEntry = [[MobiListStore sharedStore] listByListId:listId];
	[listForEntry addListEntry:entry];
	
	[self.existingsListsTable reloadData];
}

- (void)receivedEntryEditedInfo:(EntryEditedInfo* )entryEditedInfo
{
	NSString* listId = entryEditedInfo.listId;
	MobiListEntry* entry = entryEditedInfo.entry;
	
	MobiList* listForEntry = [[MobiListStore sharedStore] listByListId:listId];
	MobiListEntry* oldEntry = [listForEntry entryById:[entry entryId]];
	
	[oldEntry setTitle:[entry title]];
	[oldEntry setDescription:[entry description]];
	[oldEntry setDueDate:[entry dueDate]];
	[oldEntry setDone:[entry done]];
	
	[self.existingsListsTable reloadData];
}

- (void)receivedEntryDeletedInfo:(EntryDeletedInfo* )entryDeletedInfo
{
	NSString* listId = entryDeletedInfo.listId;
	NSString* entryId = entryDeletedInfo.entryId;
	
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
	return _isConnecting ? 0 : [[[MobiListStore sharedStore] allLists] count];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TodoListViewController* tlvc = [[TodoListViewController alloc]
				initWithMobiList:[[[MobiListStore sharedStore] allLists] objectAtIndex:[indexPath row]]];

	[[self navigationController] pushViewController:tlvc animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	MobiAppDelegate* delegate = (MobiAppDelegate*) [[UIApplication sharedApplication] delegate];
	
	if (![delegate areXMPPSettingsSufficient]) {
		return @"Go to the settings view and supply your XMPP account information.";
	}
	
	if (_isConnecting) {
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
		[[MXiConnectionHandler sharedInstance].connection sendBean:request];
		
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
			
			[[MXiConnectionHandler sharedInstance].connection reconnectWithJabberID:jabberIdFromDefaults
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
	
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:nlvc];
	
	[self presentViewController:navController
					   animated:YES
					 completion:nil];
}

@end
