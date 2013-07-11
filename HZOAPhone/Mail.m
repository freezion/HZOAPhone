//
//  Mail.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-7.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "Mail.h"

@implementation Mail

@synthesize ID;
@synthesize title;
@synthesize context;
@synthesize date;
@synthesize sender;
@synthesize senderName;
@synthesize reciver;
@synthesize reciverName;
@synthesize fileId;
@synthesize fileName;
@synthesize readed;
@synthesize importId;
@synthesize importName;
@synthesize deptment;
@synthesize status;
@synthesize cleanHtml;
@synthesize ccList;
@synthesize ccListName;
@synthesize isChecked;

+ (NSString *)serviceTestJava {
    NSString *webserviceUrl = @"http://10.1.2.114:8080/eLife/services/rest/getCardById";
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"123", @"id",
                                    nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSLog(@"%@",url);
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:jsonString forKey:@"id"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    NSLog(@" responseString ===== %@", [request responseString]);
    return nil;
}

+ (NSString *)serviceAddEmail:(Mail *) mail {
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Email.asmx/addEmailJSON"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    mail.ID, @"ID", 
                                    mail.title, @"title",
                                    mail.context, @"context",
                                    mail.date, @"date",
                                    mail.sender, @"sender",
                                    mail.senderName, @"senderName",
                                    mail.reciver, @"reciver",
                                    mail.reciverName, @"reciverName",
                                    mail.fileId, @"fileId",
                                    mail.fileName, @"fileName",
                                    mail.readed, @"readed",
                                    mail.importId, @"importId",
                                    mail.importName, @"importName",
                                    mail.status, @"status",
                                    mail.ccList, @"copyID",
                                    nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary 
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSLog(@"%@",url);
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:jsonString forKey:@"con"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    NSLog(@" responseString ===== %@", [request responseString]);
    return @"";
}

+ (NSString *)serviceSaveTmpEmail:(Mail *) mail {
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Email.asmx/saveEmailJSON"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    mail.ID, @"ID",
                                    mail.title, @"title",
                                    mail.context, @"context",
                                    mail.date, @"date",
                                    mail.sender, @"sender",
                                    mail.senderName, @"senderName",
                                    mail.reciver, @"reciver",
                                    mail.reciverName, @"reciverName",
                                    mail.fileId, @"fileId",
                                    mail.fileName, @"fileName",
                                    mail.readed, @"readed",
                                    mail.importId, @"importId",
                                    mail.importName, @"importName",
                                    mail.status, @"status",
                                    mail.ccList, @"copyID",
                                    nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSLog(@"%@",url);
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:jsonString forKey:@"con"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    NSLog(@" responseString ===== %@", [request responseString]);
    return @"";
}

+ (NSMutableArray *) getLocalSenderEmail:(id) employeeId {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM EMAIL WHERE SENDER = \"%@\" AND STATUS = \"1\" ORDER BY DATE DESC;", employeeId];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) 
        {
            while (sqlite3_step(statement) == SQLITE_ROW) 
            {
                Mail *mail = [[Mail alloc] init];
                // id
                NSString *idField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                mail.ID = idField;
                // title
                NSString *titleField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                mail.title = titleField;
                // context
                NSString *contextField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                mail.context = contextField;
                // date
                NSString *dateField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                mail.date = dateField;
                // sender
                NSString *senderField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                mail.sender = senderField;
                // senderName
                NSString *senderNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                mail.senderName = senderNameField;
                // reciver
                NSString *reciverField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                mail.reciver = reciverField;
                // reciverName
                NSString *reciverNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                mail.reciverName = reciverNameField;
                // fileId
                NSString *fileIdField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                mail.fileId = fileIdField;
                // fileName
                NSString *fileNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                mail.fileName = fileNameField;
                // readed
                NSString *readedField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                mail.readed = readedField;
                // importId
                NSString *importIdField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                mail.importId = importIdField;
                // importName
                NSString *importNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                mail.importName = importNameField;
                // deptment
                NSString *deptmentField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
                mail.deptment = deptmentField;
                // status
                NSString *statusField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)];
                mail.status = statusField;
                // cleanHtml
                NSString *cleanHtmlField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 15)];
                mail.cleanHtml = cleanHtmlField;
                // copyName
                NSString *copyNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 16)];
                mail.ccListName = copyNameField;
                // copyId
                NSString *copyIdField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 17)];
                mail.ccList = copyIdField;
                mail.isChecked = NO;
                [dataList addObject:mail];
            }
            sqlite3_finalize(statement);
        }     
        sqlite3_close(hzoaDB);
    }
    return dataList;
}

