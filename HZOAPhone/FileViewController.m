//
//  FileViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-10-25.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "FileViewController.h"

@interface FileViewController ()

@end

@implementation FileViewController
@synthesize memberId;
@synthesize fileList;


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
    NSLog(@"%@", memberId);
    fileList = [MyFolder getFileByCompanyId:memberId];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void) dismissAction:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return [fileList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FileCell";
    FileCell *cell = (FileCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MyFolder *myFolder = [fileList objectAtIndex:[indexPath row]];
    // Configure the cell...
    cell.fileName.text = myFolder.fileName;
    cell.uploadEmp.text = myFolder.EmployeeName;
    cell.uploadTime.text = myFolder.uploadTime;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFolder *myFolder = [fileList objectAtIndex:[indexPath row]];
    NSString *strUrl = [FILE_ADDRESS stringByAppendingString:myFolder.fileId];
    NSLog(@"strUrl ======= %@", strUrl);
    NSURL *URL = [NSURL URLWithString:strUrl];
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink | SVWebViewControllerAvailableActionsMailLink;
    [self presentModalViewController:webViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
