#import "LauncherViewTestController.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"
#import "EventDetails.h"
#import "Person.h"
#import "ActivityViewForLauncher.h"
#import "ShowTips.h"
#import "webViewForLinkedIn.h"
#import "SplashScreen.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation LauncherViewTestController

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

// added by pradeep on 11 feb 2011 for fixing bug related to recall loadview
int firsttimeload = 0;

@synthesize peoples, events, inBox, settings, biMeter, referrals, invites, about, settingsTableView, userid, sponsoredEvents, viewVideo, viewDigitalBillBoard;
@synthesize threadProgressView, frontImg, peopleautotagged;

- (id)init {
	 //NSLog(@"hello pradeep: here init calls");
  if (self = [super init]) {
	  
	 // NSLog(@"hello pradeep: here init calls");
	  
    //self.title = @"Launcher";
  }
  return self;
}

// called after this controller's view will appear
- (void)viewWillAppear:(BOOL)animated {
	
	//UnsocialAppDelegate *uad = [[UIApplication sharedApplication] delegate];
	/*if (didAppEnterBackGround)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getEventData:@"intendedevents" :@"") name: UIApplicationDidBecomeActiveNotification object:nil];
	}*/
	
	
	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	
	[super viewWillAppear:animated];
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	bar.hidden = NO;
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;
	leftbtn.hidden = YES;
	
	// COMMENTED by pradeep on 5th jan 2011
	//UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout_Click)];
	UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showAlertWhenLogout)];
	
	self.navigationItem.rightBarButtonItem = rightbtn;
	[rightbtn release];

	[self getImageLocally];
	[self getStatusFromFile];
	[self getNameFromFile];
	
	// added by pradeep on 7 june 2011
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object
	//loadingBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(20, 150, 280, 90) imageName:@"loadingback.png"];
	loadingBack = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(20, 150, 280, 90) imageName:@"loadingback.png"];
	
	
	[self.view addSubview:loadingBack];
	loadingBack.hidden = NO;
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 210, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	activityView.hidden = NO;
	loading2 = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"loading\nplease standby" frame:CGRectMake(20, 140, 280, 90) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading2];
	loading2.hidden = NO;
	
	// end 7 june 2011
	
}

// added by pradeep on 27 may 2011 for refreshing location label when app didbecomeactive
//************************************
- (void)viewDidLoad
{
	// added by pradeep on 27 may 2011 for refreshing location label when app didbecomeactive
	
	// UIApplicationDidBecomeActiveNotification in its viewWillAppear: method.
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData4LocationLabel) name: UIApplicationDidBecomeActiveNotification object:nil];
	
	
	// end 27 may 2011 by pradeep
}

- (void) reloadData4LocationLabel
{
	// added by pradeep on 1 aug 2011 for fixing issue for launcherview, in which reloadData4LocationLabel calls 3 times
	//if (!isreloadData4LocationLabelCall)
	{	
		//isreloadData4LocationLabelCall = TRUE;
	// end 1 aug 2011 
		// added by pradeep on 4 june 2011 since reloadData4LocationLabel method is calling even no body is logged in. due to this app is crashing.
		if ([arrayForUserID count] > 0)
		{
			//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			
			// commented n added mainthread by pradeep on 7 june 2011
			[NSThread detachNewThreadSelector:@selector(reloadData4LocationLabelBySeperateThread) toTarget:self withObject:nil];
			
			//[self performSelectorOnMainThread:@selector(reloadData4LocationLabelBySeperateThread) withObject:nil waitUntilDone:NO];
			
			//[pool release];
			
			// added by pradeep on 31 may 2011 for updating badges too when app coming on foreground process
			//pool = [[NSAutoreleasePool alloc] init];
			
			// commented n added mainthread by pradeep on 7 june 2011
			[NSThread detachNewThreadSelector:@selector(updateBadges4InboxNEventsAsync) toTarget:self withObject:nil];
			
			//[self performSelectorOnMainThread:@selector(updateBadges4InboxNEventsAsync) withObject:nil waitUntilDone:NO];
			
			//[pool release];
			// end 31 may 2011	
		}
		// end 4 june 2011
	// added by pradeep on 1 aug 2011 for fixing issue for launcherview, in which reloadData4LocationLabel calls 3 times	
	}
	// end 1 aug 2011
		
	
}

- (void) reloadData4LocationLabelBySeperateThread
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"Call didbecomeappactive in different view for refreshing location label");
	[self getEventData:@"intendedevents" :@""];
	if ([usercurrentlocationdeep count] > 0)
	{
			NSLog(@"user current location: %@", [usercurrentlocationdeep objectAtIndex:0]);
			
			//userlocation = [UnsocialAppDelegate createLabelControl:[usercurrentlocationdeep objectAtIndex:0] frame:CGRectMake(5, 390, 310, 25) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:10 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		
		userlocation.text = [usercurrentlocationdeep objectAtIndex:0];
			
			// 13 may 2011 by pradeep //[userlocation release];
		
	}
	[self.view addSubview:userlocation];
	[pool release];
}

// Unregister for the notification in your view controller's viewDidDisappear: method.
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

// ***************************************
// end 27 may 2011 by pradeep

- (void) getStatusFromFile {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4UnsocialStatus"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) 
	{
		
		status = [UnsocialAppDelegate createTextViewControl:@"Set your status here" frame:CGRectMake(95, 27, 210, 50) txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:12 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:NO editable:NO];
		status.contentInset = UIEdgeInsetsMake(-8.00, -8.00, 0.00, 0.00);
		
		//open it and read it 
		NSLog(@"LV1 data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];
		
		strsetstatus = [[tempArray objectAtIndex:0] strsetstatus];
		userid = [[tempArray objectAtIndex:0] userid];
		
		[decoder finishDecoding];
		[decoder release];
		
		if([strsetstatus compare:@""] == NSOrderedSame || !strsetstatus){
			
		}
		else {
			
			// added by pradeep on 9 feb 2011 for triming status if its length > 75 and appending 3dots
			//**************** 9 feb start
			if ([strsetstatus length] > 75)
			{
				status.text = [[strsetstatus substringWithRange:NSMakeRange(0,74)] stringByAppendingString:@"..."];
			}
			else 
			{
				status.text = strsetstatus;
			}
			//**************** 9 feb end
			
			
			status.textColor = [UIColor whiteColor];
		}
		[self.view addSubview:status];
		[status flashScrollIndicators];
	}
	else {
		
		status = [UnsocialAppDelegate createTextViewControl:@"Set your status here" frame:CGRectMake(95, 27, 210, 60) txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:12 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:NO editable:NO];
		status.contentInset = UIEdgeInsetsMake(-8.00, -8.00, 0.00, 0.00);
		[self.view addSubview:status];
		[status flashScrollIndicators];
	}
	btnSetStatus = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnSetStatus_Click) frame:CGRectMake(95, 25, 180, 60) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSetStatus];
}

- (BOOL) getNameFromFile {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
		//open it and read it
		NSLog(@"LV2 data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];
		NSString *name = [[tempArray objectAtIndex:0] username];
		//NSString *prefix = [[tempArray objectAtIndex:0] userprefix];
		
		lblUsername = [UnsocialAppDelegate createLabelControl:name frame:CGRectMake(95, 6, 210, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:13 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:lblUsername];
		
		[decoder finishDecoding];
		[decoder release];
		
		if ([userid compare:@""] == NSOrderedSame || !userid)
		{
			return NO;
		}
		else {
			
			return YES;
		}
	}
	else {
		strsetstatus = @"";
		return NO;
	}
}

- (void)getImageLocally{
	
	UIImageView *imgStatusBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(6, 6, 308, 80) imageName:@"dashimgstatusback.png"];
	[self.view addSubview:imgStatusBack];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgStatusBack release];
	// end 3 august 2011 for fixing memory issue
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"1.png"] retain];
	UIImageView *selectedImage = [[UIImageView alloc] init];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:dataFilePath]) 
	{
		selectedImage.image = [UIImage imageWithContentsOfFile:dataFilePath ];
	}
	else
	{
		selectedImage.image = [UIImage imageNamed:@"imgNoUserImage.png"];
	}
	CGImageRef realImage = selectedImage.image.CGImage;
	float realHeight = CGImageGetHeight(realImage);
	float realWidth = CGImageGetWidth(realImage);
	float ratio = realHeight/realWidth;
	float modifiedWidth, modifiedHeight, xAxis = 14, yAxis = 9;
	if(ratio > 1.00) {
		
		modifiedWidth = 70/ratio;
		modifiedHeight = 70;
	}
	else {
		
		modifiedWidth = 70;
		modifiedHeight = ratio*70;
	}
	
	UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis,  yAxis, 70, 70)];
	userImage.image = selectedImage.image;
	
	UIImageView *roundedView = userImage;
		// Get the Layer of any view
	CALayer * l = [roundedView layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:10.0];
	
    // You can even add a border
	[l setBorderWidth:1.0];
	[l setBorderColor:[[UIColor blackColor] CGColor]];
	[self.view addSubview:roundedView];
	
	// added by pradeep on 1 aug 2011 for releasing memory issue
	[selectedImage release];
	// end 1 aug 2011
}

//*********************************** splash code start

