//
//  SpringBoardViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-15.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "SpringBoardViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "DDMenuController.h"
#import "NoticeViewController.h"
#import "EmailViewController.h"
#import "MemberViewController.h"

@interface SpringBoardViewController ()

@end

@implementation SpringBoardViewController
@synthesize imageView;
@synthesize calendarButton;
@synthesize calendarImage;
@synthesize emailImage;
@synthesize noticeImage;
@synthesize noticeButton;
@synthesize emailButton;

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
	// Do any additional setup after loading the view.
    [self.imageView setImage:[UIImage imageNamed:@"springboard2.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)viewDidAppear:(BOOL)animated {
    AppDelegate *d = [[UIApplication sharedApplication] delegate];
    ;
    NSString *calendarKey = d.calendarMessage;
    NSString *emailKey = d.emailMessage;
    NSString *noticeKey = d.noticeMessage;
    if ([calendarKey isEqualToString:@"1"]) {
        self.calendarImage.image = [UIImage imageNamed:@"label_new_red.png"];
    } else {
        self.calendarImage.image = [UIImage imageNamed:@""];
    }
    
    if ([emailKey isEqualToString:@"1"]) {
        self.emailImage.image = [UIImage imageNamed:@"label_new_red.png"];
    } else {
        self.emailImage.image = [UIImage imageNamed:@""];
    }
    
    if ([noticeKey isEqualToString:@"1"]) {
        self.noticeImage.image = [UIImage imageNamed:@"label_new_red.png"];
    } else {
        self.noticeImage.image = [UIImage imageNamed:@""];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)showCalendar:(id) sender {
    [Employee deleteAllTmpContact];
    AppDelegate *d = [[UIApplication sharedApplication] delegate];
    d.calendarMessage = @"0";
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    MainViewController *mainViewController = [storyborad instantiateViewControllerWithIdentifier:@"MainViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    [menuController setRootController:navController animated:YES];
}

- (IBAction)showNotice:(id) sender {
    AppDelegate *d = [[UIApplication sharedApplication] delegate];
    d.noticeMessage = @"0";
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    NoticeViewController *noticeViewController = [storyborad instantiateViewControllerWithIdentifier:@"NoticeViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:noticeViewController];
    
    [menuController setRootController:navController animated:YES];
}

- (IBAction)showEmail:(id) sender {
    [Employee deleteAllTmpContact];
    AppDelegate *d = [[UIApplication sharedApplication] delegate];
    d.emailMessage = @"0";
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    EmailViewController *emailViewController = [storyborad instantiateViewControllerWithIdentifier:@"EmailViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:emailViewController];
    
    [menuController setRootController:navController animated:YES];
}

- (IBAction)showMember:(id) sender {
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    MemberViewController *memberViewController = [storyborad instantiateViewControllerWithIdentifier:@"MemberViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:memberViewController];
    
    [menuController setRootController:navController animated:YES];
}

@end
