//
//  Calendar.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-30.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "Calendar.h"

@implementation Calendar

@synthesize ID;
@synthesize Title;
@synthesize Note;
@synthesize StartTime;
@synthesize EndTime;
@synthesize Reminder;
@synthesize Location;
@synthesize AllDay;
@synthesize Type;
@synthesize Employee_Id;
@synthesize Employee_Name;
@synthesize Readed;
@synthesize import;
@synthesize senderId;
@synthesize senderName;
@synthesize CustomerId;
@synthesize ProjectId;
@synthesize ProjectNum;
@synthesize ProjectEndTime;
@synthesize ProjectStartTime;
@synthesize CustomerName;
@synthesize IsRead;
@synthesize TypeName;
@synthesize ClientId;
@synthesize ClientName;
@synthesize message;

+ (void)addServiceCarlendar:(NSString *) calendarId withIOSId:(NSString *) netId withEmployeeId:(NSString *) employeeId withEventStoreId:(NSString *) eventStoreId {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"CalendaridIos.asmx/addData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"]; 
    [request setPostValue:netId forKey:@"IOSId"];
    [request setPostValue:employeeId forKey:@"employeeId"];
    [request setPostValue:calendarId forKey:@"calendarId"];
    [request setPostValue:eventStoreId forKey:@"eventStoreId"];
    [request setPostValue:@"1" forKey:@"status"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    if(request.responseStatusCode == 200)
    {
        //NSLog(@"%@", [request responseString]);
    }
}

+ (NSString *)selectServiceCarlendar:(NSString *) netId withEmployeeId:(NSString *) employeeId  withEventStoreId:(NSString *) eventStoreId {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"CalendaridIos.asmx/getIOSId"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSString *calendarId = @"";
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"]; 
    [request setPostValue:netId forKey:@"calendarId"];
    [request setPostValue:employeeId forKey:@"employeeId"];
    [request setPostValue:eventStoreId forKey:@"eventStoreId"];
    [request setPostValue:@"1" forKey:@"status"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    NSError *error;
    if(request.responseStatusCode == 200)
    {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:[request responseString] options:0 error:&error];
        GDataXMLElement *root = [doc rootElement];
        calendarId = [root stringValue];
    }
    return calendarId;
}

+ (CalendarRelationship *)selectServiceCarlendarByIOSId:(NSString *) IOSId withEmployeeId:(NSString *) employeeId  withEventStoreId:(NSString *) eventStoreId {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"CalendaridIos.asmx/getSearchData"];
    CalendarRelationship *cs = [[CalendarRelationship alloc] init]; 
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSString *calendarValue = @"";
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"]; 
    [request setPostValue:IOSId forKey:@"id"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    NSError *error;
    if(request.responseStatusCode == 200)
    {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:[request responseString] options:0 error:&error];
        GDataXMLElement *root = [doc rootElement];
        calendarValue = [root stringValue];
        if ([calendarValue isEqualToString:@""]) {
            return nil;
        } else {
            NSArray *arrayList = [calendarValue componentsSeparatedByString:@","];
            cs.calendarId = [arrayList objectAtIndex:0];
            cs.IOSId = [arrayList objectAtIndex:1];
            cs.status = [arrayList objectAtIndex:2];
        }
    }
    return cs;
}

+ (void)deleteServiceCarlendar:(NSString *) netId withEmployeeId:(NSString *) employeeId withEventStoreId:(NSString *) eventStoreId {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"CalendaridIos.asmx/delData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:netId forKey:@"id"];
    [request setPostValue:eventStoreId forKey:@"eventStoreId"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    if(request.responseStatusCode == 200)
    {
        //NSLog(@"delete = = = %@", [request responseString]);
    }
}

+ (NSMutableArray *)loadCalendarRelationship:(NSData *) responseData {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil) { return nil; }
    NSArray *calendarMembers = [doc.rootElement elementsForName:@"ModJsonCalendarIdIOS"];
    for (GDataXMLElement *calendarMember in calendarMembers) {
        CalendarRelationship *calendarRelationship = [[CalendarRelationship alloc] init];
        //calendarId
        NSArray *calendarIds = [calendarMember elementsForName:@"calendarId"];
        if (calendarIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [calendarIds objectAtIndex:0];
            calendarRelationship.calendarId = firstId.stringValue;
        } else {
            calendarRelationship.calendarId = @"";
        }
        //IOSId
        NSArray *IOSIds = [calendarMember elementsForName:@"IOSId"];
        if (IOSIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [IOSIds objectAtIndex:0];
            calendarRelationship.IOSId = firstId.stringValue;
        } else {
            calendarRelationship.IOSId = @"";
        }
        //[self deleteCalendarRelationship:calendarRelationship.calendarId];
        //[self insertCalendarRelationship:calendarRelationship.calendarId withLocalId:calendarRelationship.IOSId];
    }
    return dataList;

}

