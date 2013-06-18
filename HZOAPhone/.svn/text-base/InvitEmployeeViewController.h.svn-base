//
//  InvitEmployeeViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSTokenField.h"

@class InvitEmployeeViewController;

@protocol InvitEmployeeDelegate <NSObject>
- (void) showContact:(NSString *) contactId theName:(NSString *) contactName;
@end

@protocol InvitEmployeeViewControllerDelegate <NSObject>
- (void)invitEmployeeViewController:(InvitEmployeeViewController *)controller didSelectContact:(int) count withTokens:(NSArray *) tokens withInvations:(NSString *) invations withListContactId:(NSMutableDictionary *) listContactId;
@end

@interface InvitEmployeeViewController : UIViewController<JSTokenFieldDelegate, InvitEmployeeDelegate> {
    JSTokenField *toField;
    NSMutableDictionary *listContactId;
     NSMutableArray *toRecipients;
    id<InvitEmployeeViewControllerDelegate> delegate;
    NSArray *tokens;
}

@property (nonatomic, retain) id<InvitEmployeeViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet JSTokenField *toField;
@property (nonatomic, retain) NSMutableDictionary *listContactId;
@property (nonatomic, retain) NSArray *tokens;

@end
