//
//  EventAlertViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventAlertViewController;

@protocol EventAlertViewDelegate <NSObject>
- (void)eventAlertViewController:(EventAlertViewController *)controller didSelectAlert:(NSString *) timer withSelectIndex:(int) selectedIndex withLabelTitle:(NSString *) title;
@end

@interface EventAlertViewController : UITableViewController {
    int selectedIndex;
    UITableViewCell *CellNone;
    UITableViewCell *CellFifteen;
    UITableViewCell *CellThirty;
    UITableViewCell *CellFortyFive;
    UITableViewCell *CellOneHour;
    NSString *timerInterval;
}

@property (nonatomic, retain) id<EventAlertViewDelegate> delegate;
@property (nonatomic) int selectedIndex;
@property (nonatomic, retain) NSString *timerInterval;
@property (nonatomic, retain) IBOutlet UITableViewCell *CellNone;
@property (nonatomic, retain) IBOutlet UITableViewCell *CellFifteen;
@property (nonatomic, retain) IBOutlet UITableViewCell *CellThirty;
@property (nonatomic, retain) IBOutlet UITableViewCell *CellFortyFive;
@property (nonatomic, retain) IBOutlet UITableViewCell *CellOneHour;

@end
