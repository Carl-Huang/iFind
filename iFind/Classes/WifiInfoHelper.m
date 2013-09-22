//
//  WifiInfoHelper.m
//  DisableOtherAudioPlaying
//
//  Created by vedon on 18/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//
#define WifiBSSID       @"BSSID"
#define WifiSSID        @"SSID"
#import "WifiInfoHelper.h"
#import <SystemConfiguration/CaptiveNetwork.h>


@implementation WifiInfoHelper
+ (id)fetchSSIDInfo
{
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    NSDictionary * info = nil;
    for (NSString *ifnam in ifs) {
        info = (NSDictionary *)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
        [info release];
    }
    [ifs release];
    if ([info count]) {
        NSMutableDictionary * wifiInfoDic = [[[NSMutableDictionary alloc]init]autorelease];
        [wifiInfoDic setObject:[info objectForKey:@"BSSID"] forKey:WifiBSSID];
        [wifiInfoDic setObject:[info objectForKey:@"SSID"] forKey:WifiSSID];
        [info release];
        return wifiInfoDic;

    }else
    {
        return [NSArray array];
    }
}
@end
