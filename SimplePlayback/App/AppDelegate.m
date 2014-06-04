//
//  AppDelegate.m
//  Vitamio-Demo
//
//  Created by erlz nuo(nuoerlz@gmail.com) on 7/8/13.
//  Copyright (c) 2013 yixia. All rights reserved.
//

#import "AppDelegate.h"

#import "AuthStorage.h"
#import "List.h"

#import "CustomNavController.h"
//#import "VDLViewController.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize navController = _navController;
@synthesize viewController = _viewController;
@synthesize authStorage = _authStorage;


//[obgect application:param1 di...:param2];

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
	
    
    self.authStorage = [[AuthStorage alloc] init];
    self.viewController = [[[List alloc] initWithNibName:@"List" bundle:nil] autorelease];
  //
    
    self.viewController.authDelegate = self.authStorage;
    
    
    self.navController = [[CustomNavController alloc] init];
    self.navController.navigationBar.translucent = FALSE;
   
   //[self.window addSubview:self.navController.view];
    self.window.rootViewController = self.navController;
   
    ((UIViewController*)self.viewController).title=@"Каналы";
    
    [self.navController pushViewController:self.viewController animated:FALSE];
    
	//self.window.rootViewController = self.viewController;
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
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    NSLog(@"app orientation");
    return UIInterfaceOrientationMaskAll;
}*/

@end
