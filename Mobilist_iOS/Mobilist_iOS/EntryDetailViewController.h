//
//  EntryDetailViewController.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 26.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobiListEntry.h"
#import "MobiList.h"
#import "CreateEntryRequest.h"
#import "EditEntryRequest.h"
#import "MobiListStore.h"

@interface EntryDetailViewController : UIViewController
{
	BOOL _isForNewItem;
}

@property (nonatomic, strong) MobiListEntry* entry;
@property (nonatomic, strong) MobiList* parent;
@property (nonatomic, strong) MXiConnection* connection;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (id)initForNewEntry:(BOOL)isNew;
- (IBAction)backgroundTapped:(id)sender;

@end