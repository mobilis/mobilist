//
//  SenderAppDelegate.h
//  PingSender
//
//  Created by Richard Wotzlaw on 03.09.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MXi/MXi.h>
#import "PingRequest.h"
#import "PingResponse.h"

@interface SenderAppDelegate : NSObject <NSApplicationDelegate, MXiBeanDelegate, MXiPresenceDelegate, MXiStanzaDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) MXiConnection* connection;

@end
