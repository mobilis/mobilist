//
//  EditListResponse.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 09.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "EditListResponse.h"

@implementation EditListResponse

@synthesize listId;

- (id)init {
	self = [super initWithBeanType:RESULT];
	
	return self;
}

- (void)fromXML:(NSXMLElement* )xml {
	NSXMLElement* listIdElement = (NSXMLElement*) [xml childAtIndex:0];
	listId = [listIdElement stringValue];
}

+ (NSString *)elementName {
	return @"EditListResponse";
}

+ (NSString *)iqNamespace {
	return @"mobilist:iq:editlist";
}

@end
