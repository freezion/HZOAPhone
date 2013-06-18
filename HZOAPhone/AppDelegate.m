//
//  AppDelegate.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-12.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "AppDelegate.h"
#import "DDMenuController.h"
#import "MainViewController.h"
#import "SpringBoardViewController.h"
#import "RightViewController.h"
#import "SystemConfig.h"
#import "Notice.h"
#import "Employee.h"
#import "SystemConfig.h"
#import "Calendar.h"
#import "Mail.h"
#import "MyFolder.h"
#import "NoticeViewController.h"
#import "EmailViewController.h"
#import "MemberViewController.h"
#import "Customer.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize menuController = _menuController;
@synthesize deviceTokenNum;
@synthesize deviceType;
@synthesize calendarMessage;
@synthesize emailMessage;
@synthesize noticeMessage;
@synthesize launchOptionsAction;
@synthesize activeFlag;

- (void)customizeAppearance
{
    // Create resizable images
    [[UIApplication sharedApplication] 
       setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    
    
    UIImage *navigationBarImage = [[UIImage imageNamed:@"bg_top_bar.png"] 
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Set the background image for *all* UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:navigationBarImage 
                                       forBarMetrics:UIBarMetricsDefault];
    
    // Customize the title text for *all* UINavigationBars
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], 
      UITextAttributeTextColor, 
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8], 
      UITextAttributeTextShadowColor, 
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], 
      UITextAttributeTextShadowOffset, 
      [UIFont fontWithName:@"MicrosoftYaHei" size:20.0], 
      UITextAttributeFont,  
      nil]];
    
    // Customize back button items differently
    UIImage *buttonBack30 = [[UIImage imageNamed:@"back_button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];

    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonBack30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *tabBackground = [[UIImage imageNamed:@"bg_tabbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UITabBar appearance] setBackgroundImage:tabBackground];
    //[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tab_select_indicator"]]; 
    
}

- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    //[UserKeychain delete:KEY_LOGINID_PASSWORD];
    [self customizeAppearance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hzoa.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:databasePath] == NO) 
    {
        [Employee createEmployeeTable];
        [Employee createMostContactTable];
        [Notice createNoticeTable];
        [Mail createEmailTable];
        [MyFolder createMyFolderTable];
        [SystemConfig createSystemConfigTable];
    }
    
    [Employee synchronizeEmployee];
    
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    MainViewController *mainViewController = [storyborad instantiateViewControllerWithIdentifier:@"MainViewController"];
    [mainViewController setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:100]];

    SystemConfig *systemConfig = [SystemConfig getSystemConfigById:@"99"];
    UINavigationController *navController = nil;
    if (systemConfig.typeId == nil) {
        MainViewController *mainViewController = [storyborad instantiateViewControllerWithIdentifier:@"MainViewController"];
        [mainViewController setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:100]];
        navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    } else {
        if ([systemConfig.typeId isEqualToString:@"1"]) {
            NoticeViewController *noticeViewController = [storyborad instantiateViewControllerWithIdentifier:@"NoticeViewController"];
            [noticeViewController setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:100]];
            navController = [[UINavigationController alloc] initWithRootViewController:noticeViewController];
        } else if ([systemConfig.typeId isEqualToString:@"2"]) {
            EmailViewController *emailViewController = [storyborad instantiateViewControllerWithIdentifier:@"EmailViewController"];
            [emailViewController setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:100]];
            navController = [[UINavigationController alloc] initWithRootViewController:emailViewController];
        } else if ([systemConfig.typeId isEqualToString:@"3"]) {
            MemberViewController *memberViewController = [storyborad instantiateViewControllerWithIdentifier:@"MemberViewController"];
            [memberViewController setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:100]];
            navController = [[UINavigationController alloc] initWithRootViewController:memberViewController];
        } else if ([systemConfig.typeId isEqualToString:@"0"]) {
            MainViewController *mainViewController = [storyborad instantiateViewControllerWithIdentifier:@"MainViewController"];
            [mainViewController setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:100]];
            navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        } 
    }
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:navController];
    _menuController = rootController;
    
    SpringBoardViewController *springBoardViewController = [storyborad instantiateViewControllerWithIdentifier:@"SpringBoardViewController"];
    rootController.leftViewController = springBoardViewController;
    
    RightViewController *rightViewController = [storyborad instantiateViewControllerWithIdentifier:@"RightViewController"];
    rootController.rightViewController = rightViewController;
    
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
    if (launchOptions != nil)
	{
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
            id alertCalendar = [dictionary objectForKey:@"Calendar"];
            id alertNotice = [dictionary objectForKey:@"Notice"];
            id alertEmail = [dictionary objectForKey:@"Email"];
            if ([alertCalendar isKindOfClass:[NSString class]]) {
                if ([alertCalendar isEqualToString:@"1"]) {
                    calendarMessage = @"1";
                } else {
                    calendarMessage = @"0";
                }
                
            } else {
                //calendarMessage = @"0";
            }
            if ([alertNotice isKindOfClass:[NSString class]]) {
                if ([alertNotice isEqualToString:@"1"]) {
                    noticeMessage = @"1";
                } else {
                    noticeMessage = @"0";
                }
            } else {

            }
            if ([alertEmail isKindOfClass:[NSString class]]) {
                if ([alertEmail isEqualToString:@"1"]) {
                    emailMessage = @"1";
                } else {
                    emailMessage = @"0";
                }
            } else {
                
            }
		}
	}
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSString *model = [[UIDevice currentDevice] model];
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    if (usernamepasswordKVPairs == nil) {
       
    } else {
        Customer *customer = [[Customer alloc] init];
        customer.LoginType = @"0";
        customer.deviceType = model;
        customer.deviceToken = [usernamepasswordKVPairs objectForKey:KEY_DEVICETOKEN];;
        customer.Location = @"";
        customer.EmpID = [usernamepasswordKVPairs objectForKey:KEY_USERID];
        [Customer takeStatus:customer];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSString *model = [[UIDevice currentDevice] model];
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    if (usernamepasswordKVPairs == nil) {
        
    } else {
        Customer *customer = [[Customer alloc] init];
        customer.LoginType = @"1";
        customer.deviceType = model;
        customer.deviceToken = [usernamepasswordKVPairs objectForKey:KEY_DEVICETOKEN];
        customer.Location = [usernamepasswordKVPairs objectForKey:KEY_PLACE] == nil ? @"" : [usernamepasswordKVPairs objectForKey:KEY_PLACE];
        customer.EmpID = [usernamepasswordKVPairs objectForKey:KEY_USERID];
        [Customer takeStatus:customer];
    }
    activeFlag = @"1";
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
	NSLog(@"My token is: %@", deviceToken);
    NSString *dToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dToken = [dToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"STR == %@",dToken);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)  
    {  
        deviceType = @"1";
    } else {
        deviceType = @"0";
    }
    deviceTokenNum = dToken;
    [usernamepasswordKVPairs setObject:deviceTokenNum forKey:KEY_DEVICETOKEN];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    id alertCalendar = [userInfo objectForKey:@"Calendar"];
    id alertNotice = [userInfo objectForKey:@"Notice"];
    id alertEmail = [userInfo objectForKey:@"Email"];
    if ([alertCalendar isKindOfClass:[NSString class]]) {
        if ([alertCalendar isEqualToString:@"1"]) {
            calendarMessage = @"1";
        } else {
            calendarMessage = @"0";
        }
        
    }
    if ([alertNotice isKindOfClass:[NSString class]]) {
        if ([alertNotice isEqualToString:@"1"]) {
            noticeMessage = @"1";
            //[usernamepasswordKVPairs setObject:noticeMessage forKey:KEY_NOTIFIY_NOTICE];
        } else {
            noticeMessage = @"0";
        }
    }
    if ([alertEmail isKindOfClass:[NSString class]]) {
        if ([alertEmail isEqualToString:@"1"]) {
            emailMessage = @"1";
            //[usernamepasswordKVPairs setObject:emailMessage forKey:KEY_NOTIFIY_EMAIL];
        } else {
            emailMessage = @"0";
        }
    }
    NSLog(@"calendarMessage === %@", calendarMessage);
    NSLog(@"noticeMessage === %@", noticeMessage);
    NSLog(@"emailMessage === %@", emailMessage);
}

@end
