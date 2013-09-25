//
//  DeviceDetailViewController.m
//  DisableOtherAudioPlaying
//
//  Created by vedon on 20/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//
#define FontSize 15

#define DistancePre        g     @"提醒距离选择:"
#define AlertTimePre            @"报警时长:"
#define AlertMusicePre          @"选择手机提醒音:"


#define DefaultDistanceValue    @"提醒距离选择:远"
#define DefaultAlertTime        @"报警时长:30秒"
#define DefaultAlertMusic       @"选择手机提醒音:Alchemy"
#define DefaultPhoneAlertMode   @"手机震动声光提醒"
#define DefaultDeviceAlertMode  @"声光提醒"
#define DefaultMode             @"自动关闭手机报警"

#import "DeviceDetailViewController.h"
#import "FPPopoverController.h"
#import "PopUpTableViewController.h"
#import "OrderType.h"
#import "SQLManager.h"
#import "CustomiseActionSheet.h"
//Utility class
#import "PhotoManager.h"
@interface DeviceDetailViewController ()
{
    NSString *defaultDistanceValue;
    NSString *defaultAlertMusic;
    NSString *defaultAlertTime;
    NSString *defaultPhoneAlertMode;
    NSString *defaultDeviceAlertMOde;
    NSString *defaultMode;
    NSString *defaultImage;
    NSString *defaultName;
}
@end

@implementation DeviceDetailViewController

@synthesize chooseAlertDistance,chooseAlertMusic,chooseAlertTime,chooseDeviceAlertMode,chooseMode,choosePhoneAlertMode,userPhoto,signalPic,photoBackground;
@synthesize photoManager;
@synthesize scopeImage,wifiImage,devPowerPic;
@synthesize scopeLabel,wifiLabel,devPowerLabel;
@synthesize vUUID;
@synthesize sqlMng;
@synthesize imageDiskPath;
-(void)loadView
{
    [super loadView];
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, 320, 460)];
    [backgroundImage setContentMode:UIViewContentModeScaleAspectFit];
    [backgroundImage setImage:[UIImage imageNamed:@"Settings_Bg"]];
    [self.view addSubview:backgroundImage];
    [backgroundImage release];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Main_TopBar"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setTitle:@"设置"];
    UIBarButtonItem * backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backTo)];
    self.navigationController.navigationItem.leftBarButtonItem = backBtn;
    [backBtn release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backToMainview)];
}
- (void)viewDidLoad
{
  
    [super viewDidLoad];
    [self initDirectory];
    
       
    //相片处理类
    ConfigureImageBlock block = ^(id item,id name){
        [userPhoto setFrame:CGRectMake(30, 35, 100, 100)];
        [userPhoto setImage:(UIImage *)item];
        //图片名写入数据库
        [sqlMng updateKey:ImageName value:name withUUID:self.vUUID];
    };
    [self initializationInterface];
    photoManager = [[PhotoManager alloc]initWithBlock:block];

}

-(void)backToMainview
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Interface Setting
-(void)initializationDefaultValue:(NSDictionary *)dic
{
    if (dic==nil) {
        defaultAlertMusic       = DefaultAlertMusic;
        defaultDistanceValue    = DefaultDistanceValue;
        defaultAlertTime        = DefaultAlertTime;
        defaultPhoneAlertMode   = DefaultPhoneAlertMode;
        defaultDeviceAlertMOde  = DefaultDeviceAlertMode;
        defaultMode             = DefaultMode;
    }else
    {
        defaultAlertMusic       = [dic objectForKey:AlertMusic];
        defaultDistanceValue    = [dic objectForKey:DistanceValue];
        defaultAlertTime        = [dic objectForKey:AlertTime];
        defaultPhoneAlertMode   = [dic objectForKey:PhoneMode];
        defaultDeviceAlertMOde  = [dic objectForKey:DeviceMode];
        defaultMode             = [dic objectForKey:BluetoothMode];
    }
    //数据库处理类
    sqlMng  = [[SQLManager alloc]initDataBase];
    [sqlMng createTable];
    self.vUUID = @"carl";
    [sqlMng insertValueToExistedTableWithArguments:@[@"carl",@"carl",@"carl",@"carl",[NSNumber numberWithInt:24],[NSNumber numberWithInt:24],@"男",@"男",@"男"]];
}

