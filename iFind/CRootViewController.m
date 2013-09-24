//
//  CRootViewController.m
//  iFind
//
//  Created by Carl on 13-9-20.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import "CRootViewController.h"
#import "CBLEManager.h"
#import "CBLEPeriphral.h"
#import "CUtilsFunc.h"
@interface CRootViewController ()
@property (nonatomic,retain) CBLEManager * bleManager;
@end

@implementation CRootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _bleManager = [CBLEManager sharedManager];
    _bleManager.discoverHandler = ^(void){
        NSLog(@"Reload");
        [self.tableView reloadData];
    
    };
    
    
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [_bleManager startScan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [[_bleManager foundPeripherals] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    CBPeripheral * blePeriphral = [[_bleManager foundPeripherals] objectAtIndex:indexPath.row];
    [cell.textLabel setText:blePeriphral.name];
//    [cell.detailTextLabel setText:[NSString stringWithFormat:@"RSSI:%d",blePeriphral.RSSI.intValue]];
    return cell;
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

//    CBLEPeriphral * blePeriphral = [[_bleManager foundPeripherals] objectAtIndex:indexPath.row];
//    if([blePeriphral.peripheral isConnected])
//    {
//        [blePeriphral writeAlertLevelHigh];
//    }
//    else
//    {
//        [_bleManager connectToPeripheral:blePeriphral.peripheral];
//    }
 
}

@end
