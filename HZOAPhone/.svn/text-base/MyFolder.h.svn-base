//
//  MyFolder.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-6.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GDataXMLNode.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UserKeychain.h"

@interface MyFolder : NSObject {
    NSString *ID;
    NSString *employeeId;
    NSString *EmployeeName;
    NSString *fileId;
    NSString *fileName;
    NSMutableArray *folderList;
    
    NSString *folderID;
    NSString *companyNameCN;
    NSString *companyNameJP;
    
    NSString *uploadTime;
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *employeeId;
@property (nonatomic, retain) NSString *EmployeeName;
@property (nonatomic, retain) NSString *fileId;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSMutableArray *folderList;

@property (nonatomic, retain) NSString *folderID;
@property (nonatomic, retain) NSString *companyNameCN;
@property (nonatomic, retain) NSString *companyNameJP;

@property (nonatomic, retain) NSString *uploadTime;

+ (void)createMyFolderTable;
+ (NSMutableArray *) getLocalMyFolder:(id) employeeId;
+ (NSMutableArray *) synchronizeMyFolder:(id) employeeId;
+ (NSMutableArray *) getAllCompany;
+ (NSMutableArray *) getFileByCompanyId:(NSString *) companyId;

@end