-(void)initializationDeviceWithUUID:(NSString *)uuid
{
    //数据库处理类
    sqlMng  = [[SQLManager alloc]initDataBase];
    [sqlMng createTable];
    self.vUUID = uuid;
    
    defaultAlertMusic       = AlertMusicePre;
    defaultDistanceValue    = DistancePre;
    defaultAlertTime        = AlertTimePre;

    NSDictionary * deviceInfo = nil;
    //返回的是数据库中之前保存过相应的uuid设备的配置信息
    deviceInfo = [sqlMng queryDatabaseWithUUID:uuid];
    
    if (deviceInfo == nil) {
        NSLog(@"Database did not have the record with uuid:%@",uuid);
        defaultAlertMusic       = [defaultAlertMusic stringByAppendingString:@"Alchemy"];
        defaultDistanceValue    = [defaultDistanceValue stringByAppendingString:@"近"];
        defaultAlertTime        = [defaultAlertTime stringByAppendingString:@"30"];
        defaultPhoneAlertMode   = DefaultPhoneAlertMode;
        defaultDeviceAlertMOde  = DefaultDeviceAlertMode;
        defaultMode             = DefaultMode;
        defaultName             = nil;
        defaultImage            = nil;

    }else
    {
        defaultAlertMusic       = [defaultAlertMusic stringByAppendingString:[deviceInfo objectForKey:AlertMusic]];
        defaultDistanceValue    = [deviceInfo objectForKey:DistanceValue];
        if ([defaultDistanceValue isEqualToString:@"80"]) {
            defaultDistanceValue = @"近";
        }else if ([defaultDistanceValue isEqualToString:@"90"])
        {
            defaultDistanceValue = @"中";
        }else
        {
            defaultDistanceValue = @"远";
        }
        defaultDistanceValue = [DistancePre stringByAppendingString:defaultDistanceValue];

        defaultAlertTime  = [deviceInfo objectForKey:AlertTime];
        if ([defaultAlertTime isEqualToString:@"10"]) {
            defaultAlertTime = @"10秒";
        }else if ([defaultAlertTime isEqualToString:@"20"])
        {
            defaultAlertTime = @"20秒";
        }else
        {
            defaultAlertTime = @"30秒";
        }
        defaultAlertTime = [AlertTimePre stringByAppendingString:defaultAlertTime ];
        
        defaultPhoneAlertMode   = [deviceInfo objectForKey:PhoneMode];
        if ([defaultPhoneAlertMode isEqualToString:@"p1"]) {
            defaultPhoneAlertMode = @"关闭手机提醒";
        }else if ([defaultPhoneAlertMode isEqualToString:@"p2"])
        {
            defaultPhoneAlertMode = @"手机震动提醒";
        }else
        {
            defaultPhoneAlertMode = @"手机震动声光提醒";
        }
        
        defaultDeviceAlertMOde  = [deviceInfo objectForKey:DeviceMode];
        if ([defaultDeviceAlertMOde isEqualToString:@"d1"]) {
            defaultDeviceAlertMOde = @"关闭blueberry提醒";
        }else if ([defaultDeviceAlertMOde isEqualToString:@"d2"])
        {
            defaultDeviceAlertMOde = @"发光提醒";
        }else if([defaultDeviceAlertMOde isEqualToString:@"d3"])
        {
            defaultDeviceAlertMOde = @"声音提醒";
        }else
        {
            defaultDeviceAlertMOde = @"声光提醒";
        }
        
        defaultMode  = [deviceInfo objectForKey:BluetoothMode];
        if ([defaultMode isEqualToString:@"b1"]) {
            defaultMode = @"自动关闭双向警报";
        }else if ([defaultMode isEqualToString:@"b2"])
        {
            defaultMode = @"自动关闭blueberry报警";
        }else
        {
            defaultMode = @"自动关闭手机报警";
        }
        defaultName             = [deviceInfo objectForKey:DeviceName];
        defaultImage            = [deviceInfo objectForKey:ImageName];
        [self updateScopeValue:@"" signalValue:@"" powerVaule:@""];
    }
}

