//
//  MemberViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-11-1.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "MemberViewController.h"
#import "FileViewController.h"
#import "LoginViewController.h"
#import "Reachability.h"

@interface MemberViewController ()

@end

@implementation MemberViewController

@synthesize folderList;
@synthesize filteredCandyArray;
@synthesize searchBar;
@synthesize refreshFlag;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"会员信息";
    [self initMember];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.

}

- (void) initMember {
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (void) refreshTableView {
    folderList = [MyFolder getAllCompany];
    filteredCandyArray = [NSMutableArray arrayWithCapacity:[folderList count]];
    [[self tableView] reloadData];
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [filteredCandyArray count];
    }
	else
	{
        return [folderList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MemberCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    MyFolder *folder = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        folder = [filteredCandyArray objectAtIndex:[indexPath row]];
    }
	else
	{
        folder = [folderList objectAtIndex:[indexPath row]];
    }
    
    cell.textLabel.text = folder.companyNameCN;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"folderDetail" sender:tableView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{  
    MyFolder *folder = nil;
    // In order to manipulate the destination view controller, another check on which table (search or normal) is displayed is needed
    if(sender == self.searchDisplayController.searchResultsTableView) {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        folder = [filteredCandyArray objectAtIndex:[indexPath row]];
    }
    else {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        folder = [folderList objectAtIndex:[indexPath row]];
    }
    FileViewController *fileViewController = [segue destinationViewController];
    fileViewController.memberId = folder.folderID;
    
    refreshFlag = @"NO";
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[self.filteredCandyArray removeAllObjects];
    
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.companyNameCN contains[c] %@",searchText];
    NSArray *tempArray = [folderList filteredArrayUsingPredicate:predicate];
    
    filteredCandyArray = [NSMutableArray arrayWithArray:tempArray];
}


#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
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
    [self.tableView reloadData];
    
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
    
    folderList = [MyFolder getAllCompany];
	[self.tableView reloadData];
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
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

@end
