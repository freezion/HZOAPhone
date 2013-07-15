//
//  NewEmailViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-19.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "NewEmailViewController.h"
#import "RightViewController.h"
#import "Calendar.h"
#import "SwitchViewController.h"

@interface NewEmailViewController ()

@end

@implementation NewEmailViewController

@synthesize toField;
@synthesize ccField;
@synthesize lblEmailType;
@synthesize titleView;
@synthesize scrollView;
@synthesize contextTextView;
@synthesize keyboardToolbar;
@synthesize toButton;
@synthesize ccButton;
@synthesize subTitle;
@synthesize mail;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleTokenFieldFrameDidChange:)
												 name:JSTokenFieldFrameDidChangeNotification
											   object:nil];
    usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    self.title = @"发送邮件";
    [self setupUI];
}

- (void) updateClicked {
    
}

- (void) setupUI {
    UIColor *color = [UIColor whiteColor];
    [[toField label] setTextColor:[UIColor darkGrayColor]];
    [[toField label] setText:@"收件人:"];
    [[toField label] setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:18.0]];
    [[toField textField] setTag:0];
    [toField setBackgroundColor:color];
    [toField setDelegate:self];
    
    toButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    toButton.tag = 0;
	[toButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
	[[toField textField] setRightView:toButton];
	[[toField textField] addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
	[[toField textField] addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [[ccField label] setTextColor:[UIColor darkGrayColor]];
    [[ccField label] setText:@"抄送人:"];
    [[ccField label] setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:18.0]];
    [[ccField textField] setTag:1];
    [ccField setBackgroundColor:color];
    [ccField setDelegate:self];
    
    ccButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    ccButton.tag = 1;
	[ccButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
	[[ccField textField] setRightView:ccButton];
	[[ccField textField] addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
	[[ccField textField] addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [lblEmailType setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:18.0]];
    
    self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 84, 320, 40)];
    keyboardToolbar.tag = 10;
    keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *cancelButton = [self setupLeftBar];
    UIBarButtonItem *doneButton = [self setupRightBar];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:cancelButton, spacer, doneButton, nil]];
    [self.view addSubview:keyboardToolbar];
    
    if (mail) {
        NSMutableString *recipient = [NSMutableString string];
        
        NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
        [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
        
        NSArray *reciverIds = [mail.reciver componentsSeparatedByString:@","];
        NSArray *recivers = [mail.reciverName componentsSeparatedByString:@","];
        int i = 0;
        for (NSString *reciver in recivers) {
            [toField addTokenWithTitle:reciver representedObject:recipient];
            
        }
        for (NSString *reciverId in reciverIds) {
            if (![reciverId isEqualToString:@""]) {
                Employee *employee = [[Employee alloc] init];
                employee._id = reciverId;
                employee._name = @"";
                employee._forCC = @"0";
                [Employee insertTmpContact:employee];
                i ++;
            }
            
        }
        NSArray *daIds =[mail.ccList componentsSeparatedByString:@","];
        NSArray *das =[mail.ccListName componentsSeparatedByString:@","];
        int j = 0;
        for (NSString *da in das) {
            [ccField addTokenWithTitle:da representedObject:recipient];
        }
        for (NSString *daId in daIds) {
            if (![daId isEqualToString:@""]) {
                Employee *employee = [[Employee alloc] init];
                employee._id = daId;
                employee._name = @"";
                employee._forCC = @"0";
                [Employee insertTmpContact:employee];
                j ++;
            }
        }
        
        subTitle.text = mail.title;
        contextTextView.text = mail.context;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) checkEmailField {
    BOOL flag = YES;
    int count = [[Employee getTmpContactByCC:@"0"] count];
    NSString *subTitleValue = [subTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *messageViewValue = [contextTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([subTitleValue isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入邮件标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];       
        flag = NO;
    } else if (count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择收件人，或者选择的收件人不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        flag = NO;
    } else if ([messageViewValue isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入邮件内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        flag = NO;
    } 
    return flag;
}

- (void)doSendShowHub {
    [self.view endEditing:YES];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"发送中..."];
    [HUD showWhileExecuting:@selector(doSend) onTarget:self withObject:nil animated:YES];
}

- (void)doSend {
    if ([self checkEmailField]) {
        
        NSArray *toList = [Employee getTmpContactByCC:@"0"];
        NSString *receiveList = @"";
        int i = 0;
        if (toList) {
            for (Employee *employee in toList) {
                if (i == ([toList count] - 1)) {
                    receiveList = [receiveList stringByAppendingFormat:@"%@", employee._id];
                } else {
                    receiveList = [receiveList stringByAppendingFormat:@"%@,", employee._id];
                }
                i ++;
            }
        }
        
        NSArray *ccList = [Employee getTmpContactByCC:@"1"];
        NSString *ccValue = @"";
        i = 0;
        if (ccList) {
            for (Employee *employee in ccList) {
                if (i == ([ccList count] - 1)) {
                    ccValue = [ccValue stringByAppendingFormat:@"%@", employee._id];
                } else {
                    ccValue = [ccValue stringByAppendingFormat:@"%@,", employee._id];
                }
                i ++;
            }
        }
  
        mail = [[Mail alloc] init];
        mail.ID = @"";
        mail.title = subTitle.text;
        mail.context = contextTextView.text;
        mail.date = [NSUtil parserDateToString:[NSDate date]];
        mail.sender = [usernamepasswordKVPairs objectForKey:KEY_USERID];
        mail.senderName = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
        mail.reciver = receiveList;
        mail.ccList = ccValue;
        mail.reciverName = @"";
        mail.fileId = @"";
        mail.fileName = @"";
        mail.readed = @"0";
        mail.importId = @"0";
        mail.importName = @"";
        mail.deptment = @"";
        // 已发送 1
        mail.status = @"1";
        NSString *retStr = [Mail serviceAddEmail:mail];
        if (retStr) {
            [self performSelectorOnMainThread:@selector(alertAdd) withObject:nil waitUntilDone:NO];
        } else {
            [self performSelectorOnMainThread:@selector(alertFailure) withObject:nil waitUntilDone:NO];
        }
    
    }
}

- (void) alertAdd {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) alertFailure {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)doSaveTmpShowHub {
    [self.view endEditing:YES];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"保存中..."];
    [HUD showWhileExecuting:@selector(doSaveTmp) onTarget:self withObject:nil animated:YES];
}

- (void)doSaveTmp {
    NSArray *toList = [Employee getTmpContactByCC:@"0"];
    NSString *receiveList = @"";
    int i = 0;
    if (toList) {
        for (Employee *employee in toList) {
            if (i == ([toList count] - 1)) {
                receiveList = [receiveList stringByAppendingFormat:@"%@", employee._id];
            } else {
                receiveList = [receiveList stringByAppendingFormat:@"%@,", employee._id];
            }
            i ++;
        }
    }
    
    NSArray *ccList = [Employee getTmpContactByCC:@"0"];
    NSString *ccValue = @"";
    i = 0;
    if (ccList) {
        for (Employee *employee in ccList) {
            if (i == ([ccList count] - 1)) {
                ccValue = [ccValue stringByAppendingFormat:@"%@", employee._id];
            } else {
                ccValue = [ccValue stringByAppendingFormat:@"%@,", employee._id];
            }
            i ++;
        }
    }
    
    if ([subTitle.text isEqualToString:@""] || subTitle.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存草稿之前请输入邮件标题。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    mail = [[Mail alloc] init];
    mail.ID = @"";
    mail.title = subTitle.text;
    mail.context = contextTextView.text;
    mail.date = [NSUtil parserDateToString:[NSDate date]];
    mail.sender = [usernamepasswordKVPairs objectForKey:KEY_USERID];
    mail.senderName = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
    mail.reciver = receiveList;
    mail.ccList = ccValue;
    mail.reciverName = @"";
    mail.fileId = @"";
    mail.fileName = @"";
    mail.readed = @"0";
    mail.importId = @"0";
    mail.importName = @"";
    mail.deptment = @"";
    // 存储草稿 0
    mail.status = @"0";
    NSString *retStr = [Mail serviceSaveTmpEmail:mail];
    if (retStr) {
        [self performSelectorOnMainThread:@selector(alertTmp) withObject:nil waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(alertFailure) withObject:nil waitUntilDone:NO];
    }

}

- (void) alertTmp {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已储存为草稿" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)showContactsPicker:(id)sender {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    SwitchViewController *switchViewController = [storyborad instantiateViewControllerWithIdentifier:@"SwitchViewController"];
    switchViewController.delegateEmail = self;
    switchViewController.buttonId = sender;
    UINavigationController *tmpNavController = [[UINavigationController alloc] initWithRootViewController:switchViewController];
    [self.navigationController presentModalViewController:tmpNavController animated:YES];
}

- (UIBarButtonItem *) setupLeftBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Since the buttons can be any width we use a thin image with a stretchable center point
    UIImage *buttonImage = [[UIImage imageNamed:@"cancel.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"cancel2.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(saveCancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    return buttonBar;
}

- (UIBarButtonItem *) setupRightBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Since the buttons can be any width we use a thin image with a stretchable center point
    UIImage *buttonImage = [[UIImage imageNamed:@"send_paper.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"send2.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(doSendShowHub) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    return buttonBar;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)keyboardWillShow:(NSNotification *)notification {
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
    [UIView beginAnimations:@"MoveIn" context:nil];
    [UIView setAnimationDuration:0.25];
    self.keyboardToolbar.frame = CGRectMake(0, self.view.frame.size.height - keyboardHeight - 40, 320, 40);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	keyboardHeight = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    self.keyboardToolbar.frame = CGRectMake(0, self.view.frame.size.height - 40, 320, 40);
    
    [UIView commitAnimations];
}

- (void)tokenFieldChangedEditing:(UITextField *)textField {
	// There's some kind of annoying bug where UITextFieldViewModeWhile/UnlessEditing doesn't do anything.
	[textField setRightViewMode:(textField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showRightController:YES];
}

- (void)saveCancel:(id) sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]  
                                  initWithTitle:nil  
                                  delegate:self  
                                  cancelButtonTitle:@"取消"  
                                  destructiveButtonTitle:@"退出发送"  
                                  otherButtonTitles:@"储存草稿",nil];  
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {  
        DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
        [menuController showRightController:YES];
    } else if (buttonIndex == 1) {  
        NSLog(@"储存草稿");
        [self.view endEditing:YES];
        [self doSaveTmpShowHub];
    } 
}

#pragma mark JSTokenFieldDelegate

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
	//NSLog(@"Added token");
    
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{	
	//NSLog(@"Deleted token");
}

- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField {
    NSMutableString *recipient = [NSMutableString string];
	
	NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
	[charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
	
    NSString *rawStr = [[tokenField textField] text];
	for (int i = 0; i < [rawStr length]; i++)
	{
		if (![charSet characterIsMember:[rawStr characterAtIndex:i]])
		{
			[recipient appendFormat:@"%@",[NSString stringWithFormat:@"%c", [rawStr characterAtIndex:i]]];
		}
	}
    
    if ([rawStr length])
	{
		[tokenField addTokenWithTitle:rawStr representedObject:recipient];
	}
    return NO;
}

- (void)handleTokenFieldFrameDidChange:(NSNotification *)note
{
	if ([[note object] isEqual:toField])
	{
		[UIView animateWithDuration:0.0
						 animations:^{
                             [ccField setFrame:CGRectMake(0, [toField frame].size.height + [toField frame].origin.y + 1, [ccField frame].size.width, [ccField frame].size.height)];
                             [titleView setFrame:CGRectMake(0, [ccField frame].size.height + [ccField frame].origin.y + 1, [titleView frame].size.width, [titleView frame].size.height)];
                             [contextTextView setFrame:CGRectMake(0, [titleView frame].size.height + [titleView frame].origin.y + 1, [contextTextView frame].size.width, [contextTextView frame].size.height)];
						 }
						 completion:nil];
	} else {
        [UIView animateWithDuration:0.0
						 animations:^{
                             [titleView setFrame:CGRectMake(0, [ccField frame].size.height + [ccField frame].origin.y + 1, [titleView frame].size.width, [titleView frame].size.height)];
                             [contextTextView setFrame:CGRectMake(0, [titleView frame].size.height + [titleView frame].origin.y + 1, [contextTextView frame].size.width, [contextTextView frame].size.height)];
						 }
						 completion:nil];
    }
}

- (void) deleteContact:(NSString *) contactId theName:(NSString *) contactName withButton:(UIButton *)buttonId {
    if (buttonId == toButton) {
        [toField removeTokenWithRepresentedObject:contactId];
    }
    else {
        [ccField removeTokenWithRepresentedObject:contactId];
    }
}

- (void) showContact:(NSString *) contactId theName:(NSString *) contactName withButton:(UIButton *)buttonId {
    if (buttonId == toButton) {
        Employee *employee = [[Employee alloc] init];
        employee._id = contactId;
        employee._name = contactName;
        employee._forCC = @"0";
        [Employee insertTmpContact:employee];
        [toField addTokenWithTitle:contactName representedObject:contactId];
    }
    else {
        Employee *employee = [[Employee alloc] init];
        employee._id = contactId;
        employee._name = contactName;
        employee._forCC = @"1";
        [Employee insertTmpContact:employee];
        [ccField addTokenWithTitle:contactName representedObject:contactId];
    }
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end
