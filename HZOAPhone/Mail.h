//
//  Mail.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-7.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GDataXMLNode.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UserKeychain.h"

@interface Mail : NSObject {
    NSString *ID;
    NSString *title;
    NSString *context;
    NSString *date;
    NSString *sender;
    NSString *senderName;
    NSString *reciver;
    NSString *reciverName;
    NSString *fileId;
    NSString *fileName;
    NSString *readed;
    NSString *importId;
    NSString *importName;
    NSString *deptment;
    NSString *status;
    NSString *cleanHtml;
    NSString *ccList;
    NSString *ccListName;
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *context;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *sender;
@property (nonatomic, retain) NSString *senderName;
@property (nonatomic, retain) NSString *reciver;
@property (nonatomic, retain) NSString *reciverName;
@property (nonatomic, retain) NSString *fileId;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *readed;
@property (nonatomic, retain) NSString *importId;
@property (nonatomic, retain) NSString *importName;
@property (nonatomic, retain) NSString *deptment;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *cleanHtml;
@property (nonatomic, retain) NSString *ccList;
@property (nonatomic, retain) NSString *ccListName;

+ (void)createEmailTable;
+ (void)dropEmailTable;
+ (NSMutableArray *)synchronizeEmail:(id) employeeId;
+ (NSMutableArray *) getAllEmail:(id) employeeId withSync:(BOOL) flag;
+ (NSMutableArray *) loadEmail:(NSData *) responseData withSync:(BOOL) flag;
+ (NSMutableArray *) getLocalReciveEmail:(id) employeeId;
+ (NSString *)serviceAddEmail:(Mail *) mail;
+ (NSMutableArray *) getLocalSenderEmail:(id) employeeId;
+ (void)deleteReceiveEmailById:(id) emailId withEmployeeId:(id) employeeId;
+ (NSMutableArray *) getTmpMail:(NSString *) employeeId;
+ (NSMutableArray *) getWillDeleteMail:(NSString *) employeeId;
+ (void)readedMail:(NSString *) mailId withEmployeeId:(NSString *) employeeId;
+ (void)deleteEmailById:(id) emailId withEmployeeId:(id) employeeId;
+ (NSString *)serviceSaveTmpEmail:(Mail *) mail;

+ (NSString *)serviceTestJava;

@end
