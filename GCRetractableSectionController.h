//
//  GCRetractableSectionController.h
//  Mtl mobile
//
//  Created by Guillaume Campagna on 09-10-19.
//  Copyright 2009 LittleKiwi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"

@interface GCRetractableSectionController : NSObject

@property (nonatomic, assign, getter = isOpen) BOOL open;

- (id) initWithViewController:(UIViewController*) givenViewController;

//Used by the UITableView's dataSource
- (UITableViewCell*) cellForRow:(NSUInteger) row withButtonId:(UIButton *) buttonId;
@property (nonatomic, readonly) NSUInteger numberOfRow;

//Customize appearance
 //Use only white images if the cells background is dark
@property (nonatomic, assign, getter = isOnlyUsingWhiteImages) BOOL useOnlyWhiteImages;
@property (nonatomic, assign) UIColor* titleTextColor; //nil by default, black text
@property (nonatomic, assign) UIColor* titleAlternativeTextColor; //nil by default, dark blue

//Must be subclassed to work properly
@property (nonatomic, copy, readonly) NSString* title;
@property (nonatomic, readonly) NSUInteger contentNumberOfRow;
- (NSString*) titleContentForRow:(NSUInteger) row;
- (Employee *) titleContentForEmployee:(NSUInteger) row;

//Can be subclassed for more control
- (UITableViewCell*) titleCell;
- (UITableViewCell*) contentCellForRow:(NSUInteger) row withButtonId:(UIButton *) buttonId;

//Respond to cell selection
- (void) didSelectCellAtRow:(NSUInteger) row withButtonId:(UIButton *) buttonId withIndexPath:(NSIndexPath *) indexPath;
- (void) didSelectTitleCell;
- (void) didSelectContentCellAtRow:(NSUInteger) row;

//Reserved for subclasses
@property (nonatomic, readonly) UIViewController *viewController;
@property (nonatomic, readonly) UITableView *tableView;

@end
