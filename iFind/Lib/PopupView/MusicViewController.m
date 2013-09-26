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
    
    NSInteger selectIndex;
    SQLManager *sqlMng;
    NSInteger songIndex;
    NSInteger vibrateIndex;
    BOOL isFirstView;
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

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    dataSource = [[NSArray alloc]initWithArray:@[@"Alchemy",@"AudibleAlarm",@"Bird",@"CS",@"Ericsson ring",@"Howl",@"ICQ sms sound",@"Jumping Cat",@"Laughter",@"Sent",@"Siren",@"震动"]];
    [self getDidSelectRowInDatabase];
    musicDic = [[NSMutableDictionary alloc]init];
    selectIndex = -1;
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
    [self dismissModalViewControllerAnimated:YES];
}

-(void)confirmBtnClick
{
    NSLog(@"%s",__func__);
    //    NSLog(@"%@",musicDic);
    self.configyreMusicBlock(musicDic);
    [self dismissModalViewControllerAnimated:YES];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
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
        if (selectIndex != [dataSource count]-1 ) {
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark && indexPath.row!= selectIndex) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
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
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isFirstView = NO;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    if (indexPath.row == [dataSource count]-1)
    {
        
    }else
    {
        songIndex = indexPath.row;
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (indexPath.row == [dataSource count]-1) {
                [musicDic setObject:@"" forKey:SelectVibrate];
            }else
            {
                [musicDic setObject:@"" forKey:SelectMusic];
            }
        }else
        {
            if (indexPath.row == [dataSource count]-1) {
                [musicDic setObject:cell.textLabel.text forKey:SelectVibrate];
            }else
            {
                [musicDic setObject:cell.textLabel.text forKey:SelectMusic];
            }
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    //    selectIndex = indexPath.row;
    //    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
    //        cell.accessoryType = UITableViewCellAccessoryNone;
    //        if (indexPath.row == [dataSource count]-1) {
    //            [musicDic setObject:@"" forKey:SelectVibrate];
    //        }else
    //        {
    //            [musicDic setObject:@"" forKey:SelectMusic];
    //        }
    //    }else
    //    {
    //        if (indexPath.row == [dataSource count]-1) {
    //            [musicDic setObject:cell.textLabel.text forKey:SelectVibrate];
    //        }else
    //        {
    //            [musicDic setObject:cell.textLabel.text forKey:SelectMusic];
    //        }
    //        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //    }
    [tableView reloadData];
    
    
}

@end
