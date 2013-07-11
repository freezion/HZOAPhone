//
//  NewCalendarViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-18.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "MBProgressHUD.h"
#import "CalenderChooseViewController.h"
#import "InvitEmployeeViewController.h"
#import "EventAlertViewController.h"
#import "ChooseCustomerViewController.h"
#import "ChooseTypeViewController.h"
#import "Calendar.h"
#import "DDMenuController.h"

@interface NewCalendarViewController : UITableViewController<CalenderChooseDelegate, InvitEmployeeViewControllerDelegate, EventAlertViewDelegate, ChooseCustomerDelegate, ChooseTypeDelegate, MBProgressHUDDelegate, UIAlertViewDelegate> {
    MBProgressHUD *HUD;
    UITextField *txtTitle;
    UITextField *txtLocation;
    UITextView *txtNotes;
    UILabel *startLabel;
    UILabel *endLabel;
    UILabel *invitionLabel;
    UILabel *alertLabel;
    UILabel *typeLabel;
    UISwitch *switchImport;
    UISwitch *switchPrivate;
    UILabel *customerNameLabel;
    UILabel *contractIdLabel;
    UILabel *contractStartLabel;
    UILabel *contractEndLabel;
    NSDate *startDateT;
    NSDate *endDateT;
    BOOL stateAllDay;
    NSMutableArray *tokenList;
    NSString *reminder;
    int selectIndexSave;
    int selectIndexCustomer;
    int selectIndexContract;
    int selectIndexType;
    int selectIndexType1;
    NSString *customerIdLocal;
    NSString *contractIdLocal;
    CGFloat keyboardHeight;
    UIToolbar *keyboardToolbar;
    Calendar *calendarObj;
    NSMutableDictionary *usernamepasswordKVPairs;
    UIAlertView *alertAdd;
    BOOL editFlag;
    NSMutableDictionary *listContactCustom;
    UITableViewCell *customerCell;
}

@property (nonatomic, retain) IBOutlet UITextField *txtTitle;
@property (nonatomic, retain) IBOutlet UITextField *txtLocation;
@property (nonatomic, retain) IBOutlet UITextView *txtNotes;
@property (nonatomic, retain) IBOutlet UILabel *startLabel;
@property (nonatomic, retain) IBOutlet UILabel *endLabel;
@property (nonatomic, retain) IBOutlet UILabel *invitionLabel;
@property (nonatomic, retain) IBOutlet UILabel *alertLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UISwitch *switchImport;
@property (nonatomic, retain) IBOutlet UISwitch *switchPrivate;
@property (nonatomic, retain) IBOutlet UILabel *customerNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *contractIdLabel;
@property (nonatomic, retain) IBOutlet UILabel *contractStartLabel;
@property (nonatomic, retain) IBOutlet UILabel *contractEndLabel;
@property (nonatomic, retain) IBOutlet UITableViewCell *customerCell;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) IBOutlet UITableViewCell *deleteCell;
@property (nonatomic) BOOL stateAllDay;
@property (nonatomic) int selectIndexSave;
@property (nonatomic, retain) NSMutableArray *tokenList;
@property (nonatomic, retain) NSString *reminder;
@property (nonatomic) int selectIndexType;
@property (nonatomic) int selectIndexType1;
@property (nonatomic) int selectIndexCustomer;
@property (nonatomic) int selectIndexContract;
@property (nonatomic, retain) NSString *customerIdLocal;
@property (nonatomic, retain) NSString *contractIdLocal;
@property (nonatomic, retain) NSString *eventTypeId;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;
@property (nonatomic, retain) Calendar *calendarObj;
@property (nonatomic, retain) NSString *invationsLocal;
@property (nonatomic, retain) NSMutableDictionary *listContactCustom;
@property (nonatomic) BOOL editFlag;

- (IBAction)deleteCalendarEvent:(id)sender;

@end
