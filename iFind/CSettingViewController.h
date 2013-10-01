//
//  CSettingViewController.h
//  iFind
//
//  Created by Carl on 13-10-1.
//  Copyright (c) 2013年 iFind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSettingViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *titleBtn;
@property (retain, nonatomic) IBOutlet UIButton *houseBtn;
@property (retain, nonatomic) IBOutlet UIButton *companyBtn;
- (IBAction)houseAction:(id)sender;
- (IBAction)companyAction:(id)sender;

@end
