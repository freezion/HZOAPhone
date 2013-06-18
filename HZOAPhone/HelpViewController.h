//
//  HelpViewController.h
//  HZOAPhone
//
//  Created by Gong Lingxiao on 13-1-24.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface HelpViewController : UIViewController<QLPreviewControllerDataSource, QLPreviewControllerDelegate> {
    UIWebView *webView;
    QLPreviewController *qlViewController;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