-(void)initializationInterface
{
    UIColor *shadowColor = [UIColor colorWithRed:ShadowColorR green:ShadowColorG blue:ShadowColorB alpha:1.0];
    CGRect rect = CGRectMake(170, 130, 135, 45);
    //提醒距离
    chooseAlertDistance = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseAlertDistance setFrame:CGRectOffset(rect, -150, 45)];
    chooseAlertDistance.backgroundColor = [UIColor clearColor];
    [chooseAlertDistance setBackgroundImage:[UIImage imageNamed:@"Settings_Bt_03"] forState:UIControlStateNormal];
    [chooseAlertDistance addTarget:self action:@selector(chooseDistanceAction:) forControlEvents:UIControlEventTouchUpInside];
    chooseAlertDistance.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [chooseAlertDistance setTitle:defaultDistanceValue forState:UIControlStateNormal];
   
    [chooseAlertDistance setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [chooseAlertDistance.titleLabel setShadowOffset:CGSizeMake(-0.5,-0.5)];
    chooseAlertDistance.tag = DistanceTag;
    [self.view addSubview:chooseAlertDistance];
    
    //报警音
    chooseAlertMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseAlertMusic setFrame:CGRectOffset(rect, -150, 100)];
    chooseAlertMusic.backgroundColor = [UIColor clearColor];
    [chooseAlertMusic setBackgroundImage:[UIImage imageNamed:@"Settings_Bt_03"] forState:UIControlStateNormal];
    [chooseAlertMusic addTarget:self action:@selector(chooseAlertMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    chooseAlertMusic.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [chooseAlertMusic setTitle:defaultAlertMusic forState:UIControlStateNormal];
  
    [chooseAlertMusic setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [chooseAlertMusic.titleLabel setShadowOffset:CGSizeMake(-0.5,-0.5)];
    chooseAlertMusic.tag = AlertMusicTag;
    [self.view addSubview:chooseAlertMusic];
    
       
    //警报时间
    chooseAlertTime = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseAlertTime setFrame:CGRectOffset(rect, 0, 45)];
    chooseAlertTime.backgroundColor = [UIColor clearColor];
    [chooseAlertTime setBackgroundImage:[UIImage imageNamed:@"Settings_Bt_03"] forState:UIControlStateNormal];
    [chooseAlertTime addTarget:self action:@selector(chooseAlertTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    chooseAlertTime.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [chooseAlertTime setTitle:defaultAlertTime forState:UIControlStateNormal];
    [chooseAlertTime setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [chooseAlertTime.titleLabel setShadowOffset:CGSizeMake(-0.5,-0.5)];
    chooseAlertTime.tag = AlertTimeTag;
    [self.view addSubview:chooseAlertTime];
    
    //设备工作模式
    chooseDeviceAlertMode = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseDeviceAlertMode setFrame:CGRectMake(20, chooseAlertMusic.frame.origin.y+chooseAlertMusic.frame.size.height+10, 285, 45)];
    chooseDeviceAlertMode.backgroundColor = [UIColor clearColor];
    [chooseDeviceAlertMode setBackgroundImage:[UIImage imageNamed:@"Settings_Bt_03"] forState:UIControlStateNormal];
    [chooseDeviceAlertMode addTarget:self action:@selector(chooseDeviceAlertModeAction:) forControlEvents:UIControlEventTouchUpInside];
    chooseDeviceAlertMode.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [chooseDeviceAlertMode setTitle:defaultDeviceAlertMOde forState:UIControlStateNormal];
    [chooseDeviceAlertMode setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [chooseDeviceAlertMode.titleLabel setShadowOffset:CGSizeMake(-0.5,-0.5)];
    chooseDeviceAlertMode.tag = DeviceModeTag;
    [self.view addSubview:chooseDeviceAlertMode];

    
    //手机工作模式
    choosePhoneAlertMode = [UIButton buttonWithType:UIButtonTypeCustom];
    [choosePhoneAlertMode setFrame:CGRectOffset(rect, 0, 100)];
    choosePhoneAlertMode.backgroundColor = [UIColor clearColor];
    [choosePhoneAlertMode setBackgroundImage:[UIImage imageNamed:@"Settings_Bt_03"] forState:UIControlStateNormal];
    [choosePhoneAlertMode addTarget:self action:@selector(choosePhoneAlertModeAction:) forControlEvents:UIControlEventTouchUpInside];
    choosePhoneAlertMode.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [choosePhoneAlertMode setTitle:defaultPhoneAlertMode forState:UIControlStateNormal];
    [choosePhoneAlertMode setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [choosePhoneAlertMode.titleLabel setShadowOffset:CGSizeMake(-0.5,-0.5)];
    choosePhoneAlertMode.tag = PhoneModeTag;
    [self.view addSubview:choosePhoneAlertMode];
    
    //设置蓝牙模式
    chooseMode = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseMode setFrame:CGRectMake(150, 350, 155, 45)];
    chooseMode.backgroundColor = [UIColor clearColor];
    [chooseMode setBackgroundImage:[UIImage imageNamed:@"Settings_Bt_02"] forState:UIControlStateNormal];
    [chooseMode addTarget:self action:@selector(chooseModeAction:) forControlEvents:UIControlEventTouchUpInside];
    chooseMode.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [chooseMode setTitle:defaultMode forState:UIControlStateNormal];
    [chooseMode setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [chooseMode.titleLabel setShadowOffset:CGSizeMake(-0.5,-0.5)];
    chooseMode.tag = ModeTag;
    [self.view addSubview:chooseMode];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, chooseMode.frame.origin.y, 120, 45)];
    textLabel.text = @"进入安全范围后:";
    [textLabel setBackgroundColor:[UIColor clearColor]];
    textLabel.font = [UIFont systemFontOfSize:FontSize];
    textLabel.textColor = shadowColor;
    textLabel.shadowOffset = CGSizeMake(-0.5,-0.5);
    [self.view addSubview:textLabel];
    [textLabel release];
    
    //是否在范围内，信号量，蓝牙电量
    CGSize size = CGSizeMake(20, 20);
    CGRect rectD1 = CGRectMake(50, 50, 60, 60);
    CGRect rectD2 = CGRectMake(30, 35, 100, 100);
    userPhoto = [[UIImageView alloc]init];
    userPhoto.backgroundColor = [UIColor clearColor];
    UIImage * userImage =nil;
    if (defaultImage) {
        [userPhoto setFrame:rectD2];
        NSString * userPhotoPath = [[NSString alloc]initWithFormat:@"%@/%@",imageDiskPath,defaultImage];
        NSData *data = [[NSData alloc]initWithContentsOfFile:userPhotoPath];
        userImage = [[[UIImage alloc]initWithData:data]autorelease];
        [data release];
    }else
    {
        [userPhoto setFrame:rectD1];
        userImage = [UIImage imageNamed:@"Main_Icon_Wallet_H"];
    }
    [userPhoto setImage:userImage];
    userPhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhoto)];
    [userPhoto addGestureRecognizer:tapGesture];
    photoBackground = [[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 120, 120)];
    [photoBackground setBackgroundColor:[UIColor clearColor]];
    [photoBackground setImage:[UIImage imageNamed:@"Settings_Frame"]];
    [self.view addSubview:photoBackground];
    [photoBackground release];
    [self.view addSubview:userPhoto];
    
    [tapGesture release];

    scopeImage = [[UIImageView alloc]initWithFrame:CGRectMake(photoBackground.frame.origin.x+photoBackground.frame.size.width+30, photoBackground.frame.origin.y+10, size.width, size.height)];
    [scopeImage setContentMode:UIViewContentModeScaleAspectFit];
    [scopeImage setBackgroundColor:[UIColor clearColor]];
    [scopeImage setImage:[UIImage imageNamed:@"Settings_Icon_Scope"]];
    [self.view addSubview:scopeImage];
    [scopeImage release];
    scopeLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, scopeImage.frame.origin.y-5, 90, 30)];
    scopeLabel.shadowOffset = CGSizeMake(-0.5, -0.5);
    [scopeLabel setTextAlignment:NSTextAlignmentLeft];
    scopeLabel.textColor = shadowColor;
    [scopeLabel setBackgroundColor:[UIColor clearColor]];
    [scopeLabel setText:@"在范围内"];
    [self.view addSubview:scopeLabel];
    
    wifiImage = [[UIImageView alloc]initWithFrame:CGRectMake(scopeImage.frame.origin.x, scopeImage.frame.origin.y+scopeImage.frame.size.height+20, size.width, size.height)];
    [wifiImage setContentMode:UIViewContentModeScaleAspectFit];
    [wifiImage setBackgroundColor:[UIColor clearColor]];
    [wifiImage setImage:[UIImage imageNamed:@"Settings_Icon_Sinal"]];
    [self.view addSubview:wifiImage];
    [wifiImage release];
    wifiLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, wifiImage.frame.origin.y-5, 90, 30)];
    wifiLabel.shadowOffset = CGSizeMake(-0.5, -0.5);
    [wifiLabel setTextAlignment:NSTextAlignmentLeft];
    [wifiLabel setBackgroundColor:[UIColor clearColor]];
    wifiLabel.textColor = shadowColor;
    [wifiLabel setText:@"100db"];
    [self.view addSubview:wifiLabel];
    
    devPowerPic = [[UIImageView alloc]initWithFrame:CGRectMake(wifiImage.frame.origin.x, wifiImage.frame.origin.y+wifiImage.frame.size.height+20,size.width, size.height)];
    [devPowerPic setContentMode:UIViewContentModeScaleAspectFit];
    [devPowerPic setBackgroundColor:[UIColor clearColor]];
    [devPowerPic setImage:[UIImage imageNamed:@"Settings_Icon_Battery"]];
    [self.view addSubview:devPowerPic];
    [devPowerPic release];
    devPowerLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, devPowerPic.frame.origin.y-5, 90, 30)];
    devPowerLabel.shadowOffset = CGSizeMake(-0.5, -0.5);
    [devPowerLabel setTextAlignment:NSTextAlignmentLeft];
    devPowerLabel.textColor = shadowColor;
    [devPowerLabel setBackgroundColor:[UIColor clearColor]];
    [devPowerLabel setText:@"%51"];
    [self.view addSubview:devPowerLabel];

}


