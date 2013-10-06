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
#define DistanceNear    @"80"
#define DistanceMid     @"90"
#define DistanceFar     @"100"

#define AlertTime10     @"10"
#define AlertTime15     @"15"
#define AlertTime20     @"20"
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

#define VibrateOn                   @"1"
#define VibrateOff                  @"0"

#define TagOne                      1
#define TagTwo                      2
#define TagThree                    3
#define TagFour                     4

//数据库对应字段名称
#define DeviceName                  @"name"
#define UUIDStr                     @"uuid"
#define ImageName                   @"image"
#define DistanceValue               @"alertDistance"
#define AlertMusic                  @"alertMusic"
#define AlertTime                   @"alertTime"
#define PhoneMode                   @"phoneMode"
#define DeviceMode                  @"deviceMode"
#define BluetoothMode               @"blueMode"
#define VibrateMode                 @"vibrate"
#define SelectVibrate               @"vibrateMode"
#define SelectMusic                 @"selectMusic"
#define TargetTag                   @"targetTag"

//tag对应的图片
#define TagOneImageH                    @"Main_Icon_Wallet_H"
#define TagOneImageN                    @"Main_Icon_Wallet_N"
#define TagTwoImageH                    @"Main_Icon_Key_H"
#define TagTwoImageN                    @"Main_Icon_Key_N"
#define TagThreeImageH                  @"Main_Icon_Bag_H"
#define TagThreeImageN                  @"Main_Icon_Bag_N"
#define TagFourImageH                   @"Main_Icon_Kid_H"
#define TagFourImageN                   @"Main_Icon_Kid_N"

//tag对应的名字
#define TagOneName                      @"钱包"
#define TagTwoName                      @"钥匙"
#define TagThreeName                    @"手提箱"
#define TagFourName                     @"小孩"

//数据默认值
#define DefaultMusic                    @"Alchemy"
#define DefaultDistanceValue            @"提醒距离选择:远"
#define DefaultAlertTime                @"报警时长:30秒"
#define DefaultAlertMusic               @"选择手机提醒音"
#define DefaultPhoneAlertMode           @"无提醒"
#define DefaultDeviceAlertMode          @"无提醒"
#define DefaultMode                     @"自动关闭手机报警"

#endif
