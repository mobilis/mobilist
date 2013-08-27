//
//  Constants.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 08.06.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const NotificationMobiListAdded;
extern NSString* const NotificationMobiListRemoved;
extern NSString* const NotificationConnectionEstablished;
extern NSString* const NotificationListCreationConfirmed;
extern NSString* const NotificationListDeletionConfirmed;
extern NSString* const NotificationListEditingConfirmed;
extern NSString* const NotificationEntryCreationConfirmed;
extern NSString* const NotificationEntryEditingConfirmed;
extern NSString* const NotificationEntryDeletionConfirmed;
extern NSString* const NotificationListCreatedInformed;
extern NSString* const NotificationListEditedInformed;
extern NSString* const NotificationListDeletedInformed;
extern NSString* const NotificationEntryCreatedInformed;
extern NSString* const NotificationEntryEditedInformed;
extern NSString* const NotificationEntryDeletedInformed;

extern NSString* const CellTodoListEntry;
extern NSString* const CellTodoList;

extern NSString* const UserDefaultJabberId;
extern NSString* const UserDefaultPassword;
extern NSString* const UserDefaultHostname;
extern NSString* const UserDefaultServiceNamespace;
extern NSString* const UserDefaultCoordinatorJID;
extern NSString* const UserDefaultPort;

@interface Constants : NSObject

@end
