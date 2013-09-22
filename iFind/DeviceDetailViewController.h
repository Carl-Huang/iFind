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


@interface DeviceDetailViewController : UIViewController
{
    PopUpTableViewController *popUpTableviewController;
    FPPopoverController *popover;
}

//界面按钮
@property (retain ,nonatomic)UIButton * chooseAlertDistance;
@property (retain ,nonatomic)UIButton * chooseAlertMusic;
@property (retain ,nonatomic)UIButton * chooseAlertTime;
@property (retain ,nonatomic)UIButton * choosePhoneAlertMode;
@property (retain ,nonatomic)UIButton * chooseDeviceAlertMode;
@property (retain ,nonatomic)UIButton * chooseMode;
@property (retain ,nonatomic)UIImageView * userPhoto;
@property (retain ,nonatomic)UIImageView * signalPic;
@property (retain ,nonatomic)UIImageView * devPowerPic;


//数据源类别
@property (assign ,nonatomic)PopUpTableViewDataSourceType dataSourceType;

//拍照
@property (retain ,nonatomic)PhotoManager *photoManager;


//初始化
-(void)initializationDefaultValue:(NSDictionary *)dic;
@end
