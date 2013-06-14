//
//  GetListResponse.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 03.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "GetListResponse.h"

@implementation GetListResponse

@synthesize list;

- (id)init {
	self = [super initWithBeanType:RESULT];
	
	return self;
}

- (void)fromXML:(NSXMLElement *)xml {
	NSXMLElement* listElement = (NSXMLElement*) [xml childAtIndex:0];
	NSXMLElement* listNameElement = [listElement elementForName:@"listName"];
	NSString* listName = [[listNameElement stringValue] stringByCorrectingXMLDecoding];
	NSXMLElement* listIdElement = [listElement elementForName:@"listId"];
	NSString* listId = [[listIdElement stringValue] stringByCorrectingXMLDecoding];
	
	MobiList* listObj = [[MobiList alloc] init];
	
	[listObj setListName:listName];
	[listObj setListId:listId];
	
	NSXMLElement* entriesElement = [listElement elementForName:@"entries"];
	
	for (int i = 0; i < [entriesElement childCount]; i++) {
		NSXMLElement* entryElement = (NSXMLElement*) [entriesElement childAtIndex:i];
		MobiListEntry* entry = [[MobiListEntry alloc] init];
		
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
		
		[listObj addListEntry:entry];
	}
	
	[self setList:listObj];
}

+ (NSString *)elementName {
	return @"GetListResponse";
}

+ (NSString *)iqNamespace {
	return @"http://mobilis.inf.tu-dresden.de/Mobilist";
}

@end
