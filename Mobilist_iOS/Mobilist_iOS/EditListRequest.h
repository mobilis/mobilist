//
//  EditListRequest.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 09.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <MXi/MXi.h>
#import "MobiList.h"

@interface EditListRequest : MXiBean <MXiOutgoingBean>

@property (nonatomic, strong) MobiList* list;

- (id)init;

@end
