//
//  NewNoticeViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-22.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "NewNoticeViewController.h"
#import "SwitchViewController.h"

@interface NewNoticeViewController ()

@end

@implementation NewNoticeViewController

@synthesize toField;
@synthesize keyboardToolbar;
@synthesize scrollView;
@synthesize lblNoticeType;
@synthesize lblNoticeTitle;
@synthesize typeView;
@synthesize titleView;
@synthesize contextTextView;
@synthesize listContactId;
@synthesize values;
@synthesize didSelectSystemConfig;
@synthesize subTitle;

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
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleTokenFieldFrameDidChange:)
												 name:JSTokenFieldFrameDidChangeNotification
											   object:nil];
    self.title = @"发送公告";
    [self setupUI];
    self.listContactId = [NSMutableDictionary dictionary];
}

- (void) setupUI {    
//    UIColor *color = [UIColor whiteColor];
//    [[toField label] setTextColor:[UIColor darkGrayColor]];
//    [[toField label] setText:@"收件人:"];
//    [[toField label] setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:18.0]];
//    [[toField textField] setTag:0];
//    [toField setBackgroundColor:color];
//    [toField setDelegate:self];
//    
//    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//	[addButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
//	[[toField textField] setRightView:addButton];
//	[[toField textField] addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
//	[[toField textField] addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [lblNoticeTitle setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:18.0]];
    
    [lblNoticeType setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:18.0]];
    
    typePickerView = [[CPPickerView alloc] initWithFrame:CGRectMake(80, 5, 150, 30)];
    typePickerView.backgroundColor = [UIColor whiteColor];
    typePickerView.dataSource = self;
    typePickerView.delegate = self;
    [typePickerView setSelectedItem:0];
    [typePickerView reloadData];
    [self.typeView addSubview:typePickerView];
    
    self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 84, 320, 40)];
    keyboardToolbar.tag = 10;
    keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *cancelButton = [self setupLeftBar];
    UIBarButtonItem *doneButton = [self setupRightBar];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:cancelButton, spacer, doneButton, nil]];
    [self.view addSubview:keyboardToolbar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    [button addTarget:self action:@selector(sendNoticeShowHub:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)showContactsPicker:(id)sender {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    SwitchViewController *switchViewController = [storyborad instantiateViewControllerWithIdentifier:@"SwitchViewController"];
    switchViewController.delegateNotice = self;
    UINavigationController *tmpNavController = [[UINavigationController alloc] initWithRootViewController:switchViewController];
    [self.navigationController presentModalViewController:tmpNavController animated:YES];

}

- (void)sendNoticeShowHub:(id) sender {
    [self.view endEditing:YES];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"提交数据..."];
    [HUD showWhileExecuting:@selector(sendNotice) onTarget:self withObject:nil animated:YES];
    
    //[self sendNotice];
}

- (void)sendNotice {
    if ([self checkNoticeField]) {
        int count = [self.listContactId count];
        NSLog(@"数量: %d", count);
        //get userKeychain
        NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
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
        
        Notice *notice = [[Notice alloc] init];
        notice.ID = @"";
        notice.title = subTitle.text;
        notice.context = contextTextView.text;
        notice.date = [NSUtil parserDateToString:[NSDate date]];
        notice.sender = [usernamepasswordKVPairs objectForKey:KEY_USERID];
        notice.readed = @"";
        if (didSelectSystemConfig == nil) {
            SystemConfig *systemConfig = [values objectAtIndex:0];
            notice.typeId = systemConfig.typeId;
        } else {
            notice.typeId = didSelectSystemConfig.typeId;
        }
        notice.typeName = @"";
        notice.deptment = @"";
        notice.status = @"2";
        NSString *retStr = [Notice serviceAddNotice:notice];
        if (retStr) {
            [self performSelectorOnMainThread:@selector(alertAdd) withObject:nil waitUntilDone:NO];
        } else {
            [self performSelectorOnMainThread:@selector(alertFailure) withObject:nil waitUntilDone:NO];
        }
    
    }
}

- (void) alertAdd {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) alertFailure {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL) checkNoticeField {
    BOOL flag = YES;
    //int count = [self.listContactId count];
    NSString *subTitleValue = [subTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *messageViewValue = [contextTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([subTitleValue isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入公告标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];       
        flag = NO;
    } else if ([messageViewValue isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入公告内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        flag = NO;
    } 
    return flag;
}

- (void)saveCancel:(id) sender {
    DDMenuController *menuController = (DDMenuController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showRightController:YES];
}

#pragma mark - CPPickerViewDataSource

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView
{
    return [values count];
}

- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item
{
    SystemConfig *systemConfig = [values objectAtIndex:item];
    return systemConfig.name;
}

#pragma mark - CPPickerViewDelegate

- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item
{
    didSelectSystemConfig = [values objectAtIndex:item];
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

- (void)handleTokenFieldFrameDidChange:(NSNotification *)note
{
	if ([[note object] isEqual:toField])
	{
		[UIView animateWithDuration:0.0
						 animations:^{
                             [typeView setFrame:CGRectMake(0, [toField frame].size.height + [toField frame].origin.y + 1, [typeView frame].size.width, [typeView frame].size.height)];
                             [titleView setFrame:CGRectMake(0, [typeView frame].size.height + [typeView frame].origin.y + 1, [titleView frame].size.width, [titleView frame].size.height)];
                             [contextTextView setFrame:CGRectMake(0, [titleView frame].size.height + [titleView frame].origin.y + 1, [contextTextView frame].size.width, [contextTextView frame].size.height)];
						 }
						 completion:nil];
	} 
}

- (void) showContactNotice:(NSString *) contactId theName:(NSString *) contactName {
    [toField addTokenWithTitle:contactName representedObject:contactId];
    [self.listContactId setObject:contactId forKey:[NSString stringWithFormat:@"%d", toField.tokens.count]];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end
