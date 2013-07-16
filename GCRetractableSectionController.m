//
//  GCRetractableSectionController.m
//  Mtl mobile
//
//  Created by Guillaume Campagna on 09-10-19.
//  Copyright 2009 LittleKiwi. All rights reserved.
//

#import "GCRetractableSectionController.h"
#import "ContactCell.h"
#import "Employee.h"
#import "ChooseEmployeeViewController.h"

@interface GCRetractableSectionController ()

@property (nonatomic, assign) UIViewController *viewController;

- (void) setAccessoryViewOnCell:(UITableViewCell*) cell;

@end

@implementation GCRetractableSectionController

@synthesize useOnlyWhiteImages, titleTextColor, titleAlternativeTextColor;
@synthesize viewController;
@synthesize open;

#pragma mark -
#pragma mark Initialisation

- (id) initWithViewController:(UIViewController*) givenViewController {
	if ((self = [super init])) {
        if (![givenViewController respondsToSelector:@selector(tableView)]) {
            //The view controller MUST have a tableView proprety
            [NSException raise:@"Wrong view controller" 
                        format:@"The passed view controller to GCRetractableSectionController must respond to the tableView proprety"];
        }
        
		self.viewController = givenViewController;
		self.open = NO;
        self.useOnlyWhiteImages = NO;
	}
	return self;
}

#pragma mark -
#pragma mark Getters

- (UITableView*) tableView {
	return [self.viewController performSelector:@selector(tableView)];
}

- (NSUInteger) numberOfRow {
    return (self.open) ? self.contentNumberOfRow + 1 : 1;
}

- (NSUInteger) contentNumberOfRow {
	return 0;
}

- (NSString*) title {
	return NSLocalizedString(@"No title",);
}

- (NSString*) titleContentForRow:(NSUInteger) row {
	return NSLocalizedString(@"No title",);
}

- (Employee *) titleContentForEmployee:(NSUInteger)row {
	Employee *employee = [[Employee alloc] init];
    return employee;
}

#pragma mark -
#pragma mark Cells

- (UITableViewCell *) cellForRow:(NSUInteger)row withButtonId:(UIButton *) buttonId {
	UITableViewCell* cell = nil;
	
	if (row == 0) cell = [self titleCell];
	else cell = [self contentCellForRow:row - 1 withButtonId:buttonId];
	
	return cell;
}

- (UITableViewCell *) titleCell {
	NSString* titleCellIdentifier = [NSStringFromClass([self class]) stringByAppendingString:@"title"];
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:titleCellIdentifier] autorelease];
	}
	
	cell.textLabel.text = self.title;
	if (self.contentNumberOfRow != 0) {
		cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%i 人",), self.contentNumberOfRow];
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [self setAccessoryViewOnCell:cell];
	}
	else {
		cell.detailTextLabel.text = NSLocalizedString(@"No item",);
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = nil;
        cell.textLabel.textColor = [UIColor blackColor];
	}
	
	return cell;
}

- (UITableViewCell *) contentCellForRow:(NSUInteger)row withButtonId:(UIButton *) buttonId {
//	NSString* contentCellIdentifier = [NSStringFromClass([self class]) stringByAppendingString:@"content"];
//	
//	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:contentCellIdentifier];
//	if (cell == nil) {
//		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:contentCellIdentifier] autorelease];
//		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//	}
//	
//	cell.textLabel.text = [self titleContentForRow:row];
//	
//	return cell;
    
    static NSString *CellIdentifier = @"ContactCell";
    
	ContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:CellIdentifier];
	}
     
	// Get the event at the row selected and display it's title
    Employee *employee = [self titleContentForEmployee:row];
	cell.textOne.text = employee._name;
    cell.textTwo.text = employee._id;
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    NSArray *selectedList = [[NSArray alloc] init];
    
    if (buttonId.tag == 0) {
        selectedList = [Employee getTmpContactByCC:@"0"];
    } else if (buttonId.tag == 1) {
        selectedList = [Employee getTmpContactByCC:@"1"];
    } else {
        selectedList = [Employee getTmpContactByCC:@"2"];
    }
    
    if (selectedList) {
        for (int i = 0; i < selectedList.count; i ++) {
            Employee *tmpEmployee = [selectedList objectAtIndex:i];
            if ([tmpEmployee._id isEqualToString:employee._id]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                break;
            }
        }
    }
	return cell;
}

- (void) setAccessoryViewOnCell:(UITableViewCell*) cell {
	NSString* path = nil;
	if (self.open) {
		path = @"UpAccessory";
        if (self.titleAlternativeTextColor == nil) cell.textLabel.textColor =  [UIColor colorWithRed:0.191 green:0.264 blue:0.446 alpha:1.000];
        else cell.textLabel.textColor = self.titleAlternativeTextColor;
	}	
	else {
		path = @"DownAccessory";
		cell.textLabel.textColor = (self.titleTextColor == nil ? [UIColor blackColor] : self.titleTextColor);
	}
	//cell.backgroundColor = [UIColor grayColor];
	UIImage* accessoryImage = [UIImage imageNamed:path];
	UIImage* whiteAccessoryImage = [UIImage imageNamed:[[path stringByDeletingPathExtension] stringByAppendingString:@"White"]];
	
	UIImageView* imageView;
	if (cell.accessoryView != nil) {
		imageView = (UIImageView*) cell.accessoryView;
		imageView.image = (self.useOnlyWhiteImages ? whiteAccessoryImage : accessoryImage);
		imageView.highlightedImage = whiteAccessoryImage;
    }
	else {
		imageView = [[UIImageView alloc] initWithImage:(self.useOnlyWhiteImages ? whiteAccessoryImage : accessoryImage)];
		imageView.highlightedImage = whiteAccessoryImage;
		cell.accessoryView = imageView;
		[imageView release];
	}
}

#pragma mark -
#pragma mark Select Cell

- (void) didSelectCellAtRow:(NSUInteger)row withButtonId:(UIButton *) buttonId withIndexPath:(NSIndexPath *) indexPath {
	if (row == 0) {
        [self didSelectTitleCell];
    }
	else {
        [self didSelectContentCellAtRow:row - 1  withButtonId:buttonId withIndexPath:indexPath];
    }
}

- (void) didSelectTitleCell {
	self.open = !self.open;
	if (self.contentNumberOfRow != 0) [self setAccessoryViewOnCell:[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]]];
	
	NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
	NSUInteger section = indexPath.section;
	NSUInteger contentCount = self.contentNumberOfRow;
	
	[self.tableView beginUpdates];
	
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (self.open) [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
	else [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
	[rowToInsert release];
	
	[self.tableView endUpdates];
	
	if (self.open) [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) didSelectContentCellAtRow:(NSUInteger)row {}

- (void) didSelectContentCellAtRow:(NSUInteger)row withButtonId:(UIButton *) buttonId withIndexPath:(NSIndexPath *) indexPath {

}

@end
