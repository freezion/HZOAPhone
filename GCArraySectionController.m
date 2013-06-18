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

- (void)didSelectContentCellAtRow:(NSUInteger)row  withButtonId:(UIButton *) buttonId {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
    Employee *employee = [self.content objectAtIndex:row];
    [delegateInvitEmployee showContact:employee._id theName:employee._name];
    [delegateNewEmail showContact:employee._id theName:employee._name withButton:buttonId];
    [delegateReply showContact:employee._id theName:employee._name withButton:buttonId];
    [delegateForward showContact:employee._id theName:employee._name withButton:buttonId];
    [delegateNewNotice showContactNotice:employee._id theName:employee._name];
    [delegateMostContact showContact:employee._id theName:employee._name];
    [delegateSwitchView dismissViewController];
}

- (void)dealloc {
    self.content = nil;
    self.title = nil;
    
    [super dealloc];
}

@end
