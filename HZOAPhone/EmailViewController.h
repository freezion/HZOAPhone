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
#import "RNExpandingButtonBar.h"

@interface EmailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, UITabBarControllerDelegate, MBProgressHUDDelegate, RNExpandingButtonBarDelegate, UIAlertViewDelegate> {
    CGFloat _offset;
    BOOL _animated;
    UITableView *tableViewCustom;
    UITabBar *tabBarCustom;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    NSString *refreshFlag;
    MBProgressHUD *HUD;
    int indexOfTab;
    BOOL editFlag;
    NSString *deleteList;
}

@property (retain, nonatomic) IBOutlet UITableView *tableViewCustom;
@property (retain, nonatomic) IBOutlet UITabBar *tabBarCustom;
@property (retain, nonatomic) NSString *refreshFlag;
@property (retain, nonatomic) NSString *deleteList;
@property (nonatomic) int indexOfTab;
@property (nonatomic) BOOL editFlag;
@property (nonatomic, strong) NSMutableArray *mailList;

@end
