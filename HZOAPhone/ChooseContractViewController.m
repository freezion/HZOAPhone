//
//  ChooseContractViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "ChooseContractViewController.h"
#import "NewCalendarViewController.h"

@interface ChooseContractViewController ()

@end

@implementation ChooseContractViewController

@synthesize delegate;
@synthesize customerSelectedIndex;
@synthesize customerId;
@synthesize contractList;
@synthesize selectedIndex;
@synthesize customerName;

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
    self.title = @"选择客户合同";
    [self initChooseContract];
}

- (void) initChooseContract {
    contractList = [Contract getContractIdByCustomer:customerId];
    if ([contractList count] == 0) {
        
    } else {
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
    }
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

- (void) backAction:(id) sender {
    Contract *contract = [self.contractList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    Contract *contractDate = [Contract getContractInfoByContractId:contract.contractId];
    [delegate chooseContractViewController:self didSelectContract:contract.contractId withSelectIndex:[self.tableView indexPathForSelectedRow].row withCustomerSelectIndex:customerSelectedIndex withLabelTitle:contract.compactNum withStartDate:contractDate.startDate withEndDate:contractDate.endDate withCustomerId:customerId withCustomerName:customerName];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [contractList count];
    if (count > 0) {
        return [contractList count];
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int count = [contractList count];
    static NSString *CellIdentifier = @"ContractCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (count == 0) {
        if (indexPath.row == 1) {
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.text = @"无合同";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        // Configure the cell...
        Contract *contract = [self.contractList objectAtIndex:indexPath.row];
        cell.textLabel.text = contract.compactNum;
        if (indexPath.row == selectedIndex)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int count = [contractList count];
    if (count > 0) {
        if (selectedIndex != NSNotFound)
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    
        selectedIndex = indexPath.row;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end
