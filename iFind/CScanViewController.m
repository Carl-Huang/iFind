//
//  CScanViewController.m
//  iFind
//
//  Created by Carl on 13-9-23.
//  Copyright (c) 2013年 iFind. All rights reserved.
//
#define BUTTON_WIDTH 137.0
#define BUTTON_HEIGHT 137.0
#import "CScanViewController.h"
#import "CBLEButton.h"
@interface CScanViewController ()

@end

@implementation CScanViewController
#pragma mark - Instance Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //调用初始化UI方法
	[self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


//初始化UI方法
- (void)initUI
{
    self.title = NSLocalizedString(@"MainSceneTitle", nil);
    self.wantsFullScreenLayout = YES;
    //自定义UIViewController背景颜色
    UIImage * bgImage = [UIImage imageNamed:@"Main_Bg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
    
    
    float marginTop = 30.0f;
    float hspace = 25.0f;
    float vspace = 35.0f;
    float marginLeft = (self.view.frame.size.width - hspace - BUTTON_WIDTH * 2) * .5f;
    
    CGRect rect_1 = CGRectMake(marginLeft, marginTop, BUTTON_WIDTH, BUTTON_HEIGHT);
    CGRect rect_2 = CGRectMake(marginLeft + BUTTON_WIDTH + hspace, marginTop, BUTTON_WIDTH, BUTTON_HEIGHT);
    CGRect rect_3 = CGRectMake(marginLeft, marginTop + vspace + BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
    CGRect rect_4 = CGRectMake(marginLeft + BUTTON_WIDTH + hspace, marginTop + vspace + BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
    UIImage * image_1 = [UIImage imageNamed:@"Main_Icon_Wallet_N"];
    CBLEButton * bleButton_1 = [[CBLEButton alloc] initWithFrame:rect_1 withImage:image_1 withTitle:nil];
    bleButton_1.tag = 1;
    [self.view addSubview:bleButton_1];
    [bleButton_1 release];
    
    UIImage * image_2 = [UIImage imageNamed:@"Main_Icon_Key_N"];
    CBLEButton * bleButton_2 = [[CBLEButton alloc] initWithFrame:rect_2 withImage:image_2 withTitle:nil];
    bleButton_2.tag = 2;
    [self.view addSubview:bleButton_2];
    
    UIImage * image_3 = [UIImage imageNamed:@"Main_Icon_Bag_N"];
    CBLEButton * bleButton_3 = [[CBLEButton alloc] initWithFrame:rect_3 withImage:image_3 withTitle:nil];
    bleButton_3.tag = 3;
    [self.view addSubview:bleButton_3];

    UIImage * image_4 = [UIImage imageNamed:@"Main_Icon_Kid_N"];
    CBLEButton * bleButton_4 = [[CBLEButton alloc] initWithFrame:rect_4 withImage:image_4 withTitle:nil];
    bleButton_4.tag = 4;
    [self.view addSubview:bleButton_4];
    
}

@end
