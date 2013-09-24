//
//  CDataSource.h
//  PhotoApp
//
//  Created by Carl on 13-9-17.
//  Copyright (c) 2013年 BlueApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBTableAlert.h"
#import <CoreBluetooth/CoreBluetooth.h>
typedef void (^SelectDirectoryHandler)(CBPeripheral * peripheral);
typedef void (^DismissHandler)(void);

@interface CDataSource : NSObject <SBTableAlertDataSource,SBTableAlertDelegate>
@property (nonatomic,retain) NSArray * dataSource;
@property (nonatomic,copy) SelectDirectoryHandler selectDirectoryHandler;
@property (nonatomic,copy) DismissHandler dismissHandler;
+(id)dataSource;
- (id)initWithDataSource:(NSArray *)dataArray;

@end
