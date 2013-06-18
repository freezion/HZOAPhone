//
//  RealCopyrightsViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-11-17.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealCopyrightsViewController : UIViewController {
    UIButton *urlButton;
    UILabel *versionLabel;
}

@property (nonatomic, retain) IBOutlet UIButton *urlButton;
@property (nonatomic, retain) IBOutlet UILabel *versionLabel;

-(IBAction) showSite:(id) sender;
-(IBAction) goAppStore:(id)sender;

@end
