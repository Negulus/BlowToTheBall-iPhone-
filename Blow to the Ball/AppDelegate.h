//
//  AppDelegate.h
//  Blow to the Ball
//
//  Created by Администратор on 3/16/13.
//  Copyright (c) 2013 Negulus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAccelerometerDelegate>
{
    float accel_x;
    float accel_y;
    float accel_z;
}

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic, readwrite) float accel_x;
@property (assign, nonatomic, readwrite) float accel_y;
@property (assign, nonatomic, readwrite) float accel_z;

@end
