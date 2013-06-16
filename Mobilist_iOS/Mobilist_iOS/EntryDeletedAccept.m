//
//  EntryDeletedAccept.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "EntryDeletedAccept.h"

@implementation EntryDeletedAccept

@synthesize entryId;

- (id)init {
	self = [super initWithBeanType:RESULT];
	
	return self;
}

- (NSXMLElement *)toXML {
	NSXMLElement* beanElement = [NSXMLElement elementWithName:[[self class] elementName]
														xmlns:[[self class] iqNamespace]];
	
	NSXMLElement* entryIdElement = [NSXMLElement elementWithName:@"entryId"];
	[entryIdElement setStringValue:entryId];
	[beanElement addChild:entryIdElement];
	
	return beanElement;
}

+ (NSString *)elementName {
	return @"EntryDeletedAccept";
}

+ (NSString *)iqNamespace {
	return @"http://mobilis.inf.tu-dresden.de/Mobilist";
}

@end
