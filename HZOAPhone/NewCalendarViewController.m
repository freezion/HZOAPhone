//
//  NewCalendarViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-18.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "NewCalendarViewController.h"
#import "CalenderChooseViewController.h"

@interface NewCalendarViewController ()

@end

@implementation NewCalendarViewController

@synthesize startLabel;
@synthesize switchImport;
@synthesize txtNotes;
@synthesize txtTitle;
@synthesize contractIdLabel;
@synthesize alertLabel;
@synthesize txtLocation;
@synthesize contractEndLabel;
@synthesize customerNameLabel;
@synthesize typeLabel;
@synthesize endLabel;
@synthesize invitionLabel;
@synthesize contractStartLabel;
@synthesize stateAllDay;
@synthesize tokenList;
@synthesize reminder;
@synthesize selectIndexSave;
@synthesize selectIndexCustomer;
@synthesize selectIndexContract;
@synthesize contractIdLocal;
@synthesize customerIdLocal;
@synthesize selectIndexType;
@synthesize selectIndexType1;
@synthesize eventTypeId;
@synthesize keyboardToolbar;
@synthesize calendarObj;
@synthesize invationsLocal;
@synthesize editFlag;
@synthesize listContactCustom;
@synthesize customerCell;
@synthesize switchPrivate;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if (editFlag) {
        self.title = @"修改日程";
    } else {
        self.title = @"新增安排";
    }
    [self newInitEvent];
}

