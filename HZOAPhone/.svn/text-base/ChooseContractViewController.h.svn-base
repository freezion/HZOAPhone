//
//  ChooseContractViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-15.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contract.h"

@class ChooseContractViewController;

@protocol ChooseContractDelegate <NSObject>
- (void)chooseContractViewController:(ChooseContractViewController *)controller didSelectContract:(NSString *) contractId withSelectIndex:(int) selectedIndex withCustomerSelectIndex:(int) customerSelectIndex withLabelTitle:(NSString *) title withStartDate:(NSString *) startDate withEndDate:(NSString *) endDate withCustomerId:(NSString *) customerId withCustomerName:(NSString *) customerName;
@end

@interface ChooseContractViewController : UITableViewController {
    int customerSelectedIndex;
    NSString *customerId;
    NSString *customerName;
    NSMutableArray *contractList;
    int selectedIndex;
}

@property (nonatomic, retain) NSString *customerId;
@property (nonatomic, retain) NSString *customerName;
@property (nonatomic, retain) NSMutableArray *contractList;
@property (nonatomic, retain) id<ChooseContractDelegate> delegate;
@property (nonatomic) int customerSelectedIndex;
@property (nonatomic) int selectedIndex;

@end