+ (NSMutableArray *) getLocalReciveEmail:(id) employeeId {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM EMAIL WHERE RECIVER LIKE '%%%%%@%%';", employeeId];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) 
        {
            while (sqlite3_step(statement) == SQLITE_ROW) 
            {
                Mail *mail = [[Mail alloc] init];
                // id
                NSString *idField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                mail.ID = idField;
                // title
                NSString *titleField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                mail.title = titleField;
                // context
                NSString *contextField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                mail.context = contextField;
                // date
                NSString *dateField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                mail.date = dateField;
                // sender
                NSString *senderField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                mail.sender = senderField;
                // senderName
                NSString *senderNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                mail.senderName = senderNameField;
                // reciver
                NSString *reciverField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                mail.reciver = reciverField;
                // reciverName
                NSString *reciverNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                mail.reciverName = reciverNameField;
                // fileId
                NSString *fileIdField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                mail.fileId = fileIdField;
                // fileName
                NSString *fileNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                mail.fileName = fileNameField;
                // readed
                NSString *readedField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                mail.readed = readedField;
                // importId
                NSString *importIdField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                mail.importId = importIdField;
                // importName
                NSString *importNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                mail.importName = importNameField;
                // deptment
                NSString *deptmentField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
                mail.deptment = deptmentField;
                // status
                NSString *statusField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)];
                mail.status = statusField;
                // cleanHtml
                NSString *cleanHtmlField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 15)];
                mail.cleanHtml = cleanHtmlField;
                // copyName
                NSString *copyNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 16)];
                mail.ccListName = copyNameField;
                // copyId
                NSString *copyIdField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 17)];
                mail.ccList = copyIdField;
                mail.isChecked = NO;
                [dataList addObject:mail];
            }
            sqlite3_finalize(statement);
        }     
        sqlite3_close(hzoaDB);
    }
    return dataList;
}

+ (NSMutableArray *)synchronizeEmail:(id) employeeId {
    NSMutableArray *mailList = [[NSMutableArray alloc] initWithCapacity:20];
    [Mail deleteAllEmail:employeeId];
    mailList = [Mail getAllEmail:employeeId withSync:YES];
    NSLog(@"%@",employeeId);
    return mailList;
}

+ (NSMutableArray *) getWillDeleteMail:(NSString *) employeeId {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Email.asmx/getdeleteDta"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:employeeId forKey:@"id"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        dataList = [Mail loadEmail:responseData withSync:NO];
    } else {
        
    }
    return dataList;
}

+ (NSMutableArray *) getTmpMail:(NSString *) employeeId {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Email.asmx/getUnsendData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:employeeId forKey:@"id"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        dataList = [Mail loadEmail:responseData withSync:NO];
    } else {

    }
    return dataList;

}

+ (NSMutableArray *) getAllEmail:(id) employeeId withSync:(BOOL) flag {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Email.asmx/getdata"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
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
        dataList = [Mail loadEmail:responseData withSync:flag];
    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法访问，请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
    }
    return dataList;
}

