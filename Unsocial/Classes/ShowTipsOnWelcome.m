//
//  ShowTips.m
//  unsocial
//
//  Created by vaibhavsaran on 11/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShowTipsOnWelcome.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"

@implementation ShowTipsOnWelcome
@synthesize tip1, tip2, tip3, tip4, tip5, tip6, tip7, tip8, tip9;

- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"VC view will appear");
	
	UIImageView *imgBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBackgrnd.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBackgrnd];
	
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];	
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	[imgBackgrnd release];
}

- (void)viewDidAppear:(BOOL)animated {

	[activityView stopAnimating];
	
	/*tip1 = @"...earning unsocial miles can help you to stand out? Ensure being seen by using miles to spruce up your profile.  To learn more about earning miles please click on the “unsocial miles” icon via the spring board.";*/
	
	tip1 = @"...even after closing the application your profile remains active for four hours? However, by logging in at a different location your profile will be exposed to a whole new range of people.";//, earning you even more unsocial miles.";
	
	tip2 = @"...you can view everyone attending a specific event by simply clicking on “Attendee List” on the events page.";
	
	tip3 = @"...a detailed profile improves someone’s chances of finding you. Just click on “My Metatags” in the profile section to add keywords such as MBA, graphics designer, etc. More tags mean a better probability of being found. Don’t sell yourself short!";
	
	tip4 = @"...you can find someone you are looking for by tagging an interest. Simply click the “Add Keywords” button in the “TAGGED” section. Looking for an iPhone developer? Enter key phrases like iPhone, IPhone developer, etc. On your next visit the application will automatically select people who had described themselves in this way.";
	
	tip5 = @"...adding an event you are attending or organizing is only a click away. Just go to our website at unsocial.mobi.";
	
	/*tip6 = @"...you can create your very own digital billboard.  It’s as easy as sending your digital billboard’s URL to our email at media@unsocial.mobi.  If you’ve used your email id that is registered with us we will add your billboard or video to your profile automatically.  Try it!";*/
	
	tip7 = @"...you can invite family and friends to join unsocial.";// Inviting is easy and you receive 200 miles for each valid person you invite.";
	/*
	tip9 = @"...unsocial miles work similarly to airline miles?  The distance of your new login area from your home location is how many miles you earn!";*/
	
	imgProfileBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 320, 359)];
	imgProfileBack.image = [UIImage imageNamed:@"peopleprofileback.png"];
	[self.view addSubview:imgProfileBack];
	[imgProfileBack release];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//heading = [UnsocialAppDelegate createLabelControl:@"Learn More" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	heading = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Learn More" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//heading2 = [UnsocialAppDelegate createLabelControl:@"unsocial version 1.8" frame:CGRectMake(15, 450, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	heading2 = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"unsocial version 1.8" frame:CGRectMake(15, 450, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	[self.view addSubview:heading2];
	// 13 may 2011 by pradeep //[heading2 release];
	
	learnMore = [UnsocialAppDelegate createTextViewControl:@"unsocial is a mobile application that will empower you with its proximity based search engine and improve your awareness of the professionals around you, all the while helping you become a vital part of the business community.\n\nunsocial works by using an intelligent tagging system which not only exposes your profile to others but enables you to instantly search for noteworthy business opportunities and events. Whether you enjoy business on the go or in your own neighborhood, unsocial will be there for all of your business networking needs. Please take the time to explore our proximity based features such as \"people around you\" and \"events around you\". We also encourage you to update your personal profile. The more detailed you are the easier it is for someone to find you!\n\nCheck out our tips section and learn how to utilize unsocial to benefit your business." frame:CGRectMake(10, 30, 300, 300) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:13 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeAlphabet scrollEnabled:YES editable:NO];
	[learnMore flashScrollIndicators];
	[self.view addSubview:learnMore];
	
	btnTips = [UnsocialAppDelegate createButtonControl:@"Tips" target:self selector:@selector(btnTips_Click) frame:CGRectMake(128, 380, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnTips];

	if(!arrayAllTips) {
		
		arrayAllTips = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects: tip1, tip2, tip3, tip4, tip5, tip7, nil]];//, tip8, tip9, nil]];
	}
	
	imgTipsBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80 + 400, 320, 250)];
	imgTipsBackgrnd.image = [UIImage imageNamed:@"tipsback2.png"];

	if(!lblTips) {
		
		// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
		//lblTips = [UnsocialAppDelegate createLabelControl:@"Did you know..." frame:CGRectMake(40, 90 + 400, 255, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:13 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		lblTips = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Did you know..." frame:CGRectMake(40, 90 + 400, 255, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:13 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		// end 17 august 2011
	}
	
	imgTipsHor = [[UIImageView alloc]initWithFrame:CGRectMake(50, 115 + 400, 225, 2)];
	imgTipsHor.image = [UIImage imageNamed:@"dashboardhorizontal.png"];

	if(!tips) {
		
		// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
		//tips = [UnsocialAppDelegate createLabelControl:[arrayAllTips objectAtIndex:0] frame:CGRectMake(45, 90 + 400, 240, 225) txtAlignment:UITextAlignmentLeft numberoflines:20 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		tips = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:[arrayAllTips objectAtIndex:0] frame:CGRectMake(45, 90 + 400, 240, 225) txtAlignment:UITextAlignmentLeft numberoflines:20 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		// end 17 august 2011
	}
	
	btnPrevTips = [UnsocialAppDelegate  createButtonControl:@"" target:self selector:@selector(btnPrevTips_Click) frame:CGRectMake(10, 175 + 400, 30, 50) imageStateNormal:@"tipsleft1.png" imageStateHighlighted:@"tipsleft2.png" TextColorNormal:[UIColor blackColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	
	btnNextTips = [UnsocialAppDelegate  createButtonControl:@"" target:self selector:@selector(btnNextTips_Click) frame:CGRectMake(280, btnPrevTips.frame.origin.y + 400, btnPrevTips.frame.size.width, btnPrevTips.frame.size.height) imageStateNormal:@"tipsright1.png" imageStateHighlighted:@"tipsright2.png" TextColorNormal:[UIColor blackColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];

	[self.view addSubview:imgTipsBackgrnd];
	[self.view addSubview:lblTips];
	[self.view addSubview:imgTipsHor];
	[self.view addSubview:tips];
	[self.view addSubview:btnPrevTips];
	[self.view addSubview:btnNextTips];
}

- (void)btnTips_Click {

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:1];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	learnMore.frame = CGRectMake(learnMore.frame.origin.x, learnMore.frame.origin.y - 450, learnMore.frame.size.width, learnMore.frame.size.height);
	
	imgProfileBack.frame = CGRectMake(imgProfileBack.frame.origin.x, imgProfileBack.frame.origin.y - 450, imgProfileBack.frame.size.width, imgProfileBack.frame.size.height);
	
	btnTips.frame = CGRectMake(btnTips.frame.origin.x, btnTips.frame.origin.y - 450, btnTips.frame.size.width, btnTips.frame.size.height);
	
	heading.frame = CGRectMake(heading.frame.origin.x, heading.frame.origin.y - 450, heading.frame.size.width, heading.frame.size.height);

	
	heading2.frame = CGRectMake(heading2.frame.origin.x, heading2.frame.origin.y - 450, heading2.frame.size.width, heading2.frame.size.height);
	btnPrevTips.frame = CGRectMake(10, 175, 30, 50);
	btnNextTips.frame = CGRectMake(280, 175, 30, 50);
	lblTips.frame = CGRectMake(40, 90, 255, 20);
	imgTipsBackgrnd.frame = CGRectMake(0, 80, 320, 250);
	imgTipsHor.frame = CGRectMake(50, 115, 225, 2);
	tips.frame = CGRectMake(45, 90, 240, 225);
	
	[UIView commitAnimations];
}

- (void) btnNextTips_Click {

	[UnsocialAppDelegate playClick];
	if([tips.text compare:[arrayAllTips objectAtIndex:0]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 2";
		tips.text = [arrayAllTips objectAtIndex:1];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:1]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 3";
		tips.text = [arrayAllTips objectAtIndex:2];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:2]] == NSOrderedSame) {

			//lblTips.text = @"Tip# 4";
		tips.text = [arrayAllTips objectAtIndex:3];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:3]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 5";
		tips.text = [arrayAllTips objectAtIndex:4];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:4]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 6";
		tips.text = [arrayAllTips objectAtIndex:5];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:5]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 7";
		tips.text = [arrayAllTips objectAtIndex:0];
	}
	/*else if([tips.text compare:[arrayAllTips objectAtIndex:6]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 8";
		tips.text = [arrayAllTips objectAtIndex:0];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:7]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 8";
		tips.text = [arrayAllTips objectAtIndex:8];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:8]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 1";
		tips.text = [arrayAllTips objectAtIndex:0];
	}*/
}

