//
//  Customer.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-14.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "Customer.h"

@implementation Customer

@synthesize customerId;
@synthesize name;
@synthesize deviceToken;
@synthesize deviceType;
@synthesize LoginType;
@synthesize Location;
@synthesize EmpID;

+ (NSMutableArray *) getAllCustomer {
    NSMutableArray *customerList = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"ClientCompact.asmx/getClientInfo"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    //NSLog(@"%@", [request responseString]);
    if (request.responseStatusCode == 200) {
        customerList = [self loadCustomer:[request responseData]];
    }
    return customerList;
}

+ (NSMutableArray *) loadCustomer:(NSData *) responseData {
    NSMutableArray *customerList = [[NSMutableArray alloc] initWithCapacity:20];
    
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData options:0 error:&error];
    if (doc == nil) { return nil; }
    NSArray *dataMembers = [doc.rootElement elementsForName:@"ModJsonClientIOS"];
    for (GDataXMLElement *dataMember in dataMembers) {
        Customer *customer = [[Customer alloc] init];
        //id
        NSArray *ids = [dataMember elementsForName:@"id"];
        if (ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [ids objectAtIndex:0];
            customer.customerId = firstId.stringValue;
        } else {
            customer.customerId = @"";
        }
        //name
        NSArray *names = [dataMember elementsForName:@"name"];
        if (ids.count > 0) {
            GDataXMLElement *firstId = (GDataXMLElement *) [names objectAtIndex:0];
            customer.name = firstId.stringValue;
        } else {
            customer.name = @"";
        }
        [customerList addObject:customer];
    }
    
    return customerList;
}

+ (void) takeStatus:(Customer *) customer {
    NSString *webserviceUrl = [[NSUtil chooseRealm] stringByAppendingString:@"UserCheck.asmx/ChangeLoginType"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:customer.LoginType forKey:@"LoginType"];
    [request setPostValue:customer.deviceType forKey:@"deviceType"];
    [request setPostValue:customer.deviceToken forKey:@"deviceToken"];
    [request setPostValue:customer.EmpID forKey:@"EmpID"];
    [request setPostValue:customer.Location forKey:@"Location"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
}

@end
