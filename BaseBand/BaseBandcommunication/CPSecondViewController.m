//
//  CPSecondViewController.m
//  BaseBandcommunication
//
//  Created by xiao chengfei on 14-3-8.
//  Copyright (c) 2014年 CrespoXiao. All rights reserved.
//

#import "CPSecondViewController.h"
#import "CPBaseBand.h"


@interface CPSecondViewController ()

@end

@implementation CPSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  _messageTextView.layer.borderWidth = 1.0;
  _messageTextView.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [_messageTextView resignFirstResponder];
  [_phoneTextfield resignFirstResponder];
}

- (IBAction)sendAction:(id)sender {
  if (_messageTextView.text.length == 0 || _phoneTextfield.text.length == 0) {
    return;
  }
  [_messageTextView resignFirstResponder];
  [_phoneTextfield resignFirstResponder];
  [[CPBaseBand sharedInstance]sendSMSWithPDUMode:[CPBaseBand sharedInstance].baseBand
                                        andPhone:_phoneTextfield.text
                                         andText:_messageTextView.text];
}
@end
