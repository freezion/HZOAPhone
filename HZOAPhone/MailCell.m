//
//  MailCell.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-7.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "MailCell.h"

@implementation MailCell

@synthesize titleLabel;
@synthesize detailLabel;
@synthesize dateLabel;
@synthesize senderLabel;
@synthesize attachmentImageView;
@synthesize importLabel;
@synthesize readImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
