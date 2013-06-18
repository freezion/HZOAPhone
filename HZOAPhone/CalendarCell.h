//
//  CalendarCell.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-5.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *startTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *startTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *endTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *endTextLabel;
@property (nonatomic, strong) IBOutlet UIImageView *alldayImage;

@end
