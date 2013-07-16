//
//  Employee.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-14.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "Employee.h"

@implementation Employee

@synthesize _id;
@synthesize _name;
@synthesize _mobile;
@synthesize _tel;
@synthesize _address;
@synthesize _birthday;
@synthesize _idenfityCard;
@synthesize _email;
@synthesize _status;
@synthesize _sex;
@synthesize _partyId;
@synthesize _partyName;
@synthesize _forCC;
@synthesize locationManager;

+ (Employee *)loadEmployee:(NSData *) responseData
{
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil) { return nil; } 
    //NSLog(@"%@", doc.rootElement);
    
    NSArray *employeeMembers = [doc.rootElement elementsForName:@"ModJsonEmployee"];
    for (GDataXMLElement *employeeMember in employeeMembers) {
        Employee *employee = [[Employee alloc] init];
        //id
        NSArray *ids = [employeeMember elementsForName:@"ID"];
        if (ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ids objectAtIndex:0];
            employee._id = firstId.stringValue;
        } else {
            employee._id = @"";
        }
        
        //name
        NSArray *names = [employeeMember elementsForName:@"Name"];
        if (names.count > 0) {
            GDataXMLElement *firstName = (GDataXMLElement *) [names objectAtIndex:0];
            employee._name = firstName.stringValue;
        } else {
            employee._name = @"";
        }
        
        //mobile
        NSArray *mobiles = [employeeMember elementsForName:@"Mobile"];
        if (mobiles.count > 0) {
            GDataXMLElement *firstMobile = (GDataXMLElement *) [mobiles objectAtIndex:0];
            employee._mobile = firstMobile.stringValue;
        } else {
            employee._mobile = @"";
        }
        
        //tel
        NSArray *tels = [employeeMember elementsForName:@"Tel"];
        if (tels.count > 0) {
            GDataXMLElement *firstTel = (GDataXMLElement *) [tels objectAtIndex:0];
            employee._tel = firstTel.stringValue;
        } else {
            employee._tel = @"";
        }
        
        //address
        NSArray *addresses = [employeeMember elementsForName:@"Address"];
        if (addresses.count > 0) {
            GDataXMLElement *firstAddress = (GDataXMLElement *) [addresses objectAtIndex:0];
            employee._address = firstAddress.stringValue;
        } else {
            employee._address = @"";
        }
        
        //birthday
        NSArray *birthdays = [employeeMember elementsForName:@"Birthday"];
        if (birthdays.count > 0) {
            GDataXMLElement *firstBirthday = (GDataXMLElement *) [birthdays objectAtIndex:0];
            employee._birthday = firstBirthday.stringValue;
        } else {
            employee._birthday = @"";
        }
        
        //IdenfityCard
        NSArray *idenfityCards = [employeeMember elementsForName:@"IdenfityCard"];
        if (idenfityCards.count > 0) {
            GDataXMLElement *firstIdenfityCard = (GDataXMLElement *) [idenfityCards objectAtIndex:0];
            employee._idenfityCard = firstIdenfityCard.stringValue;
        } else {
            employee._idenfityCard = @"";
        }
        
        //Email
        NSArray *emails = [employeeMember elementsForName:@"Email"];
        if (emails.count > 0) {
            GDataXMLElement *firstEmail = (GDataXMLElement *) [emails objectAtIndex:0];
            employee._email = firstEmail.stringValue;
        } else {
            employee._email = @"";
        }
        
        //Status
        NSArray *statuses = [employeeMember elementsForName:@"Status"];
        if (statuses.count > 0) {
            GDataXMLElement *firstStatus = (GDataXMLElement *) [statuses objectAtIndex:0];
            employee._status = firstStatus.stringValue;
        } else {
            employee._status = @"";
        }
        
        //sex
        NSArray *sexs = [employeeMember elementsForName:@"Sex"];
        if (sexs.count > 0) {
            GDataXMLElement *firstSex = (GDataXMLElement *) [sexs objectAtIndex:0];
            employee._sex = firstSex.stringValue;
        } else {
            employee._sex = @"";
        }
        
        //partyId
        NSArray *partyIds = [employeeMember elementsForName:@"Partyid"];
        if (partyIds.count > 0) {
            GDataXMLElement *firstPartyId = (GDataXMLElement *) [partyIds objectAtIndex:0];
            employee._partyId = firstPartyId.stringValue;
        } else {
            employee._partyId = @"";
        }
        //partyName
        NSArray *partyNames = [employeeMember elementsForName:@"PartyName"];
        if (partyNames.count > 0) {
            GDataXMLElement *firstPartyId = (GDataXMLElement *) [partyNames objectAtIndex:0];
            employee._partyName = firstPartyId.stringValue;
        } else {
            employee._partyName = @"";
        }
        [Employee insertEmployee:employee];
    }
    
    return nil;
}

+ (void)synchronizeEmployee
{
    [Employee deleteAllEmployee];
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Employee.asmx/EmployeeData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
}

+ (void)sendDeviceInfo:(NSString *) userId withDeviceType:(NSString *) deviceType withDeviceToken:(NSString *) deviceToken {
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"Calendar.asmx/addDescription"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    userId, @"calid",
                                    deviceType, @"employeeID",
                                    deviceToken, @"context",
                                    nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary 
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString ==== %@", jsonString);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:jsonString forKey:@"con"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
}

+ (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        [Employee loadEmployee:responseData];
    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法访问，请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
    }
    NSLog(@"request finished");
}

