//
//  GCArraySectionController.h
//  Demo
//
//  Created by Guillaume Campagna on 11-04-21.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCRetractableSectionController.h"
#import "ContactCell.h"
#import "Employee.h"
#import "InvitEmployeeViewController.h"
#import "NewEmailViewController.h"
#import "NewNoticeViewController.h"
#import "ReplyEmailViewController.h"
#import "ForwardEmailViewController.h"
#import "MostContactViewController.h"
#import "SwitchViewController.h"

//This is a GCRetractableSectionController that take a NSArray and display it like the simple example did.
//You can use it directly in your project if your retractable controller is simple!

@interface GCArraySectionController : GCRetractableSectionController {
    id<InvitEmployeeDelegate> delegateInvitEmployee;
    id<NewEmailDelegate> delegateNewEmail;
    id<NewNoticeDelegate> delegateNewNotice;
    id<ReplyEmailDelegate> delegateReply;
    id<ForwardEmailDelegate> delegateForward;
    id<MostContactDelegate> delegateMostContact;
    id<SwitchViewDelegate> delegateSwitchView;
}

@property (nonatomic, copy, readwrite) NSString* title;
@property (nonatomic, retain) id<InvitEmployeeDelegate> delegateInvitEmployee;
@property (nonatomic, retain) id<NewEmailDelegate> delegateNewEmail;
@property (nonatomic, retain) id<NewNoticeDelegate> delegateNewNotice;
@property (nonatomic, retain) id<ReplyEmailDelegate> delegateReply;
@property (nonatomic, retain) id<ForwardEmailDelegate> delegateForward;
@property (nonatomic, retain) id<MostContactDelegate> delegateMostContact;
@property (nonatomic, retain) id<SwitchViewDelegate> delegateSwitchView;

- (id)initWithArray:(NSArray*) array viewController:(UIViewController *)givenViewController;

@end
