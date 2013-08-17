//
//  SyncResponse.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 02.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "SyncResponse.h"

@implementation SyncResponse

@synthesize lists;

- (id)init {
	self = [super initWithBeanType:RESULT];
	
	return self;
}

- (void)fromXML:(NSXMLElement *)xml {
	NSXMLElement* listsElement = (NSXMLElement*) [xml elementForName:@"lists"];
	ListsSyncFromService* listsSyncFromService = [[ListsSyncFromService alloc] init];
	
	for (int i = 0; i < [listsElement childCount]; i++) {
		NSXMLElement* listElement = (NSXMLElement*) [listsElement childAtIndex:i];
		ListSyncFromService* listSyncFromService = [[ListSyncFromService alloc] init];
		
		NSXMLElement* listIdElement = (NSXMLElement*) [listElement elementForName:@"listId"];
		[listSyncFromService setListId:[[listIdElement stringValue] stringByCorrectingXMLDecoding]];
		
		NSXMLElement* listCrcElement = (NSXMLElement*) [listElement elementForName:@"listCrc"];
		[listSyncFromService setListCrc:[[listCrcElement stringValue] stringByCorrectingXMLDecoding]];
		
		[listsSyncFromService addListSyncFromService:listSyncFromService];
	}
	
	[self setLists:listsSyncFromService];
}

+ (NSString *)elementName {
	return @"SyncResponse";
}

+ (NSString *)iqNamespace {
	return @"http://mobilis.inf.tu-dresden.de/Mobilist";
}

@end
