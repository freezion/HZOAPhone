//
//  EmailViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-22.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"

@interface EmailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, UITabBarControllerDelegate, MBProgressHUDDelegate> {
    CGFloat _offset;
    BOOL _animated;
    UITableView *tableViewCustom;
    UITabBar *tabBarCustom;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    NSString *refreshFlag;
    MBProgressHUD *HUD;
    int indexOfTab;
}

@property (retain, nonatomic) IBOutlet UITableView *tableViewCustom;
@property (retain, nonatomic) IBOutlet UITabBar *tabBarCustom;
@property (retain, nonatomic) NSString *refreshFlag;
@property (nonatomic) int indexOfTab;
@property (nonatomic, strong) NSMutableArray *mailList;

@end
