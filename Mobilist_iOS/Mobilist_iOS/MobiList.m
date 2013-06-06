//
//  MobiList.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 18.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "MobiList.h"

@implementation MobiList

@synthesize listId, listName, listEntries;

- (id)init {
	self = [super init];
	
	if (self) {
		listEntries = [NSMutableArray array];
	}
	
	return self;
}

- (void)addListEntry:(MobiListEntry *)aListEntry {
	[[self listEntries] addObject:aListEntry];
}

- (void)removeListEntry:(MobiListEntry *)aListEntry {
	[[self listEntries] removeObjectIdenticalTo:aListEntry];
}

- (MobiListEntry *)entryAtIndex:(NSInteger)index {
	return [[self listEntries] objectAtIndex:index];
}

@end
