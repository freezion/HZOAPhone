//
//  ChooseEmployeeViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-29.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCArraySectionController.h"
#import "InvitEmployeeViewController.h"
#import "NewNoticeViewController.h"
#import "NewEmailViewController.h"
#import "ReplyEmailViewController.h"
#import "ForwardEmailViewController.h"
#import "MostContactViewController.h"
#import "SwitchViewController.h"

@interface ChooseEmployeeViewController : UITableViewController {
    UIButton *buttonId;
    NSMutableDictionary *dictionary;
    NSMutableArray* retractableControllers;
    GCArraySectionController *arrayController;
    int status;
}

@property (nonatomic) int status;
@property (nonatomic, retain) GCArraySectionController *arrayController;
@property (nonatomic, retain) NSMutableArray *retractableControllers;
@property (nonatomic, retain) NSMutableDictionary *dictionary;
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) UIButton *buttonId;
@property (nonatomic, retain) id<InvitEmployeeDelegate> delegateInvitEmployee;
@property (nonatomic, retain) id<NewEmailDelegate> delegateEmail;
@property (nonatomic, retain) id<NewNoticeDelegate> delegateNotice;
@property (nonatomic, retain) id<ReplyEmailDelegate> delegateReply;
@property (nonatomic, retain) id<ForwardEmailDelegate> delegateForward;
@property (nonatomic, retain) id<MostContactDelegate> delegateMostContact;
@property (nonatomic, retain) id<SwitchViewDelegate> delegateSwitchView;

@end
