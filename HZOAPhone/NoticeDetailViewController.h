//
//  NoticeDetailViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notice.h"

@interface NoticeDetailViewController : UITableViewController<UIActionSheetDelegate> {
    Notice *notice;
    
    UILabel *lblNoticeTitile;
    UILabel *lblSenderName;
    UILabel *lblSendDate;
    UILabel *lblSendType;
    UITextView *txtContext;
    UIButton *attchmentButton;
    NSArray *arrayFileIds;
    NSArray *arrayFileNames;
    UIActionSheet *attachmentActionSheet;
    NSString *fileId;
}

@property (nonatomic, retain) Notice *notice;
@property (nonatomic, retain) IBOutlet UILabel *lblNoticeTitile;
@property (nonatomic, retain) IBOutlet UILabel *lblSenderName;
@property (nonatomic, retain) IBOutlet UILabel *lblSendDate;
@property (nonatomic, retain) IBOutlet UILabel *lblSendType;
@property (nonatomic, retain) IBOutlet UITextView *txtContext;
@property (nonatomic, retain) IBOutlet UIButton *attchmentButton;
@property (nonatomic, retain) NSString *fileId;

- (IBAction)tappedAttachMentButton:(id)sender;

@end
