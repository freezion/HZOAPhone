//
//  Calendar.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-30.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <sqlite3.h>
#import "GDataXMLNode.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CalendarRelationship.h"
#import "UserKeychain.h"

@interface Calendar : NSObject {
    NSString *ID;
    NSString *Title;
    NSString *Note;
    NSString *StartTime;
    NSString *EndTime;
    NSString *Reminder;
    NSString *Location;
    NSString *AllDay;
    NSString *Type;
    NSString *TypeName;
    NSString *Employee_Id;
    NSString *Employee_Name;
    NSString *Readed;
    NSString *IsRead;
    NSString *import;
    NSString *senderId;
    NSString *senderName;
    NSString *CustomerId;
    NSString *CustomerName;
    NSString *ProjectId;
    NSString *ProjectNum;
    NSString *ProjectStartTime;
    NSString *ProjectEndTime;
    NSString *ClientId;
    NSString *ClientName;
    NSString *message;
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *Title;
@property (nonatomic, retain) NSString *Note;
@property (nonatomic, retain) NSString *StartTime;
@property (nonatomic, retain) NSString *EndTime;
@property (nonatomic, retain) NSString *Reminder;
@property (nonatomic, retain) NSString *Location;
@property (nonatomic, retain) NSString *AllDay;
@property (nonatomic, retain) NSString *Type;
@property (nonatomic, retain) NSString *TypeName;
@property (nonatomic, retain) NSString *Employee_Id;
@property (nonatomic, retain) NSString *Employee_Name;
@property (nonatomic, retain) NSString *Readed;
@property (nonatomic, retain) NSString *import;
@property (nonatomic, retain) NSString *senderId;
@property (nonatomic, retain) NSString *senderName;
@property (nonatomic, retain) NSString *CustomerId;
@property (nonatomic, retain) NSString *CustomerName;
@property (nonatomic, retain) NSString *ProjectId;
@property (nonatomic, retain) NSString *ProjectNum;
@property (nonatomic, retain) NSString *ProjectStartTime;
@property (nonatomic, retain) NSString *ProjectEndTime;
@property (nonatomic, retain) NSString *IsRead;
@property (nonatomic, retain) NSString *ClientId;
@property (nonatomic, retain) NSString *ClientName;
@property (nonatomic, retain) NSString *message;

+ (NSString *) addCalendar:(Calendar *) calendar withEmployeeId:(NSString *) employeeId withEventStoreId:(NSString *) eventStoreId;
+ (NSString *) updateCalendar:(Calendar *) calendar;
+ (void)createCalendarTable;
+ (NSString *) getNetCalendarId:(NSString *) localId;
+ (NSString *) getLocalCalendarId:(NSString *) netId;
+ (NSString *) deleteCalendar:(NSString *) calendarId withEmployeeId:(NSString *) employeeId withEventStoreId:
(NSString *) eventStoreId;
+ (NSMutableArray *) getCalendarDataByDateTime:(NSDate *) startDate withEndDate:(NSDate *) endDate withEmployeeId:(NSString *) employeeId withCalendar:(EKCalendar *) calendar;
+ (NSMutableArray *)loadCalendar:(NSData *) responseData withCalendar:(EKCalendar *) calendar withSync:(BOOL) flag withEmployeeId:(NSString *) employeeId;
+ (void) syncEventsToServer:(NSString *) employeeId;
+ (Calendar *) getSingleCanlendar:(NSString *) calendarId;
+ (void) senderMessage:(Calendar *) calendarObj withContext:(NSString *) context withEmployee:(NSString *) employeeId;
+ (void) accpetEvent:(NSString *) eventId withEmployeeID:(NSString *) employeeId;
+ (void) rejectEvent:(NSString *) eventId withEmployeeID:(NSString *) employeeId;

+ (NSMutableArray *) getAllMyData:(NSString *) employeeId withStartDate:(NSDate *) startDate withEndDate:(NSDate *) endDate;
+ (NSMutableArray *) allMySendData:(NSString *) employeeId withStartDate:(NSDate *) startDate withEndDate:(NSDate *) endDate;
+ (NSMutableArray *) allInvitedMeData:(NSString *) employeeId withStartDate:(NSDate *) startDate withEndDate:(NSDate *) endDate;
+ (NSMutableArray *) publicEventDate:(NSDate *) startDate withEndDate:(NSDate *) endDate;
+ (Calendar *) getSinglePublicCalendar:(NSString *) calendarId;

@end
