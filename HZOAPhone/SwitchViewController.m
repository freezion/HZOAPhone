//
//  SwitchViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 13-1-31.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import "SwitchViewController.h"
#import "ChooseMostViewController.h"
#import "ChooseEmployeeViewController.h"
#import "Employee.h"

@interface SwitchViewController ()

@end

@implementation SwitchViewController
@synthesize mostContactViewController;
@synthesize chooseEmployeeViewController;
@synthesize delegateEmail;
@synthesize delegateForward;
@synthesize delegateInvitEmployee;
@synthesize delegateMostContact;
@synthesize delegateNotice;
@synthesize delegateReply;
@synthesize buttonId;
@synthesize status;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择联系人";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Since the buttons can be any width we use a thin image with a stretchable center point
    UIImage *buttonImage = [[UIImage imageNamed:@"finish"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"finish2"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(doCancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonBar;
    if (status != 1) {
        UIButton *buttonChange = [UIButton buttonWithType:UIButtonTypeCustom];
        // Since the buttons can be any width we use a thin image with a stretchable center point
        UIImage *buttonChangeImage = [[UIImage imageNamed:@"group_btn"] stretchableImageWithLeftCapWidth:5  topCapHeight:0];
        UIImage *buttonChangePressedImage = [[UIImage imageNamed:@"group_btn"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        [buttonChange setBackgroundImage:buttonChangeImage forState:UIControlStateNormal];
        [buttonChange setBackgroundImage:buttonChangePressedImage forState:UIControlStateHighlighted];
        CGRect buttonChangeFrame = [buttonChange frame];
        buttonChangeFrame.size.width = buttonChangeImage.size.width;
        buttonChangeFrame.size.height = buttonChangeImage.size.height;
        [buttonChange setFrame:buttonChangeFrame];
        [buttonChange addTarget:self action:@selector(doChange) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonChangeBar = [[UIBarButtonItem alloc] initWithCustomView:buttonChange];
        self.navigationItem.rightBarButtonItem = buttonChangeBar;
    }
    NSMutableArray *mostList = [Employee getAllMostContact];
    
	UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    ChooseMostViewController *newMostContactViewController = [storyborad instantiateViewControllerWithIdentifier:@"ChooseMostViewController"];
    newMostContactViewController.delegateEmail = self.delegateEmail;
    newMostContactViewController.delegateForward = self.delegateForward;
    newMostContactViewController.delegateInvitEmployee = self.delegateInvitEmployee;
    newMostContactViewController.delegateMostContact = self.delegateMostContact;
    newMostContactViewController.delegateNotice = self.delegateNotice;
    newMostContactViewController.delegateReply = self.delegateReply;
    newMostContactViewController.delegateSwitchView = self;
    newMostContactViewController.buttonId = self.buttonId;
    
    ChooseEmployeeViewController *newChooseEmployeeViewController = [storyborad instantiateViewControllerWithIdentifier:@"ChooseEmployeeViewController"];
    newChooseEmployeeViewController.delegateEmail = self.delegateEmail;
    newChooseEmployeeViewController.delegateForward = self.delegateForward;
    newChooseEmployeeViewController.delegateInvitEmployee = self.delegateInvitEmployee;
    newChooseEmployeeViewController.delegateMostContact = self.delegateMostContact;
    newChooseEmployeeViewController.delegateNotice = self.delegateNotice;
    newChooseEmployeeViewController.delegateReply = self.delegateReply;
    newChooseEmployeeViewController.delegateSwitchView = self;
    newChooseEmployeeViewController.buttonId = self.buttonId;
    
    self.mostContactViewController = newMostContactViewController;
    [mostContactViewController.view setFrame:[self.view bounds]];
    self.chooseEmployeeViewController = newChooseEmployeeViewController;
    [chooseEmployeeViewController.view setFrame:[self.view bounds]];
    if ([mostList count] != 0 && status != 1) {
        [self.view insertSubview:mostContactViewController.view atIndex:0];
    } else {
        [self.view insertSubview:chooseEmployeeViewController.view atIndex:0];
    }    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doCancel {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doChange {
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.50];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    if (self.mostContactViewController.view.superview == nil) {
        if (self.mostContactViewController == nil) {
            ChooseMostViewController *newMostContactViewController = [storyborad instantiateViewControllerWithIdentifier:@"ChooseMostViewController"];
            self.mostContactViewController = newMostContactViewController;
        }
        self.title = @"选择联系人";
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [chooseEmployeeViewController viewWillAppear:YES];
        [mostContactViewController viewWillDisappear:YES];
        
        [chooseEmployeeViewController.view removeFromSuperview];
        [self.view insertSubview:mostContactViewController.view atIndex:0];
        [mostContactViewController viewDidDisappear:YES];
        [chooseEmployeeViewController viewDidAppear:YES];
    } else {
        if (self.chooseEmployeeViewController == nil) {
            ChooseEmployeeViewController *newChooseEmployeeViewController = [storyborad instantiateViewControllerWithIdentifier:@"ChooseEmployeeViewController"];
            self.chooseEmployeeViewController = newChooseEmployeeViewController;
        }
        self.title = @"常用联系人";
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [mostContactViewController viewWillAppear:YES];
        [chooseEmployeeViewController viewWillDisappear:YES];
        
        [mostContactViewController.view removeFromSuperview];
        [self.view insertSubview:chooseEmployeeViewController.view atIndex:0];
        [chooseEmployeeViewController viewDidDisappear:YES];
        [mostContactViewController viewDidAppear:YES];
    }
    [UIView commitAnimations];
}

- (void) dismissViewController {
    [self dismissModalViewControllerAnimated:YES];
}

@end
