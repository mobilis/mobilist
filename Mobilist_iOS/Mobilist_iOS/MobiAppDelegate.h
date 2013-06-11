//
//  MobiAppDelegate.h
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 14.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MXi/MXi.h>
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
#import "DashboardViewController.h"

@interface MobiAppDelegate : UIResponder <UIApplicationDelegate, MXiPresenceDelegate,
		MXiStanzaDelegate, MXiBeanDelegate>
{
	MXiConnection* connection;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DashboardViewController* dashBoardController;

@end