+ (NSMutableArray *) loadEmail:(NSData *) responseData withSync:(BOOL) flag
{
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil) { return nil; }
    NSArray *mailMembers = [doc.rootElement elementsForName:@"ModJsonEmail"];
    for (GDataXMLElement *mailMember in mailMembers) {
        Mail *mail = [[Mail alloc] init];
        //ID
        NSArray *ids = [mailMember elementsForName:@"ID"];
        if (ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ids objectAtIndex:0];
            mail.ID = firstId.stringValue;
        } else {
            mail.ID = @"";
        }
        
        //titles
        NSArray *titles = [mailMember elementsForName:@"title"];
        if (titles.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [titles objectAtIndex:0];
            mail.title = firstId.stringValue;
        } else {
            mail.title = @"";
        }
        
        //contexts
        NSArray *contexts = [mailMember elementsForName:@"context"];
        if (contexts.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [contexts objectAtIndex:0];
            mail.context = firstId.stringValue;
        } else {
            mail.context = @"";
        }
        
        //dates
        NSArray *dates = [mailMember elementsForName:@"date"];
        if (dates.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [dates objectAtIndex:0];
            NSString *firstString = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            mail.date = firstString;
        } else {
            mail.date = @"";
        }
        
        //senders
        NSArray *senders = [mailMember elementsForName:@"sender"];
        if (senders.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [senders objectAtIndex:0];
            mail.sender = firstId.stringValue;
        } else {
            mail.sender = @"";
        }
        
        //senders
        NSArray *senderNames = [mailMember elementsForName:@"senderName"];
        if (senderNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [senderNames objectAtIndex:0];
            mail.senderName = firstId.stringValue;
        } else {
            mail.senderName = @"";
        }
        
        //recivers
        NSArray *recivers = [mailMember elementsForName:@"reciver"];
        if (recivers.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [recivers objectAtIndex:0];
            mail.reciver = firstId.stringValue;
        } else {
            mail.reciver = @"";
        }
        
        //reciverNames
        NSArray *reciverNames = [mailMember elementsForName:@"reciverName"];
        if (reciverNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [reciverNames objectAtIndex:0];
            mail.reciverName = firstId.stringValue;
        } else {
            mail.reciverName = @"";
        }
        
        //fileIds
        NSArray *fileIds = [mailMember elementsForName:@"fileId"];
        if (fileIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [fileIds objectAtIndex:0];
            mail.fileId = firstId.stringValue;
        } else {
            mail.fileId = @"";
        }
        
        //fileNames
        NSArray *fileNames = [mailMember elementsForName:@"fileName"];
        if (fileNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [fileNames objectAtIndex:0];
            mail.fileName = firstId.stringValue;
        } else {
            mail.fileName = @"";
        }
        
        //readeds
        NSArray *readeds = [mailMember elementsForName:@"status"];
        if (readeds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [readeds objectAtIndex:0];
            mail.readed = firstId.stringValue;
        } else {
            mail.readed = @"";
        }
        
        //importIds
        NSArray *importIds = [mailMember elementsForName:@"importId"];
        if (importIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [importIds objectAtIndex:0];
            mail.importId = firstId.stringValue;
        } else {
            mail.importId = @"";
        }
        
        //importNames
        NSArray *importNames = [mailMember elementsForName:@"importName"];
        if (importNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [importNames objectAtIndex:0];
            mail.importName = firstId.stringValue;
        } else {
            mail.importName = @"";
        }
        
        //deptments
        NSArray *deptments = [mailMember elementsForName:@"deptment"];
        if (deptments.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [deptments objectAtIndex:0];
            mail.deptment = firstId.stringValue;
        } else {
            mail.deptment = @"";
        }
        
        //statuses
        NSArray *statuses = [mailMember elementsForName:@"status"];
        if (statuses.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [statuses objectAtIndex:0];
            mail.status = firstId.stringValue;
        } else {
            mail.status = @"";
        }
        //copyId
        NSArray *copyIds = [mailMember elementsForName:@"copyID"];
        if (copyIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [copyIds objectAtIndex:0];
            mail.ccList = firstId.stringValue;
        } else {
            mail.ccList = @"";
        }
        //copyNames
        NSArray *copyNames = [mailMember elementsForName:@"copyName"];
        if (copyNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [copyNames objectAtIndex:0];
            mail.ccListName = firstId.stringValue;
        } else {
            mail.ccListName = @"";
        }
        if (flag) {
            [Mail insertEmail:mail];
        }
        [dataList addObject:mail];
    }
    return dataList;
}

+ (void)readedMail:(NSString *) mailId withEmployeeId:(NSString *) employeeId {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE EMAIL SET READED = \"%@\" WHERE ID = \"%@\";", @"1", mailId];
        const char *insert_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(hzoaDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        } else {
            NSLog(@"更新失败");
        }
        sqlite3_finalize(statement);
        sqlite3_close(hzoaDB);
    }
    
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Email.asmx/readEmailChangeStatus"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:mailId forKey:@"id"];
    [request setPostValue:employeeId forKey:@"employeeId"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startAsynchronous];
}

