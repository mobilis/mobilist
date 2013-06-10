//
//  CreateEntryResponse.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 10.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "CreateEntryResponse.h"

@implementation CreateEntryResponse

@synthesize entryId;

- (id)init {
	self = [super initWithBeanType:RESULT];
	
	return self;
}

- (void)fromXML:(NSXMLElement *)xml {
	NSXMLElement* entryIdElement = (NSXMLElement*) [xml childAtIndex:0];
	entryId = [entryIdElement stringValue];
}

+ (NSString *)elementName {
	return @"CreateEntryResponse";
}

+ (NSString *)iqNamespace {
	return @"mobilist:iq:createentry";
}

@end
