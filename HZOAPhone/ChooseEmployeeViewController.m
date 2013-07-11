//
//  ChooseEmployeeViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-29.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "ChooseEmployeeViewController.h"

@interface ChooseEmployeeViewController ()

@end

@implementation ChooseEmployeeViewController

@synthesize dictionary;
@synthesize list;
@synthesize buttonId;
@synthesize retractableControllers;
@synthesize arrayController;
@synthesize delegateInvitEmployee;
@synthesize delegateEmail;
@synthesize delegateNotice;
@synthesize delegateReply;
@synthesize delegateForward;
@synthesize delegateMostContact;
@synthesize status;
@synthesize delegateSwitchView;
@synthesize checkedIndexPath;

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
    self.title = @"选择发送人";
    
    [self initChooseEmployee];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) initChooseEmployee {    
    self.dictionary = [[NSMutableDictionary alloc] init];
    //selectedList = [Employee getAllTmpContact];
	//分配给list
	self.list = [NSArray arrayWithArray:[Employee getAllEmployee]];
    for (int i = 0; i < [list count]; i ++) {
        Employee *employee = [list objectAtIndex:i];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        BOOL flag = NO;
        for (NSString *currentValue in [dictionary allKeys])
        {
            if ([currentValue isEqualToString:employee._partyName]) {
                flag = YES;
            }
        }
        if (flag) {
            array = [dictionary objectForKey:employee._partyName];
            [array addObject:employee];
            [dictionary setObject:array forKey:employee._partyName];
        } else {
            [array addObject:employee];
            [dictionary setObject:array forKey:employee._partyName];
        }
    }
    self.retractableControllers = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSArray *value = [dictionary objectForKey:key];
        arrayController = [[GCArraySectionController alloc] initWithArray:value viewController:self];
        arrayController.title = NSLocalizedString(key,);
        arrayController.delegateInvitEmployee = delegateInvitEmployee;
        arrayController.delegateNewEmail = delegateEmail;
        arrayController.delegateNewNotice = delegateNotice;
        arrayController.delegateReply = delegateReply;
        arrayController.delegateForward = delegateForward;
        arrayController.delegateMostContact = delegateMostContact;
        arrayController.delegateSwitchView = delegateSwitchView;
        [self.retractableControllers addObject:arrayController];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dictionary.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    GCRetractableSectionController *sectionController = [self.retractableControllers objectAtIndex:section];
    return sectionController.numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCRetractableSectionController *sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    
    return [sectionController cellForRow:indexPath.row withButtonId:buttonId];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCRetractableSectionController *sectionController = [self.retractableControllers objectAtIndex:indexPath.section];
    return [sectionController didSelectCellAtRow:indexPath.row withButtonId:buttonId withIndexPath:indexPath];
}

- (void)doCancel {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doChange {
    
}

@end
