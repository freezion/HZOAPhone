//
//  MainViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-15.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "Calendar.h"
#import "CalendarCell.h"
#import "Reachability.h"
#import "CalendarDetailViewController.h"
#import "Customer.h"
#import "SystemConfig.h"
#import "PublicCalendarViewController.h"

NSString *currentDateStr;
NSDate *currentDate;
NSString *show = @"当前日期: ";
NSString *eventStoreId = @"";
int indexOfTab = 0;

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize tableViewCustom;
@synthesize tabBarCustom;
@synthesize eventsList;
@synthesize items;
@synthesize defaultCalendar;
@synthesize eventStore;
@synthesize myCalendarType;
@synthesize refreshFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    eventsList = [[NSMutableArray alloc] initWithCapacity:10];
    [self setTitle:@"日程安排"];
    [tabBarCustom setSelectedItem:[tabBarCustom.items objectAtIndex:0]];
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableViewCustom.bounds.size.height, self.view.frame.size.width, self.tableViewCustom.bounds.size.height)];
		view.delegate = self;
		[self.tableViewCustom addSubview:view];
		_refreshHeaderView = view;
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    self.eventStore = [[EKEventStore alloc] init];
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知错误" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else if (!granted)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有授权！请允许访问iCal" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
                }
            });
        }];
    }
    else
    {
        self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //NSLog(@"%@", [NSUtil appNameAndVersionNumberDisplayString]);
    deviceType = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceType;
    deviceTokenNum = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceTokenNum;
    model = [[UIDevice currentDevice] model];
    
    if ([model isEqualToString:@"iPhone Simulator"]) {
        deviceTokenNum = @"2418a90de97c88f86c16093f12e903aaa0c00c08";
    }
    
    /* ---------------------------------------------------------
     * Create images that are used for the main button
     * -------------------------------------------------------*/
    UIImage *image = [UIImage imageNamed:@"red_plus_up.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"red_plus_down.png"];
    UIImage *toggledImage = [UIImage imageNamed:@"red_x_up.png"];
    UIImage *toggledSelectedImage = [UIImage imageNamed:@"red_x_down.png"];
    
    /* ---------------------------------------------------------
     * Create the center for the main button and origin of animations
     * -------------------------------------------------------*/
    CGPoint center = CGPointMake(self.view.frame.size.width - 22, self.view.frame.size.height - 135.0f);
    
    /* ---------------------------------------------------------
     * Setup buttons
     * Note: I am setting the frame to the size of my images
     * -------------------------------------------------------*/
    CGRect buttonFrame = CGRectMake(0, 0, 48.0f, 48.0f);
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b1 setFrame:buttonFrame];
    [b1 setImage:[UIImage imageNamed:@"con_icon_Sign.png"] forState:UIControlStateNormal];
    [b1 setImage:[UIImage imageNamed:@"con_icon_Sign_click.png"] forState:UIControlStateHighlighted];
    [b1 addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b2 setImage:[UIImage imageNamed:@"lightbulb.png"] forState:UIControlStateNormal];
    [b2 setFrame:buttonFrame];
    [b2 addTarget:self action:@selector(onAlert) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b3 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [b3 setFrame:buttonFrame];
    [b3 addTarget:self action:@selector(onModal) forControlEvents:UIControlEventTouchUpInside];
    NSArray *buttons = [NSArray arrayWithObjects:b1, nil];
    
    /* ---------------------------------------------------------
     * Init method, passing everything the bar needs to work
     * -------------------------------------------------------*/
    RNExpandingButtonBar *bar = [[RNExpandingButtonBar alloc] initWithImage:image selectedImage:selectedImage toggledImage:toggledImage toggledSelectedImage:toggledSelectedImage buttons:buttons center:center];
    //
    //    /* ---------------------------------------------------------
    //     * Settings
    //     * -------------------------------------------------------*/
    [bar setDelegate:self];
    [bar setSpin:YES];
    
    /* ---------------------------------------------------------
     * Set our property and add it to the view
     * -------------------------------------------------------*/
    [[self view] addSubview:bar];
}

//获得自己的当前的位置信息
- (void) getCurPosition
{
	//开始探测自己的位置
	if (locationManager == nil)
	{
		locationManager =[[CLLocationManager alloc] init];
	}
	
	if ([CLLocationManager locationServicesEnabled])
	{
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
		[locationManager startUpdatingLocation];
	}
}

//响应当前位置的更新，在这里记录最新的当前位置
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
			fromLocation:(CLLocation *)oldLocation
{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    if (oldLocation == nil) {
        CLGeocoder* geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:
            ^(NSArray *placemarks, NSError *error){
             for (CLPlacemark *placemark in placemarks) {
                 NSString *cityStr=[placemark.addressDictionary objectForKey:@"City"];
                 NSLog(@"city %@",cityStr);
                 NSString *Street=[placemark.addressDictionary objectForKey:@"Street"];
                 NSLog(@"Street %@",Street);
                 NSString *State=[placemark.addressDictionary objectForKey:@"State"];
                 NSLog(@"State %@",State);
                 //NSString *ZIP=[placemark.addressDictionary objectForKey:@"ZIP"];
                 //NSString *Country=[placemark.addressDictionary objectForKey:@"Country"];
                 //NSString *CountryCode=[placemark.addressDictionary objectForKey:@"CountryCode"];
                 
                 if (State == nil) {
                     location = @"";
                 } else {
                     location = State;
                     if (cityStr != nil) {
                         location = [location stringByAppendingString:cityStr];
                     }
                     if (Street != nil) {
                         location = [location stringByAppendingString:Street];
                     }
                 }
                 
                 NSString *activeFlag = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).activeFlag;
                 if ([@"1" isEqualToString:activeFlag]) {
                     Customer *customer = [[Customer alloc] init];
                     customer.LoginType = @"1";
                     customer.deviceType = model;
                     customer.deviceToken = [usernamepasswordKVPairs objectForKey:KEY_DEVICETOKEN];
                     customer.Location = location;
                     customer.EmpID = [usernamepasswordKVPairs objectForKey:KEY_USERID];
                     [Customer takeStatus:customer];
                     if (location != nil) {
                         [usernamepasswordKVPairs setObject:location forKey:KEY_PLACE];
                     }
                     ((AppDelegate *)[[UIApplication sharedApplication] delegate]).activeFlag = @"0";
                 }
                 NSLog(@"%@", [usernamepasswordKVPairs objectForKey:KEY_PLACE]);
                 break;
             }
         }];
    }
}

