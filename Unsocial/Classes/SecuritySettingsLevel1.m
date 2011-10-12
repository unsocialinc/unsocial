//
//  SecuritySettingsLevel1.m
//  Unsocial
//
//  Created by vaibhavsaran on 22/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Person.h"
#import "GlobalVariables.h"
#import "SecuritySettingsLevel1.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"
#import "ChangePwd.h"

#define klabelFontSize  13

@implementation SecuritySettingsLevel1
@synthesize varSelectedLevel, varSecurityItems, varUserid, userid, selectedLevels;
@synthesize strdispMail, strdispIndus, strdispComp, strdispCont;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	activityView.hidden = YES;
	[self createControls];
}

- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"ShowIndustryDetail view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	//add background color
	self.view.backgroundColor = color;
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"signupback.png"];
	[self.view addSubview:imgBack];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Privacy Settings" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 42, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 100, 260, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	UILabel *subHeading = [UnsocialAppDelegate createLabelControl:@"Set your privacy options here." frame:CGRectMake(15, 42, 290, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:subHeading];
	// 13 may 2011 by pradeep //[subHeading release];
	
	CGRect coachFrame = CGRectMake(5, 5, 36, 28);
	UIButton *backBtn = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(leftbtn_OnClick) frame:coachFrame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:backBtn];
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"Saving..." frame:CGRectMake(100, 380, 280, 20) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];*/
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)leftbtn_OnClick
{
	[UnsocialAppDelegate playClick];
	if(switchPrivacyLevel.on == YES)
		editedLevel1 = YES;
	else
		editedLevel1 = NO;
	
	if(switchCtl1.on == YES)
		self.strdispMail = @"1";
	else
		self.strdispMail = @"0";
	
	if(switchCtl2.on == YES)
		strdispIndus = @"1";
	else
		self.strdispIndus = @"0";
	
	if(switchCtl3.on == YES)
		self.strdispComp = @"1";
	else
		self.strdispComp = @"0";
	
	if(switchCtl4.on == YES)
		self.strdispCont = @"1";
	else
		self.strdispCont = @"0";
	
	[self getDataFromFile];

	self.selectedLevels = [NSString stringWithFormat:@"%@%@%@%@", self.strdispMail, self.strdispIndus, self.strdispComp, self.strdispCont];

	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(180, 380, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	activityView.hidden = NO;
	//[self.view addSubview:loading];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Saving..." frame:CGRectMake(100, 380, 280, 20) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	loading.hidden = NO;

	[self.navigationController popViewControllerAnimated:YES];
	
		// Saves data at left navigation 
	[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
}

- (BOOL) getDataFromFile {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"securitysettings"];
	
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
		varSelectedLevel = [[tempArray objectAtIndex:0] selectedSecurityLevel];
		varSecurityItems = [[tempArray objectAtIndex:0] displayedSecurityItems];
		varUserid = [[tempArray objectAtIndex:0] userid];
		
		[decoder finishDecoding];
		[decoder release];	
		
		if ( [varUserid compare:@""] == NSOrderedSame || !varUserid)
		{
			return NO;
		}
		else {
				// initialized global userid variable (returned usierid from web app) for tracing user in whole app
			
			return YES;
		}		
	}
	else {
			//just in case the file is not ready yet.
		return NO;
	}
}