+ (void) syncEventsToServer:(NSString *) employeeId {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKCalendar *defaultCalendar;
    NSArray *listCalendars = [eventStore calendars];
    for (EKCalendar *calendar in listCalendars) {
        NSLog(@"%@", calendar.title);
        if ([calendar.title isEqualToString:KEY_CALENDAR]) {
            defaultCalendar = calendar;
            break;
        }
    }
    NSArray *calendarArray = [NSArray arrayWithObject:defaultCalendar];
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:[NSUtil beginningOfMonth] endDate:[NSUtil endOfMonth] calendars:calendarArray]; 
    
    NSArray *events = [eventStore eventsMatchingPredicate:predicate];
    
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    for (EKEvent *event in events) {
        CalendarRelationship *cs = [Calendar selectServiceCarlendarByIOSId:event.eventIdentifier withEmployeeId:employeeId withEventStoreId:eventStore.eventStoreIdentifier];
        EKAlarm *ekAlarm = [event.alarms objectAtIndex:0];
        NSTimeInterval offset = [ekAlarm relativeOffset];
        NSString *time = @"";
        if (offset) {
            time = [NSString stringWithFormat:@"%.0f", fabs(offset)];
        }
        Calendar *calendar = [[Calendar alloc] init];
        calendar.ID = cs.calendarId;
        calendar.Title = event.title;
        if (event.notes == nil) {
            calendar.Note = @"";
        } else {
             calendar.Note = event.notes;
        }
        calendar.StartTime = [NSUtil parserDateToString:event.startDate];
        calendar.EndTime = [NSUtil parserDateToString:event.endDate];
        calendar.Reminder = time;
        if (event.location == nil) {
            calendar.Location = @"";
        } else {
            calendar.Location = event.location;
        }
        if (event.allDay) {
            calendar.AllDay = @"1";
        } else {
            calendar.AllDay = @"0";
        }
        calendar.Type = @"1";
        calendar.Employee_Id = [usernamepasswordKVPairs objectForKey:KEY_USERID];
        calendar.Readed = [usernamepasswordKVPairs objectForKey:KEY_USERID];
        calendar.import = @"0";
        calendar.senderId = [usernamepasswordKVPairs objectForKey:KEY_USERID];
        calendar.senderName = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
        if (cs) {  
            if (![cs.status isEqualToString:@"0"]) {
                [self updateCalendar:calendar];
            }
        } else {
            calendar.ID = event.eventIdentifier;
            [Calendar addCalendar:calendar withEmployeeId:employeeId withEventStoreId:eventStore.eventStoreIdentifier];
        }
    }
}

+ (NSMutableArray *) getCalendarDataByDateTime:(NSDate *) startDate withEndDate:(NSDate *) endDate withEmployeeId:(NSString *) employeeId withCalendar:(EKCalendar *) calendar {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/searchData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSString *start = [NSUtil parserDateToString:startDate];
    NSString *end = [NSUtil parserDateToString:endDate];
    NSMutableArray *events = [[NSMutableArray alloc] initWithCapacity:20];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:start forKey:@"startTime"];
    [request setPostValue:end forKey:@"endTime"];
    [request setPostValue:employeeId forKey:@"employeeId"];
    [request setPostValue:@"9992" forKey:@"type"];
    [request setPostValue:@"9992" forKey:@"import"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    //NSLog(@"responseString === %@", [request responseString]);
    
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        events = [Calendar loadCalendar:responseData withCalendar:calendar withSync:NO withEmployeeId:employeeId];
    }
    
    return events;
}

