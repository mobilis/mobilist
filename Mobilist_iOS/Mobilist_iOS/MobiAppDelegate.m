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

@synthesize dashBoardController, areXMPPSettingsSufficient, authenticated, serviceJID;

/*
 * Presence delegate
 */

- (void)didAuthenticate {
	NSLog(@"Authentication successful");
}

- (void)didDiscoverServiceWithNamespace:(NSString *)serviceNamespace
								   name:(NSString *)serviceName
								version:(NSInteger)version
							 atJabberID:(NSString *)theServiceJID {
	NSLog(@"Service discovered");
	[self setAuthenticated:YES];
	
	[self setServiceJID:theServiceJID];
	[connection setServiceJID:theServiceJID];
	
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:connection forKey:@"connection"];
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationConnectionEstablished
														object:self
													  userInfo:userInfo];
	
	SyncRequest* request = [[SyncRequest alloc] init];
	
	[connection sendBean:request];
}

- (void)didCreateServiceWithJabberID:(NSString *)jabberID andVersion:(NSString *)version
{
    NSLog(@"Not required for SINGLE services");
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
	//NSLog(@"Received message:\n%@", [message prettyXMLString]);
}

- (BOOL)didReceiveIQ:(XMPPIQ* )iq {
	//NSLog(@"Received iq:\n%@", [iq prettyXMLString]);
	return true;
}

- (void)didReceivePresence:(XMPPPresence* )presence {
	//NSLog(@"Received presence:\n%@", [presence prettyXMLString]);
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
	
	if ([theBean class] == [DeleteEntryRequest class]) {
		DeleteEntryRequest* deleteEntryRequest = (DeleteEntryRequest*) theBean;
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[deleteEntryRequest entryId]
															 forKey:@"entryId"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationEntryDeletionConfirmed
															object:self
														  userInfo:userInfo];
	}
	
	if ([theBean class] == [ListCreatedInfo class]) {
		ListCreatedInfo* listCreatedInfo = (ListCreatedInfo*) theBean;
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[listCreatedInfo list] forKey:@"list"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationListCreatedInformed
															object:self
														  userInfo:userInfo];
		
		ListCreatedAccept* accept = [[ListCreatedAccept alloc] init];
		[accept setListId:[[listCreatedInfo list] listId]];
		[connection sendBean:accept];
	}
	
	if ([theBean class] == [ListEditedInfo class]) {
		ListEditedInfo* listEditedInfo = (ListEditedInfo*) theBean;
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[listEditedInfo list]
															 forKey:@"list"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationListEditedInformed
															object:self
														  userInfo:userInfo];
		
		ListEditedAccept* accept = [[ListEditedAccept alloc] init];
		[accept setListId:[[listEditedInfo list] listId]];
		[connection sendBean:accept];
	}
	
	if ([theBean class] == [ListDeletedInfo class]) {
		ListDeletedInfo* listDeletedInfo = (ListDeletedInfo*) theBean;
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[listDeletedInfo listId]
															 forKey:@"listId"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationListDeletedInformed
															object:self
														  userInfo:userInfo];
		
		ListDeletedAccept* accept = [[ListDeletedAccept alloc] init];
		[accept setListId:[listDeletedInfo listId]];
		[connection sendBean:accept];
	}
	
	if ([theBean class] == [EntryCreatedInfo class]) {
		EntryCreatedInfo* entryCreatedInfo = (EntryCreatedInfo*) theBean;
		NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
		[userInfo setObject:[entryCreatedInfo listId] forKey:@"listId"];
		[userInfo setObject:[entryCreatedInfo entry] forKey:@"entry"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationEntryCreatedInformed
															object:self
														  userInfo:userInfo];
		
		EntryCreatedAccept* accept = [[EntryCreatedAccept alloc] init];
		[accept setEntryId:[[entryCreatedInfo entry] entryId]];
		[connection sendBean:accept];
	}
	
	if ([theBean class] == [EntryEditedInfo class]) {
		EntryEditedInfo* entryEditedInfo = (EntryEditedInfo*) theBean;
		NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
		[userInfo setObject:[entryEditedInfo listId] forKey:@"listId"];
		[userInfo setObject:[entryEditedInfo entry] forKey:@"entry"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationEntryEditedInformed
															object:self
														  userInfo:userInfo];
		
		EntryEditedAccept* accept = [[EntryEditedAccept alloc] init];
		[accept setEntryId:[[entryEditedInfo entry] entryId]];
		[connection sendBean:accept];
	}
	
	if ([theBean class] == [EntryDeletedInfo class]) {
		EntryDeletedInfo* entryDeletedInfo = (EntryDeletedInfo*) theBean;
		NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
		[userInfo setObject:[entryDeletedInfo listId] forKey:@"listId"];
		[userInfo setObject:[entryDeletedInfo entryId] forKey:@"entryId"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationEntryDeletedInformed
															object:self
														  userInfo:userInfo];
		
		EntryDeletedAccept* accept = [[EntryDeletedAccept alloc] init];
		[accept setEntryId:[entryDeletedInfo entryId]];
		[connection sendBean:accept];
	}
}

