//
//  ChooseMostViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 13-1-31.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitEmployeeViewController.h"
#import "NewNoticeViewController.h"
#import "NewEmailViewController.h"
#import "ReplyEmailViewController.h"
#import "ForwardEmailViewController.h"
#import "MostContactViewController.h"
#import "SwitchViewController.h"

@interface ChooseMostViewController : UITableViewController {
    NSMutableArray *mostList;
}

@property (nonatomic, retain) NSMutableArray *mostList;
@property (nonatomic, retain) UIButton *buttonId;
@property (nonatomic, retain) id<InvitEmployeeDelegate> delegateInvitEmployee;
@property (nonatomic, retain) id<NewEmailDelegate> delegateEmail;
@property (nonatomic, retain) id<NewNoticeDelegate> delegateNotice;
@property (nonatomic, retain) id<ReplyEmailDelegate> delegateReply;
@property (nonatomic, retain) id<ForwardEmailDelegate> delegateForward;
@property (nonatomic, retain) id<MostContactDelegate> delegateMostContact;
@property (nonatomic, retain) id<SwitchViewDelegate> delegateSwitchView;

@end