+ (NSMutableArray *) getAllEmployee {
    NSMutableArray *employeeList = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *querySQL = @"SELECT * FROM EMPLOYEE;";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) 
        {
            while (sqlite3_step(statement) == SQLITE_ROW) 
            {
                Employee *employee = [[Employee alloc] init];
                // id
                NSString *idField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                employee._id = idField;
                // name
                NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                employee._name = nameField;
                // mobile
                NSString *mobileField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                employee._mobile = mobileField;
                // tel
                NSString *telField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                employee._tel = telField;
                // address
                NSString *addressField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                employee._address = addressField;
                // birthday
                NSString *birthdayField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                employee._birthday = birthdayField;  
                // idenfityCard
                NSString *idenfityCardField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                employee._idenfityCard = idenfityCardField;
                // email
                NSString *emailField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                employee._email = emailField;
                // status
                NSString *statusField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                employee._status = statusField;
                // sex
                NSString *sexField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                employee._sex = sexField;
                // partyId
                NSString *partyIdField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                employee._partyId = partyIdField;
                // partyName
                NSString *partyNameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                employee._partyName = partyNameField;
                
                [employeeList addObject:employee];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(hzoaDB);
    }

    return employeeList;
}

+ (void)insertEmployee:(Employee *) employee {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) {
        NSString *employeeId = employee._id;
        NSString *name = employee._name;
        NSString *mobile = employee._mobile;
        NSString *tel = employee._tel;
        NSString *address = employee._address;
        NSString *birthday = employee._birthday;
        NSString *idenfityCard = employee._idenfityCard;
        NSString *email = employee._email;
        NSString *status = employee._status;
        NSString *sex = employee._sex;
        NSString *partyId = employee._partyId;
        NSString *partyName = employee._partyName;
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO EMPLOYEE VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")", employeeId, name, mobile, tel, address, birthday, idenfityCard, email, status, sex, partyId, partyName];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(hzoaDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        } 
        sqlite3_finalize(statement);
        sqlite3_close(hzoaDB);
    }
}

+ (void)deleteAllEmployee {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        const char *query = "DELETE FROM EMPLOYEE;";
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

+ (void)dropEmployeeTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *dropSql = @"DROP TABLE IF EXISTS EMPLOYEE;";
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

+ (void)createEmployeeTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) 
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS EMPLOYEE(ID VARCHAR(20) PRIMARY KEY, NAME TEXT, MOBILE TEXT, TEL TEXT, ADDRESS TEXT, BIRTHDAY TEXT, IDENFITYCARD TEXT, EMAIL TEXT, STATUS TEXT, SEX TEXT, PARTYID TEXT, PARTYNAME TEXT);";
        if (sqlite3_exec(hzoaDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else 
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void)createTmpContactTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS TMPEMPLOYEE(ID VARCHAR(20), NAME TEXT, FORCC VARCHAR(5));";
        if (sqlite3_exec(hzoaDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void)insertTmpContact:(Employee *) employee {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) {
        NSString *employeeId = employee._id;
        NSString *name = employee._name;
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO TMPEMPLOYEE VALUES(\"%@\",\"%@\",\"%@\")", employeeId, name, employee._forCC];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(hzoaDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(hzoaDB);
    }
}

+ (void)deleteTmpContactByName:(NSString *) employeeName {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM TMPEMPLOYEE WHERE NAME = \"%@\";", employeeName];
        const char *query = [deleteSQL UTF8String];
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

+ (void)deleteTmpContact:(NSString *) employeeId withForCC:(NSString *) forCC; {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM TMPEMPLOYEE WHERE ID = \"%@\" AND FORCC = \"%@\";", employeeId, forCC];
        const char *query = [deleteSQL UTF8String];
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
+ (NSMutableArray *) getTmpContactByCC:(NSString *) forCC {
    NSMutableArray *employeeList = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM TMPEMPLOYEE WHERE FORCC = \"%@\";", forCC];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                Employee *employee = [[Employee alloc] init];
                // id
                NSString *idField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                employee._id = idField;
                // name
                NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                employee._name = nameField;
                [employeeList addObject:employee];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(hzoaDB);
    }
    
    return employeeList;
}

+ (NSMutableArray *) getAllTmpContact {
    NSMutableArray *employeeList = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT * FROM TMPEMPLOYEE;";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                Employee *employee = [[Employee alloc] init];
                // id
                NSString *idField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                employee._id = idField;
                // name
                NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                employee._name = nameField;
                [employeeList addObject:employee];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(hzoaDB);
    }
    
    return employeeList;
}

+ (void) deleteAllTmpContact {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK)
    {
        const char *query = "DELETE FROM TMPEMPLOYEE;";
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

+ (void)createMostContactTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS MOSTCONTACT(ID VARCHAR(20) PRIMARY KEY, NAME TEXT);";
        if (sqlite3_exec(hzoaDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (void)insertMostContact:(Employee *) employee {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) {
        NSString *employeeId = employee._id;
        NSString *name = employee._name;
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO MOSTCONTACT VALUES(\"%@\",\"%@\")", employeeId, name];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(hzoaDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(hzoaDB);
    }
}

+ (void)deleteMostContact:(Employee *) employee {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM MOSTCONTACT WHERE ID = \"%@\";", employee._id];
        const char *query = [deleteSQL UTF8String];
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

+ (NSMutableArray *) getAllMostContact {
    NSMutableArray *employeeList = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT * FROM MOSTCONTACT;";
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                Employee *employee = [[Employee alloc] init];
                // id
                NSString *idField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                employee._id = idField;
                // name
                NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                employee._name = nameField;
                [employeeList addObject:employee];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(hzoaDB);
    }
    
    return employeeList;
}



@end
