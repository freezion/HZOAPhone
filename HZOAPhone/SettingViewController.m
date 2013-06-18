//
//  SettingViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-11-2.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize systemConfig;
@synthesize calendarCell;
@synthesize noticeCell;
@synthesize emailCell;
@synthesize memberCell;
@synthesize selectedIndex;

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
    self.title = @"设定";
    [self initSettings];
}

- (void)initSettings {
    SystemConfig *systemConfigLocal = [SystemConfig getSystemConfigById:@"99"];
    if (systemConfigLocal.typeId == nil) {
        systemConfig = [[SystemConfig alloc] init];
        systemConfig.ID = @"99";
        systemConfig.typeId = @"0";
        systemConfig.name = @"";
        [SystemConfig insertSystemConfig:systemConfig];
    } else {
        systemConfig = systemConfigLocal;
        selectedIndex = [systemConfig.typeId intValue]; 
    }
    
    if ([systemConfig.typeId isEqualToString:@"0"]) {
        calendarCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if ([systemConfig.typeId isEqualToString:@"1"]) {
        noticeCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if ([systemConfig.typeId isEqualToString:@"2"]) {
        emailCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if ([systemConfig.typeId isEqualToString:@"3"]) {
        memberCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (selectedIndex != NSNotFound)
	{
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    selectedIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
    systemConfig = [[SystemConfig alloc] init];
    systemConfig.ID = @"99";
    systemConfig.typeId = [NSString stringWithFormat:@"%d", selectedIndex];
    systemConfig.name = @"";
    [SystemConfig updateSystemConfig:systemConfig];
}

@end
