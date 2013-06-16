//
//  ListEditedInfo.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 15.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <MXi/MXi.h>
#import "MobiList.h"
#import "NSString+XMLDecoding.h"

@interface ListEditedInfo : MXiBean <MXiIncomingBean>

@property (nonatomic, strong) MobiList* list;

- (id)init;

@end
