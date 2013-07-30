//
//  EmailDetailViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "EmailDetailViewController.h"
#import "SVWebViewController.h"
#import "ReplyEmailViewController.h"
#import "ForwardEmailViewController.h"

@interface EmailDetailViewController ()

@end

@implementation EmailDetailViewController

@synthesize lblSenderName;
@synthesize lblCcName;
@synthesize lblReceiveName;
@synthesize titleCell;
@synthesize txtContext;
@synthesize btnAttachment;
@synthesize mail;
@synthesize arrayFileIds;
@synthesize arrayFileNames;
@synthesize tabbarIndex;

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
    if ([UIScreen mainScreen].bounds.size.height == 480.0) {
        [self.txtContext setFrame:CGRectMake(6, 0, 289, 197)];
    } else {
        [self.txtContext setFrame:CGRectMake(6, 0, 289, 197)];
    }
    self.title = @"邮件内容";
    [self initEmail];
}

- (void) initEmail {
    if (tabbarIndex == 3) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        // Since the buttons can be any width we use a thin image with a stretchable center point
        UIImage *buttonImage = [[UIImage imageNamed:@"action_default"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        UIImage *buttonPressedImage = [[UIImage imageNamed:@"action_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
        CGRect buttonFrame = [button frame];
        buttonFrame.size.width = buttonImage.size.width;
        buttonFrame.size.height = buttonImage.size.height;
        [button setFrame:buttonFrame];
        [button addTarget:self action:@selector(showActionTwo:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = buttonBar;
    }
    else if (tabbarIndex == 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        // Since the buttons can be any width we use a thin image with a stretchable center point
        UIImage *buttonImage = [[UIImage imageNamed:@"action_default"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        UIImage *buttonPressedImage = [[UIImage imageNamed:@"action_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
        CGRect buttonFrame = [button frame];
        buttonFrame.size.width = buttonImage.size.width;
        buttonFrame.size.height = buttonImage.size.height;
        [button setFrame:buttonFrame];
        [button addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = buttonBar;
    }
    else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        // Since the buttons can be any width we use a thin image with a stretchable center point
        UIImage *buttonImage = [[UIImage imageNamed:@"action_default"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        UIImage *buttonPressedImage = [[UIImage imageNamed:@"action_pressed"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
        CGRect buttonFrame = [button frame];
        buttonFrame.size.width = buttonImage.size.width;
        buttonFrame.size.height = buttonImage.size.height;
        [button setFrame:buttonFrame];
        [button addTarget:self action:@selector(showActionThree:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = buttonBar;
    }
    
    self.lblSenderName.text = mail.senderName;
    self.lblReceiveName.text = mail.reciverName;
    self.lblCcName.text = mail.ccListName;
    self.titleCell.textLabel.text = mail.title;
    self.titleCell.detailTextLabel.text = mail.date;
    [txtContext loadHTMLString:mail.context baseURL:nil];
    if ([mail.fileId isEqualToString:@""]) {
        [btnAttachment setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btnAttachment setHidden:YES];
    } else {
        [btnAttachment setImage:[UIImage imageNamed:@"mail_attachment.png"] forState:UIControlStateNormal];
    }
    
    [txtContext setBackgroundColor:[UIColor clearColor]];
    [self hideGradientBackground:txtContext];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            subview.hidden = YES;
        
        [self hideGradientBackground:subview];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showAction:(id)sender {
    replyActionSheet = [[UIActionSheet alloc]
                        initWithTitle:nil
                        delegate:self
                        cancelButtonTitle:@"取消"
                        destructiveButtonTitle:@"删除"
                        otherButtonTitles:@"回复", @"全部回复", @"转发", nil];
    replyActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [replyActionSheet showInView:self.view];
}

- (void)showActionTwo:(id)sender {
    deleteActionSheet = [[UIActionSheet alloc]
                        initWithTitle:nil
                        delegate:self
                        cancelButtonTitle:@"取消"
                        destructiveButtonTitle:@"彻底删除"
                        otherButtonTitles:nil, nil];
    deleteActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [deleteActionSheet showInView:self.view];
}

- (void)showActionThree:(id)sender {
    perDeleteActionSheet = [[UIActionSheet alloc]
                         initWithTitle:nil
                         delegate:self
                         cancelButtonTitle:@"取消"
                         destructiveButtonTitle:@"删除"
                         otherButtonTitles:nil, nil];
    perDeleteActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [perDeleteActionSheet showInView:self.view];
}


- (IBAction)tappedAttachMentButton:(id)sender {
    arrayFileIds = [mail.fileId componentsSeparatedByString:@","];
    arrayFileNames = [mail.fileName componentsSeparatedByString:@","];
    
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
    if (actionSheet == attachmentActionSheet) {
        if (actionSheet.cancelButtonIndex != buttonIndex) {
            NSString *strUrl;
            strUrl = [[NSUtil chooseFileRealm] stringByAppendingString:[arrayFileIds objectAtIndex:buttonIndex]];
            NSLog(@"strUrl ======= %@", strUrl);
            NSURL *URL = [NSURL URLWithString:strUrl];
            SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
            webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
            webViewController.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink | SVWebViewControllerAvailableActionsMailLink;
            [self presentModalViewController:webViewController animated:YES];
        }
    } else if (actionSheet == deleteActionSheet) {
        if (buttonIndex == 0) {
            NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
            [Mail deleteEmailById:mail.ID withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (actionSheet == perDeleteActionSheet) {
        if (buttonIndex == 0) {
            NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
            [Mail deleteReceiveEmailById:mail.ID withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"移到垃圾箱成功" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
        
        if (buttonIndex == 1) {
            ReplyEmailViewController *replyEmailViewController = [storyborad instantiateViewControllerWithIdentifier:@"ReplyEmailViewController"];
            replyEmailViewController.mail = mail;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:replyEmailViewController];
            [self presentModalViewController:navigationController animated:YES];
        } else if(buttonIndex == 2){
            ReplyEmailViewController *replyEmailViewController = [storyborad instantiateViewControllerWithIdentifier:@"ReplyEmailViewController"];
            replyEmailViewController.mail = mail;
            replyEmailViewController.replyAllFlag = true;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:replyEmailViewController];
            [self presentModalViewController:navigationController animated:YES];
        } else if(buttonIndex == 3){
            ForwardEmailViewController *forwardEmailViewController = [storyborad instantiateViewControllerWithIdentifier:@"ForwardEmailViewController"];
            forwardEmailViewController.mail = mail;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:forwardEmailViewController];
            [self presentModalViewController:navigationController animated:YES];
            
        } else if (buttonIndex == 0) {
            NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
            [Mail deleteReceiveEmailById:mail.ID withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"移到垃圾箱成功" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 45;
    } else if (indexPath.row == 1) {
        return 44;
    } else if (indexPath.row == 2) {
        return 44;
    } else if (indexPath.row == 3) {
        return 65;
    } else {
        if ([UIScreen mainScreen].bounds.size.height == 480.0) {
            return 197;
        } else {
            return 288;
        }
    }
}

@end
