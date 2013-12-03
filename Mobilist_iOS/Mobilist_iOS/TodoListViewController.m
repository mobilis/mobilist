//
//  TodoListViewController.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 25.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "TodoListViewController.h"
#import "CreateEntryResponse.h"
#import "EditEntryResponse.h"
#import "EntryCreatedInfo.h"
#import "EntryEditedInfo.h"
#import "EntryDeletedInfo.h"
#import "EntryCreatedAccept.h"
#import "EntryEditedAccept.h"
#import "EntryDeletedAccept.h"

@interface TodoListViewController () <TodoListEntryCellDelegate>

@end

@implementation TodoListViewController

- (id)initWithMobiList:(MobiList *)aList {
	self = [super initWithStyle:UITableViewStyleGrouped];
	
    if (self) {
		UIImage* bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
															 pathForResource:@"light_toast" ofType:@"png"]];
		self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
		
        self.mobiList = aList;
		
		[[self navigationItem] setTitle:[self.mobiList listName]];
		
		UIBarButtonItem* addEntryItem = [[UIBarButtonItem alloc]
			initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
								 target:self
								 action:@selector(showComposeListEntryView:)];
        self.navigationItem.rightBarButtonItem = addEntryItem;
		
        [[MXiConnectionHandler sharedInstance].connection addBeanDelegate:self
                                                             withSelector:@selector(receivedEntryCreationConfirmed:)
                                                             forBeanClass:[CreateEntryResponse class]];
        [[MXiConnectionHandler sharedInstance].connection addBeanDelegate:self
                                                             withSelector:@selector(receivedEntryEditingConfirmed:)
                                                             forBeanClass:[EditEntryResponse class]];
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
	
    return self;
}

- (void)receivedEntryCreationConfirmed:(CreateEntryResponse* )createEntryResponse {
	NSString* entryId = createEntryResponse.entryId;
	
	[[MobiListStore sharedStore] setSyncedStatus:YES
									  forEntryId:entryId];
	[[self tableView] reloadData];
}

- (void)receivedEntryEditingConfirmed:(EditEntryResponse* )editEntryResponse {
	NSString* entryId = editEntryResponse.entryId;
	
	[[MobiListStore sharedStore] setSyncedStatus:YES
									  forEntryId:entryId];
	[[self tableView] reloadData];
}

- (void)receivedEntryCreatedInfo:(EntryCreatedInfo* )entryCreatedInfo {
    EntryCreatedAccept* accept = [[EntryCreatedAccept alloc] init];
    [accept setEntryId:entryCreatedInfo.entry.entryId];
    [[MXiConnectionHandler sharedInstance] sendBean:accept toService:nil];

	[[self tableView] reloadData];
}

- (void)receivedEntryEditedInfo:(EntryEditedInfo* )entryEditedInfo {
    EntryEditedAccept* accept = [[EntryEditedAccept alloc] init];
    [accept setEntryId:[[entryEditedInfo entry] entryId]];
    [[MXiConnectionHandler sharedInstance] sendBean:accept toService:nil];

	[[self tableView] reloadData];
}

- (void)receivedEntryDeletedInfo:(EntryDeletedInfo* )entryDeletedInfo {
    EntryDeletedAccept* accept = [[EntryDeletedAccept alloc] init];
    [accept setEntryId:[entryDeletedInfo entryId]];
    [[MXiConnectionHandler sharedInstance] sendBean:accept toService:nil];

	[[self tableView] reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Load the NIB file
	UINib* nib = [UINib nibWithNibName:CellTodoListEntry
								bundle:nil];
	
	// Register this NIB file which contains the cell
	[[self tableView] registerNib:nib
		   forCellReuseIdentifier:CellTodoListEntry];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.mobiList listEntries] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TodoListEntryCell* cell = [tableView dequeueReusableCellWithIdentifier:CellTodoListEntry
															forIndexPath:indexPath];
    cell.delegate = self;
	MobiListEntry* entry = [self.mobiList entryAtIndex:[indexPath row]];
    
	[cell setEntry:entry];
	
    [[cell titleLabel] setText:[entry title]];
	
	NSDate* dueDate = [entry dueDateAsDate];
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Berlin"]];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	[[cell dueDateLabel] setText:[NSString stringWithFormat:@"Due %@", [formatter stringFromDate:dueDate]]];
	
	[[cell checkedSwitch] setOn:[entry done] animated:YES];
		
	if (![[MobiListStore sharedStore] isEntrySyncedWithService:entry]) {
		[[cell syncIndicator] startAnimating];
	}
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		entryIndexToBeDeleted = [indexPath row];
		MobiListEntry* entryToBeDeleted = [self.mobiList entryAtIndex:entryIndexToBeDeleted];
		NSString* message = [[@"Do you really want to delete the entry '"
							  stringByAppendingString:[entryToBeDeleted title]]
							 stringByAppendingString:@"'?"];
		
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Delete todo entry"
															message:message
														   delegate:self
												  cancelButtonTitle:@"Don't delete"
												  otherButtonTitles:@"Delete", nil];
		[alertView show];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		// Delete button was pressed
		DeleteEntryRequest* request = [[DeleteEntryRequest alloc] init];
		[request setListId:[self.mobiList listId]];
		[request setEntryId:[[[self.mobiList listEntries] objectAtIndex:entryIndexToBeDeleted] entryId]];
		[[MXiConnectionHandler sharedInstance] sendBean:request toService:nil];
		
		[[self.mobiList listEntries] removeObjectAtIndex:entryIndexToBeDeleted];
		
		NSIndexPath* indexPath = [NSIndexPath indexPathForRow:entryIndexToBeDeleted
													inSection:0];
		[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
								withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntryDetailViewController* edvc = [[EntryDetailViewController alloc] initForNewEntry:NO];
	
	[edvc setDismissBlock:^{
		[tableView reloadData];
	}];
	[edvc setParent:self.mobiList];
	[edvc setEntry:[self.mobiList entryAtIndex:[indexPath row]]];
	
	[[self navigationController] pushViewController:edvc animated:YES];
}

- (void)showComposeListEntryView:(id)sender {
	EntryDetailViewController* edvc = [[EntryDetailViewController alloc] initForNewEntry:YES];
	
	MobiListEntry* newEntry = [[MobiListEntry alloc] init];
	[newEntry setEntryId:[UUIDCreator createUUID]];

	[edvc setParent:self.mobiList];
	[edvc setEntry:newEntry];
	[self.mobiList addListEntry:newEntry];
	
	[edvc setDismissBlock:^{
		[[self tableView] reloadData];
	}];
	
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:edvc];
	
	[self presentViewController:navController
					   animated:YES
					 completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TodoListEntryCell expectedHeight];
}

#pragma mark - TodoListEntryCellDelegate

- (void)checkedSwitchStateChange:(UISwitch *)theSwitch forEntry:(MobiListEntry *)entry
{
    [entry setDone:[theSwitch isOn]];
	
	EditEntryRequest* request = [[EditEntryRequest alloc] init];
	[request setListId:[self.mobiList listId]];
	[request setEntry:entry];
	[[MXiConnectionHandler sharedInstance] sendBean:request toService:nil];
	
	[[MobiListStore sharedStore] setSyncedStatus:NO
									  forEntryId:[entry entryId]];
}

@end
