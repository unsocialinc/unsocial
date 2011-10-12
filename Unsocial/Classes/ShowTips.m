//
//  ShowTips.m
//  unsocial
//
//  Created by vaibhavsaran on 11/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShowTips.h"
#import "UnsocialAppDelegate.h"
#import "InviteUser.h"
#import "GlobalVariables.h"
#import "LinkedInNetworkUpdate.h"
#import "WebViewForWebsites.h"

int cnt4tips;

@implementation ShowTips

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
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;
	
	UIImageView *imgTipsBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, 320, 224)];
	imgTipsBackgrnd.image = [UIImage imageNamed:@"tipsback.png"];
	[self.view addSubview:imgTipsBackgrnd];
	/*
	UIImageView *imgTipsBackgrnd2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 275, 320, 135)];
	imgTipsBackgrnd2.image = [UIImage imageNamed:@"tipsback2.png"];
	[self.view addSubview:imgTipsBackgrnd2];
	
	UIImageView *imgTipsHor = [[UIImageView alloc]initWithFrame:CGRectMake(50, 302, 225, 2)];
	imgTipsHor.image = [UIImage imageNamed:@"dashboardhorizontal.png"];
	[self.view addSubview:imgTipsHor];
	
	tip8 = @"You can easily invite friends and family to join unsocial";
	
	UILabel *lblTipsInv = [UnsocialAppDelegate createLabelControl:@"Invite Friends" frame:CGRectMake(40, 280, 255, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:13 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblTipsInv];

	UITextView *tipsInvite = [UnsocialAppDelegate createTextViewControl:tip8 frame:CGRectMake(42, 300, 240, 90) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:12 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	tipsInvite.showsVerticalScrollIndicator = YES;
	tipsInvite.scrollsToTop = YES;
	tipsInvite.contentInset = UIEdgeInsetsMake(-4, -8, 0, 0);
	[self.view addSubview:tipsInvite];
	*/
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Tips" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	/*
	btnInvite = [UnsocialAppDelegate createButtonControl:@"Invite Someone" target:self selector:@selector(btnInvite_Onclick) frame:CGRectMake(110, 370, 105, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnInvite.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	[self.view addSubview:btnInvite];
	*/
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	[imgBackgrnd release];
	[imgTipsBackgrnd release];
}

- (void)viewDidAppear:(BOOL)animated {

	[activityView stopAnimating];
	
	tip1 = @"...even after closing the application your profile remains active for four hours? However, by logging in at a different location your profile will be exposed to a whole new range of people.";//, earning you even more unsocial miles.";
	
	tip2 = @"...you can view everyone attending a specific event by simply clicking on “Attendee List” on the events page.";
	
	tip3 = @"...a detailed profile improves someone’s chances of finding you. Just click on “My Metatags” in the profile section to add keywords such as MBA, graphics designer, etc. More tags mean a better probability of being found. Don’t sell yourself short!";
	
	tip4 = @"...you can find someone you are looking for by tagging an interest. Simply click the “Add Keywords” button in the “TAGGED” section. Looking for an iPhone developer? Enter key phrases like iPhone, IPhone developer, etc. On your next visit the application will automatically select people who had described themselves in this way.";
	
	tip5 = @"...adding an event you are attending or organizing is only a click away. Just go to our website at unsocial.mobi.";
	/*
	tip6 = @"...you can create your very own digital billboard.  It’s as easy as sending your digital billboard’s URL to our email at media@unsocial.mobi.  If you’ve used your email id that is registered with us we will add your billboard or video to your profile automatically.  Try it!";*/
	
	if(!arrayAllTips) {
		
		arrayAllTips = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects: tip1, tip2, tip3, tip4, tip5, nil]];
	}		
		
	/*UIButton *btnCloseTips = [UnsocialAppDelegate  createButtonControl:@"" target:self selector:@selector(btnCloseTips_Click) frame:CGRectMake(240, 58, 70, 30) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor blackColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnCloseTips.showsTouchWhenHighlighted = YES;
	[btnCloseTips.titleLabel setFont:[UIFont fontWithName:kAppFontName size:13]];
	[self.view addSubview:btnCloseTips];*/

	if(!lblTips) {
		
		lblTips = [UnsocialAppDelegate createLabelControl:@"Did you know..." frame:CGRectMake(40, 100, 255, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:13 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	}
	[self.view addSubview:lblTips];
	
	if(!tips) {
		
	tips = [UnsocialAppDelegate createTextViewControl:[arrayAllTips objectAtIndex:0] frame:CGRectMake(42, 125, 240, 125) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:12 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
		tips.showsVerticalScrollIndicator = YES;
		tips.scrollsToTop = YES;
		tips.contentInset = UIEdgeInsetsMake(-4, -8, 0, 0);
	}
	[self.view addSubview:tips];
	
	// btnmiles is not in use
	btnMiles = [UnsocialAppDelegate createButtonControl:@"unsocial Miles" target:self selector:@selector(btnMiles_Onclick) frame:CGRectMake(110, 260, 105, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnMiles.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	btnMiles.hidden = YES;
		//[self.view addSubview:btnMiles];
	
	if (!btnEvents)
	{
	btnEvents = [UnsocialAppDelegate createButtonControl:@"Events" target:self selector:@selector(btnEvents_Onclick) frame:CGRectMake(110, 260, 105, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnEvents.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	btnEvents.hidden = YES;
	}
	[self.view addSubview:btnEvents];
	
	if (!btnMetaTags)
	{
	btnMetaTags = [UnsocialAppDelegate createButtonControl:@"My Metatags" target:self selector:@selector(btnMetaTags_Onclick) frame:CGRectMake(110, 260, 105, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnMetaTags.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	btnMetaTags.hidden = YES;
	}
	[self.view addSubview:btnMetaTags];
	
	if (!btnPeople)
	{
	btnPeople = [UnsocialAppDelegate createButtonControl:@"Tagged" target:self selector:@selector(btnPeople_Onclick) frame:CGRectMake(110, 260, 105, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnPeople.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	btnPeople.hidden = YES;
	}
	[self.view addSubview:btnPeople];
	
	if (!btnWebsite)
	{
	btnWebsite = [UnsocialAppDelegate createButtonControl:@"Go to Website" target:self selector:@selector(btnWebsite_Onclick) frame:CGRectMake(110, 260, 105, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnWebsite.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	btnWebsite.hidden = YES;
	}
	[self.view addSubview:btnWebsite];
	
	
	/*btnBillBoard = [UnsocialAppDelegate createButtonControl:@"unsocial Tile" target:self selector:@selector(btnBillBoard_Onclick) frame:CGRectMake(110, 260-40, 105, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnBillBoard.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	btnBillBoard.hidden = YES;
	[self.view addSubview:btnBillBoard];*/
	
	btnPrevTips = [UnsocialAppDelegate  createButtonControl:@"" target:self selector:@selector(btnPrevTips_Click) frame:CGRectMake(10, 160, 30, 50) imageStateNormal:@"tipsleft1.png" imageStateHighlighted:@"tipsleft2.png" TextColorNormal:[UIColor blackColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnPrevTips];
	
	btnNextTips = [UnsocialAppDelegate  createButtonControl:@"" target:self selector:@selector(btnNextTips_Click) frame:CGRectMake(280, btnPrevTips.frame.origin.y, btnPrevTips.frame.size.width, btnPrevTips.frame.size.height) imageStateNormal:@"tipsright1.png" imageStateHighlighted:@"tipsright2.png" TextColorNormal:[UIColor blackColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnNextTips];
}

- (void) btnNextTips_Click {

	[UnsocialAppDelegate playClick];
	if([tips.text compare:[arrayAllTips objectAtIndex:0]] == NSOrderedSame) {
		
		btnBillBoard.hidden = YES;
		btnWebsite.hidden = YES;
		btnMiles.hidden = YES;
		btnEvents.hidden = NO;
		btnMetaTags.hidden = YES;
		btnPeople.hidden = YES;
			//lblTips.text = @"Tip# 2";//blank
		tips.text = [arrayAllTips objectAtIndex:1];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:1]] == NSOrderedSame) {
		
		btnBillBoard.hidden = YES;
		btnWebsite.hidden = YES;
		btnMiles.hidden = YES;
		btnEvents.hidden = YES;
		btnPeople.hidden = YES;
		btnMetaTags.hidden = NO;
			//lblTips.text = @"Tip# 3";// event
		tips.text = [arrayAllTips objectAtIndex:2];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:2]] == NSOrderedSame) {
		
		btnWebsite.hidden = YES;
		btnPeople.hidden = NO;
		btnBillBoard.hidden = YES;
		btnMetaTags.hidden = YES;
		btnMiles.hidden = YES;
		btnEvents.hidden = YES;
			//lblTips.text = @"Tip# 4";// metatags
		tips.text = [arrayAllTips objectAtIndex:3];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:3]] == NSOrderedSame) {
		
		btnWebsite.hidden = NO;
		btnPeople.hidden = YES;
		btnMetaTags.hidden = YES;
		btnBillBoard.hidden = YES;
		btnMiles.hidden = YES;
		btnEvents.hidden = YES;
			//lblTips.text = @"Tip# 5";// people
		tips.text = [arrayAllTips objectAtIndex:4];
	}
	/*else if([tips.text compare:[arrayAllTips objectAtIndex:4]] == NSOrderedSame) {
		
		btnWebsite.hidden = YES;
		btnMetaTags.hidden = YES;
		btnPeople.hidden = YES;
		btnBillBoard.hidden = NO;
		btnMiles.hidden = YES;
		btnEvents.hidden = YES;
			//lblTips.text = @"Tip# 6";// website
		tips.text = [arrayAllTips objectAtIndex:5];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:5]] == NSOrderedSame) {
		
		btnWebsite.hidden = YES;
		btnPeople.hidden = YES;
		btnMetaTags.hidden = YES;
		btnBillBoard.hidden = NO;
		btnMiles.hidden = YES;
		btnEvents.hidden = YES;
		//lblTips.text = @"Tip# 7";// billboard
		tips.text = [arrayAllTips objectAtIndex:6];
	}*/
	else if([tips.text compare:[arrayAllTips objectAtIndex:4]] == NSOrderedSame) {
		
		btnWebsite.hidden = YES;
		btnPeople.hidden = YES;
		btnMetaTags.hidden = YES;
		btnMiles.hidden = YES;
		btnBillBoard.hidden = YES;
		btnEvents.hidden = YES;
			//lblTips.text = @"Tip# 1";// Miles
		tips.text = [arrayAllTips objectAtIndex:0];
	}
	/*else if([tips.text compare:[arrayAllTips objectAtIndex:7]] == NSOrderedSame) {
		
		btnMetaTags.hidden = YES;
		btnWebsite.hidden = YES;
		btnPeople.hidden = YES;
		btnEvents.hidden = YES;
		btnBillBoard.hidden = YES;
		//btnInvite.hidden = YES;
		btnMiles.hidden = NO;
		//lblTips.text = @"Tip# 1";
		tips.text = [arrayAllTips objectAtIndex:0];
	}*/
	[tips flashScrollIndicators];
}

- (void) btnPrevTips_Click
{
	
	[UnsocialAppDelegate playClick];
	if([tips.text compare:[arrayAllTips objectAtIndex:0]] == NSOrderedSame) {
		
		btnWebsite.hidden = NO;
		btnMetaTags.hidden = YES;
		btnBillBoard.hidden = YES;
		btnPeople.hidden = YES;
		btnEvents.hidden = YES;
		btnMiles.hidden = YES;
			//lblTips.text = @"Tip# 7";// billboard
		tips.text = [arrayAllTips objectAtIndex:4];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:1]] == NSOrderedSame) {
		
		btnWebsite.hidden = YES;
		btnPeople.hidden = YES;
		btnMetaTags.hidden = YES;
		btnMiles.hidden = YES;
		btnBillBoard.hidden = YES;
		btnEvents.hidden = YES;
			//lblTips.text = @"Tip# 1";// Miles
		tips.text = [arrayAllTips objectAtIndex:0];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:2]] == NSOrderedSame) {
		
		btnBillBoard.hidden = YES;
		btnWebsite.hidden = YES;
		btnMiles.hidden = YES;
		btnEvents.hidden = NO;
		btnMetaTags.hidden = YES;
		btnPeople.hidden = YES;
			//lblTips.text = @"Tip# 2";//blank
		tips.text = [arrayAllTips objectAtIndex:1];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:3]] == NSOrderedSame) {
		
		btnBillBoard.hidden = YES;
		btnWebsite.hidden = YES;
		btnMiles.hidden = YES;
		btnEvents.hidden = YES;
		btnPeople.hidden = YES;
		btnMetaTags.hidden = NO;
			//lblTips.text = @"Tip# 3";// event
		tips.text = [arrayAllTips objectAtIndex:2];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:4]] == NSOrderedSame) {
		
		btnWebsite.hidden = YES;
		btnPeople.hidden = NO;
		btnBillBoard.hidden = YES;
		btnMetaTags.hidden = YES;
		btnMiles.hidden = YES;
		btnEvents.hidden = YES;
			//lblTips.text = @"Tip# 4";// metatags
		tips.text = [arrayAllTips objectAtIndex:3];
	}
	/*else if([tips.text compare:[arrayAllTips objectAtIndex:5]] == NSOrderedSame) {
		
		btnWebsite.hidden = NO;
		btnPeople.hidden = YES;
		btnMetaTags.hidden = YES;
		btnBillBoard.hidden = YES;
		btnMiles.hidden = YES;
		btnEvents.hidden = YES;
			//lblTips.text = @"Tip# 5";// people
		tips.text = [arrayAllTips objectAtIndex:4];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:6]] == NSOrderedSame) {
		
		btnWebsite.hidden = YES;
		btnMetaTags.hidden = YES;
		btnPeople.hidden = YES;
		btnBillBoard.hidden = NO;
		btnMiles.hidden = YES;
		btnEvents.hidden = YES;
			//lblTips.text = @"Tip# 6";// website
		tips.text = [arrayAllTips objectAtIndex:5];
	}
	else if([tips.text compare:[arrayAllTips objectAtIndex:7]] == NSOrderedSame) {
		
		btnWebsite.hidden = YES;
		btnMetaTags.hidden = YES;
		btnBillBoard.hidden = NO;
		btnPeople.hidden = YES;
		btnEvents.hidden = YES;
		//btnInvite.hidden = YES;
		btnMiles.hidden = YES;
		//lblTips.text = @"Tip# 7";
		tips.text = [arrayAllTips objectAtIndex:6];
	}*/
	[tips flashScrollIndicators];
}	

