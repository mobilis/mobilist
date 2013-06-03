//
//  ListsSyncFromService.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 03.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListSyncFromService.h"

@interface ListsSyncFromService : NSObject

@property (nonatomic, strong) NSMutableArray* lists;

- (id)init;

- (void)addListSyncFromService:(ListSyncFromService* )list;

@end
