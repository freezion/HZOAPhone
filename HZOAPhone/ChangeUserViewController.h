//
//  ChangeUserViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-18.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "GDataXMLNode.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "DDMenuController.h"
#import "EmailViewController.h"
#import "MainViewController.h"
#import "EmailViewController.h"
#import "MemberViewController.h"
#import "NoticeViewController.h"
#import "SystemConfig.h"

@interface ChangeUserViewController : UIViewController<MBProgressHUDDelegate, UIAlertViewDelegate, UITextFieldDelegate> {
    UITextField *txtUserId;
    UITextField *txtPassword;
    MBProgressHUD *HUD;
    UIButton *subButton;
}

@property (nonatomic, retain) IBOutlet UITextField *txtUserId;
@property (nonatomic, retain) IBOutlet UITextField *txtPassword;
@property (nonatomic, retain) IBOutlet UIButton *subButton;

- (IBAction)login:(id)sender;

@end
