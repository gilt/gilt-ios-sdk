//
//  GAppDelegate.m
//  KitchenSink
//
//  Created by Adam Kaplan on 1/26/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

#import "GAppDelegate.h"

@implementation GAppDelegate

@synthesize window = _window, downloadQueue, productCache;

void uncaughtExceptionHandler(NSException *exception);

#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    downloadQueue = [NSOperationQueue new];
    downloadQueue.maxConcurrentOperationCount = 5;
    
    productCache = [[NSMutableDictionary alloc] initWithCapacity:1024];
    
    // Customize appearances
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.2 alpha:1.0] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    UIImage *pixel = UIGraphicsGetImageFromCurrentImageContext();
    pixel = [pixel resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIGraphicsEndImageContext();
    
    UINavigationBar *defaultNavBar = [UINavigationBar appearance];
    [defaultNavBar setBackgroundImage:pixel forBarMetrics:UIBarMetricsDefault];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - Memory Management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    // Nuke caches
    [productCache removeAllObjects];
}

#pragma mark - Exception Handling

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"Exception: %@", exception);
    NSLog(@"Stack Trace:\n%@", [exception callStackSymbols]);
}

@end
