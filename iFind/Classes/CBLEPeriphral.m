//
//  CBLEPeriphral.m
//  iFind
//
//  Created by Carl on 13-9-19.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import "CBLEPeriphral.h"
#import "CUtilsFunc.h"
#import "Constants.h"

typedef enum{
    ALERT_LEVEL_NONE = 0,
    ALERT_LEVEL_MID = 1,
    ALERT_LEVEL_HIGH = 2,
    ALERT_LEVEL_LIGHT = 5
}_ALERT_LEVEL_;


typedef enum {
    CMD_STOP = 4,
    CMD_CONTROL = 6
}_CMD_;

@implementation CBLEPeriphral

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _peripheral.delegate = nil;
    [_peripheral release];
    _peripheral = nil;
    _characteristicForAlert = nil;
    _characteristicForAlertLevel = nil;
    _characteristicForBattery = nil;
    [super dealloc];
}

-(id)initWithPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
   if((self = [super init]))
   {
       self.peripheral = peripheral;
       
       self.peripheral.delegate = self;
       //取得蓝牙的信号
       self.rssi = [peripheral.RSSI intValue];
       //取得蓝牙的uuid
       if(peripheral.UUID != NULL)
           self.UUID = [CUtilsFunc convertCFUUIDIntoString:peripheral.UUID];
       
       [self discoverServices];
       
       [[NSNotificationCenter defaultCenter] addObserverForName:kCallIncomingNotification object:self queue:[[NSOperationQueue alloc] init] usingBlock:^(NSNotification *note) {
    
           [self writeAlertLevelLight];
       }];
       
   }
    return self;
}


-(void)discoverServices
{
    NSArray * services = @[[CBUUID UUIDWithString:Service_Immediate_Alert],[CBUUID UUIDWithString:Service_Link_Loss],[CBUUID UUIDWithString:Service_Battery]];
    [_peripheral discoverServices:services];
}

-(void)discoverCharacteristic
{

    [_peripheral discoverCharacteristics:nil forService:nil];
}



-(void)readRSSI:(NSTimer *)timer
{
    
    if(![_peripheral isConnected])
    {
//        [timer invalidate];
//        timer = nil;
        return;
    }
    NSLog(@"Peripheral read rssi.");
    [_peripheral readRSSI];
    
}



#pragma mark - CBPeripheralDelegate Methods

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if(error)
    {
        NSLog(@"Discover services error : %@",[error description]);
        return ;
    }
    NSLog(@"Discover services %d",[peripheral.services count]);
    for(CBService * service in peripheral.services)
    {
        if([service.UUID isEqual:[CBUUID UUIDWithString:Service_Immediate_Alert ]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:Characteristic_Alert_Level]] forService:service];
        }
        else if([service.UUID isEqual:[CBUUID UUIDWithString:Service_Battery]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:Characteristic_Battery_Level]] forService:service];
        }
        else if([service.UUID isEqual:[CBUUID UUIDWithString:Service_Link_Loss]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:Characteristic_Alert_Level]] forService:service];
        }
    }
    
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if(error)
    {
        NSLog(@"Discover characteristics error : %@",[error description]);
        return ;
    }
    NSLog(@"Discover characteristics %d",[service.characteristics count]);
    for(CBCharacteristic * characteristic in service.characteristics)
    {
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:Characteristic_Alert_Level]])
        {
            [peripheral readValueForCharacteristic:characteristic];

            if([service.UUID isEqual:[CBUUID UUIDWithString:Service_Immediate_Alert]])
            {
                _characteristicForAlert = characteristic;
                [self writeAlertLevelHigh];

            }
            else if ([service.UUID isEqual:[CBUUID UUIDWithString:Service_Link_Loss]])
            {
                _characteristicForAlertLevel = characteristic;
            }
            
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:Characteristic_Battery_Level]])
        {
            _characteristicForBattery = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
        }

    }

}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error)
    {
        NSLog(@"Peripheral write value %@ with error :%@",characteristic.value,[error description]);
        return ;
    }
    NSLog(@"Did write value %@, characteristic uuid %@",characteristic.value,characteristic.UUID);
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
//    if(error)
//    {
//        NSLog(@"Peripheral read value %@ with error : %@",characteristic.value,[error description]);
//        return ;
//    }
    NSLog(@"Did update value %@, in characteristic uuid %@, service uuid:%@",characteristic.value,characteristic.UUID,characteristic.service.UUID);
    
    
    
//    if(characteristic.value == nil)
//    {
//        return ;
//    }
    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:Characteristic_Battery_Level]])
    {

        NSString * batteryLevel = [CUtilsFunc HexStringFromBinaryValue:characteristic.value];
        int level = [CUtilsFunc HexConvertIntoInt:batteryLevel];
        self.batteryLevel = level;
        NSLog(@"Batter Level %d",level);
    }
    else
    {
        if(self.remoteControlHandler)
        {
            self.remoteControlHandler(self.peripheral);
        }
    }
    
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"Update rssi with error:%@",error);
        return ;
    }
    NSLog(@"New RSSI:%d",peripheral.RSSI.intValue);
    
    self.rssi = peripheral.RSSI.intValue;
    if(self.updateRSSIHandler)
    {
        self.updateRSSIHandler(self.rssi);
    }
    //在这里处理蓝牙的距离
    if(peripheral.RSSI.intValue < -90)
    {
        
        [self performSelector:@selector(writeAlertLevelHigh) withObject:nil afterDelay:2.5];
    }
    else
    {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(writeAlertLevelHigh) object:nil];
    }
    
}



-(void)writeAlertLevelNone
{
    [self writeAlertLevel:ALERT_LEVEL_NONE];
}

-(void)writeAlertLevelMid
{
    [self writeAlertLevel:ALERT_LEVEL_MID];
}

-(void)writeAlertLevelHigh
{
    [self writeAlertLevel:ALERT_LEVEL_HIGH];
}

-(void)writeAlertLevelLight
{
    [self writeAlertLevel:ALERT_LEVEL_LIGHT];
}

-(void)writeAlertLevel:(int)level
{
    if(![_peripheral isConnected]) return ;
    NSData * data;
    switch (level) {
        case ALERT_LEVEL_NONE:
            data = [CUtilsFunc BinaryValueFromHexString:@"00"];
            break;
        case ALERT_LEVEL_MID:
            data = [CUtilsFunc BinaryValueFromHexString:@"01"];
            break;
        case ALERT_LEVEL_HIGH:
            data = [CUtilsFunc BinaryValueFromHexString:@"02"];
            break;
        case ALERT_LEVEL_LIGHT:
            data = [CUtilsFunc BinaryValueFromHexString:@"05"];
            break;
        default:
            data = nil;
            break;
    }
    if(!data)
    {
        NSLog(@"The alert level data is nil.");
        return ;
    }
    
    [_peripheral writeValue:data forCharacteristic:_characteristicForAlert type:CBCharacteristicWriteWithResponse];
}

@end
