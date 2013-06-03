//
//  SyncRequest.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 01.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "SyncRequest.h"

@implementation SyncRequest

- (id)init {
	self = [super initWithElementName:@"SyncRequest"
						  iqNamespace:@"mobilist:iq:sync"
							 beanType:GET];
	
	return self;
}

- (NSXMLElement *)toXML {
	NSXMLElement* beanElement = [NSXMLElement elementWithName:[self elementName] xmlns:[self iqNamespace]];
	
	return beanElement;
}

@end
