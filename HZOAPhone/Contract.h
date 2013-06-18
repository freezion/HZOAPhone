//
//  Contract.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-15.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GDataXMLNode.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface Contract : NSObject {
    NSString *compactNum;
    NSString *contractId;
    NSString *startDate;
    NSString *endDate;
}

@property (nonatomic, retain) NSString *compactNum;
@property (nonatomic, retain) NSString *contractId;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;

+ (NSMutableArray *) getContractIdByCustomer:(NSString *) customerId;

+ (Contract *) getContractInfoByContractId:(NSString *) contractId;

@end
