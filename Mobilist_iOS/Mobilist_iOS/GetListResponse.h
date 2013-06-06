//
//  GetListResponse.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 03.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <MXi/MXi.h>
#import "MobiList.h"
#import "MobiListEntry.h"
#import "NSString+XMLDecoding.h"

@interface GetListResponse : MXiBean <MXiIncomingBean>

@property (nonatomic, strong) MobiList* list;

@end
