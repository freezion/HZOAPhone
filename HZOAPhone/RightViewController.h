//
//  RightViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-16.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightViewController : UITableViewController {
    UILabel *userName;
    BOOL showNewFlag;
    UIImageView *newImage;
}

@property(nonatomic, retain) IBOutlet  UILabel *userName;
@property(nonatomic, retain) NSString *userNameStr;
@property(nonatomic) BOOL showNewFlag;
@property(nonatomic, retain) IBOutlet UIImageView *flagImage;

- (IBAction)showLogin:(id) sender;
- (IBAction)showNewCalendar:(id) sender;
- (IBAction)showNewEmail:(id) sender;
- (IBAction)showNewNotice:(id) sender;
- (IBAction)showSettings:(id) sender;
- (IBAction)showCopyright:(id) sender;
- (IBAction)cancelLogin:(id) sender;
- (IBAction)showHelp:(id) sender;
- (IBAction)showMostContact:(id) sender;

@end
