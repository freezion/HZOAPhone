//
//  CalenderChooseViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalenderChooseViewController;

@protocol CalenderChooseDelegate <NSObject>
- (void)calenderChooseViewController:(CalenderChooseViewController *)controller didSelectCalendar:(NSDate *) startDate withEndDate:(NSDate *) endDate withAllDay:(BOOL) state;
@end

@interface CalenderChooseViewController : UITableViewController {
    UILabel *startLabel;
    UILabel *endLabel;
    UISwitch *allDaySwitch;
    UIDatePicker *datePicker;
    NSDate *startDate;
    NSDate *endDate;
    NSDateFormatter *dateFormatter;
    NSString *startDateStr;
    NSString *endDateStr;
    BOOL state;
    id<CalenderChooseDelegate> delegate;
}

@property (nonatomic, retain) id<CalenderChooseDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *startLabel;
@property (nonatomic, retain) IBOutlet UILabel *endLabel;
@property (nonatomic, retain) IBOutlet UISwitch *allDaySwitch;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property(nonatomic) BOOL state;
@property (nonatomic, retain) NSString *startDateStr;
@property (nonatomic, retain) NSString *endDateStr;

@end
