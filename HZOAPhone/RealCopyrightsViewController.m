//
//  RealCopyrightsViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-11-17.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "RealCopyrightsViewController.h"
#import "SystemConfig.h"

@interface RealCopyrightsViewController ()

@end

@implementation RealCopyrightsViewController
@synthesize urlButton;
@synthesize versionLabel;

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
    self.title = @"版权信息";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    versionLabel.text = version;
    double ver = [version doubleValue];
    NSString *currVersion = [SystemConfig getVersion];
    if (ver < [currVersion doubleValue]) {
        [urlButton setTitle:@"点击下载新版本" forState:UIControlStateNormal];
    } else {
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) showSite:(id) sender {
    NSURL* url = [[NSURL alloc] initWithString:@"http://www.shcs.com.cn/"];
    [[ UIApplication sharedApplication]openURL:url];
}

-(IBAction) goAppStore:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/hua-zhong-zi-xun/id575478439?mt=8"]];
}

@end
