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
@synthesize editFlag;
@synthesize deleteList;

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
    editFlag = FALSE;
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableViewCustom.bounds.size.height, self.view.frame.size.width, self.tableViewCustom.bounds.size.height)];
		view.delegate = self;
		[self.tableViewCustom addSubview:view];
		_refreshHeaderView = view;
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    [tabBarCustom setSelectedItem:[tabBarCustom.items objectAtIndex:0]];
    
    
    /* ---------------------------------------------------------
     * Create images that are used for the main button
     * -------------------------------------------------------*/
    UIImage *image = [UIImage imageNamed:@"red_plus_up.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"red_plus_down.png"];
    UIImage *toggledImage = [UIImage imageNamed:@"red_x_up.png"];
    UIImage *toggledSelectedImage = [UIImage imageNamed:@"red_x_down.png"];
    
    /* ---------------------------------------------------------
     * Create the center for the main button and origin of animations
     * -------------------------------------------------------*/
    CGPoint center = CGPointMake(self.view.frame.size.width - 22, self.view.frame.size.height - 135.0f);
    
    /* ---------------------------------------------------------
     * Setup buttons
     * Note: I am setting the frame to the size of my images
     * -------------------------------------------------------*/
//    CGRect buttonFrame = CGRectMake(0, 0, 48.0f, 48.0f);
//    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [b1 setFrame:buttonFrame];
//    [b1 setImage:[UIImage imageNamed:@"con_icon_Sign.png"] forState:UIControlStateNormal];
//    [b1 setImage:[UIImage imageNamed:@"con_icon_Sign_click.png"] forState:UIControlStateHighlighted];
//    [b1 addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [b2 setImage:[UIImage imageNamed:@"lightbulb.png"] forState:UIControlStateNormal];
//    [b2 setFrame:buttonFrame];
//    [b2 addTarget:self action:@selector(onAlert) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [b3 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
//    [b3 setFrame:buttonFrame];
//    [b3 addTarget:self action:@selector(onModal) forControlEvents:UIControlEventTouchUpInside];
//    NSArray *buttons = [NSArray arrayWithObjects:b1, nil];
    
    /* ---------------------------------------------------------
     * Init method, passing everything the bar needs to work
     * -------------------------------------------------------*/
    RNExpandingButtonBar *bar = [[RNExpandingButtonBar alloc] initWithImage:image selectedImage:selectedImage toggledImage:toggledImage toggledSelectedImage:toggledSelectedImage buttons:nil center:center];
    //
    //    /* ---------------------------------------------------------
    //     * Settings
    //     * -------------------------------------------------------*/
    [bar setDelegate:self];
    [bar setSpin:YES];
    
    /* ---------------------------------------------------------
     * Set our property and add it to the view
     * -------------------------------------------------------*/
    [[self view] addSubview:bar];
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
//    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable: {
//            // 没有网络连接
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到没有网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//            break;
//        case ReachableViaWWAN:
//            // 使用3G网络
//            break;
//        case ReachableViaWiFi:
//            // 使用WiFi网络
//            break;
//    }
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
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
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
    if (editFlag) {
        //cell.readImageView.image = [UIImage imageNamed:@"Unselected.png"];
		//cell.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (mail.isChecked) {
            
            cell.readImageView.image = [UIImage imageNamed:@"Selected.png"];
            cell.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
        } else {
            
            cell.readImageView.image = [UIImage imageNamed:@"Unselected.png"];
            cell.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Mail *mail = [mailList objectAtIndex:[self.tableViewCustom indexPathForSelectedRow].row];
    MailCell *cell = (MailCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    if (editFlag) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (mail.isChecked) {
            cell.readImageView.image = [UIImage imageNamed:@"Unselected.png"];
            cell.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
            mail.isChecked = NO;
        } else {
            cell.readImageView.image = [UIImage imageNamed:@"Selected.png"];
            cell.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
            mail.isChecked = YES;
        }
        
    } else {
        MailCell *cell = (MailCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
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

/* ---------------------------------------------------------
 * Delegate methods of ExpandingButtonBarDelegate
 * -------------------------------------------------------*/
- (void) expandingBarDidAppear:(RNExpandingButtonBar *)bar
{
    //NSLog(@"did appear");
    editFlag = YES;
    [self.tableViewCustom performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

- (void) expandingBarWillAppear:(RNExpandingButtonBar *)bar
{
    //NSLog(@"will appear");
}

- (void) expandingBarDidDisappear:(RNExpandingButtonBar *)bar
{
    NSMutableArray *deleteMail = [[NSMutableArray alloc] init];
    deleteList = @"";
    for (int i = 0; i < [mailList count]; i ++) {
        Mail *mail = [mailList objectAtIndex:i];
        if (mail.isChecked) {
            [deleteMail addObject:mail];
        }
    }
    
    for (int i = 0; i < [deleteMail count]; i ++) {
        Mail *mail = [deleteMail objectAtIndex:i];
        deleteList = [deleteList stringByAppendingFormat:@"%@", mail.ID];
        if (i != [deleteMail count] - 1) {
            deleteList = [deleteList stringByAppendingString:@","];
        }
    }
    
    if (![deleteList isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要删除这些邮件吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 0;
        [alert show];
    }
    
    editFlag = FALSE;
    [self.tableViewCustom performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

- (void) expandingBarWillDisappear:(RNExpandingButtonBar *)bar
{
    //NSLog(@"will disappear");
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    } else {
        if (alertView.tag == 0) {
            NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
            if (indexOfTab == 3) {
                [Mail deleteEmailById:deleteList withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
            } else {
                [Mail deleteReceiveEmailById:deleteList withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
            }
            
            [self refreshTableView];
        }
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end
