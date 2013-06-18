//
//  ChooseTypeViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemConfig.h"
#import "Calendar.h"

@class ChooseTypeViewController;

@protocol ChooseTypeDelegate <NSObject>
- (void)chooseTypeViewController:(ChooseTypeViewController *)controller didSelectType:(NSString *) typeId withSelectIndex:(int) selectedIndex withLabelTitle:(NSString *) title;
@end

@interface ChooseTypeViewController : UITableViewController {
    int selectedIndex;
    NSString *typeId;
    NSString *typeName;
    SystemConfig *didSelectSystemConfig;
    NSMutableArray *values;
    
    }

@property (nonatomic, retain) id<ChooseTypeDelegate> delegate;
@property (nonatomic, retain) NSString *typeId;
@property (nonatomic, retain) NSString *typeName;
@property (nonatomic) int selectedIndex;
@property (nonatomic, retain) SystemConfig *didSelectSystemConfig;
@property (nonatomic, retain) NSMutableArray *values;

@end
