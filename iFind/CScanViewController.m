//
//  CScanViewController.m
//  iFind
//
//  Created by Carl on 13-9-23.
//  Copyright (c) 2013年 iFind. All rights reserved.
//
#define BUTTON_WIDTH 137.0
#define BUTTON_HEIGHT 137.0
#define BUTTON_TAG_1 1
#define BUTTON_TAG_2 2
#define BUTTON_TAG_3 3
#define BUTTON_TAG_4 4
#define FIND_BUTTON_TAG 10
#define CONTROL_BUTTON_TAG 11
#define PIC_FOLDER @"PicFolder"
#import "CScanViewController.h"
#import "CBLEButton.h"
#import "CBLEManager.h"
#import "PopUpTableViewController.h"
#import "FPPopoverController.h"
#import "DeviceDetailViewController.h"
#import "CSettingViewController.h"
#import "SBTableAlert.h"
#import "CDataSource.h"
#import "CUtilsFunc.h"
#import "ACPScrollMenu.h"
#import "ACPItem.h"
#import "SQLManager.h"
#import "OrderType.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
typedef enum {
    REMOTE_ACTION_MUSIC = 0,
    REMOTE_ACTION_TAKE_PICTURE,
    REMOTE_ACTION_TAKE_VIDEO,
    REMOTE_ACTION_RECORD
}REMOTE_ACTION;

@interface CScanViewController () <ACPScrollDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MPMediaPickerControllerDelegate>
@property (nonatomic,retain) NSMutableArray * defaultImages;
@property (nonatomic,retain) NSMutableArray * defaultHightlighImages;
@property (nonatomic,assign) int currentButtonTag;
@property (nonatomic,retain) SQLManager * sqlManager;
@property (nonatomic,retain) NSArray * dataSource;
@property (nonatomic,assign) REMOTE_ACTION actionType;
@property (nonatomic,retain) MPMusicPlayerController * musicPlayer;
@end

@implementation CScanViewController
#pragma mark - Instance Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        //初始化数据库管理类
        _sqlManager = [[SQLManager alloc] initDataBase];
        _dataSource = [[NSArray alloc] initWithArray:@[@"音乐",@"拍照",@"视频",@"录音"]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //调用初始化UI方法
	[self initUI];
    
    
    _musicPlayer = [[MPMusicPlayerController alloc] init];

    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //初始化默认图标
    @autoreleasepool {
        [self initImages];
    }
    
    
    for(int i = 1; i <= 4; i++)
    {
        UIView * view = [self.view viewWithTag:i];
        if([view isKindOfClass:[CBLEButton class]])
        {
            CBLEButton * button = (CBLEButton *)view;
            [button setImage:[_defaultImages objectAtIndex:(i-1)] withHighLight:[_defaultHightlighImages objectAtIndex:(i-1)]];
        }
    }
    
    
    CBLEManager * bleManager = [CBLEManager sharedManager];
    [bleManager startScan];
    //发现蓝牙处理block
    bleManager.discoverHandler = ^(void){
        NSLog(@"Disconver Handler");
        int index = [[bleManager foundPeripherals] count];
        if(index == 0) return;
        for(int i = 1; i <= index; i++)
        {
            id sender = [self.view viewWithTag:i];
            if([sender isKindOfClass:[CBLEButton class]])
            {
                CBLEButton * bleButton = (CBLEButton *)sender;
                [bleButton setHighlight:YES];
            }
        }
        
        for(int i = index + 1; i <= 4; i++)
        {
            id sender = [self.view viewWithTag:i];
            if([sender isKindOfClass:[CBLEButton class]])
            {
                CBLEButton * bleButton = (CBLEButton *)sender;
                [bleButton setHighlight:NO];
            }
        }
        
    };
    
    //蓝牙连接处理block
    bleManager.connectedHandler = ^(CBPeripheral * peripheral){
        id sender = [self.view viewWithTag:self.currentButtonTag];
        if([sender isKindOfClass:[CBLEButton class]])
        {
            CBLEButton * bleButton = (CBLEButton *)sender;
            [bleButton setUuid:[CUtilsFunc convertCFUUIDIntoString:peripheral.UUID]];
            [_sqlManager insertTableWithUUID:bleButton.uuid Tag:bleButton.tag];
            
            CBLEPeriphral * instance = nil;
            for(CBLEPeriphral * blePeripheral in [bleManager connectedPeripherals])
            {
                if(blePeripheral.peripheral.UUID == peripheral.UUID)
                {
                    NSLog(@"%@",bleButton.uuid);
                    blePeripheral.tag = bleButton.tag;
                    blePeripheral.UUID = bleButton.uuid;
                    instance = blePeripheral;
                    break;
                }
            }
            
            if(!instance) return ;
            instance.remoteControlHandler = ^(CBPeripheral * peripheral){
                
                if(self.presentedViewController)
                {
                    UIViewController * viewController = self.presentedViewController;
                    if([viewController isKindOfClass:[UIImagePickerController class]])
                    {
                        [self processTakePicAndVideo:viewController];
                    }
                    
                }
                
            };
        }
        
        [self enableButton];
    };
    
    //蓝牙断开连接处理block
    bleManager.disconnectHandler = ^(CBPeripheral * peripheral){
        if([[bleManager connectedPeripherals] count] == 0)
        {
            [self disableButton];
        }
        for(int i = 1; i <= 4; i++)
        {
            CBLEButton * bleButton = (CBLEButton *)[self.view viewWithTag:i];
            if([bleButton.uuid isEqualToString:[CUtilsFunc convertCFUUIDIntoString:peripheral.UUID]])
            {
                [bleButton setHighlight:NO];
                bleButton.uuid = nil;
            }
        }
    };
    

    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[CBLEManager sharedManager] stopScan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    [self.view release];
    self.view = nil;
    [_defaultImages release];
    _defaultImages = nil;
    [_defaultHightlighImages release];
    _defaultHightlighImages = nil;
    [_sqlManager release];
    _sqlManager = nil;
    [super dealloc];
}



