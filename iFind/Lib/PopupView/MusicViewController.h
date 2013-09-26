//
//  MusicViewController.h
//  iFind
//
//  Created by vedon on 26/9/13.
//  Copyright (c) 2013 iFind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceDetailViewController.h"
@interface MusicViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain ,nonatomic) NSArray * dataSource;
@property (retain ,nonatomic) NSMutableDictionary * musicDic;
@property (copy ,nonatomic) DidSelectMusicConfigureBlock configyreMusicBlock;
@property (retain ,nonatomic)NSString * vUUID;
@property (retain ,nonatomic)UITableView *musicTableview;

-(id)initWithUUID:(NSString *)uuid;
@end
