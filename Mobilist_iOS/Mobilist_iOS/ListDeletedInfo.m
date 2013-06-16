//
//  ListDeletedInfo.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "ListDeletedInfo.h"

@implementation ListDeletedInfo

@synthesize listId;

- (id)init {
	self = [super initWithBeanType:SET];
	
	return self;
}

- (void)fromXML:(NSXMLElement *)xml {
	NSXMLElement* listIdElement = (NSXMLElement*) [xml childAtIndex:0];
	listId = [listIdElement stringValue];
}

+ (NSString *)elementName {
	return @"ListDeletedInfo";
}

+ (NSString *)iqNamespace {
	return @"http://mobilis.inf.tu-dresden.de/Mobilist";
}

@end
