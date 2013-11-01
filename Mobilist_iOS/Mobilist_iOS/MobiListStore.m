//
//  MobiListStore.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 18.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "MobiListStore.h"

@implementation MobiListStore

+ (MobiListStore *)sharedStore {
	static MobiListStore* sharedInstance = nil;
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
	
	return sharedInstance;
}

- (id)init {
	self = [super init];
	
	if (self) {
		allLists = [NSMutableArray array];
		notYetSyncedListIds = [NSMutableArray array];
		notYetSyncedEntryIds = [NSMutableArray array];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(listCreationConfirmed:)
													 name:NotificationListCreationConfirmed
												   object:nil];
	}
	
	return self;
}

- (NSMutableArray *)allLists {
	return allLists;
}

- (NSMutableArray* )notYetSyncedListIds {
	return notYetSyncedListIds;
}

- (NSArray *)notYetSyncedEntryIds {
	return notYetSyncedEntryIds;
}

- (BOOL)isListSyncedWithService:(MobiList *)aList {
	for (NSString* listId in notYetSyncedListIds) {
		if ([listId isEqualToString:[aList listId]]) {
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)isEntrySyncedWithService:(MobiListEntry *)anEntry {
	for (NSString* entryId in notYetSyncedEntryIds) {
		if ([entryId isEqualToString:[anEntry entryId]]) {
			return NO;
		}
	}
	
	return YES;
}

- (void)listCreationConfirmed:(NSNotification* )notification {
	NSDictionary* userInfo = [notification userInfo];
	NSString* listId = [userInfo objectForKey:@"listId"];
	
	[notYetSyncedListIds removeObject:listId];
}

- (void)addMobiList:(MobiList *)aList
	   newlyCreated:(BOOL)isNew {
	[allLists addObject:aList];
	
	if (isNew) {
		[notYetSyncedListIds addObject:[aList listId]];
	}
	
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:aList forKey:@"theAddedList"];
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationMobiListAdded
														object:self
													  userInfo:userInfo];
}

- (MobiList *)listByListId:(NSString *)aListId {
	for (MobiList* list in allLists) {
		if ([[list listId] isEqualToString:aListId]) {
			return list;
		}
	}
	
	return nil;
}

- (void)setSyncedStatus:(BOOL )inSync
			  forListId:(NSString* )listId  {
	if (inSync) {
		// Find and remove the supplied listId from the
		// list of not yet synced ones
		[notYetSyncedListIds removeObject:listId];
	} else {
		// Add the supplied listId to the list of
		// not yet synced ones
		[notYetSyncedListIds addObject:listId];
	}
}

- (void)setSyncedStatus:(BOOL)inSync
			 forEntryId:(NSString *)entryId {
	if (inSync) {
		// Find and remove the supplied entryId
		// from the list of not yet synced ones
		[notYetSyncedEntryIds removeObject:entryId];
	} else {
		[notYetSyncedEntryIds addObject:entryId];
	}
}

- (void)removeMobiList:(MobiList *)aList {
	[allLists removeObjectIdenticalTo:aList];
	
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:aList forKey:@"theRemovedList"];
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationMobiListRemoved
														object:self
													  userInfo:userInfo];
}

- (void)reset {
	allLists = [NSMutableArray array];
	notYetSyncedListIds = [NSMutableArray array];
	notYetSyncedEntryIds = [NSMutableArray array];
}

@end
