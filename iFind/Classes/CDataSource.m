//
//  CDataSource.m
//  PhotoApp
//
//  Created by Carl on 13-9-17.
//  Copyright (c) 2013年 BlueApp. All rights reserved.
//

#import "CDataSource.h"

@implementation CDataSource


-(void)dealloc
{
    [super dealloc];
    [_dataSource release];
    _dataSource = nil;
}


+(id)dataSource
{
    
    CDataSource * dataSource = [[self alloc] init];
    
    return [dataSource autorelease];
}


- (id)initWithDataSource:(NSArray *)dataArray
{
    if((self = [super init]))
    {
        self.dataSource = dataArray;
    }
    return self;
}

- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}
- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableAlert.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
    }
    CBPeripheral * blePeripheral = [_dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:blePeripheral.name];
    return cell;
    
}



- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
    
    CBPeripheral * blePeripheral = [_dataSource objectAtIndex:indexPath.row];
    
    if(self.selectDirectoryHandler)
        self.selectDirectoryHandler(blePeripheral);
    
    
}


- (void)tableAlert:(SBTableAlert *)tableAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    if(self.dismissHandler)
        self.dismissHandler();
}

- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [tableAlert release];
}


@end
