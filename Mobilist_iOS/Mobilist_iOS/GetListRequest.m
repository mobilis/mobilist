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

- (NSXMLElement* )payloadToXML {
	NSXMLElement* listIdElement = [NSXMLElement elementWithName:@"listId"];
	[listIdElement setStringValue:listId];
	
	return listIdElement;
}

@end
