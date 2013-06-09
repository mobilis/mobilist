//
//  MobiListStore.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 18.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "MobiList.h"

@interface MobiListStore : NSObject
{
	NSMutableArray* allLists;
	NSMutableArray* notYetSyncedListIds;
}

+ (MobiListStore* )sharedStore;

- (NSMutableArray* )allLists;
- (NSArray* )notYetSyncedListIds;
- (BOOL)isSyncedWithService:(MobiList* )aList;
- (void)setSyncedStatus:(BOOL )inSync
			  forListId:(NSString* )listId;
- (void)addMobiList:(MobiList* )aList
	   newlyCreated:(BOOL)isNew;
- (void)removeMobiList:(MobiList* )aList;

@end
