//
//  CPSecondViewController.h
//  BaseBandcommunication
//
//  Created by CrespoXiao on 14-3-8.
//  Copyright (c) 2014年 CrespoXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface CPSecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *inputPhoneLable;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UILabel *inputMseeageLabel;

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendAction:(id)sender;
@end
