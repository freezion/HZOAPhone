//
//  GCArraySectionController.m
//  Demo
//
//  Created by Guillaume Campagna on 11-04-21.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import "GCArraySectionController.h"
#import "Employee.h"


@interface GCArraySectionController ()

@property (nonatomic, retain) NSArray* content;

@end

@implementation GCArraySectionController

@synthesize content, title;
@synthesize delegateInvitEmployee;
@synthesize delegateNewEmail;
@synthesize delegateNewNotice;
@synthesize delegateReply;
@synthesize delegateForward;
@synthesize delegateMostContact;
@synthesize delegateSwitchView;

- (id)initWithArray:(NSArray *)array viewController:(UIViewController *)givenViewController {
    if ((self = [super initWithViewController:givenViewController])) {
        self.content = array;
    }
    return self;
}

#pragma mark -
#pragma mark Subclass

- (NSUInteger)contentNumberOfRow {
    return [self.content count];
}

- (NSString *)titleContentForRow:(NSUInteger)row {
    return [self.content objectAtIndex:row];
}

- (Employee *)titleContentForEmployee:(NSUInteger)row {
    return [self.content objectAtIndex:row];
}

- (void)didSelectContentCellAtRow:(NSUInteger)row  withButtonId:(UIButton *) buttonId withIndexPath:(NSIndexPath *) indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    Employee *employee = [self.content objectAtIndex:row];
    BOOL flag = TRUE;
    UITableViewCell *thisCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else{
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        if (buttonId.tag == 0) {
            [Employee deleteTmpContact:employee._id withForCC:@"0"];
        } else {
            [Employee deleteTmpContact:employee._id withForCC:@"1"];
        }
        flag = FALSE;
    }
    NSArray *selectedList = [[NSArray alloc] init];
    if (buttonId.tag == 0) {
        selectedList = [Employee getTmpContactByCC:@"0"];
    } else {
        selectedList = [Employee getTmpContactByCC:@"1"];
    }
    if (selectedList) {
        for (int i = 0; i < selectedList.count; i ++) {
            Employee *tmpEmployee = [selectedList objectAtIndex:i];
            if ([tmpEmployee._id isEqualToString:employee._id]) {
                flag = FALSE;
                break;
            }
        }
    }
    if (flag) {
        [delegateNewEmail showContact:employee._id theName:employee._name withButton:buttonId];
        [delegateInvitEmployee showContact:employee._id theName:employee._name];
        [delegateReply showContact:employee._id theName:employee._name withButton:buttonId];
        [delegateForward showContact:employee._id theName:employee._name withButton:buttonId];
        [delegateNewNotice showContactNotice:employee._id theName:employee._name];
    } else {
        [delegateNewEmail deleteContact:employee._id theName:employee._name withButton:buttonId];
        [delegateReply deleteContact:employee._id theName:employee._name withButton:buttonId];
        [delegateForward deleteContact:employee._id theName:employee._name withButton:buttonId];
        //[delegateInvitEmployee deleteContact:employee._id theName:employee._name withButton:buttonId];
        //[delegateNewNotice deleteContact:employee._id theName:employee._name withButton:buttonId];
        //[delegateMostContact deleteContact:employee._id theName:employee._name withButton:buttonId];
    }
    if (delegateMostContact) {
        [delegateMostContact showContact:employee._id theName:employee._name];
        [delegateSwitchView dismissViewController];
    }
}

- (void)dealloc {
    self.content = nil;
    self.title = nil;
    
    [super dealloc];
}

@end
