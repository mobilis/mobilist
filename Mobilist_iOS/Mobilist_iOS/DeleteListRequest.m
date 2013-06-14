//
//  DeleteListRequest.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 08.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "DeleteListRequest.h"

@implementation DeleteListRequest

@synthesize listId;

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
	
	return beanElement;
}

+ (NSString *)elementName {
	return @"DeleteListRequest";
}

+ (NSString *)iqNamespace {
	return @"http://mobilis.inf.tu-dresden.de/Mobilist";
}

@end
