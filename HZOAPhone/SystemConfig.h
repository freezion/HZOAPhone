//
//  SystemConfig.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-31.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GDataXMLNode.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UserKeychain.h"

@interface SystemConfig : NSObject {
    NSString *ID;
    NSString *typeId;
    NSString *name;
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *typeId;
@property (nonatomic, retain) NSString *name;

+ (void)createSystemConfigTable;
+ (void)dropSystemConfigTable;
+ (void)synchronizeSystemConfig;
+ (NSMutableArray *)loadSystemConfigById:(NSString *) sender;
+ (NSMutableArray *) loadSystemConfig:(NSData *) responseData withSync:(BOOL) flag;
+ (void)updateSystemConfig:(SystemConfig *) systemConfig;
+ (SystemConfig *) getSystemConfigById:(NSString *) sysId;
+ (void)insertSystemConfig:(SystemConfig *) systemConfig;
+ (NSString *) getVersion;
+ (NSMutableArray *) getNoticeType:(NSString *) employeeId;
+ (void) returnToLogin;

@end
