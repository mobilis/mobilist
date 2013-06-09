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
	NSLog(@"List deletion confirmed: %@", [userInfo objectForKey:@"listId"]);
}

- (void)receivedListEditingConfirmedNotification:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	[[MobiListStore sharedStore] setSyncedStatus:YES forListId:[userInfo objectForKey:@"listId"]];
	
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
	if (![[MobiListStore sharedStore] isSyncedWithService:list]) {
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
	
	[[self navigationController] pushViewController:tlvc animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Existing lists";
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
