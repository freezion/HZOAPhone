//
//  RightViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-16.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "RightViewController.h"
#import "ChangeUserViewController.h"
#import "DDMenuController.h"
#import "NewCalendarViewController.h"
#import "NewEmailViewController.h"
#import "NewNoticeViewController.h"
#import "SettingViewController.h"
#import "CopyrightViewController.h"
#import "RealCopyrightsViewController.h"
#import "LoginViewController.h"
#import "HelpViewController.h"
#import "MainViewController.h"
#import "MostContactViewController.h"
#import "Mail.h"

@interface RightViewController ()

@end

@implementation RightViewController
@synthesize userName;
@synthesize showNewFlag;
@synthesize flagImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
     
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    userName.text=[usernamepasswordKVPairs objectForKey:KEY_USERNAME];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *currVersion = [SystemConfig getVersion];
    if (![version isEqualToString:currVersion]) {
        self.flagImage.image = [UIImage imageNamed:@"label_new_red.png"];
    } else {
        self.flagImage.image = [UIImage imageNamed:@""];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = [UIColor colorWithRed:54.0/255 green:54.0/255 blue:54.0/255 alpha:1];
    cell.backgroundColor = color;
}

- (IBAction)showLogin:(id) sender {
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    ChangeUserViewController *changeUserViewController = [storyborad instantiateViewControllerWithIdentifier:@"ChangeUserViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:changeUserViewController];
    //[Mail serviceTestJava];
    [menuController setRootController:navController animated:YES];
}

- (IBAction)showNewCalendar:(id) sender {
    [Employee deleteAllTmpContact];
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    NewCalendarViewController *newCalendarViewController = [storyborad instantiateViewControllerWithIdentifier:@"NewCalendarViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newCalendarViewController];
    
    [menuController setRootController:navController animated:YES];
}

- (IBAction)showNewEmail:(id) sender {
    [Employee deleteAllTmpContact];
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    NewEmailViewController *newEmailViewController = [storyborad instantiateViewControllerWithIdentifier:@"NewEmailViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newEmailViewController];
    [menuController setRootController:navController animated:YES];
}

- (IBAction)showNewNotice:(id) sender {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    NSMutableArray *systemConfigs = [SystemConfig getNoticeType:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    if ([systemConfigs count] > 0) {
        DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
        NewNoticeViewController *newNoticeViewController = [storyborad instantiateViewControllerWithIdentifier:@"NewNoticeViewController"];
        newNoticeViewController.values = systemConfigs;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newNoticeViewController];
        [menuController setRootController:navController animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有公告权限" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (IBAction)showSettings:(id) sender {
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    SettingViewController *settingViewController = [storyborad instantiateViewControllerWithIdentifier:@"SettingViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [menuController setRootController:navController animated:YES];
}

- (IBAction)showCopyright:(id) sender {
//    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
//    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
//    CopyrightViewController *copyrightViewController = [storyborad instantiateViewControllerWithIdentifier:@"CopyrightViewController"];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:copyrightViewController];
//    [menuController setRootController:navController animated:YES];
    
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    RealCopyrightsViewController *realCopyrightsViewController = [storyborad instantiateViewControllerWithIdentifier:@"RealCopyrightsViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:realCopyrightsViewController];
    [menuController setRootController:navController animated:YES];
}

- (IBAction)cancelLogin:(id)sender{

     [UserKeychain delete:KEY_LOGINID_PASSWORD];
     DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
     UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
     MainViewController *mainViewController = [storyborad instantiateViewControllerWithIdentifier:@"MainViewController"];
     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [menuController setRootController:navController animated:YES];
     
}

- (IBAction)showHelp:(id) sender {
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    HelpViewController *helpViewController = [storyborad instantiateViewControllerWithIdentifier:@"HelpViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:helpViewController];
    [menuController setRootController:navController animated:YES];
}

- (IBAction)showMostContact:(id) sender {
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    MostContactViewController *mostContactViewController = [storyborad instantiateViewControllerWithIdentifier:@"MostContactViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mostContactViewController];
    [menuController setRootController:navController animated:YES];
}

@end