- (void)onNext {
    NSArray *eventArray = [self fetchEventsForToday:currentDate];
    NSError *error;
    for (EKEvent *event in eventArray) {
        [eventStore removeEvent:event span:EKSpanThisEvent error:&error];
    }
    
    for (Calendar *calendarObj in eventsList) {
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        event.calendar = defaultCalendar;
        event.title = calendarObj.Title;
        event.notes = calendarObj.Note;
        event.startDate = [NSUtil parserStringToDate:calendarObj.StartTime];
        event.endDate = [NSUtil parserStringToDate:calendarObj.EndTime];
        if (![calendarObj.Reminder isEqualToString:@""]) {
            float value = -[calendarObj.Reminder floatValue];
            NSMutableArray *alarmsArray = [[NSMutableArray alloc] init];
            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:value];
            [alarmsArray addObject:alarm];
            event.alarms = [NSArray arrayWithArray:alarmsArray];
        } else {
            event.alarms = nil;
        }
        event.location = calendarObj.Location;
        if ([calendarObj.AllDay isEqualToString:@"1"]) {
            event.allDay = YES;
        } else {
            event.allDay = NO;
        }
        [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
    }
    //lanuch ical
    NSURL *url = [NSURL URLWithString:@"calshow:"];
    [[UIApplication sharedApplication] openURL:url];
}