// not in use from 25 may 2011 for disabling splashexperience added by pradeep on 25 may 2011
- (void) createSplashExperience
{
	NSLog(@"***** call createsplashexp ***********");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  
	// This is where rest of your calls go - such as sending data to server/retrieving status stuff etc.
	
	//[NSThread sleepForTimeInterval:3];  
	//[self performSelectorOnMainThread:@selector(callsplash) withObject:nil waitUntilDone:NO];  
	
	//SplashScreen *ss = [[SplashScreen alloc] init];
	//[self.navigationController pushViewController:ss animated:NO];
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	TTURLMap* map = navigator.URLMap;
	[map from:@"tt://splash" toModalViewController:[SplashScreen class]transition:1];
	//[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://splash"]];
	
	[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://splash"] applyAnimated:YES]];
	
	[pool release];
}
//end 25 may 2011

/*- (void) callsplash
{
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	TTURLMap* map = navigator.URLMap;
	[map from:@"tt://splash" toModalViewController:[SplashScreen class]transition:1];
	//[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://splash"]];
	 
	[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://splash"] applyAnimated:YES]];
	
	//SplashScreen *ss = [[SplashScreen alloc] init];
	//[self.navigationController pushViewController:ss animated:NO];
}*/

//************************************ splash code end



// added by pradeep on 5th Jan 2011 for prompting user when he wqnt to log-out
//****************** start 5th jan 2011

- (void)showAlertWhenLogout
{
	[self alertSimpleAction:@"":@"Are you sure you want to logout?"];
}

- (void)alertSimpleAction:(NSString *)alertMsg:(NSString *)instrc
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertMsg message:instrc delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
	alertFrom = 2;
}

/*- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	// added by pradeep on 5th Jan 2011 for prompting user when he wqnt to log-out
	//****************** start 5th jan 2011
	if (buttonIndex == 0)
	{
	}
	else
	{
		[self logout_Click];
	}
}*/

//****************** end 5th jan 2011


- (void) logout_Click
{
	// commented and added by pradeep on 25 july 2011 for fixing issue syncronization failed message display multiple times
	issyncfailedmsgdisplayed = FALSE;
	// end by pradeep on 25 july 2011 for fixing issue syncronization failed message display multiple times
	
	NSLog(@"Logout");
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self removeLocalFiles:@"settingsinfo4Unsocial"];
	[self removeLocalFiles:@"settingsinfo4Unsocial2"];
	[self removeLocalFiles:@"securitysettings"];
	[self removeLocalFiles:@"1.png"];
	[self removeLocalFiles:@"settingsinfo4UnsocialStatus"];
	[self removeLocalFiles:@"billboard.jpg"];
	[self removeLocalFiles:@"settingsinfo4metatags"];
	[self removeLocalFiles:@"settingsinfo4tags"];
	
	[self sendForLogoff:@"logoff" :@""];
	
	//****
	// added by pradeep on 15 oct according to vaibhav
	[self removeLocalFiles:@"flagunsocialtile.jpg"];
	
	//*****
	
	//[pool release];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
#pragma mark Setting lastVisitedFeature array as signup for not opening splash during LauncherViewTestController
	[lastVisitedFeature removeAllObjects];
	[lastVisitedFeature addObject:@"welcome"];
	
	//********* added by pradeep on 5 oct 2010 for deleting all the items from global array for people
	
	[interestedIndustryIds1 removeAllObjects];
	[interestedIndustryIds2 removeAllObjects];
	[interestedIndustryIds3 removeAllObjects];	
	[interestedIndustry1 removeAllObjects];
	[interestedIndustry2 removeAllObjects];
	[interestedIndustry3 removeAllObjects];	
	[aryKeyword removeAllObjects];
	[aryTags removeAllObjects];
	[aryVideo removeAllObjects];
	[aryVideoTitle removeAllObjects];
	[aryLoggedinUserName removeAllObjects];
	[aryUsrStatus removeAllObjects];			
	[stories4peoplearoundme removeAllObjects];
	[stories4peoplemyinterest removeAllObjects];
	[stories4peoplebookmark removeAllObjects];
	[imageURLs4Lazyall removeAllObjects];
	[imageURLs4Lazyauto removeAllObjects];
	[imageURLs4Lazysaved removeAllObjects];

	[arrayForUserID removeAllObjects];
	[allInfo removeAllObjects];
	[userEntries removeAllObjects];
	[userEntries2 removeAllObjects];
	[industryArray1 removeAllObjects];
	[industryArray2 removeAllObjects];
	[industryArray3 removeAllObjects];
	[searchtxt removeAllObjects];
	[aryCompanyInfo removeAllObjects];
	whichsegmentselectedlasttime4msg = 0;
	
	NSHTTPCookie *cookie;
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (cookie in [storage cookies]) {
		[storage deleteCookie:cookie];
	}
	//********* added by pradeep on 5 oct 2010 for deleting all the items from global array for people
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	TTURLMap *map = navigator.URLMap;
	//[map from:@"tt://launcherTest" toViewController:[SignIn class]];
	//[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://launcherTest"]];
	
	//[map from:@"tt://launcherTest" toModalViewController:[SignIn class]transition:1];
	[map from:@"tt://welcome" toModalViewController:[WelcomeViewController class]transition:1];
	[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://welcome"] applyAnimated:YES]];
}

- (void) removeLocalFiles: (NSString *) filename
{
	// during logout, delete all persistance files locally i.e. delete files or remove files
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];	
	NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
	//documentsDirectory = [documentsDirectory stringByAppendingString:@"/settingsinfo4UnsocialVideo"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSLog(@"%@", fileManager);
	if([fileManager fileExistsAtPath:path]) // if all the videos have deleted then file should be deleted and lastVisitedFeature must be reloaded
	{
		[fileManager removeItemAtPath:path error:NULL];			
	}
}


- (BOOL) getDataFromFile: (NSString *) filename {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
		//open it and read it 
		NSLog(@"LV3 data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];
		
		//strsetstatus = [[tempArray objectAtIndex:0] strsetstatus];
		userid = [[tempArray objectAtIndex:0] userid];
		
		[decoder finishDecoding];
		[decoder release];	
		
		if ( [userid compare:@""] == NSOrderedSame || !userid)
		{
			return NO;
		}
		else {
			[arrayForUserID removeAllObjects];
			[arrayForUserID addObject:userid]; 
			return YES;
		}		
	}
	else { 
		return NO;
	}
}

// added by pradeep on 14 may 2011 for improving springboard response listed in RTH issue # 16

- (void) updateBadges4InboxNEventsAsync
{
	
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	self.navigationItem.rightBarButtonItem.enabled = FALSE;
#pragma mark send requst for unread message
	[UnsocialAppDelegate sendNow4UnreadMessages];
	
	// added by pradeep on 7 june 2011
	NSLog(@"1 worked till here for updateBadges4InboxNEventsAsync");
	
	TTLauncherItem* items = [_launcherView itemWithURL:@"fb://item3"];
	if (unreadmsg > 0)
		items.badgeNumber = unreadmsg;
	else items.badgeNumber = 0;
	
#pragma mark Adding Badge to Events START
	//Number of events within 50 Miles and with in 24 hours -Vaibhav 19 Jan
	items = [_launcherView itemWithURL:@"fb://item2"];
	NSInteger totalpre = [UnsocialAppDelegate getNumberOfPreEvents];
	if (totalpre > 0)
		items.badgeNumber = totalpre;
	else items.badgeNumber = 0;
	
	// added by pradeep on 7 june 2011
	NSLog(@"2 worked till here for updateBadges4InboxNEventsAsync");
	
#pragma mark Adding Badge to Events ENDS
	
	// added by pradeep on 31 may 2011 for badging for newlytagged users
	
	items = [_launcherView itemWithURL:@"fb://item6"];
	NSInteger recentlytaggedusers = [UnsocialAppDelegate getNumberOfNewlyTaggedUsers];
	if (recentlytaggedusers > 0)
		items.badgeNumber = recentlytaggedusers;
	else items.badgeNumber = 0;
	
	// added by pradeep on 7 june 2011
	NSLog(@"3 worked till here for updateBadges4InboxNEventsAsync");
	
	// end 31 may 2011
	
	self.navigationItem.rightBarButtonItem.enabled = TRUE;
	[pool release];
	
	
}

// end 14 may 2011 by pradeep


- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];

	// commented & added by pradeep on 14 may 2011 for improving springboard response listed in RTH issue # 16
