//
//  SettingViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-11-2.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemConfig.h"

@interface SettingViewController : UITableViewController {
    SystemConfig *systemConfig;
    UITableViewCell *calendarCell;
    UITableViewCell *noticeCell;
    UITableViewCell *emailCell;
    UITableViewCell *memberCell;
    int selectedIndex;
}

@property (nonatomic, retain) SystemConfig *systemConfig;
@property (nonatomic) int selectedIndex;
@property (nonatomic, retain) IBOutlet UITableViewCell *calendarCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *noticeCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *emailCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *memberCell;

@end