- (void)viewWillAppear:(BOOL)animated {

    CGPoint offset = self.tableView.contentOffset;
    CGRect bounds = self.tableView.bounds;
    UIEdgeInsets inset = self.tableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = y - keyboardHeight - 40;
    self.keyboardToolbar.frame = frame;
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void) newInitEvent {
    
    usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    listContactCustom = [[NSMutableDictionary alloc] init];
    NSString *canRead = [usernamepasswordKVPairs objectForKey:KEY_READ_CONTRACT];
    if ([@"0" isEqualToString:canRead]) {
        customerCell.hidden = YES;
    }
    
    if (editFlag) {
        txtTitle.text = calendarObj.Title;
        txtLocation.text = calendarObj.Location;
        startLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.StartTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"yyyy年M月d日 HH:mm"];
        endLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.EndTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"yyyy年M月d日 HH:mm"];
        
        NSString *invationIds = calendarObj.Employee_Id;
        NSArray *idList = [invationIds componentsSeparatedByString:@","];
        NSString *invationNames = calendarObj.CustomerName;
        //NSLog(@"invationNames === %@", invationNames);
        NSArray *nameList = [invationNames componentsSeparatedByString:@","];
        tokenList = [[NSMutableArray alloc] initWithCapacity:20];
        //NSLog(@"count === %d", [nameList count]);
        for (int i = 0; i < [nameList count]; i ++) {
            [tokenList addObject:[nameList objectAtIndex:i]];
            [listContactCustom setObject:[idList objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d", i]];
        }
        if ([invationNames isEqualToString:@""]) {
            invitionLabel.text = @"无";
        } else {
            invitionLabel.text = [NSString stringWithFormat:@"%d", [nameList count]];
        }
        if ([calendarObj.Reminder isEqualToString:@""] || calendarObj.Reminder == nil) {
            alertLabel.text = @"无";
            selectIndexSave = 0;
        } else {
            if ([calendarObj.Reminder isEqualToString:@"900"]) {
                alertLabel.text = @"15 分钟前";
                selectIndexSave = 1;
            } else if ([calendarObj.Reminder isEqualToString:@"1800"]) {
                alertLabel.text = @"30 分钟前";
                selectIndexSave = 2;
            } else if ([calendarObj.Reminder isEqualToString:@"2700"]) {
                alertLabel.text = @"45 分钟前";
                selectIndexSave = 3;
            } else if ([calendarObj.Reminder isEqualToString:@"3600"]) {
                alertLabel.text = @"1 小时前";
                selectIndexSave = 4;
            }
        }
        contractIdLabel.text = calendarObj.ProjectNum;
        customerNameLabel.text = calendarObj.ClientName;
        if ([calendarObj.ProjectStartTime isEqualToString:@"0001-01-01 00:00:00"]) {
            contractStartLabel.text = @"";
        } else {
            contractStartLabel.text = calendarObj.ProjectStartTime;
        }
        if ([calendarObj.ProjectEndTime isEqualToString:@"0001-01-01 00:00:00"]) {
            contractEndLabel.text = @"";
        } else {
            contractEndLabel.text = calendarObj.ProjectEndTime;
        }
        typeLabel.text = calendarObj.TypeName;
        if ([calendarObj.import isEqualToString:@"0"]) {
            [switchImport setOn:NO];
            [switchPrivate setOn:NO];
        }
        else if ([calendarObj.import isEqualToString:@"1"]) {
            [switchImport setOn:YES];
            [switchPrivate setOn:NO];
        }
        else if ([calendarObj.import isEqualToString:@"2"]) {
            [switchImport setOn:NO];
            [switchPrivate setOn:YES];
        } else {
            [switchImport setOn:YES];
            [switchPrivate setOn:YES];
        }
        txtNotes.text = calendarObj.Note;
        
        if ([calendarObj.AllDay isEqualToString:@"0"]) {
            stateAllDay = NO;
        } else {
            stateAllDay = YES;
        }
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年M月d日 H:00"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        
        startDateT = [NSDate dateWithTimeIntervalSinceNow: 60 * 60];
        NSString *oneHourAfter = [dateFormatter stringFromDate:startDateT];
        startLabel.text = oneHourAfter;
        
        endDateT = [NSDate dateWithTimeIntervalSinceNow: 60 * 120];
        NSString *twoHourAfter = [dateFormatter stringFromDate:endDateT];
        endLabel.text = twoHourAfter;
        selectIndexType = 0;
    }
    
    
    self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 84, 320, 40)];
    keyboardToolbar.tag = 10;
    keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *cancelButton = [self setupLeftBar];
    UIBarButtonItem *doneButton = [self setupRightBar];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:cancelButton, spacer, doneButton, nil]];
    [self.view addSubview:keyboardToolbar];
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CheckCalendar"])
	{
		CalenderChooseViewController *calenderChooseViewController = segue.destinationViewController;
		calenderChooseViewController.delegate = self;
        calenderChooseViewController.startDateStr = startLabel.text;
        calenderChooseViewController.endDateStr = endLabel.text;
        calenderChooseViewController.state = stateAllDay;
	} else if ([segue.identifier isEqualToString:@"PickContact"]) {
        InvitEmployeeViewController *invitEmployeeViewController = segue.destinationViewController;
        invitEmployeeViewController.delegate = self;
        invitEmployeeViewController.tokens = tokenList;
        invitEmployeeViewController.listContactId = listContactCustom;
    } else if ([segue.identifier isEqualToString:@"AlertPicker"]) {
        EventAlertViewController *eventAlertViewController = segue.destinationViewController;
        eventAlertViewController.delegate = self;
        eventAlertViewController.selectedIndex = selectIndexSave;
    } else if ([segue.identifier isEqualToString:@"CustomerPick"]) {
        ChooseCustomerViewController *chooseCustomerViewController = segue.destinationViewController;
        chooseCustomerViewController.delegate = self;
        chooseCustomerViewController.customerSelectedIndex = selectIndexCustomer;
        chooseCustomerViewController.contractSelectedIndex = selectIndexContract;
    } else if ([segue.identifier isEqualToString:@"CalendarType"]) {
        ChooseTypeViewController *chooseTypeViewController = segue.destinationViewController;
        chooseTypeViewController.delegate = self;
        chooseTypeViewController.selectedIndex = selectIndexType1;
        //NSLog(@"%d",selectIndexType);
    }
    
}

