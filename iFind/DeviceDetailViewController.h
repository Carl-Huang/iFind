//
//  DeviceDetailViewController.h
//  DisableOtherAudioPlaying
//
//  Created by vedon on 20/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//


typedef NS_ENUM(NSInteger, PopUpTableViewDataSourceType)
{
    PopUpTableViewDataSourceDistance=1,
    PopUpTableViewDataSourceMusic,
    PopUpTableViewDataSourceTime,
    PopUpTableViewDataSourcePhoneAlertMode,
    PopUpTableViewDataSourceDeviceAlertMode,
    PopUpTableViewDataSourceMode,
    
};

typedef void (^DidSelectTableviewRowCongigureBlock) (id item);
#import <UIKit/UIKit.h>
@class PopUpTableViewController;
@class FPPopoverController;
@class PhotoManager;
@class SQLManager;

@interface DeviceDetailViewController : UIViewController
{
    PopUpTableViewController *popUpTableviewController;
    FPPopoverController *popover;
}

//数据库操作
@property (retain ,nonatomic)SQLManager *sqlMng;

//界面按钮
@property (retain ,nonatomic)UIButton * chooseAlertDistance;
@property (retain ,nonatomic)UIButton * chooseAlertMusic;
@property (retain ,nonatomic)UIButton * chooseAlertTime;
@property (retain ,nonatomic)UIButton * choosePhoneAlertMode;
@property (retain ,nonatomic)UIButton * chooseDeviceAlertMode;
@property (retain ,nonatomic)UIButton * chooseMode;
@property (retain ,nonatomic)UIImageView * userPhoto;
@property (retain ,nonatomic)UIImageView * signalPic;


//信号图标
@property (retain ,nonatomic)UIImageView *scopeImage;
@property (retain ,nonatomic)UIImageView *wifiImage;
@property (retain ,nonatomic)UIImageView * devPowerPic;

//信号值label
@property (retain ,nonatomic)UILabel *scopeLabel;
@property (retain ,nonatomic)UILabel *wifiLabel;
@property (retain ,nonatomic)UILabel *devPowerLabel;


//数据源类别
@property (assign ,nonatomic)PopUpTableViewDataSourceType dataSourceType;

//拍照
@property (retain ,nonatomic)PhotoManager *photoManager;

//初始化
-(void)initializationDefaultValue:(NSDictionary *)dic;

//更新范围值，信号量值，电量值
-(void)updateScopeValue:(NSString *)scopeV signalValue:(NSString *)signalV powerVaule:(NSString *)powerV;
@end
