//
//  MusicViewController.m
//  iFind
//
//  Created by vedon on 26/9/13.
//  Copyright (c) 2013 iFind. All rights reserved.
//

#import "MusicViewController.h"
#import "OrderType.h"
#import "SQLManager.h"

@interface MusicViewController ()
{
    
    NSInteger selectIndex1;
    NSInteger selectIndex2;
    
    SQLManager *sqlMng;
    NSInteger songIndex;
    NSInteger vibrateIndex;
    BOOL isFirstView;
    BOOL isVibrateItem;
}
@end

@implementation MusicViewController
@synthesize configyreMusicBlock;
@synthesize dataSource;
@synthesize musicDic;
@synthesize vUUID;
@synthesize musicTableview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithUUID:(NSString *)uuid
{
    self = [super init];
    if (self) {
        vUUID = [[NSString alloc]initWithString:uuid];
        sqlMng = [[SQLManager alloc]initDataBase];
        songIndex = -1;
        vibrateIndex = -1;
        isFirstView = YES;
        musicTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 420)];
        selectIndex1 = -1;
        selectIndex2 = -1;
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataSource = [[NSArray alloc]initWithArray:@[@"Alchemy",@"AudibleAlarm",@"Bird",@"CS",@"Ericsson ring",@"Howl",@"ICQ sms sound",@"Jumping Cat",@"Laughter",@"Sent",@"Siren",@"震动"]];
    [self getDidSelectRowInDatabase];
    musicDic = [[NSMutableDictionary alloc]init];
    UIToolbar *bar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [bar setBackgroundImage:[UIImage imageNamed:@"Main_TopBar"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(5, 10, 50, 30)];
    [btn addTarget:self action:@selector(backToDeviceDetailViewcontroller) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"Settings_Btn_Back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    
    //确定按钮
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setFrame:CGRectMake(5, 10, 50, 30)];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"Settings_Btn_Confirm"] forState:UIControlStateNormal];
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc]initWithCustomView:confirmBtn];
    
    UIBarButtonItem *flexibleBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    bar.items = @[backBtn,flexibleBtn,confirmBarBtn];
    [self.view addSubview:bar];
    [flexibleBtn release];
    [backBtn release];
    [bar release];
    [self.view addSubview:musicTableview];
    [musicTableview setDataSource:self];
    [musicTableview setDelegate:self];
	// Do any additional setup after loading the view.
}
-(void)backToDeviceDetailViewcontroller
{
    NSLog(@"%s",__func__);
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"musicTable back to upper view controller");
    }];
}

-(void)confirmBtnClick
{
    NSLog(@"%s",__func__);
    //    NSLog(@"%@",musicDic);
    self.configyreMusicBlock(musicDic);
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"musicTable back to upper view controller");
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    [dataSource release];
    [musicDic release];
    [vUUID release];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease ];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
//    }
    cell.textLabel.text = [dataSource objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (isFirstView) {
        if (indexPath.row == songIndex || indexPath.row == vibrateIndex) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;

        if (indexPath.row == selectIndex1) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [musicDic setObject:cell.textLabel.text forKey:SelectMusic];

        }
        if (indexPath.row == selectIndex2 &&isVibrateItem) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [musicDic setObject:cell.textLabel.text forKey:SelectVibrate];
        }
    }
    
    
    return cell;
}



-(void)getDidSelectRowInDatabase
{
    NSString * vibrateStr = [sqlMng getValue:VibrateMode ByUUID:vUUID];
    NSString * songStr = [sqlMng getValue:AlertMusic ByUUID:vUUID];
    for (int i = 0; i<[dataSource count]; i++) {
        NSString *str = [dataSource objectAtIndex:i];
        if ([str isEqualToString:songStr]) {
            songIndex = i;
        }
    }
    if ([vibrateStr isEqualToString:@"1"]) {
        vibrateIndex = [dataSource count]-1;
        isVibrateItem = YES;
    }
    selectIndex1 = songIndex;
    selectIndex2 = vibrateIndex;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isFirstView = NO;
    selectIndex2 = [dataSource count]-1;
    if (indexPath.row == [dataSource count]-1)
    {
        isVibrateItem = !isVibrateItem;
        selectIndex2 = indexPath.row;

    }else
    {
        selectIndex1 = indexPath.row;
    }

    [tableView reloadData];
}

@end