+ (Calendar *)loadSingleCalendar:(NSData *) responseData {
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil) { return nil; }
        Calendar *calendar = [[Calendar alloc] init];
        GDataXMLElement *calendarMember = doc.rootElement;
        //ID
        NSArray *ids = [calendarMember elementsForName:@"ID"];
        if (ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ids objectAtIndex:0];
            calendar.ID = firstId.stringValue;
        } else {
            calendar.ID = @"";
        }
        //Title
        NSArray *Titles = [calendarMember elementsForName:@"Title"];
        if (Titles.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Titles objectAtIndex:0];
            calendar.Title = firstId.stringValue;
        } else {
            calendar.Title = @"";
        }
        //Note
        NSArray *Notes = [calendarMember elementsForName:@"Note"];
        if (Notes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Notes objectAtIndex:0];
            calendar.Note = firstId.stringValue;
        } else {
            calendar.Note = @"";
        }
        //StartTime
        NSArray *StartTimes = [calendarMember elementsForName:@"StartTime"];
        if (StartTimes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [StartTimes objectAtIndex:0];
            NSString *firstString = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            calendar.StartTime = firstString;
        } else {
            calendar.StartTime = @"";
        }
        //EndTime
        NSArray *EndTimes = [calendarMember elementsForName:@"EndTime"];
        if (EndTimes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [EndTimes objectAtIndex:0];
            NSString *firstString = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            calendar.EndTime = firstString;
        } else {
            calendar.EndTime = @"";
        }
        //Reminder
        NSArray *Reminders = [calendarMember elementsForName:@"Reminder"];
        if (Reminders.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Reminders objectAtIndex:0];
            calendar.Reminder = firstId.stringValue;
        } else {
            calendar.Reminder = @"";
        }
        //Location
        NSArray *Locations = [calendarMember elementsForName:@"Location"];
        if (Locations.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Locations objectAtIndex:0];
            calendar.Location = firstId.stringValue;
        } else {
            calendar.Location = @"";
        }
        //AllDay
        NSArray *AllDays = [calendarMember elementsForName:@"AllDay"];
        if (AllDays.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [AllDays objectAtIndex:0];
            calendar.AllDay = firstId.stringValue;
        } else {
            calendar.AllDay = @"";
        }
        //Type
        NSArray *Types = [calendarMember elementsForName:@"Type"];
        if (Types.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Types objectAtIndex:0];
            calendar.Type = firstId.stringValue;
        } else {
            calendar.Type = @"";
        }
        //TypeName
        NSArray *TypeNames = [calendarMember elementsForName:@"TypeName"];
        if (TypeNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [TypeNames objectAtIndex:0];
            calendar.TypeName = firstId.stringValue;
        } else {
            calendar.TypeName = @"";
        }
        //Employee_Id
        NSArray *Employee_Ids = [calendarMember elementsForName:@"Employee_Id"];
        if (Employee_Ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Employee_Ids objectAtIndex:0];
            calendar.Employee_Id = firstId.stringValue;
        } else {
            calendar.Employee_Id = @"";
        }
        //Employee_Name
        NSArray *Employee_Names = [calendarMember elementsForName:@"Employee_Name"];
        if (Employee_Names.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Employee_Names objectAtIndex:0];
            calendar.Employee_Name = firstId.stringValue;
        } else {
            calendar.Employee_Name = @"";
        }
        //Readed
        NSArray *Readeds = [calendarMember elementsForName:@"Readed"];
        if (Readeds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Readeds objectAtIndex:0];
            calendar.Readed = firstId.stringValue;
        } else {
            calendar.Readed = @"";
        }
        //IsRead
        NSArray *IsReads = [calendarMember elementsForName:@"IsRead"];
        if (IsReads.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [IsReads objectAtIndex:0];
            calendar.IsRead = firstId.stringValue;
        } else {
            calendar.IsRead = @"";
        }
        //import
        NSArray *imports = [calendarMember elementsForName:@"import"];
        if (imports.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [imports objectAtIndex:0];
            calendar.import = firstId.stringValue;
        } else {
            calendar.import = @"";
        }
        //senderId
        NSArray *senderIds = [calendarMember elementsForName:@"senderId"];
        if (senderIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [senderIds objectAtIndex:0];
            calendar.senderId = firstId.stringValue;
        } else {
            calendar.senderId = @"";
        }
        //senderName
        NSArray *senderNames = [calendarMember elementsForName:@"senderName"];
        if (senderNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [senderNames objectAtIndex:0];
            calendar.senderName = firstId.stringValue;
        } else {
            calendar.senderName = @"";
        }
        //CustomerId
        NSArray *CustomerIds = [calendarMember elementsForName:@"CustomerId"];
        if (CustomerIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [CustomerIds objectAtIndex:0];
            calendar.CustomerId = firstId.stringValue;
        } else {
            calendar.CustomerId = @"";
        }
        //ProjectId
        NSArray *ProjectIds = [calendarMember elementsForName:@"ProjectId"];
        if (ProjectIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ProjectIds objectAtIndex:0];
            calendar.ProjectId = firstId.stringValue;
        } else {
            calendar.ProjectId = @"";
        }
        //CustomerName
        NSArray *CustomerNames = [calendarMember elementsForName:@"CustomerName"];
        if (CustomerNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [CustomerNames objectAtIndex:0];
            calendar.CustomerName = firstId.stringValue;
        } else {
            calendar.CustomerName = @"";
        }
        //ProjectNum
        NSArray *ProjectNums = [calendarMember elementsForName:@"ProjectNum"];
        if (ProjectNums.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ProjectNums objectAtIndex:0];
            calendar.ProjectNum = firstId.stringValue;
        } else {
            calendar.ProjectNum = @"";
        }
        //ProjectStartTime
        NSArray *ProjectStartTimes = [calendarMember elementsForName:@"ProjectStartTime"];
        if (ProjectStartTimes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ProjectStartTimes objectAtIndex:0];
            NSString *firstString = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            calendar.ProjectStartTime = firstString;
        } else {
            calendar.ProjectStartTime = @"";
        }
        //ProjectEndTime
        NSArray *ProjectEndTimes = [calendarMember elementsForName:@"ProjectEndTime"];
        if (ProjectEndTimes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ProjectEndTimes objectAtIndex:0];
            NSString *firstString = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            calendar.ProjectEndTime = firstString;
        } else {
            calendar.ProjectEndTime = @"";
        }   
        //ClientId
        NSArray *ClientIds = [calendarMember elementsForName:@"ClientId"];
        if (ClientIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ProjectNums objectAtIndex:0];
            calendar.ClientId = firstId.stringValue;
        } else {
            calendar.ClientId = @"";
        }
        //ClientName
        NSArray *ClientNames = [calendarMember elementsForName:@"ClientName"];
        if (ClientNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ClientNames objectAtIndex:0];
            calendar.ClientName = firstId.stringValue;
        } else {
            calendar.ClientName = @"";
        }
        //messages
        NSArray *messages = [calendarMember elementsForName:@"message"];
        if (messages.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [messages objectAtIndex:0];
            calendar.message = firstId.stringValue;
        } else {
            calendar.message = @"";
        }
    return calendar;
}

