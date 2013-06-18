//
//  HelpViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 13-1-24.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"Intranet_iPhone" ofType:@"doc" inDirectory:@"/"]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request]
    self.title = @"帮助";
    qlViewController = [[QLPreviewController alloc] init];
    qlViewController.dataSource = self;
    qlViewController.delegate = self;
    [self.view addSubview:qlViewController.view];
    //[self presentModalViewController:qlViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}


- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"Intranet_iPhone" ofType:@"doc" inDirectory:@"/"]];;
}

@end
