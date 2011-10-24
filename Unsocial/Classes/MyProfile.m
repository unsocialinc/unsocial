//
//  PeoplesUserProfile.m
//  Unsocial
//
//  Created by vaibhavsaran on 23/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyProfile.h"
#import "PeopleSendMessage.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"
#import "SettingsStep5.h"
#import "ReferPeople.h"
#import "Person.h"
#import "WebViewForWebsites.h"

NSString *ownerKeywords2;

@implementation MyProfile

@synthesize username, userid, userind, userrole, userprefix, useremail, usercontact, userwebsite, usercompany, statusmgs, userlinkedin, displayedSecurityItems, userlinkedinmail, usertitle;
@synthesize fullImg;

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
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	[imgBack release];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"signupback.png"];
	[self.view addSubview:imgBack];
	[imgBack release];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];	
		
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 210, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {
	
	[self getKeywordsForUser:@""];
	//collectionAryKeywords = [[NSMutableArray alloc]init];
	if ([stories count] >0)
	{		
		ownerKeywords2 = @"";
		for (int cnt=0; cnt < [stories count]; cnt++) 
		{
			ownerKeywords2 = (ownerKeywords2==@"")?[[stories objectAtIndex:cnt] objectForKey:@"keywords"]:[ownerKeywords2 stringByAppendingString:[@", " stringByAppendingString:[[stories objectAtIndex:cnt] objectForKey:@"keywords"]]]; 
		}
		//[collectionAryKeywords addObject:ownerKeywords2];
		NSLog(@"profile owner's who am i keywords are- %@", ownerKeywords2);
	}
	
	[self getDataFromFile];
	[self getData2FromFile];
	[self getImageFromFile];
	[self getStatusFromFile];
	[self getPrivacyFromFile];
	
	// commented by pradeep on 11 august for fixing different image layout
	/*CGImageRef realImage = fullImg.CGImage;
	float realHeight = CGImageGetHeight(realImage);
	float realWidth = CGImageGetWidth(realImage);
	// commented by pradeep on 11 august for fixing different image layout
	float ratio = realHeight/realWidth;
	float modifiedWidth, modifiedHeight;
	// commented by pradeep on 11 august for fixing different image layout
	if(ratio >= 1) {
		
		modifiedWidth = 75/ratio;
		modifiedHeight = 75;
	}
	else {
		
		modifiedWidth = 75;
		modifiedHeight = ratio*75;
	}
	
	userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, modifiedWidth, modifiedHeight)];*/
	userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 75, 75)];
	userImage.image = fullImg;
	
	// Get the Layer of any view
	CALayer * l = [userImage layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:10.0];
	
	// You can even add a border
	[l setBorderWidth:1.0];
	[l setBorderColor:[[UIColor blackColor] CGColor]];
	[self.view addSubview:userImage];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[userImage release];
	// end 3 august 2011 for fixing memory issue

	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(90, 85, 220, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	heading = [UnsocialAppDelegate createTextViewControl:username frame:CGRectMake(90, 13, 220, 75) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize-1 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	heading.contentInset = UIEdgeInsetsMake(-4.00, -8.00, 0.00, 0.00);
	heading.scrollsToTop = YES;
	[self.view addSubview:heading];
	
	// for adding TT's navigation controller for website
	[self.navigationItem setTitle:username];
	
	NSString *displayitem = displayedSecurityItems;
	isemailshow = [[displayitem substringFromIndex:0] substringToIndex:1];
	NSString *isindustryshow = [[displayitem substringFromIndex:1] substringToIndex:1];
	NSString *iscompanyshow = [[displayitem substringFromIndex:2] substringToIndex:1];
	iscontactshow = [[displayitem substringFromIndex:3] substringToIndex:1];
	
	UILabel *lbltitle = [UnsocialAppDelegate createLabelControl:@"Title: " frame:CGRectMake(10, 90, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lbltitle];
	
	UILabel *lblcompany = [UnsocialAppDelegate createLabelControl:@"Company: " frame:CGRectMake(lbltitle.frame.origin.x, lbltitle.frame.origin.y + 16, 270, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblcompany];
	
	UILabel *lblindustry = [UnsocialAppDelegate createLabelControl:@"Industry:" frame:CGRectMake(lblcompany.frame.origin.x, lblcompany.frame.origin.y + 16, 270, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblindustry];
	
	UILabel *lblemail = [UnsocialAppDelegate createLabelControl:@"E-Mail: " frame:CGRectMake(lblcompany.frame.origin.x, lblindustry.frame.origin.y + 16, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblemail];
	
	UILabel *lblcontact = [UnsocialAppDelegate createLabelControl:@"Contact:" frame:CGRectMake(lblcompany.frame.origin.x, lblemail.frame.origin.y + 16, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblcontact];
	
	UILabel *lbllinkedIn = [UnsocialAppDelegate createLabelControl:@"Public Profile:" frame:CGRectMake(lblcompany.frame.origin.x, lblcontact.frame.origin.y + 16, 80, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lbllinkedIn];
	
	CGRect lableTitleFrame = CGRectMake(lblcompany.frame.origin.x + 58, lbltitle.frame.origin.y, 240, 15);
	UILabel *lblTitle = [UnsocialAppDelegate createLabelControl:usertitle frame:lableTitleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	[self.view addSubview:lblTitle];
	
		// for company **** start ****
	// if company is set as private then it will be as 1 else 0
	CGRect lableCompanyFrame = CGRectMake(lblcompany.frame.origin.x + 58, lblcompany.frame.origin.y, 240, 15);
	UILabel *lblCompny = [UnsocialAppDelegate createLabelControl:@"" frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	[self.view addSubview:lblCompny];
	
	if ([iscompanyshow compare:@"0"] != NSOrderedSame) // company is private i.e. 1
	{
		CGRect lableLockFrame = CGRectMake(lblCompny.frame.origin.x, lblcompany.frame.origin.y, 15, 15);
		userImage = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
		[self.view addSubview:userImage];
	}
	else {
		
		if ([usercompany compare:@""] == NSOrderedSame)
			lblCompny.text = @"";
		else {
			lblCompny.text = usercompany;
		}
	}
	// for company **** end ****
	
	
	CGRect lableIntIndFrame = CGRectMake(lableCompanyFrame.origin.x, lableCompanyFrame.origin.y + 16, lblCompny.frame.size.width, 15);
	UILabel *lblIndustry = [UnsocialAppDelegate createLabelControl:@"" frame:lableIntIndFrame txtAlignment:UITextAlignmentLeft numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	[self.view addSubview:lblIndustry];
	
	if ([isindustryshow compare:@"0"] != NSOrderedSame)//industry is private i.e. 1
	{
		CGRect lableLockFrame = CGRectMake(lblIndustry.frame.origin.x, lblIndustry.frame.origin.y, 15, 15);
		userImage = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
		[self.view addSubview:userImage];
	}
	else {
		
		if ([userind compare:@""] == NSOrderedSame)
			lblIndustry.text = @"";
		else
			lblIndustry.text = userind;
	}
	
	// for email **** start ****
	// if email is set as private then it will be as 1 else 0
	CGRect lableEmailFrame = CGRectMake(lblIndustry.origin.x, lblIndustry.origin.y + 16, lblCompny.frame.size.width, 15);
	
	lblEmail = [UnsocialAppDelegate createLabelControl:@"" frame:lableEmailFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	[self.view addSubview:lblEmail];
	
	if ([isemailshow compare:@"0"] != NSOrderedSame) {// email is private i.e. 1
		
		CGRect lableLockFrame = CGRectMake(lblEmail.frame.origin.x, lblEmail.origin.y, 15, 15);
		imgLockForEmail = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
		[self.view addSubview:imgLockForEmail];
	}
	else 
	{
		if(![userprefix isEqualToString:@"none"])
			lblEmail.text = useremail;
		else
			lblEmail.text = userlinkedinmail;
		if ([useremail isEqualToString:@""])
			lblEmail.text = @"";		
		[self.view addSubview:lblEmail];
	}
	// for email **** end ****
	
	// for phone # **** start ****
	// if phone # is set as private then it will be as 1 else 0
	CGRect lableContactFrame = CGRectMake(lblEmail.origin.x, lblEmail.origin.y + 16, lblCompny.frame.size.width, 15);	
	/*lblPhone = [UnsocialAppDelegate createLabelControl:@"" frame:lableContactFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	[self.view addSubview:lblPhone];*/
		
	// changed TextColorNormal:[UIColor orangeColor] to TextColorNormal:[UIColor whiteColor] by pradeep on 24 march 2011 since contact is visualize clickable but shoud not
	UIButton *btnCallTheNumber = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnCallTheNumber_Click) frame:lableContactFrame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnCallTheNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[self.view addSubview:btnCallTheNumber];
	
	if ([iscontactshow compare:@"0"] != NSOrderedSame) // company is private i.e. 1
	{		
		//btnCallTheNumber.text = @"Phone:";
		CGRect lableLockFrame = CGRectMake(btnCallTheNumber.origin.x, btnCallTheNumber.origin.y, 15, 15);
		imgLockForPhone = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
		[self.view addSubview:imgLockForPhone];
		btnCallTheNumber.hidden = YES;
	}
	else {
		if ([self.usercontact compare:@""] == NSOrderedSame) {
			
			[btnCallTheNumber setTitle:@"" forState:UIControlStateNormal];
			[btnCallTheNumber setHidden:YES];
				//			btnCallTheNumber.text = @"";
				//			btnCallTheNumber.hidden = YES;
		}
		else {
			[btnCallTheNumber setTitle:self.usercontact forState:UIControlStateNormal];
			[btnCallTheNumber setHidden:NO];
				//			btnCallTheNumber.text = self.usercontact;
				//			btnCallTheNumber.hidden = NO;	
		}
	}
	
	CGRect lableLinkedInFrame = CGRectMake(btnCallTheNumber.origin.x + 20, btnCallTheNumber.origin.y + 16, lblCompny.frame.size.width - 15, 15);	
	
	/*tvLinkedIn = [UnsocialAppDelegate createTextViewControl:@"" frame:lableLinkedInFrame txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:11 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:NO editable:NO];
	tvLinkedIn.contentInset = UIEdgeInsetsMake(-8, -8, 0, 0);
	[self.view addSubview:tvLinkedIn];*/
	
	btnOpenLinkedIn = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnOpenLinkedIn_Click) frame:lableLinkedInFrame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnOpenLinkedIn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[self.view addSubview:btnOpenLinkedIn];
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, btnOpenLinkedIn.origin.y + 17, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	if ([userlinkedin compare:@""] == NSOrderedSame){
		[btnOpenLinkedIn setTitle:@"" forState:UIControlStateNormal];// .text = @"";
		[btnOpenLinkedIn setHidden:YES];
		//btnOpenLinkedIn.hidden = YES;
	}
	else {
		[btnOpenLinkedIn setTitle:userlinkedin forState:UIControlStateNormal];		//btnOpenLinkedIn.text = userlinkedin;
		[btnOpenLinkedIn setHidden:NO];
			// .hidden = NO;
		aryLinkedIn = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:userlinkedin, nil]];
	}
	UILabel *lblStatus = [UnsocialAppDelegate createLabelControl:@"Status:" frame:CGRectMake(lbllinkedIn.origin.x, btnOpenLinkedIn.origin.y + 20, btnOpenLinkedIn.frame.size.width + 16, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblStatus];
	
	statusmsg = [UnsocialAppDelegate createTextViewControl:statusmgs frame:CGRectMake(lbllinkedIn.frame.origin.x, lblStatus.frame.origin.y + 16, 300, 60) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:@"Helvetica-BoldOblique" fontsize:kPeopleTableContent returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	statusmsg.contentInset = UIEdgeInsetsMake(-8.00, -8.00, 0.00, 0.00);
	statusmsg.userInteractionEnabled = YES;
	statusmsg.bounces = NO;
	[self.view addSubview:statusmsg];
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, statusmsg.origin.y + 63, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue

	UILabel *lblfunction = [UnsocialAppDelegate createLabelControl:@"Function:" frame:CGRectMake(lblStatus.frame.origin.x, statusmsg.frame.origin.y + 65, 270, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblfunction];
	
	CGRect lablefunctionFrame = CGRectMake(lblStatus.frame.origin.x, lblfunction.frame.origin.y + 16, 270, 15);
	UILabel *lblFunction = [UnsocialAppDelegate createLabelControl:@"" frame:lablefunctionFrame txtAlignment:UITextAlignmentLeft numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	
	if ([userrole compare:@""] == NSOrderedSame)
		lblFunction.text = @"";
	else 
		lblFunction.text = userrole;
	[self.view addSubview:lblFunction];
	
	UILabel *lblwebsite = [UnsocialAppDelegate createLabelControl:@"Website:" frame:CGRectMake(lblfunction.frame.origin.x, lblFunction.frame.origin.y + 20, 270, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblwebsite];
	
	CGRect lableWebsiteFrame = CGRectMake(lblfunction.frame.origin.x, lblwebsite.frame.origin.y + 16, 270, 15);

	UIButton *btnLinks = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnLinks_Click) frame:lableWebsiteFrame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnLinks.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		//[self.view addSubview:btnLinks];
	
		//UILabel *lblLinks = [UnsocialAppDelegate createLabelControl:@"" frame:lableLinkedInFrame txtAlignment:UITextAlignmentLeft numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:btnLinks];
	
	if ([userwebsite compare:@""] == NSOrderedSame)
		[btnLinks setTitle:@"" forState:UIControlStateNormal];
	else {
		
		[btnLinks setTitle:userwebsite forState:UIControlStateNormal];
	}
	
	UILabel *lblSmartTags = [UnsocialAppDelegate createLabelControl:@"Sample Tags: " frame:CGRectMake(lblfunction.frame.origin.x, btnLinks.frame.origin.y + 20, 105, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblSmartTags];
	
	UITextView *tvMetaTags = [UnsocialAppDelegate createTextViewControl:ownerKeywords2 frame:CGRectMake(lblfunction.frame.origin.x, lblSmartTags.frame.origin.y + 16, 300, 30) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:kPeopleTableContent returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	tvMetaTags.userInteractionEnabled = YES;
	[tvMetaTags flashScrollIndicators];
	tvMetaTags.contentInset = UIEdgeInsetsMake(-8, -8, 0, 0);
	
	if([ownerKeywords2 compare:@""] == NSOrderedSame)
		tvMetaTags.text = @"";
	[self.view addSubview:tvMetaTags];
	
	//[heading release];
	// 13 may 2011 by pradeep //[lblSmartTags release];
	// 13 may 2011 by pradeep //[lblwebsite release];
	// 13 may 2011 by pradeep //[lblfunction release];
	// 13 may 2011 by pradeep //[lblindustry release];
	// 13 may 2011 by pradeep //[lblcompany release];
	// 13 may 2011 by pradeep //[lblemail release];
	// 13 may 2011 by pradeep //[lblcontact release];
}

- (void) btnLinks_Click {
	
	// commented added by pradeep on 7 june 2011 for fixing issue when website never set by user and click on blank website app crashes
	//if ([userwebsite isEqualToString:@""]  || !userwebsite)
	// added by pradeep on 7 june 2011
	[self getData2FromFile];
	NSLog(@"%@", userwebsite);
	if(userwebsite == nil || [userwebsite isEqualToString:@""])
		return;
	
	WebViewForWebsites *webViewForWebsites = [[WebViewForWebsites alloc]init];
	webViewForWebsites.webAddress = userwebsite;
	[self.navigationController pushViewController:webViewForWebsites animated:YES];
	[webViewForWebsites release];
}

- (void)btnOpenLinkedIn_Click {
	
	if ([btnOpenLinkedIn.titleLabel.text isEqualToString:@""])
		return;
	
	WebViewForWebsites *webViewForWebsites = [[WebViewForWebsites alloc]init];
	webViewForWebsites.webAddress = btnOpenLinkedIn.titleLabel.text;
	[self.navigationController pushViewController:webViewForWebsites animated:YES];
	[webViewForWebsites release];
}

- (void)btnCallTheNumber_Click {
	
	// commented by pradeep on 24 nov 2010 for disabling calling feature on clicking on phone # since user is viewing their profile 
	// ***** start 24 nov 2010
	/*
	 if([self.usercontact isEqualToString:@""]) {
	 
	 //UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:@"Phone currently not set" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	 //[alertOnChoose show];
	 //[alertOnChoose release];
	 return;
	 }
	 NSLog(@"\nDialing a Number- %@", self.usercontact);
	 UIApplication *app = [UIApplication sharedApplication];
	 NSString *urlString = [NSString stringWithFormat:@"%@", self.usercontact];
	 //NSURL *url = [NSURL URLWithString:urlString];
	 NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel:%@",urlString]];
	 [app openURL:url];
	 // below commented line is also work the same work
	 //[[UIApplication sharedApplication] openURL: url];
	 
	 */
	// ***** end 24 nov 2010

}

- (void) getKeywordsForUser:(NSString *)inid
{
	// Time Formats
	
	NSString *dt = [NSString stringWithFormat:@"%@", [NSDate date]];
	NSLog(@"%@", dt);
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	NSString *urlString;
	urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getkeywords&userid=%@&datetime=%@", [arrayForUserID objectAtIndex:0], usertime];
	urlString = [globalUrlString stringByAppendingString:urlString];
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];
}

- (void)parseXMLFileAtURL:(NSString *)URL {
	stories = [[NSMutableArray alloc] init];
	
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:URL];
	
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[rssParser setDelegate:self];
	
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];	
	[rssParser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down."];
	NSLog(@"error parsing XML: %@", errorString);	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"])
	{
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		keywordName = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		[item setObject:keywordName forKey:@"keywords"]; 
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
		
		NSLog(@"adding story keywordName: %@", keywordName);
		/*[aryKeyword addObject:keywordName];
		 NSLog(@"aryKeyword has %d itmes", [aryKeyword count]);*/
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"keywords"])
	{
		[keywordName appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
}

- (void) getDataFromFile {
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
		username = [[tempArray objectAtIndex:0] username];
		userid = [[tempArray objectAtIndex:0] userid];
		useremail = [[tempArray objectAtIndex:0] useremail];
		userlinkedinmail = [[tempArray objectAtIndex:0] userlinkedinmailid];
		usercontact = [[tempArray objectAtIndex:0] usercontact];
		
		[decoder finishDecoding];
		[decoder release];
	}
}

- (void) getData2FromFile {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial2"];
	
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
		
		usertitle = [[tempArray objectAtIndex:0] usertitle];
		usercompany = [[tempArray objectAtIndex:0] usercompany];
		userwebsite = [[tempArray objectAtIndex:0] userwebsite];
		userind = [[tempArray objectAtIndex:0] userindustry];
		userrole = [[tempArray objectAtIndex:0] userfunction];	
		userlinkedin = [[tempArray objectAtIndex:0] userlinkedin];	
		userid = [[tempArray objectAtIndex:0] userid];
		idOfSelectedInd = [[tempArray objectAtIndex:0] userindid];
		idOfSelectedFunction = [[tempArray objectAtIndex:0] userroleid];
		
		[decoder finishDecoding];
		[decoder release];	
	}
	// added by pradeep on 7 june 2011 for fixing issue when website never set by user and click on blank website app crashes 
	else {
		userwebsite=@"";
	}

}

- (void)getImageFromFile{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"1.png"] retain];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:dataFilePath]) 
	{
		fullImg = [UIImage imageWithContentsOfFile:dataFilePath ];
	}
	else
	{
		fullImg = [UIImage imageNamed:@"imgNoUserImage.png"];
	}
}

- (void) getStatusFromFile {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4UnsocialStatus"];
	
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
		
		statusmgs = [[tempArray objectAtIndex:0] strsetstatus];
		userid = [[tempArray objectAtIndex:0] userid];
		
		[decoder finishDecoding];
		[decoder release];	
	}
}

- (void) getMetaTags {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4metatags"];
	
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
		
		usermetatags = [[tempArray objectAtIndex:0] strsetkeywords];
		userid = [[tempArray objectAtIndex:0] userid];
		
		[decoder finishDecoding];
		[decoder release];	
	}
}

- (void) getPrivacyFromFile {
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
		displayedSecurityItems = [[tempArray objectAtIndex:0] displayedSecurityItems];
		
		[decoder finishDecoding];
		[decoder release];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

-(void)leftbtn_OnClick {
	
	[self.navigationController popViewControllerAnimated:YES];
	[aryContact release];
	[aryLinkedIn release];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
