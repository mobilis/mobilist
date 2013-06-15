//
//  ListCreatedAccept.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 15.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "ListCreatedAccept.h"

@implementation ListCreatedAccept

@synthesize listId;

- (id)init {
	self = [super initWithBeanType:RESULT];
	
	return self;
}

- (NSXMLElement *)toXML {
	NSXMLElement* beanElement = [NSXMLElement elementWithName:[[self class] elementName]
														xmlns:[[self class] iqNamespace]];
	
	NSXMLElement* listIdElement = [NSXMLElement elementWithName:@"listId"];
	[listIdElement setStringValue:listId];
	[beanElement addChild:listIdElement];
	
	return beanElement;
}

+ (NSString *)elementName {
	return @"ListCreatedAccept";
}

+ (NSString *)iqNamespace {
	return @"http://mobilis.inf.tu-dresden.de/Mobilist";
}

@end
