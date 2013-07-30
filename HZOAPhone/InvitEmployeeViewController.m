//
//  InvitEmployeeViewController.m
//  HZOAPhone
//
//  Created by Gong Lingxiao on 12-10-23.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "InvitEmployeeViewController.h"
#import "SwitchViewController.h"
#import "JSTokenButton.h"

@interface InvitEmployeeViewController ()

@end

@implementation InvitEmployeeViewController

@synthesize toField;
@synthesize listContactId;
@synthesize delegate;
@synthesize tokens;

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
    self.title = @"添加被邀请人";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Since the buttons can be any width we use a thin image with a stretchable center point
    UIImage *buttonImage = [[UIImage imageNamed:@"finish"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"finish2"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonBar;
    
    UIColor *color = [UIColor whiteColor];
    [[toField label] setTextColor:[UIColor darkGrayColor]];
    [[toField label] setText:@""];
    [[toField label] setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:18.0]];
    [[toField textField] setTag:2];
    [toField setBackgroundColor:color];
    [toField setDelegate:self];
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.tag = 2;
	[addButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
	[[toField textField] setRightView:addButton];
	[[toField textField] addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
	[[toField textField] addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [[toField textField] setRightViewMode:UITextFieldViewModeAlways];
    
    NSArray *empList = [Employee getTmpContactByCC:@"2"];
    
    toRecipients = [[NSMutableArray alloc] init];
    if ([empList count] > 0) {
        NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
        [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
        for (Employee *emp in empList) {
            [toField addTokenWithTitle:emp._name representedObject:emp._id];
        }
    } else {
        listContactId = [[NSMutableDictionary alloc] init];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)showContactsPicker:(id)sender {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"HZOAStoryboard" bundle:nil];
    SwitchViewController *switchViewController = [storyborad instantiateViewControllerWithIdentifier:@"SwitchViewController"];
    switchViewController.delegateInvitEmployee = self;
    switchViewController.buttonId = sender;
    UINavigationController *tmpNavController = [[UINavigationController alloc] initWithRootViewController:switchViewController];
    [self.navigationController presentModalViewController:tmpNavController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tokenFieldChangedEditing:(UITextField *)textField {
	// There's some kind of annoying bug where UITextFieldViewModeWhile/UnlessEditing doesn't do anything.
	//[textField setRightViewMode:(textField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}

- (void) showContact:(NSString *) contactId theName:(NSString *) contactName
{
    Employee *employee = [[Employee alloc] init];
    employee._id = contactId;
    employee._name = contactName;
    employee._forCC = @"2";
    [Employee insertTmpContact:employee];
    [toField addTokenWithTitle:contactName representedObject:contactId];
    //[toField addTokenWithTitle:contactName representedObject:contactId];
    [self.listContactId setObject:contactId forKey:[NSString stringWithFormat:@"%d", toField.tokens.count]];
}

#pragma mark JSTokenFieldDelegate

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
	NSDictionary *recipient = [NSDictionary dictionaryWithObject:obj forKey:title];
	[toRecipients addObject:recipient];
	//NSLog(@"Added token for < %@ : %@ >\n%@", title, obj, _toRecipients);
    
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{	
	[toRecipients removeObjectAtIndex:index];
    [self.listContactId removeObjectForKey:[NSString stringWithFormat:@"%d", index]];
	//NSLog(@"Deleted token %d\n%@", index, _toRecipients);
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

- (void) deleteContact:(NSString *) contactId theName:(NSString *) contactName {
    [toField removeTokenWithRepresentedObject:contactId];
}

- (void)backAction:(id) sender {
    int count = [self.listContactId count];
//    NSEnumerator *enumeratorValue = [self.listContactId objectEnumerator];
    NSString *receiveList = @"";
//    int i = 0;
//    for (NSString *contactId in enumeratorValue) {
//        if (i == (count - 1)) {
//            receiveList = [receiveList stringByAppendingFormat:@"%@", contactId];
//        } else {
//            receiveList = [receiveList stringByAppendingFormat:@"%@,", contactId];
//        }
//        i ++;
//    }
    
    int j = 0;
    for (JSTokenButton *button in toField.tokens) {
        NSString *value = button.titleLabel.text;
        receiveList = [receiveList stringByAppendingFormat:@"%@", value];
        if (j != [toField.tokens count] - 1) {
            receiveList = [receiveList stringByAppendingString:@","];
        }
        j ++;
    }
    
    [delegate invitEmployeeViewController:self didSelectContact:count withTokens:toField.tokens withInvations:receiveList withListContactId:listContactId];
}

@end
