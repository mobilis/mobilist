//
//  EditEntryResponse.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 11.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <MXi/MXi.h>

@interface EditEntryResponse : MXiBean <MXiIncomingBean>

@property (nonatomic, strong) NSString* entryId;

- (id)init;

@end
