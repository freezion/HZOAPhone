//
//  MemberViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-11-1.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "Employee.h"
#import "MBProgressHUD.h"
#import "MyFolder.h"

@interface MemberViewController : UITableViewController<UINavigationBarDelegate, UINavigationControllerDelegate, EGORefreshTableHeaderDelegate, UIAlertViewDelegate, MBProgressHUDDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    MBProgressHUD *HUD;
    NSString *refreshFlag;
}

@property (nonatomic, strong) NSArray *folderList;
@property (strong,nonatomic) NSMutableArray *filteredCandyArray;
@property IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) NSString *refreshFlag;

@end
