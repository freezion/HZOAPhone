//
//  CalendarDetailViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-22.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "CalendarDetailViewController.h"
#import "NewCalendarViewController.h"

@interface CalendarDetailViewController ()

@end

@implementation CalendarDetailViewController

@synthesize calendarObj;
@synthesize importCell;
@synthesize endDateLabel;
@synthesize locationLabel;
@synthesize contractNum;
@synthesize contractEndDateLabel;
@synthesize invationCell;
@synthesize startDateLabel;
@synthesize eventTitleLabel;
@synthesize contractStartDateLabel;
@synthesize alertCell;
@synthesize typeCell;
@synthesize buttonCell;
@synthesize customerNameLabel;
@synthesize notesCell;
@synthesize retMessageButton;
@synthesize calenderId;
@synthesize frontFlag;
@synthesize accpetButton;
@synthesize senderCell;
@synthesize contextTextView;
@synthesize tabIndex;
@synthesize accpetCell;
@synthesize rejectButton;
@synthesize customerCell;
@synthesize privateCell;

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
    self.title = @"日程内容";
    [self initDetail];
}

- (void)initDetail {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    calendarObj = [Calendar getSingleCanlendar:calenderId];
    [retMessageButton setBackgroundImage:[UIImage imageNamed:@"mails.png"] forState:UIControlStateNormal];
    if ([calendarObj.senderId isEqualToString:[usernamepasswordKVPairs objectForKey:KEY_USERID]]) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        // Since the buttons can be any width we use a thin image with a stretchable center point
        UIImage *buttonImage = [[UIImage imageNamed:@"update"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        UIImage *buttonPressedImage = [[UIImage imageNamed:@"update1"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
        CGRect buttonFrame = [button frame];
        buttonFrame.size.width = buttonImage.size.width;
        buttonFrame.size.height = buttonImage.size.height;
        [button setFrame:buttonFrame];
        [button addTarget:self action:@selector(editClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = buttonBar;
        if ([calendarObj.message isEqualToString:@""]) {
            [retMessageButton setBackgroundImage:[UIImage imageNamed:@"mails.png"] forState:UIControlStateNormal];
        } else {
            [retMessageButton setBackgroundImage:[UIImage imageNamed:@"mail_add.png"] forState:UIControlStateNormal];
        }
    }
    if ([frontFlag isEqualToString:@""] || frontFlag == nil) {        
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithBarButtonSystemItem:
                                                 UIBarButtonSystemItemCancel target:self
                                                 action:@selector(cancelClick:)];
    }
    eventTitleLabel.text = calendarObj.Title;
    locationLabel.text = calendarObj.Location;
    startDateLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.StartTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"yyyy年M月d日 HH:mm"];
    endDateLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.EndTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"yyyy年M月d日 HH:mm"];
    invationCell.detailTextLabel.text = calendarObj.Employee_Name;
    senderCell.detailTextLabel.text = calendarObj.senderName;
    //NSLog(@"%@", calendarObj.Reminder);
    if ([calendarObj.Reminder isEqualToString:@""] || calendarObj.Reminder == nil)
        alertCell.detailTextLabel.text = @"无";
    else {
        NSString *reminder = @"";
        if ([calendarObj.Reminder isEqualToString:@"900"]) {
            reminder = @"15 分钟前";
        } else if ([calendarObj.Reminder isEqualToString:@"1800"]) {
            reminder = @"30 分钟前";
        } else if ([calendarObj.Reminder isEqualToString:@"2700"]) {
            reminder = @"45 分钟前";
        } else if ([calendarObj.Reminder isEqualToString:@"3600"]) {
            reminder = @"1 小时前";
        }
        alertCell.detailTextLabel.text = reminder;
    }
    customerNameLabel.text = calendarObj.ClientName;
    contractNum.text = calendarObj.ProjectNum;
    if ([calendarObj.ProjectStartTime isEqualToString:@"0001-01-01 00:00:00"]) {
        contractStartDateLabel.text = @"";
    } else {
        contractStartDateLabel.text = calendarObj.ProjectStartTime;
    }
    if ([calendarObj.ProjectEndTime isEqualToString:@"0001-01-01 00:00:00"]) {
        contractEndDateLabel.text = @"";
    } else {
        contractEndDateLabel.text = calendarObj.ProjectEndTime;
    }
    typeCell.detailTextLabel.text = calendarObj.TypeName;
    if ([calendarObj.import isEqualToString:@"0"]) {
        importCell.detailTextLabel.text = @"普通";
        [importCell.detailTextLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
        privateCell.detailTextLabel.text = @"否";
        [privateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
    } else if ([calendarObj.import isEqualToString:@"1"]) {
        importCell.detailTextLabel.text = @"紧急";
        [importCell.detailTextLabel setTextColor:[UIColor redColor]];
        privateCell.detailTextLabel.text = @"否";
        [privateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
    } else if ([calendarObj.import isEqualToString:@"2"]) {
        privateCell.detailTextLabel.text = @"是";
        [privateCell.detailTextLabel setTextColor:[UIColor redColor]];
        importCell.detailTextLabel.text = @"普通";
        [importCell.detailTextLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
    } else {
        privateCell.detailTextLabel.text = @"是";
        [privateCell.detailTextLabel setTextColor:[UIColor redColor]];
        importCell.detailTextLabel.text = @"紧急";
        [importCell.detailTextLabel setTextColor:[UIColor redColor]];
    }
    if ([calendarObj.Note isEqualToString:@""] || calendarObj.Note == nil) {
        notesCell.detailTextLabel.text = @"";
    } else {
        notesCell.detailTextLabel.text = calendarObj.Note;
    }
    contextTextView.text = calendarObj.Note;
    
    if (tabIndex == 2) {
        [accpetButton useWhiteLabel: YES]; 
        accpetButton.tintColor = [UIColor darkGrayColor];
        [accpetButton setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
        accpetButton.hidden = NO;
        
        [rejectButton useWhiteLabel: YES];
        rejectButton.tintColor = [UIColor redColor];
        [rejectButton setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
        rejectButton.hidden = NO;

    } else {
        accpetButton.hidden = YES;
        rejectButton.hidden = YES;
        accpetCell.hidden = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)editClicked {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    NewCalendarViewController *newCalendarViewController = [storyborad instantiateViewControllerWithIdentifier:@"NewCalendarViewController"];
    newCalendarViewController.editFlag = YES;
    newCalendarViewController.calendarObj = calendarObj;
    UINavigationController *navBar = [[UINavigationController alloc]initWithRootViewController:newCalendarViewController];
    [self presentModalViewController:navBar animated:YES];
    
}

- (IBAction)acceptEvent:(id) sender {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    [Calendar accpetEvent:calendarObj.ID withEmployeeID:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已接受" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alertView show];
    //accpetButton.hidden = YES;
    
    
}

- (IBAction)rejectEvent:(id) sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定拒绝该安排吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
        NSString *employeeId = [usernamepasswordKVPairs objectForKey:KEY_USERID];
        [Calendar rejectEvent:calendarObj.ID withEmployeeID:employeeId];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
