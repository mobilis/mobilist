//
//  ListsSyncFromService.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 03.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "ListsSyncFromService.h"

@implementation ListsSyncFromService

@synthesize lists;

- (id)init {
	self = [super init];
	
	if (self) {
		lists = [NSMutableArray array];
	}
	
	return self;
}

- (void)addListSyncFromService:(ListSyncFromService* )list {
	[lists addObject:list];
}

@end
