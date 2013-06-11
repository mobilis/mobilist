//
//  TodoListViewController.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 25.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "MobiList.h"
#import "MobiListEntry.h"
#import "TodoListEntryCell.h"
#import "EntryDetailViewController.h"
#import "EditEntryRequest.h"
#import "UUIDCreator.h"

@interface TodoListViewController : UITableViewController <UIAlertViewDelegate>
{
	NSInteger entryIndexToBeDeleted;
}

@property (nonatomic, strong) MobiList* theList;
@property (nonatomic, strong) MXiConnection* connection;

- (id)initWithMobiList:(MobiList* )aList;
- (void)showComposeListEntryView:(id)sender;

@end
