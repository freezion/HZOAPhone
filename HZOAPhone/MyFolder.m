//
//  MyFolder.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-6.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "MyFolder.h"

@implementation MyFolder

@synthesize ID;
@synthesize employeeId;
@synthesize EmployeeName;
@synthesize fileId;
@synthesize fileName;
@synthesize folderList;
@synthesize folderID;
@synthesize companyNameCN;
@synthesize companyNameJP;
@synthesize uploadTime;

+ (NSMutableArray *) synchronizeMyFolder:(id) employeeId {
    NSMutableArray *folderList = [[NSMutableArray alloc] initWithCapacity:20];
    [MyFolder deleteAllMyFolder:employeeId];
    //folderList = [MyFolder getAllMyFolder:employeeId withSync:YES];
    return folderList;
}

+ (void) deleteServiceMyFolder:(NSString *) myFolderId withEmployeeId:(id) employeeId {
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"employeefile.asmx/getAllData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    //NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:employeeId forKey:@"employeeId"];
    [request setPostValue:myFolderId forKey:@"fileId"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    if(request.responseStatusCode == 200)
    {
        [MyFolder deleteAllMyFolder:myFolderId];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法访问，请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

+ (NSMutableArray *) getFileByCompanyId:(NSString *) companyId {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"memberFile.asmx/getAllFilesByFolderID"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    //NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:companyId forKey:@"FolderID"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        dataList = [MyFolder loadMyFile:responseData];
    } else {
        
    }
    return dataList;
}

+ (NSMutableArray *) getAllCompany {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"memberFile.asmx/getAllCompany"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    //NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    //NSLog(@"%@", [request responseString]);
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        dataList = [MyFolder loadMyFolder:responseData];
    } else {
        
    }
    return dataList;
}

+ (NSMutableArray *) loadMyFile:(NSData *) responseData {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:0];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil) { return nil; }
    NSArray *noticeMembers = [doc.rootElement elementsForName:@"ModJsonMemberConnectFiles"];
    for (GDataXMLElement *noticeMember in noticeMembers) {
        MyFolder *myFolder = [[MyFolder alloc] init];
        //FolderID
        NSArray *ids = [noticeMember elementsForName:@"FolderID"];
        if (ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ids objectAtIndex:0];
            myFolder.folderID = firstId.stringValue;
        } else {
            myFolder.folderID = @"";
        }
        
        //FileID
        NSArray *fileIds = [noticeMember elementsForName:@"FileID"];
        if (fileIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [fileIds objectAtIndex:0];
            myFolder.fileId = firstId.stringValue;
        } else {
            myFolder.fileId = @"";
        }
        
        //FileNames
        NSArray *fileNames = [noticeMember elementsForName:@"FileName"];
        if (fileNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [fileNames objectAtIndex:0];
            myFolder.fileName = firstId.stringValue;
        } else {
            myFolder.fileName = @"";
        }
        
        //UploadTimes
        NSArray *uploadTimes = [noticeMember elementsForName:@"UploadTime"];
        if (uploadTimes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [uploadTimes objectAtIndex:0];
            myFolder.uploadTime = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        } else {
            myFolder.uploadTime = @"";
        }
        
        //EmpName
        NSArray *empNames = [noticeMember elementsForName:@"EmpName"];
        if (empNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [empNames objectAtIndex:0];
            myFolder.EmployeeName = firstId.stringValue;
        } else {
            myFolder.EmployeeName = @"";
        }
        
        [dataList addObject:myFolder];
    }
    
    return dataList;
}

+ (NSMutableArray *) loadMyFolder:(NSData *) responseData
{
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil) { return nil; }
    NSArray *noticeMembers = [doc.rootElement elementsForName:@"ModJsonMemberFile"];
    for (GDataXMLElement *noticeMember in noticeMembers) {
        MyFolder *myFolder = [[MyFolder alloc] init];
        //FolderID
        NSArray *ids = [noticeMember elementsForName:@"FolderID"];
        if (ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ids objectAtIndex:0];
            myFolder.folderID = firstId.stringValue;
        } else {
            myFolder.folderID = @"";
        }
        
        //namesCN
        NSArray *companyNameCNs = [noticeMember elementsForName:@"NameCN"];
        if (companyNameCNs.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [companyNameCNs objectAtIndex:0];
            myFolder.companyNameCN = firstId.stringValue;
        } else {
            myFolder.companyNameCN = @"";
        }
        
        //namesJP
        NSArray *companyNameJPs = [noticeMember elementsForName:@"NameJP"];
        if (companyNameJPs.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [companyNameJPs objectAtIndex:0];
            myFolder.companyNameJP = firstId.stringValue;
        } else {
            myFolder.companyNameJP = @"";
        }
        
        [dataList addObject:myFolder];
    }
    return dataList;
}

+ (NSMutableArray *) getLocalMyFolder:(id) employeeId {
    NSMutableArray *myFolderList = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        employeeId = [NSUtil addLT:employeeId];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM MYFOLDER WHERE ID = \"%@\";", employeeId];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) 
        {
            while (sqlite3_step(statement) == SQLITE_ROW) 
            {
                MyFolder *myFolder = [[MyFolder alloc] init];
                // id
                NSString *idField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                myFolder.ID = idField;
                // employeeId
                NSString *employeeIdField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                myFolder.employeeId = employeeIdField;
                // EmployeeName
                NSString *EmployeeNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                myFolder.EmployeeName = EmployeeNameField;
                // fileId
                NSString *fileIdField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                myFolder.fileId = fileIdField;
                // fileName
                NSString *fileNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                myFolder.fileName = fileNameField;
                [myFolderList addObject:myFolder];
            }
            sqlite3_finalize(statement);
        }     
        sqlite3_close(hzoaDB);
    }
    //NSLog(@"%@", noticeList);
    return myFolderList;
}

+ (void)deleteAllMyFolder:(NSString *) employeeId {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        employeeId = [NSUtil addLT:employeeId];
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM MYFOLDER WHERE EMPLOYEEID = \"%@\";", employeeId] ;
        const char *query = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query, -1, &stmt, NULL) != SQLITE_OK) {
            
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(hzoaDB));
        }
    } else {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void)insertMyFolder:(MyFolder *) myFolder {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) {
        NSString *myFolderId = myFolder.ID;
        NSString *employeeId = myFolder.employeeId;
        NSString *EmployeeName = myFolder.EmployeeName;
        NSString *fileId = myFolder.fileId;
        NSString *fileName = myFolder.fileName;
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO MYFOLDER VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")", myFolderId, employeeId, EmployeeName, fileId, fileName];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(hzoaDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(hzoaDB);
    }
}

+ (void)deleteMyFolderById:(id) myFloderId {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM NOTICE MYFOLDER ID = \"%@\";", myFloderId];
        NSLog(@"%@", query);
        const char *delete_stmt = [query UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, delete_stmt, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"delete data failed!");
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(hzoaDB));
        }
    } else {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void)createMyFolderTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) 
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS MYFOLDER(ID VARCHAR(50) PRIMARY KEY, EMPLOYEEID VARCHAR(50), FILEID VARCHAR(50), FILENAME TEXT);";
        if (sqlite3_exec(hzoaDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else 
    {
        NSLog(@"创建/打开数据库失败");
    }
}

@end
