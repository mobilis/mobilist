//
//  UserDefaultUtil.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 14.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultUtil : NSObject

+ (BOOL)isUserDefaultSet:(NSString* )userDefaultName;

@end
