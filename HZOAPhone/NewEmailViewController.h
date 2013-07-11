//
//  NewEmailViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-19.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTokenField.h"
#import "DDMenuController.h"
#import "Mail.h"
#import "MBProgressHUD.h"
#import "Employee.h"

@class TPKeyboardAvoidingScrollView;

@protocol NewEmailDelegate <NSObject>
- (void) showContact:(NSString *) contactId theName:(NSString *) contactName withButton:(UIButton *)buttonId;
- (void) deleteContact:(NSString *) contactId theName:(NSString *) contactName withButton:(UIButton *)buttonId;
@end

@interface NewEmailViewController : UIViewController<JSTokenFieldDelegate, UIActionSheetDelegate, NewEmailDelegate, UIAlertViewDelegate, MBProgressHUDDelegate> {
    JSTokenField *toField;
	JSTokenField *ccField;
    UIView *titleView;
    UITextView *contextTextView;
    CGFloat keyboardHeight;
    UILabel *lblEmailType;
    TPKeyboardAvoidingScrollView *scrollView;
    UIToolbar *keyboardToolbar;
    MBProgressHUD *HUD;
    UITextField *subTitle;
    Mail *mail;
    NSMutableDictionary *usernamepasswordKVPairs;
}

@property (nonatomic, retain) IBOutlet JSTokenField *toField;
@property (nonatomic, retain) IBOutlet JSTokenField *ccField;
@property (nonatomic, retain) IBOutlet UIView *titleView;
@property (nonatomic, retain) IBOutlet UILabel *lblEmailType;
@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITextView *contextTextView;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;
@property (nonatomic, retain) IBOutlet UITextField *subTitle;
@property (nonatomic, retain) UIButton *toButton;
@property (nonatomic, retain) UIButton *ccButton;
@property (nonatomic, retain) Mail *mail;

@end