- (void)doneClicked {    
    
    calendarObj = [[Calendar alloc] init ];
    calendarObj.ID = @"";
    calendarObj.Title = txtTitle.text;
    calendarObj.Location = txtLocation.text;
    calendarObj.Note = txtNotes.text;
    calendarObj.ClientName=customerNameLabel.text;
    if (reminder == nil) {
        calendarObj.Reminder = @"0";
    } else {
        calendarObj.Reminder = reminder;
    }
    if (stateAllDay) {
        calendarObj.AllDay = @"1";
        calendarObj.StartTime = [NSUtil parserStringToCustomString:startLabel.text withParten:@"yyyy年M月d日 HH:mm:ss"];
        calendarObj.EndTime = [NSUtil parserStringToCustomString:endLabel.text withParten:@"yyyy年M月d日 HH:mm:ss"];
    } else {
        calendarObj.AllDay = @"0";
        calendarObj.StartTime = [NSUtil parserStringToCustomString:startLabel.text withParten:@"yyyy年M月d日 HH:mm"];
        calendarObj.EndTime = [NSUtil parserStringToCustomString:endLabel.text withParten:@"yyyy年M月d日 HH:mm"];
    }
    if (eventTypeId == nil) {
        calendarObj.Type =@"";
    } else {
        calendarObj.Type = eventTypeId;
    }
    if (invationsLocal == nil) {
        calendarObj.Employee_Id = @"";
    } else {
        calendarObj.Employee_Id = invationsLocal;
    }
    
    calendarObj.Readed = [usernamepasswordKVPairs objectForKey:KEY_USERID];
    if ([switchImport isOn]) {
        if ([switchPrivate isOn]) {
            calendarObj.import = @"3";
            calendarObj.Employee_Id = @"";
        } else {
            calendarObj.import = @"1";
        }
    } else {
        if ([switchPrivate isOn]) {
            calendarObj.import = @"2";
            calendarObj.Employee_Id = @"";
        } else {
            calendarObj.import = @"0";
        }
    }
    NSLog(@"%@", calendarObj.import);
    calendarObj.senderId = [usernamepasswordKVPairs objectForKey:KEY_USERID];
    if (customerIdLocal) {
        calendarObj.CustomerId = customerIdLocal;
    } else {
        calendarObj.CustomerId = @"0";
    }
    if (contractIdLocal) {
        calendarObj.ProjectId = contractIdLocal;
    } else {
        calendarObj.ProjectId = @"0";
    }
    if ([self checkCalendar]) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        [HUD setDelegate:self];
        [HUD setLabelText:@"提交数据..."];
        [HUD showWhileExecuting:@selector(doSend:) onTarget:self withObject:nil animated:YES];
    }
}