/*#pragma mark send requst for unread message
	[UnsocialAppDelegate sendNow4UnreadMessages];
	
	TTLauncherItem* items = [_launcherView itemWithURL:@"fb://item3"];
	if (unreadmsg > 0)
		items.badgeNumber = unreadmsg;
	else items.badgeNumber = 0;
	
#pragma mark Adding Badge to Events START
	//Number of events within 50 Miles and with in 24 hours -Vaibhav 19 Jan
	items = [_launcherView itemWithURL:@"fb://item2"];
	NSInteger totalpre = [UnsocialAppDelegate getNumberOfPreEvents];
	if (totalpre > 0)
		items.badgeNumber = totalpre;
	else items.badgeNumber = 0;
#pragma mark Adding Badge to Events ENDS*/
	
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// commented n added mainthread by pradeep on 7 june 2011
	//[NSThread detachNewThreadSelector:@selector(updateBadges4InboxNEventsAsync) toTarget:self withObject:nil];
	
	[self performSelectorOnMainThread:@selector(updateBadges4InboxNEventsAsync) withObject:nil waitUntilDone:NO];
	
	//[pool release];
	
	// end 14 may 2011 improving springboard response listed in RTH issue # 16
	
	if([lastVisitedFeature count] >0) {
		
		// note: lastVisitedFeature is initialized as 
		//intendedtoattend > in eventdetails if event is added as intendedtoattend
		//digitalbillboard > in settingsStep5 if digitalbillboard is added
		NSLog(@"Last View Controller- %@", [lastVisitedFeature objectAtIndex:0]);
		if ([[lastVisitedFeature objectAtIndex:0] isEqualToString:@"intendedtoattend"] || [[lastVisitedFeature objectAtIndex:0] isEqualToString:@"digitalbillboard"] || [[lastVisitedFeature objectAtIndex:0] isEqualToString:@"videoad"] || [[lastVisitedFeature objectAtIndex:0] isEqualToString:@"addextrafeature"]) {
			
			[lastVisitedFeature removeAllObjects];
			[self reLoadLauncherView];			
		}
	}
	/*
	UIButton *btnTips = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
	btnTips.frame = CGRectMake(291, 387, 25.0, 25.0);
	[btnTips addTarget:self action:@selector(btnTips_Click) forControlEvents:UIControlEventTouchUpInside];
	btnTips.backgroundColor = [UIColor clearColor];
	[self.view addSubview:btnTips];*/
	
	//NSString *usrloc = @"";
	//if ([stories4usercurrentlocation4springboard count] > 0)
		//usrloc = [stories4usercurrentlocation4springboard objectAtIndex:0];
	
	if (!userlocation)
	{
		if ([usercurrentlocationdeep count] > 0)
		{
		NSLog(@"user current location: %@", [usercurrentlocationdeep objectAtIndex:0]);
		
		userlocation = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:[usercurrentlocationdeep objectAtIndex:0] frame:CGRectMake(5, 390, 310, 25) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:10 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		
		// 13 may 2011 by pradeep //[userlocation release];
		}
	}
	// added by pradeep on 27 may 2011 for resetting location label's text.
	else 
	{
		if ([usercurrentlocationdeep count] > 0)
			userlocation.text = [usercurrentlocationdeep objectAtIndex:0];
	}
	// end 27 may 2011

	[self.view addSubview:userlocation];
	
	// added by pradeep on 7 june 2011
	loadingBack.hidden = YES;
	loading2.hidden = YES;
	[activityView stopAnimating];
	// end 7 june 2011
}

- (void)dealloc {
	// added by pradeep on 27 may 2011 during refreshing location label
	NSLog(@"dealloc called for launcherviewtest");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
	// end 27 may 2011
	[super dealloc];
	//[btnSetStatus release];
	//[status release];
	
	// added by pradeep on 29 june 2011
	//_launcherView.delegate = nil;
	// end 29 june 2011
}

