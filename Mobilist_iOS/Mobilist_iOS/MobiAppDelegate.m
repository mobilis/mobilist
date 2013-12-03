//  MobiAppDelegate.m
//  Mobilist_iOS
//
//  Created by Richard Wotzlaw on 14.04.13.
//  Copyright (c) 2013 TU Dresden. All rights reserved.
//

#import "MobiAppDelegate.h"
#import "DashboardViewController.h"
#import <MXiServiceManager.h>

@interface MobiAppDelegate () <MXiConnectionHandlerDelegate>

@end

@implementation MobiAppDelegate
{
    DashboardViewController *__rootViewController;
}

#pragma mark - MXiConnectionHandlerDelegate

- (void)authenticationFinishedSuccessfully:(BOOL)authenticationState {
	NSLog(@"Authentication finished: %i", authenticationState);
    [[MXiConnectionHandler sharedInstance].serviceManager addDelegate:__rootViewController];
}

- (void)serviceDiscoveryError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)connectionDidDisconnect:(NSError *)error
{
    NSLog(@"%@", error);
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
				
				[[MXiConnectionHandler sharedInstance] sendBean:getListRequest toService:nil];
			}
		}
	}
	
	if ([theBean class] == [GetListResponse class]) {
		GetListResponse* getListResponse = (GetListResponse*) theBean;
		[[MobiListStore sharedStore] addMobiList:[getListResponse list]
									newlyCreated:NO];
	}
	
	if ([theBean class] == [DeleteEntryRequest class]) {
		DeleteEntryRequest* deleteEntryRequest = (DeleteEntryRequest*) theBean;
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[deleteEntryRequest entryId]
															 forKey:@"entryId"];
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationEntryDeletionConfirmed
															object:self
														  userInfo:userInfo];
	}
}

- (BOOL)isSufficientJabberID:(NSString* )jabberID
					password:(NSString* )password
			serviceNamespace:(NSString* )serviceNamespace {
	if (jabberID && ![jabberID isEqualToString:@""] &&
		password && ![password isEqualToString:@""] &&
		serviceNamespace && ![serviceNamespace isEqualToString:@""]) {
        self.areXMPPSettingsSufficient = YES;
			return YES;
	}
	
    self.areXMPPSettingsSufficient = NO;
	return NO;
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MXiConnectionHandler sharedInstance].delegate = self;
    
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* jabberIdFromDefaults = [userDefaults stringForKey:UserDefaultJabberId];
	NSString* passwordFromDefaults = [userDefaults stringForKey:UserDefaultPassword];
	NSString* serviceNamespaceFromDefaults = [userDefaults stringForKey:UserDefaultServiceNamespace];
	
	[self setAreXMPPSettingsSufficient:[self isSufficientJabberID:jabberIdFromDefaults
														 password:passwordFromDefaults
												 serviceNamespace:serviceNamespaceFromDefaults]];
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	__rootViewController = [[DashboardViewController alloc] init];

	UINavigationController* navController = [[UINavigationController alloc]
											 initWithRootViewController:__rootViewController];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* jabberIdFromDefaults = [userDefaults stringForKey:UserDefaultJabberId];
	NSString* passwordFromDefaults = [userDefaults stringForKey:UserDefaultPassword];
	NSString* hostnameFromDefaults = [userDefaults stringForKey:UserDefaultHostname];
	NSInteger portFromDefaults = [userDefaults integerForKey:UserDefaultPort];
	if (portFromDefaults == 0) {
		portFromDefaults = 5222;
	}
	
	if (jabberIdFromDefaults && passwordFromDefaults && hostnameFromDefaults) {
        [[MXiConnectionHandler sharedInstance] launchConnectionWithJID:jabberIdFromDefaults
                                                              password:passwordFromDefaults
                                                              hostName:hostnameFromDefaults
                                                           serviceType:SINGLE
                                                                  port:[NSNumber numberWithInteger:portFromDefaults]];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
