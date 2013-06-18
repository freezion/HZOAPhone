//
//  MostContactViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 13-1-30.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import "MostContactViewController.h"
#import "Employee.h"
#import "SwitchViewController.h"

@interface MostContactViewController ()

@end

@implementation MostContactViewController

@synthesize mostList;
@synthesize selectRow;

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
    self.title = @"常用联系人";
    [self initMost];
}

- (void) initMost {
    NSArray* toolbarItems = [NSArray arrayWithObjects:
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                           target:self
                                                                           action:@selector(addStuff:)],
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                               target:self
                                               action:@selector(trashStuff:)],
                             nil];
    self.toolbarItems = toolbarItems;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.toolbarHidden = NO;
    selectRow = -1;
    mostList = [Employee getAllMostContact];
}

- (void) addStuff:(id) sender {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    SwitchViewController *switchViewController = [storyborad instantiateViewControllerWithIdentifier:@"SwitchViewController"];
    switchViewController.delegateMostContact = self;
    switchViewController.status = 1;
    UINavigationController *tmpNavController = [[UINavigationController alloc] initWithRootViewController:switchViewController];
    [self.navigationController presentModalViewController:tmpNavController animated:YES];
}

- (void) trashStuff:(id) sender {
    if (selectRow == -1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择要删除的联系人" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        Employee *employee = [self.mostList objectAtIndex:selectRow];
        [Employee deleteMostContact:employee];
        mostList = [Employee getAllMostContact];
        [self.tableView reloadData];
        selectRow = -1;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [mostList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MostCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Employee *employee = [self.mostList objectAtIndex:indexPath.row];
    cell.textLabel.text = employee._name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectRow = indexPath.row;
}

- (void) showContact:(NSString *) contactId theName:(NSString *) contactName {
    Employee *employee = [[Employee alloc] init];
    employee._id = contactId;
    employee._name = contactName;
    [Employee insertMostContact:employee];
    mostList = [Employee getAllMostContact];
    [self.tableView reloadData];
}

@end