- (void)btnTips_Click {
	
	[UnsocialAppDelegate playClick];
	TTNavigator* navigator = [TTNavigator navigator];
	//navigator.delegate = self;
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	TTURLMap* map = navigator.URLMap;
	[map from:@"tt://pkTest" toModalViewController:[ShowTips class]transition:1];
	[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://pkTest"] applyAnimated:YES]];
	
	/*ShowTips *showTips = [[ShowTips alloc]init];
	 [self.navigationController presentModalViewController:showTips animated:YES];
	 [showTips release];*/
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController
- (CGFloat)rowHeight {

    return 103;
} 

- (void) getEventData:(NSString *) eventflg: (NSString *) eventsubflg {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	// Time Formats
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	//dt = [[dt substringFromIndex:0] substringToIndex:19];
	
	
	//testing for GMT time by pradeep on 6 Oct 2010 not in use
	//***********************
	/*NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
	NSDate *gmtDate = [[NSDate date] addTimeInterval:-timeZoneOffset]; // NOTE the "-" sign!
	// for iphone 4 should use dateByAddingTimeInterval in place of addTimeInterval
	
	NSString *dtgmt = [NSString stringWithFormat:@"%@", gmtDate];
	NSLog(@"gmt date: %@", dtgmt);*/
	//*********************************

	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];

	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	gbluserid = [arrayForUserID objectAtIndex:0];
	[myArray release];
	
	NSLog(@"LV Sending....");
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&distance=%@&eventflag=%@&eventsubflag=%@",@"getevents",gbllatitude,gbllongitude,gbluserid,usertime,@"0",eventflg,eventsubflg];
	urlString = [globalUrlString stringByAppendingString:urlString];
	
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//return successflg;
	[pool release];
}

- (void)parseXMLFileAtURL:(NSString *)URL {
	
	// added by pradeep on 19 may 2011
	if (stories)
	{
		[stories release];
		[stories4sponevent release];
		[stories4useraddfeature release];
		[usercurrentlocationdeep release];
		[stories4usercurrentlocation4springboard release];
		[rssParser release];
	}
	// end 19 may 2011
	
	stories = [[NSMutableArray alloc] init];
	stories4sponevent = [[NSMutableArray alloc] init];
	stories4useraddfeature = [[NSMutableArray alloc] init];
	usercurrentlocationdeep = [[NSMutableArray alloc] init];
	
	// added by pradeep on 18 dec 2010 for user location on springboard
	//***** start 18 dec 2010
	stories4usercurrentlocation4springboard = [[NSMutableArray alloc] init];
	//***** end 18 dec 2010
	
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
	
	// commented and added by pradeep on 25 july 2011 for fixing issue syncronization failed message display multiple times
	
	/*
	 NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down."];
	 NSLog(@"error parsing XML: %@", errorString);
	 alertFrom=0;
	 UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	 [errorAlert show];
	 [errorAlert release]; 
	*/ 
	
	if (!issyncfailedmsgdisplayed)
	{
		issyncfailedmsgdisplayed = TRUE;
		NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down."];
		NSLog(@"error parsing XML: %@", errorString);
		alertFrom=0;
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];	
	}
	
	// end 25 july 2011 for fixing issue syncronization failed message display multiple times
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) {
		
		// added by pradeep on 19 may 2011
		if (item)
		{
			// added by pradeep on 19 may 2011 for releasing objects
			[item release];
			[eventid release];
			[eventname release];
			[eventdesc release];
			[eventaddress release];
			[eventindustry release];
			[eventdate release];
			[eventdateto release];
			[fromtime release];
			
			[totime release];
			[eventcontact release];
			[eventwebsite release];
			[eventlatitude release];
			[eventlongitude release];
			[isrecurring release];
			[eventcurrentdistance release];
			[eventtype release];
			// end 19 may 2011
		}
		
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		eventid = [[NSMutableString alloc] init];
		eventname= [[NSMutableString alloc] init];
		eventdesc = [[NSMutableString alloc] init];
		eventaddress = [[NSMutableString alloc] init];
		eventindustry = [[NSMutableString alloc] init];
		eventdate = [[NSMutableString alloc] init];
		eventdateto = [[NSMutableString alloc] init];
		fromtime = [[NSMutableString alloc] init];
		
		totime = [[NSMutableString alloc] init];
		eventcontact = [[NSMutableString alloc] init];
		eventwebsite = [[NSMutableString alloc] init];
		eventlatitude = [[NSMutableString alloc] init];
		eventlongitude = [[NSMutableString alloc] init];
		isrecurring = [[NSMutableString alloc] init];
		eventcurrentdistance = [[NSMutableString alloc] init];
		eventtype = [[NSMutableString alloc] init];
	}
	if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}
	
	if ([elementName isEqualToString:@"item2"]) 
	{
		// added by pradeep on 19 may 2011 for releasing objects
		if (item4sponevent)
		{
			[item4sponevent release];
			[sponeventexist release];
			[totsponevents release];
		}
		// end 19 may 2011
		
		item4sponevent = [[NSMutableDictionary alloc] init];
		sponeventexist = [[NSMutableString alloc] init];
		// added by pradeep on 22 sep 2010 for checking total spon events and if it will be 1 then we have to open splash directly on click of "Live" on springboard;
		totsponevents = [[NSMutableString alloc] init];
	}
	if ([elementName isEqualToString:@"item3"]) 
	{
		// added by pradeep on 19 may 2011 for releasing objects
		if (item4useraddfeature)
		{
			[item4useraddfeature release];
			[useraddfeaturevalue release];			
		}
		// end 19 may 2011
		
		item4useraddfeature = [[NSMutableDictionary alloc] init];
		useraddfeaturevalue = [[NSMutableString alloc] init];
	}
	// added by pradeep on 18 dec 2010 for user location on springboard
	//***** start 18 dec 2010
	if ([elementName isEqualToString:@"item4"]) 
	{
		// added by pradeep on 19 may 2011 for releasing objects
		if (item4usercurrentlocation4springboard)
		{
			[item4usercurrentlocation4springboard release];
			[usercurrentlocation4springboard release];			
		}
		// end 19 may 2011
		
		item4usercurrentlocation4springboard = [[NSMutableDictionary alloc] init];
		usercurrentlocation4springboard = [[NSMutableString alloc] init];
	}
	//***** end 18 dec 2010
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		// save values to an item, then store that item into the array...

		[item setObject:eventid forKey:@"guid"];
		[item setObject:eventname forKey:@"eventname"]; 
		[item setObject:eventdesc forKey:@"eventdescription"]; // for blog description also date but not rite now
		[item setObject:eventaddress forKey:@"eventaddress"];
		
		[item setObject:eventindustry forKey:@"eventindustry"];
		[item setObject:eventdate forKey:@"eventdate"];
		[item setObject:eventdateto forKey:@"eventdateto"];
		[item setObject:fromtime forKey:@"fromtime"];
		[item setObject:totime forKey:@"totime"];
		[item setObject:eventcontact forKey:@"eventcontact"];
		[item setObject:eventwebsite forKey:@"eventwebsite"];
		[item setObject:eventlongitude forKey:@"eventlongitude"];
		[item setObject:eventlatitude forKey:@"eventlatitude"];
		
		[item setObject:isrecurring forKey:@"isrecurring"];
		[item setObject:eventcurrentdistance forKey:@"currentdistance"];
		[item setObject:eventtype forKey:@"eventtype"];
		[item setObject:currentImageURL forKey:@"eventurl"];
		
		//add the actual image as well right now into the stories array
		
		/*NSURL *url = [NSURL URLWithString:currentImageURL];		
		NSString *searchForMe = @"images.png";
		NSRange range = [currentImageURL rangeOfString:searchForMe];// [searchThisString rangeOfString : searchForMe];
		// if image exist for user then use it else use default img locally for event
		if (range.location == NSNotFound) 
		{
			NSLog(@"Thumbnail Image exist for this event.");
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *y1 = [[UIImage alloc] initWithData:data];
			if (y1) {
				[item setObject:y1 forKey:@"itemPicture"];		
			}
		}
		else
		{
			UIImage *y1 = [UIImage imageNamed: @"dashnoevent.png"];;
			//if (y1) {
			[item setObject:y1 forKey:@"itemPicture"];	
		}*/
		
		[stories addObject:[item copy]];
		NSLog(@"adding story: %@", eventname);		
	}
	if ([elementName isEqualToString:@"item2"]) 
	{
		[item4sponevent setObject:sponeventexist forKey:@"sponeventexist"]; 
		// added by pradeep on 22 sep 2010 for checking total spon events and if it will be 1 then we have to open splash directly on click of "Live" on springboard;
		[item4sponevent setObject:totsponevents forKey:@"totsponevents"]; 
		
		[stories4sponevent addObject:[item4sponevent copy]];
	}
	if ([elementName isEqualToString:@"item3"]) 
	{
		[item4useraddfeature setObject:useraddfeaturevalue forKey:@"useraddfeaturevalue"]; 
		[stories4useraddfeature addObject:[item4useraddfeature copy]];
	}
	// added by pradeep on 18 dec 2010 for user location on springboard
	//***** start 18 dec 2010
	if ([elementName isEqualToString:@"item4"]) 
	{
		[item4usercurrentlocation4springboard setObject:usercurrentlocation4springboard forKey:@"usercurrentlocation4springboard"]; 
		[stories4usercurrentlocation4springboard addObject:[item4usercurrentlocation4springboard copy]];
		//NSLog(@"stories4usercurrentlocation4springboard -%@", [stories4usercurrentlocation4springboard objectAtIndex:0]);
	}
	//***** end 18 dec 2010
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

	// save the characters for the current item...
	if ([currentElement isEqualToString:@"guid"]) {
		[eventid appendString:string];
	}else if ([currentElement isEqualToString:@"eventname"]) {
		[eventname appendString:string];
	}else if ([currentElement isEqualToString:@"eventdescription"]) {
		[eventdesc appendString:string];
	}else if ([currentElement isEqualToString:@"eventaddress"]) {
		[eventaddress appendString:string];
	}else if ([currentElement isEqualToString:@"eventaddress"]) {
		[eventaddress appendString:string];
	}else if ([currentElement isEqualToString:@"eventindustry"]) {
		[eventindustry appendString:string];
	}else if ([currentElement isEqualToString:@"eventdate"]) {
		[eventdate appendString:string];
	}else if ([currentElement isEqualToString:@"eventdateto"]) {
		[eventdateto appendString:string];
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
	}else if ([currentElement isEqualToString:@"sponeventexist"]) {
		[sponeventexist appendString:string];
	}else if ([currentElement isEqualToString:@"totsponevents"]) {
		[totsponevents appendString:string];
	}else if ([currentElement isEqualToString:@"useraddfeaturevalue"]) {
		[useraddfeaturevalue appendString:string];
	}
	// added by pradeep on 18 dec 2010 for user location on springboard
	//***** start 18 dec 2010
	else if ([currentElement isEqualToString:@"usercurrentlocation4springboard"]) {
		NSLog(@"here is cur loc %@:", string);
		[usercurrentlocation4springboard appendString:string];
		if ([usercurrentlocationdeep count] == 0)
			[usercurrentlocationdeep addObject:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {		
	
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	//[itemTableView reloadData];
	
}
		
+ (BOOL) isFileExist: (NSString *) filename
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if([fileManager fileExistsAtPath:path]) {
			return YES;
		}
		else {
			
			return NO;
		}
	}

- (void) getTabs {
	NSMutableDictionary *items = [[NSMutableDictionary alloc] init];
	
	// added by pradeep on 19 may 2011
	if (springBoardTabsAry)
		[springBoardTabsAry release];
	// end 19 may 2011
	
	springBoardTabsAry = [[NSMutableArray alloc] init];
	
	// added by pradeep on 7 june 2011
	NSLog(@"1 worked till here for getTabs");
	
	// for getting intended events for springboard's tab. It will provide only upcoming intended events
	[self getEventData:@"intendedevents" :@""];
		
	for (cntTotTabs=0; cntTotTabs < 11; cntTotTabs++) // 7
	{
		if (cntTotTabs==0)
		{
			[items setObject:@"PEOPLE" forKey:@"title"];
			[items setObject:@"bundle://dashpeople.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];			
			[items setObject:@"NO" forKey:@"candelete"];
		}
		else if (cntTotTabs==1)
		{
			[items setObject:@"EVENTS" forKey:@"title"];
			[items setObject:@"bundle://dashevents.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];
		}
		else if (cntTotTabs==2)
		{
			[items setObject:@"INBOX" forKey:@"title"];
			[items setObject:@"bundle://dashmail.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];
		}
		else if (cntTotTabs==3)
		{
			[items setObject:@"PROFILE" forKey:@"title"];
			[items setObject:@"bundle://dashprofile.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];
		}
		else if (cntTotTabs==4)
		{
			[items setObject:@"SEARCH" forKey:@"title"];
			[items setObject:@"bundle://dashsearch.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];
		}		
			// adding AutoTag here 18 Dec Vaibhav
		else if (cntTotTabs==5)
		 {
		 [items setObject:@"TAGGED" forKey:@"title"];
		 [items setObject:@"bundle://dashtagged.png" forKey:@"image"];
		 [items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
		 [items setObject:@"NO" forKey:@"candelete"];
		 }
			// adding Invite here 24 Dec Vaibhav
		else if (cntTotTabs==6)
		{
			[items setObject:@"INVITE" forKey:@"title"];
			[items setObject:@"bundle://dashadd.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];			
		}
		// added by pradeep on 9 june 2011 for a new springboard item "MY EVENTS"
		else if (cntTotTabs==7)
		{
			[items setObject:@"MY EVENTS" forKey:@"title"];
			[items setObject:@"bundle://myevents_ribbon.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];			
		}
		// end by pradeep on 9 june 2011 for a new springboard item "MY EVENTS" which is associated with intended events and code/keywords of events
		
		// added by pradeep on 15 july 2011 for a new springboard item "MY NOTES"
		else if (cntTotTabs==8)
		{
			[items setObject:@"MY NOTES" forKey:@"title"];
			[items setObject:@"bundle://mynotes.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];			
		}
		// end by pradeep on 15 july 2011 for a new springboard item "MY NOTES" which is associated with user's notes
		
			// adding TIPS here 24 Dec Vaibhav
		else if (cntTotTabs==9)
		{
			[items setObject:@"TIPS" forKey:@"title"];
			[items setObject:@"bundle://tips.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];			
		}
			// adding INFO here 24 Dec Vaibhav
		else if (cntTotTabs == 10)
		{
			[items setObject:@"INFO" forKey:@"title"];
			[items setObject:@"bundle://info.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];			
		}
		
		// ******************************** on 21 October by pradeep
		
		/*else if (cntTotTabs==5)
		 {
		 [items setObject:@"LIVE" forKey:@"title"];
		 [items setObject:@"bundle://dashlive.png" forKey:@"image"];
		 [items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
		 [items setObject:@"NO" forKey:@"candelete"];
		 		 
		 }*/
		
		//********************************* on 21 October by pradeep for adding "LIVE" btn on spring board permanently
		
		/*else if (cntTotTabs==5)
		{
			[items setObject:@"UNSOCIAL MILES" forKey:@"title"];
			[items setObject:@"bundle://dashnoevent.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];
		}*/
		/*else if (cntTotTabs==6)
		{
			[items setObject:@"LIVE" forKey:@"title"];
			[items setObject:@"bundle://dashlive.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];
			
			//[items setObject:@"ADD" forKey:@"title"];
			//[items setObject:@"bundle://dashadd.png" forKey:@"image"];
			//[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			//[items setObject:@"NO" forKey:@"candelete"];
		}*/
		[springBoardTabsAry addObject:[items copy]];
	}
	
	/*if ([stories4sponevent count] > 0)
	{		
		cntTotTabs++;
		[items setObject:@"LIVE" forKey:@"title"];
		[items setObject:@"bundle://dashlive.png" forKey:@"image"];
		[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
		[items setObject:@"NO" forKey:@"candelete"];
		
		[springBoardTabsAry addObject:[items copy]];
	}*/
	
	
	// removing the "ADD" tab from spring board according to icheena request id 251 by pradeep on 21 October 2010
	//************************
	
	/*if ([stories4useraddfeature count] > 0)
	{
		NSString *strfeaturevalue = [[stories4useraddfeature objectAtIndex:0] objectForKey:@"useraddfeaturevalue"];
		NSString *featurevalue4unsocialmiles = [strfeaturevalue substringWithRange:NSMakeRange(0, 1)];
		int intSwitch1 = [featurevalue4unsocialmiles integerValue];
		
		NSString *featurevalue4livenow = [strfeaturevalue substringWithRange:NSMakeRange(1, 1)];
		int intSwitch2 = [featurevalue4livenow integerValue];
		
		if (intSwitch1==1)
		{
			cntTotTabs++;
			[items setObject:@"MILES" forKey:@"title"];
			[items setObject:@"bundle://dashmiles.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];
			
			[springBoardTabsAry addObject:[items copy]];
		}
		if ([stories4sponevent count] > 0)
		if (intSwitch2==1)
		{
			cntTotTabs++;
			[items setObject:@"LIVE" forKey:@"title"];
			[items setObject:@"bundle://dashlive.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];
			
			[springBoardTabsAry addObject:[items copy]];
		}
	}*/
	
	// removing the "ADD" tab from spring board according to icheena request id 251 by pradeep on 21 October 2010
	//************************
	
	// searching for digitalbilboard and videoad files on device, if find any/both then add tabs accordingly in the springboard
	
	// commented digitalbillboard and video by pradeep on 28 July 2010 according to latest request in icheena ID 20
	/*if ([LauncherViewTestController isFileExist:@"billboard.jpg"])
	{
		cntTotTabs++;
		[items setObject:@"Digital Billboard" forKey:@"title"];
		[items setObject:@"bundle://dashboardIconBack.png" forKey:@"image"];
		[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
		[items setObject:@"NO" forKey:@"candelete"];
		
		[springBoardTabsAry addObject:[items copy]];
	}
	if ([LauncherViewTestController isFileExist:@"settingsinfo4UnsocialVideo"])
	{
		cntTotTabs++;
		[items setObject:@"Video Ad" forKey:@"title"];
		[items setObject:@"bundle://dashboardIconBack.png" forKey:@"image"];
		[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
		[items setObject:@"NO" forKey:@"candelete"];
		
		[springBoardTabsAry addObject:[items copy]];
	}*/
	
	
	
	// replacing the "ADD" tab of spring board according to icheena request ID 23 added by PRadeep on 28 july 2010
	
	// removing the "ADD" tab from spring board according to icheena request id 251 by pradeep on 21 October 2010
	//************************
	/*{
		cntTotTabs++;
		[items setObject:@"ADD" forKey:@"title"];
		[items setObject:@"bundle://dashadd.png" forKey:@"image"];
		[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
		[items setObject:@"NO" forKey:@"candelete"];
		
		[springBoardTabsAry addObject:[items copy]];
	}*/
	
	//******************
	
	// for filling array for intended events
	
	// added by pradeep on 7 june 2011
	NSLog(@"2 worked till here for getTabs");
	
	for (int i=0; i < [stories count]; i++)
	{
		cntTotTabs++;
		// added by pradeep on 8 sep 2010 for fixing overlap intended events on spring board's border
		NSString *strevntnm = [NSString stringWithFormat:@"%@",[[[stories objectAtIndex:i] objectForKey:@"eventname"] uppercaseString]];
		int length = [strevntnm length];
		if (length > 10)
		{
			strevntnm = [[strevntnm substringWithRange: NSMakeRange (0, 9)] stringByAppendingString:@"..."];
			//[strevntnm stringByAppendingString:@"..."];
		}

		[items setObject:strevntnm forKey:@"title"];
		//[items setObject:[[[stories objectAtIndex:i] objectForKey:@"eventname"] uppercaseString] forKey:@"title"];
		//[items setObject:[[stories objectAtIndex:i] objectForKey:@"eventurl"] forKey:@"image"];
		
		
		//******************* commented by pradeep on 10 feb 2011 for changing intended event's images on spring board to our new decided images
		//[items setObject:@"bundle://dashnoevent.png" forKey:@"image"];
		
		//******************* added by pradeep on 10 feb 2011 for changing intended event's images on spring board to our new decided images
		
		// added by pradeep on 10 feb 2011 for changing images according to event industry
		
		if ([[[stories objectAtIndex:i] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
		{
			[items setObject:@"bundle://dashlive.png" forKey:@"image"];
		}
		else 
		{
			if ([[[stories objectAtIndex:i] objectForKey:@"eventindustry"] isEqualToString:@"Business"])
			{
				[items setObject:@"bundle://business.png" forKey:@"image"];
			}
			else if ([[[stories objectAtIndex:i] objectForKey:@"eventindustry"] isEqualToString:@"Social"])
			{
				[items setObject:@"bundle://social.png" forKey:@"image"];
			}
			else if ([[[stories objectAtIndex:i] objectForKey:@"eventindustry"] isEqualToString:@"Technology"])
			{
				[items setObject:@"bundle://technology.png" forKey:@"image"];
			}
			else {
				[items setObject:@"bundle://dashevents.png" forKey:@"image"];
			}
		}
		
		// ********* end 10 feb 2011
		
		//******************* end by pradeep on 10 feb 2011
		
		[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",cntTotTabs+1]]  forKey:@"URL"];
		[items setObject:@"NO" forKey:@"candelete"];
		
		[springBoardTabsAry addObject:[items copy]];
	}
	//if ([stories4useraddfeature count] == 0)
	
	[items release];
	
	// added by pradeep on 7 june 2011
	NSLog(@"3 worked till here for getTabs");
		
}

- (void)reLoadLauncherView {
	//_launcherView = [[TTLauncherView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 103)];//
	//_launcherView.backgroundColor = [UIColor grayColor];
	_launcherView.delegate = self;
	_launcherView.columnCount = 3;
	//_launcherView.columnCount = 2;
	
	
	[self getTabs];
	
	int totitem = [springBoardTabsAry count];
	int totpage = (totitem%9==0)?(totitem/9):((totitem/9)+1);
	int cnt4innerloop1 = 0, cnt4innerlooplast = 0;
	if (totitem%9==0)
	{
		cnt4innerloop1 = 9;
		cnt4innerlooplast = 9;
	}
	else 
	{
		if (totitem < 9)
		{
			cnt4innerloop1 = totitem%9;
			cnt4innerlooplast = totitem%9;
		}
		else {
			cnt4innerloop1 = 9;
			cnt4innerlooplast = totitem%9;
		}
		
	}
	
	NSMutableArray *ary2 = [[NSMutableArray alloc] init];
	int cntpg=0;	
	int temptotitem = 0;
	int cnt4filleditem = 0;
	
	for (int i=0; i<totpage; i++)
	{
		cntpg++;
		NSLog(@"Hello");
		NSMutableArray *ary1 = [[NSMutableArray alloc] init];
		
		if (cntpg < totpage)
			temptotitem = cnt4innerloop1;
		else temptotitem = cnt4innerlooplast;
		
		
		for (int j=0; j < temptotitem; j++) 
		{				
			//[ary1 addObject:[[[TTLauncherItem alloc] initWithTitle:@"PEOPLE" image:@"bundle://tabbar_people.png" URL:@"fb://item1" canDelete:YES] autorelease]];
			BOOL candelete;
			//if([[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"candelete"] compare:@"YES"] == NSOrderedSame)
			//			if(j < 7)
			candelete = NO;
			//			else candelete = YES;
			[ary1 addObject:[[[TTLauncherItem alloc] initWithTitle:[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"title"] image:[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"image"] URL:[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"URL"] canDelete:candelete] autorelease]];
			cnt4filleditem++;
		}
		[ary2 addObject:ary1];
		_launcherView.pages = ary2;
		
		// on 19 may 2011 by pradeep
		[ary1 release];
	}
	
	// on 19 may 2011 by pradeep
	[ary2 release];
	
	//*********************************
	
	/*int totitem = [springBoardTabsAry count];
	int totpage = (totitem%4==0)?(totitem/4):((totitem/4)+1);
	int cnt4innerloop1 = 0, cnt4innerlooplast = 0;
	if (totitem%4==0)
	{
		cnt4innerloop1 = 4;
		cnt4innerlooplast = 4;
	}
	else 
	{
		if (totitem < 4)
		{
			cnt4innerloop1 = totitem%4;
			cnt4innerlooplast = totitem%4;
		}
		else {
			cnt4innerloop1 = 4;
			cnt4innerlooplast = totitem%4;
		}
		
	}
	
	NSMutableArray *ary2 = [[NSMutableArray alloc] init];
	int cntpg=0;	
	int temptotitem = 0;
	int cnt4filleditem = 0;
	
	for (int i=0; i<totpage; i++)
	{
		cntpg++;
		NSLog(@"Hello");
		NSMutableArray *ary1 = [[NSMutableArray alloc] init];
		
		if (cntpg < totpage)
			temptotitem = cnt4innerloop1;
		else temptotitem = cnt4innerlooplast;
		
		
		for (int j=0; j < temptotitem; j++) 
		{				
			//[ary1 addObject:[[[TTLauncherItem alloc] initWithTitle:@"PEOPLE" image:@"bundle://tabbar_people.png" URL:@"fb://item1" canDelete:YES] autorelease]];
			BOOL candelete;
			//if([[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"candelete"] compare:@"YES"] == NSOrderedSame)
			//			if(j < 7)
			candelete = NO;
			//			else candelete = YES;
			[ary1 addObject:[[[TTLauncherItem alloc] initWithTitle:[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"title"] image:[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"image"] URL:[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"URL"] canDelete:candelete] autorelease]];
			cnt4filleditem++;
		}
		[ary2 addObject:ary1];
		_launcherView.pages = ary2;
	}*/
	
	//*********************************
	
	CGRect springBoardFrame;
	springBoardFrame = CGRectMake(0, 80, 320, 320);
	
	_launcherView.frame =  springBoardFrame;//  [[TTLauncherView alloc] initWithFrame:springBoardFrame]; //CGRectMake(0.0, 0.0, 320, 103)];//
	
	
	
	[self.view addSubview:_launcherView];
	
	// commented by pradeep on 31 may 2011 and added below method
	/*TTLauncherItem* items = [_launcherView itemWithURL:@"fb://item3"];
	if (unreadmsg > 0)
		items.badgeNumber = unreadmsg;
	else items.badgeNumber = 0;*/
	
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// commented n added mainthread by pradeep on 7 june 2011
	//[NSThread detachNewThreadSelector:@selector(updateBadges4InboxNEventsAsync) toTarget:self withObject:nil];
	
	[self performSelectorOnMainThread:@selector(updateBadges4InboxNEventsAsync) withObject:nil waitUntilDone:NO];
	
	//[pool release];
}

- (void)loadView {
	
	[super loadView];
	
	if([lastVisitedFeature count] >0)
	{
		if ([[lastVisitedFeature objectAtIndex:0] isEqualToString:@"signin"] || [[lastVisitedFeature objectAtIndex:0] isEqualToString:@"signup"] || [[lastVisitedFeature objectAtIndex:0] isEqualToString:@"signinlinkedin"])
		{
			
			[self callspringboard];
		}
		else
		{
			//and now start your actual processing in background
			
			// added by pradeep on 16 may 2011 for resolving leeking issue for nsthread 
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			// 16 may 2011 end
			
			// commented by pradeep on 25 may 2011 for disabling splashexperience
			//[NSThread detachNewThreadSelector:@selector(createSplashExperience) toTarget:self withObject:nil];
			// end 25 may 2011 
								
			// commented by pradeep on 25 may 2011 for disabling splashexperience
			//[NSThread sleepForTimeInterval:3]; 
			// end 25 may 2011
			
			// added by pradeep on 16 may 2011 for resolving leeking issue for nsthread 
			
			// commented by pradeep on 25 may 2011 for disabling splashexperience
			//[pool release];
			// end 25 may 2011
			
			// end 16 may 2011
			
			// added by pradeep on 16 may 2011 for resolving leeking issue for nsthread 
			
			// commented by pradeep on 25 may 2011 for disabling splashexperience
			//pool = [[NSAutoreleasePool alloc] init];
			// end 25 may 2011
			
			// end 16 may 2011
			
			[NSThread detachNewThreadSelector:@selector(createSpringBoard) toTarget:self withObject:nil];
			// added by pradeep on 16 may 2011 for resolving leeking issue for nsthread 
			[pool release];
			// end 16 may 2011
			//[self callspringboard];
		}
	}
	else
	{
		// added if by pradeep on 11 feb 2011
		if (firsttimeload == 0)
		{
			// added by pradeep on 11 feb 2011
			firsttimeload = 1;
		
			//and now start your actual processing in background
			
			// added by pradeep on 16 may 2011 for resolving leeking issue for nsthread 
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			// 16 may 2011 end
			
			// commented by pradeep on 25 may 2011 for disabling splashexperience
			//[NSThread detachNewThreadSelector:@selector(createSplashExperience) toTarget:self withObject:nil];
			// end 25 may 2011
			
			// added by pradeep on 16 may 2011 for resolving leeking issue for nsthread 
			
			// commented by pradeep on 25 may 2011 for disabling splashexperience
			//[pool release];
			// end 25 may 2011
			
			// end 16 may 2011
			
			// commented by pradeep on 25 may 2011 for disabling splashexperience
			//[NSThread sleepForTimeInterval:3]; 
			// end 25 may 2011			
			
			// added by pradeep on 16 may 2011 for resolving leeking issue for nsthread 
			
			// commented by pradeep on 25 may 2011 for disabling splashexperience
			//pool = [[NSAutoreleasePool alloc] init];
			// end 25 may 2011
			
			// end 16 may 2011
			
			// commented by pradeep on 25 may 2011 for resolving issue status n user image disapeearing
			//[NSThread detachNewThreadSelector:@selector(createSpringBoard) toTarget:self withObject:nil];
			// end 25 may 2011
						
			// added by pradeep on 16 may 2011 for resolving leeking issue for nsthread 
			[pool release];
			// end 16 may 2011
			
		}
		// added by pradeep on 12 feb 2011 
		[self callspringboard];
	}
}

- (void) createSpringBoard
{
	NSLog(@"***** call create *** SpringBoard ***********");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  
	// This is where rest of your calls go - such as sending data to server/retrieving status stuff etc.
	
	//[NSThread sleepForTimeInterval:5];  
	[self performSelectorOnMainThread:@selector(callspringboard) withObject:nil waitUntilDone:NO];  
	
	//SplashScreen *ss = [[SplashScreen alloc] init];
	//[self.navigationController pushViewController:ss animated:NO];
	[pool release];
}

- (void) callspringboard
{
	// for background
	imgBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBackgrnd.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBackgrnd];
	// 19 may 2011 added by pradeep
	[imgBackgrnd release];
	
	// for background grid i.e. horizontal & vertical lines
	imgBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 85, 320, 320)];
	imgBackgrnd.image = [UIImage imageNamed:@"dashboardgrid.png"];
	[self.view addSubview:imgBackgrnd];
	// 19 may 2011 added by pradeep
	[imgBackgrnd release];
	
	if ([self getDataFromFile:@"settingsinfo4Unsocial"])
	{
		NSLog(@"get local data");
		//		[self getImageLocally];
//		[self getStatusFromFile];
	}
	else // if user has logged off last time
	{
		NSLog(@"get server data");
		[self getDataFromFile:@"userlogininfo"];
		NSLog(@"%@", [NSString stringWithFormat:@"Userid - %@",[arrayForUserID objectAtIndex:0]]);
		ActivityViewForLauncher *peoplesUserProfile = [[ActivityViewForLauncher alloc]init];
		peoplesUserProfile.strFrom = [arrayForUserID objectAtIndex:0];
		[self.navigationController pushViewController:peoplesUserProfile animated:YES];
		[peoplesUserProfile release];
	}
	
	_launcherView = [[TTLauncherView alloc] initWithFrame:CGRectMake(0.0, 80, 320, 320)];//
	_launcherView.delegate = self;
	_launcherView.columnCount = 3;
	
	[self getTabs];
	
	int totitem = [springBoardTabsAry count];
	int totpage = (totitem%9==0)?(totitem/9):((totitem/9)+1);
	int cnt4innerloop1 = 0, cnt4innerlooplast = 0;
	if (totitem%9==0)
	{
		cnt4innerloop1 = 9;
		cnt4innerlooplast = 9;
	}
	else 
	{
		if (totitem < 9)
		{
			cnt4innerloop1 = totitem%9;
			cnt4innerlooplast = totitem%9;
		}
		else {
			cnt4innerloop1 = 9;
			cnt4innerlooplast = totitem%9;
		}
		
	}
	
	NSMutableArray *ary2 = [[NSMutableArray alloc] init];
	int cntpg=0;	
	int temptotitem = 0;
	int cnt4filleditem = 0;
	
	// added by pradeep on 7 june 2011
	NSLog(@"1 worked till here for callspringboard");
	
	for (int i=0; i<totpage; i++)
	{
		cntpg++;
		NSLog(@"Hello");
		NSMutableArray *ary1 = [[NSMutableArray alloc] init];
		
		if (cntpg < totpage)
			temptotitem = cnt4innerloop1;
		else temptotitem = cnt4innerlooplast;
		
		
		for (int j=0; j < temptotitem; j++) 
		{				
			//[ary1 addObject:[[[TTLauncherItem alloc] initWithTitle:@"PEOPLE" image:@"bundle://tabbar_people.png" URL:@"fb://item1" canDelete:YES] autorelease]];
			BOOL candelete;
			//if([[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"candelete"] compare:@"YES"] == NSOrderedSame)
			//			if(j < 7)
			candelete = NO;
			//			else candelete = YES;
			[ary1 addObject:[[[TTLauncherItem alloc] initWithTitle:[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"title"] image:[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"image"] URL:[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"URL"] canDelete:candelete] autorelease]];
			cnt4filleditem++;
		}
		[ary2 addObject:ary1];
		_launcherView.pages = ary2;
		
		// on 19 may 2011 by pradeep
		[ary1 release];
		
		// added by pradeep on 7 june 2011
		NSLog(@"2 worked till here for callspringboard");
	}
	
	// on 19 may 2011 by pradeep
	[ary2 release];
	
	// added by pradeep on 7 june 2011
	NSLog(@"3 worked till here for callspringboard");
	
	//*********************************
	
	/*int totitem = [springBoardTabsAry count];
	 int totpage = (totitem%4==0)?(totitem/4):((totitem/4)+1);
	 int cnt4innerloop1 = 0, cnt4innerlooplast = 0;
	 if (totitem%4==0)
	 {
	 cnt4innerloop1 = 4;
	 cnt4innerlooplast = 4;
	 }
	 else 
	 {
	 if (totitem < 4)
	 {
	 cnt4innerloop1 = totitem%4;
	 cnt4innerlooplast = totitem%4;
	 }
	 else {
	 cnt4innerloop1 = 4;
	 cnt4innerlooplast = totitem%4;
	 }
	 
	 }
	 
	 NSMutableArray *ary2 = [[NSMutableArray alloc] init];
	 int cntpg=0;	
	 int temptotitem = 0;
	 int cnt4filleditem = 0;
	 
	 for (int i=0; i<totpage; i++)
	 {
	 cntpg++;
	 NSLog(@"Hello");
	 NSMutableArray *ary1 = [[NSMutableArray alloc] init];
	 
	 if (cntpg < totpage)
	 temptotitem = cnt4innerloop1;
	 else temptotitem = cnt4innerlooplast;
	 
	 
	 for (int j=0; j < temptotitem; j++) 
	 {				
	 //[ary1 addObject:[[[TTLauncherItem alloc] initWithTitle:@"PEOPLE" image:@"bundle://tabbar_people.png" URL:@"fb://item1" canDelete:YES] autorelease]];
	 BOOL candelete;
	 //if([[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"candelete"] compare:@"YES"] == NSOrderedSame)
	 //			if(j < 7)
	 candelete = NO;
	 //			else candelete = YES;
	 [ary1 addObject:[[[TTLauncherItem alloc] initWithTitle:[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"title"] image:[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"image"] URL:[[springBoardTabsAry objectAtIndex:cnt4filleditem] objectForKey:@"URL"] canDelete:candelete] autorelease]];
	 cnt4filleditem++;
	 }
	 [ary2 addObject:ary1];
	 _launcherView.pages = ary2;
	 }*/
	
	//*********************************
	
	CGRect springBoardFrame;
	//	if ([aryUsrStatus count] > 0)
	//	{
	//		if ([[aryUsrStatus objectAtIndex:0] compare:@""] != NSOrderedSame)
	//			springBoardFrame = CGRectMake(0, 80, 320, 320);
	//		else springBoardFrame = CGRectMake(0, 60, 320, 320);
	//	}
	//	else
	//	{
	springBoardFrame = CGRectMake(0, 85, 320, 323);
	//	}
	
	_launcherView.frame =  springBoardFrame;//  [[TTLauncherView alloc] initWithFrame:springBoardFrame]; //CGRectMake(0.0, 0.0, 320, 103)];//
	
	
	
	[self.view addSubview:_launcherView];
	
	// 19 may 2011 added by pradeep
	[_launcherView release];
}

- (void) updateStatusOnSave:(NSString *)uid:(NSString *)stsmsg {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	newPerson.strsetstatus = stsmsg;
	newPerson.userid = uid;
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4UnsocialStatus"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
	[userInfo release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTLauncherViewDelegate

- (void)btnSetStatus_Click {
	
	[UnsocialAppDelegate playClick];
	[_launcherView endEditing];
	TTPostController *postController = [[TTPostController alloc] init]; 
	postController.delegate = self; // self must implement the TTPostControllerDelegate protocol 
	self.popupViewController = postController; 
	postController.navigationItem.rightBarButtonItem.title = @"Save";
	postController.superController = self; // assuming self to be the current UIViewController 
	[postController showInView:self.view animated:YES]; 
	//[postController release]; 
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
	
	if(alertFrom == 1) // when user change his/her status then alertfrom=1 and this will call
	{
		
		if(buttonIndex == 0)
		{
			// below one line is added by pradeep on 5th Jan 2011
			alertFrom=0;
			[self openLinedInWebView:[strStatusText objectAtIndex:0]];
		}
	}
	// added by pradeep on 5th Jan 2011 for prompting user when he wqnt to log-out
	//****************** start 5th jan 2011
	else if(alertFrom == 2) // when user wants to logout from unsocial then alertfrom=2
	{
		
		if (buttonIndex == 0)
		{
			alertFrom=0;
		}
		else
		{
			alertFrom=0;
			[self logout_Click];
		}
	}
	//****************** end 5th jan 2011

}

- (BOOL) postController:	(TTPostController *) 	postController willPostText: (NSString *) text {
	
	text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	/*NSLog(@"Text: %@, Total Length %i", text, [text length]);
	
	if(text != nil) 
	{
		
		if([text length] > 140) 
		{
			
			NSLog(@"Total text length- %d", [text length]);
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Status message is too lengthy to submit." message:@"Maximum 140 characters accepted." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			[errorAlert show];
			return NO;
		}
		else 
		{
			return YES;
		}
	}
	else 
	{
		return NO;		
	}*/
	return YES;

}

/*- (void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result { 
	
	NSString *strForLinkedIn = [text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	[self startProcess:text];
	
	strStatusText = [[NSMutableArray alloc]init];
	[strStatusText addObject:strForLinkedIn];
	status.text = [[@"\"" stringByAppendingString:text] stringByAppendingString:@"\""];
}*/

- (void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result {
	
	text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *strForLinkedIn = [NSString stringWithFormat:@"%@", text];
    NSMutableArray *parts = [NSMutableArray arrayWithArray:[strForLinkedIn componentsSeparatedByString:@"\n"]];
    strForLinkedIn = [parts componentsJoinedByString:@"$"];
	
    strForLinkedIn = [strForLinkedIn stringByReplacingOccurrencesOfString:@" " withString:@"$"];
    [self startProcess:text];
	
	// added by pradeep on 19 may 2011
	if (strStatusText)
	{
		[strStatusText release];
	}
	strStatusText = [[NSMutableArray alloc]init];
    [strStatusText addObject:strForLinkedIn];
    status.text = [[@"\"" stringByAppendingString:text] stringByAppendingString:@"\""];
}


- (void)openLinedInWebView:(NSString *)strStatus {
	
	webViewForLinkedIn *wfl = [[webViewForLinkedIn alloc]init];
	wfl.status = strStatus;
	wfl.camefrom = @"UnsocialUpdateStatus";
	[self.navigationController pushViewController:wfl animated:YES];
	[wfl release];
}

- (void)startProcess:(NSString *)stsmsg {
	
	NSLog(@"%@", gbluserid);
	[self sendNowStatus:@"updatestatus":stsmsg];
//	[UnsocialAppDelegate getStatus2];
	[self reLoadLauncherView];
}

- (BOOL) sendNowStatus: (NSString *) flag:(NSString *)stsmsg {
	NSLog(@"Sending....");
	//NSData *imageData1;
	
	if([stsmsg length] > 200)
		stsmsg = [[stsmsg substringWithRange:NSMakeRange(0,199)] stringByAppendingString:@""];
	
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
	
	NSString *userstatus =@"";;
	
	if ([stsmsg compare:nil] == NSOrderedSame)
	userstatus = [NSString stringWithFormat:@"%@\r\n",@""];
	else userstatus = [NSString stringWithFormat:@"%@\r\n",stsmsg];
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	// added by pradeep on 19 may 2011
	[myArray release];
	
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
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"status\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	 [body appendData:[[NSString stringWithFormat:@"\r\n%@",userstatus] dataUsingEncoding:NSUTF8StringEncoding]];
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
		if (![key isEqualToString:@"Userid"])			
		{
			//userid = [dic objectForKey:key];
			
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				[self updateStatusOnSave:[dic objectForKey:key]:stsmsg];				
				NSLog(@"\n\n\n\n\n\n#######################-- post for status added successfully --#######################\n\n\n\n\n\n");
				successflg=YES;
				userid = [dic objectForKey:key];
				
				UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:@"Your status has been updated." message:@"Do you want to update your LinkedIn status also?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES", @"NO", nil];
				[saveAlert show];
				[saveAlert release];
				alertFrom = 1;
				break;
			}
		}
	}
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	
	// added by pradeep on 19 may 2011
	[returnString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

- (BOOL) sendForLogoff: (NSString *) flag:(NSString *)stsmsg { // for disabling Push notification if user used same device as last logged in then after loged off user will not get push notification
	NSLog(@"Sending requset for logoff....");
	//NSData *imageData1;
	
	
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
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	NSString *userstatus = @"";
	
	if ([stsmsg compare:nil] == NSOrderedSame)
		userstatus = [NSString stringWithFormat:@"%@\r\n",@""];
	else userstatus = [NSString stringWithFormat:@"%@\r\n",stsmsg];
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	// added by pradeep on 19 may 2011
	[myArray release];
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"devicetocken\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",deviceTocken] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
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
				NSLog(@"\n\n\n\n\n\n#######################-- device token has updated successfully --#######################\n\n\n\n\n\n");
				successflg=YES;
				userid = [dic objectForKey:key];
						
				break;
			}
		}
	}
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	// added by pradeep on 19 may 2011
	[returnString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)items {
	
	// commented and added by pradeep on 25 july 2011 for fixing issue syncronization failed message display multiple times
	issyncfailedmsgdisplayed = FALSE;
	// end by pradeep on 25 july 2011 for fixing issue syncronization failed message display multiple times
	
	[UnsocialAppDelegate playClick];
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	NSLog(@"%@", [NSString stringWithFormat:@"%@", items]);
	if ([items.title compare:@"PEOPLE"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://peoples"] applyAnimated:YES]];
		//peoples  = [[Peoples alloc]init];
		//[self.navigationController pushViewController:peoples animated:YES];
	}
	else if ([items.title compare:@"EVENTS"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://events"] applyAnimated:YES]];
		//		events  = [[EVENTS alloc]init];
		//		[self.navigationController pushViewController:events animated:YES];
	}
	else if ([items.title compare:@"INBOX"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://inbox"] applyAnimated:YES]];
		//		inBox  = [[InBox alloc]init];
		//		[self.navigationController pushViewController:inBox animated:YES];
	}
	else if ([items.title compare:@"PROFILE"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://settingstb"] applyAnimated:YES]];
		//		settingsTableView  = [[SettingsTableView alloc]init];
		//		[self.navigationController pushViewController:settingsTableView animated:YES];
	}
	else if ([items.title compare:@"MILES"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://unsocialmiles"] applyAnimated:YES]];
		//		tips  = [[Tips alloc]init];
		//		[self.navigationController pushViewController:tips animated:YES];
	}
	else if ([items.title compare:@"ADD"] == NSOrderedSame)
	{
		// for setting "LiveNow" switch will display on "AddExtraFeature" or not
		
		// added by pradeep on 19 may 2011
		if (aryIsLiveNowEventsExist)
			[aryIsLiveNowEventsExist release];
		
		aryIsLiveNowEventsExist = [[NSMutableArray alloc] init];
		if ([stories4sponevent count] > 0)
			[aryIsLiveNowEventsExist addObject:[NSString stringWithFormat:@"yes"]];
		else [aryIsLiveNowEventsExist addObject:[NSString stringWithFormat:@"no"]];
		
		if ([stories4useraddfeature count] > 0)
		{
		
		NSString *strfeaturevalue = [[stories4useraddfeature objectAtIndex:0] objectForKey:@"useraddfeaturevalue"];
		NSString *featurevalue4unsocialmiles = [strfeaturevalue substringWithRange:NSMakeRange(0, 1)];
		//int intSwitch1 = [featurevalue4unsocialmiles integerValue];
		
		NSString *featurevalue4livenow = [strfeaturevalue substringWithRange:NSMakeRange(1, 1)];
		//int intSwitch2 = [featurevalue4livenow integerValue];
		
		[aryIsLiveNowEventsExist addObject:[NSString stringWithFormat:@"%@",featurevalue4unsocialmiles]];
		[aryIsLiveNowEventsExist addObject:[NSString stringWithFormat:@"%@",featurevalue4livenow]];
		
		
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://addfeature"] applyAnimated:YES]];
		}
		//		tips  = [[Tips alloc]init];
		//		[self.navigationController pushViewController:tips animated:YES];
	}
	else if ([items.title compare:@"SEARCH"] == NSOrderedSame)
	{
		//*************************
		// commneted by pradeep on 24 july 2010 and added search in place of tags
		//[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://tags"] applyAnimated:YES]];
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://search"] applyAnimated:YES]];
		//**************************
		//		tags  = [[SEARCH alloc]init];
		//		[self.navigationController pushViewController:tags animated:YES];
	}
	else if ([items.title compare:@"TAGGED"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://peopleauto"] applyAnimated:YES]];
		/********* COMMENTED 18 DEC, REPLACEING BY AUTO TAGS
		// added by pradeep for "Live Start Logic" on 23 sep 2010
		startLogicSponSplashCameFrom = [[NSMutableArray alloc] init];
		int totsponevent = 0;
		if ([stories4sponevent count] > 0)
			totsponevent = [[[stories4sponevent objectAtIndex:0] objectForKey:@"totsponevents"] integerValue];
		if (totsponevent > 1)
		{
			[startLogicSponSplashCameFrom addObject:@"eventlist"];
			[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://sevents"] applyAnimated:YES]];
		}
		else 
		{
			[startLogicSponSplashCameFrom addObject:@"springboard"];
			[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://sponsoredsplash"] applyAnimated:YES]];
		}*/
		//		sponsoredEvents  = [[SponsoredEvents alloc]init];
		//		[self.navigationController pushViewController:sponsoredEvents animated:YES];
	}
	else if ([items.title compare:@"INVITE"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://peopleinvite"] applyAnimated:YES]];
	}
	// added by pradeep on 9 june 2011 for a new springboard item "MY EVENTS"	
	else if ([items.title compare:@"MY EVENTS"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://myevents"] applyAnimated:YES]];
	}
	// end 9 june 2011
	// added by pradeep on 15 july 2011 for a new springboard item "MY NOTES"	
	else if ([items.title compare:@"MY NOTES"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://mynotes"] applyAnimated:YES]];
	}
	// end 15 july 2011
	else if ([items.title compare:@"TIPS"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://tips"] applyAnimated:YES]];
	}
	else if ([items.title compare:@"INFO"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://info"] applyAnimated:YES]];
	}
	else if ([items.title compare:@"Digital Billboard"] == NSOrderedSame)
	{
		[lastVisitedFeature removeAllObjects];
		[lastVisitedFeature addObject:@"viewdigitalbillboard"];
		NSLog(@"%@", [lastVisitedFeature objectAtIndex:0]);
				[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://billboard"] applyAnimated:YES]];
		//		settings  = [[Settings alloc]init];
		//		[self.navigationController pushViewController:settings animated:YES];
	}
	else if ([items.title compare:@"Video Ad"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://video"] applyAnimated:YES]];
		//		viewVideo  = [[ViewVideo alloc]init];
		//		[self.navigationController pushViewController:viewVideo animated:YES];
	}
	
	else {
		for (int i=0; i < [stories count]; i++)
		{
			// added by pradeep on 8 sep 2010 for fixing overlap intended events on spring board's border
			NSString *strevntnm = [NSString stringWithFormat:@"%@", [[[stories objectAtIndex:i] objectForKey:@"eventname"] uppercaseString]];
			int length = [strevntnm length];
			if (length > 10)
			{
				strevntnm = [[strevntnm substringWithRange: NSMakeRange (0, 9)] stringByAppendingString:@"..."];
				//[strevntnm stringByAppendingString:@"..."];
			}
						
			if ([items.title compare:strevntnm] == NSOrderedSame)
			//if ([items.title compare:[[[stories objectAtIndex:i] objectForKey:@"eventname"] uppercaseString]] == NSOrderedSame)
			{
				// added by pradeep on 19 may 2011
				if (aryEventDetails)
					[aryEventDetails release];
				
				aryEventDetails = [[NSMutableArray alloc]init];
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"guid"]]; //0
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"eventname"]]; //1
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"eventdescription"]]; //2
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"eventaddress"]]; //3
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"eventindustry"]];//4
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"eventdate"]];//5
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"fromtime"]];//6
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"totime"]];//7
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"eventcontact"]];//8
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"eventwebsite"]];//9
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"isrecurring"]];//10
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"eventtype"]];//11
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"currentdistance"]];//12
				
				[aryEventDetails addObject:[NSString stringWithFormat:@"%i",0]]; // 13 comingfrom
				[aryEventDetails addObject:[NSString stringWithFormat:@"%i",0]]; // 14 fromwhichsegment
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"eventlongitude"]];//15
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"eventlatitude"]];//16
				
				// if statement added by pradeep on 3 feb 2011 for fixing issue 00157 on RTH
				if([[[stories objectAtIndex:i] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
				{
					[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"isrecurring"]];//17
				}
				else {
					
					// commented by pradeep on 10 feb 2011 for implementing (chaning) image for intended images
					//UIImage *eImage = [UIImage imageNamed: @"dashattendevent.png"];//[[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
					
					UIImage *eImage;
					
					//******************** added by pradeep on 2011 
					//******************* added by pradeep on 10 feb 2011 for changing intended event's images on spring board to our new decided images
					
					// added by pradeep on 10 feb 2011 for changing images according to event industry
					if ([[[stories objectAtIndex:i] objectForKey:@"eventindustry"] isEqualToString:@"Business"])
					{
						eImage = [UIImage imageNamed: @"business.png"];
					}
					else if ([[[stories objectAtIndex:i] objectForKey:@"eventindustry"] isEqualToString:@"Social"])
					{
						eImage = [UIImage imageNamed: @"social.png"];
					}
					else if ([[[stories objectAtIndex:i] objectForKey:@"eventindustry"] isEqualToString:@"Technology"])
					{
						eImage = [UIImage imageNamed: @"technology.png"];
					}
					else 
					{
						eImage = [UIImage imageNamed: @"dashevents.png"];
					}				
					
					// ********* end 10 feb 2011
					
					//******************* end by pradeep on 10 feb 2011
					//******************** end 10 feb 2011
					
					if(eImage)
						[aryEventDetails addObject:eImage];
					
				}

				// commented by pradeep on 3 feb 2011 for fixing issue 00157 on RTH
				/*
				 UIImage *eImage = [UIImage imageNamed: @"dashattendevent.png"];//[[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
				 
				 if(eImage)
				 [aryEventDetails addObject:eImage];
				 */
					
				
				[aryEventDetails addObject:[[stories objectAtIndex:i] objectForKey:@"eventdateto"]];//18
				
				// added by pradeep on 3 feb 2011 for resolving issue # 00157 on RTH
				if([[[stories objectAtIndex:i] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
				{
					// added by pradeep on 19 may 2011
					if (startLogicSponSplashCameFrom)
						[startLogicSponSplashCameFrom release];
					
					startLogicSponSplashCameFrom = [[NSMutableArray alloc] init];
					[startLogicSponSplashCameFrom addObject:@"springboard"];
					[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://sponsoredsplash"] applyAnimated:YES]];
				}
				else 
					[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://eventd"] applyAnimated:YES]];
			}		
		}
	}	
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
  [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] 
    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
    target:_launcherView action:@selector(endEditing)] autorelease] animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
		//[self.navigationItem setRightBarButtonItem:nil animated:YES];
	UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showAlertWhenLogout)];
	
	self.navigationItem.rightBarButtonItem = rightbtn;
	[rightbtn release];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	printf("Did begin editing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	printf("Did end editing\n");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	printf("Clearing Keyboard\n");
    return YES;
}


@end
