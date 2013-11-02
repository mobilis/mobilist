//
//  TodoListViewController.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 25.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "TodoListViewController.h"

@interface TodoListViewController ()

@end

@implementation TodoListViewController

@synthesize theList, connection;

- (id)initWithMobiList:(MobiList *)aList {
	self = [super initWithStyle:UITableViewStyleGrouped];
	
    if (self) {
		UIImage* bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
															 pathForResource:@"light_toast" ofType:@"png"]];
		self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
		
        theList = aList;
		
		[[self navigationItem] setTitle:[theList listName]];
		
		UIBarButtonItem* addEntryItem = [[UIBarButtonItem alloc]
			initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
								 target:self
								 action:@selector(showComposeListEntryView:)];
		[[self navigationItem] setRightBarButtonItem:addEntryItem];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedEntryCreationConfirmed:)
													 name:NotificationEntryCreationConfirmed
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedEntryEditingConfirmed:)
													 name:NotificationEntryEditingConfirmed
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

- (id)init {
	@throw [NSException exceptionWithName:@"Wrong initializer"
								   reason:@"Use initWithMobiList"
								 userInfo:nil];
	
	return nil;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)receivedEntryCreationConfirmed:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	NSString* entryId = [userInfo objectForKey:@"entryId"];
	
	[[MobiListStore sharedStore] setSyncedStatus:YES
									  forEntryId:entryId];
	[[self tableView] reloadData];
}

- (void)receivedEntryEditingConfirmed:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	NSString* entryId = [userInfo objectForKey:@"entryId"];
	
	[[MobiListStore sharedStore] setSyncedStatus:YES
									  forEntryId:entryId];
	[[self tableView] reloadData];
}

- (void)receivedEntryCreatedInfo:(NSNotification* )notification {
	[[self tableView] reloadData];
}

- (void)receivedEntryEditedInfo:(NSNotification* )notification {
	[[self tableView] reloadData];
}

- (void)receivedEntryDeletedInfo:(NSNotification* )notification {
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
    return [[theList listEntries] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TodoListEntryCell* cell = [tableView dequeueReusableCellWithIdentifier:CellTodoListEntry
															forIndexPath:indexPath];
	MobiListEntry* entry = [theList entryAtIndex:[indexPath row]];
    
	[cell setEntry:entry];
	
    [[cell titleLabel] setText:[entry title]];
	
	NSDate* dueDate = [entry dueDateAsDate];
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
	[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Berlin"]];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	[[cell dueDateLabel] setText:[NSString stringWithFormat:@"Due %@", [formatter stringFromDate:dueDate]]];
	
	[[cell checkedSwitch] setOnImage:[UIImage imageNamed:@"checked.png"]];
	[[cell checkedSwitch] setOffImage:[UIImage imageNamed:@"not-checked.png"]];
	[[cell checkedSwitch] setOn:[entry done] animated:YES];
	[[cell checkedSwitch] addTarget:self
							 action:@selector(switchTapped:forEvent:)
				   forControlEvents:UIControlEventValueChanged];
	
	if (![[MobiListStore sharedStore] isEntrySyncedWithService:entry]) {
		[[cell syncIndicator] startAnimating];
	}
    
    return cell;
}

- (void)switchTapped:(id)sender forEvent:(UIEvent* )event {
	UISwitch* theSwitch = (UISwitch*) sender;
	// TODO this seems a bad solution …
	TodoListEntryCell* cell = (TodoListEntryCell*) [[[theSwitch superview] superview] superview];
	
	MobiListEntry* entry = [cell entry];
	[entry setDone:[theSwitch isOn]];
	
	EditEntryRequest* request = [[EditEntryRequest alloc] init];
	[request setListId:[theList listId]];
	[request setEntry:entry];
	[connection sendBean:request];
	
	[[MobiListStore sharedStore] setSyncedStatus:NO
									  forEntryId:[entry entryId]];
	[[cell syncIndicator] startAnimating];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		entryIndexToBeDeleted = [indexPath row];
		MobiListEntry* entryToBeDeleted = [theList entryAtIndex:entryIndexToBeDeleted];
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
		[request setListId:[theList listId]];
		[request setEntryId:[[[theList listEntries] objectAtIndex:entryIndexToBeDeleted] entryId]];
		[connection sendBean:request];
		
		[[theList listEntries] removeObjectAtIndex:entryIndexToBeDeleted];
		
		NSIndexPath* indexPath = [NSIndexPath indexPathForRow:entryIndexToBeDeleted
													inSection:0];
		[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
								withRowAnimation:YES];
	}
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntryDetailViewController* edvc = [[EntryDetailViewController alloc] initForNewEntry:NO];
	
	[edvc setDismissBlock:^{
		[tableView reloadData];
	}];
	[edvc setParent:theList];
	[edvc setEntry:[theList entryAtIndex:[indexPath row]]];
	[edvc setConnection:connection];
	
	[[self navigationController] pushViewController:edvc animated:YES];
}

- (void)showComposeListEntryView:(id)sender {
	EntryDetailViewController* edvc = [[EntryDetailViewController alloc] initForNewEntry:YES];
	
	MobiListEntry* newEntry = [[MobiListEntry alloc] init];
	[newEntry setEntryId:[UUIDCreator createUUID]];
	
	[edvc setConnection:connection];
	[edvc setParent:theList];
	[edvc setEntry:newEntry];
	[theList addListEntry:newEntry];
	
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

@end
