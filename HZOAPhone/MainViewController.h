//
//  MainViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-15.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EGORefreshTableHeaderView.h"
#import "SpringBoardViewController.h"
#import "MBProgressHUD.h"
#import "RNExpandingButtonBar.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, UITabBarControllerDelegate, MBProgressHUDDelegate, RNExpandingButtonBarDelegate, CLLocationManagerDelegate, UIAlertViewDelegate> {
    CGFloat _offset;
    BOOL _animated;
    UITableView *tableViewCustom;
    UITabBar *tabBarCustom;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    NSMutableArray *eventsList;
    NSMutableArray *items;
    EKEventStore *eventStore;
    EKCalendar *defaultCalendar;
    NSString *myCalendarType;
    MBProgressHUD *HUD;
    NSString *refreshFlag;
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D curLocation;
    
    NSString *deviceType;
    NSString *deviceTokenNum;
    NSString *model;
    NSString *location;
    int calendarExists;
    RNExpandingButtonBar *bar;
}

@property (retain, nonatomic) IBOutlet UITableView *tableViewCustom;
@property (retain, nonatomic) IBOutlet UITabBar *tabBarCustom;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) NSMutableArray *items;
@property (retain, nonatomic) NSString *refreshFlag;
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) NSString *myCalendarType;
@property (nonatomic, retain) RNExpandingButtonBar *bar;
@property (nonatomic) int calendarExists;

@end
