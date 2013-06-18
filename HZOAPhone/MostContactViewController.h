//
//  MostContactViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 13-1-30.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MostContactDelegate <NSObject>
- (void) showContact:(NSString *) contactId theName:(NSString *) contactName;
@end

@interface MostContactViewController : UITableViewController<MostContactDelegate> {
    NSMutableArray *mostList;
    int selectRow;
}

@property (nonatomic, retain) NSMutableArray *mostList;
@property (nonatomic) int selectRow;

@end
