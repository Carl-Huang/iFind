//
//  DeviceDetailViewController.m
//  DisableOtherAudioPlaying
//
//  Created by vedon on 20/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//
#define FontSize 14

#define DefaultDistanceValue    @"提醒距离选择:远"
#define DefaultAlertTime        @"报警时长:30秒"
#define DefaultAlertMusic       @"选择手机提醒音:"
#define DefaultPhoneAlertMode   @"手机震动声光提醒"
#define DefaultDeviceAlertMode  @"声光提醒"
#define DefaultMode             @"自动关闭手机报警"
#define DefaultUserPhoto        @""


#import "DeviceDetailViewController.h"
#import "FPPopoverController.h"
#import "PopUpTableViewController.h"

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
}
@end

@implementation DeviceDetailViewController

@synthesize chooseAlertDistance,chooseAlertMusic,chooseAlertTime,chooseDeviceAlertMode,chooseMode,choosePhoneAlertMode,userPhoto,devPowerPic,signalPic;
@synthesize photoManager;

-(void)loadView
{
    [super loadView];
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.view.backgroundColor = [UIColor whiteColor];
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
    [self initializationInterface];
    
    //相片处理类
    ConfigureImageBlock block = ^(id item){
        [userPhoto setImage:(UIImage *)item];
    };
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
}

-(void)initializationInterface
{
    CGRect rect = CGRectMake(170, 120, 130, 40);
    chooseAlertDistance = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseAlertDistance setFrame:rect];
    chooseAlertDistance.backgroundColor = [UIColor blueColor];
    [chooseAlertDistance addTarget:self action:@selector(chooseDistanceAction:) forControlEvents:UIControlEventTouchUpInside];
    chooseAlertDistance.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [chooseAlertDistance setTitle:defaultDistanceValue forState:UIControlStateNormal];
    [self.view addSubview:chooseAlertDistance];
    
    chooseAlertMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseAlertMusic setFrame:CGRectOffset(rect, 0, 50)];
    chooseAlertMusic.backgroundColor = [UIColor blueColor];
    [chooseAlertMusic addTarget:self action:@selector(chooseAlertMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    chooseAlertMusic.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [chooseAlertMusic setTitle:defaultAlertMusic forState:UIControlStateNormal];
    [self.view addSubview:chooseAlertMusic];
    
    chooseDeviceAlertMode = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseDeviceAlertMode setFrame:CGRectOffset(rect, 0, 100)];
    chooseDeviceAlertMode.backgroundColor = [UIColor blueColor];
    [chooseDeviceAlertMode addTarget:self action:@selector(chooseDeviceAlertModeAction:) forControlEvents:UIControlEventTouchUpInside];
    chooseDeviceAlertMode.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [chooseDeviceAlertMode setTitle:defaultDeviceAlertMOde forState:UIControlStateNormal];
    [self.view addSubview:chooseDeviceAlertMode];
    
    
    chooseAlertTime = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseAlertTime setFrame:CGRectOffset(rect, -150, 50)];
    chooseAlertTime.backgroundColor = [UIColor blueColor];
    [chooseAlertTime addTarget:self action:@selector(chooseAlertTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    chooseAlertTime.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [chooseAlertTime setTitle:defaultAlertTime forState:UIControlStateNormal];
    [self.view addSubview:chooseAlertTime];
    
    choosePhoneAlertMode = [UIButton buttonWithType:UIButtonTypeCustom];
    [choosePhoneAlertMode setFrame:CGRectOffset(rect, -150, 100)];
    choosePhoneAlertMode.backgroundColor = [UIColor blueColor];
    [choosePhoneAlertMode addTarget:self action:@selector(choosePhoneAlertModeAction:) forControlEvents:UIControlEventTouchUpInside];
    choosePhoneAlertMode.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [choosePhoneAlertMode setTitle:defaultPhoneAlertMode forState:UIControlStateNormal];
    [self.view addSubview:choosePhoneAlertMode];
    
    chooseMode = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseMode setFrame:CGRectMake(140, 370, 160, 40)];
    chooseMode.backgroundColor = [UIColor blueColor];
    [chooseMode addTarget:self action:@selector(chooseModeAction:) forControlEvents:UIControlEventTouchUpInside];
    chooseMode.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [chooseMode setTitle:defaultMode forState:UIControlStateNormal];
    [self.view addSubview:chooseMode];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectOffset(rect, -160, 250)];
    textLabel.text = @"进入安全范围后:";
    [self.view addSubview:textLabel];
    [textLabel release];
    
    //是否在范围内，信号量，蓝牙电量
    
    userPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 120, 130)];
    userPhoto.backgroundColor = [UIColor blueColor];
    userPhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhoto)];
    [userPhoto addGestureRecognizer:tapGesture];
    [self.view addSubview:userPhoto];
    [tapGesture release];
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
            [popUpTableviewController setDataSource:@[@"近",@"中",@"远"]];
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
        NSString * title = (NSString *)item;
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
    //拍照
    [self presentViewController:photoManager.camera animated:YES completion:nil];
    
    //选取照片
    [self presentViewController:photoManager.pickingImageView animated:YES completion:nil];
}

#pragma mark - Public method
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
}
@end
