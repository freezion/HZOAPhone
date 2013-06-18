//
//  ChooseMostViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 13-1-31.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import "ChooseMostViewController.h"
#import "Employee.h"
#import "ContactCell.h"

@interface ChooseMostViewController ()

@end

@implementation ChooseMostViewController

@synthesize mostList;
@synthesize delegateEmail;
@synthesize delegateForward;
@synthesize delegateInvitEmployee;
@synthesize delegateMostContact;
@synthesize delegateNotice;
@synthesize delegateReply;
@synthesize buttonId;
@synthesize delegateSwitchView;

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
    mostList = [Employee getAllMostContact];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mostList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EmployeeCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Employee *employee = [self.mostList objectAtIndex:indexPath.row];
    cell.textOne.text = employee._name;
    cell.textTwo.text = employee._id;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Employee *employee = [self.mostList objectAtIndex:indexPath.row];
    [delegateInvitEmployee showContact:employee._id theName:employee._name];
    [delegateEmail showContact:employee._id theName:employee._name withButton:buttonId];
    [delegateReply showContact:employee._id theName:employee._name withButton:buttonId];
    [delegateForward showContact:employee._id theName:employee._name withButton:buttonId];
    [delegateNotice showContactNotice:employee._id theName:employee._name];
    [delegateMostContact showContact:employee._id theName:employee._name];
    [delegateSwitchView dismissViewController];
}

@end
