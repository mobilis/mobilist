//
//  ListEditedAccept.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 15.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <MXi/MXi.h>

@interface ListEditedAccept : MXiBean <MXiOutgoingBean>

@property (nonatomic, strong) NSString* listId;

- (id)init;

@end
