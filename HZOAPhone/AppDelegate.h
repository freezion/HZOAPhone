//
//  AppDelegate.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-12.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class DDMenuController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate> {
    NSString *deviceTokenNum;
    NSString *deviceType;
    NSString *calendarMessage;
    NSString *noticeMessage;
    NSString *emailMessage;
    NSDictionary *launchOptionsAction;
    NSString *databasePath;
    sqlite3 *hzoaDB;
    
    NSString *activeFlag;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DDMenuController *menuController;
@property (retain, nonatomic) NSString *deviceTokenNum;
@property (retain, nonatomic) NSString *deviceType;
@property (retain, nonatomic) NSString *calendarMessage;
@property (retain, nonatomic) NSString *noticeMessage;
@property (retain, nonatomic) NSString *emailMessage;
@property (retain, nonatomic) NSDictionary *launchOptionsAction;
@property (retain, nonatomic) NSString *activeFlag;

@end