- (void)leftbtn_OnClick {
	
	[self dismissModalViewControllerAnimated:YES];
}

-(void)btnWebsite_Onclick {
	
	[UnsocialAppDelegate playClick];
	WebViewForWebsites *webViewController = [[WebViewForWebsites alloc]init];
	webViewController.webAddress = @"www.unsocial.mobi";
	[self.navigationController pushViewController:webViewController animated:YES];
	[webViewController release];
		//[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"http://www.unsocial.mobi"]];
}

-(void)btnPeople_Onclick {
	
	[UnsocialAppDelegate playClick];
	PeopleAutoTagged *viewcontroller = [[PeopleAutoTagged alloc] init];
	viewcontroller.comingfrom = 1;
	[self.navigationController pushViewController:viewcontroller animated:YES];
	[viewcontroller release];
}

-(void)btnEvents_Onclick {
	
	[UnsocialAppDelegate playClick];
	Events *viewcontroller = [[Events alloc] init];
	viewcontroller.comingfrom = 1;
	[self.navigationController pushViewController:viewcontroller animated:YES];
	[viewcontroller release];
}

-(void)btnMiles_Onclick {
	
	[UnsocialAppDelegate playClick];
	MilesOptions *viewcontroller = [[MilesOptions alloc] init];
	viewcontroller.comingfrom = 1;
	[self.navigationController pushViewController:viewcontroller animated:YES];
	[viewcontroller release];
}