- (BOOL)isSufficientJabberID:(NSString* )jabberID
					password:(NSString* )password
			  coordinatorJID:(NSString* )coordinatorJID
			serviceNamespace:(NSString* )serviceNamespace {
	if (jabberID && ![jabberID isEqualToString:@""] &&
		password && ![password isEqualToString:@""] &&
		coordinatorJID && ![coordinatorJID isEqualToString:@""] &&
		serviceNamespace && ![serviceNamespace isEqualToString:@""]) {
			return YES;
	}
	
	return NO;
}

/*
 * App delegate
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* jabberIdFromDefaults = [userDefaults stringForKey:UserDefaultJabberId];
	NSString* passwordFromDefaults = [userDefaults stringForKey:UserDefaultPassword];
	NSString* coordinatorJIDFromDefaults = [userDefaults stringForKey:UserDefaultCoordinatorJID];
	NSString* serviceNamespaceFromDefaults = [userDefaults stringForKey:UserDefaultServiceNamespace];
	
	[self setAreXMPPSettingsSufficient:[self isSufficientJabberID:jabberIdFromDefaults
														 password:passwordFromDefaults
												   coordinatorJID:coordinatorJIDFromDefaults
												 serviceNamespace:serviceNamespaceFromDefaults]];
	
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
	NSLog(@"%@", NSStringFromSelector(_cmd));
	authenticated = false;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSMutableArray* incomingBeanPrototypes = [NSMutableArray array];
	[incomingBeanPrototypes addObject:[[SyncResponse alloc] init]];
	[incomingBeanPrototypes addObject:[[GetListResponse alloc] init]];
	[incomingBeanPrototypes addObject:[[CreateListResponse alloc] init]];
	[incomingBeanPrototypes addObject:[[DeleteListResponse alloc] init]]; // EXC_BAD_ACCESS
	[incomingBeanPrototypes addObject:[[EditListResponse alloc] init]];
	[incomingBeanPrototypes addObject:[[CreateEntryResponse alloc] init]];
	[incomingBeanPrototypes addObject:[[EditEntryResponse alloc] init]];
	[incomingBeanPrototypes addObject:[[DeleteEntryRequest alloc] init]];
	[incomingBeanPrototypes addObject:[[ListCreatedInfo alloc] init]];
	[incomingBeanPrototypes addObject:[[ListEditedInfo alloc] init]];
	[incomingBeanPrototypes addObject:[[ListDeletedInfo alloc] init]];
	[incomingBeanPrototypes addObject:[[EntryCreatedInfo alloc] init]];
	[incomingBeanPrototypes addObject:[[EntryEditedInfo alloc] init]];
	[incomingBeanPrototypes addObject:[[EntryDeletedInfo alloc] init]];
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* jabberIdFromDefaults = [userDefaults stringForKey:UserDefaultJabberId];
	NSString* passwordFromDefaults = [userDefaults stringForKey:UserDefaultPassword];
	NSString* hostnameFromDefaults = [userDefaults stringForKey:UserDefaultHostname];
	NSString* serviceNamespaceFromDefaults = [userDefaults stringForKey:UserDefaultServiceNamespace];
	NSInteger portFromDefaults = [userDefaults integerForKey:UserDefaultPort];
	if (portFromDefaults == 0) {
		portFromDefaults = 5222;
	}
	
	if (jabberIdFromDefaults && passwordFromDefaults && hostnameFromDefaults) {
		authenticated = false;
        connection = [MXiConnection connectionWithJabberID:jabberIdFromDefaults
                                                  password:passwordFromDefaults
                                                  hostName:hostnameFromDefaults
                                                      port:portFromDefaults
                                            coordinatorJID:[NSString stringWithFormat:@"mobilis@%@/Coordinator", hostnameFromDefaults]
                                          serviceNamespace:serviceNamespaceFromDefaults
                                               serviceType:SINGLE
                                          presenceDelegate:self
                                            stanzaDelegate:self
                                              beanDelegate:self
                                 listeningForIncomingBeans:incomingBeanPrototypes];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