+ (NSMutableArray *)loadCalendar:(NSData *) responseData withCalendar:(EKCalendar *) calendarType withSync:(BOOL) flag	withEmployeeId:(NSString *) employeeId {
    NSMutableArray *dataList = [[NSMutableArray alloc] initWithCapacity:20];
    NSError *error;
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    //NSLog(@"eventStore ==== %@", eventStore.eventStoreIdentifier);
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil) { return nil; }
    NSArray *calendarMembers = [doc.rootElement elementsForName:@"ModJsonCalendar"];
    for (GDataXMLElement *calendarMember in calendarMembers) {
        Calendar *calendar = [[Calendar alloc] init];
        //ID
        NSArray *ids = [calendarMember elementsForName:@"ID"];
        if (ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ids objectAtIndex:0];
            calendar.ID = firstId.stringValue;
        } else {
            calendar.ID = @"";
        }
        //Title
        NSArray *Titles = [calendarMember elementsForName:@"Title"];
        if (Titles.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Titles objectAtIndex:0];
            calendar.Title = firstId.stringValue;
        } else {
            calendar.Title = @"";
        }
        //Note
        NSArray *Notes = [calendarMember elementsForName:@"Note"];
        if (Notes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Notes objectAtIndex:0];
            calendar.Note = firstId.stringValue;
        } else {
            calendar.Note = @"";
        }
        //StartTime
        NSArray *StartTimes = [calendarMember elementsForName:@"StartTime"];
        if (StartTimes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [StartTimes objectAtIndex:0];
            NSString *firstString = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            calendar.StartTime = firstString;
        } else {
            calendar.StartTime = @"";
        }
        //EndTime
        NSArray *EndTimes = [calendarMember elementsForName:@"EndTime"];
        if (EndTimes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [EndTimes objectAtIndex:0];
            NSString *firstString = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            calendar.EndTime = firstString;
        } else {
            calendar.EndTime = @"";
        }
        //Reminder
        NSArray *Reminders = [calendarMember elementsForName:@"Reminder"];
        if (Reminders.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Reminders objectAtIndex:0];
            calendar.Reminder = firstId.stringValue;
        } else {
            calendar.Reminder = @"";
        }
        //Location
        NSArray *Locations = [calendarMember elementsForName:@"Location"];
        if (Locations.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Locations objectAtIndex:0];
            calendar.Location = firstId.stringValue;
        } else {
            calendar.Location = @"";
        }
        //AllDay
        NSArray *AllDays = [calendarMember elementsForName:@"AllDay"];
        if (AllDays.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [AllDays objectAtIndex:0];
            calendar.AllDay = firstId.stringValue;
        } else {
            calendar.AllDay = @"";
        }
        //Type
        NSArray *Types = [calendarMember elementsForName:@"Type"];
        if (Types.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Types objectAtIndex:0];
            calendar.Type = firstId.stringValue;
        } else {
            calendar.Type = @"";
        }
        //Employee_Id
        NSArray *Employee_Ids = [calendarMember elementsForName:@"Employee_Id"];
        if (Employee_Ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Employee_Ids objectAtIndex:0];
            calendar.Employee_Id = firstId.stringValue;
        } else {
            calendar.Employee_Id = @"";
        }
        //Readed
        NSArray *Readeds = [calendarMember elementsForName:@"Readed"];
        if (Readeds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [Readeds objectAtIndex:0];
            calendar.Readed = firstId.stringValue;
        } else {
            calendar.Readed = @"";
        }
        //IsRead
        NSArray *IsReads = [calendarMember elementsForName:@"IsRead"];
        if (IsReads.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [IsReads objectAtIndex:0];
            calendar.IsRead = firstId.stringValue;
        } else {
            calendar.IsRead = @"";
        }
        //import
        NSArray *imports = [calendarMember elementsForName:@"import"];
        if (imports.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [imports objectAtIndex:0];
            calendar.import = firstId.stringValue;
        } else {
            calendar.import = @"";
        }
        //senderId
        NSArray *senderIds = [calendarMember elementsForName:@"senderId"];
        if (senderIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [senderIds objectAtIndex:0];
            calendar.senderId = firstId.stringValue;
        } else {
            calendar.senderId = @"";
        }
        //senderName
        NSArray *senderNames = [calendarMember elementsForName:@"senderName"];
        if (senderNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [senderNames objectAtIndex:0];
            calendar.senderName = firstId.stringValue;
        } else {
            calendar.senderName = @"";
        }
        //CustomerId
        NSArray *CustomerIds = [calendarMember elementsForName:@"CustomerId"];
        if (CustomerIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [CustomerIds objectAtIndex:0];
            calendar.CustomerId = firstId.stringValue;
        } else {
            calendar.CustomerId = @"";
        }
        //ProjectId
        NSArray *ProjectIds = [calendarMember elementsForName:@"ProjectId"];
        if (ProjectIds.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ProjectIds objectAtIndex:0];
            calendar.ProjectId = firstId.stringValue;
        } else {
            calendar.ProjectId = @"";
        }
        //CustomerName
        NSArray *CustomerNames = [calendarMember elementsForName:@"CustomerName"];
        if (CustomerNames.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [CustomerNames objectAtIndex:0];
            calendar.CustomerName = firstId.stringValue;
        } else {
            calendar.CustomerName = @"";
        }
        //ProjectNum
        NSArray *ProjectNums = [calendarMember elementsForName:@"ProjectNum"];
        if (ProjectNums.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ProjectNums objectAtIndex:0];
            calendar.ProjectNum = firstId.stringValue;
        } else {
            calendar.ProjectNum = @"";
        }
        //ProjectStartTime
        NSArray *ProjectStartTimes = [calendarMember elementsForName:@"ProjectStartTime"];
        if (ProjectStartTimes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ProjectStartTimes objectAtIndex:0];
            NSString *firstString = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            calendar.ProjectStartTime = firstString;
        } else {
            calendar.ProjectStartTime = @"";
        }
        //ProjectEndTime
        NSArray *ProjectEndTimes = [calendarMember elementsForName:@"ProjectEndTime"];
        if (ProjectEndTimes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ProjectEndTimes objectAtIndex:0];
            NSString *firstString = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            calendar.ProjectEndTime = firstString;
        } else {
            calendar.ProjectEndTime = @"";
        }
        if (flag) {
            NSLog(@"calendar.ID ==== %@", calendar.ID);
            NSString *localId = [Calendar selectServiceCarlendar:calendar.ID withEmployeeId:employeeId withEventStoreId:eventStore.eventStoreIdentifier];
            NSLog(@"localId === %@", localId);
            if ([localId isEqualToString:@""]) {
                EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                event.calendar = calendarType;
                event.title = calendar.Title;
                event.notes = calendar.Note;
                event.startDate = [NSUtil parserStringToDate:calendar.StartTime];
                event.endDate = [NSUtil parserStringToDate:calendar.EndTime];
                if (![calendar.Reminder isEqualToString:@""]) {
                    float value = -[calendar.Reminder floatValue];
                    NSMutableArray *alarmsArray = [[NSMutableArray alloc] init];
                    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:value];
                    [alarmsArray addObject:alarm];
                    event.alarms = [NSArray arrayWithArray:alarmsArray];
                } else {
                    event.alarms = nil;
                }
                event.calendar = calendarType;
                event.location = calendar.Location;           
                if ([calendar.AllDay isEqualToString:@"1"]) {
                    event.allDay = YES;
                } else {
                    event.allDay = NO;
                }
                [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
                NSLog(@"save ID === %@", event.eventIdentifier);
                [Calendar addServiceCarlendar:calendar.ID withIOSId:event.eventIdentifier withEmployeeId:employeeId withEventStoreId:eventStore.eventStoreIdentifier];
            } else {
                EKEvent *event = [eventStore eventWithIdentifier:localId];
                NSLog(@"event === %@", event);
                [eventStore removeEvent:event span:EKSpanThisEvent error:&error];
                event = [EKEvent eventWithEventStore:eventStore];
                event.calendar = calendarType;
                event.title = calendar.Title;
                event.notes = calendar.Note;
                event.startDate = [NSUtil parserStringToDate:calendar.StartTime];
                event.endDate = [NSUtil parserStringToDate:calendar.EndTime];
                if (![calendar.Reminder isEqualToString:@""]) {
                    float value = -[calendar.Reminder floatValue];
                    NSMutableArray *alarmsArray = [[NSMutableArray alloc] init];
                    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:value];
                    [alarmsArray addObject:alarm];
                    event.alarms = [NSArray arrayWithArray:alarmsArray];
                } else {
                    event.alarms = nil;
                }
                event.calendar = calendarType;
                event.location = calendar.Location;           
                if ([calendar.AllDay isEqualToString:@"1"]) {
                    event.allDay = YES;
                } else {
                    event.allDay = NO;
                }
                [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
                NSLog(@"eventIdentifiered === %@", event.eventIdentifier);
                [Calendar deleteServiceCarlendar:calendar.ID withEmployeeId:employeeId withEventStoreId:eventStore.eventStoreIdentifier];
                [Calendar addServiceCarlendar:calendar.ID withIOSId:event.eventIdentifier withEmployeeId:employeeId withEventStoreId:eventStore.eventStoreIdentifier];
            }
        }
        [dataList addObject:calendar];
    }
    return dataList;
}

