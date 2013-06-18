//
//  LoginViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-18.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "LoginViewController.h"
#import "Calendar.h"
#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize txtUserId;
@synthesize txtPassword;
@synthesize subButton;

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
    [txtUserId becomeFirstResponder];
    [txtPassword becomeFirstResponder];
    self.txtUserId.delegate = self;
    self.txtPassword.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)login:(id)sender {
    //验证用户名 密码]
    subButton.hidden = YES;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = NO;
    [HUD setDelegate:self];
    
    [HUD setFrame:CGRectMake(270, 195, 0, 0)];
    [HUD showWhileExecuting:@selector(myLoginTask) onTarget:self withObject:nil animated:YES];
}

- (void)myLoginTask {
    
    NSString *user = [txtUserId.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"%@",user);
    NSString *pass = [txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"%@",pass);
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"UserCheck.asmx/loginUserCheckForIOS"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    
    NSString *deviceType = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceType;
    NSString *deviceTokenNum = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceTokenNum;
     NSLog(@"%@",deviceType);
     NSLog(@"%@",deviceTokenNum);
    
    NSString *model = [[UIDevice currentDevice] model];
    if ([model isEqualToString:@"iPhone Simulator"]) {
        deviceType = @"1";
        deviceTokenNum = @"2418a90de97c88f86c16093f12e903aaa0c00c08";
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:user forKey:@"name"];
    [request setPostValue:pass forKey:@"pwd"];
    [request setPostValue:deviceType forKey:@"deviceType"];
    [request setPostValue:deviceTokenNum forKey:@"deviceToken"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@", [request responseString]);
    
    if(request.responseStatusCode == 200)
    {
        NSString *responseString = [request responseString];
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
        GDataXMLElement *root = [doc rootElement];
        NSString *xmlString = [root stringValue];
        if ([xmlString isEqualToString:@"errorPwd"] || [xmlString isEqualToString:@"unExist"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            self.subButton.hidden = NO;
        } else {
            NSString *deviceTokenNum = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceTokenNum;
            NSArray *listItems = [[NSArray alloc]init];
            listItems = [xmlString componentsSeparatedByString:@","];
            NSString *userId = [listItems objectAtIndex:0];
            NSString *name = [listItems objectAtIndex:1];
            NSString *deptId = [listItems objectAtIndex:2];
            NSString *canRead = [listItems objectAtIndex:3];
            //用户名和密码存入keychain
            NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
            [usernamepasswordKVPairs setObject:txtUserId.text forKey:KEY_LOGINID];
            [usernamepasswordKVPairs setObject:txtPassword.text forKey:KEY_PASSWORD];
            [usernamepasswordKVPairs setObject:userId forKey:KEY_USERID];
            [usernamepasswordKVPairs setObject:name forKey:KEY_USERNAME];
            [usernamepasswordKVPairs setObject:deptId forKey:KEY_DEPTID];
            [usernamepasswordKVPairs setObject:canRead forKey:KEY_READ_CONTRACT];
            NSString *model = [[UIDevice currentDevice] model];
            NSLog(@"EmployeeId ==== %@", userId);
            if ([model isEqualToString:@"iPhone Simulator"]) {
                deviceTokenNum = @"2418a90de97c88f86c16093f12e903aaa0c00c08";
            }
            [usernamepasswordKVPairs setObject:deviceTokenNum forKey:KEY_DEVICETOKEN];
            
            [usernamepasswordKVPairs setObject:@"0" forKey:KEY_NOTIFIY_CALENDAR];
            [usernamepasswordKVPairs setObject:@"0" forKey:KEY_NOTIFIY_NOTICE];
            [usernamepasswordKVPairs setObject:@"0" forKey:KEY_NOTIFIY_EMAIL];
            
            //save session
            [UserKeychain save:KEY_LOGINID_PASSWORD data:usernamepasswordKVPairs];
            
            // dismiss self
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法访问，请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    NSLog(@"request finished");    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
    self.subButton.hidden = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [self login:nil];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

@end
