//
//  CalendarDetailViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-22.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGlossyButton.h"
#import "UIView+LayerEffects.h"
#import "Calendar.h"

@interface CalendarDetailViewController : UITableViewController<UIAlertViewDelegate> {
    UILabel *eventTitleLabel;
    UILabel *locationLabel;
    UILabel *startDateLabel;
    UILabel *endDateLabel;
    UITableViewCell *invationCell;
    UITableViewCell *alertCell;
    UILabel *customerNameLabel;
    UILabel *contractNum;
    UILabel *contractStartDateLabel;
    UILabel *contractEndDateLabel;
    UITableViewCell *typeCell;
    UITableViewCell *importCell;
    UITableViewCell *notesCell;
    UITableViewCell *buttonCell;
    UIButton *retMessageButton;
    Calendar *calendarObj;
    NSString *calenderId;
    UIGlossyButton *accpetButton;
    UIGlossyButton *rejectButton;
    NSString *frontFlag;
    UITableViewCell *senderCell;
    UITextView *contextTextView;
    int tabIndex;
    
    UITableViewCell *accpetCell;
    
    UITableViewCell *customerCell;
    UITableViewCell *privateCell;
}

@property (nonatomic, retain) IBOutlet UILabel *eventTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *startDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *endDateLabel;
@property (nonatomic, retain) IBOutlet UITableViewCell *invationCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *alertCell;
@property (nonatomic, retain) IBOutlet UILabel *customerNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *contractNum;
@property (nonatomic, retain) IBOutlet UILabel *contractStartDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *contractEndDateLabel;
@property (nonatomic, retain) IBOutlet UITableViewCell *typeCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *importCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *notesCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *buttonCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *senderCell;
@property (nonatomic, retain) IBOutlet UIButton *retMessageButton;
@property (nonatomic, retain) IBOutlet UITextView *contextTextView;
@property (nonatomic, retain) IBOutlet UIGlossyButton *accpetButton;
@property (nonatomic, retain) IBOutlet UIGlossyButton *rejectButton;
@property (nonatomic, retain) IBOutlet UITableViewCell *accpetCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *customerCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *privateCell;
@property (nonatomic, retain) NSString *calenderId;
@property (nonatomic, retain) Calendar *calendarObj;
@property (nonatomic, retain) NSString *frontFlag;
@property (nonatomic) int tabIndex;

- (IBAction)acceptEvent:(id) sender;
- (IBAction)rejectEvent:(id) sender;

@end
