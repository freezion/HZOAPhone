//
//  ChooseCustomerViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "ChooseCustomerViewController.h"
#import "Customer.h"
#import "ChooseContractViewController.h"

@interface ChooseCustomerViewController ()

@end

@implementation ChooseCustomerViewController

@synthesize customerList;
@synthesize contractSelectedIndex;
@synthesize customerSelectedIndex;
@synthesize contractIdLocal;
@synthesize startDateLocal;
@synthesize endDateLocal;
@synthesize customerIdLocal;
@synthesize contractName;
@synthesize customerNameLocal;
@synthesize nameList;
@synthesize searchBar;
@synthesize delegate;

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
    self.title = @"选择客户";
    [self initChooseCustomer];
}

- (void) initChooseCustomer {
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
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonBar;
    
    [searchBar setShowsScopeBar:NO];
    [searchBar sizeToFit];
    
    // Hide the search bar until user scrolls up
    CGRect newBounds = [[self tableView] bounds];
    newBounds.origin.y = newBounds.origin.y + searchBar.bounds.size.height;
    [[self tableView] setBounds:newBounds];
    
    customerList = [Customer getAllCustomer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)backAction:(id) sender {
    [delegate chooseCustomerViewController:self didSelectContract:contractIdLocal withSelectIndex:contractSelectedIndex withCustomerSelectIndex:customerSelectedIndex withLabelTitle:contractName withStartDate:startDateLocal withEndDate:endDateLocal withCustomerId:customerIdLocal withCustomerName:customerNameLocal];
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    
    Customer *customer = nil;

    if(sender == self.searchDisplayController.searchResultsTableView) {
        customer = [searchResults objectAtIndex:[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row];
    }
    else {
        customer = [self.customerList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
    ChooseContractViewController *chooseContractViewController = segue.destinationViewController;
    chooseContractViewController.delegate = self;
    chooseContractViewController.customerId = customer.customerId;
    chooseContractViewController.customerName = customer.name;
    chooseContractViewController.customerSelectedIndex = [self.tableView indexPathForSelectedRow].row;
    chooseContractViewController.selectedIndex = contractSelectedIndex;
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [customerList count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Customer *customer = [[Customer alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        customer = [searchResults objectAtIndex:indexPath.row];
    } else {
        customer = [customerList objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = customer.name;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"candyDetail" sender:tableView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate 
                                    predicateWithFormat:@"SELF.name contains[cd] %@",
                                    searchText];
    
    searchResults = [customerList filteredArrayUsingPredicate:resultPredicate];
    [self.tableView reloadData];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString 
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    [self.tableView reloadData];
    return YES;
}

#pragma mark - ChooseContractDelegate
- (void)chooseContractViewController:(ChooseContractViewController *)controller didSelectContract:(NSString *) contractId withSelectIndex:(int) selectedIndex withCustomerSelectIndex:(int) customerSelectIndex withLabelTitle:(NSString *) title withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate withCustomerId:(NSString *)customerId withCustomerName:(NSString *)customerName {
    self.contractIdLocal = contractId;
    contractSelectedIndex = selectedIndex;
    contractName = title;
    startDateLocal = startDate;
    endDateLocal = endDate;
    customerIdLocal = customerId;
    customerNameLocal = customerName;
    //[self.navigationController popViewControllerAnimated:YES];
    
    
    [delegate chooseCustomerViewController:self didSelectContract:contractIdLocal withSelectIndex:contractSelectedIndex withCustomerSelectIndex:customerSelectedIndex withLabelTitle:contractName withStartDate:startDateLocal withEndDate:endDateLocal withCustomerId:customerIdLocal withCustomerName:customerNameLocal];
}

@end
