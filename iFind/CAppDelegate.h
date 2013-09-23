//
//  CAppDelegate.h
//  iFind
//
//  Created by Carl on 13-9-18.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "Constants.h"
#import "CScanViewController.h"
@interface CAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CTCallCenter * callCenter;
@property (assign, nonatomic) UIBackgroundTaskIdentifier bgTask;
@property (strong, nonatomic) NSTimer * bgTimer;
@property (strong, nonatomic) NSTimer * foregroudTimer;
@end
