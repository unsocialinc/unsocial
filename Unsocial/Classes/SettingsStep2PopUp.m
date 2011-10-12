//
//  PatientDetail2ViewController.m
//  CLINIC App
//
//  Created by santosh khare on 18/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsStep2PopUp.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "SignUp.h"

#define klabelFontSize  13
@implementation SettingsStep2PopUp
@synthesize txtPersonPublicProfile;


- (id)initWithFrame:(CGRect)frame {
	
	// we aren't editing any fields yet, it will be in edit when the user touches an edit field
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	//if (!txtPersonContact) txtPersonContact=[[UITextField alloc] init];
	
	//numberPadShowing = NO;
	
	if (self = [super initWithFrame:frame])
	{
		
		imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 285)];
		imgBack.image = [UIImage imageNamed:@"popupback.png"];
		[self addSubview:imgBack];
		imgBack.hidden = YES;
		
		UILabel *personPublicProfile = [UnsocialAppDelegate createLabelControl:@"Public Profile:" frame:CGRectMake(30, 0, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[self addSubview:personPublicProfile];
		
		txtPersonPublicProfile = [UnsocialAppDelegate createTextFieldControl:CGRectMake(personPublicProfile.frame.origin.x, personPublicProfile.frame.origin.y + 25, personPublicProfile.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"LinkedIn, Plaxo" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		[txtPersonPublicProfile setDelegate:self];
		txtPersonPublicProfile.backgroundColor = [UIColor clearColor];
		[self addSubview:txtPersonPublicProfile];
		txtPersonPublicProfile.autocapitalizationType = UITextAutocapitalizationTypeNone;
		txtPersonPublicProfile.autocorrectionType = UITextAutocorrectionTypeNo;
		txtPersonPublicProfile.keyboardType = UIKeyboardTypeEmailAddress;
		txtPersonPublicProfile.returnKeyType = UIReturnKeyDone;
		
		/*UILabel *personPublicProfile = [UnsocialAppDelegate createLabelControl:@"Public Profile:" frame:CGRectMake(personEmail.frame.origin.x, 68, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[self addSubview:personPublicProfile];
		
		txtPersonPublicProfile = [UnsocialAppDelegate createTextFieldControl:CGRectMake(personEmail.frame.origin.x, personContact.frame.origin.y + 25, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"LinkedIn, Plaxo" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		txtPersonPublicProfile.keyboardType = UIKeyboardTypeDefault;
		txtPersonEmail.autocorrectionType = UITextAutocorrectionTypeNo;
		txtPersonEmail.returnKeyType = UIReturnKeyDone;
		[txtPersonPublicProfile setDelegate:self];
		[self addSubview:txtPersonPublicProfile];
		txtPersonPublicProfile.backgroundColor = [UIColor clearColor];*/
	}
	return self;
}

- (void)viewWillDisappear:(BOOL)animated {
	if (numberPadShowing) {
		[doneButton removeFromSuperview];
	}	
	numberPadShowing = NO;
}

- (void)keyboardWillShow:(NSNotification *)note {  
	
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard;
	for (keyboard in tempWindow.subviews) {
 		if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
			if (numberPadShowing) {
				
				doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
				doneButton.tag = 123;
				doneButton.frame = CGRectMake(0, 163, 106, 53);
				if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"3"]) {
					[doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
					[doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
				} else {        
					[doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
					[doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
				}
				doneButton.hidden = YES;
				[keyboard addSubview:doneButton];
				[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
				return;					
				break;
			} else {
				for (UIView *v in [keyboard subviews]){
					if ([v tag]==123)
						[v removeFromSuperview];
				}
			}
	}
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

/*- (void)doneButton:(id)sender {
	[txtPersonContact resignFirstResponder];
	[UnsocialAppDelegate playClick];
}*/

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	
	//if(textField == txtPersonContact)
		//numberPadShowing = (textField.keyboardType == UIKeyboardTypeNumberPad);
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{	
	imgBack.hidden = NO;
	[self setViewMovedUp:YES:75];
	//if(textField == txtPersonContact)
		//doneButton.hidden = NO;
	//else
		//doneButton.hidden = YES;
	[textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	[self setViewMovedUp:NO:75]; // 132
	//doneButton.hidden = YES;
	imgBack.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
    [textField resignFirstResponder];
	[UnsocialAppDelegate playClick];
    return YES;
}

- (void) setViewMovedUp:(BOOL)movedUp:(NSInteger) setOrigin
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.frame;
    if (movedUp)
	{
        // If moving up, not only decrease the origin but increase the height so the view 
        // covers the entire screen behind the keyboard.
		rect.origin.y -= setOrigin;
		rect.size.height += 10;
	}
	else
	{
		// If moving down, not only increase the origin but decrease the height.
		rect.origin.y += setOrigin;
		rect.size.height -= 10;
	}
    self.frame = rect;    
    [UIView commitAnimations];
}


- (void)dealloc {
    [super dealloc];
}
@end
