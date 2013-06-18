//
//  PublicCalendarViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 13-3-12.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import "PublicCalendarViewController.h"
#import "Calendar.h"

@interface PublicCalendarViewController ()

@end

@implementation PublicCalendarViewController

@synthesize calenderId;
@synthesize calendarObj;
@synthesize startDateLabel;
@synthesize endDateLabel;
@synthesize contextTextView;
@synthesize eventTitleLabel;
@synthesize creatorCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"公共日程";
    [self initPublicCalendar];
}

- (void) initPublicCalendar {
    calendarObj = [Calendar getSinglePublicCalendar:calenderId];
    
    self.eventTitleLabel.text = calendarObj.Title;
    self.startDateLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.StartTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"yyyy年M月d日 HH:mm"];
    self.endDateLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.EndTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"yyyy年M月d日 HH:mm"];
    self.contextTextView.text = calendarObj.Note;
    self.creatorCell.detailTextLabel.text = calendarObj.senderName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
