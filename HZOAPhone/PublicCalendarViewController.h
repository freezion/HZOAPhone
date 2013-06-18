//
//  PublicCalendarViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 13-3-12.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calendar.h"

@interface PublicCalendarViewController : UITableViewController {
    NSString *calenderId;
    Calendar *calendarObj;
    UILabel *eventTitleLabel;
    UILabel *startDateLabel;
    UILabel *endDateLabel;
    UITextView *contextTextView;
    UITableViewCell *creatorCell;
}

@property (nonatomic, retain) NSString *calenderId;
@property (nonatomic, retain) Calendar *calendarObj;

@property (nonatomic, retain) IBOutlet UILabel *eventTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *startDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *endDateLabel;
@property (nonatomic, retain) IBOutlet UITextView *contextTextView;
@property (nonatomic, retain) IBOutlet UITableViewCell *creatorCell;

@end
