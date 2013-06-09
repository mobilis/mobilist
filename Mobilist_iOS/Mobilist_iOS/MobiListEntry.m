//
//  MobiListEntry.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 18.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "MobiListEntry.h"

@implementation MobiListEntry

@synthesize entryId, title, description, dueDate, done;

- (id)init {
	self = [super init];
	
	return self;
}

- (NSDate* )dueDateAsDate {
	return [NSDate dateWithTimeIntervalSince1970:dueDate];
}

@end