#pragma mark - Private Methods
//初始化图片，如果用户没有设置图片，则使用默认图片
- (void)initImages
{
    NSString * imageName_1 = [_sqlManager getValue:ImageName ByTag:BUTTON_TAG_1];
    NSString * imageName_2 = [_sqlManager getValue:ImageName ByTag:BUTTON_TAG_2];
    NSString * imageName_3 = [_sqlManager getValue:ImageName ByTag:BUTTON_TAG_3];
    NSString * imageName_4 = [_sqlManager getValue:ImageName ByTag:BUTTON_TAG_4];
    NSURL * imageURL_1, * imageURL_2, * imageURL_3, * imageURL_4;
    NSURL * imageURL_H_1, * imageURL_H_2, * imageURL_H_3, * imageURL_H_4;
    if(imageName_1 == nil || [imageName_1 isEqualToString:TagOneImageH])
    {
        imageURL_1 = [[NSBundle mainBundle] URLForResource:TagOneImageN withExtension:@"png"];
        imageURL_H_1 = [[NSBundle mainBundle] URLForResource:TagOneImageH withExtension:@"png"];
    }
    else
    {
        imageURL_1 = imageURL_H_1 = [CUtilsFunc URLForResource:imageName_1 inDirectory:PIC_FOLDER];
    }
    
    if(imageName_2 == nil || [imageName_2 isEqualToString:TagTwoImageH])
    {
        imageURL_2 = [[NSBundle mainBundle] URLForResource:TagTwoImageN withExtension:@"png"];
        imageURL_H_2 = [[NSBundle mainBundle] URLForResource:TagTwoImageH withExtension:@"png"];
    }
    else
    {
        imageURL_2 = imageURL_H_2 = [CUtilsFunc URLForResource:imageName_2 inDirectory:PIC_FOLDER];
    }
    
    if(imageName_3 == nil || [imageName_3 isEqualToString:TagThreeImageH])
    {
        imageURL_3 = [[NSBundle mainBundle] URLForResource:TagThreeImageN withExtension:@"png"];
        imageURL_H_3 = [[NSBundle mainBundle] URLForResource:TagThreeImageH withExtension:@"png"];
    }
    else
    {
        imageURL_3 = imageURL_H_3 = [CUtilsFunc URLForResource:imageName_3 inDirectory:PIC_FOLDER];
    }
    
    if(imageName_4 == nil || [imageName_4 isEqualToString:TagFourImageH])
    {
        imageURL_4 = [[NSBundle mainBundle] URLForResource:TagFourImageN withExtension:@"png"];
        imageURL_H_4 = [[NSBundle mainBundle] URLForResource:TagFourImageH withExtension:@"png"];
    }
    else
    {
        imageURL_4 = imageURL_H_4 = [CUtilsFunc URLForResource:imageName_4 inDirectory:PIC_FOLDER];
    }
    
    
    if(_defaultImages != nil)
    {
        [_defaultImages release];
    }
    
    if(_defaultHightlighImages != nil)
    {
        [_defaultHightlighImages release];
    }
    
    _defaultImages = [[NSMutableArray alloc] initWithObjects:
                      [UIImage imageWithData:[NSData dataWithContentsOfFile:[imageURL_1 path]]],
                      [UIImage imageWithData:[NSData dataWithContentsOfFile:[imageURL_2 path]]],
                      [UIImage imageWithData:[NSData dataWithContentsOfFile:[imageURL_3 path]]],
                      [UIImage imageWithData:[NSData dataWithContentsOfFile:[imageURL_4 path]]],nil];
    _defaultHightlighImages = [[NSMutableArray alloc] initWithObjects:
                               [UIImage imageWithData:[NSData dataWithContentsOfFile:[imageURL_H_1 path]]],
                               [UIImage imageWithData:[NSData dataWithContentsOfFile:[imageURL_H_2 path]]],
                               [UIImage imageWithData:[NSData dataWithContentsOfFile:[imageURL_H_3 path]]],
                               [UIImage imageWithData:[NSData dataWithContentsOfFile:[imageURL_H_4 path]]],nil];
}

