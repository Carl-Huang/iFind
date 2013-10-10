//
//  CSettingViewController.m
//  iFind
//
//  Created by Carl on 13-10-1.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import "CSettingViewController.h"
@interface CSettingViewController ()

@end

@implementation CSettingViewController

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
    self.title = NSLocalizedString(@"Setting", nil);
    //设置返回按钮
    UIImage * backImage = [UIImage imageNamed:@"Settings_Btn_Back"];
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
    [backButton addTarget:self action:@selector(backToMainview) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:backImage forState:UIControlStateNormal];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    
    UIImage * doneImage = [UIImage imageNamed:@"Settings_Btn_Confirm"];
    UIButton * doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(0, 0, doneImage.size.width, doneImage.size.height)];
    [doneButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setImage:doneImage forState:UIControlStateNormal];
    UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = doneItem;
    [doneItem release];
    
    
    [_titleBtn setTitle:NSLocalizedString(@"FunctionSetting", nil) forState:UIControlStateDisabled];
    [_houseBtn setTitle:NSLocalizedString(@"House", nil) forState:UIControlStateNormal];
    [_companyBtn setTitle:NSLocalizedString(@"Company", nil) forState:UIControlStateNormal];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)dealloc {
    [_titleBtn release];
    [_houseBtn release];
    [_companyBtn release];
    [super dealloc];
}
- (IBAction)houseAction:(id)sender
{
    
}

- (IBAction)companyAction:(id)sender
{
    
}

-(void)backToMainview
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)save:(id)sender
{
    [self backToMainview];
}
@end
