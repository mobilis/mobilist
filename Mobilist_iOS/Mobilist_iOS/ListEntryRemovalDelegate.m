//
//  ListEntryRemovalDelegate.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 28.05.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "ListEntryRemovalDelegate.h"

@implementation ListEntryRemovalDelegate

- (id)initWithList:(MobiList *)aList removeIndex:(NSInteger)anIndex {
	self = [super init];
	
	if (self) {
		theList = aList;
		index = anIndex;
	}
	
	return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	MobiListEntry* theEntry = [theList entryAtIndex:index];
	
	NSLog(@"%d", buttonIndex);
}

@end
