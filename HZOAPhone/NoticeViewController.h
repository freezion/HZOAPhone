//
//  NoticeViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-22.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "RNExpandingButtonBar.h"

@interface NoticeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, UITabBarControllerDelegate, MBProgressHUDDelegate, RNExpandingButtonBarDelegate> {
    CGFloat _offset;
    BOOL _animated;
    UITableView *tableViewCustom;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    MBProgressHUD *HUD;
    NSString *refreshFlag;
    RNExpandingButtonBar *bar;
}

@property (retain, nonatomic) IBOutlet UITableView *tableViewCustom;
@property (retain, nonatomic) NSString *refreshFlag;
@property (nonatomic, strong) NSMutableArray *noticeList;
@property (nonatomic, retain) RNExpandingButtonBar *bar;

@end
