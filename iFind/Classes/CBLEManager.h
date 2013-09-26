//
//  CBLEManager.h
//  iFind
//  BLE 管理类
//  Created by Carl on 13-9-19.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CBLEPeriphral.h"
typedef void (^DiscoverNewPeripheralHandler)(void);
typedef void (^ConnectedPeripheralHandler)(CBPeripheral * peripheral);
typedef void (^DisconnectPeripheralHandler)(CBPeripheral * peripheral);
@interface CBLEManager : NSObject <CBCentralManagerDelegate>
@property (nonatomic,readonly) CBCentralManager * bleCentralManager;
@property (nonatomic,retain) NSMutableArray * connectedPeripherals;
@property (nonatomic,retain) NSMutableArray * foundPeripherals;
@property (nonatomic,copy) DiscoverNewPeripheralHandler discoverHandler;
@property (nonatomic,copy) ConnectedPeripheralHandler connectedHandler;
@property (nonatomic,copy) DisconnectPeripheralHandler disconnectHandler;
+(id)sharedManager;
-(void)startScan;
-(void)startScan:(NSArray *)services;
-(void)stopScan;
-(void)connectToPeripheral:(CBPeripheral *)peripheral;
-(void)disconnectFromPeripheral:(CBPeripheral *)peripheral;
-(void)clear;






@end
