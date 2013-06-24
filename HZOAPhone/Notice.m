//
//  Notice.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-2.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "Notice.h"

@implementation Notice

@synthesize ID;
@synthesize title;
@synthesize context;
@synthesize date;
@synthesize sender;
@synthesize reciver;
@synthesize readed;
@synthesize deptment;
@synthesize typeId;
@synthesize typeName;
@synthesize status;
@synthesize fileName;
@synthesize fileId;

+ (void)dropNoticeTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *dropSql = @"DROP TABLE IF EXISTS NOTICE;";
        const char *query = [dropSql UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"drop table failed!");
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(hzoaDB));
        }
    }
    else 
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void)createNoticeTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) 
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS NOTICE(ID VARCHAR(50) PRIMARY KEY, TITLE TEXT, CONTEXT TEXT, DATE TEXT, SENDER TEXT, RECIVER TEXT, READED TEXT, TYPEID TEXT, TYPENAME TEXT, DEPTMENT TEXT, STATUS VARCHAR(10), FILEID VARCHAR(255), FILENAME VARCHAR(255));";
        if (sqlite3_exec(hzoaDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else 
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (NSString *)serviceAddNotice:(Notice *) notice {
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Notice.asmx/addNoticeJson"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    notice.ID, @"ID", 
                                    notice.title, @"title",
                                    notice.context, @"context",
                                    notice.date, @"date",
                                    notice.sender, @"sender", 
                                    notice.readed, @"readed",
                                    notice.typeId, @"typeId",
                                    notice.typeName, @"typeName",
                                    notice.deptment, @"deptment", 
                                    notice.status, @"status",
                                    nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary 
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:jsonString forKey:@"con"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startAsynchronous];
//    if(request.responseStatusCode == 200)
//    {        
//        NSString *responseString = [request responseString];
        NSLog(@" responseString ===== %@", [request responseString]);
//        NSError *error;
//        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
//        GDataXMLElement *root = [doc rootElement];
//        notice.ID = [root stringValue];
//        // add to local DB
//        [Notice insertNotice:notice];
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法访问，请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    return @"";
}

+ (NSMutableArray *)synchronizeNotice:(id) employeeId {
    NSMutableArray *noticeList = [[NSMutableArray alloc] initWithCapacity:20];
    [Notice deleteAllNotice:employeeId];
    noticeList = [Notice getAllNotice:employeeId withSync:YES];
    return noticeList;
}


+ (NSMutableArray *) getLocalNotice:(id) employeeId {
    NSMutableArray *noticeList = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        employeeId = [NSUtil addLT:employeeId];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM NOTICE WHERE RECIVER LIKE '%%%%%@%%';", employeeId];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) 
        {
            while (sqlite3_step(statement) == SQLITE_ROW) 
            {
                Notice *notice = [[Notice alloc] init];
                // id
                NSString *idField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                notice.ID = idField;
                // title
                NSString *titleField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                notice.title = titleField;
                // context
                NSString *contextField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                notice.context = contextField;
                // date
                NSString *dateField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                notice.date = dateField;
                // sender
                NSString *senderField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                notice.sender = senderField;
                // reciver
                NSString *reciverField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                notice.reciver = reciverField;  
                // readed
                NSString *readedField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                notice.readed = readedField;
                // typeId
                NSString *typeIdField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                notice.typeId = typeIdField;
                // typeName
                NSString *typeNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                notice.typeName = typeNameField;
                // deptment
                NSString *deptmentField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                notice.deptment = deptmentField;
                // status
                NSString *statusField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                notice.status = statusField;
                
                [noticeList addObject:notice];
            }
            sqlite3_finalize(statement);
        }     
        sqlite3_close(hzoaDB);
    }
    NSLog(@"%@", noticeList);
    return noticeList;
}

+ (NSMutableArray *) getAllNotice:(id) employeeId withSync:(BOOL) flag {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Notice.asmx/getAllNotice"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    //NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:employeeId forKey:@"id"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    //NSLog(@"%@", [request responseString]);
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        dataList = [Notice loadNotice:responseData withSync:flag];
    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法访问，请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
    }
    return dataList;
}

