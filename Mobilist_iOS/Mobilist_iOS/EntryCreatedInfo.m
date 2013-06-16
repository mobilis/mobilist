//
//  EntryCreatedInfo.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "EntryCreatedInfo.h"

@implementation EntryCreatedInfo

@synthesize listId, entry;

- (id)init {
	self = [super initWithBeanType:SET];
	
	return self;
}

- (void)fromXML:(NSXMLElement *)xml {
	NSXMLElement* listIdElement = (NSXMLElement*) [xml childAtIndex:0];
	listId = [listIdElement stringValue];
	
	NSXMLElement* entryElement = (NSXMLElement*) [xml childAtIndex:1];
	entry = [[MobiListEntry alloc] init];
	[entry setEntryId:[[[entryElement elementForName:@"entryId"] stringValue] stringByCorrectingXMLDecoding]];
	
	[entry setTitle:[[[entryElement elementForName:@"title"] stringValue] stringByCorrectingXMLDecoding]];
	
	[entry setDescription:[[[entryElement elementForName:@"description"] stringValue] stringByCorrectingXMLDecoding]];
	
	NSInteger dueDate = [[[entryElement elementForName:@"dueDate"] stringValue] integerValue];
	[entry setDueDate:dueDate];
	
	NSString* doneString = [[entryElement elementForName:@"done"] stringValue];
	if ([[doneString lowercaseString] isEqualToString:@"true"]) {
		[entry setDone:YES];
	} else {
		[entry setDone:NO];
	}
}

+ (NSString *)elementName {
	return @"EntryCreatedInfo";
}

+ (NSString *)iqNamespace {
	return @"http://mobilis.inf.tu-dresden.de/Mobilist";
}

@end
