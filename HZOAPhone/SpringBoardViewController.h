//
//  SpringBoardViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-15.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpringBoardViewController : UIViewController {
    UIImageView *imageView;
    UIButton *calendarButton;
    UIButton *noticeButton;
    UIButton *emailButton;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *calendarButton;
@property (nonatomic, retain) IBOutlet UIImageView *calendarImage;
@property (nonatomic, retain) IBOutlet UIImageView *emailImage;
@property (nonatomic, retain) IBOutlet UIImageView *noticeImage;
@property (nonatomic, retain) IBOutlet UIButton *noticeButton;
@property (nonatomic, retain) IBOutlet UIButton *emailButton;

- (IBAction)showCalendar:(id) sender;
- (IBAction)showNotice:(id) sender;
- (IBAction)showEmail:(id) sender;
- (IBAction)showMember:(id) sender;

@end
