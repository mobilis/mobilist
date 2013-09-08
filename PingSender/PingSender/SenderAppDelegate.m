//
//  SenderAppDelegate.m
//  PingSender
//
//  Created by Richard Wotzlaw on 03.09.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "SenderAppDelegate.h"

@implementation SenderAppDelegate

@synthesize connection, serviceJID = _serviceJID;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSMutableArray* incomingPrototypes = [NSMutableArray array];
	[incomingPrototypes addObject:[[PingResponse alloc] init]];
	
	[self setConnection:[MXiConnection connectionWithJabberID:@"richard@mobilis-dev.inf.tu-dresden.de/sender"
													 password:@"richard@mobilis"
													 hostName:@"mobilis-dev.inf.tu-dresden.de"
														 port:5222
											   coordinatorJID:@"mobilis@mobilis-dev.inf.tu-dresden.de/Coordinator"
											 serviceNamespace:@"http://mobilis.inf.tu-dresden.de#services/MobilistService"
											 presenceDelegate:self
											   stanzaDelegate:self
												 beanDelegate:self
									listeningForIncomingBeans:incomingPrototypes]];
}

- (void)didAuthenticate {
	
}

- (void)didDiscoverServiceWithNamespace:(NSString *)serviceNamespace
								   name:(NSString *)serviceName
								version:(NSInteger)version
							 atJabberID:(NSString *)serviceJID {
	[self setServiceJID:serviceJID];
	NSLog(@"Ready");
}

- (void)didDisconnectWithError:(NSError *)error {
	
}

- (void)didFailToAuthenticate:(NSXMLElement *)error {
	
}

- (void)didReceiveBean:(MXiBean<MXiIncomingBean> *)theBean {
	if ([theBean class] == [PingResponse class]) {
		NSDate* now = [NSDate date];
		
		PingResponse* response = (PingResponse*) theBean;
		NSString* pingContent = [response content];
		
		NSTimeInterval requestTimeStampInterval = [pingContent doubleValue];
		NSDate* requestTime = [NSDate dateWithTimeIntervalSince1970:requestTimeStampInterval];
		
		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterNoStyle];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		NSString* requestTimeString = [dateFormatter stringFromDate:requestTime];
		NSString* nowString = [dateFormatter stringFromDate:now];
		
		NSLog(@"Ping sent at %@, received at %@", requestTimeString, nowString);
	}
}

- (void)didReceiveMessage:(XMPPMessage *)message {
	
}

- (BOOL)didReceiveIQ:(XMPPIQ *)iq {
	return true;
}

- (void)didReceivePresence:(XMPPPresence *)presence {
	
}

- (void)didReceiveError:(NSXMLElement *)error {
	
}

- (IBAction)sendPingClicked:(id)sender {
	if ([self serviceJID]) {
		NSTimeInterval timeStampInterval = [[NSDate date] timeIntervalSince1970];
		NSNumber* timeStamp = [NSNumber numberWithDouble:timeStampInterval];
		
		PingRequest* ping = [[PingRequest alloc] init];
		[ping setContent:[NSString stringWithFormat:@"%ld", (long) [timeStamp integerValue]]];
		[connection sendBean:ping];
	}
}

- (IBAction)startPingLoopClicked:(id)sender {
	if (![self serviceJID]) {
		return;
	}
	
	NSThread* pingThread = [[NSThread alloc] initWithTarget:self
												   selector:@selector(runPingLoop)
													 object:nil];
	[pingThread start];
}

- (void)runPingLoop {
	PingRequest* ping = [[PingRequest alloc] init];
	NSTimeInterval timeStampInterval;
	NSNumber* timeStamp;
	
	while (YES) {
		timeStampInterval = [[NSDate date] timeIntervalSince1970];
		timeStamp = [NSNumber numberWithDouble:timeStampInterval];
		[ping setContent:[NSString stringWithFormat:@"%ld", (long)[timeStamp integerValue]]];
		[connection sendBean:ping];
		
		sleep(1);
	}
}

@end
