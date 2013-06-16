//
//  EntryEditedInfo.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 16.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <MXi/MXi.h>
#import "MobiListEntry.h"
#import "NSString+XMLDecoding.h"

@interface EntryEditedInfo : MXiBean <MXiIncomingBean>

@property (nonatomic, strong) NSString* listId;
@property (nonatomic, strong) MobiListEntry* entry;

- (id)init;

@end
