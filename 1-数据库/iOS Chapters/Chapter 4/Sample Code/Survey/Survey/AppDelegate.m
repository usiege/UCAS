//
//  AppDelegate.m
//  Survey
//
//  Created by Patrick Alessi on 9/25/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)navigationController.topViewController;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    NSData *serializedData;
    NSString *error;
    
    // Get a reference to the first navigation controller in the split view
    UISplitViewController *splitViewController =
    (UISplitViewController *)self.window.rootViewController;
    UINavigationController* nav = [splitViewController.viewControllers
                                   objectAtIndex:0];
    
    // Use this to get a reference to the MasterViewController
    MasterViewController* rvc = (MasterViewController*) nav.topViewController ;
    
    serializedData = [NSPropertyListSerialization
                      dataFromPropertyList:rvc.surveyDataArray
                      format:NSPropertyListXMLFormat_v1_0
                      errorDescription:&error];
    
    if (serializedData)
    {
        // Serialization was successful, write the data to the file system
        // Get an array of paths.
        // (This function is carried over from the desktop)
        NSArray *documentDirectoryPath =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                            NSUserDomainMask, YES);
        NSString *docDir = [NSString stringWithFormat:@"%@/serialized.xml",
                            [documentDirectoryPath objectAtIndex:0]];
        
        [serializedData writeToFile:docDir atomically:YES];
    }
    else
    {
        // An error has occurred, log it
        NSLog(@"Error: %@",error);
    }
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
    // Called when the application is about to terminate.
    // Save data if appropriate. See also applicationDidEnterBackground:.

}

@end
