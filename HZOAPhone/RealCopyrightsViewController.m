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
    NSString *currVersion = [SystemConfig getVersion];
    if (![version isEqualToString:currVersion]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"App的版本过低请下载新版本."
                                                       delegate:self
                                              cancelButtonTitle:@"前往下载"
                                              otherButtonTitles:nil, nil];
        [alert performSelector:@selector(show) withObject:nil afterDelay:0.0];
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
