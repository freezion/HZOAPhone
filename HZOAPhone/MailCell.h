//
//  MailCell.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-7.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailCell : UITableViewCell {
	BOOL			m_checked;
}

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIImageView *attachmentImageView;
@property (nonatomic, strong) IBOutlet UILabel *senderLabel;
@property (nonatomic, strong) IBOutlet UILabel *importLabel;
@property (nonatomic, strong) IBOutlet UIImageView *readImageView;

- (void) setChecked:(BOOL)checked;

@end
