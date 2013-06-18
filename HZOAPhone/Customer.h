//
//  Customer.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-14.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GDataXMLNode.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface Customer : NSObject {
    NSString *customerId;
    NSString *name;
    
    NSString *LoginType;
    NSString *deviceType;
    NSString *deviceToken;
    NSString *EmpID;
    NSString *Location;
}

@property (nonatomic, retain) NSString *customerId;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *LoginType;
@property (nonatomic, retain) NSString *deviceType;
@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, retain) NSString *EmpID;
@property (nonatomic, retain) NSString *Location;

+ (NSMutableArray *) getAllCustomer;

+ (void) takeStatus:(Customer *) customer;

@end
