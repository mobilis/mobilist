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

- (NSXMLElement* )payloadToXML {
	return nil;
}

- (NSDictionary *)beanAttributes {
	NSMutableDictionary* attrs = [NSMutableDictionary dictionaryWithObject:listId forKey:@"id"];
	return attrs;
}

@end