- (void)createControls {
	
	// Load an application image and set it as the primary view
	
	int increaseYaxis4newPrivacy = -10;
	
	contentView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	contentView.backgroundColor = [UIColor whiteColor];
	
	switchPrivacyLevel = [[UISwitch alloc] initWithFrame:CGRectMake(198.0, 70 + yAxisForSettingControls +increaseYaxis4newPrivacy, 104.0, 30.0)];
	[switchPrivacyLevel addTarget:self action:@selector(privacyLevel:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:switchPrivacyLevel];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//personEmail = [UnsocialAppDelegate createLabelControl:@"E-Mail:" frame:CGRectMake(30, 100, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	personEmail = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"E-Mail:" frame:CGRectMake(30, 100, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	personEmail.hidden = YES;
	[self.view addSubview:personEmail];
	
	btnpersonEmail = [UnsocialAppDelegate createButtonControl:@"(What is this?)" target:self selector:@selector(btnpersonEmail_click) frame:CGRectMake(210, personEmail.frame.origin.y, 100, personEmail.frame.size.height) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnpersonEmail.titleLabel.textAlignment = UITextAlignmentRight;
	[btnpersonEmail.titleLabel setFont:[UIFont boldSystemFontOfSize:klabelFontSize]];
	btnpersonEmail.hidden = YES;
	[self.view addSubview:btnpersonEmail];
	
	switchCtl1 = [[UISwitch alloc] initWithFrame:CGRectMake(personEmail.frame.origin.x, personEmail.frame.origin.y + 25, personEmail.frame.size.width, 30)];
	[switchCtl1 addTarget:self action:@selector(dispMail:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:switchCtl1];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//personIndustry = [UnsocialAppDelegate createLabelControl:@"Industry:" frame:CGRectMake(personEmail.frame.origin.x, personEmail.frame.origin.y + 55, personEmail.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	personIndustry = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Industry:" frame:CGRectMake(personEmail.frame.origin.x, personEmail.frame.origin.y + 55, personEmail.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	personIndustry.hidden = YES;
	[self.view addSubview:personIndustry];
	
	btnpersonIndustry = [UnsocialAppDelegate createButtonControl:@"(What is this?)" target:self selector:@selector(btnpersonIndustry_click) frame:CGRectMake(210, personIndustry.frame.origin.y, 100, personIndustry.frame.size.height) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnpersonIndustry.titleLabel.textAlignment = UITextAlignmentRight;
	[btnpersonIndustry.titleLabel setFont:[UIFont boldSystemFontOfSize:klabelFontSize]];
	[self.view addSubview:btnpersonIndustry];
	
	switchCtl2 = [[UISwitch alloc] initWithFrame:CGRectMake(personIndustry.frame.origin.x, personIndustry.frame.origin.y + 25, personIndustry.frame.size.width, 30)];
	[switchCtl2 addTarget:self action:@selector(dispIndus:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:switchCtl2];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//personCompany = [UnsocialAppDelegate createLabelControl:@"Company:" frame:CGRectMake(personIndustry.frame.origin.x, personIndustry.frame.origin.y + 55, personIndustry.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	personCompany = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Company:" frame:CGRectMake(personIndustry.frame.origin.x, personIndustry.frame.origin.y + 55, personIndustry.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011

	personCompany.hidden = YES;
	[self.view addSubview:personCompany];
	
	btnpersonCompany = [UnsocialAppDelegate createButtonControl:@"(What is this?)" target:self selector:@selector(btnpersonCompany_click) frame:CGRectMake(210, personCompany.frame.origin.y, 100, personCompany.frame.size.height) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnpersonCompany.titleLabel.textAlignment = UITextAlignmentRight;
	[btnpersonCompany.titleLabel setFont:[UIFont boldSystemFontOfSize:klabelFontSize]];
	[self.view addSubview:btnpersonCompany];
	
	switchCtl3 = [[UISwitch alloc] initWithFrame:CGRectMake(personCompany.frame.origin.x, personCompany.frame.origin.y + 25, personCompany.frame.size.width, 30)];
	[switchCtl3 addTarget:self action:@selector(dispComp:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:switchCtl3];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//personContact = [UnsocialAppDelegate createLabelControl:@"Phone:" frame:CGRectMake(personCompany.frame.origin.x, personCompany.frame.origin.y + 55, personCompany.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	personContact = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Phone:" frame:CGRectMake(personCompany.frame.origin.x, personCompany.frame.origin.y + 55, personCompany.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011

	
	personContact.hidden = YES;
	[self.view addSubview:personContact];
	
	btnpersonContact = [UnsocialAppDelegate createButtonControl:@"(What is this?)" target:self selector:@selector(btnpersonContact_click) frame:CGRectMake(210, personContact.frame.origin.y, 100, personContact.frame.size.height) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnpersonContact.titleLabel.textAlignment = UITextAlignmentRight;
	[btnpersonContact.titleLabel setFont:[UIFont boldSystemFontOfSize:klabelFontSize]];
	[self.view addSubview:btnpersonContact];
	
	switchCtl4 = [[UISwitch alloc] initWithFrame:CGRectMake(personContact.frame.origin.x, personContact.frame.origin.y + 25, personContact.frame.size.width, 30)];
	[switchCtl4 addTarget:self action:@selector(dispCont:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:switchCtl4];

	switchPrivacyLevel.on = NO;
	[switchCtl1 setOn:YES animated:NO];
	[switchCtl2 setOn:YES animated:NO];
	[switchCtl3 setOn:YES animated:NO];
	[switchCtl4 setOn:YES animated:NO];
	BOOL isDataExists = [self getDataFromFile];
	if(isDataExists)	{
		
		int intPrivacyLevel = [varSelectedLevel integerValue];
		if(intPrivacyLevel == 0) switchPrivacyLevel.on = NO;
		else switchPrivacyLevel.on = YES;
		
		NSString *switch1 = [varSecurityItems substringWithRange:NSMakeRange(0, 1)];
		int intSwitch1 = [switch1 integerValue];
		NSString *switch2 = [varSecurityItems substringWithRange:NSMakeRange(1, 1)];
		int intSwitch2 = [switch2 integerValue];
		NSString *switch3 = [varSecurityItems substringWithRange:NSMakeRange(2, 1)];
		int intSwitch3 = [switch3 integerValue];
		NSString *switch4 = [varSecurityItems substringWithRange:NSMakeRange(3, 1)];
		int intSwitch4 = [switch4 integerValue];
		
		if(intSwitch1 == 0) [switchCtl1 setOn:NO animated:NO];
		else [switchCtl1 setOn:YES animated:NO];
		
		if(intSwitch2 == 0) [switchCtl2 setOn:NO animated:NO];
		else [switchCtl2 setOn:YES animated:NO];
		
		if(intSwitch3 == 0) [switchCtl3 setOn:NO animated:NO];
		else [switchCtl3 setOn:YES animated:NO];
		
		if(intSwitch4 == 0) [switchCtl4 setOn:NO animated:NO];
		else [switchCtl4 setOn:YES animated:NO];
	}
	
	UILabel *personPrivacyLevel = [UnsocialAppDelegate createLabelControl:@"Privacy:" frame:CGRectMake(10, 70 + yAxisForSettingControls +increaseYaxis4newPrivacy, 160, 30) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	
	[self.view addSubview:personPrivacyLevel];
	// 13 may 2011 by pradeep //[personPrivacyLevel release];
	
		// no need of save button, left button save data -vaibhav(V1.1)
	/*btnSave = [UnsocialAppDelegate createButtonControl:@"Save" target:self selector:@selector(btnSave_Click) frame:CGRectMake(128, 380, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSave];
	[btnSave release];*/
	
	if(switchPrivacyLevel.on == YES)
	{
		NSLog(@"Privacy Level On");
		personEmail.hidden = NO;
		personIndustry.hidden = NO;
		personCompany.hidden = NO;
		personContact.hidden = NO;
		
		switchCtl1.hidden = NO;
		switchCtl2.hidden = NO;
		switchCtl3.hidden = NO;
		switchCtl4.hidden = NO;
		
		btnpersonEmail.hidden = NO;
		btnpersonIndustry.hidden = NO;
		btnpersonCompany.hidden = NO;
		btnpersonContact.hidden = NO;
	}
	else 
	{
		NSLog(@"Privacy Level Off");
		
		personEmail.hidden = YES;
		personIndustry.hidden = YES;
		personCompany.hidden = YES;
		personContact.hidden = YES;
		
		switchCtl1.hidden = YES;
		switchCtl2.hidden = YES;
		switchCtl3.hidden = YES;
		switchCtl4.hidden = YES;
		
		switchCtl1.on = YES;
		switchCtl2.on = YES;
		switchCtl3.on = YES;
		switchCtl4.on = YES;

		btnpersonEmail.hidden = YES;
		btnpersonIndustry.hidden = YES;
		btnpersonCompany.hidden = YES;
		btnpersonContact.hidden = YES;
	}
	btnCngPwd = [UnsocialAppDelegate createButtonControl:@"Change Password" target:self selector:@selector(btnCngPwd_Click) frame:CGRectMake(30, 340, 130, 25) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnCngPwd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[btnCngPwd.titleLabel setFont:[UIFont boldSystemFontOfSize:klabelFontSize]];
	[self.view addSubview:btnCngPwd];

	BOOL prefixes = [self getPrefixFromFile];
	if(!prefixes) {

		NSString *strLinkedInMail = [UnsocialAppDelegate getLinkedInMailFromFile];
		
		if([strLinkedInMail isEqualToString:@""]) {
			
			[switchCtl1 setEnabled:NO];
			[btnCngPwd setHidden:YES];
				//[btnpersonEmail setHidden:YES];
		}
	}
	else
	{
		[switchCtl1 setEnabled:YES];
		[btnCngPwd setHidden:NO];
			//[btnpersonEmail setHidden:NO];
	}
	if(switchPrivacyLevel.on == NO)
		btnCngPwd.frame = CGRectMake(30, 125, 130, 25);
}

- (void) btnCngPwd_Click {
	
	ChangePwd *changePwd = [[ChangePwd alloc]init];
	[self.navigationController pushViewController:changePwd animated:NO];
	[changePwd release];
}

- (void)btnpersonEmail_click {
	
	UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:nil message:@"Turn Email \"ON\" to hide your email address when others view your profile." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert1 show];
	[alert1 release];
}

- (void)btnpersonIndustry_click {
	
	UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:nil message:@"Turn Industry \"ON\" to hide your Industry when others view your profile." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert2 show];
	[alert2 release];
}

- (void)btnpersonCompany_click {
	
	UIAlertView *alert3 = [[UIAlertView alloc]initWithTitle:nil message:@"Turn Company \"ON\" to hide your Company when others view your profile." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert3 show];
	[alert3 release];
}

- (void)btnpersonContact_click {
	
	UIAlertView *alert4 = [[UIAlertView alloc]initWithTitle:nil message:@"Turn Phone \"ON\" to hide your Phone when others view your profile." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert4 show];
	[alert4 release];
}

- (void)btnSave_Click {
	
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
}

- (void)privacyLevel:(id)sender {
	
	if([sender isOn])
	{
			//START move Change Password button down -vaibhav(V1.1)
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationBeginsFromCurrentState:YES];
		
		btnCngPwd.frame = CGRectMake(btnCngPwd.frame.origin.x, 340, btnCngPwd.frame.size.width, btnCngPwd.frame.size.height);
		[UIView commitAnimations];
			//END
		[NSTimer scheduledTimerWithTimeInterval:0.50 target:self selector:@selector(ChngPwdMoveDown:) userInfo:self.view repeats:NO];
	}
	else 
	{		
			//START move Change Password button up -vaibhav(V1.1)
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationBeginsFromCurrentState:YES];
		
		btnCngPwd.frame = CGRectMake(btnCngPwd.frame.origin.x, 125, btnCngPwd.frame.size.width, btnCngPwd.frame.size.height);
		[UIView commitAnimations];
			//END
		NSLog(@"Privacy Level Off");
		
		personEmail.hidden = YES;
		personIndustry.hidden = YES;
		personCompany.hidden = YES;
		personContact.hidden = YES;
		
		switchCtl1.hidden = YES;
		switchCtl2.hidden = YES;
		switchCtl3.hidden = YES;
		switchCtl4.hidden = YES;
		
		switchCtl1.on = YES;
		switchCtl2.on = YES;
		switchCtl3.on = YES;
		switchCtl4.on = YES;
		
		btnpersonEmail.hidden = YES;
		btnpersonIndustry.hidden = YES;
		btnpersonCompany.hidden = YES;
		btnpersonContact.hidden = YES;
	}
}

- (void) ChngPwdMoveDown:(id)sender {	
	
	NSLog(@"Privacy Level On");
	personEmail.hidden = NO;
	personIndustry.hidden = NO;
	personCompany.hidden = NO;
	personContact.hidden = NO;
	
	switchCtl1.hidden = NO;
	switchCtl2.hidden = NO;
	switchCtl3.hidden = NO;
	switchCtl4.hidden = NO;
	
	btnpersonEmail.hidden = NO;
	btnpersonIndustry.hidden = NO;
	btnpersonCompany.hidden = NO;
	btnpersonContact.hidden = NO;
	
	BOOL isDataExists = [self getDataFromFile];
	if(isDataExists)	
	{
		
			//int intPrivacyLevel = [varSelectedLevel integerValue];
			//if(intPrivacyLevel == 0) switchPrivacyLevel.on = NO;
			//else switchPrivacyLevel.on = YES;
		
		NSString *switch1 = [varSecurityItems substringWithRange:NSMakeRange(0, 1)];
		int intSwitch1 = [switch1 integerValue];
		NSString *switch2 = [varSecurityItems substringWithRange:NSMakeRange(1, 1)];
		int intSwitch2 = [switch2 integerValue];
		NSString *switch3 = [varSecurityItems substringWithRange:NSMakeRange(2, 1)];
		int intSwitch3 = [switch3 integerValue];
		NSString *switch4 = [varSecurityItems substringWithRange:NSMakeRange(3, 1)];
		int intSwitch4 = [switch4 integerValue];
		
		if(intSwitch1 == 0) switchCtl1.on = NO;
		else switchCtl1.on = YES;
		
		if(intSwitch2 == 0) switchCtl2.on = NO;
		else switchCtl2.on = YES;
		
		if(intSwitch3 == 0) switchCtl3.on = NO;
		else switchCtl3.on = YES;
		
		if(intSwitch4 == 0) switchCtl4.on = NO;
		else switchCtl4.on = YES;
	}
	else {
		switchCtl1.on = NO;
		switchCtl2.on = NO;
		switchCtl3.on = NO;
		switchCtl4.on = NO;
	}
}

- (void)startProcess {
	if(switchPrivacyLevel.on == NO)
	{
		[self sendSecurityLevel:@"0000":@"0"];
	}
	else //if(selectedSegment == 1)
	{
		/*if(!editedLevel1)
		{
			if([selectedLevels compare:@""] == NSOrderedSame)
				selectedLevels = @"1111";
		}*/
		[self sendSecurityLevel:self.selectedLevels :@"1"];
	}
}

- (BOOL)sendSecurityLevel:(NSString *)selsecurity:(NSString *)selectedLevel {
	
	NSLog(@"Sending....");
	
	// setting up the URL to post to	
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];	
	
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSString *flag = [NSString stringWithFormat:@"%@\r\n",@"updateprofilestep5"];
	
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	NSString *selSecurity = [NSString stringWithFormat:@"%@\r\n",selsecurity];
	NSString *securityLevel = [NSString stringWithFormat:@"%@\r\n",selectedLevel];
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	NSString *allownotification = [NSString stringWithFormat:@"%@\r\n",@"0"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];		
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"flag\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",flag] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"displayitem4security\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",selSecurity] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"securitylevel\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",securityLevel] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
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
		if ([key compare:@"Userid"] == NSOrderedSame)			
		{
			//userid = [dic objectForKey:key];
			
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				[self updateDataFileOnSave:[arrayForUserID objectAtIndex:0] :selectedLevel:selsecurity];
				NSLog(@"\n\n\n\n\n\n#######################-- post for SecuritySettings added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				//localuserid = [dic objectForKey:key];
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

- (void)dispMail:(id)sender {
	
	if([sender isOn])
	{
		NSLog(@"Display Email");
	}
	else 
	{
		NSLog(@"Dont Display Email");
	}
}

- (void)dispIndus:(id)sender {
	
	if([sender isOn])
	{
		NSLog(@"Display Industry");
	}
	else 
	{
		NSLog(@"Dont Display Industry");
	}
}

- (void)dispComp:(id)sender {
	
	if([sender isOn])
	{
		NSLog(@"Display Company");
	}
	else 
	{
		NSLog(@"Dont Display Company");
	}
}

- (void)dispCont:(id)sender {
	
	if([sender isOn])
	{
		NSLog(@"Display Phone");
	}
	else 
	{
		NSLog(@"Dont Display Phone");
	}
}

/*- (void)leftbtn_OnClick {
	saveLevel1 = YES;
	[self dismissModalViewControllerAnimated:YES];
}*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (BOOL) getPrefixFromFile {

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial"];
	
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
	
	if ([userprefix compare:@"Mr"] == NSOrderedSame || [userprefix compare:@"Miss"] == NSOrderedSame || [userprefix compare:@"Mrs"] == NSOrderedSame)
	{
		return YES;
	}
	else {
		
		return NO;
	}
}

- (void) updateDataFileOnSave:(NSString *)uid:(NSString *)level:(NSString *)securityItems {
	
	//NSLog(@"Selected Value- %d", selitem);
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];	
	
	newPerson.selectedSecurityLevel = level;
	newPerson.displayedSecurityItems = securityItems;
	newPerson.userid = uid;
	
	//newPerson.imgperson = [images objectAtIndex:0];
	NSLog(@"\nselectedSecurityLevel-%@\n\ndisplayedSecurityItems-%@", 	  
		  newPerson.selectedSecurityLevel, 
		  newPerson.displayedSecurityItems
		  );
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"securitysettings"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
