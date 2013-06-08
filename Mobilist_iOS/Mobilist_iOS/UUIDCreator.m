//
//  UUIDCreator.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 07.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "UUIDCreator.h"

@implementation UUIDCreator

+ (NSString *)createUUID {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	NSString *uuidStr = (__bridge_transfer NSString*) CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
	return uuidStr;
}

@end
