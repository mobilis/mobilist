//
//  UserDefaultUtil.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 14.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "UserDefaultUtil.h"

@implementation UserDefaultUtil

+ (BOOL)isUserDefaultSet:(NSString *)userDefaultName {
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	
	if ([userDefaults objectForKey:userDefaultName]) {
		return YES;
	}
	
	return NO;
}

@end