+ (Calendar *) getSingleCanlendar:(NSString *) calendarId {
    Calendar *calendarObj = [[Calendar alloc] init];
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/singleData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:calendarId forKey:@"id"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    NSLog(@"responseString === %@", [request responseString]);
    if(request.responseStatusCode == 200)
    {
        calendarObj = [self loadSingleCalendar:[request responseData]];
    }
    return calendarObj;
}

+ (void) senderMessage:(Calendar *) calendarObj withContext:(NSString *) context withEmployee:(NSString *) employeeId {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/addDescription"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    calendarObj.ID, @"calid",
                                    employeeId, @"employeeID",
                                    context, @"context",
                                    calendarObj.senderId, @"senderID",
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
    
    //NSLog(@"responseString === %@", [request responseString]);
}

+ (NSString *) addCalendar:(Calendar *) calendar withEmployeeId:(NSString *) employeeId withEventStoreId: (NSString *) eventStoreId {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/addCalendarJson"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    //@"123", @"ID",
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    
                                    calendar.Title, @"Title",
                                    calendar.Note, @"Note",
                                    calendar.StartTime , @"StartTime",
                                    calendar.EndTime, @"EndTime", 
                                    calendar.Reminder, @"Reminder",
                                    calendar.Location, @"Location",
                                    calendar.AllDay, @"AllDay",
                                    calendar.Type, @"Type",
                                    calendar.Employee_Id, @"Employee_Id",
                                    calendar.Readed, @"Readed",
                                    calendar.import, @"import",
                                    calendar.senderId, @"senderId",
                                    //calendar.CustomerId, @"CustomerId",
                                    calendar.ProjectId, @"ProjectId",
                                    nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary 
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonString ==== %@", jsonString);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:jsonString forKey:@"con"];
    [request buildPostBody];
    [request setTimeOutSeconds:10];
    [request setDelegate:self];
    [request startAsynchronous];
    
    NSLog(@"The Response String is: %@",[request responseString]);
    
    
    //NSLog(@"%@", request.responseStatusCode);
//    if(request.responseStatusCode == 200)
//    {
//        NSData *data = [request responseData];
//        NSLog(@"responseData === %@", data);
//        NSString *responseString = [request responseString];
//        NSLog(@"responseString === %@", responseString);
//        NSError *error;
//        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
//        GDataXMLElement *root = [doc rootElement];
//        [root stringValue];
//        NSString *netCalendarId = [root stringValue];
//        NSString *calendarId = calendar.ID;
//        // add to net DB
//        [Calendar addServiceCarlendar:netCalendarId withIOSId:calendarId withEmployeeId:employeeId withEventStoreId:eventStoreId];
        
//    }
    return @"";
}

