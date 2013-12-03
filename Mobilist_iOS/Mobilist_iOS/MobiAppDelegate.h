//
//  MobiAppDelegate.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 14.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "SyncRequest.h"
#import "SyncResponse.h"
#import "GetListRequest.h"
#import "GetListResponse.h"
#import "CreateListRequest.h"
#import "CreateListResponse.h"
#import "DeleteListRequest.h"
#import "DeleteListResponse.h"
#import "EditListResponse.h"
#import "CreateEntryResponse.h"
#import "EditEntryResponse.h"
#import "DeleteEntryRequest.h"
#import "ListCreatedInfo.h"
#import "ListCreatedAccept.h"
#import "ListEditedInfo.h"
#import "ListEditedAccept.h"
#import "ListDeletedInfo.h"
#import "ListDeletedAccept.h"
#import "EntryCreatedInfo.h"
#import "EntryCreatedAccept.h"
#import "EntryEditedInfo.h"
#import "EntryEditedAccept.h"
#import "EntryDeletedInfo.h"
#import "EntryDeletedAccept.h"

@class DashboardViewController;

@interface MobiAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property BOOL areXMPPSettingsSufficient;

- (BOOL)isSufficientJabberID:(NSString* )jabberID
					password:(NSString* )password
			serviceNamespace:(NSString* )serviceNamespace;

@end