- (void) btnPrevTips_Click {
	
	[UnsocialAppDelegate playClick];
	if([tips.text compare:[arrayAllTips objectAtIndex:0]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 8";
		tips.text = [arrayAllTips objectAtIndex:5];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:1]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 1";
		tips.text = [arrayAllTips objectAtIndex:0];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:2]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 2";
		tips.text = [arrayAllTips objectAtIndex:1];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:3]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 3";
		tips.text = [arrayAllTips objectAtIndex:2];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:4]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 4";
		tips.text = [arrayAllTips objectAtIndex:3];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:5]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 5";
		tips.text = [arrayAllTips objectAtIndex:4];
	}
	/*else if([tips.text compare:[arrayAllTips objectAtIndex:6]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 6";
		tips.text = [arrayAllTips objectAtIndex:5];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:7]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 7";
		tips.text = [arrayAllTips objectAtIndex:6];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:8]] == NSOrderedSame) {
		
			//lblTips.text = @"Tip# 7";
		tips.text = [arrayAllTips objectAtIndex:7];
	}*/
}	

- (void)leftbtn_OnClick {
	
	// added by pradeep on 7 august 2010
	[lastVisitedFeature removeAllObjects];
	[lastVisitedFeature addObject:@"welcome"];
	[self.navigationController popViewControllerAnimated:YES];
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
	
    [super dealloc];
	[imgTipsBackgrnd release];
	// 13 may 2011 by pradeep //[lblTips release];
	[imgTipsHor release];
	// 13 may 2011 by pradeep //[tips release];
	[btnPrevTips release];
	[btnNextTips release];
}


@end