+ (NSString *) updateCalendar:(Calendar *) calendar {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/updateCanlendarJSON"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    calendar.ID, @"ID",
                                    calendar.Title, @"Title",
                                    calendar.Note, @"Note",
                                    calendar.StartTime , @"StartTime",
                                    calendar.EndTime, @"EndTime", 
                                    calendar.Reminder, @"Reminder",
                                    calendar.Location, @"Location",
                                    calendar.AllDay, @"AllDay",
                                    calendar.Type, @"Type",
                                    calendar.Employee_Id, @"Employee_Id",
                                    calendar.Readed, @"Readed",
                                    calendar.import, @"import",
                                    calendar.senderId, @"senderId",
                                    //calendar.CustomerId, @"CustomerId",
                                    calendar.ProjectId, @"ProjectId",
                                    calendar.ClientName,@"ClientName",
                                    //calendar.ProjectNum, @"ProjectNum",
                                    nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary 
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonString === %@", jsonString);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:jsonString forKey:@"con"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startAsynchronous];
    //NSLog(@"%@", [request responseString]);
    return @"";
}

+ (NSString *) deleteCalendar:(NSString *) calendarId withEmployeeId:(NSString *) employeeId withEventStoreId:
(NSString *) eventStoreId {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/deleteCalendar"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:calendarId forKey:@"id"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
   
    if(request.responseStatusCode == 200)
    {
        [Calendar deleteServiceCarlendar:calendarId withEmployeeId:employeeId withEventStoreId:eventStoreId];
    }
    return @"";
}

