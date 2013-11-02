//
//  NewListViewController.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobiList.h"
#import "MobiListStore.h"
#import "MobiListEntry.h"
#import "CreateListRequest.h"
#import "EditListRequest.h"
#import "UUIDCreator.h"

@interface ListDetailViewController : UIViewController
{
	BOOL _isForNewItem;
}

@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic) MobiList* list;
@property (nonatomic) MXiConnection* connection;

- (id)initForNewList:(BOOL)isNew;

@end
