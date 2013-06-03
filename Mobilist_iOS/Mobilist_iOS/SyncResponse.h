//
//  SyncResponse.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 02.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <MXi/MXi.h>
#import "ListsSyncFromService.h"

@interface SyncResponse : MXiBean <MXiIncomingBean>

@property (nonatomic, strong) ListsSyncFromService* lists;

- (id)init;

@end
