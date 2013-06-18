//
//  SwitchViewController.h
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

@class ChooseMostViewController;
@class ChooseEmployeeViewController;

@protocol SwitchViewDelegate <NSObject>
- (void) dismissViewController;
@end

@interface SwitchViewController : UIViewController<SwitchViewDelegate> {
    ChooseMostViewController *mostContactViewController;
    ChooseEmployeeViewController *chooseEmployeeViewController;
    int status;
}

@property (nonatomic, retain) ChooseMostViewController *mostContactViewController;
@property (nonatomic, retain) ChooseEmployeeViewController *chooseEmployeeViewController;
@property (nonatomic, retain) UIButton *buttonId;
@property (nonatomic) int status;
@property (nonatomic, retain) id<InvitEmployeeDelegate> delegateInvitEmployee;
@property (nonatomic, retain) id<NewEmailDelegate> delegateEmail;
@property (nonatomic, retain) id<NewNoticeDelegate> delegateNotice;
@property (nonatomic, retain) id<ReplyEmailDelegate> delegateReply;
@property (nonatomic, retain) id<ForwardEmailDelegate> delegateForward;
@property (nonatomic, retain) id<MostContactDelegate> delegateMostContact;

@end
