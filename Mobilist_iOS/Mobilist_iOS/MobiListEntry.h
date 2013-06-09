//
//  MobiListEntry.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 18.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobiListEntry : NSObject

@property (nonatomic, strong) NSString* entryId;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* description;
@property (nonatomic) NSInteger dueDate;
@property (nonatomic) BOOL done;

- (id)init;

- (NSDate* )dueDateAsDate;

@end
