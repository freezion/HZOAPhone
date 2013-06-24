//
//  Contract.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-15.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "Contract.h"

@implementation Contract

@synthesize compactNum;
@synthesize contractId;
@synthesize startDate;
@synthesize endDate;

+ (NSMutableArray *) getContractIdByCustomer:(NSString *) customerId {
    NSMutableArray *contractList = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"ClientCompact.asmx/getCompactByClientID"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"customerId ==== %@", customerId);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:customerId forKey:@"id"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    NSLog(@"%@", [request responseString]);
    if (request.responseStatusCode == 200) {
        contractList = [self loadContract:[request responseData]];
    }
    return contractList;
}

+ (NSMutableArray *) loadContract:(NSData *) responseData {
    NSMutableArray *contractList = [[NSMutableArray alloc] initWithCapacity:20];
    
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil) { return nil; }
    NSArray *dataMembers = [doc.rootElement elementsForName:@"ModJsonCompactForIOS"];
    for (GDataXMLElement *dataMember in dataMembers) {
        Contract *contract = [[Contract alloc] init];
        //compactNum
        NSArray *compactNums = [dataMember elementsForName:@"compactNum"];
        if (compactNums.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [compactNums objectAtIndex:0];
            contract.compactNum = firstId.stringValue;
        } else {
            contract.compactNum = @"";
        }
        //id
        NSArray *ids = [dataMember elementsForName:@"id"];
        if (ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ids objectAtIndex:0];
            contract.contractId = firstId.stringValue;
        } else {
            contract.contractId = @"";
        }
        [contractList addObject:contract];
    }
    return contractList;
}

+ (Contract *) getContractInfoByContractId:(NSString *) contractId {
    Contract *contract = [[Contract alloc] init];
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"ClientCompact.asmx/getCompactTimeByID"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:contractId forKey:@"id"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    if (request.responseStatusCode == 200) {
        contract = [self loadContractInfo:[request responseData]];
    }
    return contract;
}

+ (Contract *) loadContractInfo:(NSData *) responseData {
    NSMutableArray *contractList = [[NSMutableArray alloc] initWithCapacity:20];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil) { return nil; }
    NSArray *dataMembers = [doc.rootElement elementsForName:@"ModJsonProjectTime"];
    for (GDataXMLElement *dataMember in dataMembers) {
        Contract *contract = [[Contract alloc] init];
        //startTime
        NSArray *startTimes = [dataMember elementsForName:@"startTime"];
        if (startTimes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [startTimes objectAtIndex:0];
            NSString *firstString = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            contract.startDate = firstString;
        } else {
            contract.startDate = @"";
        }
        
        //endTime
        NSArray *endTimes = [dataMember elementsForName:@"endTime"];
        if (endTimes.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [endTimes objectAtIndex:0];
            NSString *firstString = [firstId.stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            contract.endDate = firstString;
        } else {
            contract.endDate = @"";
        }
        [contractList addObject:contract];
    }
    Contract *contract = [[Contract alloc] init];
    if ([contractList count] != 0) {
        contract = [contractList objectAtIndex:0];
    } 
    return contract;
}

+ (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

@end
