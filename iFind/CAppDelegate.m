//
//  CAppDelegate.m
//  iFind
//
//  Created by Carl on 13-9-18.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import "CAppDelegate.h"
#import "CRootViewController.h"
#import "CBLEPeriphral.h"
#import "CBLEManager.h"
#import "DeviceDetailViewController.h"
#import "SQLManager.h"
//#define TestDeviceDetailViewcontroller
//#define TestCRootViewController
@implementation CAppDelegate

- (void)dealloc
{
    [_window release];
    _callCenter.callEventHandler = nil;
    [_callCenter release];
    
    _bgTimer = nil;
    [_foregroudTimer release];
    _foregroudTimer = nil;
    
    [_bleManager release];
    _bleManager = nil;
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //初始化数据库
    SQLManager * sqlManager = [[SQLManager alloc] initDataBase];
    [sqlManager createTable];
    [sqlManager release];
    
    //自定义UI
    [self customUI];
    //实例化蓝牙管理类
    _bleManager = [CBLEManager sharedManager];
    
    //监听来电
    _callCenter = [[CTCallCenter alloc] init];
    _callCenter.callEventHandler = ^(CTCall * call){
        if([call.callState isEqualToString:CTCallStateIncoming])
        {
            NSLog(@"Call incoming");
            [[NSNotificationCenter defaultCenter] postNotificationName:kCallIncomingNotification object:self];
        }
        
    };
    
    //定时读取蓝牙的信号值
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        _foregroudTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(readRSSI:) userInfo:nil repeats:YES];
//        [_foregroudTimer fire];
//        [[NSRunLoop currentRunLoop] addTimer:_foregroudTimer forMode:NSRunLoopCommonModes];
//        [[NSRunLoop currentRunLoop] run];
//    });
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

//#ifdef TestDeviceDetailViewcontroller
//    DeviceDetailViewController * viewcontroller = [[[DeviceDetailViewController alloc]init]autorelease];
//    [viewcontroller initializationDefaultValue:nil];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewcontroller];
//
//    self.window.rootViewController = nav;
//#endif
    
//#ifdef TestCRootViewController
//
//    CRootViewController * rootViewController = [[CRootViewController alloc] initWithNibName:nil bundle:nil];
//    UINavigationController *cnav = [[UINavigationController alloc]initWithRootViewController:rootViewController];    
//    self.window.rootViewController = cnav;
//    [rootViewController release];
//#endif
    
    CScanViewController * scanViewController = [[CScanViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:scanViewController];
    [scanViewController release];
    [self.window setRootViewController:navController];
    [navController release];
    
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
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if(_foregroudTimer)
    {
        [_foregroudTimer setFireDate:[NSDate distantFuture]];
        
    }
    
    UIApplication * app = [UIApplication sharedApplication];
    _bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [app endBackgroundTask:_bgTask];
            _bgTask = UIBackgroundTaskInvalid;
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if([app backgroundTimeRemaining] > 1.0)
        {
            _bgTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(readRSSI:) userInfo:nil repeats:YES];
            [_bgTimer fire];
            [[NSRunLoop currentRunLoop] addTimer:_bgTimer forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] run];
            
            [app endBackgroundTask:_bgTask];
            _bgTask = UIBackgroundTaskInvalid;
        }
    });
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    _bgTask = UIBackgroundTaskInvalid;
    if(_bgTimer)
    {
        if([_bgTimer isValid]) [_bgTimer invalidate];
    }
    
    
    if(_foregroudTimer)
    {
        [_foregroudTimer setFireDate:[NSDate date]];
        [_foregroudTimer fire];
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[CBLEManager sharedManager] clear];
}


-(void)readRSSI:(NSTimer *)timer
{
    [[[CBLEManager sharedManager] connectedPeripherals] makeObjectsPerformSelector:@selector(readRSSI:) withObject:timer];
}

- (void)customUI
{
    //全屏显示，取消状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //设置导航栏的背景颜色
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Main_TopBar"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary * textAttribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18],UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor,[UIColor grayColor],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(-1, -1)],UITextAttributeTextShadowOffset,nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textAttribute];

}

@end
