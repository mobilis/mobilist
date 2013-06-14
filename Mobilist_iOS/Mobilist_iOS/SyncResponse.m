//
//  SyncResponse.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 02.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "SyncResponse.h"

@implementation SyncResponse

- (id)init {
	self = [super initWithBeanType:RESULT];
	
	return self;
}

- (void)fromXML:(NSXMLElement *)xml {
	NSXMLNode* listsElement = [xml childAtIndex:0];
	ListsSyncFromService* listsSyncFromService = [[ListsSyncFromService alloc] init];
	
	for (int i = 0; i < [listsElement childCount]; i++) {
		NSXMLNode* listElement = [listsElement childAtIndex:i];
		ListSyncFromService* listSyncFromService = [[ListSyncFromService alloc] init];
		
		[listSyncFromService setListId:[[((NSXMLElement*) listElement) attributeStringValueForName:@"listId"]
										stringByCorrectingXMLDecoding]];
		[listSyncFromService setListCrc:[[((NSXMLElement*) listElement) attributeStringValueForName:@"listCrc"]
										 stringByCorrectingXMLDecoding]];
		
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
