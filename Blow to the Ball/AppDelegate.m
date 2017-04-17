//
//  AppDelegate.m
//  Blow to the Ball
//
//  Created by Администратор on 3/16/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

// CONSTANTS
#define kAccelerometerFrequency		100.0 // Hz
#define kFilteringFactor			0.1

@implementation AppDelegate

@synthesize accel_x;
@synthesize accel_y;
@synthesize accel_z;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Configure and start accelerometer
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	//Use a basic low-pass filter to only keep the gravity in the accelerometer values
	accel_x = acceleration.x * kFilteringFactor + accel_x * (1.0 - kFilteringFactor);
	accel_y = acceleration.y * kFilteringFactor + accel_y * (1.0 - kFilteringFactor);
	accel_z = acceleration.z * kFilteringFactor + accel_z * (1.0 - kFilteringFactor);
}

@end
