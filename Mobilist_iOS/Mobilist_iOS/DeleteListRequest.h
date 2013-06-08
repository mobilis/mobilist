//
//  DeleteListRequest.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 08.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <MXi/MXi.h>

@interface DeleteListRequest : MXiBean <MXiOutgoingBean>

@property (nonatomic, strong) NSString* listId;

- (id)init;

@end
