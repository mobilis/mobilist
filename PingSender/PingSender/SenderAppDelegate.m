//
//  SenderAppDelegate.m
//  PingSender
//
//  Created by Richard Wotzlaw on 03.09.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "SenderAppDelegate.h"

@implementation SenderAppDelegate

@synthesize connection;

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
	
	PingRequest* request = [[PingRequest alloc] init];
	[request setContent:@"Hello world"];
	[[self connection] sendBean:request];
}

- (void)didDisconnectWithError:(NSError *)error {
	
}

- (void)didFailToAuthenticate:(NSXMLElement *)error {
	
}

- (void)didReceiveBean:(MXiBean<MXiIncomingBean> *)theBean {
	if ([theBean class] == [PingResponse class]) {
		PingResponse* response = (PingResponse*) theBean;
		NSLog(@"Received PingResponse with content: %@", [response content]);
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

@end
