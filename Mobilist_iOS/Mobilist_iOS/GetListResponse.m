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
	NSString* listName = [[listElement attributeStringValueForName:@"listName"] stringByCorrectingXMLDecoding];
	NSString* listId = [[listElement attributeStringValueForName:@"listId"] stringByCorrectingXMLDecoding];
	
	MobiList* listObj = [[MobiList alloc] init];
	
	[listObj setListName:listName];
	[listObj setListId:listId];
	
	for (int i = 0; i < [listElement childCount]; i++) {
		NSXMLElement* entryElement = (NSXMLElement*) [listElement childAtIndex:i];
		MobiListEntry* entry = [[MobiListEntry alloc] init];
		
		[entry setEntryId:[[[entryElement elementForName:@"id"] stringValue] stringByCorrectingXMLDecoding]];
		
		[entry setTitle:[[[entryElement elementForName:@"title"] stringValue] stringByCorrectingXMLDecoding]];
		
		[entry setDescription:[[[entryElement elementForName:@"description"] stringValue] stringByCorrectingXMLDecoding]];
		
		NSInteger dueDateTimestamp = [[[entryElement elementForName:@"dueDate"] stringValue] integerValue];
		[entry setDueDate:[NSDate dateWithTimeIntervalSince1970:dueDateTimestamp]];
		
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
	return @"mobilist:iq:getlist";
}

@end
