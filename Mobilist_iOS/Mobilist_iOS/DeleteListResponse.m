//
//  DeleteListResponse.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 08.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "DeleteListResponse.h"

@implementation DeleteListResponse

@synthesize listId;

- (id)init {
	self = [super initWithBeanType:RESULT];
	
	return self;
}

- (void)fromXML:(NSXMLElement *)xml {
	NSXMLElement* listIdElement = (NSXMLElement*) [xml childAtIndex:0];
	listId = [listIdElement stringValue];
}

+ (NSString *)elementName {
	return @"DeleteListResponse";
}

+ (NSString *)iqNamespace {
	return @"http://mobilis.inf.tu-dresden.de/Mobilist";
}

@end