- (BOOL) checkCalendar {
    BOOL flag = YES;
    if ([txtTitle.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];       
        flag = NO;
    }
    if ([txtNotes.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        flag = NO;
    }
    return flag;
}

- (void)updateClicked {
    calendarObj.Title = txtTitle.text;
    calendarObj.Location = txtLocation.text;
    calendarObj.Note = txtNotes.text;
    calendarObj.ClientName=customerNameLabel.text;
    if (reminder == nil) {
        calendarObj.Reminder = @"0";
    } else {
        calendarObj.Reminder = reminder;
    }
    if (stateAllDay) {
        calendarObj.AllDay = @"1";
        calendarObj.StartTime = startLabel.text;
        calendarObj.EndTime = endLabel.text;
    } else {
        calendarObj.AllDay = @"0";
        calendarObj.StartTime = [NSUtil parserStringToCustomString:startLabel.text withParten:@"yyyy年M月d日 HH:mm"];
        calendarObj.EndTime = [NSUtil parserStringToCustomString:endLabel.text withParten:@"yyyy年M月d日 HH:mm"];
    }
    if (eventTypeId) {
        calendarObj.Type = eventTypeId;
    } else {
        calendarObj.Type = @"1";
    }
    if (invationsLocal == nil) {
        calendarObj.Employee_Id = @"";
    } else {
        calendarObj.Employee_Id = invationsLocal;
    }
    
    calendarObj.Readed = [usernamepasswordKVPairs objectForKey:KEY_USERID];
    if ([switchImport isOn]) {
        if ([switchPrivate isOn]) {
            calendarObj.import = @"3";
            calendarObj.Employee_Id = @"";
        } else {
            calendarObj.import = @"1";
        }
    } else {
        if ([switchPrivate isOn]) {
            calendarObj.import = @"2";
            calendarObj.Employee_Id = @"";
        } else {
            calendarObj.import = @"0";
        }
    }
    calendarObj.senderId = [usernamepasswordKVPairs objectForKey:KEY_USERID];
    if (customerIdLocal) {
        calendarObj.CustomerId = customerIdLocal;
    } else {
        calendarObj.CustomerId = @"0";
    }
    if (contractIdLocal) {
        calendarObj.ProjectId = contractIdLocal;
    } else {
        calendarObj.ProjectId = @"0";
    }
    calendarObj.ProjectNum = contractIdLabel.text;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"提交数据..."];
    [HUD showWhileExecuting:@selector(doEdit:) onTarget:self withObject:nil animated:YES];
}

- (void) doEdit: (id) sender {
    [Calendar updateCalendar:calendarObj];
    
    UIAlertView *alertEdit = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改完毕" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alertEdit show];
}

- (void)saveCancel:(id) sender {
    if (editFlag) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
        [menuController showRightController:YES];
    }
}

- (void) doSend: (id) sender {
    [Calendar addCalendar:calendarObj withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID] withEventStoreId:nil];
    
    alertAdd = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加完毕" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alertAdd show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    self.keyboardToolbar.frame = CGRectMake(0, y - keyboardHeight - 40, 320, 40);
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

- (void)keyboardWillShow:(NSNotification *)notification {
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
    [UIView beginAnimations:@"MoveIn" context:nil];
    [UIView setAnimationDuration:0.25];
    CGPoint offset = self.tableView.contentOffset;
    CGRect bounds = self.tableView.bounds;
    UIEdgeInsets inset = self.tableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = y - keyboardHeight - 40;
    self.keyboardToolbar.frame = frame;

    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	keyboardHeight = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    CGPoint offset = self.tableView.contentOffset;
    CGRect bounds = self.tableView.bounds;
    UIEdgeInsets inset = self.tableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = y - keyboardHeight - 40;
    self.keyboardToolbar.frame = frame;
    
    [UIView commitAnimations];
}

