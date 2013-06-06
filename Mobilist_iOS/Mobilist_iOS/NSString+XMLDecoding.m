//
//  NSString+XMLDecoding.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 05.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "NSString+XMLDecoding.h"

@implementation NSString (XMLDecoding)

- (NSString *)stringByCorrectingXMLDecoding {
	NSString* result = [self stringByReplacingOccurrencesOfString:@"Ã" withString:@"ß"];
	result = [result stringByReplacingOccurrencesOfString:@"Ã¶" withString:@"ä"];
	result = [result stringByReplacingOccurrencesOfString:@"Ã¤" withString:@"ö"];
	result = [result stringByReplacingOccurrencesOfString:@"Ã¼" withString:@"ü"];
	return result;
}

@end
