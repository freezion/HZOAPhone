//
//  EmailDetailViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mail.h"

@interface EmailDetailViewController : UITableViewController<UIActionSheetDelegate> {
    UILabel *lblSenderName;
    UILabel *lblReceiveName;
    UILabel *lblCcName;
    UITableViewCell *titleCell;
    UIWebView *txtContext;
    Mail *mail;
    UIButton *btnAttachment;
    NSArray *arrayFileIds;
    NSArray *arrayFileNames;
    UIActionSheet *attachmentActionSheet;
    UIActionSheet *replyActionSheet;
    UIActionSheet *deleteActionSheet;
    UIActionSheet *perDeleteActionSheet;
    int tabbarIndex;
}

@property (nonatomic, retain) IBOutlet UILabel *lblSenderName;
@property (nonatomic, retain) IBOutlet UILabel *lblReceiveName;
@property (nonatomic, retain) IBOutlet UILabel *lblCcName;
@property (nonatomic, retain) IBOutlet UITableViewCell *titleCell;
@property (nonatomic, retain) IBOutlet UIWebView *txtContext;
@property (nonatomic, retain) IBOutlet UIButton *btnAttachment;
@property (nonatomic, retain) Mail *mail;
@property (nonatomic, retain) NSArray *arrayFileIds;
@property (nonatomic, retain) NSArray *arrayFileNames;
@property (nonatomic) int tabbarIndex;

- (IBAction)tappedAttachMentButton:(id)sender;

@end
