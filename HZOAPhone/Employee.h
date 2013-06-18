//
//  Employee.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-14.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <CoreLocation/CoreLocation.h>
#import "GDataXMLNode.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface Employee : NSObject<CLLocationManagerDelegate> {
    NSString *_id;
    NSString *_name;
    NSString *_mobile;
    NSString *_tel;
    NSString *_address;
    NSString *_birthday;
    NSString *_idenfityCard;
    NSString *_email;
    NSString *_status;
    NSString *_sex;
    NSString *_partyId;
    NSString *_partyName;
    
    CLLocationManager *locationManager;
}

@property (nonatomic, retain) NSString *_id;
@property (nonatomic, retain) NSString *_name;
@property (nonatomic, retain) NSString *_mobile;
@property (nonatomic, retain) NSString *_tel;
@property (nonatomic, retain) NSString *_address;
@property (nonatomic, retain) NSString *_birthday;
@property (nonatomic, retain) NSString *_idenfityCard;
@property (nonatomic, retain) NSString *_email;
@property (nonatomic, retain) NSString *_status;
@property (nonatomic, retain) NSString *_sex;
@property (nonatomic, retain) NSString *_partyId;
@property (nonatomic, retain) NSString *_partyName;
@property (nonatomic, retain) CLLocationManager *locationManager;

+ (void)synchronizeEmployee;
+ (void)insertEmployee:(Employee *) employee;
+ (void)deleteAllEmployee;
+ (void)dropEmployeeTable;
+ (void)createEmployeeTable;
+ (void)createMostContactTable;
+ (NSMutableArray *) getAllEmployee;
+ (void)sendDeviceInfo:(NSString *) userId withDeviceType:(NSString *) deviceType withDeviceToken:(NSString *) deviceToken;
+ (NSMutableArray *) getAllMostContact;
+ (void)insertMostContact:(Employee *) employee;
+ (void)deleteMostContact:(Employee *) employee;

@end