+ (void)dropEmailTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *dropSql = @"DROP TABLE IF EXISTS EMAIL;";
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

+ (void)createEmailTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) 
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS EMAIL(ID VARCHAR(50) PRIMARY KEY, TITLE TEXT, CONTEXT LONGTEXT, DATE TEXT, SENDER VARCHAR(50), SENDERNAME TEXT, RECIVER TEXT, RECIVERNAME TEXT, FILEID TEXT, FILENAME TEXT, READED TEXT, IMPORTID TEXT, IMPORTNAME TEXT, DEPTMENT TEXT, STATUS VARCHAR(5), NOHTMLCON TEXT, COPYNAME TEXT, COPYID VARCHAR(50));";
        if (sqlite3_exec(hzoaDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else 
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void)insertEmail:(Mail *) mail
{
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) {
        NSString *emailId = mail.ID;
        NSString *title = mail.title;
        NSString *context = mail.context;
        NSString *date = mail.date;
        NSString *sender = mail.sender;
        NSString *senderName = mail.senderName;
        NSString *reciver = mail.reciver;
        NSString *reciverName = mail.reciverName;
        NSString *fileId = mail.fileId;
        NSString *fileName = mail.fileName;
        NSString *readed = mail.readed;
        NSString *importId = mail.importId;
        NSString *importName = mail.importName;
        NSString *deptment = mail.deptment;
        NSString *status = mail.status;
        NSString *ccList = mail.ccList;
        NSString *ccListName = mail.ccListName;
        context = [context stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        NSString *str = [self stringByStrippingHTML:context];
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO EMAIL VALUES(\"%@\",\"%@\",'%@',\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",'%@',\"%@\",\"%@\")", emailId, title, context, date, sender, senderName, reciver, reciverName, fileId, fileName, readed, importId, importName, deptment, status, str, ccListName, ccList];
        //NSLog(@"%@", insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(hzoaDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        }        
        sqlite3_finalize(statement);
        sqlite3_close(hzoaDB);
    }
}

+ (void)deleteAllEmail:(NSString *) employeeId {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        employeeId = [NSUtil addLT:employeeId];
        NSString *querySQL = @"DELETE FROM EMAIL;";
        const char *query = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"delete data failed!");
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(hzoaDB));
        }
    } else {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (NSString *)getReceiveById:(id) emailId {
    NSString *receive = @"";
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT RECIVER FROM EMAIL WHERE ID = \"%@\";", emailId];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) 
        {
            if (sqlite3_step(statement) == SQLITE_ROW) 
            {
                // receive
                NSString *receiveField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                receive = receiveField;
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(hzoaDB);
    }
    return receive;
}

+ (void)deleteEmailById:(id) emailId withEmployeeId:(id) employeeId {
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Email.asmx/delData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:emailId forKey:@"id"];
    [request setPostValue:employeeId forKey:@"EmployeeId"];
    [request setPostValue:@"True" forKey:@"deleteType"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    NSLog(@"%@", [request responseString]);
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM EMAIL WHERE ID = \"%@\";", emailId];
        const char *delete_stmt = [query UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, delete_stmt, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"UPDATE data failed!");
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(hzoaDB));
        }
    } else {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void)deleteReceiveEmailById:(id) emailId withEmployeeId:(id) employeeId {
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Email.asmx/delData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:emailId forKey:@"id"];
    [request setPostValue:employeeId forKey:@"EmployeeId"];
    [request setPostValue:@"False" forKey:@"deleteType"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    NSLog(@"%@", [request responseString]);
    NSString *receive = [self getReceiveById:emailId];
    NSString *newReceive = [NSUtil removeReceiveId:receive withReplace:employeeId];
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *query = [NSString stringWithFormat:@"UPDATE EMAIL SET RECIVER = \"%@\" WHERE ID = \"%@\";", newReceive, emailId];
        const char *delete_stmt = [query UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, delete_stmt, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"UPDATE data failed!");
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(hzoaDB));
        }
    } else {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (NSString *) stringByStrippingHTML:(NSString *) str {
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    return str; 
}

+ (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

@end
