//
//  EditListRequest.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 09.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "EditListRequest.h"

@implementation EditListRequest

@synthesize list;

- (id)init {
	self = [super initWithBeanType:SET];
	
	return self;
}

- (NSXMLElement *)toXML {
	NSLog(@"inside toXML");
	NSXMLElement* beanElement = [NSXMLElement elementWithName:[[self class] elementName]
														xmlns:[[self class] iqNamespace]];
	
	NSXMLElement* listElement = [NSXMLElement elementWithName:@"list"];
	
	NSXMLElement* listNameElement = [NSXMLElement elementWithName:@"listName"];
	[listNameElement setStringValue:[list listName]];
	[listElement addChild:listNameElement];
	
	NSXMLElement* listIdElement = [NSXMLElement elementWithName:@"listId"];
	[listIdElement setStringValue:[list listId]];
	[listElement addChild:listIdElement];
	
	NSXMLElement* entriesElement = [NSXMLElement elementWithName:@"entries"];
	
	for (MobiListEntry* entry in [list listEntries]) {
		NSXMLElement* entryElement = [NSXMLElement elementWithName:@"entry"];
		
		NSXMLElement* entryIdElement = [NSXMLElement elementWithName:@"entryId" stringValue:[entry entryId]];
		[entryElement addChild:entryIdElement];
		NSXMLElement* titleElement = [NSXMLElement elementWithName:@"title" stringValue:[entry title]];
		[entryElement addChild:titleElement];
		NSXMLElement* descriptionElement = [NSXMLElement elementWithName:@"description" stringValue:[entry description]];
		[entryElement addChild:descriptionElement];
		NSXMLElement* dueDateElement = [NSXMLElement elementWithName:@"dueDate"
														 stringValue:[NSString stringWithFormat:@"%d", [entry dueDate]]];
		[entryElement addChild:dueDateElement];
		
		NSString* doneStringValue;
		if ([entry done]) {
			doneStringValue = @"true";
		} else {
			doneStringValue = @"false";
		}
		NSXMLElement* doneElement = [NSXMLElement elementWithName:@"done" stringValue:doneStringValue];
		[entryElement addChild:doneElement];
		
		[entriesElement addChild:entryElement];
	}
	
	[listElement addChild:entriesElement];
	[beanElement addChild:listElement];
	
	return beanElement;
}

+ (NSString *)elementName {
	return @"EditListRequest";
}

+ (NSString *)iqNamespace {
	return @"mobilist:iq:editlist";
}

@end
