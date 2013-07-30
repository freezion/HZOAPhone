//
//  EventAlertViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "EventAlertViewController.h"

@interface EventAlertViewController ()

@end

@implementation EventAlertViewController

@synthesize selectedIndex;
@synthesize CellNone;
@synthesize CellThirty;
@synthesize CellOneHour;
@synthesize CellFifteen;
@synthesize CellFortyFive;
@synthesize timerInterval;
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
    self.title = @"事件提醒";
    [self initEventAlert];
}

- (void)initEventAlert {
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
    
    if (selectedIndex == 0) {
        CellNone.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (selectedIndex == 1) {
        CellFifteen.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (selectedIndex == 2) {
        CellThirty.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (selectedIndex == 3) {
        CellFortyFive.accessoryType = UITableViewCellAccessoryCheckmark;
    } else if (selectedIndex == 4) {
        CellOneHour.accessoryType = UITableViewCellAccessoryCheckmark;
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

- (void)backAction:(id) sender {
    [delegate eventAlertViewController:self didSelectAlert:timerInterval withSelectIndex:selectedIndex withLabelTitle:[self retTextByIndex:selectedIndex]];
}

- (NSString *) retTextByIndex:(int) selectIndex {
    NSString *text = @"无";
    if (selectIndex == 0) {
        text = CellNone.textLabel.text;
    } else if (selectIndex == 1) {
        text = CellFifteen.textLabel.text;
    } else if (selectIndex == 2) {
        text = CellThirty.textLabel.text;
    } else if (selectIndex == 3) {
        text = CellFortyFive.textLabel.text;
    } else if (selectIndex == 4) {
        text = CellOneHour.textLabel.text;
    }
    return text;
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
    
    int i = indexPath.row;
    timerInterval = nil;
    if (i == 1) {
        double timer = 15 * 60;
        timerInterval = [NSString stringWithFormat:@"%f", timer];
    } else if (i == 2) {
        double timer = 30 * 60; 
        timerInterval = [NSString stringWithFormat:@"%f", timer];
    } else if (i == 3) {
        double timer = 45 * 60;
        timerInterval = [NSString stringWithFormat:@"%f", timer];
    } else if (i == 4) {
        double timer = 60 * 60;
        timerInterval = [NSString stringWithFormat:@"%f", timer];
    } 
}

@end