#pragma mark - PopupView
-(void)popover:(id)sender withType:(PopUpTableViewDataSourceType)_type
{
    popUpTableviewController = [[PopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];

    [popUpTableviewController.view setFrame:CGRectMake(0, 0, 200, 200)];
   __block NSString *descriptionStr = nil;

    switch (_type) {
        case PopUpTableViewDataSourceDistance:
            //距离按钮
            [popUpTableviewController setDataSource:@[@"近",@"中",@"远"]];
            descriptionStr = @"提醒距离选择:";
            break;
        case PopUpTableViewDataSourceMusic:
            //声音按钮
            popUpTableviewController.title = @"手机提醒音";
            [popUpTableviewController setDataSource:@[@"Alchemy",@"AudibleAlarm",@"Bird",@"CS",@"Ericsson ring",@"Howl",@"ICQ sms sound",@"Jumping Cat",@"Laughter",@"Sent",@"Siren"]];
            descriptionStr = @"选择手机提醒音:";
            break;
        case PopUpTableViewDataSourceTime:
            //时间按钮
            [popUpTableviewController setDataSource:@[@"10秒",@"20秒",@"30秒"]];
            descriptionStr = @"报警时长:";
            break;
        case PopUpTableViewDataSourcePhoneAlertMode:
            //手机警报模式按钮
            [popUpTableviewController setDataSource:@[@"关闭手机提醒",@"手机震动提醒",@"手机震动声光提醒"]];
            descriptionStr = @"";
            break;
        case PopUpTableViewDataSourceDeviceAlertMode:
            //设备警报模式按钮按钮
            [popUpTableviewController setDataSource:@[@"关闭blueberry提醒",@"发光提醒",@"声音提醒",@"声光提醒"]];
            descriptionStr = @"";
            break;
        case PopUpTableViewDataSourceMode:
            //双向报警按钮
            [popUpTableviewController setDataSource:@[@"自动关闭双向报警",@"自动关闭blueberry报警",@"自动关闭手机报警"]];
            descriptionStr = @"";
            break;
        default:
            break;
    }
    
    DidSelectTableviewRowCongigureBlock block = ^(id item)
    {
        UIButton *btn = (UIButton *)sender;
        NSLog(@"%d",btn.tag);
        NSString * title = (NSString *)item;
        int i = 0;
        for (;i< [popUpTableviewController.dataSource count];i++) {
            NSString * str = [popUpTableviewController.dataSource objectAtIndex:i];
            if ([item isEqualToString:str]) {
                NSLog(@"Select Index:%d",i);
                break;
            }
        }
        NSString * str = nil;
        switch (btn.tag) {
            case DistanceTag:
                
                if (i == 0) {
                    str = DistanceNear;
                    NSLog(@"Distance Order: %@",DistanceNear);
                   
                }else if(i == 1)
                {
                    str = DistanceMid;
                    NSLog(@"Distance Order: %@",DistanceMid);
                }else if(i == 2)
                {
                    str = DistanceFar;
                    NSLog(@"Distance Order: %@",DistanceFar);
                }
                 [sqlMng updateKey:DistanceValue value:str withUUID:self.vUUID];
                break;
            case AlertMusicTag:
                break;
            case AlertTimeTag:
                if (i == 0) {
                    str = AlertTime10;
                    NSLog(@"Alert Time Order: %@",AlertTime10);
                }else if(i == 1)
                {
                    str = AlertTime20;
                   NSLog(@"Alert Time Order: %@",AlertTime20);
                }else if(i == 2)
                {
                    str = AlertTime30;
                   NSLog(@"Alert Time Order: %@",AlertTime30);
                }
                [sqlMng updateKey:AlertTime value:str withUUID:self.vUUID];
                break;
            case PhoneModeTag:
                if (i == 0) {
                    str = PhoneModeStopAlert;
                    NSLog(@"PhoneMode Order: %@",PhoneModeStopAlert);
                }else if(i == 1)
                {
                    str = PhoneModeVibrate;
                    NSLog(@"PhoneMode Order: %@",PhoneModeVibrate);
                }else if(i == 2)
                {
                    str = PhoneModeVibrateAndSound;
                    NSLog(@"PhoneMode Order: %@",PhoneModeVibrateAndSound);
                }
                [sqlMng updateKey:PhoneMode value:str withUUID:self.vUUID];
                break;
            case DeviceModeTag:
                if (i == 0) {
                    str = DeviceModeStopAlert;
                    NSLog(@"DeviceMode Order: %@",DeviceModeStopAlert);
                }else if(i == 1)
                {
                    str = DeviceModeLight;
                    NSLog(@"DeviceMode Order: %@",DeviceModeLight);
                }else if(i == 2)
                {
                    str = DeviceModeSound;
                    NSLog(@"DeviceMode Order: %@",DeviceModeSound);
                }else if (i == 3)
                {
                    str = DeviceModeLightSound;
                    NSLog(@"DeviceMode Order: %@",DeviceModeLightSound);
                }
                [sqlMng updateKey:DeviceMode value:str withUUID:self.vUUID];
                break;
            case ModeTag:
                if (i == 0) {
                    str = ModeMutualAlertStop;
                    NSLog(@"Mode Order: %@",ModeMutualAlertStop);
                }else if(i == 1)
                {
                    str = ModeDeviceAlertStop;
                    NSLog(@"Mode Order: %@",ModeDeviceAlertStop);
                }else if(i == 2)
                {
                    str = ModePhoneAlertStop;
                    NSLog(@"Mode Order: %@",ModePhoneAlertStop);
                }
                [sqlMng updateKey:BluetoothMode value:str withUUID:self.vUUID];
                break;
            default:
                break;
        }
        title = [descriptionStr stringByAppendingString:title];
        [btn setTitle:title forState:UIControlStateNormal];
        title = nil;
    };
    [popUpTableviewController setConfigureBlock:block];
    
    if (popover) {
        [popover release];
        popover = nil;
    }
    popover = [[FPPopoverController alloc] initWithViewController:popUpTableviewController];
    [popUpTableviewController release];
    
    popover.tint = FPPopoverDefaultTint;
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    [popover presentPopoverFromView:sender];
}


- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    [visiblePopoverController dismissPopoverAnimated:YES];
    [visiblePopoverController autorelease];
}


