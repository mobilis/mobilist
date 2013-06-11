//
//  EditEntryRequest.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 11.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "EditEntryRequest.h"

@implementation EditEntryRequest

@synthesize listId, entry;

- (id)init {
	self = [super initWithBeanType:SET];
	
	return self;
}

- (NSXMLElement *)toXML {
	NSXMLElement* beanElement = [NSXMLElement elementWithName:[[self class] elementName]
														xmlns:[[self class] iqNamespace]];
	
	NSXMLElement* listIdElement = [NSXMLElement elementWithName:@"listId"];
	[listIdElement setStringValue:listId];
	[beanElement addChild:listIdElement];
	
	NSXMLElement* entryElement = [NSXMLElement elementWithName:@"entry"];
	NSXMLElement* entryIdElement = [NSXMLElement elementWithName:@"entryId"];
	[entryIdElement setStringValue:[entry entryId]];
	[entryElement addChild:entryIdElement];
	NSXMLElement* titleElement = [NSXMLElement elementWithName:@"title"];
	[titleElement setStringValue:[entry title]];
	[entryElement addChild:titleElement];
	NSXMLElement* descriptionElement = [NSXMLElement elementWithName:@"description"];
	[descriptionElement setStringValue:[entry description]];
	[entryElement addChild:descriptionElement];
	NSXMLElement* dueDateElement = [NSXMLElement elementWithName:@"dueDate"];
	[dueDateElement setStringValue:[NSString stringWithFormat:@"%d", [entry dueDate]]];
	[entryElement addChild:dueDateElement];
	NSXMLElement* doneElement = [NSXMLElement elementWithName:@"done"];
	NSString* doneStringValue;
	if ([entry done]) {
		doneStringValue = @"true";
	} else {
		doneStringValue = @"false";
	}
	[doneElement setStringValue:doneStringValue];
	[entryElement addChild:doneElement];
	
	[beanElement addChild:entryElement];
	
	return beanElement;
}

+ (NSString *)elementName {
	return @"EditEntryRequest";
}

+ (NSString *)iqNamespace {
	return @"mobilist:iq:editentry";
}

@end
