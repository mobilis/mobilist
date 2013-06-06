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
	self = [super initWithBeanType:GET];
	
	return self;
}

- (NSXMLElement *)toXML {
	NSXMLElement* beanElement = [NSXMLElement elementWithName:[[self class] elementName]
														xmlns:[[self class] iqNamespace]];
	
	return beanElement;
}

+ (NSString *)elementName {
	return @"SyncRequest";
}

+ (NSString *)iqNamespace {
	return @"mobilist:iq:sync";
}

@end