#pragma mark - 点击Button事件
-(void)chooseDistanceAction:(id)sender
{
     //选择距离事件
    NSLog(@"%s",__func__);
    [self popover:sender withType:PopUpTableViewDataSourceDistance];

}

-(void)chooseAlertMusicAction:(id)sender
{

    //选择提示音
    NSLog(@"%s",__func__);
    [self popover:sender withType:PopUpTableViewDataSourceMusic];
}

-(void)chooseDeviceAlertModeAction:(id)sender
{

    //选择设备的工作模式
    NSLog(@"%s",__func__);
    [self popover:sender withType:PopUpTableViewDataSourceDeviceAlertMode];
}

-(void)chooseAlertTimeAction:(id)sender
{
    //选择提醒时间长度
    NSLog(@"%s",__func__);
    [self popover:sender withType:PopUpTableViewDataSourceTime];
}

-(void)choosePhoneAlertModeAction:(id)sender
{
    NSLog(@"%s",__func__);
    [self popover:sender withType:PopUpTableViewDataSourcePhoneAlertMode];
    //手机提醒模式
}

-(void)chooseModeAction:(id)sender
{
     //蓝牙通讯模式
    NSLog(@"%s",__func__);
    [self popover:sender withType:PopUpTableViewDataSourceMode];
   
}

