//
//  CPFirstViewController.m
//  BaseBandcommunication
//
//  Created by xiao chengfei on 14-3-8.
//  Copyright (c) 2014年 CrespoXiao. All rights reserved.
//

#import "CPFirstViewController.h"
#import "CPBaseBand.h"


@interface CPFirstViewController ()

@end

@implementation CPFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [ _atTextfield resignFirstResponder];
}


- (IBAction)sendAction:(id)sender {
  if (_atTextfield.text.length == 0) {
    return;
  }
  [ _atTextfield resignFirstResponder];
  [[CPBaseBand sharedInstance]sendATCommand:[CPBaseBand sharedInstance].baseBand andCommand:_atTextfield.text];
}
@end
