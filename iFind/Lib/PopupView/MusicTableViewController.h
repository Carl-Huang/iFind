//
//  MusicTableViewController.h
//  iFind
//
//  Created by vedon on 26/9/13.
//  Copyright (c) 2013 iFind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceDetailViewController.h"
@interface MusicTableViewController : UITableViewController
@property (retain ,nonatomic) NSArray * dataSource;
@property (retain ,nonatomic) NSMutableDictionary * musicDic;
@property (copy ,nonatomic) DidSelectMusicConfigureBlock configyreMusicBlock;
@end
