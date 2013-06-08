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

@synthesize theList;

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
    
    [[cell titleLabel] setText:[entry title]];
	[[cell dueDateLabel] setText:[[entry dueDate] description]];
    
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
		[[theList listEntries] removeObjectAtIndex:entryIndexToBeDeleted];
		
		NSIndexPath* indexPath = [NSIndexPath indexPathForRow:entryIndexToBeDeleted
													inSection:0];
		[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
								withRowAnimation:YES];
	}
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntryDetailViewController* edvc = [[EntryDetailViewController alloc] initForNewEntry:NO];
	
	[edvc setDismissBlock:^{
		[tableView reloadData];
	}];
	[edvc setParent:theList];
	[edvc setEntry:[theList entryAtIndex:[indexPath row]]];
	
	[[self navigationController] pushViewController:edvc animated:YES];
}

- (void)showComposeListEntryView:(id)sender {
	EntryDetailViewController* edvc = [[EntryDetailViewController alloc] initForNewEntry:YES];
	
	[edvc setDismissBlock:^{
		[[self tableView] reloadData];
	}];
	
	MobiListEntry* newEntry = [[MobiListEntry alloc] init];
	[newEntry setEntryId:@"1"];
	[newEntry setTitle:@"Hallo"];
	[newEntry setDescription:@"Beschreibung"];
	[newEntry setDueDate:[NSDate date]];
	[newEntry setDone:NO];
	
	[edvc setParent:theList];
	[edvc setEntry:newEntry];
	
	UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:edvc];
	
	[self presentViewController:navController
					   animated:YES
					 completion:nil];
}

@end
