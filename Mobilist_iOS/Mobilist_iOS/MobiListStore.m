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
	
	if (!sharedInstance) {
		sharedInstance = [[MobiListStore alloc] init];
	}
	
	return sharedInstance;
}

- (id)init {
	self = [super init];
	
	if (self) {
		allLists = [NSMutableArray array];
		notYetSyncedListIds = [NSMutableArray array];
		
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

- (BOOL)isSyncedWithService:(MobiList *)aList {
	for (NSString* listId in notYetSyncedListIds) {
		if ([listId isEqualToString:[aList listId]]) {
			return false;
		}
	}
	
	return true;
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

- (void)setSyncedStatus:(BOOL )inSync
			  forListId:(NSString* )listId  {
	if (inSync) {
		// Find and remove the supplied listId from the
		// list of not yet synced ones
		for (NSString* notYetSyncedId in notYetSyncedListIds) {
			if ([notYetSyncedId isEqualToString:listId]) {
				[notYetSyncedListIds removeObject:notYetSyncedId];
			}
		}
	} else {
		// Add the supplied listId to the list of
		// not yet synced ones
		[notYetSyncedListIds addObject:listId];
	}
}

- (void)removeMobiList:(MobiList *)aList {
	[allLists removeObjectIdenticalTo:aList];
	
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:aList forKey:@"theRemovedList"];
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationMobiListRemoved
														object:self
													  userInfo:userInfo];
}

@end
