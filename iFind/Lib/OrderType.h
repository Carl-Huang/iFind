//
//  OrderType.h
//  iFind
//
//  Created by vedon on 24/9/13.
//  Copyright (c) 2013 iFind. All rights reserved.
//

#ifndef iFind_OrderType_h
#define iFind_OrderType_h

//定义button tag宏
#define DistanceTag     1001
#define AlertTimeTag    1002
#define AlertMusicTag   1003
#define PhoneModeTag    1004
#define DeviceModeTag   1005
#define ModeTag         1006

//定义命令宏
#define DistanceNear    80
#define DistanceMid     90
#define DistanceFar     100

#define AlertTime10     10
#define AlertTime20     20
#define AlertTime30     30
#define PhoneModeStopAlert          @"p1"
#define PhoneModeVibrate            @"p2"
#define PhoneModeVibrateAndSound    @"p3"

#define DeviceModeStopAlert         @"d1"
#define DeviceModeLight             @"d2"
#define DeviceModeSound             @"d3"
#define DeviceModeLightSound        @"d4"

#define ModeMutualAlertStop         @"b1"
#define ModeDeviceAlertStop         @"b2"
#define ModePhoneAlertStop          @"b3"

#define DeviceName                  @"DeviceName"
#define UUIDStr                     @"UUID"
#define ImageName                   @"ImageName"
#define DistanceValue               @"DistanceValue"
#define AlertMusic                  @"AlertMusic"
#define AlertTime                   @"AlertTime"
#define PhoneMode                   @"PhoneMode"
#define DeviceMode                  @"DeviceMode"
#define BluetoothMode               @"BluetoothMode"

#endif
