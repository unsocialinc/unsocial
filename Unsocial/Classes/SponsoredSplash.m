//
//  SponsoredEvents.m
//  Unsocial
//
//  Created by santosh khare on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SponsoredSplash.h"
#import "UnsocialAppDelegate.h"
//#import "PeopleEventSetDistance.h"
#import "EventDetails.h"
#import "GlobalVariables.h"
#import "Person.h"
#import "SponsoredEventFeaturesLauncherView.h"
//#import "EventAdd.h"

//BOOL allInterest = NO;
//NSString *localuserid, *localdistance;
int whichsegmentselectedlasttime4sponevent;
int arivefirsttime4sponevent;
int checkforsplash = 0;

@implementation SponsoredSplash

@synthesize calendarselectedindex;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	activityView.hidden = loading.hidden = YES;
	[self createControls];
}

- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"SponsoredEvents view will appear");
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
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	//itemNV.leftBarButtonItem = leftcbtnitme;
	
	if([[startLogicSponSplashCameFrom objectAtIndex:0] compare:@"springboard"] == NSOrderedSame) {
		self.navigationItem.leftBarButtonItem = leftcbtnitme;
	}
	else {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
		
		// added by pradeep on 1 june 2011 for returning to dashboard requirement
		
		UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(285.0, 0.0, 33, 30)];
		[rightbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
		[rightbtn addTarget:self action:@selector(rightbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *rightbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
		itemNV.rightBarButtonItem = rightbtnitme;
		//rightbtn.hidden = YES;
		
		// end 1 june 2011
	}
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)leftbtn_OnClick{
	
	if([[startLogicSponSplashCameFrom objectAtIndex:0] compare:@"springboard"] == NSOrderedSame)
		[self dismissModalViewControllerAnimated:YES];
	else {
		
		[self.navigationController popViewControllerAnimated:YES];		
	}
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
- (void)rightbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	[self dismissModalViewControllerAnimated:YES];
	[self dismissModalViewControllerAnimated:YES];
}
// end 1 june 2011

- (void)createControls {
	
	if (gbllatitude	== nil)
	{
		// recursion for getting longitude and latitude value
		// timer control using threading
		[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createControls) userInfo:self.view repeats:NO];
	}
	else
	{
		if ([[startLogicSponSplashCameFrom objectAtIndex:0] compare:@"springboard"] == NSOrderedSame)
		{
			// commented by pradeep on 1 feb 2011 for fixing bug i.e. if we click on sponsored event from event list and wants to see the splash of sponsored event, it shows "There are no premium events to display right now!" since we sent current date for [self getEventData:@"sponsoredevents" :@"all"]; while event is of past date etc
			
			/*if(!stories)
				[self getEventData:@"sponsoredevents" :@"all"];
			if ([stories count] == 0)
			{
				recnotfound = [UnsocialAppDelegate createLabelControl:@"There are no premium events to display right now!" frame:CGRectMake(30, 200, 260, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
				[self.view addSubview:recnotfound];
				recnotfound.hidden = NO;
				[recnotfound release];
				return;
				
			}
			else*/ {
				
				WhereIam = 3;
				// commented by pradeep on 3 feb 2011 for fixing bug 00157 on RTH
				//checkforsplash = 1;
				checkforsplash = 2;
				[self createScrollView];
			}
		}
		else 
		{
			// commented by pradeep on 1 feb 2011 for fixing bug i.e. if we click on sponsored event from event list and wants to see the splash of sponsored event, it shows "There are no premium events to display right now!" since we sent current date for [self getEventData:@"sponsoredevents" :@"all"]; while event is of past date etc
			/*if(!stories)
				[self getEventData:@"sponsoredevents" :@"all"];
			if ([stories count] == 0)
			{
				recnotfound = [UnsocialAppDelegate createLabelControl:@"There are no premium events to display right now!" frame:CGRectMake(30, 200, 260, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];	
				[self.view addSubview:recnotfound];
				recnotfound.hidden = NO;
				[recnotfound release];
				return;				
			}
			else*/ {
				
				WhereIam = 3;
				checkforsplash = 2;
				[self createScrollView];
			}
		}
		
		UIButton *btnOptions = [UnsocialAppDelegate createButtonControl:@"Explore" target:self selector:@selector(btnExplore_Click) frame:CGRectMake(110, 380, 100, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
		[self.view addSubview:btnOptions];

	}
}

- (void)createScrollView {
	
	CGRect frame = CGRectMake(0, 0, 320, 460);
	asyncImage = [[[AsyncImageView alloc]initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	NSURL*url;
	if(checkforsplash == 2)
		url = [NSURL URLWithString:[aryEventDetails objectAtIndex:17]];
	else
		url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:0]];
	[asyncImage loadImageFromURL:url];
	asyncImage.autoresizingMask = UIViewAutoresizingNone;
	asyncImage.backgroundColor = [UIColor clearColor];
	
		// Get the Layer of any view
	/*CALayer * l = [asyncImage layer];
	 [l setMasksToBounds:YES];
	 [l setCornerRadius:1.0];
	 
	 // You can even add a border
	 [l setBorderWidth:1.0];
	 [l setBorderColor:[[UIColor blackColor] CGColor]];
	 asyncImage.contentMode = UIViewContentModeScaleAspectFit;*/
	[self.view addSubview:asyncImage];

	/*CGRect frame = CGRectMake(10, 10, 300, 400);
	_scrollView = [[TTScrollView alloc] initWithFrame:frame];
	_scrollView.dataSource = self;
	_scrollView.backgroundColor = [UIColor clearColor];
	_scrollView.scrollEnabled = YES;
	[self.view addSubview:_scrollView];*/
}
/*
- (NSInteger)numberOfPagesInScrollView:(TTScrollView*)scrollView {
	return 1;
}

- (UIView*)scrollView:(TTScrollView*)scrollView pageAtIndex:(NSInteger)pageIndex {
	
	TTView* pageView = nil;
	if (!pageView) {
		pageView = [[[TTView alloc] init] autorelease];
		pageView.backgroundColor = [UIColor clearColor];
		pageView.userInteractionEnabled = NO;
		
		CGRect frame = CGRectMake(50, 0, 300, 400);
		asyncImage = [[[AsyncImageView alloc]
					   initWithFrame:frame] autorelease];
		asyncImage.tag = 999;
		NSURL*url;
		if(checkforsplash == 2)
			url = [NSURL URLWithString:[aryEventDetails objectAtIndex:17]];
		else
			url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:0]];
		[asyncImage loadImageFromURL:url];
		asyncImage.backgroundColor = [UIColor clearColor];
		
		// Get the Layer of any view
		/*CALayer * l = [asyncImage layer];
		[l setMasksToBounds:YES];
		[l setCornerRadius:1.0];
		
		// You can even add a border
		[l setBorderWidth:1.0];
		[l setBorderColor:[[UIColor blackColor] CGColor]];
 asyncImage.contentMode = UIViewContentModeScaleAspectFit;*//*
		[pageView addSubview:asyncImage];
	}
	return pageView;
}

- (CGSize)scrollView:(TTScrollView*)scrollView sizeOfPageAtIndex:(NSInteger)pageIndex {
	return CGSizeMake(320, 320);
}
*/
- (void)btnExplore_Click {
	
	// added by pradeep on 14 june 2011 for fixing bug in which if user click on spring board's premium event, it calls as intended event and request goes to server
	if([[startLogicSponSplashCameFrom objectAtIndex:0] compare:@"springboard"] != NSOrderedSame)
		// end 14 june 2011
	[self entendToAttend];
	SponsoredEventFeaturesLauncherView *viewcontroller = [[SponsoredEventFeaturesLauncherView alloc]init];
	
	
	// added by pradeep on 23 sep 2010
	//*************************
	
	// created livenoweventid by pradeep on 25 sep 2010
	liveNowEventID = [[NSMutableArray alloc] init];
	
	// if statement commented by pradeep on 3 feb 2011 for fixing issue 00157 on RTH
	/*if([[startLogicSponSplashCameFrom objectAtIndex:0] compare:@"springboard"] == NSOrderedSame)
	{
		NSLog(@"%@", [NSString stringWithFormat:@"Event id for splash: %@\r\n",[[stories objectAtIndex:0] objectForKey:@"guid"]]);
		viewcontroller.eventid = [[stories objectAtIndex:0] objectForKey:@"guid"];
		viewcontroller.eventname = [[stories objectAtIndex:0] objectForKey:@"eventname"];
		[liveNowEventID addObject:[[stories objectAtIndex:0] objectForKey:@"guid"]];
	}
	else */
	{
		NSLog(@"%@", [NSString stringWithFormat:@"Event id for splash: %@\r\n",[aryEventDetails objectAtIndex:0]]);
		viewcontroller.eventid = [aryEventDetails objectAtIndex:0];
		viewcontroller.eventname = [aryEventDetails objectAtIndex:1];
		[liveNowEventID addObject:[aryEventDetails objectAtIndex:0]];
	}
	
	//*************************
	
	[self.navigationController pushViewController:viewcontroller animated:YES];
	//[eventIntendedUsers release];
}

-(void)entendToAttend {
	
	BOOL isuserentendtoattend = [self sendNow4Event:@"addentendtoattendevent"];
	if (isuserentendtoattend)
	{
		// for reloading the spring board
		[lastVisitedFeature removeAllObjects];
		[lastVisitedFeature addObject:@"intendedtoattend"];
		
		// commented by pradeep on 6 june 2011 for disabling feature to prompt user that "You have successfully reported this event as intended event! for release 1.6
		/*UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:@"" message:@"You have successfully reported this event as intended event!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];//[[username stringByAppendingString:@" "] stringByAppendingString:
		[alertOnChoose show];
		[alertOnChoose release];*/
		
		// end 6 june 2011
	}
	else 
	{
		/*UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:@"" message:@"You have already reported this event as intended event!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];//[[username stringByAppendingString:@" "] stringByAppendingString:
		[alertOnChoose show];
		[alertOnChoose release];*/
	}
}

- (BOOL) sendNow4Event: (NSString *) flag {
	NSLog(@"Sending....");
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
	
	//[[stories objectAtIndex:indexPath.row] objectForKey:@"eventname"]
	NSString *abusedeventid;
	if([[startLogicSponSplashCameFrom objectAtIndex:0] compare:@"springboard"] == NSOrderedSame)
	{
		NSLog(@"%@", [NSString stringWithFormat:@"Event id for splash: %@\r\n",[[stories objectAtIndex:0] objectForKey:@"guid"]]);
		abusedeventid = [NSString stringWithFormat:@"%@\r\n",[[stories objectAtIndex:0] objectForKey:@"guid"]];
	}
	else 
	{
		NSLog(@"%@", [NSString stringWithFormat:@"Event id for splash: %@\r\n",[aryEventDetails objectAtIndex:0]]);
		abusedeventid = [NSString stringWithFormat:@"%@\r\n",[aryEventDetails objectAtIndex:0]];
	}

	
	
	
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
		if ([key compare:@"Userid"] == NSOrderedSame)			
		{
			//userid = [dic objectForKey:key];
			
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
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
	
	NSLog(returnString);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

- (void) getEventData:(NSString *) eventflg: (NSString *) eventsubflg {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	// Time Formats
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	//dt = [[dt substringFromIndex:0] substringToIndex:19];
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	//[collectionindustry stringByAppendingString:@","] stringByAppendingString:[interestedIndustryIds1 objectAtIndex:i]
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	//NSString *distance = @"1"; // it should be retrieved from file that contains the set value
	
	// retreiving HH:MM from HH:MM:SS using substring
	//usertime = [[usertime substringFromIndex:0] substringToIndex:5];
	
	//if ( [gbluserid compare:@""] == NSOrderedSame || !gbluserid)
	//	gbluserid = @"none";
	gbluserid = [arrayForUserID objectAtIndex:0];
	
	NSLog(@"Sending....");
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&distance=%@&eventflag=%@&eventsubflag=%@",@"getevents",gbllatitude,gbllongitude,gbluserid,usertime,@"0",eventflg,eventsubflg];
	urlString = [globalUrlString stringByAppendingString:urlString];
	
	NSLog(urlString);
	[self parseXMLFileAtURL:urlString];	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//return successflg;
	[pool release];
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
	imageURLs4Lazy = [[NSMutableArray alloc]init];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down."];
	NSLog(@"error parsing XML: %@", errorString);	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		eventid = [[NSMutableString alloc] init];
		eventname= [[NSMutableString alloc] init];
		eventdesc = [[NSMutableString alloc] init];
		eventaddress = [[NSMutableString alloc] init];
		eventindustry = [[NSMutableString alloc] init];
		eventdate = [[NSMutableString alloc] init];
		fromtime = [[NSMutableString alloc] init];
		eventtype = [[NSMutableString alloc] init];
		
		totime = [[NSMutableString alloc] init];
		eventcontact = [[NSMutableString alloc] init];
		eventwebsite = [[NSMutableString alloc] init];
		eventlatitude = [[NSMutableString alloc] init];
		eventlongitude = [[NSMutableString alloc] init];
		isrecurring = [[NSMutableString alloc] init];
		eventcurrentdistance = [[NSMutableString alloc] init];
	}
	if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		// save values to an item, then store that item into the array...
		//[item setObject:userprefix forKey:@"prefix"];
		[item setObject:eventid forKey:@"guid"];
		[item setObject:eventname forKey:@"eventname"]; 
		[item setObject:eventdesc forKey:@"eventdescription"]; // for blog description also date but not rite now
		[item setObject:eventaddress forKey:@"eventaddress"];
		
		[item setObject:eventindustry forKey:@"eventindustry"];
		[item setObject:eventdate forKey:@"eventdate"];
		[item setObject:fromtime forKey:@"fromtime"];
		[item setObject:totime forKey:@"totime"];
		[item setObject:eventcontact forKey:@"eventcontact"];
		[item setObject:eventwebsite forKey:@"eventwebsite"];
		[item setObject:eventlongitude forKey:@"eventlongitude"];
		[item setObject:eventlatitude forKey:@"eventlatitude"];
		
		[item setObject:isrecurring forKey:@"isrecurring"];
		[item setObject:eventcurrentdistance forKey:@"currentdistance"];
		[item setObject:eventtype forKey:@"eventtype"];
		//if ([[startLogicSponSplashCameFrom objectAtIndex:0] compare:@"springboard"] == NSOrderedSame) {
			
//			NSURL *url = [NSURL URLWithString:currentImageURL];
//			NSData *data = [NSData dataWithContentsOfURL:url];
//			asyncImage2 = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
		/*}
		else {
			
			[imageURLs4Lazy addObject:currentImageURL];
		}*/
		[imageURLs4Lazy addObject:currentImageURL];
		[stories addObject:[item copy]];
		NSLog(@"adding story: %@", currentImageURL);		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

	if ([currentElement isEqualToString:@"guid"]) {
		[eventid appendString:string];
	}else if ([currentElement isEqualToString:@"eventname"]) {
		[eventname appendString:string];
	}else if ([currentElement isEqualToString:@"eventdescription"]) {
		[eventdesc appendString:string];
	} 
	
	else if ([currentElement isEqualToString:@"eventaddress"]) {
		[eventaddress appendString:string];
	}else if ([currentElement isEqualToString:@"eventaddress"]) {
		[eventaddress appendString:string];
	}else if ([currentElement isEqualToString:@"eventindustry"]) {
		[eventindustry appendString:string];
	}else if ([currentElement isEqualToString:@"eventdate"]) {
		[eventdate appendString:string];
	}else if ([currentElement isEqualToString:@"fromtime"]) {
		[fromtime appendString:string];
	}else if ([currentElement isEqualToString:@"totime"]) {
		[totime appendString:string];
	}else if ([currentElement isEqualToString:@"eventcontact"]) {
		[eventcontact appendString:string];
	}else if ([currentElement isEqualToString:@"eventwebsite"]) {
		[eventwebsite appendString:string];
	}else if ([currentElement isEqualToString:@"eventlongitude"]) {
		[eventlongitude appendString:string];
	}else if ([currentElement isEqualToString:@"eventlatitude"]) {
		[eventlatitude appendString:string];
	}else if ([currentElement isEqualToString:@"isrecurring"]) {
		[isrecurring appendString:string];
	}else if ([currentElement isEqualToString:@"currentdistance"]) {
		[eventcurrentdistance appendString:string];
	}else if ([currentElement isEqualToString:@"eventtype"]) {
		[eventtype appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {		
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	[itemTableView reloadData];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
	}
	else {
		AsyncImageView* oldImage = (AsyncImageView*)
		[cell.contentView viewWithTag:999];
		[oldImage removeFromSuperview];
	}
	
    // Set up the cell...	
	UIImageView *imgPplBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 0, 320, 115) imageName:@"peopleback.png"];
	[cell.contentView addSubview:imgPplBack];
	
	CGRect frame;
	frame.size.width=65; frame.size.height=65;
	frame.origin.x=9; frame.origin.y=7;
	asyncImage = [[[AsyncImageView alloc]
				   initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	NSURL*url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
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
	[cell.contentView addSubview:asyncImage];
	//[usrImage release];
	
	//*************** lazy img code end
	
#pragma mark EVENT NAME STARTS
	CGRect lableNameFrame = CGRectMake(89, 8, 220, 15);	
	lblEvent = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventname"] frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblEvent];
	/*EVENT NAME ENDS*/
	
	NSArray *split = [[[stories objectAtIndex:indexPath.row] objectForKey:@"eventdate"]componentsSeparatedByString:@" "];
	NSString *eventdt = [NSString stringWithFormat:@"%@",[split objectAtIndex:0]];
	
#pragma mark EVENT DATE STARTS
	CGRect lableDateFrame = CGRectMake(lableNameFrame.origin.x, 25, 100, 15);
	lblEventDt = [UnsocialAppDelegate createLabelControl:@"On:" frame:lableDateFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblEventDt];
	
	lblEventDt = [UnsocialAppDelegate createLabelControl:eventdt frame:CGRectMake(lableNameFrame.origin.x, lableDateFrame.origin.y + 12, 100, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDt];
	/*EVENT DATE ENDS*/
	
#pragma mark EVENT DATE FROM STARTS
	CGRect lablefromFrame = CGRectMake(lableDateFrame.origin.x, lableDateFrame.origin.y + 28, 100, 15);	
	lblEventDtFrom = [UnsocialAppDelegate createLabelControl:@"From:" frame:lablefromFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDtFrom];
	
	lblEventDtFrom = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"fromtime"] frame:CGRectMake(lableNameFrame.origin.x, lablefromFrame.origin.y + 12, 100, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDtFrom];
	/*EVENT DATE FROM ENDS*/
	
#pragma mark EVENT DATE TO STARTS
	CGRect lableToFrame = CGRectMake(lablefromFrame.origin.x, lablefromFrame.origin.y + 28, 90, 15);
	lblEventDtTo = [UnsocialAppDelegate createLabelControl:@"To:" frame:lableToFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDtTo];
	
	lblEventDtTo = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"totime"] frame:CGRectMake(lablefromFrame.origin.x, lableToFrame.origin.y + 12, 90, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblEventDtTo];
	/*EVENT DATE TO ENDS*/
	
#pragma mark EVENT DISTANCE STARTS
	CGRect lableDistanceFrame = CGRectMake(0, lableToFrame.origin.y, 310, 15);
	lblEventDistance = [UnsocialAppDelegate createLabelControl:@"Distance:" frame:lableDistanceFrame txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDistance];
	
	lblEventDistance = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"] frame:CGRectMake(0, lableToFrame.origin.y + 12, 310, 15) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDistance];
	/*EVENT DISTANCE ENDS*/
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return 10;
	return [stories count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	EventDetails *eventDetails = [[EventDetails alloc]init];
	aryEventDetails = [[NSMutableArray alloc]init];
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"guid"]]; //0
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventname"]]; //1
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventdescription"]]; //2
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventaddress"]]; //3
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"]];//4
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventdate"]];//5
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"fromtime"]];//6
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"totime"]];//7
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventcontact"]];//8
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventwebsite"]];//9
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"isrecurring"]];//10
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventtype"]];//11
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"]];//12	
	[aryEventDetails addObject:[NSString stringWithFormat:@"%i",1]]; // 13 comingfrom
	
	[aryEventDetails addObject:[NSString stringWithFormat:@"%i",segmentedControl.selectedSegmentIndex]]; // 14
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventlongitude"]];//15
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventlatitude"]];//16
	[aryEventDetails addObject:[imageURLs4Lazy objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:eventDetails animated:YES];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// Delete the row from the data source
		[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
}


@end
