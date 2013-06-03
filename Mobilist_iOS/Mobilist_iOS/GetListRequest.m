//
//  GetListRequest.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 01.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "GetListRequest.h"

@implementation GetListRequest

@synthesize listId;

- (id)init {
	self = [super initWithElementName:@"GetListRequest"
						  iqNamespace:@"mobilist:iq:getlist"
							 beanType:GET];
	
	return self;
}

- (NSXMLElement* )toXML {
	NSXMLElement* beanElement = [NSXMLElement elementWithName:[self elementName] xmlns:[self iqNamespace]];
	NSXMLElement* listIdElement = [NSXMLElement elementWithName:@"listId"];
	
	[listIdElement setStringValue:[self listId]];
	[beanElement addChild:listIdElement];
	
	return beanElement;
}

@end
