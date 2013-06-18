//
//  EmailViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-22.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "EmailViewController.h"
#import "Mail.h"
#import "MailCell.h"
#import "EmailDetailViewController.h"
#import "NewEmailViewController.h"
#import "LoginViewController.h"
#import "Reachability.h"

@interface EmailViewController ()

@end

@implementation EmailViewController

@synthesize tableViewCustom;
@synthesize tabBarCustom;
@synthesize refreshFlag;
@synthesize mailList;
@synthesize indexOfTab;

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
    
    self.title = @"收件箱";
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableViewCustom.bounds.size.height, self.view.frame.size.width, self.tableViewCustom.bounds.size.height)];
		view.delegate = self;
		[self.tableViewCustom addSubview:view];
		_refreshHeaderView = view;
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    [tabBarCustom setSelectedItem:[tabBarCustom.items objectAtIndex:0]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    if (usernamepasswordKVPairs == nil) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
        LoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentModalViewController:loginViewController animated:NO];
    } else {
        if (refreshFlag == nil) {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.dimBackground = YES;
            [HUD setDelegate:self];
            [HUD setLabelText:@"数据加载..."];
            [HUD showWhileExecuting:@selector(refreshTableView) onTarget:self withObject:nil animated:YES];
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable: {
            // 没有网络连接
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到没有网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    
}

-(void)refreshTableView {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    [Mail synchronizeEmail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    if (indexOfTab == 0) {
        [self myReceiveList];
    } else if (indexOfTab == 1) {
        [self mySendList];
    } else if (indexOfTab == 2) {
        [self myTmpList];
    } else if (indexOfTab == 3) {
        [self myDeleteList];
    }
	[self.tableViewCustom reloadData];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"数据加载..."];
    
    indexOfTab = [[tabBar items] indexOfObject:item];
    if (indexOfTab == 0) {
        self.title = @"收件箱";
        [HUD showWhileExecuting:@selector(myReceiveList) onTarget:self withObject:nil animated:YES];
    } else if (indexOfTab == 1) {
        self.title = @"已发送";
        [HUD showWhileExecuting:@selector(mySendList) onTarget:self withObject:nil animated:YES];
    } else if (indexOfTab == 2) {
        self.title = @"草稿箱";
        [HUD showWhileExecuting:@selector(myTmpList) onTarget:self withObject:nil animated:YES];
    } else if (indexOfTab == 3) {
        self.title = @"垃圾箱";
        [HUD showWhileExecuting:@selector(myDeleteList) onTarget:self withObject:nil animated:YES];
    }
    //[self.tableViewCustom reloadData];
}

- (void) myReceiveList {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    mailList = [Mail getLocalReciveEmail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    [self.tableViewCustom reloadData];
}

- (void) mySendList {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    mailList = [Mail getLocalSenderEmail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    [self.tableViewCustom reloadData];
}

- (void) myTmpList {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    mailList = [Mail getTmpMail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    [self.tableViewCustom reloadData];
}

- (void) myDeleteList {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    mailList = [Mail getWillDeleteMail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    [self.tableViewCustom reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        Mail *mail = (Mail *)[self.mailList objectAtIndex:indexPath.row];
        NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
        [Mail deleteReceiveEmailById:mail.ID withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
		[self.mailList removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [mailList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MailCell";
    MailCell *cell = (MailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Mail *mail = [self.mailList objectAtIndex:indexPath.row];
	cell.titleLabel.text = mail.title;
    
    if ([mail.readed isEqualToString:@"0"] && indexOfTab != 3) {
        cell.readImageView.image = [UIImage imageNamed:@"1Star.png"];
    } else {
        cell.readImageView.image = [UIImage imageNamed:@""];
    }
    if ([mail.fileId isEqualToString:@""]) {
        [cell.attachmentImageView setImage:[UIImage imageNamed:@""]];
    } else {
        [cell.attachmentImageView setImage:[UIImage imageNamed:@"attachment"]];
    } 
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Mail *mail = [mailList objectAtIndex:[self.tableViewCustom indexPathForSelectedRow].row];
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    if (indexOfTab != 2) {
        EmailDetailViewController *viewController = [storyborad instantiateViewControllerWithIdentifier:@"EmailDetailViewController"];
        viewController.mail = mail;
        viewController.tabbarIndex = indexOfTab;
        NSLog(@"%@", mail.ID);
        NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
        if ([mail.readed isEqualToString:@"0"]) {
            [Mail readedMail:mail.ID withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
            if (indexOfTab == 0) {
                [self myReceiveList];
            } else if (indexOfTab == 1) {
                [self mySendList];
            } else if (indexOfTab == 2) {
                [self myTmpList];
            } else if (indexOfTab == 3) {
                [self myDeleteList];
            }
        }
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        NewEmailViewController *viewController = [storyborad instantiateViewControllerWithIdentifier:@"NewEmailViewController"];
        viewController.mail = mail;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    refreshFlag = @"NO";
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
    [self.tableViewCustom reloadData];
    
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData {
	[self refreshTableView];
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableViewCustom];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
