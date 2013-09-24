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
#import "CScanViewController.h"
#import "CBLEButton.h"
#import "CBLEManager.h"
#import "PopUpTableViewController.h"
#import "FPPopoverController.h"
#import "DeviceDetailViewController.h"
#import "SBTableAlert.h"
#import "CDataSource.h"
#import "CUtilsFunc.h"
@interface CScanViewController ()
@property (nonatomic,retain) NSArray * defaultImages;
@property (nonatomic,retain) NSArray * defaultHightlighImages;
@property (nonatomic,assign) int currentButtonTag;
@end

@implementation CScanViewController
#pragma mark - Instance Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //初始化默认图标
        _defaultImages = [[NSArray alloc] initWithObjects:
                          [UIImage imageNamed:@"Main_Icon_Wallet_N"],
                          [UIImage imageNamed:@"Main_Icon_Key_N"],
                          [UIImage imageNamed:@"Main_Icon_Bag_N"],
                          [UIImage imageNamed:@"Main_Icon_Kid_N"],
                          nil];
        _defaultHightlighImages = [[NSArray alloc] initWithObjects:
                                   [UIImage imageNamed:@"Main_Icon_Wallet_H"],
                                   [UIImage imageNamed:@"Main_Icon_Key_H"],
                                   [UIImage imageNamed:@"Main_Icon_Bag_H"],
                                   [UIImage imageNamed:@"Main_Icon_Kid_H"],
                                   nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //调用初始化UI方法
	[self initUI];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    CBLEManager * bleManager = [CBLEManager sharedManager];
    bleManager.discoverHandler = ^(void){
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
    
    
    bleManager.connectedHandler = ^(CBPeripheral * peripheral){
        id sender = [self.view viewWithTag:self.currentButtonTag];
        if([sender isKindOfClass:[CBLEButton class]])
        {
            CBLEButton * bleButton = (CBLEButton *)sender;
            [bleButton setUuid:[CUtilsFunc convertCFUUIDIntoString:peripheral.UUID]];
        }
    };
    
    
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
    [super dealloc];
}

//初始化UI方法
- (void)initUI
{
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
    
    TapHandler tapHandler = ^(id sender){
        if([sender isKindOfClass:[CBLEButton class]])
        {
            NSLog(@"CBLEButton");
            
            CBLEButton * bleButton = (CBLEButton *)sender;
            if(bleButton.uuid != nil)
            {
                [self showDetailViewControler];
                return ;
            }
            int index = bleButton.tag;
            [self showSBAlert:index];
        }
    };
    
    //Button1
    UIImage * image_1 = [_defaultImages objectAtIndex:0];
    UIImage * highlight_1 = [_defaultHightlighImages objectAtIndex:0];
    CBLEButton * bleButton_1 = [[CBLEButton alloc] initWithFrame:rect_1 withImage:image_1 withHighLight:highlight_1 withTitle:nil withTag:BUTTON_TAG_1];
    bleButton_1.tag = BUTTON_TAG_1;
    bleButton_1.tapHandler = tapHandler;
    [self.view addSubview:bleButton_1];
    [bleButton_1 release];
    //Button2
    UIImage * image_2 = [_defaultImages objectAtIndex:1];
    UIImage * highlight_2 = [_defaultHightlighImages objectAtIndex:1];
    CBLEButton * bleButton_2 = [[CBLEButton alloc] initWithFrame:rect_2 withImage:image_2 withHighLight:highlight_2 withTitle:nil withTag:BUTTON_TAG_2];
    bleButton_2.tag = BUTTON_TAG_2;
    bleButton_2.tapHandler = tapHandler;
    [self.view addSubview:bleButton_2];
    //Button3
    UIImage * image_3 = [_defaultImages objectAtIndex:2];
    UIImage * highlight_3 = [_defaultHightlighImages objectAtIndex:2];
    CBLEButton * bleButton_3 = [[CBLEButton alloc] initWithFrame:rect_3 withImage:image_3 withHighLight:highlight_3 withTitle:nil withTag:BUTTON_TAG_3];
    bleButton_3.tag = BUTTON_TAG_3;
    bleButton_2.tapHandler = tapHandler;
    [self.view addSubview:bleButton_3];
    //Button4
    UIImage * image_4 = [_defaultImages objectAtIndex:3];
    UIImage * highlight_4 = [_defaultHightlighImages objectAtIndex:3];
    CBLEButton * bleButton_4 = [[CBLEButton alloc] initWithFrame:rect_4 withImage:image_4 withHighLight:highlight_4 withTitle:nil withTag:BUTTON_TAG_4];
    bleButton_4.tag = BUTTON_TAG_4;
    bleButton_2.tapHandler = tapHandler;
    [self.view addSubview:bleButton_4];
    
    //添加找设备按钮
    UIImage * findImage = [UIImage imageNamed:@"Main_Bt_Find"];
    UIButton * findButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [findButton setFrame:CGRectMake((self.view.frame.size.width - findImage.size.width)*.5f, 137.0f, findImage.size.width, findImage.size.height)];
    [findButton setImage:findImage forState:UIControlStateNormal];
    [findButton addTarget:self action:@selector(findPeripheral:) forControlEvents:UIControlEventTouchUpInside];
    findButton.tag = FIND_BUTTON_TAG;
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
    [controlButton setBackgroundImage:controlImage forState:UIControlStateNormal];
    [controlButton setFrame:CGRectMake(marginLeft + btnHSpace + helpButton.frame.size.width, btnMarginTop, controlImage.size.width, controlImage.size.height)];
    controlButton.tag = CONTROL_BUTTON_TAG;
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
    
    
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    
}


//响应找按钮的点击事件
- (void)findPeripheral:(id)sender
{
    
}
//响应帮助按钮点击事件
- (void)showHelpScene:(id)sender
{
    
}
//响应手机遥控按钮点击事件
- (void)remoteControl:(id)sender
{
    PopUpTableViewController * popupTableViewController = [[PopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
    popupTableViewController.title = NSLocalizedString(@"RemoteControl", nil);
    popupTableViewController.dataSource = @[@"音乐",@"拍照",@"视频",@"录音"];
    [popupTableViewController.view setFrame:CGRectMake(0, 0, 200, 250)];
    [popupTableViewController setConfigureBlock:^(id item){
        UIButton * controlButton = (UIButton *)[self.view viewWithTag:CONTROL_BUTTON_TAG];
        [controlButton setTitle:(NSString *)item forState:UIControlStateNormal];
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
    DeviceDetailViewController * detailViewController = [[DeviceDetailViewController alloc] initWithNibName:nil bundle:nil];
    [detailViewController initializationDefaultValue:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}



-(void)showSBAlert:(int)tag
{
    
    CDataSource * dataSource = [[CDataSource alloc] init];
    dataSource.dataSource = [[CBLEManager sharedManager] foundPeripherals];
    SBTableAlert * tableAlert = [[SBTableAlert alloc] initWithTitle:@"搜索设备" cancelButtonTitle:@"取消" messageFormat:nil];
    dataSource.selectDirectoryHandler = ^(CBPeripheral * peripheral){
        if([peripheral isConnected])
        {
            [self showDetailViewControler];
        }
        else
        {
            self.currentButtonTag = tag;
            [[CBLEManager sharedManager] connectToPeripheral:peripheral];
        }
    };
    
    dataSource.dismissHandler = ^{
        
    };
    tableAlert.dataSource = dataSource;
    tableAlert.delegate = dataSource;
    [tableAlert show];
}

-(void)showDetailViewControler
{
    DeviceDetailViewController * detailViewController = [[DeviceDetailViewController alloc] initWithNibName:nil bundle:nil];
    [detailViewController initializationDefaultValue:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}


@end
