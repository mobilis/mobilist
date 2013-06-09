//
//  EditListResponse.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 09.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <MXi/MXi.h>

@interface EditListResponse : MXiBean <MXiIncomingBean>

@property (nonatomic, strong) NSString* listId;

- (id)init;

@end
