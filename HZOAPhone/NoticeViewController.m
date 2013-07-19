//
//  NoticeViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-22.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "NoticeViewController.h"
#import "Notice.h"
#import "NoticeCell.h"
#import "NoticeDetailViewController.h"
#import "LoginViewController.h"
#import "Reachability.h"

@interface NoticeViewController ()

@end

@implementation NoticeViewController

@synthesize tableViewCustom;
@synthesize noticeList;
@synthesize refreshFlag;
@synthesize bar;

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
    self.title = @"公告";
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableViewCustom.bounds.size.height, self.view.frame.size.width, self.tableViewCustom.bounds.size.height)];
		view.delegate = self;
		[self.tableViewCustom addSubview:view];
		_refreshHeaderView = view;
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    Notice *notice = [noticeList objectAtIndex:[self.tableViewCustom indexPathForSelectedRow].row];
    NoticeDetailViewController *noticeDetailViewController = [segue destinationViewController];
    noticeDetailViewController.notice = notice;
    
    if ([notice.readed isEqualToString:@"0"]) {
        [Notice readedNotice:notice.ID withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
        noticeList = [Notice getAllNotice:[usernamepasswordKVPairs objectForKey:KEY_USERID] withSync:YES];
        [self.tableViewCustom reloadData];
    }
    
    refreshFlag = @"NO";
}

-(void)refreshTableView { 
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    noticeList = [Notice synchronizeNotice:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
	[self.tableViewCustom reloadData];
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
    return [noticeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeCell *cell = (NoticeCell *)[tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
    
	Notice *notice = [self.noticeList objectAtIndex:indexPath.row];
	cell.nameLabel.text = notice.title;
    //NSLog(@"title ==== %@, readed ==== %@", notice.title, notice.readed);
    if ([notice.readed isEqualToString:@"0"]) {
        cell.readImageView.image = [UIImage imageNamed:@"1Star.png"];
    } else {
        cell.readImageView.image = [UIImage imageNamed:@""];
    }
    if ([notice.fileId isEqualToString:@""]) {
        [cell.attachmentImageView setImage:[UIImage imageNamed:@""]];
    } else {
        [cell.attachmentImageView setImage:[UIImage imageNamed:@"attachment"]];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
	[self.tableViewCustom reloadData];
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

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

/* ---------------------------------------------------------
 * Delegate methods of ExpandingButtonBarDelegate
 * -------------------------------------------------------*/
- (void) expandingBarDidAppear:(RNExpandingButtonBar *)bar
{
    //NSLog(@"did appear");
}

- (void) expandingBarWillAppear:(RNExpandingButtonBar *)bar
{
    //NSLog(@"will appear");
}

- (void) expandingBarDidDisappear:(RNExpandingButtonBar *)bar
{
    //NSLog(@"did disappear");
}

- (void) expandingBarWillDisappear:(RNExpandingButtonBar *)bar
{
    //NSLog(@"will disappear");
}

@end
