//
//  Notice.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-2.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GDataXMLNode.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UserKeychain.h"
#import "SystemConfig.h"

@interface Notice : NSObject <UIAlertViewDelegate> {
    NSString *ID;
    NSString *title;
    NSString *context;
    NSString *date;
    NSString *sender;
    NSString *reciver;
    NSString *readed;
    NSString *typeId;
    NSString *typeName;
    NSString *deptment;
    NSString *status;
    NSString *fileName;
    NSString *fileId;
    id viewController;
    BOOL isChecked;
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *context;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *sender;
@property (nonatomic, retain) NSString *reciver;
@property (nonatomic, retain) NSString *readed;
@property (nonatomic, retain) NSString *typeId;
@property (nonatomic, retain) NSString *typeName;
@property (nonatomic, retain) NSString *deptment;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *fileId;
@property (nonatomic, retain) id viewController;
@property (assign, nonatomic) BOOL isChecked;

+ (NSMutableArray *) getAllNotice:(id) noticeID withSync:(BOOL) flag;
+ (void)createNoticeTable;
+ (void)dropNoticeTable;
+ (NSMutableArray *)synchronizeNotice:(id) employeeId;
+ (NSMutableArray *) getLocalNotice:(id) employeeId;
+ (void)insertNotice:(Notice *) notice;
+ (NSString *)serviceAddNotice:(Notice *) notice;
+ (NSMutableArray *) loadNotice:(NSData *) responseData withSync:(BOOL) flag;
+ (void)readedNotice:(NSString *) noticeId withEmployeeId:(NSString *) employeeId;

@end
