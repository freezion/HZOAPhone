//
//  FileCell.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-10-25.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileCell : UITableViewCell

@property (nonatomic ,retain) IBOutlet UILabel *fileName;
@property (nonatomic ,retain) IBOutlet UILabel *uploadEmp;
@property (nonatomic ,retain) IBOutlet UILabel *uploadTime;

@end
