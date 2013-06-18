//
//  ForwardEmailViewController.m
//  HZOAPhone
//
//  Created by Li Feng on 12-11-22.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "ForwardEmailViewController.h"
#import "SwitchViewController.h"

@interface ForwardEmailViewController ()

@end

@implementation ForwardEmailViewController
@synthesize mail;
@synthesize contextTextView;
@synthesize toField;
@synthesize ccField;
@synthesize titleView;
@synthesize lblEmailType;
@synthesize subTitle;
@synthesize toButton;
@synthesize ccButton;
@synthesize listCCContactId;
@synthesize listContactId;
@synthesize scrollView;



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
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleTokenFieldFrameDidChange:)
												 name:JSTokenFieldFrameDidChangeNotification
											   object:nil];
    
    self.title = [@"Fw:" stringByAppendingString:mail.title];
    [self initForward];
    usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    self.listContactId = [NSMutableDictionary dictionary];
    self.listCCContactId = [NSMutableDictionary dictionary];
    if (mail) {
        subTitle.text = [@"Fw:" stringByAppendingString: mail.title];
        contextTextView.text = [NSString stringWithFormat:@"\n\n在 %@, %@ 转发邮件: \n %@", mail.date, mail.senderName, mail.context];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)initForward{
    UIColor *color = [UIColor whiteColor];
    [[toField label] setTextColor:[UIColor darkGrayColor]];
    [[toField label] setText:@"收件人:"];
    [[toField label] setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:18.0]];
    [[toField textField] setTag:0];
    [toField setBackgroundColor:color];
    [toField setDelegate:self];
    
    toButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
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
	[ccButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
	[[ccField textField] setRightView:ccButton];
	[[ccField textField] addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
	[[ccField textField] addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [lblEmailType setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:18.0]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [[UIImage imageNamed:@"cancel.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"cancel2.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(cancelTaped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonBar;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonImage = [[UIImage imageNamed:@"send_paper.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    buttonPressedImage = [[UIImage imageNamed:@"send2.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(doSendShowHub:) forControlEvents:UIControlEventTouchUpInside];
    buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonBar;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cancelTaped:(id) sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"退出转发"
                                  otherButtonTitles:@"储存草稿",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    //[self dismissModalViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self dismissModalViewControllerAnimated:YES];
    } else if (buttonIndex == 1) {
        NSLog(@"储存草稿");
        [self doSaveTmp];
    }
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

- (void)showContactsPicker:(id)sender {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    SwitchViewController *switchViewController = [storyborad instantiateViewControllerWithIdentifier:@"SwitchViewController"];
    switchViewController.delegateForward = self;
    switchViewController.buttonId = sender;
    UINavigationController *tmpNavController = [[UINavigationController alloc] initWithRootViewController:switchViewController];
    [self.navigationController presentModalViewController:tmpNavController animated:YES];
}


- (void)tokenFieldChangedEditing:(UITextField *)textField {
	// There's some kind of annoying bug where UITextFieldViewModeWhile/UnlessEditing doesn't do anything.
	[textField setRightViewMode:(textField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}


#pragma mark JSTokenFieldDelegate

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
	NSLog(@"Added token");
    
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
	NSLog(@"Deleted token");
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


- (BOOL) checkEmailField {
    BOOL flag = YES;
    int count = [self.listContactId count];
    NSString *subTitleValue = [subTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *messageViewValue = [contextTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([subTitleValue isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入公告标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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


- (void)doSend {
    if ([self checkEmailField]) {
        int count = [self.listContactId count];
        NSLog(@"数量: %d", count);
        // go webservice here
        NSEnumerator *enumeratorValue = [self.listContactId objectEnumerator];
        NSString *receiveList = @"";
        int i = 0;
        for (NSString *contactId in enumeratorValue) {
            if (i == (count - 1)) {
                receiveList = [receiveList stringByAppendingFormat:@"%@", contactId];
            } else {
                receiveList = [receiveList stringByAppendingFormat:@"%@,", contactId];
            }
            i ++;
        }
        
        int countCC = [self.listCCContactId count];
        NSLog(@"数量: %d", countCC);
        // go webservice here
        enumeratorValue = [self.listCCContactId objectEnumerator];
        NSString *CCList = @"";
        i = 0;
        for (NSString *contactId in enumeratorValue) {
            if (i == (countCC - 1)) {
                CCList = [CCList stringByAppendingFormat:@"%@", contactId];
            } else {
                CCList = [CCList stringByAppendingFormat:@"%@,", contactId];
            }
            i ++;
        }
        
        mail = [[Mail alloc] init];
        mail.ID = @"";
        mail.title = subTitle.text;
        mail.context = contextTextView.text;
        mail.date = [NSUtil parserDateToString:[NSDate date]];
        mail.sender = [usernamepasswordKVPairs objectForKey:KEY_USERID];
        mail.senderName = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
        mail.reciver = receiveList;
        mail.ccList = CCList;
        mail.reciverName = @"";
        mail.fileId = @"";
        mail.fileName = @"";
        mail.readed = @"0";
        mail.importId = @"0";
        mail.importName = @"";
        mail.deptment = @"";
        // 已发送 2
        mail.status = @"1";
        [Mail serviceAddEmail:mail];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        //[self doCancel];
    }
}

- (void)doSaveTmp {
    int count = [self.listContactId count];
    NSLog(@"数量: %d", count);
    // go webservice here
    NSEnumerator *enumeratorValue = [self.listContactId objectEnumerator];
    NSString *receiveList = @"";
    int i = 0;
    for (NSString *contactId in enumeratorValue) {
        if (i == (count - 1)) {
            receiveList = [receiveList stringByAppendingFormat:@"%@", contactId];
        } else {
            receiveList = [receiveList stringByAppendingFormat:@"%@,", contactId];
        }
        i ++;
    }
    
    int countCC = [self.listCCContactId count];
    
    if ([subTitle.text isEqualToString:@""] || subTitle.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存草稿之前请输入邮件标题。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSLog(@"数量: %d", countCC);
    // go webservice here
    enumeratorValue = [self.listCCContactId objectEnumerator];
    NSString *CCList = @"";
    i = 0;
    for (NSString *contactId in enumeratorValue) {
        if (i == (countCC - 1)) {
            CCList = [CCList stringByAppendingFormat:@"%@", contactId];
        } else {
            CCList = [CCList stringByAppendingFormat:@"%@,", contactId];
        }
        i ++;
    }
    
    mail = [[Mail alloc] init];
    mail.ID = @"";
    mail.title = subTitle.text;
    mail.context = contextTextView.text;
    mail.date = [NSUtil parserDateToString:[NSDate date]];
    mail.sender = [usernamepasswordKVPairs objectForKey:KEY_USERID];
    mail.senderName = [usernamepasswordKVPairs objectForKey:KEY_USERNAME];
    mail.reciver = receiveList;
    mail.ccList = CCList;
    mail.reciverName = @"";
    mail.fileId = @"";
    mail.fileName = @"";
    mail.readed = @"0";
    mail.importId = @"0";
    mail.importName = @"";
    mail.deptment = @"";
    // 已发送 1
    mail.status = @"0";
    [Mail serviceAddEmail:mail];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已储存为草稿" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)doSendShowHub:(id) sender {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"发送中..."];
    [HUD showWhileExecuting:@selector(doSend) onTarget:self withObject:nil animated:YES];
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

- (void) showContact:(NSString *) contactId theName:(NSString *) contactName withButton:(UIButton *)buttonId {
    if (buttonId == toButton) {
        [toField addTokenWithTitle:contactName representedObject:contactId];
        [self.listContactId setObject:contactId forKey:[NSString stringWithFormat:@"%d", toField.tokens.count]];
    }
    else {
        [ccField addTokenWithTitle:contactName representedObject:contactId];
        [self.listCCContactId setObject:contactId forKey:[NSString stringWithFormat:@"%d", ccField.tokens.count]];
    }
}


@end
