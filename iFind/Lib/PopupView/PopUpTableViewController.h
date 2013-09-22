//
//  PopUpTableViewController.h
//  IWifi
//
//  Created by vedon on 21/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceDetailViewController.h"
@interface PopUpTableViewController : UITableViewController

@property (retain ,nonatomic) NSArray * dataSource;
@property (assign ,nonatomic) PopUpTableViewDataSourceType type;
//Block
@property (copy ,nonatomic) DidSelectTableviewRowCongigureBlock configureBlock;
-(void)setTableViewOriginalType;

@end
