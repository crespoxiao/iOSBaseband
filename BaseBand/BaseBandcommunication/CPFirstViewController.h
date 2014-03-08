//
//  CPFirstViewController.h
//  BaseBandcommunication
//
//  Created by CrespoXiao on 14-3-8.
//  Copyright (c) 2014年 CrespoXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPFirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *inputAtCommadLabel;
@property (weak, nonatomic) IBOutlet UITextField *atTextfield;
@property (weak, nonatomic) IBOutlet UIButton *sendButtn;
- (IBAction)sendAction:(id)sender;

@end
