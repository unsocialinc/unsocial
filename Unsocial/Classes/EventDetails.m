//
//  EventDetails.m
//  Unsocial
//
//  Created by vaibhavsaran on 28/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventDetails.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"
#import "EventIntendedUsers.h"
#import "SponsoredEventFeatures.h"
#import "SponsoredEventFeaturesLauncherView.h"
#import "ShareEvent.h"
#import "EventMap.h"
#import "WebViewForWebsites.h"

NSString *alreadybookmark;

@implementation EventDetails
@synthesize strEventTopic, strEventWhen, strEventWhere, strEventSuggst, strEventDecscrip;
@synthesize eventid, eventname, eventdesc, eventaddress, eventindustry, eventdate, fromtime, totime, eventcontact, eventwebsite, isrecurring, eventcurrentdistance, fromwhichsegment;
@synthesize comingfrom, eventImage, liveNow, eventtype, calendarselectedindex;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(createControls) userInfo:self.view repeats:NO];
//	[self createControls];
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
	
	UIImageView *imgProfileBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgProfileBack.image = [UIImage imageNamed:@"eventback.png"];
	[self.view addSubview:imgProfileBack];
	
	imgProfileBack = [[UIImageView alloc]initWithFrame:CGRectMake(15, 60, 290, 2)];
	imgProfileBack.image = [UIImage imageNamed:@"dashboardhorizontal.png"];
	[self.view addSubview:imgProfileBack];
	
	if([[aryEventDetails objectAtIndex:13]  intValue] != 1) {
		
		UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
		[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
		[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
		self.navigationItem.leftBarButtonItem = leftcbtnitme;
	}
	else {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	}
	
	lblReletedto = [UnsocialAppDelegate createLabelControl:@"Industry:" frame:CGRectMake(90, 68, 110, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblReletedto];
	
	lblOn = [UnsocialAppDelegate createLabelControl:@"Date:" frame:CGRectMake(90, lblReletedto.frame.origin.y + 18, 110, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblOn];
	
		//event to Date added by pradeep on 18 oct 2010
	lblToForDt = [UnsocialAppDelegate createLabelControl:@"To:" frame:CGRectMake(185, lblOn.frame.origin.y, 20, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblToForDt];
	
	lblFrom = [UnsocialAppDelegate createLabelControl:@"From:" frame:CGRectMake(90, lblOn.frame.origin.y + 18, 110, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblFrom];
	
	lblTo = [UnsocialAppDelegate createLabelControl:@"To:" frame:CGRectMake(185, lblOn.frame.origin.y + 18, 110, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblTo];
	
	lblPhone = [UnsocialAppDelegate createLabelControl:@"Phone#:" frame:CGRectMake(90, lblTo.frame.origin.y + 18, 110, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblPhone];
	
	lblPlace = [UnsocialAppDelegate createLabelControl:@"Place:" frame:CGRectMake(90, lblPhone.frame.origin.y + 18, 110, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblPlace];
	
	lblWebsite = [UnsocialAppDelegate createLabelControl:@"Website:" frame:CGRectMake(15, 180, 110, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblWebsite];
	
	lblDescription = [UnsocialAppDelegate createLabelControl:@"Description:" frame:CGRectMake(15, 235, 110, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblDescription];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 190, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {
	
	//if([aryEventDetails count] > 18) {	
	if([[aryEventDetails objectAtIndex:13]  intValue] == 1) // coming from event list
	{
		
		// comment on 26 Aug 2010 by Pradeep for lazy img implementation
		/*UIImage *fullImg = [aryEventDetails objectAtIndex:17];	
		CGImageRef realImage = fullImg.CGImage;
		float realHeight = CGImageGetHeight(realImage);
		float realWidth = CGImageGetWidth(realImage);
		float ratio = realHeight/realWidth;
		float modifiedWidth, modifiedHeight;
		if(ratio >= 1) {
			
			modifiedWidth = 75/ratio;
			modifiedHeight = 75;
		}
		else {
			
			modifiedWidth = 75;
			modifiedHeight = ratio*75;
		}
		
		UIImageView *eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, lblReletedto.frame.origin.y, modifiedWidth, modifiedHeight)];
		eventImageView.image = [aryEventDetails objectAtIndex:17];
		
		// Get the Layer of any view
		CALayer * l = [eventImageView layer];
		[l setMasksToBounds:YES];
		[l setCornerRadius:10.0];
		
		// You can even add a border
		[l setBorderWidth:1.0];
		[l setBorderColor:[[UIColor blackColor] CGColor]];
		[self.view addSubview:eventImageView];
		[eventImageView release];		*/ // comment on 25 Aug 2010 by Pradeep for lazy img implementation
		
		//************************** // code added on 25 Aug 2010 by Pradeep for lazy img implementation
		WhereIam = 5;
		CGRect frame;
		frame.size.width=75; frame.size.height=75;
		frame.origin.x=10; frame.origin.y=lblReletedto.frame.origin.y;
		asyncImage = [[[AsyncImageView alloc]
					   initWithFrame:frame] autorelease];
		asyncImage.tag = 999;
		//NSURL*url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
		NSURL*url = [NSURL URLWithString:[aryEventDetails objectAtIndex:17]];
		[asyncImage loadImageFromURL:url];
		asyncImage.backgroundColor = [UIColor clearColor];
		//[cell.contentView addSubview:asyncImage];
		
		// Get the Layer of any view
		CALayer * l = [asyncImage layer];
		[l setMasksToBounds:YES];
		[l setCornerRadius:10.0];
		
		// You can even add a border
		[l setBorderWidth:1.0];
		[l setBorderColor:[[UIColor blackColor] CGColor]];
		[self.view addSubview:asyncImage];
		
		//************************** // code added on 25 Aug 2010 by Pradeep for lazy img implementation
	}
	// added else condition after implementing lazy img feature and checking that if user come in eventdetail from spring board or event list on 26 aug 2010 by pradeep
	else { // coming from spring board
		UIImage *fullImg = [aryEventDetails objectAtIndex:17];	
		 CGImageRef realImage = fullImg.CGImage;
		 float realHeight = CGImageGetHeight(realImage);
		 float realWidth = CGImageGetWidth(realImage);
		 float ratio = realHeight/realWidth;
		 float modifiedWidth, modifiedHeight;
		 if(ratio >= 1) {
		 
		 modifiedWidth = 75/ratio;
		 modifiedHeight = 75;
		 }
		 else {
		 
		 modifiedWidth = 75;
		 modifiedHeight = ratio*75;
		 }
		 
		 UIImageView *eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, lblReletedto.frame.origin.y, modifiedWidth, modifiedHeight)];
		 eventImageView.image = [aryEventDetails objectAtIndex:17];
		 
		 // Get the Layer of any view
		 CALayer * l = [eventImageView layer];
		 [l setMasksToBounds:YES];
		 [l setCornerRadius:10.0];
		 
		 // You can even add a border
		 [l setBorderWidth:1.0];
		 [l setBorderColor:[[UIColor blackColor] CGColor]];
		 [self.view addSubview:eventImageView];
		 [eventImageView release];
	}

	
	// heading
	eventTopic = [UnsocialAppDelegate createTextViewControl:[aryEventDetails objectAtIndex:1] frame:CGRectMake(15, 8, 290, 52) txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:13 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	eventTopic.contentInset = UIEdgeInsetsMake(-4.00, -8.00, 0.00, 0.00);
	[self.view addSubview:eventTopic];
	
	//event Date
	eventWhen = [UnsocialAppDelegate createLabelControl:[aryEventDetails objectAtIndex:5] frame:CGRectMake(123, lblOn.frame.origin.y, 70, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:eventWhen];
	
	//event to Date added by pradeep on 18 oct 2010
	//totime
	NSString *evttodate = [aryEventDetails objectAtIndex:18];
	if ([[aryEventDetails objectAtIndex:2] isEqualToString:@"meetup"]) {
		evttodate = @"NA";
	}
	eventWhen = [UnsocialAppDelegate createLabelControl:evttodate frame:CGRectMake(205, lblOn.frame.origin.y, 70, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:eventWhen];
	
	//fromtime
	eventWhen = [UnsocialAppDelegate createLabelControl:[aryEventDetails objectAtIndex:6] frame:CGRectMake(125, lblFrom.frame.origin.y, 100, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:eventWhen];
	
	//totime
	NSString *evttotime = [aryEventDetails objectAtIndex:7];
	if ([[aryEventDetails objectAtIndex:2] isEqualToString:@"meetup"]) {
		evttotime = @"NA";
	}
	eventWhen = [UnsocialAppDelegate createLabelControl:evttotime frame:CGRectMake(205, lblFrom.frame.origin.y, 100, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:eventWhen];
	
	//eventRelated
	eventWhen = [UnsocialAppDelegate createLabelControl:[aryEventDetails objectAtIndex:4] frame:CGRectMake(150, lblReletedto.frame.origin.y, 180, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:eventWhen];	
	
	//eventcontact #
	eventWhen = [UnsocialAppDelegate createLabelControl:[aryEventDetails objectAtIndex:8] frame:CGRectMake(140, lblPhone.frame.origin.y, 180, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	if ([[aryEventDetails objectAtIndex:8] isEqualToString:@""])
		eventWhen.text = @"Not available";
	[self.view addSubview:eventWhen];
	
	//eventaddress
	tvEventWhere = [UnsocialAppDelegate createTextViewControl:@"nil" frame:CGRectMake(130, lblPlace.frame.origin.y, 180, 60) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:12 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	tvEventWhere.contentInset = UIEdgeInsetsMake(-8.00, -8.00, 0.00, 0.00);
	
	if([[aryEventDetails objectAtIndex:3] isEqualToString:@""])
		tvEventWhere.text = @"Not available";
	else tvEventWhere.text = [aryEventDetails objectAtIndex:3];
	[self.view addSubview:tvEventWhere];
	
	/*tvEventWebsite = [UnsocialAppDelegate createTextViewControl:@"" frame:CGRectMake(15, lblWebsite.frame.origin.y+15, 290, 60) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:12 returnKeyType:UIReturnKeyDefault keyboardType:UIReturnKeyDefault scrollEnabled:YES editable:NO];
	tvEventWebsite.contentInset = UIEdgeInsetsMake(-8.00, -8.00, 0.00, 0.00);*/

	btntvEventWebsite = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btntvEventWebsite_Click) frame:CGRectMake(15, lblWebsite.frame.origin.y+15, 290, 60) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btntvEventWebsite.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	btntvEventWebsite.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
	btntvEventWebsite.titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
	btntvEventWebsite.titleLabel.numberOfLines = 2;
	
	[self.view addSubview:btntvEventWebsite];
	
	if ([[aryEventDetails objectAtIndex:9] isEqualToString:@""]) {
		
		[btntvEventWebsite setTitle:@"Not Available" forState:UIControlStateNormal];
	}
	else {
		
		[btntvEventWebsite setTitle:[aryEventDetails objectAtIndex:9] forState:UIControlStateNormal];
	}
	
	NSString *evtdesc = [aryEventDetails objectAtIndex:2];
	if ([[aryEventDetails objectAtIndex:2] isEqualToString:@"eventbrite"] ||[[aryEventDetails objectAtIndex:2] isEqualToString:@"meetup"]) {
		
		evtdesc = @"Please check website for all the information.";
		UILabel *lbl3rdPartyEvent = [UnsocialAppDelegate createLabelControl:@"Disclaimer: Event details can be differ from this given\ninfo. Please verify details before attending." frame:CGRectMake(15, 360, 290, 25) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeCharacterWrap fontwithname:kAppFontName fontsize:10 txtcolor:[UIColor redColor] backgroundcolor:[UIColor clearColor]];
		
		// commented by pradeep on 5th feb 2011 since disclaimer will not show in the event details section for events which are added by "Meet Up" and "Event Bright". It may be 
		//[self.view addSubview:lbl3rdPartyEvent];
		//[lbl3rdPartyEvent release];
	}
	eventDecscrip = [UnsocialAppDelegate createTextViewControl:evtdesc frame:CGRectMake(15, lblDescription.frame.origin.y + 18, 290, 100) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:13 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	eventDecscrip.contentInset = UIEdgeInsetsMake(-8.00, -8.00, 0.00, 0.00);
	eventDecscrip.showsVerticalScrollIndicator = YES;
	[self.view addSubview:eventDecscrip];
	
	//(0, 0, 300, 43)
	// for bookmarkbtn
	
	UIButton *btnOptions = [UnsocialAppDelegate createButtonControl:@"Options" target:self selector:@selector(btnOptions_Click) frame:CGRectMake(20, 385, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
//		[btnOptions.titleLabel setFont:[UIFont fontWithName:kAppFontName size:11.5]];
		[self.view addSubview:btnOptions];
	
	UIButton *btnShare = [UnsocialAppDelegate createButtonControl:@"Share" target:self selector:@selector(btnShare_Click)  frame:CGRectMake(128, 385, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
//	[btnShare.titleLabel setFont:[UIFont fontWithName:kAppFontName size:11.5]];
	[self.view addSubview:btnShare];

	UIButton *btnMapIt = [UnsocialAppDelegate createButtonControl:@"Map It" target:self selector:@selector(btnMapIt_Click) frame:CGRectMake(235, 385, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
//	[btnMapIt.titleLabel setFont:[UIFont fontWithName:kAppFontName size:11.5]];
	[self.view addSubview:btnMapIt];
	
	[activityView stopAnimating];
	activityView.hidden = YES;
	[eventTopic flashScrollIndicators];
	[eventDecscrip flashScrollIndicators];
	[tvEventWhere  flashScrollIndicators];
	[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(flashScrollIndic) userInfo:self.view repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(flashScrollIndic) userInfo:self.view repeats:NO];
	printf("All loading finished");
}

- (void) btntvEventWebsite_Click {
	
	if([btntvEventWebsite.titleLabel.text isEqualToString:@"Not Available"])
		return;
	WebViewForWebsites *webViewForWebsites = [[WebViewForWebsites alloc]init];
	webViewForWebsites.webAddress = btntvEventWebsite.titleLabel.text;
	[self.navigationController pushViewController:webViewForWebsites animated:YES];
	
	//[webViewForWebsites release];
}

-(void)flashScrollIndic {
	
	[eventTopic flashScrollIndicators];
	[eventDecscrip flashScrollIndicators];
	[tvEventWhere  flashScrollIndicators];
}

-(void)btnMapIt_Click {
	
	EventMap *eventMap = [[EventMap alloc]init];
	eventMap.getLongitude = [aryEventDetails objectAtIndex:15];
	eventMap.getLatitude = [aryEventDetails objectAtIndex:16];
	eventMap.eventaddress = [aryEventDetails objectAtIndex:3];
	[self.navigationController pushViewController:eventMap animated:YES];
	[eventMap release];
}

-(void)btnShare_Click {
	
	ShareEvent *shareEvent = [[ShareEvent alloc]init];
	shareEvent.eventid = eventid;
	[self.navigationController pushViewController:shareEvent animated:YES];
	[shareEvent release];
}

- (void)applyBookmark {
	
	BOOL isuserbookmarked = [self sendNow4Bookmark:@""];
	if (isuserbookmarked)
	{
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Event saved successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alertOnChoose show];
		[alertOnChoose release];
		self.navigationItem.rightBarButtonItem = nil;
	}
	else 
	{
		if ([alreadybookmark compare:@"alreadybookmark"] == NSOrderedSame)
		{
			UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Event is already saved!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alertOnChoose show];
			[alertOnChoose release];
			self.navigationItem.rightBarButtonItem = nil;
		}
	}
}

- (void)sponserThisEvent {
	// added by pradeep on 24 nov 2010 for fixing bug when user reached the live now event detail using springboard's saved live now event and click on "Explore" option of event details page, user landed to spring board of live now events. Now if user click on "People" tab, user got alway error message "Syncronization failed".
	// fixing above mentioned bug by pradeep on 24 nov 2010
	//********* start
	liveNowEventID = [[NSMutableArray alloc] init];
	//********* end
	
	[self entendToAttend];
	SponsoredEventFeaturesLauncherView *viewcontroller = [[SponsoredEventFeaturesLauncherView alloc]init];
	viewcontroller.eventid = [aryEventDetails objectAtIndex:0];
	viewcontroller.eventname = [aryEventDetails objectAtIndex:1];
	// fixing above mentioned bug by pradeep on 24 nov 2010
	//********* start 24 nov 2010
	[liveNowEventID addObject:[aryEventDetails objectAtIndex:0]];
	//********* end 24 nov 2010
	[self.navigationController pushViewController:viewcontroller animated:YES];
	//[eventIntendedUsers release];
}

- (void)btnOptions_Click {
	
	UIActionSheet *actionSheet;
	NSLog(@"%@", [aryEventDetails objectAtIndex:11]);
	if(![[aryEventDetails objectAtIndex:11] isEqualToString:@"normalevent"]) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Intend to attend", @"Attendee list", @"Save", @"Explore", @"Cancel", nil];
		actionSheet.destructiveButtonIndex = 4;
		clickedOn = 0;
	}
	else if ([[aryEventDetails objectAtIndex:14]  intValue] == 1) 
		// if user landed from myevents section then there is no need of save btn
	{
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Intend to attend", @"Attendee list", @"Report abuse", @"Save to calendar", @"Cancel", nil];
		actionSheet.destructiveButtonIndex = 4;
		clickedOn = 1;
	}
	else {		
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Intend to attend", @"Attendee list", @"Save", @"Report abuse", @"Save to calendar", @"Cancel", nil];
		actionSheet.destructiveButtonIndex = 5;
		clickedOn = 2;
	}
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	[actionSheet release];	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

	if(clickedOn == 1) { // normal event section
		
		if(buttonIndex == 0) {
			[self entendToAttend];
		}
		else if(buttonIndex == 1) {
			[self entendedUsers];
		}
		else if(buttonIndex == 2) {
			[self reportAbuse];
		}
		else if(buttonIndex == 3) { // save to calendar -vaibhav(v1.1)
			[self saveToCalendar];
		}
		else if(buttonIndex == 4) {
			
		}
	}
	else if(clickedOn == 2) { // saved event section
		
		if(buttonIndex == 0) {
			[self entendToAttend];
		}
		else if(buttonIndex == 1) {
			[self entendedUsers];
		}
		else if(buttonIndex == 2) {
			[self applyBookmark];
		}
		else if(buttonIndex == 3) {
			[self reportAbuse];
		}
		else if(buttonIndex == 4) { // save to calendar -vaibhav(v1.1)
			[self saveToCalendar];
		}
	}
	else { // sponsored event
		
		if(buttonIndex == 0) {
			flagforalreadyintend = YES;
			[self entendToAttend];
		}
		else if(buttonIndex == 1) {
			[self entendedUsers];
		}
		else if(buttonIndex == 2) {
			[self applyBookmark];
		}
		else if(buttonIndex == 3) {
			[self sponserThisEvent];
		}
			//		else if(buttonIndex == 4) {
			//[self sponserThisEvent];
			//}
		else {
			
		}		
	}
}

- (void)saveToCalendar {
	
		//**********
	// version check
	NSString *os_verson = [[UIDevice currentDevice] systemVersion];
		NSLog(@"%@", os_verson);
	float os_versionflt = [os_verson floatValue];
	
		// open an alert with two custom buttons
		//UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
		//deviceString=[h platformString];
		//NSLog(deviceString);
	
	if (os_versionflt >= 4) 
	{
		
		EKEventStore *eventStore = [[EKEventStore alloc] init];
		
		EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
		event.title     = [aryEventDetails objectAtIndex:1]; //@"EVENT TITLE";
		
		NSString *dateStrfrom = [[aryEventDetails objectAtIndex:5] stringByAppendingString:[@" " stringByAppendingString:[aryEventDetails objectAtIndex:6]]];
		NSLog(@"%@", dateStrfrom);
			// Convert string to date object
		NSDateFormatter *dateFormatfrom = [[NSDateFormatter alloc] init];
		[dateFormatfrom setDateFormat:@"MM/dd/yyyy hh:mm a"];
		NSDate *datefrom = [dateFormatfrom dateFromString:dateStrfrom];	
		[dateFormatfrom setDateFormat:@"LLL dd yyyy hh:mm a"];
		dateStrfrom = [dateFormatfrom stringFromDate:datefrom];
		datefrom = [dateFormatfrom dateFromString:dateStrfrom];
		
		NSString *dateStrto = [[aryEventDetails objectAtIndex:5] stringByAppendingString:[@" " stringByAppendingString:[aryEventDetails objectAtIndex:7]]];
		NSLog(@"%@", [aryEventDetails objectAtIndex:7]);
		NSDateFormatter *dateFormatto = [[NSDateFormatter alloc] init];
		[dateFormatto setDateFormat:@"MM/dd/yyyy hh:mm a"];
		NSDate *dateto = [dateFormatto dateFromString:dateStrto];	
		[dateFormatto setDateFormat:@"LLL dd yyyy hh:mm a"];
		dateStrto = [dateFormatfrom stringFromDate:dateto];
		dateto = [dateFormatto dateFromString:dateStrto];
		
		event.startDate = datefrom;//[NSDate date];
		event.endDate   = dateto;//[[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
		
		[event setCalendar:[eventStore defaultCalendarForNewEvents]];
		NSError *err;
		[eventStore saveEvent:event span:EKSpanThisEvent error:&err];
		
		UIAlertView *savealert = [[UIAlertView alloc]initWithTitle:nil message:@"Item saved to your Calendar." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[savealert show];
		[savealert release];
	}
	else {
		
		UIAlertView *savealert = [[UIAlertView alloc]initWithTitle:nil message:@"Feature is not available on your iPhone." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[savealert show];
		[savealert release];
	}
}

-(void)entendToAttend {
	
	BOOL isuserentendtoattend = [self sendNow4Event:@"addentendtoattendevent"];
	if (isuserentendtoattend)
	{
		// for reloading the spring board
		[lastVisitedFeature removeAllObjects];
		[lastVisitedFeature addObject:@"intendedtoattend"];
		
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:@"" message:@"You have successfully reported this event as intended event!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];//[[username stringByAppendingString:@" "] stringByAppendingString:
		[alertOnChoose show];
		[alertOnChoose release];
	}
	else 
	{
			// commented by pradeep on 24 nov 2010 for fixing bug related to receiving alert "already reported event as intended event again and again when user explore live now event from event detail's option
		
			// but it will give alert if event is an normal event - vaibhav 18 Dec 2010
		if([[aryEventDetails objectAtIndex:11] isEqualToString:@"normalevent"]) {
			
			UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:@"" message:@"You have already reported this event as intended event!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alertOnChoose show];
			[alertOnChoose release];
		}
		else {
			
			if (flagforalreadyintend == YES) {
				
				UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:@"" message:@"You have already reported this event as intended event!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
				[alertOnChoose show];
				[alertOnChoose release];
				flagforalreadyintend = NO;
			}

		}
	}
}

- (BOOL) sendNow4Bookmark: (NSString *) flag {
	
	NSLog(@"Sending....");
	//NSData *imageData1;
	
	/*NSData *imageData1 = [[NSData alloc] init];;
	 NSString *isimg1exist = [NSString stringWithFormat:@"%@\r\n", @"no"];
	 NSString *isimgexist = @"no";
	 
	 if ([capturedImage count] > 0)
	 {
	 
	 isimg1exist = [NSString stringWithFormat:@"%@\r\n", @"yes"];
	 isimgexist = @"yes";
	 //imageData1 = [capturedImage objectAtIndex:0];//UIImageJPEGRepresentation([imgarry1 objectAtIndex:0], 1.0);
	 imageData1 = UIImageJPEGRepresentation([capturedImage objectAtIndex:0], 1.0);
	 }*/
	
	
	// setting up the URL to post to
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"bookmarkevent"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	//NSString *deviceTocken;
	
	//NSString *usrabout;
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *usrid = [arrayForUserID objectAtIndex:0];
	usrid = [NSString stringWithFormat:@"%@\r\n",usrid];
	
	NSString *bookmarkedid = [NSString stringWithFormat:@"%@\r\n",[aryEventDetails objectAtIndex:0]];	
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"bookmarkedeventid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",bookmarkedid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
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
	alreadybookmark = nil;
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Userid"])			
		{
			//userid = [dic objectForKey:key];
			
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				
				NSLog(@"\n\n\n\n\n\n#######################-- post for bookmaark added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				
				break;
			}			
		}
		else if ([key isEqualToString:@"Notsuccess"])	
		{
			//userid = [dic objectForKey:key];
			
			if ([[dic objectForKey:key] isEqualToString:@"Already bookmark!"])
			{
				
				NSLog(@"\n\n\n\n\n\n#######################-- post for bookmaark added successfully --#######################\n\n\n\n\n\n");
				
				//successflg=YES;
				alreadybookmark = @"alreadybookmark";
				break;
			}			
		}
		
		
		
		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	//NSData *returnRes = [returnString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//now see what the status came back as
	//TSXMLParser *myparser = [[TSXMLParser alloc] init];
	//[myparser parseXMLFileAtData:(NSData *)returnRes];
	
	//NSLog(myparser.status);
	//NSLog(returnString);
	
	NSLog(@"%@", returnString);
	
	//NSString *strraffleid = raffleid;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
	//return;
}

- (BOOL) sendNow4Event: (NSString *) flag {
	NSLog(@"Sending....");
	//NSData *imageData1;
	
	/*NSData *imageData1 = [[NSData alloc] init];;
	 NSString *isimg1exist = [NSString stringWithFormat:@"%@\r\n", @"no"];
	 NSString *isimgexist = @"no";
	 
	 if ([capturedImage count] > 0)
	 {
	 
	 isimg1exist = [NSString stringWithFormat:@"%@\r\n", @"yes"];
	 isimgexist = @"yes";
	 //imageData1 = [capturedImage objectAtIndex:0];//UIImageJPEGRepresentation([imgarry1 objectAtIndex:0], 1.0);
	 imageData1 = UIImageJPEGRepresentation([capturedImage objectAtIndex:0], 1.0);
	 }*/
	
	
	// setting up the URL to post to
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
	//NSString *deviceTocken;
	
	//NSString *usrabout;
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *usrid = [arrayForUserID objectAtIndex:0];
	usrid = [NSString stringWithFormat:@"%@\r\n",usrid];
	
	NSString *abusedeventid = [NSString stringWithFormat:@"%@\r\n",[aryEventDetails objectAtIndex:0]];
	
	
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",abusedeventid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
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
			//userid = [dic objectForKey:key];
			
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				if ([flag compare:@"abuseevent"] == NSOrderedSame)
					NSLog(@"\n\n\n\n\n\n#######################-- post for abuse event added successfully --#######################\n\n\n\n\n\n");
				else if ([flag compare:@"addentendtoattendevent"] == NSOrderedSame)
					NSLog(@"\n\n\n\n\n\n#######################-- post for entendtoattend event added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				
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

- (void)leftbtn_OnClick {	
	
	WhereIam = 0;
	if([[aryEventDetails objectAtIndex:13]  intValue] != 1)
		[self dismissModalViewControllerAnimated:YES];
	else 
		[self.navigationController popViewControllerAnimated:YES];
	[aryEventDetails removeAllObjects];
}

- (void)reportAbuse {
	
	BOOL isuserabused = [self sendNow4Event:@"abuseevent"];
	if (isuserabused)
	{
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:@"" message:@"You have reported event as abuse successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];//[[username stringByAppendingString:@" "] stringByAppendingString:
		[alertOnChoose show];
		[alertOnChoose release];
	}
}

- (void)entendedUsers {
	
	EventIntendedUsers *eventIntendedUsers = [[EventIntendedUsers alloc]init];
	//eventIntendedUsers.eventid = eventid;
	eventIntendedUsers.eventid = [aryEventDetails objectAtIndex:0];
	[self.navigationController pushViewController:eventIntendedUsers animated:YES];
	[eventIntendedUsers release];
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
}


@end
