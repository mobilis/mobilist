//
//  GetListResponse.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 03.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "GetListResponse.h"

@implementation GetListResponse

- (id)init {
	self = [super initWithElementName:@"GetListResponse"
						  iqNamespace:@"mobilist:iq:getlist"
							 beanType:RESULT];
	
	return self;
}

- (void)fromXML:(NSXMLElement *)xml {
	
}

@end
