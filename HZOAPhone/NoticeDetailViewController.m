//
//  NoticeDetailViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "NoticeViewController.h"
#import "SVModalWebViewController.h"

@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController

@synthesize notice;
@synthesize lblSendDate;
@synthesize lblSenderName;
@synthesize lblNoticeTitile;
@synthesize txtContext;
@synthesize lblSendType;
@synthesize attchmentButton;
@synthesize fileId;

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
    self.title = @"公告内容";
    [self initNotice];
}

- (void) initNotice {
    lblNoticeTitile.text = notice.title;
    lblSendDate.text = notice.date;
    lblSenderName.text = notice.sender;
    lblSendType.text = notice.typeName;
    txtContext.text = notice.context;
    if ([notice.fileId isEqualToString:@""] || notice.fileId == nil) {
        [attchmentButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [attchmentButton setHidden:YES];
    } else {
        [attchmentButton setImage:[UIImage imageNamed:@"mail_attachment.png"] forState:UIControlStateNormal];
        [attchmentButton setHidden:NO];
        self.fileId = notice.fileId;
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

- (IBAction)tappedAttachMentButton:(id)sender {
    arrayFileIds = [notice.fileId componentsSeparatedByString:@","];
    arrayFileNames = [notice.fileName componentsSeparatedByString:@","];
    
    attachmentActionSheet = [[UIActionSheet alloc]
                             initWithTitle:@"邮件附件"
                             delegate:self
                             cancelButtonTitle:nil
                             destructiveButtonTitle:nil
                             otherButtonTitles:nil, nil];
    for (int i = 0; i < [arrayFileNames count]; i++) {
        [attachmentActionSheet addButtonWithTitle:[arrayFileNames objectAtIndex:i]];
    }
    [attachmentActionSheet addButtonWithTitle:@"取消"];
    
    attachmentActionSheet.cancelButtonIndex = attachmentActionSheet.numberOfButtons - 1;
    
    attachmentActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [attachmentActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        NSString *strUrl;
        strUrl = [FILE_ADDRESS stringByAppendingString:[arrayFileIds objectAtIndex:buttonIndex]];
        NSLog(@"strUrl ======= %@", strUrl);
        NSURL *URL = [NSURL URLWithString:strUrl];
        SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
        webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        webViewController.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink | SVWebViewControllerAvailableActionsMailLink;
        [self presentModalViewController:webViewController animated:YES];
    }
}

@end