- (NSArray *)fetchEventsForToday:(NSDate *) startDate {
    NSTimeInterval  interval = 24 * 60 * 60 * 3;
    NSDate *endDate = [currentDate initWithTimeIntervalSinceNow:+interval];
    
	// Create the predicate. Pass it the default calendar.
	NSArray *calendarArray = [NSArray arrayWithObject:defaultCalendar];
    
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate
                                                                    calendars:calendarArray];
	
	// Fetch all events that match the predicate.
	NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
	return events;
}

- (void) myEventList {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    currentDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval  interval = 24 * 60 * 60 * 30;
    NSDate *threeDayAfter = [currentDate initWithTimeIntervalSinceNow:+interval];
    // Fetch today's event on selected calendar and put them into the eventsList array
    [self.eventsList removeAllObjects];
    self.eventsList = [Calendar getAllMyData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    [self.tableViewCustom reloadData];
}

- (void) mySendList {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    currentDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval  interval = 24 * 60 * 60 * 30;
    NSDate *threeDayAfter = [currentDate initWithTimeIntervalSinceNow:+interval];
    // Fetch today's event on selected calendar and put them into the eventsList array
    [self.eventsList removeAllObjects];
    self.eventsList = [Calendar allMySendData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    
    [self.tableViewCustom reloadData];
}

- (void) myInvationList {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    currentDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval  interval = 24 * 60 * 60 * 30;
    NSDate *threeDayAfter = [currentDate initWithTimeIntervalSinceNow:+interval];
    // Fetch today's event on selected calendar and put them into the eventsList array
    [self.eventsList removeAllObjects];
    self.eventsList = [Calendar allInvitedMeData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    [self.tableViewCustom reloadData];
}

- (void) publicEventList {
    //NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    currentDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval  interval = 24 * 60 * 60 * 30;
    NSDate *threeDayAfter = [currentDate initWithTimeIntervalSinceNow:+interval];
    // Fetch today's event on selected calendar and put them into the eventsList array
    [self.eventsList removeAllObjects];
    self.eventsList = [Calendar publicEventDate:currentDate withEndDate:threeDayAfter];
    [self.tableViewCustom reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable: {
            // 没有网络连接
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到没有网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            break;
    }
}

-(void) goAppStore {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/hua-zhong-zi-xun/id575478439?mt=8"]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    } else {
        [self goAppStore];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    if (usernamepasswordKVPairs == nil) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
        LoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentModalViewController:loginViewController animated:NO];
    } else {
        [self getCurPosition];
//        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//        double ver = [version doubleValue];
//        NSString *currVersion = [SystemConfig getVersion];
//        if (ver < [currVersion doubleValue]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发现新版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
        if (refreshFlag == nil) {
            
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.dimBackground = YES;
            [HUD setDelegate:self];
            [HUD setLabelText:@"数据加载..."];
            if (indexOfTab == 0) {
                [HUD showWhileExecuting:@selector(myEventList) onTarget:self withObject:nil animated:YES];
            } else if (indexOfTab == 1) {
                [HUD showWhileExecuting:@selector(mySendList) onTarget:self withObject:nil animated:YES];
            } else if (indexOfTab == 2) {
                [HUD showWhileExecuting:@selector(myInvationList) onTarget:self withObject:nil animated:YES];
            } else if (indexOfTab == 3) {
                [HUD showWhileExecuting:@selector(publicEventList) onTarget:self withObject:nil animated:YES];
            }
        }
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    
}

-(void)setVerticalFrame
{
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-260, self.view.bounds.size.width, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, self.view.bounds.size.width, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2500)];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    //UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 770, 216)];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 216)];
    datePicker.tag = 10;
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];             
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"数据加载..."];

    indexOfTab = [[tabBar items] indexOfObject:item];
    if (indexOfTab == 0) {
        [HUD showWhileExecuting:@selector(myEventList) onTarget:self withObject:nil animated:YES];
    } else if (indexOfTab == 1) {
        [HUD showWhileExecuting:@selector(mySendList) onTarget:self withObject:nil animated:YES];
    } else if (indexOfTab == 2) {
        [HUD showWhileExecuting:@selector(myInvationList) onTarget:self withObject:nil animated:YES];
    } else if (indexOfTab == 3) {
        [HUD showWhileExecuting:@selector(publicEventList) onTarget:self withObject:nil animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"count ==== %d", [self.eventsList count]);
    return [self.eventsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CalendarCell";
	CalendarCell *cell = (CalendarCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	// Get the event at the row selected and display it's title
    Calendar *calendarObj = [self.eventsList objectAtIndex:indexPath.row];
    cell.eventNameLabel.text = calendarObj.Title;
    cell.startTimeLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.StartTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"MM月dd日 HH:mm"];
    cell.endTimeLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.EndTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"MM月dd日 HH:mm"];
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"do didSelectRowAtIndexPath");
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    Calendar *calendarObj = [self.eventsList objectAtIndex:[self.tableViewCustom indexPathForSelectedRow].row];
    if (indexOfTab != 3) {
        CalendarDetailViewController *calendarDetailViewController = [storyborad instantiateViewControllerWithIdentifier:@"CalendarDetailViewController"];
        calendarDetailViewController.calenderId = calendarObj.ID;
        calendarDetailViewController.tabIndex = indexOfTab;
        refreshFlag = @"NO";
        [self.navigationController pushViewController:calendarDetailViewController animated:YES];
    } else {
        PublicCalendarViewController *publicCalendarViewController = [storyborad instantiateViewControllerWithIdentifier:@"PublicCalendarViewController"];
        publicCalendarViewController.calenderId = calendarObj.ID;
        [self.navigationController pushViewController:publicCalendarViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
    [self.tableViewCustom reloadData];
    
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData {
	//  model should call this when its done loading
	_reloading = NO;
    if (indexOfTab == 0) {
        [self myEventList]; 
    } else if (indexOfTab == 1) {
        [self mySendList];
    } else if (indexOfTab == 2) {
        [self myInvationList];
    } else if (indexOfTab == 3) {
        [self publicEventList];
    }
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableViewCustom];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

- (void)changeDate:(UIDatePicker *)sender {
    NSLog(@"New Date: %@", sender.date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    currentDateStr = [dateFormatter stringFromDate:sender.date];
    self.navigationItem.prompt = [show stringByAppendingFormat:@"%@", currentDateStr];
    self.items = [NSArray arrayWithObjects:@"打开iCal", [show stringByAppendingFormat:@"%@", currentDateStr], nil];
    
    currentDate = sender.date;
    [self.eventsList removeAllObjects];
    NSTimeInterval  interval = 24 * 60 * 60 * 3;
    NSDate *threeDayAfter = [currentDate initWithTimeIntervalSinceNow:+interval];
    // Fetch today's event on selected calendar and put them into the eventsList array
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    if (indexOfTab == 0) {
        self.eventsList = [Calendar getAllMyData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    }
    else if (indexOfTab == 1) {
        self.eventsList = [Calendar allMySendData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    }
    else if (indexOfTab == 2) {
        self.eventsList = [Calendar allInvitedMeData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    }
    [self.tableViewCustom reloadData];
}

/* ---------------------------------------------------------
 * Delegate methods of ExpandingButtonBarDelegate
 * -------------------------------------------------------*/
- (void) expandingBarDidAppear:(RNExpandingButtonBar *)bar
{
    //NSLog(@"did appear");
}

- (void) expandingBarWillAppear:(RNExpandingButtonBar *)bar
{
    //NSLog(@"will appear");
}

- (void) expandingBarDidDisappear:(RNExpandingButtonBar *)bar
{
    //NSLog(@"did disappear");
}

- (void) expandingBarWillDisappear:(RNExpandingButtonBar *)bar
{
    //NSLog(@"will disappear");
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end
