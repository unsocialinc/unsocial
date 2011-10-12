//
//  PatientDetail2ViewController.m
//  CLINIC App
//
//  Created by santosh khare on 18/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsPopUp.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "SignUp.h"

@implementation SettingsPopUp
@synthesize txtPersonEmail, txtPersonContact;


- (id)initWithFrame:(CGRect)frame {
    
	// add observer for the respective notifications (depending on the os version)
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardDidShow:) 
													 name:UIKeyboardDidShowNotification 
												   object:nil];		
	} else {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillShow:) 
													 name:UIKeyboardWillShowNotification 
												   object:nil];
	}
	
	if (self = [super initWithFrame:frame])
	{
		
		imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 285)];
		imgBack.image = [UIImage imageNamed:@"popupback.png"];
		[self addSubview:imgBack];
		imgBack.hidden = YES;
		
		UILabel *personEmail = [UnsocialAppDelegate createLabelControl:@"E-Mail*:" frame:CGRectMake(30, 2, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[self addSubview:personEmail];
		
		txtPersonEmail = [UnsocialAppDelegate createTextFieldControl:CGRectMake(personEmail.frame.origin.x, personEmail.frame.origin.y + 25, personEmail.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter email" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		[txtPersonEmail setDelegate:self];
		txtPersonEmail.backgroundColor = [UIColor clearColor];
		[self addSubview:txtPersonEmail];
		txtPersonEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
		txtPersonEmail.autocorrectionType = UITextAutocorrectionTypeNo;
		txtPersonEmail.keyboardType = UIKeyboardTypeEmailAddress;
		txtPersonEmail.returnKeyType = UIReturnKeyDone;
		
		UILabel *personContact = [UnsocialAppDelegate createLabelControl:@"Phone #:" frame:CGRectMake(personEmail.frame.origin.x, 68, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[self addSubview:personContact];
		
		txtPersonContact = [UnsocialAppDelegate createTextFieldControl:CGRectMake(personEmail.frame.origin.x, personContact.frame.origin.y + 25, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter phone number" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeNumberPad returnKey:UIReturnKeyDone];
		[txtPersonContact setDelegate:self];
		[self addSubview:txtPersonContact];
		txtPersonContact.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)addButtonToKeyboard {
	
	// create custom button
	doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(0, 163, 106, 53);
	doneButton.adjustsImageWhenHighlighted = NO;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) {
		[doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
	} else {        
		[doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
	}
	[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
	// locate keyboard view
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView* keyboard;
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard found, add the button
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
				[keyboard addSubview:doneButton];
		} else {
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
				[keyboard addSubview:doneButton];
		}
	}
}

- (void)keyboardWillShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2) {
		[self addButtonToKeyboard];
	}
}

- (void)keyboardDidShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		[self addButtonToKeyboard];
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)doneButton:(id)sender {
	[txtPersonContact resignFirstResponder];
	[UnsocialAppDelegate playClick];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	
	if(doneButton != nil) {
	if(textField == txtPersonContact)
		doneButton.hidden = YES;
	}
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{	
	if (doneButton)
		doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	imgBack.hidden = NO;
	[self setViewMovedUp:YES:132];
	
	if(doneButton) {
	if(textField == txtPersonContact)
		doneButton.hidden = NO;
	else
		doneButton.hidden = YES;
	}
	[textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	[self setViewMovedUp:NO:132];
	if(doneButton) {
	doneButton.hidden = YES;
	}
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
