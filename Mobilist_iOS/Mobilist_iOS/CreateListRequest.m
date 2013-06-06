//
//  CreateListRequest.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 05.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "CreateListRequest.h"

@implementation CreateListRequest

@synthesize list;

- (id)init {
	self = [super initWithBeanType:SET];
	
	return self;
}

- (NSXMLElement *)toXML {
	NSXMLElement* beanElement = [NSXMLElement elementWithName:[[self class] elementName]
														xmlns:[[self class] iqNamespace]];
	
	NSXMLElement* listElement = [NSXMLElement elementWithName:@"list"];
	[listElement addAttributeWithName:@"listName" stringValue:[list listName]];
	[listElement addAttributeWithName:@"listId" stringValue:[list listId]];
	
	for (MobiListEntry* entry in [list listEntries]) {
		NSXMLElement* entryElement = [NSXMLElement elementWithName:@"entry"];
		
		NSXMLElement* entryIdElement = [NSXMLElement elementWithName:@"entryId" stringValue:[entry entryId]];
		[entryElement addChild:entryIdElement];
		NSXMLElement* titleElement = [NSXMLElement elementWithName:@"title" stringValue:[entry title]];
		[entryElement addChild:titleElement];
		NSXMLElement* descriptionElement = [NSXMLElement elementWithName:@"description" stringValue:[entry description]];
		[entryElement addChild:descriptionElement];
		NSXMLElement* dueDateElement = [NSXMLElement elementWithName:@"dueDate"
														 stringValue:[NSString stringWithFormat:@"%lf",
																	  [[entry dueDate] timeIntervalSince1970]]];
		[entryElement addChild:dueDateElement];
		
		NSString* doneStringValue;
		if ([entry done]) {
			doneStringValue = @"true";
		} else {
			doneStringValue = @"false";
		}
		NSXMLElement* doneElement = [NSXMLElement elementWithName:@"done" stringValue:doneStringValue];
		[entryElement addChild:doneElement];
		
		[listElement addChild:entryElement];
	}
	
	return beanElement;
}

+ (NSString *)elementName {
	return @"CreateListRequest";
}

+ (NSString *)iqNamespace {
	return @"mobilist:iq:createlist";
}

@end
