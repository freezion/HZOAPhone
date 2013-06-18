//
//  GCCustomSectionController.m
//  Demo
//
//  Created by Guillaume Campagna on 11-04-21.
//  Copyright 2011 LittleKiwi. All rights reserved.
//

#import "GCCustomSectionController.h"
#import "ContactCell.h"
#import "Employee.h"

@interface GCCustomSectionController ()

@property (nonatomic, readonly) NSArray* content;

@end

@implementation GCCustomSectionController

@synthesize content;

#pragma mark -
#pragma mark Simple subclass

- (NSString *)title {
    return NSLocalizedString(@"Custom",);
}

- (NSUInteger)contentNumberOfRow {
    return [self.content count];
}

- (NSString *)titleContentForRow:(NSUInteger)row {
    return [self.content objectAtIndex:row];
}

#pragma mark -
#pragma mark Customization

- (UITableViewCell *)cellForRow:(NSUInteger)row {
    //All cells in the GCRetractableSectionController will be indented
    UITableViewCell* cell = nil;
	
	if (row == 0) cell = [self titleCell];
	else cell = [self contentCellForRow:row - 1];
	
	return cell;
}

- (UITableViewCell *)titleCell {
    //I removed the detail text here, but you can do whatever you want
    UITableViewCell* titleCell = [super titleCell];
    titleCell.detailTextLabel.text = nil;
    
    return titleCell;
}

- (UITableViewCell *)contentCellForRow:(NSUInteger)row {
    static NSString *CellIdentifier = @"ContactCell";
    
	ContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:CellIdentifier];
	}
    
	// Get the event at the row selected and display it's title
    Employee *employee = [self.content objectAtIndex:row];
    
	cell.textOne.text = employee._name;
    cell.textTwo.text = employee._id;
    
	return cell;
}

#pragma mark -
#pragma mark Getters 

- (NSArray *)content {
    if (content == nil) {
        content = [[NSArray alloc] initWithObjects:@"You can do", @"WHATEVER", @"you want!", nil];
    }
    return content;
}

- (void)dealloc {
    [content release];
    
    [super dealloc];
}

@end
