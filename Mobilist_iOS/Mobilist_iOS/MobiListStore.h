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
	NSMutableArray* notYetSyncedEntryIds;
}

+ (MobiListStore* )sharedStore;

- (NSMutableArray* )allLists;
- (MobiList* )listByListId:(NSString* )listId;
- (void)addMobiList:(MobiList* )aList
	   newlyCreated:(BOOL)isNew;
- (void)removeMobiList:(MobiList* )aList;

- (NSArray* )notYetSyncedListIds;
- (NSArray* )notYetSyncedEntryIds;
- (BOOL)isListSyncedWithService:(MobiList* )aList;
- (BOOL)isEntrySyncedWithService:(MobiListEntry* )anEntry;

- (void)setSyncedStatus:(BOOL )inSync
			  forListId:(NSString* )listId;
- (void)setSyncedStatus:(BOOL)inSync
			 forEntryId:(NSString* )entryId;

@end
