//
//  CalenderChooseViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "CalenderChooseViewController.h"

@interface CalenderChooseViewController ()

@end

@implementation CalenderChooseViewController

@synthesize startDate;
@synthesize endLabel;
@synthesize state;
@synthesize startDateStr;
@synthesize endDate;
@synthesize endDateStr;
@synthesize startLabel;
@synthesize dateFormatter;
@synthesize allDaySwitch;
@synthesize delegate;

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
    self.title = @"开始与结束";
    [self initCalendarChoose];
}

- (void) initCalendarChoose {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Since the buttons can be any width we use a thin image with a stretchable center point
    UIImage *buttonImage = [[UIImage imageNamed:@"finish"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"finish2"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = buttonBar;
    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    if (state) {
        [dateFormatter setDateFormat:@"yyyy年M月d日 HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        allDaySwitch.on = YES;
    } else {
        [dateFormatter setDateFormat:@"yyyy年M月d日 HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        allDaySwitch.on = NO;
    }
    
    startDate = [dateFormatter dateFromString:startDateStr];
    endDate = [dateFormatter dateFromString:endDateStr];
    
    startLabel.text = startDateStr;
    endLabel.text = endDateStr;
    
    datePicker = [[UIDatePicker alloc] init];
    CGRect datePickerFrame = [datePicker frame];
    datePickerFrame.origin.y = self.view.frame.size.height - datePickerFrame.size.height - 40;
    [datePicker setFrame:datePickerFrame];
    
    if (state) {
        datePicker.datePickerMode = UIDatePickerModeDate;
    } else {
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    
    datePicker.minuteInterval = 5;
    [datePicker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
    [datePicker setDate:startDate];
    [self.view addSubview:datePicker];
    
    [self.allDaySwitch addTarget:self action:@selector(setStateAllDay:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) validateDate {
    BOOL flag = NO;
    dateFormatter = [[NSDateFormatter alloc] init];
    if (state) {
        [dateFormatter setDateFormat:@"yyyy年M月d日"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    } else {
        [dateFormatter setDateFormat:@"yyyy年M月d日 HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    }
    
    //startDate = [dateFormatter dateFromString:startLabel.text];
    //endDate = [dateFormatter dateFromString:endLabel.text];
    
    if ([endDate compare:startDate] == NSOrderedAscending) {
        return flag;
    } else {
        flag = YES;
    }
    
    return flag;
}

- (void)setStateAllDay:(id) sender {
    state = [sender isOn];
    if (state) {
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        startLabel.text = [NSUtil parserDateToCustomString:startDate withParten:@"yyyy年M月d日"];
        endLabel.text = [NSUtil parserDateToCustomString:endDate withParten:@"yyyy年M月d日"];
        startDate = [NSUtil parserStringToAppendDate:startLabel.text withParten:@" 00:00"];
        endDate = [NSUtil parserStringToAppendDate:endLabel.text withParten:@" 23:59"];
        if (![self validateDate]) {
            [startLabel setTextColor:[UIColor redColor]];
            [endLabel setTextColor:[UIColor redColor]];
        }
    } else {
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        //startDate = [NSUtil parserStringToCustomDate:startDateStr withParten:@"yyyy年M月d日 H:mm"];
        //endDate = [NSUtil parserStringToCustomDate:endDateStr withParten:@"yyyy年M月d日 H:mm"];
        if (startDate == nil) {
            startDate = [NSUtil parserStringToCustomDate:startDateStr withParten:@"yyyy年M月d日 00:00"];
            startDateStr = [NSUtil parserStringToCustomStringAdv:startDateStr withParten:@"yyyy年M月d日" withToParten:@"yyyy年M月d日 00:00"];
        }
        if (endDate == nil) {
            endDate = [NSUtil parserStringToCustomDate:endDateStr withParten:@"yyyy年M月d日 23:59"];
            endDateStr = [NSUtil parserStringToCustomStringAdv:endDateStr withParten:@"yyyy年M月d日" withToParten:@"yyyy年M月d日 23:59"];
        }
        startLabel.text = startDateStr; 
        endLabel.text = endDateStr;
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.minuteInterval = 5;
        [datePicker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
        [datePicker setDate:startDate];
        
        if (![self validateDate]) {
            [startLabel setTextColor:[UIColor redColor]];
            [endLabel setTextColor:[UIColor redColor]];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [datePicker setDate:startDate];
    } else if (indexPath.row == 1) {
        [datePicker setDate:endDate];
    }
}

- (void)backAction:(id) sender {
    if ([self validateDate]) {        
        [self.delegate calenderChooseViewController:self didSelectCalendar:startDate withEndDate:endDate withAllDay:state];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法储存事件" message:@"开始日期必须早与结束日期。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)dateDidChange:(UIDatePicker *) sender {
    int row = [self.tableView indexPathForSelectedRow].row;
    if (row == 0) {
        startDate = sender.date;
    } else {
        endDate = sender.date;
    }
    if (state) {
        if (row == 0) {
            startLabel.text = [NSUtil parserDateToCustomString:startDate withParten:@"yyyy年M月d日"];
            startDate = [NSUtil parserStringToAppendDate:startLabel.text withParten:@" 00:00"];
        } else {
            endLabel.text = [NSUtil parserDateToCustomString:endDate withParten:@"yyyy年M月d日"];
            endDate = [NSUtil parserStringToAppendDate:endLabel.text withParten:@" 23:59"];
            
        }
        if (![self validateDate]) {
            [startLabel setTextColor:[UIColor redColor]];
            [endLabel setTextColor:[UIColor redColor]];
        }
    } else {
        if (row == 0) {
            startLabel.text = [NSUtil parserDateToCustomString:startDate withParten:@"yyyy年M月d日 HH:mm"];
            endDate = [NSDate dateWithTimeInterval:60 * 60 sinceDate:startDate];
            endLabel.text = [NSUtil parserDateToCustomString:endDate withParten:@"yyyy年M月d日 HH:mm"];
        } else {
            endLabel.text = [NSUtil parserDateToCustomString:endDate withParten:@"yyyy年M月d日 HH:mm"];
        }
        
        if (![self validateDate]) {
            [startLabel setTextColor:[UIColor redColor]];
            [endLabel setTextColor:[UIColor redColor]];
        }
    }
}

@end
