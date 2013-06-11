//  MobiAppDelegate.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 14.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "MobiAppDelegate.h"
#import "DashboardViewController.h"
#import <MXi/MXi.h>

@implementation MobiAppDelegate

@synthesize dashBoardController;

/*
 * Presence delegate
 */

- (void)didAuthenticate {
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:connection forKey:@"connection"];
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationConnectionEstablished
														object:self
													  userInfo:userInfo];
	
	SyncRequest* request = [[SyncRequest alloc] init];
	
	[connection sendBean:request];
}

- (void)didDisconnectWithError:(NSError* )error {
	
}

- (void)didFailToAuthenticate:(NSXMLElement* )error {
	NSLog(@"Failed to authenticate");
}

/*
 * Stanza delegate
 */

- (void)didReceiveMessage:(XMPPMessage* )message {
	NSLog(@"Received message:\n%@", [message prettyXMLString]);
}

- (BOOL)didReceiveIQ:(XMPPIQ* )iq {
	NSLog(@"Received iq:\n%@", [iq prettyXMLString]);
	return true;
}

- (void)didReceivePresence:(XMPPPresence* )presence {
	NSLog(@"Received presence:\n%@", [presence prettyXMLString]);
}

- (void)didReceiveError:(NSXMLElement* )error {
	NSLog(@"Received error:\n%@", [error prettyXMLString]);
}

/*
 * Bean delegate
 */

- (void)didReceiveBean:(MXiBean<MXiIncomingBean> *)theBean {
	if ([theBean class] == [SyncResponse class]) {
		SyncResponse* syncResponse = (SyncResponse*) theBean;
		NSArray* lists = [[syncResponse lists] lists];
		
		for (ListSyncFromService* list in lists) {
			NSString* listId = [list listId];
			// TODO compare local and remote crc
			
			// CHeck if the List store knows this list already
			if (![[MobiListStore sharedStore] listByListId:listId]) {
				GetListRequest* getListRequest = [[GetListRequest alloc] init];
				[getListRequest setListId:listId];
				
				[connection sendBean:getListRequest];
			}
		}
	}
	
	if ([theBean class] == [GetListResponse class]) {
		GetListResponse* getListResponse = (GetListResponse*) theBean;
		[[MobiListStore sharedStore] addMobiList:[getListResponse list]
									newlyCreated:NO];
	}
	
	if ([theBean class] == [CreateListResponse class]) {
		CreateListResponse* createListResponse = (CreateListResponse*) theBean;
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[createListResponse listId]
															 forKey:@"listId"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationListCreationConfirmed
															object:self
														  userInfo:userInfo];
	}
	
	if ([theBean class] == [DeleteListResponse class]) {
		DeleteListResponse* deleteListResponse = (DeleteListResponse*) theBean;
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[deleteListResponse listId]
															 forKey:@"listId"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationListDeletionConfirmed
															object:self
														  userInfo:userInfo];
	}
	
	if ([theBean class] == [EditListResponse class]) {
		EditListResponse* editListResponse = (EditListResponse*) theBean;
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[editListResponse listId]
															 forKey:@"listId"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationListEditingConfirmed
															object:self
														  userInfo:userInfo];
	}
	
	if ([theBean class] == [CreateEntryResponse class]) {
		CreateEntryResponse* createEntryResponse = (CreateEntryResponse*) theBean;
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[createEntryResponse entryId]
															 forKey:@"entryId"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationEntryCreationConfirmed
															object:self
														  userInfo:userInfo];
	}
	
	if ([theBean class] == [EditEntryResponse class]) {
		EditEntryResponse* editEntryResponse = (EditEntryResponse*) theBean;
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[editEntryResponse entryId]
															 forKey:@"entryId"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationEntryEditingConfirmed
															object:self
														  userInfo:userInfo];
	}
}

/*
 * App delegate
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	//[MxiLog log];
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	dashBoardController = [[DashboardViewController alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:dashBoardController
											 selector:@selector(connectionEstablished:)
												 name:NotificationConnectionEstablished
											   object:nil];
	
	UINavigationController* navController = [[UINavigationController alloc]
											 initWithRootViewController:dashBoardController];
	[self.window setRootViewController:navController];
	
	self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	NSMutableArray* incomingBeanPrototypes = [NSMutableArray array];
	[incomingBeanPrototypes addObject:[[SyncResponse alloc] init]];
	[incomingBeanPrototypes addObject:[[GetListResponse alloc] init]];
	[incomingBeanPrototypes addObject:[[CreateListResponse alloc] init]];
	[incomingBeanPrototypes addObject:[[DeleteListResponse alloc] init]];
	[incomingBeanPrototypes addObject:[[EditListResponse alloc] init]];
	[incomingBeanPrototypes addObject:[[CreateEntryResponse alloc] init]];
	[incomingBeanPrototypes addObject:[[EditEntryResponse alloc] init]];
	
	// 192.168.1.51
	connection = [MXiConnection connectionWithJabberID:@"test@mymac.box/res"
											  password:@"abc"
											  hostName:@"localhost"
									  presenceDelegate:self
										stanzaDelegate:self
										  beanDelegate:self
							 listeningForIncomingBeans:incomingBeanPrototypes];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
