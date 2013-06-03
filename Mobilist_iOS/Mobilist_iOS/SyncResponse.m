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
	self = [super initWithElementName:@"SyncResponse"
						  iqNamespace:@"mobilist:iq:sync"
							 beanType:RESULT];
	
	return self;
}

- (void)fromXML:(NSXMLElement *)xml {
	NSXMLNode* listsElement = [xml childAtIndex:0];
	ListsSyncFromService* listsSyncFromService = [[ListsSyncFromService alloc] init];
	
	int listsElementChildCount = [listsElement childCount];
	
	for (int i = 0; i < listsElementChildCount; i++) {
		NSXMLNode* listElement = [listsElement childAtIndex:i];
		ListSyncFromService* listSyncFromService = [[ListSyncFromService alloc] init];
		[listSyncFromService setListId:[((NSXMLElement*) listElement) attributeStringValueForName:@"listId"]];
		[listSyncFromService setListCrc:[((NSXMLElement*) listElement) attributeStringValueForName:@"listCrc"]];
		
		[listsSyncFromService addListSyncFromService:listSyncFromService];
	}
	
	[self setLists:listsSyncFromService];
}

@end