+ (void) accpetEvent:(NSString *) eventId withEmployeeID:(NSString *) employeeId {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/readCalendar"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:eventId forKey:@"id"];
    [request setPostValue:employeeId forKey:@"EmployeeID"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startAsynchronous];
    
    //NSLog(@"responseString ==== %@", [request responseString]);
}

+ (void) rejectEvent:(NSString *) eventId withEmployeeID:(NSString *) employeeId {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/refuseCalendar"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:eventId forKey:@"id"];
    [request setPostValue:employeeId forKey:@"EmployeeID"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
}

+ (NSMutableArray *) getAllMyData:(NSString *) employeeId withStartDate:(NSDate *) startDate withEndDate:(NSDate *) endDate {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/allMyData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    NSString *start = [NSUtil parserDateToString:startDate];
    NSString *end = [NSUtil parserDateToString:endDate];
    NSMutableArray *events = [[NSMutableArray alloc] initWithCapacity:0];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:employeeId forKey:@"id"];
    [request setPostValue:start forKey:@"startTime"];
    [request setPostValue:end forKey:@"endTime"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        events = [Calendar loadCalendar:responseData withCalendar:nil withSync:NO withEmployeeId:employeeId];
    }
    return events;
}

+ (NSMutableArray *) allMySendData:(NSString *) employeeId withStartDate:(NSDate *) startDate withEndDate:(NSDate *) endDate {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/allMySendData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    NSString *start = [NSUtil parserDateToString:startDate];
    NSString *end = [NSUtil parserDateToString:endDate];
    NSMutableArray *events = [[NSMutableArray alloc] initWithCapacity:0];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:employeeId forKey:@"id"];
    [request setPostValue:start forKey:@"startTime"];
    [request setPostValue:end forKey:@"endTime"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        events = [Calendar loadCalendar:responseData withCalendar:nil withSync:NO withEmployeeId:employeeId];
    }
    return events;
}

