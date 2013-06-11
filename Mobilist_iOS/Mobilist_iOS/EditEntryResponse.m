//
//  EditEntryResponse.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 11.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "EditEntryResponse.h"

@implementation EditEntryResponse

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
	return @"EditEntryResponse";
}

+ (NSString *)iqNamespace {
	return @"mobilist:iq:editentry";
}

@end
