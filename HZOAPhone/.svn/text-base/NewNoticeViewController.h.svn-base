//
//  NewNoticeViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-22.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTokenField.h"
#import "CPPickerView.h"
#import "SystemConfig.h"
#import "Notice.h"
#import "MBProgressHUD.h"

@class TPKeyboardAvoidingScrollView;

@protocol NewNoticeDelegate <NSObject>
- (void) showContactNotice:(NSString *) contactId theName:(NSString *) contactName;
@end

@interface NewNoticeViewController : UIViewController<JSTokenFieldDelegate, UIActionSheetDelegate, CPPickerViewDataSource, CPPickerViewDelegate, NewNoticeDelegate, MBProgressHUDDelegate> {
    JSTokenField *toField;
    CGFloat keyboardHeight;
    UIToolbar *keyboardToolbar;
    TPKeyboardAvoidingScrollView *scrollView;
    UILabel *lblNoticeType;
    UILabel *lblNoticeTitle;
    CPPickerView *typePickerView;
    UIView *typeView;
    UIView *titleView;
    UITextView *contextTextView;
    NSMutableArray *_toRecipients;
    NSMutableDictionary *listContactId;
    NSMutableArray *values;
    SystemConfig *didSelectSystemConfig;
    UITextField *subTitle;
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSMutableDictionary *listContactId;
@property (nonatomic, retain) IBOutlet JSTokenField *toField;
@property (nonatomic, retain) IBOutlet UITextField *subTitle;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;
@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *lblNoticeType;
@property (nonatomic, retain) IBOutlet UILabel *lblNoticeTitle;
@property (nonatomic, retain) IBOutlet UIView *typeView;
@property (nonatomic, retain) IBOutlet UIView *titleView;
@property (nonatomic, retain) IBOutlet UITextView *contextTextView;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) SystemConfig *didSelectSystemConfig;

@end
