//
//  EntryCreatedAccept.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <MXi/MXi.h>

@interface EntryCreatedAccept : MXiBean <MXiOutgoingBean>

@property (nonatomic, strong) NSString* entryId;

- (id)init;

@end
