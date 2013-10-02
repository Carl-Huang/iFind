//
//  CBLEManager.m
//  iFind
//
//  Created by Carl on 13-9-19.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import "CBLEManager.h"
#import "CUtilsFunc.h"
#import "Constants.h"
@implementation CBLEManager

#pragma mark - Class Methods
+(id)sharedManager
{
    static CBLEManager *bleManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bleManager = [[self alloc] init];
    });
    return bleManager;
}

#pragma  mark - Instance Methods
-(id)init
{
    if((self = [super init]))
    {
        _connectedPeripherals = [[NSMutableArray alloc] init];
        _foundPeripherals = [[NSMutableArray alloc] init];
        _bleCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    
    return self;
}


-(void)dealloc
{
    [super dealloc];
    _bleCentralManager.delegate = nil;
    [_bleCentralManager release];
    _bleCentralManager = nil;
    [_connectedPeripherals release];
    _connectedPeripherals = nil;
    [_foundPeripherals release];
    _foundPeripherals = nil;
    
}


- (void)startScan
{
    [self startScan:@[Service_Immediate_Alert]];
}


- (void)startScan:(NSArray *)services
{
    NSMutableArray * servicesUUIDs = nil;
    if(services != nil || [services count] != 0)
    {
        for(NSString * uuid in services)
        {
            [servicesUUIDs addObject:[CBUUID UUIDWithString:uuid]];
        }
    }
    [_bleCentralManager scanForPeripheralsWithServices:servicesUUIDs options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey]];
}

- (void)stopScan
{
    [_bleCentralManager stopScan];
}


- (void)connectToPeripheral:(CBPeripheral *)peripheral
{
    NSAssert(peripheral != nil, @"The CBPeripheral is nil.%@",NSStringFromSelector(_cmd));
    if([peripheral isConnected])
    {
        //[self disconnectFromPeripheral:peripheral];
        NSLog(@"The peripheral is already connected.");
        return ;
        
    }
    [_bleCentralManager connectPeripheral:peripheral options:nil];
}


- (void)disconnectFromPeripheral:(CBPeripheral *)peripheral
{
    NSAssert(peripheral != nil, @"The CBPeripheral is nil.%@",NSStringFromSelector(_cmd));
    [_bleCentralManager cancelPeripheralConnection:peripheral];
}

- (void)clear
{

    [_connectedPeripherals removeAllObjects];
    [_foundPeripherals removeAllObjects];
    
}


- (void)addFoundPeripheral:(CBPeripheral *)peripheral
{
    if(peripheral.name == nil)
    {
        NSLog(@"Peripheral name is nil");
        return;
    }
    if(![_foundPeripherals containsObject:peripheral])
    {
        NSLog(@"Add peripheral");
        [_foundPeripherals addObject:peripheral];
        if(self.discoverHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.discoverHandler();
            });
        }
    }


}
- (void)removeFoundPeripheral:(CBPeripheral *)peripheral
{
    
    if([_foundPeripherals containsObject:peripheral])
    {
        [_foundPeripherals removeObject:peripheral];
        if(self.discoverHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.discoverHandler();
            });
        }
    }
}

- (void)addConnectedPeripheral:(CBPeripheral *)peripheral
{
    if(![self isContainPeripheral:peripheral])
    {
        CBLEPeriphral * instance = [[[CBLEPeriphral alloc] initWithPeripheral:peripheral] autorelease];
        [_connectedPeripherals addObject:instance];
        if(self.connectedHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.connectedHandler(peripheral);
            });
        }
    }
}

- (void)removeConnectedPeripheral:(CBPeripheral *)peripheral
{
    CBLEPeriphral * instance;
    for(CBLEPeriphral * blePeripheral in _connectedPeripherals)
    {
        if(peripheral.UUID == blePeripheral.peripheral.UUID)
        {
            instance = blePeripheral;
            break;
        }
    }
    if(instance)
    {
        
        if(self.disconnectHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.disconnectHandler(peripheral);
            });
        }
        [_connectedPeripherals removeObject:instance];
    }
}

- (BOOL)isContainPeripheral:(CBPeripheral *)peripheral
{
    BOOL isContained = NO;
    for(CBLEPeriphral * blePeripheral in _connectedPeripherals)
    {
        if(peripheral.UUID == blePeripheral.peripheral.UUID)
        {
            isContained = YES;
            break;
        }

    }
    return isContained;
}

#pragma mark - CBCentralManagerDelegate Methods
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [self startScan];
            NSLog(@"The Bluetooth powered on.");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"The Bluetooth powered off.");
            [self stopScan];
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"The Bluetooth state resetting.");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"The Bluetooth state unauthorized.");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"The Bluetooth state unknown.");
            break;
        default:
            break;
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{

    NSLog(@"Discover peripheral,name:%@,RSSI:%d",peripheral.name,[RSSI intValue]);

    if([RSSI intValue] < -100)
    {
        NSLog(@"The rssi is weak.");
        return ;
    }
    
    if([RSSI intValue] > -15)
    {
        NSLog(@"The rssi is impossible.");
        return ;
    }
    
    [self addFoundPeripheral:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"CBCentralManager did connect peripheral %@",peripheral.name);
    [self addConnectedPeripheral:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"CBCentralMananger did fail to connect peripheral:%@",error);
    [self removeFoundPeripheral:peripheral];
    
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Disconnect peripheral:%@,rssi:%d,with error:%@",peripheral.name,peripheral.RSSI.intValue,error);
    if(error)
    {
        //some error
        //有可能是设备离远了
//        [central retrievePeripherals:@[(id)peripheral.UUID]];
    }
    [self removeConnectedPeripheral:peripheral];
    //在这里出来蓝牙断开连接

}

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"Did retrieve peripherals %d",[peripherals count]);
    
    
    CBPeripheral * peripheral;
    for(peripheral in peripherals)
    {
        [self connectToPeripheral:peripheral];
    }
    
}







@end
