//
//  DeleteEntryResponse.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 11.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "DeleteEntryResponse.h"

@implementation DeleteEntryResponse

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
	return @"DeleteEntryResponse";
}

+ (NSString *)iqNamespace {
	return @"mobilist:iq:deleteentry";
}

@end