+ (NSMutableArray *) allInvitedMeData:(NSString *) employeeId withStartDate:(NSDate *) startDate withEndDate:(NSDate *) endDate {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/allInvitedMeData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    NSString *start = [NSUtil parserDateToString:startDate];
    NSString *end = [NSUtil parserDateToString:endDate];
    NSMutableArray *events = [[NSMutableArray alloc] initWithCapacity:0];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];    
    [request setPostValue:employeeId forKey:@"id"];
    [request setPostValue:start forKey:@"startTime"];
    [request setPostValue:end forKey:@"endTime"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        events = [Calendar loadCalendar:responseData withCalendar:nil withSync:NO withEmployeeId:employeeId];
    }
    return events;
}

+ (NSMutableArray *) publicEventDate:(NSDate *) startDate withEndDate:(NSDate *) endDate {
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/GetOpenCalendar"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    NSString *start = [NSUtil parserDateToString:startDate];
    NSString *end = [NSUtil parserDateToString:endDate];
    NSMutableArray *events = [[NSMutableArray alloc] initWithCapacity:0];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:start forKey:@"startTime"];
    [request setPostValue:end forKey:@"endTime"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    if(request.responseStatusCode == 200)
    {
        NSData *responseData = [request responseData];
        events = [Calendar loadCalendar:responseData withCalendar:nil withSync:NO withEmployeeId:nil];
    }
    return events;
}

+ (Calendar *) getSinglePublicCalendar:(NSString *) calendarId {
    Calendar *calendarObj = [[Calendar alloc] init];
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"Calendar.asmx/singleOpenData"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:calendarId forKey:@"id"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    NSLog(@"responseString === %@", [request responseString]);
    if(request.responseStatusCode == 200)
    {
        calendarObj = [self loadSingleCalendar:[request responseData]];
    }
    return calendarObj;
}

+ (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
}

+ (void)createCalendarTable {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) 
    {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CALENDAR(NETID VARCHAR(50) PRIMARY KEY, LOCALID VARCHAR(50));";
        if (sqlite3_exec(hzoaDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
            NSLog(@"create failed!\n");
        }
    }
    else 
    {
        NSLog(@"创建/打开数据库失败");
    }
}

+ (NSString *) getNetCalendarId:(NSString *) localId {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    NSString *netIdField = @"";
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM CALENDAR WHERE LOCALID = \"%@\";", localId];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) 
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                netIdField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            } 
            sqlite3_finalize(statement);
        }
        sqlite3_close(hzoaDB);
    }
    return netIdField;
}

+ (NSString *) getLocalCalendarId:(NSString *) netId {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    NSString *localIdField = @"";
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM CALENDAR WHERE NETID = \"%@\";", netId];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(hzoaDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) 
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                localIdField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            } 
            sqlite3_finalize(statement);
        }
        sqlite3_close(hzoaDB);
    }
    return localIdField;
}

+ (void) insertCalendarRelationship:(NSString *) netId withLocalId:(NSString *) localId {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &hzoaDB)==SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO CALENDAR VALUES(\"%@\",\"%@\");", netId, localId];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(hzoaDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(hzoaDB);
    }
}

+ (void) deleteCalendarRelationship:(NSString *) netId {
    NSString *databasePath = [NSUtil getDBPath];
    sqlite3 *hzoaDB;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_open(dbpath, &hzoaDB) == SQLITE_OK) 
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM CALENDAR WHERE NETID = \"%@\";", netId];
        //NSLog(@"querySQL ==== %@", querySQL);
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

@end
