//
//  NSUtil.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-31.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "NSUtil.h"

@implementation NSUtil

+ (NSString *) chooseRealm {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    NSString *webAddress = [usernamepasswordKVPairs objectForKey:KEY_WEBSERVICE_ADDRESS];
    return webAddress;
}

+ (NSString *) chooseFileRealm {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    NSString *fileAddress = [usernamepasswordKVPairs objectForKey:KEY_FILE_ADDRESS];
    return fileAddress;
    
}

+ (NSDate *)beginningOfMonth
{
    NSDate *curDate = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *beginning = nil;
    if ([cal rangeOfUnit:NSMonthCalendarUnit startDate:&beginning interval:NULL forDate:curDate])
        return beginning;
    return nil;
}

+ (NSDate *)endOfMonth {
    NSDate *curDate = [self beginningOfMonth];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange month = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:curDate];
    return [curDate dateByAddingTimeInterval:month.length * 24 * 60 * 60 - 1];
}

+ (NSString *)addLT:(NSString *) data {
    NSString *value = @"";
    value = [@"<" stringByAppendingString:data];
    value = [value stringByAppendingString:@">"];
    return value;
}

+ (NSString *)removeReceiveId:(NSString *) allId withReplace:(NSString *) receiveId {
    NSString *value = @"";
    receiveId = [self addLT:receiveId];
    value = [allId stringByReplacingOccurrencesOfString:receiveId withString:@""];
    return value;
}

+ (NSString *) parserDateToTimeString:(NSDate *) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"HH:mm"];
    return [formatter stringFromDate:date];
}

+ (NSString *) parserDateToString:(NSDate *) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:date];
}

+ (NSDate *) parserStringToDate:(NSString *) dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:timeZone];
    NSDate *dateTime = [formatter dateFromString:dateString];
    return dateTime;
}

+ (NSDate *) parserStringToNeedDate:(NSDate *) currentDate {
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:00:00"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    date = [self parserStringToDate:dateString];
    
    return date;
}

+ (NSDate *) parserStringToCustomDate:(NSString *) currentDateStr withParten:(NSString *) parten {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:parten];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    return [dateFormatter dateFromString:currentDateStr];
}

+ (NSDate *) parserStringToAppendDate:(NSString *) currentDateStr withParten:(NSString *) parten {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年M月d日 HH:mm"];
    NSTimeZone *currentDateTimeZone = [NSTimeZone defaultTimeZone];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setTimeZone:currentDateTimeZone];
    currentDateStr = [currentDateStr stringByAppendingString:parten];
    NSDate *date = [dateFormatter dateFromString:currentDateStr];
    return date;
}

+ (NSString *) parserDateToCustomString:(NSDate *) currentDate withParten:(NSString *) parten {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:parten];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    return [dateFormatter stringFromDate:currentDate];
}

+ (NSString *) parserStringToCustomString:(NSString *) currentDateStr withParten:(NSString *) parten {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat : parten];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *dateTime = [formatter dateFromString:currentDateStr];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [formatter stringFromDate:dateTime];
}

+ (NSString *) parserStringToCustomStringAdv:(NSString *) currentDateStr withParten:(NSString *) parten  withToParten:(NSString *) toParten {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateFormat : parten];
    [formatter setTimeZone:timeZone];
    NSDate *dateTime = [formatter dateFromString:currentDateStr];
    [formatter setDateFormat:toParten];
    
    return [formatter stringFromDate:dateTime];
}

+ (NSString *)uuidString {
    // Returns a UUID
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidStr;
}

+ (NSString *)getDBPath {
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hzoa.db"]];
    return databasePath;
}

+ (NSString *) subStringLast:(NSString *) str {
    NSString *newString = nil;
    if ([str length] > 0) {
        newString = [str substringWithRange:NSMakeRange(0, [str length] - 1)];
    } else {
        newString = @"<无>";
    }
    return newString;
}

+ (NSString *)appNameAndVersionNumberDisplayString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return [NSString stringWithFormat:@"%@, Version %@ (%@)",
            appDisplayName, majorVersion, minorVersion];
}

@end