- (UIBarButtonItem *) setupLeftBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Since the buttons can be any width we use a thin image with a stretchable center point
    UIImage *buttonImage = [[UIImage imageNamed:@"cancel.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"cancel2.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(saveCancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    return buttonBar;
}

- (UIBarButtonItem *) setupRightBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Since the buttons can be any width we use a thin image with a stretchable center point
    UIImage *buttonImage = [[UIImage imageNamed:@"send_paper.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"send2.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    if (editFlag) {
        [button addTarget:self action:@selector(updateClicked) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [button addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    return buttonBar;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 8;
}

#pragma mark - CalenderChooseDelegate
- (void)calenderChooseViewController:(CalenderChooseViewController *)controller didSelectCalendar:(NSDate *) startDate withEndDate:(NSDate *) endDate withAllDay:(BOOL) state {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (state) {
        [dateFormatter setDateFormat:@"yyyy年M月d日 HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        
        NSString *oneHourAfter = [dateFormatter stringFromDate:startDate];
        startLabel.text = oneHourAfter;
        
        NSString *twoHourAfter = [dateFormatter stringFromDate:endDate];
        endLabel.text = twoHourAfter;
        stateAllDay = YES;
    } else {
        [dateFormatter setDateFormat:@"yyyy年M月d日 HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        
        NSString *oneHourAfter = [dateFormatter stringFromDate:startDate];
        startLabel.text = oneHourAfter;
        
        NSString *twoHourAfter = [dateFormatter stringFromDate:endDate];
        endLabel.text = twoHourAfter;
        stateAllDay = NO;
    }  
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SelectContactControllerDelegate
- (void)invitEmployeeViewController:(InvitEmployeeViewController *)controller didSelectContact:(int) count withTokens:(NSArray *) tokens withInvations:(NSString *) invations withListContactId:(NSMutableDictionary *) listContactId {
    NSArray *invationNames = [invations componentsSeparatedByString:@","];
    tokenList = [[NSMutableArray alloc] initWithCapacity:20];
    
    for (int i = 0; i < [invationNames count]; i ++) {
        [tokenList addObject:[invationNames objectAtIndex:i]];
    }

    NSString *value = @"";
    int i = 0;
    for (NSString *key in listContactId) {
        NSString *obj = [listContactId objectForKey:key];
        value = [value stringByAppendingFormat:@"%@", obj];
        if (i != [listContactId count] - 1) {
            value = [value stringByAppendingString:@","];
        }
        
        i ++;
    }
    invationsLocal = value;
    listContactCustom = listContactId;
    if ([tokens count] > 0) {
        self.invitionLabel.text = [NSString stringWithFormat:@"%d", [tokens count]];
    } else {
        self.invitionLabel.text = @"无";
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - EventAlertViewController
- (void)eventAlertViewController:(EventAlertViewController *)controller didSelectAlert:(NSString *) timer withSelectIndex:(int)selectedIndex withLabelTitle:(NSString *) title {
    selectIndexSave = selectedIndex;
    if (selectedIndex != 0) {
        alertLabel.text = title;
        if (selectedIndex == 0) {
            reminder = @"";
        } else if (selectedIndex == 1) {
            reminder = @"900";
        } else if (selectedIndex == 2) {
            reminder = @"1800";
        } else if (selectedIndex == 3) {
            reminder = @"2700";
        } else if (selectedIndex == 4) {
            reminder = @"3600";
        } else {
            reminder = @"";
        }
    } else {
        alertLabel.text = @"无";
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ChooseCustomerDelegate
- (void)chooseCustomerViewController:(ChooseCustomerViewController *)controller didSelectContract:(NSString *) contractId withSelectIndex:(int) selectedIndex withCustomerSelectIndex:(int) customerSelectIndex withLabelTitle:(NSString *) title withStartDate:(NSString *) startDate withEndDate:(NSString *) endDate withCustomerId:(NSString *) customerId withCustomerName:(NSString *) customerName {
    selectIndexCustomer = customerSelectIndex;
    selectIndexContract = selectedIndex;
    customerIdLocal = customerId;
    //contractIdLocal = contractId;
    contractIdLocal = title;
    if ([customerName isEqualToString:@""] || customerName == nil) {
        customerNameLabel.text = @"无";
    } else {
        customerNameLabel.text = customerName;
    }
    if ([title isEqualToString:@""] || title == nil) {
        contractIdLabel.text = @"无";
    } else {
        contractIdLabel.text = title;
    }
    if ([startDate isEqualToString:@""] || startDate == nil) {
        contractStartLabel.text = @"无";
    } else {
        contractStartLabel.text = startDate;
    }
    if ([endDate isEqualToString:@""] || endDate == nil) {
        contractEndLabel.text = @"无";
    } else {
        contractEndLabel.text = endDate;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - EventTypeViewDelegate
- (void)chooseTypeViewController:(ChooseTypeViewController *)controller didSelectType:(NSString *) typeId withSelectIndex:(int) selectedIndex withLabelTitle:(NSString *) title {
    selectIndexType1 = selectedIndex;
    //NSLog(@"%d",selectedIndex);
    eventTypeId = typeId;
    typeLabel.text = title;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
