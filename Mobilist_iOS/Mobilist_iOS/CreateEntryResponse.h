//
//  CreateEntryResponse.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 10.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <MXi/MXi.h>

@interface CreateEntryResponse : MXiBean <MXiIncomingBean>

@property (nonatomic, strong) NSString* entryId;

- (id)init;

@end