//初始化UI方法
- (void)initUI
{
    //设置标题
    self.title = NSLocalizedString(@"MainSceneTitle", nil);
    self.wantsFullScreenLayout = YES;
    //自定义UIViewController背景颜色
    UIImage * bgImage = [UIImage imageNamed:@"Main_Bg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
    
    //定义图标的间隔，计算图标在界面的位置
    float marginTop = 34.0f;
    float hspace = 15.0f;
    float vspace = 20.0f;
    float marginLeft = (self.view.frame.size.width - hspace - BUTTON_WIDTH * 2) * .5f;
    //图标1的位置，左上角
    CGRect rect_1 = CGRectMake(marginLeft, marginTop, BUTTON_WIDTH, BUTTON_HEIGHT);
    //图标2的位置，右上角
    CGRect rect_2 = CGRectMake(marginLeft + BUTTON_WIDTH + hspace, marginTop, BUTTON_WIDTH, BUTTON_HEIGHT);
    //图标3的位置，左下角
    CGRect rect_3 = CGRectMake(marginLeft, marginTop + vspace + BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
    //图标4的位置，右下角
    CGRect rect_4 = CGRectMake(marginLeft + BUTTON_WIDTH + hspace, marginTop + vspace + BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
    //按钮的点击事件
    TapHandler tapHandler = ^(id sender){
        if([sender isKindOfClass:[CBLEButton class]])
        {
            NSLog(@"CBLEButton");
            CBLEButton * bleButton = (CBLEButton *)sender;
            if(!bleButton.isHighlight) return ;
            //如果uuid不为空，表示蓝牙已经连接，直接进入蓝牙设置界面
            if(bleButton.uuid != nil)
            {
                [self showDetailViewControler:bleButton];
                return ;
            }
            int index = bleButton.tag;
            [self showSBAlert:index];
        }
    };
    
    //Button1
//    UIImage * image_1 = [_defaultImages objectAtIndex:0];
//    UIImage * highlight_1 = [_defaultHightlighImages objectAtIndex:0];
    CBLEButton * bleButton_1 = [[CBLEButton alloc] initWithFrame:rect_1 withImage:nil withHighLight:nil withTitle:nil withTag:BUTTON_TAG_1];
    bleButton_1.tag = BUTTON_TAG_1;
    bleButton_1.tapHandler = tapHandler;
    [self.view addSubview:bleButton_1];
    [bleButton_1 release];
    //Button2
//    UIImage * image_2 = [_defaultImages objectAtIndex:1];
//    UIImage * highlight_2 = [_defaultHightlighImages objectAtIndex:1];
    CBLEButton * bleButton_2 = [[CBLEButton alloc] initWithFrame:rect_2 withImage:nil withHighLight:nil withTitle:nil withTag:BUTTON_TAG_2];
    bleButton_2.tag = BUTTON_TAG_2;
    bleButton_2.tapHandler = tapHandler;
    [self.view addSubview:bleButton_2];
    //Button3
//    UIImage * image_3 = [_defaultImages objectAtIndex:2];
//    UIImage * highlight_3 = [_defaultHightlighImages objectAtIndex:2];
    CBLEButton * bleButton_3 = [[CBLEButton alloc] initWithFrame:rect_3 withImage:nil withHighLight:nil withTitle:nil withTag:BUTTON_TAG_3];
    bleButton_3.tag = BUTTON_TAG_3;
    bleButton_3.tapHandler = tapHandler;
    [self.view addSubview:bleButton_3];
    //Button4
//    UIImage * image_4 = [_defaultImages objectAtIndex:3];
//    UIImage * highlight_4 = [_defaultHightlighImages objectAtIndex:3];
    CBLEButton * bleButton_4 = [[CBLEButton alloc] initWithFrame:rect_4 withImage:nil withHighLight:nil withTitle:nil withTag:BUTTON_TAG_4];
    bleButton_4.tag = BUTTON_TAG_4;
    bleButton_4.tapHandler = tapHandler;
    [self.view addSubview:bleButton_4];
    
    //添加找设备按钮
    UIImage * findImage = [UIImage imageNamed:@"Main_Bt_Find"];
    UIButton * findButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [findButton setFrame:CGRectMake((self.view.frame.size.width - findImage.size.width)*.5f, 137.0f, findImage.size.width, findImage.size.height)];
    [findButton setImage:findImage forState:UIControlStateNormal];
    [findButton addTarget:self action:@selector(findPeripheral:) forControlEvents:UIControlEventTouchUpInside];
    findButton.tag = FIND_BUTTON_TAG;
    findButton.enabled = NO;
    [self.view addSubview:findButton];
    
    //底部按钮
    float btnMarginTop = marginTop + vspace + BUTTON_HEIGHT * 2 + 20;
    float btnHSpace = 4.0f;
    UIImage * helpImage = [UIImage imageNamed:@"Main_Bt_Help"];
    
    //帮助按钮
    UIButton * helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpButton setTitle:NSLocalizedString(@"Help", nil) forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [helpButton setBackgroundImage:helpImage forState:UIControlStateNormal];
    [helpButton setFrame:CGRectMake(marginLeft, btnMarginTop, helpImage.size.width, helpImage.size.height)];
    [helpButton addTarget:self action:@selector(showHelpScene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helpButton];
    
    //手机遥控按钮
    UIImage * controlImage = [UIImage imageNamed:@"Main_Bt_Remote"];
    UIButton * controlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [controlButton setTitle:NSLocalizedString(@"RemoteControl", nil) forState:UIControlStateNormal];
    [controlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [controlButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [controlButton setBackgroundImage:controlImage forState:UIControlStateNormal];
    [controlButton setFrame:CGRectMake(marginLeft + btnHSpace + helpButton.frame.size.width, btnMarginTop, controlImage.size.width, controlImage.size.height)];
    controlButton.tag = CONTROL_BUTTON_TAG;
    controlButton.enabled = NO;
    [controlButton addTarget:self action:@selector(remoteControl:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:controlButton];
    
    //设置按钮
    UIButton * setttingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setttingButton setTitle:NSLocalizedString(@"Setting", nil) forState:UIControlStateNormal];
    [setttingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setttingButton setBackgroundImage:helpImage forState:UIControlStateNormal];
    [setttingButton setFrame:CGRectMake(marginLeft + btnHSpace * 2 + helpButton.frame.size.width + controlButton.frame.size.width, btnMarginTop, helpImage.size.width, helpImage.size.height)];
    [setttingButton addTarget:self action:@selector(showSettingScene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setttingButton];
    
}

- (void)disableButton
{
    UIButton * findButton = (UIButton *)[self.view viewWithTag:FIND_BUTTON_TAG];
    findButton.enabled = NO;
    UIButton * controlButton = (UIButton *)[self.view viewWithTag:CONTROL_BUTTON_TAG];
    controlButton.enabled = NO;
}

- (void)enableButton
{
    UIButton * findButton = (UIButton *)[self.view viewWithTag:FIND_BUTTON_TAG];
    findButton.enabled = YES;
    UIButton * controlButton = (UIButton *)[self.view viewWithTag:CONTROL_BUTTON_TAG];
    controlButton.enabled = YES;
}

//响应找按钮的点击事件
- (void)findPeripheral:(id)sender
{
    [self setUpScrollMenu];
    NSArray * connectedPeripheral = [[CBLEManager sharedManager] connectedPeripherals];
    if([connectedPeripheral count] == 0)
    {
        [self disableButton];
        return ;
    }
    
    if([connectedPeripheral count] == 1)
    {
        CBLEPeriphral * blePeripheral = [connectedPeripheral objectAtIndex:0];
        [blePeripheral writeAlertLevelHigh];
        return ;
    }
    
}

//显示滚动菜单
- (void)setUpScrollMenu
{
    UIView * overLayer = [[UIView alloc] init];
    overLayer.frame = self.view.bounds;
    overLayer.backgroundColor = [UIColor blackColor];
    overLayer.alpha = .8f;
    overLayer.tag = 100;
    ACPScrollMenu * _ACPScrollMenu = [[ACPScrollMenu alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 100)];
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (int i = 1; i < 5; i++) {
		NSString *imgName = [NSString stringWithFormat:@"%d.png", i];
		NSString *imgSelectedName = [NSString stringWithFormat:@"%ds.png", i];
		//Set the items
		ACPItem *item = [[ACPItem alloc] initACPItem:[UIImage imageNamed:@"bg.png"] iconImage:[UIImage imageNamed:imgName] andLabel:@"Test"];
		//Set highlighted behaviour
		[item setHighlightedBackground:nil iconHighlighted:[UIImage imageNamed:imgSelectedName] textColorHighlighted:[UIColor redColor]];
        
		[array addObject:item];
	}
    
	[_ACPScrollMenu setUpACPScrollMenu:array];
    [array release];
	//We choose an animation when the user touch the item (you can create your own animation)
	[_ACPScrollMenu setAnimationType:ACPZoomOut];
	_ACPScrollMenu.delegate = self;
    _ACPScrollMenu.tag = 101;
    [overLayer addSubview:_ACPScrollMenu];
    [_ACPScrollMenu release];
    [self.view addSubview:overLayer];
    [overLayer release];
}



//响应帮助按钮点击事件
- (void)showHelpScene:(id)sender
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Help", nil) message:NSLocalizedString(@"HelpContent", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];

}

- (void)showMusicPlayer
{
    MPMediaPickerController * mediaPickerController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPickerController.delegate = self;
    mediaPickerController.allowsPickingMultipleItems = YES;
    [self presentViewController:mediaPickerController animated:YES completion:nil];
    [mediaPickerController release];
}

- (void)takePicture
{
    
    [self showCameraWithMediaTypes:@[(NSString *)kUTTypeImage]];
}


- (void)captureVideo
{
    [self showCameraWithMediaTypes:@[(NSString *)kUTTypeMovie]];
}

- (void)showCameraWithMediaTypes:(NSArray *)mediaTypes
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的设备不支持摄像头！" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return ;
    }
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.mediaTypes = mediaTypes;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    [imagePickerController release];
}


- (void)processTakePicAndVideo:(id)viewController
{
    UIImagePickerController * picker = (UIImagePickerController *)viewController;
    NSArray * mediaTypes = picker.mediaTypes;
    if(!mediaTypes) return ;
    NSString * mediaType = [mediaTypes objectAtIndex:0];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        NSLog(@"Take picture");
        [picker takePicture];
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        if(![picker startVideoCapture])
        {
            [picker stopVideoCapture];
        }
    }
}

#pragma mark - Button Actions
//响应手机遥控按钮点击事件
- (void)remoteControl:(id)sender
{
    PopUpTableViewController * popupTableViewController = [[PopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
    popupTableViewController.title = NSLocalizedString(@"RemoteControl", nil);
    popupTableViewController.dataSource = _dataSource;
    [popupTableViewController.view setFrame:CGRectMake(0, 0, 200, 250)];
    [popupTableViewController setConfigureBlock:^(id item){

        UIButton * controlButton = (UIButton *)[self.view viewWithTag:CONTROL_BUTTON_TAG];
        [controlButton setTitle:(NSString *)item forState:UIControlStateNormal];
        
        int index = [_dataSource indexOfObject:item];
        switch (index) {
            case REMOTE_ACTION_MUSIC:
                [self showMusicPlayer];
                break;
            case REMOTE_ACTION_TAKE_PICTURE:
                [self takePicture];
                break;
            case REMOTE_ACTION_TAKE_VIDEO:
                [self captureVideo];
                break;
            case REMOTE_ACTION_RECORD:
                
                break;
            default:
                break;
        }
     
    }];
    FPPopoverController * popoverController = [[FPPopoverController alloc] initWithViewController:popupTableViewController];
    [popupTableViewController release];
    popoverController.tint = FPPopoverDefaultTint;
    popoverController.arrowDirection = FPPopoverArrowDirectionAny;
    [popoverController presentPopoverFromView:sender];
    [popoverController release];
    
}
//响应设置按钮点击事件
- (void)showSettingScene:(id)sender
{
    CSettingViewController * settingViewController = [[CSettingViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [settingViewController release];
    [self presentViewController:navigationController animated:YES completion:^{
        [navigationController release];
    }];
}


//显示搜索蓝牙对话框
-(void)showSBAlert:(int)tag
{
    CDataSource * dataSource = [[CDataSource alloc] init];
    dataSource.dataSource = [[CBLEManager sharedManager] foundPeripherals];
    SBTableAlert * tableAlert = [[SBTableAlert alloc] initWithTitle:@"搜索设备" cancelButtonTitle:@"取消" messageFormat:nil];
    dataSource.selectDirectoryHandler = ^(CBPeripheral * peripheral){
        if([peripheral isConnected])
        {
//            [self showDetailViewControler];
        }
        else
        {
            self.currentButtonTag = tag;
            [[CBLEManager sharedManager] connectToPeripheral:peripheral];
        }
    };
    
    dataSource.dismissHandler = ^{
        self.currentButtonTag = 0;
    };
    tableAlert.dataSource = dataSource;
    tableAlert.delegate = dataSource;
    [tableAlert show];
}

//进入蓝牙设置页面方法
-(void)showDetailViewControler:(CBLEButton *)sender
{
    DeviceDetailViewController * detailViewController = [[DeviceDetailViewController alloc] initWithNibName:nil bundle:nil];
    CBLEPeriphral * blePeripheral = nil;
    for(CBLEPeriphral * instance in [[CBLEManager sharedManager] connectedPeripherals])
    {
        if([instance.UUID isEqualToString:sender.uuid])
        {
            blePeripheral = instance;
            break;
        }
    }
    NSLog(@"%@",blePeripheral.UUID);
    blePeripheral.tag = sender.tag;
    detailViewController.blePeripheral = blePeripheral;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

//ACPScrollMenu Delegate Methods
- (void)scrollMenu:(ACPItem *)menu didSelectIndex:(NSInteger)selectedIndex {
	NSLog(@"Item %d", selectedIndex);
    UIView * overlay = [self.view viewWithTag:100];
    UIView *scrollView = [overlay viewWithTag:101];
    [UIView animateWithDuration:.8f animations:^{
        scrollView.alpha = 0.0;
        scrollView.frame = CGRectMake(0, 0, 0, 0);
//        overlay.frame = CGRectMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        [scrollView removeFromSuperview];
        [overlay removeFromSuperview];
    }];
}


#pragma mark - UIImagePickerControllerDelegate Methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"%@",mediaType);
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
        if(url)
        {
            ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
            [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
               if(error)
               {
                   UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"保存失败！" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
                   [alertView show];
                   [alertView release];
                   NSLog(@"save video error:%@",error);
               }
            }];
            [library release];
        }
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if(image)
        {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
        }
        
    }
}



#pragma mark - MPMediaPickerControllerDelegate Methods
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if(_musicPlayer == nil)
    {
        NSLog(@"The music player is nil.");
        return ;
    }
    [_musicPlayer setQueueWithItemCollection:mediaItemCollection];
    [_musicPlayer play];
}

@end