+ (NSMutableArray *) loadNotice:(NSData *) responseData withSync:(BOOL) flag
{
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil) { return nil; }
    NSArray *noticeMembers = [doc.rootElement elementsForName:@"ModJsonNotice"];
    for (GDataXMLElement *noticeMember in noticeMembers) {
        Notice *notice = [[Notice alloc] init];
        //ID
        NSArray *ids = [noticeMember elementsForName:@"ID"];
        if (ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ids objectAtIndex:0];
            notice.ID = firstId.stringValue;
        } else {
            notice.ID = @"";
        }
        
        //titles
        NSArray *titles = [noticeMember elementsForName:@"title"];
        if (titles.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [titles objectAtIndex:0];
            notice.title = firstId.stringValue;
        } else {
            notice.title = @"";
        }
        
        //contexts
        NSArray *contexts = [noticeMember elementsForName:@"context"];
        if (contexts.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [contexts objectAtIndex:0];
            notice.context = firstId.stringValue;
        } else {
            notice.context = @"";
        }
        
        //dates
        NSArray *dates = [noticeMember elementsForName:@"date"];
        if (dates.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [dates objectAtIndex:0];
            NSString *firstString = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            notice.date = firstString;
        } else {
            notice.date = @"";
        }
        
        //senders
        NSArray *senders = [noticeMember elementsForName:@"sender"];
        if (senders.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [senders objectAtIndex:0];
            notice.sender = firstId.stringValue;
        } else {
            notice.sender = @"";
        }
        
        //recivers
        NSArray *recivers = [noticeMember elementsForName:@"reciver"];
        if (recivers.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [recivers objectAtIndex:0];
            notice.reciver = firstId.stringValue;
        } else {
            notice.reciver = @"";
        }
        
        //readeds
        NSArray *readeds = [noticeMember elementsForName:@"readed"];
        if (readeds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [readeds objectAtIndex:0];
            notice.readed = firstId.stringValue;
        } else {
            notice.readed = @"";
        }
        
        //typeIds
        NSArray *typeIds = [noticeMember elementsForName:@"typeId"];
        if (typeIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [typeIds objectAtIndex:0];
            notice.typeId = firstId.stringValue;
        } else {
            notice.typeId = @"";
        }
        
        //typeNames
        NSArray *typeNames = [noticeMember elementsForName:@"typeName"];
        if (typeNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [typeNames objectAtIndex:0];
            notice.typeName = firstId.stringValue;
        } else {
            notice.typeName = @"";
        }
        
        //deptments
        NSArray *deptments = [noticeMember elementsForName:@"deptment"];
        if (deptments.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [deptments objectAtIndex:0];
            notice.deptment = firstId.stringValue;
        } else {
            notice.deptment = @"";
        }
        
        //statuses
        NSArray *statuses = [noticeMember elementsForName:@"status"];
        if (statuses.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [statuses objectAtIndex:0];
            notice.status = firstId.stringValue;
        } else {
            notice.status = @"";
        }
        
        //fileIds
        NSArray *fileIds = [noticeMember elementsForName:@"fileID"];
        if (fileIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [fileIds objectAtIndex:0];
            notice.fileId = firstId.stringValue;
        } else {
            notice.fileId = @"";
        }
        
        //fileNames
        NSArray *fileNames = [noticeMember elementsForName:@"fileName"];
        if (fileNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [fileNames objectAtIndex:0];
            notice.fileName = firstId.stringValue;
        } else {
            notice.fileName = @"";
        }
        
        if (flag) {
            [Notice insertNotice:notice];
        }
        [dataList addObject:notice];
    }
    return dataList;
}

+ (void)readedNotice:(NSString *) noticeId withEmployeeId:(NSString *) employeeId {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE NOTICE SET READED = \"%@\" WHERE ID = \"%@\";", @"1", noticeId];
        const char *insert_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(hzoaDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        } else {
            NSLog(@"更新失败");
        }
        sqlite3_finalize(statement);
        sqlite3_close(hzoaDB);
    }
    
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Notice.asmx/readNotice"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:noticeId forKey:@"id"];
    [request setPostValue:employeeId forKey:@"employeeId"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
}

+ (void)insertNotice:(Notice *) notice
{
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) {
        NSString *noticeId = notice.ID;
        NSString *title = notice.title;
        NSString *context = notice.context;
        NSString *date = notice.date;
        NSString *sender = notice.sender;
        NSString *reciver = notice.reciver;
        NSString *readed = notice.readed;
        NSString *typeId = notice.typeId;
        NSString *typeName = notice.typeName;
        NSString *deptment = notice.deptment;
        NSString *status = notice.status;
        NSString *fileId = notice.fileId;
        NSString *fileName = notice.fileName;
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO NOTICE VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")", noticeId, title, context, date, sender, reciver, readed, typeId, typeName, deptment, status, fileId, fileName];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(hzoaDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(hzoaDB);
    }

}

+ (void)deleteAllNotice:(NSString *) employeeId {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        employeeId = [NSUtil addLT:employeeId];
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM NOTICE WHERE RECIVER LIKE '%%%%%@%%';", employeeId] ;
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

+ (void)deleteNoticeById:(id) noticeId {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM NOTICE WHERE ID = \"%@\";", noticeId];
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

+ (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

@end
