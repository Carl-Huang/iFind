//
//  CScanViewController.m
//  iFind
//
//  Created by Carl on 13-9-23.
//  Copyright (c) 2013年 iFind. All rights reserved.
//
#define BUTTON_WIDTH 137.0
#define BUTTON_HEIGHT 137.0
#define FIND_BUTTON_TAG 10
#define CONTROL_BUTTON_TAG 11
#import "CScanViewController.h"
#import "CBLEButton.h"
#import "CBLEManager.h"
@interface CScanViewController ()
@property (nonatomic,retain) NSArray * defaultImages;
@property (nonatomic,retain) NSArray * defaultHightlighImages;
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
        NSLog(@"Found Peripheral");
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
    //Button1
    UIImage * image_1 = [_defaultImages objectAtIndex:0];
    UIImage * highlight_1 = [_defaultHightlighImages objectAtIndex:0];
    CBLEButton * bleButton_1 = [[CBLEButton alloc] initWithFrame:rect_1 withImage:image_1 withHighLight:highlight_1 withTitle:nil];
    bleButton_1.tag = 1;
    [self.view addSubview:bleButton_1];
    [bleButton_1 release];
    //Button2
    UIImage * image_2 = [_defaultImages objectAtIndex:1];
    UIImage * highlight_2 = [_defaultHightlighImages objectAtIndex:1];
    CBLEButton * bleButton_2 = [[CBLEButton alloc] initWithFrame:rect_2 withImage:image_2 withHighLight:highlight_2 withTitle:nil];
    bleButton_2.tag = 2;
    [self.view addSubview:bleButton_2];
    //Button3
    UIImage * image_3 = [_defaultImages objectAtIndex:2];
    UIImage * highlight_3 = [_defaultHightlighImages objectAtIndex:2];
    CBLEButton * bleButton_3 = [[CBLEButton alloc] initWithFrame:rect_3 withImage:image_3 withHighLight:highlight_3 withTitle:nil];
    bleButton_3.tag = 3;
    [self.view addSubview:bleButton_3];
    //Button4
    UIImage * image_4 = [_defaultImages objectAtIndex:3];
    UIImage * highlight_4 = [_defaultHightlighImages objectAtIndex:3];
    CBLEButton * bleButton_4 = [[CBLEButton alloc] initWithFrame:rect_4 withImage:image_4 withHighLight:highlight_4 withTitle:nil];
    bleButton_4.tag = 4;
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
    [self.view addSubview:controlButton];
    [self.view addSubview:setttingButton];
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

}
//响应设置按钮点击事件
- (void)showSettingScene:(id)sender
{
    
}

@end