-(void)takePhoto
{
    NSLog(@"take photo action");
    CustomiseActionSheet * synActionSheet = [[CustomiseActionSheet alloc] init];
    synActionSheet.titles = [NSArray arrayWithObjects:@"From Camera", @"From Album",@"Cancel", nil];
    synActionSheet.destructiveButtonIndex = -1;
    synActionSheet.cancelButtonIndex = 2;
    NSUInteger result = [synActionSheet showInView:self.view];
    if (result==0) {
        //拍照
        NSLog(@"From Camera");
        [self presentViewController:photoManager.camera animated:YES completion:nil];
        
    }else if(result ==1)
    {
        //从相册选择
        NSLog(@"From Album");
        [self presentViewController:photoManager.pickingImageView animated:YES completion:nil];
       
    }else
    {
        NSLog(@"Cancel");
    }
}


#pragma mark - 更新：范围值，信号量值，电量值
-(void)updateScopeValue:(NSString *)scopeV signalValue:(NSString *)signalV powerVaule:(NSString *)powerV
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *signalStrFormat = [NSString stringWithFormat:@"%@db",signalV];
        NSString *powerStrFormat = [NSString stringWithFormat:@"%@%%",powerV];
        self.scopeLabel.text    = scopeV;
        self.wifiLabel.text     = signalStrFormat;
        self.devPowerLabel.text = powerStrFormat;
    });
}

#pragma mark - Public method
-(void)initDirectory
{
    NSFileManager * defaultManager = [NSFileManager defaultManager];
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileDirectory = [path stringByAppendingPathComponent:@"PicFolder"];
    
    if (![defaultManager fileExistsAtPath:fileDirectory]) {
        [defaultManager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }else
    {
        NSLog(@"Directory already exists");
    }
    if (imageDiskPath ) {
        [imageDiskPath release];
        imageDiskPath = nil;
    }
    imageDiskPath = [[fileDirectory stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]retain];
}


-(void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    [photoManager release];
    photoManager = nil;
    [wifiLabel release];
    [scopeLabel release];
    [devPowerLabel release];
}
@end
