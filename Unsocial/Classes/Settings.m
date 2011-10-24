//
//  Settings.m
//  Unsocial
//
//  Created by vaibhavsaran on 07/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "UIDeviceHardware.h"
#import "Person.h"
#import "SettingsSelectPrefix.h"
#import "LauncherViewTestController.h"

BOOL edited = NO;
#define klabelFontSize  13
@implementation Settings
@synthesize username, userid, userprefix, useremail, usercontact, imgPicker, comingfrom, aray1, userlinkedinmailid;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	[activityView stopAnimating];
	activityView.hidden = YES;
	[self createControls];
}

- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	//add background color
	self.view.backgroundColor = color;
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(btnLeft_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	
	if(comingfrom == 0) {
		self.navigationItem.leftBarButtonItem = leftcbtnitme;
	}
	else {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(btnLeft_OnClick)] autorelease];
	}
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"signupback.png"];
	[self.view addSubview:imgBack];
	
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object i.e. without auto release
	//imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 40, 300, 2) imageName:@"dashboardhorizontal.png"];
	imgHorSep = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(10, 40, 300, 2) imageName:@"dashboardhorizontal.png"];
	// end 3 august 2011	
	[self.view addSubview:imgHorSep];
	[imgHorSep release];
	
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object i.e. without auto release
	//imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 133, 260, 2) imageName:@"dashboardhorizontal.png"];
	imgHorSep = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(30, 133, 260, 2) imageName:@"dashboardhorizontal.png"];
	// end 3 august 2011
	[self.view addSubview:imgHorSep];
	[imgHorSep release];
	
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object i.e. without auto release
	//imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 200, 260, 2) imageName:@"dashboardhorizontal.png"];
	imgHorSep = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(30, 200, 260, 2) imageName:@"dashboardhorizontal.png"];
	// end 3 august 2011
	[self.view addSubview:imgHorSep];
	[imgHorSep release];
	
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object i.e. without auto release
	//imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 266, 260, 2) imageName:@"dashboardhorizontal.png"];
	imgHorSep = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(30, 266, 260, 2) imageName:@"dashboardhorizontal.png"];
	// end 3 august 2011
	[self.view addSubview:imgHorSep];
	[imgHorSep release];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//heading = [UnsocialAppDelegate createLabelControl:@"General Information" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	heading = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"General Information" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011

	[self.view addSubview:heading];
	
	// 13 may 2011 by pradeep //[heading release];
	
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object i.e. without auto release
	//loadingBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(20, 150, 280, 90) imageName:@"loadingback.png"];
	loadingBack = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(20, 150, 280, 90) imageName:@"loadingback.png"];
	// end 3 august 2011
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"saving\nplease standby" frame:CGRectMake(20, 140, 280, 90) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];*/
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {
	
	imageGrabed = [[UIImageView alloc] initWithFrame:CGRectMake(137, 207 + yAxisForSettingControls, 156, 116)];
	if ([capturedImage count] > 0)
		imageGrabed.image = [capturedImage objectAtIndex:0];
	else {
			//imageGrabed.image = [UIImage imageNamed:@"imgNoUserImage.png"];
			imageGrabed = [self getImageFromFile];
	}
	
	UIImageView *tempImage = [[UIImageView alloc]init];
	tempImage.image = imageGrabed.image;
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//lblProfilePic = [UnsocialAppDelegate createLabelControl:@"Profile Picture:" frame:CGRectMake(30, 50, 110, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	lblProfilePic = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Profile Picture:" frame:CGRectMake(30, 50, 110, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:lblProfilePic];
	// 13 may 2011 by pradeep //[lblProfilePic release];
	
	imageGrabed = [[UIImageView alloc] initWithFrame:CGRectMake(135, 50, 75, 75)];
	imageGrabed.image = tempImage.image;
	
	roundedView = imageGrabed;
    // Get the Layer of any view
	CALayer * l = [roundedView layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:10.0];
	
    // You can even add a border
	[l setBorderWidth:1.0];
	[l setBorderColor:[[UIColor blackColor] CGColor]];
	[self.view addSubview:roundedView];

	btnAddPhoto = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnGrab_Click:) frame:imageGrabed.frame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnAddPhoto];
	[btnAddPhoto release];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//namePrefix = [UnsocialAppDelegate createLabelControl:@"Prefix*:" frame:CGRectMake(30, 135, 130, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	namePrefix = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Prefix*:" frame:CGRectMake(30, 135, 130, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:namePrefix];
	
	txtPrefix = [UnsocialAppDelegate createTextFieldControl:CGRectMake(namePrefix.frame.origin.x, 160, 50, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"Mr/Mrs/Miss" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
	[txtPrefix setDelegate:self];
	txtPrefix.backgroundColor = [UIColor clearColor];
	[self.view addSubview:txtPrefix];
	
	btnSelPrefix = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnSelPrefix_Click) frame:txtPrefix.frame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSelPrefix];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//personName = [UnsocialAppDelegate createLabelControl:@"Name*:" frame:CGRectMake(95, namePrefix.frame.origin.y, 198, namePrefix.frame.size.height) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	personName = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Name*:" frame:CGRectMake(95, namePrefix.frame.origin.y, 198, namePrefix.frame.size.height) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:personName];
	
	txtPersonName = [UnsocialAppDelegate createTextFieldControl:CGRectMake(personName.frame.origin.x, txtPrefix.frame.origin.y, personName.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter your name" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
	[txtPersonName setDelegate:self];
	txtPersonName.backgroundColor = [UIColor clearColor];
	[self.view addSubview:txtPersonName];
	
	NSString *stremail = @"E-Mail*:";
	[self getPrefixFromFile];
	if([userprefix isEqualToString:@"none"])
		stremail = @"E-Mail:";
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//personEmail = [UnsocialAppDelegate createLabelControl:stremail frame:CGRectMake(namePrefix.origin.x, txtPrefix.frame.origin.y + 43, 263, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	personEmail = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:stremail frame:CGRectMake(namePrefix.origin.x, txtPrefix.frame.origin.y + 43, 263, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:personEmail];
	
	txtPersonEmail = [UnsocialAppDelegate createTextFieldControl:CGRectMake(personEmail.frame.origin.x, personEmail.frame.origin.y + 25, personEmail.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter email" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
	[txtPersonEmail setDelegate:self];
	txtPersonEmail.backgroundColor = [UIColor clearColor];
	txtPersonEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
	txtPersonEmail.autocorrectionType = UITextAutocorrectionTypeNo;
	txtPersonEmail.keyboardType = UIKeyboardTypeEmailAddress;
	txtPersonEmail.returnKeyType = UIReturnKeyDone;
	[txtPersonEmail setHidden:NO];
	[self.view addSubview:txtPersonEmail];
	
	txtPersonLinkedInEmail = [UnsocialAppDelegate createTextFieldControl:CGRectMake(personEmail.frame.origin.x, personEmail.frame.origin.y + 25, personEmail.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter secondary email" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
	[txtPersonLinkedInEmail setDelegate:self];
	txtPersonLinkedInEmail.backgroundColor = [UIColor clearColor];
	txtPersonLinkedInEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
	txtPersonLinkedInEmail.autocorrectionType = UITextAutocorrectionTypeNo;
	txtPersonLinkedInEmail.keyboardType = UIKeyboardTypeEmailAddress;
	txtPersonLinkedInEmail.returnKeyType = UIReturnKeyDone;
	[txtPersonLinkedInEmail setHidden:YES];
	[self.view addSubview:txtPersonLinkedInEmail];
	
	NSString *strephone = @"Phone #*:";
	[self getPrefixFromFile];
	if([userprefix isEqualToString:@"none"])
		strephone = @"Phone #:";
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//personContact = [UnsocialAppDelegate createLabelControl:strephone frame:CGRectMake(personEmail.frame.origin.x, personEmail.frame.origin.y + 65, personEmail.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	personContact = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:strephone frame:CGRectMake(personEmail.frame.origin.x, personEmail.frame.origin.y + 65, personEmail.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:personContact];
	
	txtPersonContact = [UnsocialAppDelegate createTextFieldControl:CGRectMake(personEmail.frame.origin.x, personContact.frame.origin.y + 25, personEmail.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter phone number" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeNumberPad returnKey:UIReturnKeyDone];
	[txtPersonContact setDelegate:self];
	[self.view addSubview:txtPersonContact];
	txtPersonContact.backgroundColor = [UIColor clearColor];
	
	if([allInfo count] == 0) {
		
		BOOL isrecexist = [self getDataFromFile];
		if(isrecexist) {
			
			txtPrefix.text = self.userprefix;
			txtPersonName.text = self.username;
			txtPersonEmail.text = self.useremail;
			txtPersonLinkedInEmail.text = self.userlinkedinmailid;
			txtPersonContact.text = self.usercontact;
		}
	}
	
	if([allInfo count] > 0) {
		
		txtPrefix.text = [allInfo objectAtIndex:0];
		txtPersonName.text = [allInfo objectAtIndex:1];
		txtPersonEmail.text = [allInfo objectAtIndex:2];
		txtPersonContact.text = [allInfo objectAtIndex:3];
		txtPersonLinkedInEmail.text = [allInfo objectAtIndex:4];
	}
	
	/*btnSave = [UnsocialAppDelegate createButtonControl:@"Save" target:self selector:@selector(saveAndSendData) frame:CGRectMake(128, 380, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSave];*/
	
	[self getPrefixFromFile];
	if(userprefix) {
		
		if([userprefix compare:@"none"] == NSOrderedSame) {
			
			[namePrefix setHidden:YES];
			[txtPrefix setHidden:YES];
			[txtPersonEmail setHidden:YES];
			[txtPersonLinkedInEmail setHidden:NO];
			
			personName.frame = CGRectMake(30, 135, 50, 30);
			txtPersonName.frame = CGRectMake(30, 160, personEmail.frame.size.width, 30);

			/*[txtPersonEmail setHidden:YES];
			 
			 [personEmail setHidden:YES];
			 personContact.frame = CGRectMake(namePrefix.origin.x, txtPrefix.frame.origin.y + 43, 263, 20);
			 txtPersonContact.frame = CGRectMake(personEmail.frame.origin.x, personEmail.frame.origin.y + 25, personEmail.frame.size.width, 30);
			 }
			 else {
			 
			 imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 335, 260, 2) imageName:@"dashboardhorizontal.png"];
			 [self.view addSubview:imgHorSep];
			 [imgHorSep release];*/
		}
		/*else {
			[txtPersonEmail setHidden:YES];
			[txtPersonLinkedInEmail setHidden:NO];
		}*/
	}
	if(!aray1)
		[self checkForLeftNavClick];
	
		//[btnSave release];
	[imageGrabed release];
	[tempImage release];
	// 13 may 2011 by pradeep //[namePrefix release];
	[txtPrefix release];
	[btnSelPrefix release];
	// 13 may 2011 by pradeep //[personName release];
	[txtPersonName release];
}

- (void) viewMovedUp:(NSInteger) yAxis {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];

	imgHorSep.frame = CGRectMake(imgHorSep.frame.origin.x, (imgHorSep.frame.origin.y + yAxis), imgHorSep.frame.size.width, imgHorSep.frame.size.height);
	
	imgBack.frame = CGRectMake(imgBack.frame.origin.x, (imgBack.frame.origin.y + yAxis), imgBack.frame.size.width, imgBack.frame.size.height);
	
	heading.frame = CGRectMake(heading.frame.origin.x, (heading.frame.origin.y + yAxis), heading.frame.size.width, heading.frame.size.height);
	
	lblProfilePic.frame = CGRectMake(lblProfilePic.frame.origin.x, (lblProfilePic.frame.origin.y + yAxis), lblProfilePic.frame.size.width, lblProfilePic.frame.size.height);
	imageGrabed.frame = CGRectMake(imageGrabed.frame.origin.x, (imageGrabed.frame.origin.y + yAxis), imageGrabed.frame.size.width, imageGrabed.frame.size.height);
	btnAddPhoto.frame = CGRectMake(btnAddPhoto.frame.origin.x, (btnAddPhoto.frame.origin.y + yAxis), btnAddPhoto.frame.size.width, btnAddPhoto.frame.size.height);
	
	personName.frame = CGRectMake(personName.frame.origin.x, (personName.frame.origin.y + yAxis), personName.frame.size.width, personName.frame.size.height);
	txtPersonName.frame = CGRectMake(txtPersonName.frame.origin.x, (txtPersonName.frame.origin.y + yAxis), txtPersonName.frame.size.width, txtPersonName.frame.size.height);
	
	txtPrefix.frame = CGRectMake(txtPrefix.frame.origin.x, (txtPrefix.frame.origin.y + yAxis), txtPrefix.frame.size.width, txtPrefix.frame.size.height);
	btnSelPrefix.frame = CGRectMake(btnSelPrefix.frame.origin.x, (btnSelPrefix.frame.origin.y + yAxis), btnSelPrefix.frame.size.width, btnSelPrefix.frame.size.height);
	namePrefix.frame = CGRectMake(namePrefix.frame.origin.x, (namePrefix.frame.origin.y + yAxis), namePrefix.frame.size.width, namePrefix.frame.size.height);
	
	personEmail.frame = CGRectMake(personEmail.frame.origin.x, (personEmail.frame.origin.y + yAxis), personEmail.frame.size.width, personEmail.frame.size.height);
	
	txtPersonEmail.frame = CGRectMake(txtPersonEmail.frame.origin.x, (txtPersonEmail.frame.origin.y + yAxis), txtPersonEmail.frame.size.width, txtPersonEmail.frame.size.height);
	
	txtPersonLinkedInEmail.frame = CGRectMake(txtPersonLinkedInEmail.frame.origin.x, (txtPersonLinkedInEmail.frame.origin.y + yAxis), txtPersonLinkedInEmail.frame.size.width, txtPersonLinkedInEmail.frame.size.height);
	
	personContact.frame = CGRectMake(personContact.frame.origin.x, (personContact.frame.origin.y + yAxis), personContact.frame.size.width, personContact.frame.size.height);
	txtPersonContact.frame = CGRectMake(txtPersonContact.frame.origin.x, (txtPersonContact.frame.origin.y + yAxis), txtPersonContact.frame.size.width, txtPersonContact.frame.size.height);
	
	[UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {	
	
		//[self getPrefixFromFile];
		//if([userprefix compare:@"none"] != NSOrderedSame) {
	
	if (textField == txtPersonEmail) {
		
		[self viewMovedUp:-69];
		self.navigationItem.rightBarButtonItem = nil;
	}
	else if (textField == txtPersonLinkedInEmail) {
		
		[self viewMovedUp:-69];
	}
	else if (textField == txtPersonContact) {
		
		[self viewMovedUp:-132];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightbtn_OnClick)] autorelease];
	}
		//}
	/*else {
	 
	 if (textField == txtPersonContact) {
	 
	 [self viewMovedUp:-69];
	 self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightbtn_OnClick)] autorelease];
	 }
	 }*/
}

- (void)textFieldDidEndEditing:(UITextField *)textField {	
	
		//[self getPrefixFromFile];
		//if([userprefix compare:@"none"] != NSOrderedSame) {
	
	if (textField == txtPersonEmail) {
		
		[self viewMovedUp:+69];
	}
	else if (textField == txtPersonLinkedInEmail) {
		
		[self viewMovedUp:+69];
	}
	else if (textField == txtPersonContact) {
		
		[self viewMovedUp:+132];
		self.navigationItem.rightBarButtonItem = nil;
	}
		//}
	/*else {
	 
	 if (textField == txtPersonContact) {
	 
	 [self viewMovedUp:+69];
	 self.navigationItem.rightBarButtonItem = nil;
	 }	
	 }*/
}

- (void)btnLeft_OnClick{
	
	[self resignAll];
	[self storeToMutableArray];
	NSString *_str1, *_str2, *_str3, *_str4, *_str5;
	
	_str1 = [txtPrefix.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	_str2 = [txtPersonName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	_str3 = [txtPersonEmail.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	_str4 = [txtPersonContact.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	_str5 = [txtPersonLinkedInEmail.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	
	NSString *_strA1, *_strA2, *_strA3, *_strA4, *_strA5;
	_strA1 = [self.aray1 objectAtIndex:1];
	_strA2 = [self.aray1 objectAtIndex:2];
	_strA3 = [self.aray1 objectAtIndex:3]; // email
	_strA4 = [self.aray1 objectAtIndex:4];
	_strA5 = [self.aray1 objectAtIndex:5]; // linkedin mail
	
	NSLog(@"New Email- %@, Old email- %@", _str5, _strA5);
		// to check if user is trying to remove his linkedin secondary mail id
	NSString *getprfix = [UnsocialAppDelegate getLinkedInPrefixFromFile];
		// user can not remove his secondary email once it is set STARTS
	if ([getprfix isEqualToString:@"none"])
	{
		if(![_strA5 isEqualToString:@""])
		{
			if([_str5 isEqualToString:@""])
			{
				
				if([[allInfo objectAtIndex:4] isEqualToString:@""])
				{					
					UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Once email is set you can only edit it, can not remove it." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[errorAlert show];
					[errorAlert release];
					whereClicked = 1;
					return;
				}
			}
		}
	}
		// user can not remove his secondary email once it is set ENDS
	
	if ([self.aray1 objectAtIndex:0] == imageGrabed && [_strA1 isEqualToString: _str1] && [_strA2 isEqualToString: _str2] && [_strA3 isEqualToString: _str3] && [_strA4 isEqualToString: _str4] && [_strA5 isEqualToString: _str5]) {
		
		printf("Matched\n");
		matchemail = 0;
		[allInfo removeAllObjects];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
		
		printf("Not Matched\n");
		// normal mail
		if (![_strA1 isEqualToString:@"none"]) {
			
			if (![_strA3 isEqualToString: _str3])
				matchemail = 1;// hence normal mail was updated
			else
				matchemail = 0;// hence normal mail was not updated
		}
		// linkedin secondary mail
		else {
			
			if (![_strA5 isEqualToString: _str5])
					
				matchemail = 1; // hence linkedin mail was updated
			else
				matchemail = 0; // hence linkedin mail was not updated			
		}
		[self saveAndSendData];
	}
}

- (void)rightbtn_OnClick {
	 self.navigationItem.rightBarButtonItem = nil;
	 [txtPersonContact resignFirstResponder];
 }

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	printf("Clearing Keyboard\n");
    return YES;
}

- (void) updateDataFileOnSave:(NSString *)uid {
	
	NSString *_checkmailid = [UnsocialAppDelegate getLinkedInMailFromFile];
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];	
	newPerson.userprefix = txtPrefix.text;
	newPerson.username = txtPersonName.text;
	newPerson.useremail = txtPersonEmail.text;
	newPerson.userlinkedinmailid = txtPersonLinkedInEmail.text;
	newPerson.usercontact = txtPersonContact.text;
	newPerson.userid = uid;
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	[theData writeToFile:path atomically:YES];
	[encoder release];
	
	if ((![newPerson.userlinkedinmailid isEqualToString:@""]) || (newPerson.userlinkedinmailid != nil)) {
		
		if(![_checkmailid isEqualToString:newPerson.userlinkedinmailid]) {
			
			flagforlinkedinmailset = 1;
		}
	}
	if ((![newPerson.useremail isEqualToString:@""]) || (newPerson.useremail != nil)) {
		
		if(![self.useremail isEqualToString:newPerson.useremail]) {
			
			flagforlinkedinmailset = 2;
		}
	}
}

// for saving an image inside document forder
- (void) updateDataFileOnSave4Img:(NSString *)uid {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"1.png"] retain];
	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([capturedImage objectAtIndex:0])];
	[imageData writeToFile:dataFilePath atomically:YES];
}

- (BOOL) getDataFromFile {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
			//open it and read it 
		NSLog(@"data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];
			//[self setPersonArray:tempArray];
		
		NSLog(@"%@", [[tempArray objectAtIndex:0] usersubind]);
		if ( [[[tempArray objectAtIndex:0] usersubind] compare:@""] == NSOrderedSame)
		{
			NSLog(@"subind blank");
		}
		userprefix = [[tempArray objectAtIndex:0] userprefix];
		self.username = [[tempArray objectAtIndex:0] username];
		self.userid = [[tempArray objectAtIndex:0] userid];
		self.useremail = [[tempArray objectAtIndex:0] useremail];
		self.usercontact = [[tempArray objectAtIndex:0] usercontact];
		self.userlinkedinmailid = [[tempArray objectAtIndex:0] userlinkedinmailid];
		
		[decoder finishDecoding];
		[decoder release];	
		
			//if ( [username compare:@""] == NSOrderedSame || !username)
		if ( [userid compare:@""] == NSOrderedSame || !userid)
		{
			return NO;
		}
		else {
			
			return YES;
		}		
	}
	else { 
		return NO;
	}
}

- (void) getPrefixFromFile {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
			//open it and read it 
		NSLog(@"data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];
			//[self setPersonArray:tempArray];
		
		NSLog(@"%@", [[tempArray objectAtIndex:0] usersubind]);
		if ( [[[tempArray objectAtIndex:0] usersubind] compare:@""] == NSOrderedSame)
		{
			NSLog(@"subind blank");
		}
		userprefix = [[tempArray objectAtIndex:0] userprefix];
		
		[decoder finishDecoding];
		[decoder release];	
	}
}

- (UIImageView *)getImageFromFile{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"1.png"] retain];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isimgfilefound = NO;
	
	if([fileManager fileExistsAtPath:dataFilePath]) 
	{
		capturedImage = [[NSMutableArray alloc] init];
		[capturedImage addObject:[UIImage imageWithContentsOfFile:dataFilePath ]];
		imageGrabed.image = [UIImage imageWithContentsOfFile:dataFilePath ];
		isimgfilefound = YES;		
	}
	else
	{
		imageGrabed.image = [UIImage imageNamed:@"imgNoUserImage.png"];
		isimgfilefound = NO;		
	}
	return imageGrabed;
}

- (void)saveAndSendData {

	[self storeToMutableArray];
	UIAlertView *errorAlert = [[UIAlertView alloc] init];
	
	if([[allInfo objectAtIndex:2] length] > 50) {
		
		errorAlert = [[UIAlertView alloc]initWithTitle:nil message:@"E-Mail can't be more than 50 characters." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		whereClicked = 1;
		return;
	}	
		//Email validation START
	if(![[allInfo objectAtIndex:2] isEqualToString:@""])
	{
		BOOL email1 = [UnsocialAppDelegate validateEmail:[allInfo objectAtIndex:2]];
		if (!email1) {
			
			errorAlert = [[UIAlertView alloc]initWithTitle:nil message:@"E-Mail is not in correct format." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			[errorAlert show];
			[errorAlert release];
			whereClicked = 1;
			return;
		}
	}
		//Email validation	END

	if([[allInfo objectAtIndex:4] length] > 50) {
		
		errorAlert = [[UIAlertView alloc]initWithTitle:nil message:@"E-Mail can't be more than 50 characters." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		whereClicked = 1;
		return;
	}
		//secondry Email validation START
	if(![[allInfo objectAtIndex:4] isEqualToString:@""])
	{
		BOOL email2 = [UnsocialAppDelegate validateEmail:[allInfo objectAtIndex:4]];
		if (!email2) {
			
			errorAlert = [[UIAlertView alloc]initWithTitle:nil message:@"E-Mail is not in correct format." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			[errorAlert show];
			[errorAlert release];
			whereClicked = 1;
			return;
		}
		//secondry Email validation END
	}
	
	if([[allInfo objectAtIndex:1] length] > 100) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Name can't be more than 100 characters." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		whereClicked = 1;
		return;
	}
	if([[allInfo objectAtIndex:3] length] > 20) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Phone number is too long to accept." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		whereClicked = 1;
		return;
	}

	[self getPrefixFromFile];
	if([userprefix isEqualToString:@"none"]) {
		
		if(([[allInfo objectAtIndex:0] isEqualToString:@""])  || ([[allInfo objectAtIndex:1] isEqualToString:@""]) || ([[allInfo objectAtIndex:2] isEqualToString:@""])) {
			
			errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill all necessary fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[errorAlert show];
			whereClicked = 1;
			return;
		}
	}
	else {
		if(([[allInfo objectAtIndex:0] isEqualToString:@""])  || ([[allInfo objectAtIndex:1] isEqualToString:@""]) || ([[allInfo objectAtIndex:2] isEqualToString:@""]) || ([[allInfo objectAtIndex:3] isEqualToString:@""])) {
			
			errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill all fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[errorAlert show];
			whereClicked = 1;
			return;
		}
	}
	[self.view addSubview:loadingBack];
	loadingBack.hidden = NO;
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 210, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	activityView.hidden = NO;
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//loading = [UnsocialAppDelegate createLabelControl:@"saving\nplease standby" frame:CGRectMake(20, 140, 280, 90) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	loading = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"saving\nplease standby" frame:CGRectMake(20, 140, 280, 90) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:loading];
	loading.hidden = NO;
		//btnSave.hidden = YES;
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
}

- (void)startProcess {
	
	BOOL isrecexist = [self getDataFromFile];
	BOOL isupdatesucceeded;
	if (!isrecexist)
	{
		isupdatesucceeded = [self send4GeneralInfo:@"addprofilestep1"];
	}
	else 
	{
		isupdatesucceeded = [self send4GeneralInfo:@"updateprofilestep1v14"];
	}
	if (isupdatesucceeded)
	{
		if ([arrayForUserID count]==0)
			[arrayForUserID addObject:userid];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
			//btnSave.hidden = NO;
		// added by pradeep on 18 august 2011 for fixing bug if wifi not working and trying to update info i.e. id on rth 	00255
		loading.hidden = YES;
		whereClicked = 3;
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:@"Profile information has not updated successfully. Your internet connection may be down." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		
		// end 18 august 2011
	}

}

- (void)checkForLeftNavClick {
	
	NSString *_str1, *_str2, *_str3, *_str4, *_str5;
	_str1 = [txtPrefix.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	_str2 = [txtPersonName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	_str3 = [txtPersonEmail.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	_str4 = [txtPersonContact.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	_str5 = [txtPersonLinkedInEmail.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	
	self.aray1 = [NSArray arrayWithObjects:imageGrabed, _str1, _str2, _str3, _str4, _str5, nil];
}

- (void)storeToMutableArray {
	
	allInfo = [[NSMutableArray alloc]init];
	
	NSString *_txtPrefix, *_txtPersonName, *_txtPersonEmail, *_txtPersonContact, *_txtPersonLinkedInEmail;
	
	_txtPrefix = [txtPrefix.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	_txtPersonName = [txtPersonName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	_txtPersonEmail = [txtPersonEmail.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	_txtPersonContact = [txtPersonContact.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	_txtPersonLinkedInEmail = [txtPersonLinkedInEmail.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

	
	if(_txtPrefix == nil)
		[allInfo addObject:@""];
	else [allInfo addObject:_txtPrefix];
	
	if(_txtPersonName == nil)
		[allInfo addObject:@""];
	else [allInfo addObject:_txtPersonName];
	
	if(_txtPersonEmail == nil)
		[allInfo addObject:@""];
	else [allInfo addObject:_txtPersonEmail];
	
	if(_txtPersonContact == nil)
		[allInfo addObject:@""];
	else [allInfo addObject:_txtPersonContact];
	
	if(_txtPersonLinkedInEmail == nil)
		[allInfo addObject:@""];
	else [allInfo addObject:_txtPersonLinkedInEmail];
}

- (void)btnGrab_Click:(id)sender {
	
	[self resignAll];
	[self dialogSelection];
}

- (void)dialogSelection {
	
	// open an alert with two custom buttons
	UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
	deviceString=[h platformString];
		//NSLog(@"%@", deviceString);
	
	// open an alert with two custom buttons
	if(!capturedImage)
		capturedImage = [[NSMutableArray alloc] init];
	
	// checking for device in which camera feature is enabled
	if ([deviceString isEqualToString:@"iPod Touch 1G"] || [deviceString isEqualToString:@"iPod Touch 2G"] || [deviceString isEqualToString:@"iPhone Simulator"])
	{
		iscemera = NO;
		alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil
										 otherButtonTitles:@"From Gallery", @"Cancel", nil];
	}
	else
	{
		iscemera = YES;
		alertOnChoose = [[UIAlertView alloc] initWithTitle:
						 nil message:nil delegate:self cancelButtonTitle:
						 nil otherButtonTitles:
						 @"Choose From Gallery", 
						 @"Take Photo",@"Cancel", nil];
	}	
	whereClicked = 2;
	[alertOnChoose show];
	[alertOnChoose release];
}

- (void)resignAll {
	
	[txtPersonContact resignFirstResponder];
	[txtPersonEmail resignFirstResponder];
	[txtPersonLinkedInEmail resignFirstResponder];
	[txtPersonName resignFirstResponder];
	[txtPrefix resignFirstResponder];
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
	// commented and added by pradeep on 18 august for fixing bug 	00255 on rth
	//if(whereClicked != 1) // i.e. whereclicked not = 1 i.e. 2
	if (whereClicked == 2)
	{
		if(iscemera){
			cameraUse = YES;
			if (buttonIndex == 0)
			{
				NSLog(@"chose existing photo");
				[self switchTouched];
			}
			else if (buttonIndex == 1)
			{
				
				NSLog(@"take photo from camera");
				[self recordNow];
			}
			else if (buttonIndex == 0)
			{
				NSLog(@"Cancel");
			}
		}
		else {
			if (buttonIndex == 0)
			{
				NSLog(@"chose existing photo");
				[self switchTouched];
			}
			else if (buttonIndex == 1)
			{
				NSLog(@"Cancel");
			}
		}
	}
	else if (whereClicked==1)
	{
		if (buttonIndex == 0)
		{
			whereClicked = 2;
		}
	}
	// added by pradeep on 18 august 2011 for fixing bug if wifi not working and trying to update info i.e. id on rth 	00255
	else if (whereClicked==3)
	{
		if (buttonIndex == 0)
		{
			whereClicked = 2;
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
	// end 18 august 2011
}

- (void) switchTouched {
	
	cameraUse = NO;
	printf("switch touched - %d", cameraUse);
	[self recordNow];
}

- (IBAction)recordNow {
	
	[self captureImage];
	//set this flag back to yes for the next time.
	cameraUse = YES;
}

-(void) captureImage {	
	self.imgPicker = [[UIImagePickerController alloc] init];
	self.imgPicker.allowsEditing = YES;
	self.imgPicker.delegate = self;		
	
	if (cameraUse) {
		self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	else {
		self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	[self presentModalViewController:self.imgPicker animated:YES];
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {	

	if ([capturedImage count] > 0)
	{
		capturedImage = nil;
		capturedImage = [[NSMutableArray alloc] init];
	}
	[capturedImage addObject:img];
	edited = YES;

	savingProfile = NO;
	[self storeToMutableArray];
	
	allInfo2 = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:txtPrefix.text, txtPersonName.text, txtPersonEmail.text, txtPersonContact.text, nil]];
	imageGrabed.image = [capturedImage objectAtIndex:0];
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (BOOL) send4GeneralInfo: (NSString *) flag {
	
	NSLog(@"Sending....");
	
	NSData *imageData1 = [[NSData alloc] init];;
	NSString *isimg1exist = [NSString stringWithFormat:@"%@\r\n", @"no"];
	NSString *isimgexist = @"no";
	
	if ([capturedImage count] > 0)
	{		
		isimg1exist = [NSString stringWithFormat:@"%@\r\n", @"yes"];
		isimgexist = @"yes";
		imageData1 = UIImageJPEGRepresentation([capturedImage objectAtIndex:0], 1.0);
	}
	
	
	// setting up the URL to post to
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];	
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
	 */
	
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",flag];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	NSString *prefix = [NSString stringWithFormat:@"%@\r\n",[allInfo objectAtIndex:0]];
	NSString *name = [NSString stringWithFormat:@"%@\r\n",[allInfo objectAtIndex:1]];
	NSString *email = [NSString stringWithFormat:@"%@\r\n",[allInfo objectAtIndex:2]];
	NSString *contact = [NSString stringWithFormat:@"%@\r\n",[allInfo objectAtIndex:3]];
	NSString *linkedinmail = [NSString stringWithFormat:@"%@\r\n",[allInfo objectAtIndex:4]];
	NSString *matchEmail = [NSString stringWithFormat:@"%i\r\n", matchemail];
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	NSString *allownotification = [NSString stringWithFormat:@"%@\r\n",@"0"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"flag\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",flg1] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"deviceid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",deviceUDID] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"flag2\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",flg2] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	if ([flag compare:@"updateprofilestep1v14"] == NSOrderedSame)
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",self.userid]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"devicetocken\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",deviceTocken] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"prefix\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",prefix] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",name] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"useremail\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",email] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"linkedinmail\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",linkedinmail] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"matchemail\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",matchEmail] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"usercontact\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",contact] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"pic1exist\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",isimg1exist] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	if ([isimgexist compare:@"yes"] == NSOrderedSame)
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"pic1\"; filename=\"pic1.jpg\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[NSData dataWithData:imageData1]];
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"isallownotification\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",allownotification] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	//we need an activity indicator here.	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//[activityView startAnimating];
	
    NSHTTPURLResponse *response11;
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response11 error:nil];
	
	NSLog(@"response header: %@", [response11 allHeaderFields]);
	
	NSDictionary *dic = [response11 allHeaderFields];
	BOOL successflg=NO;
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Userid"])			
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				[self updateDataFileOnSave:[dic objectForKey:key]];
				if ([capturedImage count] > 0)
					[self updateDataFileOnSave4Img:[dic objectForKey:key]];
				NSLog(@"\n\n\n\n\n\n#######################-- post For Settings Step 1 added successfully --#######################\n\n\n\n\n\n");				
				successflg=YES;
				userid = [dic objectForKey:key];
				arrayForUserID = [[NSMutableArray alloc]init];
				[arrayForUserID addObject:userid];
				break;
			}			
		}
		if ([key isEqualToString:@"Useridexist"])			
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				whereClicked = 1;
				alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"E-Mail already exist, please try another one!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
				[alertOnChoose show];
				[alertOnChoose release];
				activityView.hidden = YES;
				loading.hidden = YES;
				loadingBack.hidden = YES;
				[activityView stopAnimating];
				successflg=NO;
				
				break;
			}
		}
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

- (void)btnSelPrefix_Click {
	
	[self resignAll];
	CGSize contentSize = CGSizeMake(320, 480);	
	UIGraphicsBeginImageContext(contentSize);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	capturedScreen = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:UIGraphicsGetImageFromCurrentImageContext(), nil]];
	UIGraphicsEndImageContext();	
	
	[self storeToMutableArray];
	SettingsSelectPrefix *settingsSelectPrefix = [[SettingsSelectPrefix alloc]init];
	[txtPrefix resignFirstResponder];
	[txtPersonName resignFirstResponder];
	[txtPersonEmail resignFirstResponder];
	settingsSelectPrefix.strPrefix = txtPrefix.text;
	[self.navigationController presentModalViewController:settingsSelectPrefix animated:YES];
	[settingsSelectPrefix release];
}

- (void)btnDone_OnClick {
	
	[self viewMovedUp:+132];
	[txtPersonContact resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	// added by pradeep on 29 june 2011
	//imgPicker.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
}

/*UILabel *personEmail = [UnsocialAppDelegate createLabelControl:@"E-Mail*:" frame:CGRectMake(30, 202, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
 [self.view addSubview:personEmail];
 
 txtPersonEmail = [UnsocialAppDelegate createTextFieldControl:CGRectMake(personEmail.frame.origin.x, personEmail.frame.origin.y + 25, personEmail.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"E-Mail" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
 [txtPersonEmail setDelegate:self];
 txtPersonEmail.backgroundColor = [UIColor clearColor];
 [self.view addSubview:txtPersonEmail];
 txtPersonEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
 txtPersonEmail.autocorrectionType = UITextAutocorrectionTypeNo;
 txtPersonEmail.keyboardType = UIKeyboardTypeEmailAddress;
 txtPersonEmail.returnKeyType = UIReturnKeyDone;
 
 UILabel *personContact = [UnsocialAppDelegate createLabelControl:@"Phone #:" frame:CGRectMake(personEmail.frame.origin.x, 268, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
 [self.view addSubview:personContact];
 
 txtPersonContact = [UnsocialAppDelegate createTextFieldControl:CGRectMake(personEmail.frame.origin.x, personContact.frame.origin.y + 25, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"Phone Number" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
 [txtPersonContact setDelegate:self];
 [self.view addSubview:txtPersonContact];
 txtPersonContact.backgroundColor = [UIColor clearColor];*/

@end
