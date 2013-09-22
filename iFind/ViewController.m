//
//  ViewController.m
//  IWifi
//
//  Created by vedon on 20/9/13.
//  Copyright (c) 2013 com.vedon. All rights reserved.
//

#import "ViewController.h"
#import "DeviceDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()

@end
    
@implementation ViewController
@synthesize firstItemView,secondItemView,thirdItemView,fourthItemView;
@synthesize findBtn,helpBtn,remoteControlBtn,settingBtn;


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgoundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Main_Bg4"]];
    [backgoundImg setContentMode:UIViewContentModeScaleAspectFill];
    [backgoundImg setFrame:CGRectMake(0, 0, 320,460)];
    [self.view addSubview:backgoundImg];
    [backgoundImg release];
    UIImageView *titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Main_Top_Bar"]];
    [titleView setContentMode:UIViewContentModeScaleToFill];
    [titleView setFrame:CGRectMake(0, 0, 320,44)];
    [self.view addSubview:titleView];
    [titleView release];
    
//    UIButton * detailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [detailBtn setTitle:@"进入设备信息页面" forState:UIControlStateNormal];
//    [detailBtn addTarget:self action:@selector(pushDetailviewController) forControlEvents:UIControlEventTouchUpInside];
//    [detailBtn setFrame:CGRectMake(0, 0, 150, 44)];
//    [self.view addSubview:detailBtn];

    [self initializationInterface];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)pushDetailviewController
{
    DeviceDetailViewController *detailViewController = [[DeviceDetailViewController alloc]init];
    [detailViewController initializationDefaultValue:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    detailViewController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}


-(void)initializationInterface
{
    CGRect rect = CGRectMake(20, 50, 130, 130);
    firstItemView = [[UIImageView alloc]initWithFrame:rect];
    [firstItemView setImage:[UIImage imageNamed:@"Main_Add_01"]];
    [firstItemView setBackgroundColor:[UIColor clearColor]];
    [firstItemView setContentMode:UIViewContentModeScaleAspectFit];
    firstItemView.userInteractionEnabled = YES;
    [self.view addSubview:firstItemView];
    [firstItemView release];
    
    secondItemView = [[UIImageView alloc]initWithFrame:CGRectOffset(rect, 150, 0)];
    [secondItemView setImage:[UIImage imageNamed:@"Main_Add_01"]];
    [secondItemView setBackgroundColor:[UIColor clearColor]];
    [secondItemView setContentMode:UIViewContentModeScaleAspectFit];
    secondItemView.userInteractionEnabled = YES;
    [self.view addSubview:secondItemView];
    [secondItemView release];
    
    thirdItemView = [[UIImageView alloc]initWithFrame:CGRectOffset(rect, 0, 140)];
    [thirdItemView setImage:[UIImage imageNamed:@"Main_Add_01"]];
    [thirdItemView setBackgroundColor:[UIColor clearColor]];
    [thirdItemView setContentMode:UIViewContentModeScaleAspectFit];
    thirdItemView.userInteractionEnabled = YES;
    [self.view addSubview:thirdItemView];
    [thirdItemView release];
    
    fourthItemView = [[UIImageView alloc]initWithFrame:CGRectOffset(rect, 150, 140)];
    [fourthItemView setImage:[UIImage imageNamed:@"Main_Add_01"]];
    [fourthItemView setBackgroundColor:[UIColor clearColor]];
    [fourthItemView setContentMode:UIViewContentModeScaleAspectFit];
    fourthItemView.userInteractionEnabled = YES;
    [self.view addSubview:fourthItemView];
    [fourthItemView release];
    
    CGRect btnRect = CGRectMake(110, 135, 100, 100);
    findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [findBtn setFrame:btnRect];
    findBtn.backgroundColor = [UIColor clearColor];
    [findBtn setBackgroundImage:[UIImage imageNamed:@"Main_Bt_01"] forState:UIControlStateNormal];
    [findBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [findBtn addTarget:self action:@selector(findBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    findBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [findBtn setTitle:@"找" forState:UIControlStateNormal];
    UIColor *shadowColor = [UIColor colorWithRed:ShadowColorR green:ShadowColorG blue:ShadowColorB alpha:1.0];
    [findBtn setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [findBtn.titleLabel setShadowOffset:CGSizeMake(-0.5,-0.5)];
    [self.view addSubview:findBtn];
  
    
    
}

-(void)findBtnAction:(id)sender
{
    NSLog(@"%s",__func__);
    
}
@end
