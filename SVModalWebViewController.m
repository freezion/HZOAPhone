//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"

@interface SVModalWebViewController ()

@property (nonatomic, strong) SVWebViewController *webViewController;

@end


@implementation SVModalWebViewController

@synthesize barsTintColor, availableActions, webViewController;

#pragma mark - Initialization


- (id)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    self.webViewController = [[SVWebViewController alloc] initWithURL:URL];
    if (self = [super initWithRootViewController:self.webViewController]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonImage = [[UIImage imageNamed:@"finish"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        UIImage *buttonPressedImage = [[UIImage imageNamed:@"finish2"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
        CGRect buttonFrame = [button frame];
        buttonFrame.size.width = buttonImage.size.width;
        buttonFrame.size.height = buttonImage.size.height;
        [button setFrame:buttonFrame];
        [button addTarget:webViewController action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.webViewController.navigationItem.leftBarButtonItem = buttonBar;
        //self.webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webViewController action:@selector(doneButtonClicked:)];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.navigationBar.tintColor = self.toolbar.tintColor = self.barsTintColor;
}

- (void)setAvailableActions:(SVWebViewControllerAvailableActions)newAvailableActions {
    self.webViewController.availableActions = newAvailableActions;
}

@end