-(void)btnBillBoard_Onclick {
		
	[UnsocialAppDelegate playClick];
	SettingsStep5 *viewcontroller = [[SettingsStep5 alloc] init];
	viewcontroller.comingfrom = 1;
	[self.navigationController pushViewController:viewcontroller animated:YES];
	[viewcontroller release];
}

- (void)btnMetaTags_Onclick {
	
	[UnsocialAppDelegate playClick];
	SettingsAddKeywords *viewcontroller = [[SettingsAddKeywords alloc] init];
	[self.navigationController pushViewController:viewcontroller animated:YES];
	//commented by pradeep on 7 june 2011 since if user is in airplane mode and click on "My Metatag" then it opens and automatically bcaked and prompt sync error msg and as soon as user clicked on "OK" app crashes
	//[viewcontroller release];
}

- (void) btnInvite_Onclick {
	
	[UnsocialAppDelegate playClick];
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Invite via email", @"Invite via LinkedIn", @"Cancel",  nil];
	actionSheet.destructiveButtonIndex = 2;
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	// show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(buttonIndex == 0) {
		
		InviteUser *viewcontroller = [[InviteUser alloc] init];
		[self.navigationController pushViewController:viewcontroller animated:YES];
		[viewcontroller release];
	}
	else if (buttonIndex == 1) {
	
		LinkedInNetworkUpdate *linkedInNetworkUpdate = [[LinkedInNetworkUpdate alloc]init];
		[self.navigationController pushViewController:linkedInNetworkUpdate animated:YES];
		[linkedInNetworkUpdate release];
	}
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
	[tips release];
}


@end
