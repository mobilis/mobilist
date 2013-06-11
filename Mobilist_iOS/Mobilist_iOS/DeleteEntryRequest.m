//
//  DeleteEntryRequest.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 11.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "DeleteEntryRequest.h"

@implementation DeleteEntryRequest

@synthesize listId, entryId;

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
	
	NSXMLElement* entryIdElement = [NSXMLElement elementWithName:@"entryId"];
	[entryIdElement setStringValue:entryId];
	[beanElement addChild:entryIdElement];
	
	return beanElement;
}

+ (NSString *)elementName {
	return @"DeleteEntryRequest";
}

+ (NSString *)iqNamespace {
	return @"mobilist:iq:deleteentry";
}

@end
