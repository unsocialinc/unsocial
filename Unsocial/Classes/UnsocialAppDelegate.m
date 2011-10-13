//
//  UnsocialAppDelegate.m
//  Unsocial
//
//  Created by vaibhavsaran on 03/05/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "UnsocialAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "GlobalVariables.h"
#import "Person.h"
#import "LauncherViewTestController.h"
#import "LauncherNewUserController.h"
#import "SplashScreen.h"
#import <CommonCrypto/CommonDigest.h>

// added by pradeep on 10 Jan 2011 for releasing used memory but it is not working perfectly and still shows low memory warning 
//#import <mach/mach.h>
//#import <mach/mach_host.h>

BOOL flg4autoupdatebadge;
NSInteger flglocationupdate=0;

BOOL didAppEnterBackGround;

@implementation UnsocialAppDelegate

@synthesize window, peoples, events, inBox, settings, biMeter, referrals, invites, milesOptions, about, settingsTableView, peopleautotagged;
@synthesize username, userid, locationManager;
@synthesize bestEffortAtLocation;

// 13 oct 2011


//- (void)applicationDidFinishLaunching:(UIApplication *)application
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	// Override point for customization after application launch
	//[window makeKeyAndVisible];

	NSLog(@"application launched with launchOptions");
	if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
		NSLog(@"application launched with launchOptions for location");	
		exit(0);
		return FALSE;
	}
	
	
	NSLog(@"Initiating remoteNoticationssAreActive");
	
	aryLoggedinUserName = [[NSMutableArray alloc] init];
	
	// *********** push notification code start
	
	NSLog(@"Registering for remote notifications"); 
	// added by pradeep 
	if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0)
		[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	
	//************ push notification code end
	
	[self addFeaturesToWindow];
	
	//[self processing];
	
	// added by pradeep on 10 may 2011 for performance issue
	gbllatitudeary = [[NSMutableArray alloc] initWithObjects: nil];
	gbllongitudeary = [[NSMutableArray alloc] initWithObjects: nil];
	
	//initializing arrays for all 3 segment under people tab
	stories4peoplearoundme = [[NSMutableArray alloc] init];
	stories4peoplemyinterest = [[NSMutableArray alloc] init];
	stories4peoplebookmark = [[NSMutableArray alloc] init];
	//[UnsocialAppDelegate sendNow:@"getunreadmsg":userid];
	
	// for implementing lazy img for people on 16 sep 2010 by pradeep
	//******************
	
	imageURLs4Lazyall = [[NSMutableArray alloc]init];
	imageURLs4Lazyauto = [[NSMutableArray alloc]init];
	imageURLs4Lazysaved = [[NSMutableArray alloc]init];
	
	//******************
	// for implementing lazy img for people on 16 sep 2010 by pradeep
	
	// end 10 may 2011
	
	
	//Also only do updates if application is active;
	
	if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive || [UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
		NSLog(@"Application is active, starting updates");
		[self startUpdates];
	}
	else {
		NSLog(@"Application is running in backgroud...., so exiting now....");
		//exit(0);
	}
	
	[window makeKeyAndVisible];	
	
	return TRUE;
	/*if ([self getDataFromFile])
	{
		//tabBarController.selectedIndex = 0;
		//people = [[People alloc] init];
		//[window addSubview:people.view];
		[self recalliflatlongnotset];
		//[self recall4UdateBadgeEvery5Min];
			
		
	}
	else 
	{
		//tabBarController.selectedIndex = 3;
		[self recalliflatlongnotset];
		//settings = [[Settings alloc] init];
		// [window addSubview:settings.view];
		//[window addSubview:[tabBarController view]];
		
	}	
	//initializing arrays for all 3 segment under people tab
	stories4peoplearoundme = [[NSMutableArray alloc] init];
	stories4peoplemyinterest = [[NSMutableArray alloc] init];
	stories4peoplebookmark = [[NSMutableArray alloc] init];
	//[UnsocialAppDelegate sendNow:@"getunreadmsg":userid];
		
	//***************** start three20 code
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	TTURLMap* map = navigator.URLMap;
	//[map from:@"*" toViewController:[TTWebController class]];
	
	//[SettingsTableView ifDataExists];
	//if(flagStep6 == 1)
	//BOOL isalreadysignedin = [LauncherViewTestController isFileExist:@"settingsinfo4Unsocial"];
	//if (isalreadysignedin)
	
	BOOL flg = [self getLocationLock];
	if ([self getDataFromFile])
	{
	ƒ	
		if (flg==FALSE)
		{
			[map from:@"tt://launcherTest" toViewController:[LauncherViewTestController class]];
			[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://launcherTest"]];
		}
		else {
			[map from:@"tt://locationlock" toViewController:[AppNotAvailable class]transition:1];
			[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://locationlock"]];
		}
	}
	else
	{
		if (flg==TRUE)
		{
			checklocation = 1;
		}
		//[map from:@"tt://launcherTest" toViewController:[SignIn class]];
		[map from:@"tt://welcome" toViewController:[WelcomeViewController class]];
		[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://welcome"]];
	}
	
	//[map from:@"tt://launcherTest" toViewController:[SplashScreen class]];
	//[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://launcherTest"]];
	

	[map from:@"*" toViewController:[TTWebController class]];
	[map from:@"tt://peoples" toModalViewController:[Peoples class]transition:1];
	[map from:@"tt://events" toModalViewController:[Events class]transition:1];
	[map from:@"tt://inbox" toModalViewController:[InBox class]transition:1];
	[map from:@"tt://settings" toModalViewController:[Settings class]transition:1];
	[map from:@"tt://settingstb" toModalViewController:[SettingsTableView class]transition:1];
	[map from:@"tt://unsocialmiles" toModalViewController:[MilesOptions class]transition:1];
	//*************************
	// commneted by pradeep on 24 july 2010 and added search in place of tags
	//[map from:@"tt://tags" toModalViewController:[Tags class]transition:1];
	[map from:@"tt://search" toModalViewController:[SearchViewControllerImproved class]transition:1];
	//*************************
	[map from:@"tt://sevents" toModalViewController:[SponsoredEvents class]transition:1];
	[map from:@"tt://billboard" toModalViewController:[SettingsStep5 class]transition:1];
	[map from:@"tt://video" toModalViewController:[ViewVideo class]transition:1];
	[map from:@"tt://eventd" toModalViewController:[EventDetails class]transition:1];
	[map from:@"tt://signup" toModalViewController:[SignUp class]transition:1];
	[map from:@"tt://signin" toModalViewController:[SignIn class]transition:1];
	[map from:@"tt://addfeature" toModalViewController:[AddExtraFeature class]transition:1];
	
	//***************
	[map from:@"tt://forgetpwd" toModalViewController:[ForgetPwd class]transition:1];	*/
}

/*-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
	
		
		if(buttonIndex == 0)
			NSLog(@"location lock ");
			
	
}*/

//****************************** added by pradeep on 21 Oct for handling background process

// added by pradeep on 17 may 2011 for implementing app shouldn't kill on home btn press

- (void) startUpdatesDuringApplicationDidBecomeActive
{

	// already have one.
	
    if (nil == locationManager)
		
        locationManager = [[CLLocationManager alloc] init];
		//self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	
	locationManager.delegate = self;
	
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;//kCLLocationAccuracyKilometer;
	
	
	
	// Set a movement threshold for new events
	
	locationManager.distanceFilter = kCLDistanceFilterNone; //500;	
	//[locationManager startUpdatingLocation];
	
	if (locationManager.locationServicesEnabled == NO)		
		
	{
		if (flglocationupdate==1)
			return;
		flglocationupdate =1;
		
		NSLog(@"don't allow location service seleted by user");
		
		[gbllatitudeary removeAllObjects];
		[gbllongitudeary removeAllObjects];
		// end 10 may 2011
		
		//gbldateary = [[NSMutableArray alloc] initWithObjects: nil];
		
		gbllatitude = [NSString stringWithFormat:@"%+.6f",locationManager.location.coordinate.latitude];// oldLocation.coordinate.latitude];
		//gbllatitude   = @"47.711411";//gbllongitude; //@"47.8779449"
		//gbllatitude   = @"37.3318621";//gbllongitude; //@"47.8779449"
		[gbllatitudeary addObject:gbllatitude];
		gbllongitude = [NSString stringWithFormat:@"%+.6f",locationManager.location.coordinate.longitude];//oldLocation.coordinate.longitude];
		//gbllongitude = @"-122.190647";//gbllatitude; // @"-122.1864364"
		//gbllongitude = @"-122.0299369";//gbllatitude; // @"-122.1864364"
		[gbllongitudeary addObject:gbllongitude];
		
		
		[self recalliflatlongnotset];
						
	}   
	else 
	{
		[locationManager startUpdatingLocation];
	}
	
}

// end 17 may 2011

- (void)applicationDidBecomeActive:(UIApplication *)application {
	
	// first execute this
	printf("applicationDidBecomeActive\n");
	
	printf("\nBecomeActive\n");
	
	
	
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	
	/*// Override point for customization after application launch
	[window makeKeyAndVisible];
	
	NSLog(@"Initiating remoteNoticationssAreActive");
	
	aryLoggedinUserName = [[NSMutableArray alloc] init];
	
	// *********** push notification code start
	
	NSLog(@"Registering for remote notifications"); 
	// added by pradeep 
	if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0)
		[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	
	//************ push notification code end
	
	[self addFeaturesToWindow];
	
	//[self processing];
	[self startUpdates];*/
	
	//[self recalliflatlongnotset];
	
	//[locationManager startUpdatingLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	printf("applicationDidEnterBackground\n");
	
	printf("\nback ground\n");
	/*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	
	// also set UIApplicationExitsOnSuspend as checked in info.plist file
	// for unsocial, earlier unsocial 1.5.0, it was checked but now for unsocial 1.6.0, set it as unchecked. 
	
	// commented by pradeep on 16 may 2011 for not killing app if user pressed home btn
	//exit(0);
	//return;
	
	// added by pradeep on 17 may 2011 for app status for background
	didAppEnterBackGround = TRUE;	
	
	// added by pradeep on 25 july 2011 for fixing issue syncronization failed message display multiple times
	issyncfailedmsgdisplayed = FALSE;
	// end 25 july 2011 issue syncronization failed message display multiple times
	
	// added by pradeep on 1 aug 2011 for fixing issue for launcherview, in which reloadData4LocationLabel calls 3 times
	isreloadData4LocationLabelCall = FALSE;
	// end 1 aug 2011 
	
}

- (void)applicationWillTerminate:(UIApplication *)application{
	printf("applicationWillTerminate method is being called.\n");
	
	/*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	
	// also set UIApplicationExitsOnSuspend as checked in info.plist file
	// for unsocial, earlier unsocial 1.5.0, it was checked but now for unsocial 1.6.0, set it as unchecked. 
	
	//exit(0);
	//return;
	
}

// added by pradeep on 16 may 2011 for basics of delegate

- (void)applicationWillResignActive:(UIApplication *)application {
	
	printf("\nResign\n");
	
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	printf("\nForeground\n");
	
	if (didAppEnterBackGround)
	{
		[self startUpdatesDuringApplicationDidBecomeActive];
		
	}
	
	/*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}

// end 16 may 2011


//****************************** added by pradeep on 21 Oct for handling background process




// *********** push notification code start

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSLog(@"deviceToken: %@", deviceToken); 
	NSString *dt=[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	NSLog(@"%@", dt);
	//NSString *reqString=[NSString stringWwithFormat:@"http://myserver/?dt=%@",dt];
	//[application openURL:[NSURL URLWithString:reqString]]; 
	devTocken = [[NSMutableArray alloc] init];
	[devTocken addObject:dt];
} 

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"Error in registration. Error: %@", error); 
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"user info %@", userInfo);
	
}

//******************************** location lock start

#pragma mark location lock
- (BOOL) getLocationLock 
{
	NSLog(@"Sending 4 getLocationLock....");
	//NSData *imageData1;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"locationlock"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	/*UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	NSString *varuserid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];*/
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
	NSLog(@"latitude: %@, longitude: %@", gbllatitude, gbllongitude);
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"flag\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",flg1] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];			
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"flag2\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",flg2] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	/*[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"devicetocken\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",deviceTocken] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varuserid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];*/
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	//we need an activity indicator here.	
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	BOOL retflg = FALSE;
	
	//[activityView startAnimating];
	
    NSHTTPURLResponse *response11;
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response11 error:nil];
	
	NSLog(@"response header: %@", [response11 allHeaderFields]);
	
	NSDictionary *dic = [response11 allHeaderFields];
	//BOOL successflg=NO;
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key compare:@"Locationlock"] == NSOrderedSame)			
		{
			if ([[dic objectForKey:key] compare:@"yes"] == NSOrderedSame)
			{
				NSLog(@"\n\n\n\n\n\n#######################-- app is locked for this location --#######################\n\n\n\n\n\n");				
				retflg = TRUE;
				break;
			}
		}
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(returnString);
	[returnString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
	[pool release];
	return retflg;
}

//******************************** location lock end


//************ push notification code end

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
	return YES;
}

+(BOOL)checkInternet:(NSString *)weburl {
	NSURL *url = [[NSURL alloc] initWithString:weburl];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	if ([NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil])
	{
		printf("Internet Available");
		[url release];
		[request release];
		return TRUE;
	}
	else
	{
		printf("Internet not Available");
		[url release];
		[request release];
		return FALSE;
	}
}

-(void) recalliflatlongnotset
{	
	if (gbllatitude	== nil)
	{		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		/*loading = [UnsocialAppDelegate createLabelControl:@"Refreshing\nPlease  Wait" frame:CGRectMake(25, 125, 280,  60) txtAlignment:UITextAlignmentCenter numberoflines:2  linebreakmode:UILineBreakModeWordWrap fontwithname:@"ArialRoundedMTBold"  fontsize:15 txtcolor:[UIColor darkGrayColor]  backgroundcolor:[UIColor clearColor]];
				
		imgBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 360)];//initWithImage:[UIImage  imageNamed:@"imgback.png"]];
		imgBack.image = [UIImage imageNamed:@"imgback.png"];
		imgBack.hidden = NO;

		[window addSubview:imgBack];
		
		activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150,  180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
		
		activityView.hidden = NO;
		loading.hidden = NO;
		
		[window addSubview:loading];
		[window addSubview:imgBack];
		[window addSubview:activityView];*/
		
		//gbllongitude = @"-122.190647";//gbllatitude; // @"-122.1864364"
		//gbllatitude   = @"47.711411";//gbllongitude; //@"47.8779449"
		
		NSLog(@"Infinite loop");
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		/*activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 260,18,18)];
		activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;	
		[window addSubview:activityView];
		[activityView startAnimating];*/
		sleep(5);
		[NSThread detachNewThreadSelector:@selector(recalliflatlongnotset) toTarget:self withObject:nil];
		//[self recalliflatlongnotset];
		[pool release];
	}
	else
	{		
		if ([self getDataFromFile])
		{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		/*activityView.hidden = YES;
		loading.hidden = YES;
		imgBack.hidden = YES;*/
		
//		[NSThread detachNewThreadSelector:@selector(sendNow) toTarget:self withObject:nil];
		flg4autoupdatebadge = TRUE;
		[pool release];
			
			aryUsrStatus = [[NSMutableArray alloc] init];			
			pool = [[NSAutoreleasePool alloc] init];
			/*activityView.hidden = YES;
			 loading.hidden = YES;
			 imgBack.hidden = YES;*/
			
			// // it will call only when user has already logged-in in unsocial app (i.e. user's local file exist). This method sends request to the server and manage userlocation table in DB accordingly
			[NSThread detachNewThreadSelector:@selector(getStatus) toTarget:self withObject:nil]; 
			[pool release];
		}
		else 
		{
			NSLog(@"Since user has logged off so, location hasn't updated - 17 may 2011 pradeep :-) ");
		}

	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//[pool release];
}

/*- (void) recall4UdateBadgeEvery5Min
{
	if (!flg4autoupdatebadge)
	{
		NSAutoreleasePool *pool1 = [[NSAutoreleasePool alloc] init];
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recall4UdateBadgeEvery5Min) userInfo:self repeats:NO];
		[pool1 release];	
	}
	else 
	{
		NSAutoreleasePool *pool1 = [[NSAutoreleasePool alloc] init];
		[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(sendNow) userInfo:self repeats:YES];
		[pool1 release];
	}		
}*/

//[NSThread detachNewThreadSelector:@selector(goButtonClicked) toTarget:self withObject:nil];
//[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createControls) userInfo:self.view repeats:NO];

// added by pradeep on 31 may 2011 for counting newly tagged users

+ (NSInteger)getNumberOfNewlyTaggedUsers {
	
	NSLog(@"Sending 4 NewlyTaggedUsers....");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];	
	
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"getnumberofnewlytaggedusers"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	NSString *varuserid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	[myArray release];
	
	// added by pradeep on 7 june 2011
	NSLog(@"1 worked till here for getNumberOfNewlyTaggedUsers");
	
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
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varuserid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	//we need an activity indicator here.	
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
    NSHTTPURLResponse *response11;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response11 error:nil];
	
	NSLog(@"response header: %@", [response11 allHeaderFields]);
	
	// added by pradeep on 7 june 2011
	NSLog(@"2 worked till here for getNumberOfNewlyTaggedUsers");
	
	NSDictionary *dic = [response11 allHeaderFields];
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Totnewlybadgedusers"])			
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				gblTotalNewlyTaggedUsers4Badge = [[dic objectForKey:key] intValue];				
				NSLog(@"\n\n\n\n\n\n#######################-- %i Newly Tagged Users Counted successfully --#######################\n\n\n\n\n\n",gblTotalNewlyTaggedUsers4Badge);
				if(gblTotalNewlyTaggedUsers4Badge != 0)
					break;
			}
		}
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	[returnString release];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
	[pool release];
	
	// added by pradeep on 7 june 2011
	NSLog(@"3 worked till here for getNumberOfNewlyTaggedUsers");
	
	return gblTotalNewlyTaggedUsers4Badge;
}

// end 31 may 2011



+ (NSInteger)getNumberOfPreEvents {
	
	NSLog(@"Sending 4 total premimun events....");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];	
	
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"getnumberofpremevents"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	[myArray release];
	
	// added by pradeep on 7 june 2011
	NSLog(@"1 worked till here for getNumberOfPreEvents");
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"flag\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",flg1] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];			
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"flag2\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",flg2] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
		// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
		// now lets make the connection to the web
		//we need an activity indicator here.	
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
    NSHTTPURLResponse *response11;
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response11 error:nil];
	
	NSLog(@"response header: %@", [response11 allHeaderFields]);
	
	NSDictionary *dic = [response11 allHeaderFields];
	
	// added by pradeep on 7 june 2011
	NSLog(@"2 worked till here for getNumberOfPreEvents");
	
	for (id key in dic)
	{
			// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Totalspevents"])			
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				gblTotalnumberofsponevents = [[dic objectForKey:key] intValue];				
				NSLog(@"\n\n\n\n\n\n#######################-- %i Events Counted successfully --#######################\n\n\n\n\n\n",gblTotalnumberofsponevents);
				if(gblTotalnumberofsponevents != 0)
					break;
			}
		}
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	[returnString release];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
	[pool release];
	return gblTotalnumberofsponevents;
	
	// added by pradeep on 7 june 2011
	NSLog(@"3 worked till here for getNumberOfPreEvents");
}

+ (void) sendNow4UnreadMessages {
	
	NSLog(@"Sending 4 getunreadmsg....");
	//NSData *imageData1;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"getunreadmsg"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	NSString *varuserid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
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
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varuserid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	//we need an activity indicator here.	
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//[activityView startAnimating];
	
    NSHTTPURLResponse *response11;
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response11 error:nil];
	
	NSLog(@"response header: %@", [response11 allHeaderFields]);
	
	NSDictionary *dic = [response11 allHeaderFields];
	BOOL successflg=NO;
	
	// added by pradeep on 7 june 2011
	NSLog(@"1 worked till here for sendunreadmsg");
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key compare:@"Totunreadmsg"] == NSOrderedSame)			
		{
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				NSLog(@"\n\n\n\n\n\n#######################-- Unread Message Counted successfully --#######################\n\n\n\n\n\n");
				unreadmsg = [[dic objectForKey:key] intValue];				
				successflg=YES;				
				//uid = [dic objectForKey:key];
				//NSString *strbadgevalue = [NSString stringWithFormat:@"%i", unreadmsg];
				if(unreadmsg != 0)
					//inBoxviewcontroller.tabBarItem.badgeValue = strbadgevalue;
				break;
			}
		}
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(returnString);
	[returnString release];
	
	// added by pradeep on 7 june 2011
	NSLog(@"2 worked till here for sendunreadmsg");
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//return unreadmsg;
	[pool release];
	
	// added by pradeep on 7 june 2011
	NSLog(@"3 worked till here for sendunreadmsg");
}

- (void) getStatus 
{
	NSLog(@"Sending 4 getStatus....");
	//NSData *imageData1;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"getstatus"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	NSString *varuserid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
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
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varuserid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	//we need an activity indicator here.	
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//[activityView startAnimating];
	
    NSHTTPURLResponse *response11;
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response11 error:nil];
	
	NSLog(@"response header: %@", [response11 allHeaderFields]);
	
	NSDictionary *dic = [response11 allHeaderFields];
	//BOOL successflg=NO;
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key compare:@"Status"] == NSOrderedSame)			
		{
			//if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				NSLog(@"\n\n\n\n\n\n#######################-- user status got successfully --#######################\n\n\n\n\n\n");
				if ([aryUsrStatus count] > 0)
					[aryUsrStatus removeAllObjects];
				[aryUsrStatus addObject:[dic objectForKey:key]];
				break;
			}
		}
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(returnString);
	[returnString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//return unreadmsg;
	[pool release];
}

+ (void) getStatus2 
{
	NSLog(@"Sending 4 getStatus ******************** \n ********************....");
	//NSData *imageData1;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"getstatus"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	NSString *varuserid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
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
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varuserid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	//we need an activity indicator here.	
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//[activityView startAnimating];
	
    NSHTTPURLResponse *response11;
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response11 error:nil];
	
	NSLog(@"response header: %@", [response11 allHeaderFields]);
	
	NSDictionary *dic = [response11 allHeaderFields];
	//BOOL successflg=NO;
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key compare:@"Status"] == NSOrderedSame)			
		{
			//if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				NSLog(@"\n\n\n\n\n\n#######################-- user status got successfully --#######################\n\n\n\n\n\n");
				if ([aryUsrStatus count] > 0)
					[aryUsrStatus removeAllObjects];
				[aryUsrStatus addObject:[dic objectForKey:key]];
				break;
			}
		}
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(returnString);
	[returnString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//return unreadmsg;
	[pool release];
}

- (void)startUpdates

{
	
    // Create the location manager if this object does not
	
    // already have one.
	
    if (nil == locationManager)
		
        //self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		locationManager = [[CLLocationManager alloc] init];
	
		locationManager.delegate = self;
		
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;//kCLLocationAccuracyKilometer;
		
		
		
		// Set a movement threshold for new events
		
	locationManager.distanceFilter = kCLDistanceFilterNone; //500;	
		//[locationManager startUpdatingLocation];
			
	if (locationManager.locationServicesEnabled == NO)		
	
	{
		if (flglocationupdate==1)
			return;
		flglocationupdate =1;
		
		NSLog(@"don't allow location service seleted by user");
		
		// commented by pradeep on 10 may 2011 for enhancing performance issue	
		//gbllatitudeary = [[NSMutableArray alloc] initWithObjects: nil];
		//gbllongitudeary = [[NSMutableArray alloc] initWithObjects: nil];
		// end 20 may 2011
		
		// added by pradeep on 10 may 2011 for enhancing performance issue
		[gbllatitudeary removeAllObjects];
		[gbllongitudeary removeAllObjects];
		// end 10 may 2011
		
		//gbldateary = [[NSMutableArray alloc] initWithObjects: nil];
		
		gbllatitude = [NSString stringWithFormat:@"%+.6f",locationManager.location.coordinate.latitude];// oldLocation.coordinate.latitude];
		//gbllatitude   = @"47.711411";//gbllongitude; //@"47.8779449"
		//gbllatitude   = @"37.3318621";//gbllongitude; //@"47.8779449"
		[gbllatitudeary addObject:gbllatitude];
		gbllongitude = [NSString stringWithFormat:@"%+.6f",locationManager.location.coordinate.longitude];//oldLocation.coordinate.longitude];
		//gbllongitude = @"-122.190647";//gbllatitude; // @"-122.1864364"
		//gbllongitude = @"-122.0299369";//gbllatitude; // @"-122.1864364"
		[gbllongitudeary addObject:gbllongitude];
		
		
		
		
		if ([self getDataFromFile])
		{
			//tabBarController.selectedIndex = 0;
			//people = [[People alloc] init];
			//[window addSubview:people.view];
			[self recalliflatlongnotset];
			//[self recall4UdateBadgeEvery5Min];
			
			
		}
		else 
		{
			//tabBarController.selectedIndex = 3;
			[self recalliflatlongnotset];
			//settings = [[Settings alloc] init];
			// [window addSubview:settings.view];
			//[window addSubview:[tabBarController view]];
			
		}
		
		// commented by pradeep on 10 may 2011 for enhancing performance issue
		/*
		//initializing arrays for all 3 segment under people tab
		stories4peoplearoundme = [[NSMutableArray alloc] init];
		stories4peoplemyinterest = [[NSMutableArray alloc] init];
		stories4peoplebookmark = [[NSMutableArray alloc] init];
		//[UnsocialAppDelegate sendNow:@"getunreadmsg":userid];
		
		// for implementing lazy img for people on 16 sep 2010 by pradeep
		//******************
		
		imageURLs4Lazyall = [[NSMutableArray alloc]init];
		imageURLs4Lazyauto = [[NSMutableArray alloc]init];
		imageURLs4Lazysaved = [[NSMutableArray alloc]init];
		
		//******************
		// for implementing lazy img for people on 16 sep 2010 by pradeep
		
		 */
		// end 10 may 2011
		
		//***************** start three20 code
		
		TTNavigator* navigator = [TTNavigator navigator];
		navigator.supportsShakeToReload = YES;
		navigator.persistenceMode = TTNavigatorPersistenceModeAll;
		
		TTURLMap* map = navigator.URLMap;
		//[map from:@"*" toViewController:[TTWebController class]];
		
		//[SettingsTableView ifDataExists];
		//if(flagStep6 == 1)
		//BOOL isalreadysignedin = [LauncherViewTestController isFileExist:@"settingsinfo4Unsocial"];
		//if (isalreadysignedin)
		BOOL flg = [self getLocationLock];
		if ([self getDataFromFile])
		{
			
			if (flg==FALSE)
			{
				[map from:@"tt://launcherTest" toViewController:[LauncherViewTestController class]];
				[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://launcherTest"]];
			}
			else {
				[map from:@"tt://locationlock" toViewController:[AppNotAvailable class]transition:1];
				[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://locationlock"]];
			}
		}
		else
		{
			if (flg==TRUE)
			{
				checklocation = 1;
			}
			//[map from:@"tt://launcherTest" toViewController:[SignIn class]];
			[map from:@"tt://welcome" toViewController:[WelcomeViewController class]];
			[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://welcome"]];
		}
		
		//[map from:@"tt://launcherTest" toViewController:[SplashScreen class]];
		//[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://launcherTest"]];
		
		
		[map from:@"*" toViewController:[TTWebController class]];
		[map from:@"tt://peoples" toModalViewController:[Peoples class]transition:1];
		[map from:@"tt://peopleauto" toModalViewController:[PeopleAutoTagged class]transition:1];
		[map from:@"tt://peopleinvite" toModalViewController:[InvitePeople class]transition:1];
		// added by pradeep on 9 june 2011 for a new springboard item "MY EVENTS"
		[map from:@"tt://myevents" toModalViewController:[MyEvents class]transition:1];
		// end 9 june 2011
		
		// added by pradeep on 15 july 2011 for a new springboard item "MY EVENTS"
		[map from:@"tt://mynotes" toModalViewController:[MyNotes class]transition:1];
		// end 15 july 2011
		
		[map from:@"tt://tips" toModalViewController:[ShowTips class]transition:1];
		[map from:@"tt://info" toModalViewController:[Info class]transition:1];
		[map from:@"tt://events" toModalViewController:[Events class]transition:1];
		[map from:@"tt://inbox" toModalViewController:[InBox class]transition:1];
		[map from:@"tt://settings" toModalViewController:[Settings class]transition:1];
		[map from:@"tt://settingstb" toModalViewController:[SettingsTableView class]transition:1];
		[map from:@"tt://unsocialmiles" toModalViewController:[MilesOptions class]transition:1];
		//*************************
		// commneted by pradeep on 24 july 2010 and added search in place of tags
		//[map from:@"tt://tags" toModalViewController:[Tags class]transition:1];
		[map from:@"tt://search" toModalViewController:[SearchViewControllerImproved class]transition:1];
		//*************************
		[map from:@"tt://sevents" toModalViewController:[SponsoredEvents class]transition:1];
		
		// added by pradeep for "Live Now Start Logic" on 22 sep 2010
		//*************************
		[map from:@"tt://sponsoredsplash" toModalViewController:[SponsoredSplash class]transition:1];
		[map from:@"tt://peoplelivenow" toViewController:[PeopleLiveNow class]];
		//*************************
		
		[map from:@"tt://billboard" toModalViewController:[SettingsStep5 class]transition:1];
		[map from:@"tt://video" toModalViewController:[ViewVideo class]transition:1];
		[map from:@"tt://eventd" toModalViewController:[EventDetails class]transition:1];
		[map from:@"tt://signup" toModalViewController:[SignUp class]transition:1];
		[map from:@"tt://signin" toModalViewController:[SignIn class]transition:1];
		[map from:@"tt://addfeature" toModalViewController:[AddExtraFeature class]transition:1];
		
		//***************
		[map from:@"tt://forgetpwd" toModalViewController:[ForgetPwd class]transition:1];
		
		//*****************************
		
	}   
	else {
		[locationManager startUpdatingLocation];
	}
	
}



// Delegate method from the CLLocationManagerDelegate protocol.

//it will be called when locationManager cannot receive any coordinates. Or when user don't allow to find current location.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	if (flglocationupdate==1)
		return;
	flglocationupdate =1;
		
	NSLog(@"don't allow location service seleted by user");
	NSLog(@"************* location fail *************");
	
	// commented by pradeep on 10 may 2011 for enhancing performance issue	
	//gbllatitudeary = [[NSMutableArray alloc] initWithObjects: nil];
	//gbllongitudeary = [[NSMutableArray alloc] initWithObjects: nil];
	// end 10 may 2011
	
	// added by pradeep on 10 may 2011 for enhancing performance issue
	[gbllatitudeary removeAllObjects];
	[gbllongitudeary removeAllObjects];
	// end 10 may 2011
	
	//gbldateary = [[NSMutableArray alloc] initWithObjects: nil];
	
	gbllatitude = [NSString stringWithFormat:@"%+.6f",locationManager.location.coordinate.latitude];// oldLocation.coordinate.latitude];
	//gbllatitude   = @"47.711411";//gbllongitude; //@"47.8779449"
	//gbllatitude   = @"37.7868940";// for trade tech event // @"37.3318621";//gbllongitude; //@"47.8779449"
	//gbllatitude = @"+28.565931"; // DELHI LOCATION
	//gbllatitude   = @"37.7681339"; // sanfransisco for discovery beat
	//gbllatitude   = @"47.6062095"; // seattle, wa for discovery beat
	[gbllatitudeary addObject:gbllatitude];
	gbllongitude = [NSString stringWithFormat:@"%+.6f",locationManager.location.coordinate.longitude];//oldLocation.coordinate.longitude];
	//gbllongitude = @"-122.190647";//gbllatitude; // @"-122.1864364"
	//gbllongitude = @"-122.4031010";// for trade tech event // @"-122.0299369";//gbllatitude; // @"-122.1864364"
	//gbllongitude = @"+77.216813"; // DELHI LOCATION
	//gbllongitude = @"-122.3939490"; // sanfransisco for discovery beat
	//gbllongitude = @"-122.3320708"; // seattle, wa for discovery beat
	[gbllongitudeary addObject:gbllongitude];
	
	
	
	
	if ([self getDataFromFile])
	{
		//tabBarController.selectedIndex = 0;
		//people = [[People alloc] init];
		//[window addSubview:people.view];
		[self recalliflatlongnotset];
		//[self recall4UdateBadgeEvery5Min];
		
		
	}
	else 
	{
		//tabBarController.selectedIndex = 3;
		[self recalliflatlongnotset];
		//settings = [[Settings alloc] init];
		// [window addSubview:settings.view];
		//[window addSubview:[tabBarController view]];
		
	}	
	
	// commented by pradeep on 10 may 2011 for enhancing performance issue
	/*
	 //initializing arrays for all 3 segment under people tab
	 stories4peoplearoundme = [[NSMutableArray alloc] init];
	 stories4peoplemyinterest = [[NSMutableArray alloc] init];
	 stories4peoplebookmark = [[NSMutableArray alloc] init];
	 //[UnsocialAppDelegate sendNow:@"getunreadmsg":userid];
	 
	 // for implementing lazy img for people on 16 sep 2010 by pradeep
	 //******************
	 
	 imageURLs4Lazyall = [[NSMutableArray alloc]init];
	 imageURLs4Lazyauto = [[NSMutableArray alloc]init];
	 imageURLs4Lazysaved = [[NSMutableArray alloc]init];
	 
	 //******************
	 // for implementing lazy img for people on 16 sep 2010 by pradeep
	 
	 */
	// end 10 may 2011
	
	//***************** start three20 code
	
	// added by pradeep on 17 may 2011 for implementing foregrnd n backgrnd process
	// below code will only execute if app has killed i.e. not running in backgrnd,
	
	if (!didAppEnterBackGround)
	{
		TTNavigator* navigator = [TTNavigator navigator];
		navigator.supportsShakeToReload = YES;
		navigator.persistenceMode = TTNavigatorPersistenceModeAll;
		
		TTURLMap* map = navigator.URLMap;
		//[map from:@"*" toViewController:[TTWebController class]];
		
		//[SettingsTableView ifDataExists];
		//if(flagStep6 == 1)
		//BOOL isalreadysignedin = [LauncherViewTestController isFileExist:@"settingsinfo4Unsocial"];
		//if (isalreadysignedin)
		BOOL flg = [self getLocationLock];
		if ([self getDataFromFile])
		{
			
			if (flg==FALSE)
			{
				[map from:@"tt://launcherTest" toViewController:[LauncherViewTestController class]];
				[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://launcherTest"]];
			}
			else {
				[map from:@"tt://locationlock" toViewController:[AppNotAvailable class]transition:1];
				[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://locationlock"]];
			}
		}
		else
		{
			if (flg==TRUE)
			{
				checklocation = 1;
			}
			//[map from:@"tt://launcherTest" toViewController:[SignIn class]];
			[map from:@"tt://welcome" toViewController:[WelcomeViewController class]];
			[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://welcome"]];
		}
		
		//[map from:@"tt://launcherTest" toViewController:[SplashScreen class]];
		//[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://launcherTest"]];
		
		
		[map from:@"*" toViewController:[TTWebController class]];
		[map from:@"tt://peoples" toModalViewController:[Peoples class]transition:1];
		[map from:@"tt://peopleauto" toModalViewController:[PeopleAutoTagged class]transition:1];
		[map from:@"tt://peopleinvite" toModalViewController:[InvitePeople class]transition:1];
		// added by pradeep on 9 june 2011 for a new springboard item "MY EVENTS"
		[map from:@"tt://myevents" toModalViewController:[MyEvents class]transition:1];
		// end 9 june 2011
		
		// added by pradeep on 15 july 2011 for a new springboard item "MY EVENTS"
		[map from:@"tt://mynotes" toModalViewController:[MyNotes class]transition:1];
		// end 15 july 2011
		
		[map from:@"tt://tips" toModalViewController:[ShowTips class]transition:1];
		[map from:@"tt://info" toModalViewController:[Info class]transition:1];
		[map from:@"tt://events" toModalViewController:[Events class]transition:1];
		[map from:@"tt://inbox" toModalViewController:[InBox class]transition:1];
		[map from:@"tt://settings" toModalViewController:[Settings class]transition:1];
		[map from:@"tt://settingstb" toModalViewController:[SettingsTableView class]transition:1];
		[map from:@"tt://unsocialmiles" toModalViewController:[MilesOptions class]transition:1];
		//*************************
		// commneted by pradeep on 24 july 2010 and added search in place of tags
		//[map from:@"tt://tags" toModalViewController:[Tags class]transition:1];
		[map from:@"tt://search" toModalViewController:[SearchViewControllerImproved class]transition:1];
		//*************************
		[map from:@"tt://sevents" toModalViewController:[SponsoredEvents class]transition:1];
		
		// added by pradeep for "Live Now Start Logic" on 22 sep 2010
		//*************************
		[map from:@"tt://sponsoredsplash" toModalViewController:[SponsoredSplash class]transition:1];
		[map from:@"tt://peoplelivenow" toViewController:[PeopleLiveNow class]];
		//*************************
		
		[map from:@"tt://billboard" toModalViewController:[SettingsStep5 class]transition:1];
		[map from:@"tt://video" toModalViewController:[ViewVideo class]transition:1];
		[map from:@"tt://eventd" toModalViewController:[EventDetails class]transition:1];
		[map from:@"tt://signup" toModalViewController:[SignUp class]transition:1];
		[map from:@"tt://signin" toModalViewController:[SignIn class]transition:1];
		[map from:@"tt://addfeature" toModalViewController:[AddExtraFeature class]transition:1];
		
		//***************
		[map from:@"tt://forgetpwd" toModalViewController:[ForgetPwd class]transition:1];
		
		//*****************************
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{	
    // If it's a relatively recent event, turn off updates to save power
	
	//we need an activity indicator here.	
	/*NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;*/
	
	NSLog(@"************* location update method called *************");
    //if (flglocationupdate==1)
	//	return;
	flglocationupdate++;
	
	NSDate* eventoldDate = oldLocation.timestamp;
	NSDate* eventDate = newLocation.timestamp;
	NSLog(@"%@", [NSString stringWithFormat:@"%+.6f",newLocation.coordinate.latitude]);
	NSLog(@"%@", [NSString stringWithFormat:@"%+.6f",newLocation.coordinate.longitude]);
	
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
	NSTimeInterval howRecent4old = [eventoldDate timeIntervalSinceNow];
	
	NSString *strdt = [NSString stringWithFormat:@"%@",eventDate];
	
	NSLog(@"Date for getting location: %@", strdt);
	
	NSLog(@"%@", [NSString stringWithFormat:@"how recent: %f",howRecent]);
	NSLog(@"%@", [NSString stringWithFormat:@"how recent: %f",howRecent4old]);
	
    //if (abs(howRecent) <= 5.0)	
	if (abs(howRecent) > 5.0) 
	{
		// added by pradeep on 6th Jan 2011 for fixing bug when there is no sim installed and also user off wifi either device or ipod the app will be hang on default page
		// 6th jan 2011 start
		if(![UnsocialAppDelegate checkInternet:@"http://www.google.com"])
			NSLog(@"net is not available");
			//else return;
		// 6th jan 2011 end
		
		// commented on 6th jan 2011 by pradeep
		//return;
	}
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
	
    NSLog(@"bestEffortAtLocation horizontalAccuracy: %f, newLocation's horizontalAccuracy: %f ", bestEffortAtLocation.horizontalAccuracy,newLocation.horizontalAccuracy);
	
	//if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) 
    {
		//+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats
		
		//[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval) 0.55 target:self selector:@selector(makeSplashMove) userInfo:nil repeats:NO];
		
		// store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
		
		NSLog(@"Inside first if condition for location manager");
		
		// test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        
		NSLog(@"horizontalAccuracy: %f, desiredAccuracy: %f ", newLocation.horizontalAccuracy,locationManager.desiredAccuracy);
		NSLog(@"How many time location update manager method calls: %d", flglocationupdate);
		//if (flglocationupdate >= 3)
		//if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) 
		{
			//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			//[pool release];
			
			NSLog(@"Inside second if condition for location manager");
		//SKK updated this to make sure we run at least once more before we use the location
		
			if(newLocation.horizontalAccuracy > 2000 ) {
				if (flglocationupdate < 3) {
					NSLog(@"SKK updating one more time...");
					//[manager startUpdatingLocation];
					return;
				}
			}
		
        [manager stopUpdatingLocation];		
        printf("latitude %+.6f, longitude %+.6f\n",newLocation.coordinate.latitude,			   
			   newLocation.coordinate.longitude);
		
		// commented by pradeep on 10 may 2011 for enhancing performance issue	
		//gbllatitudeary = [[NSMutableArray alloc] initWithObjects: nil];
		//gbllongitudeary = [[NSMutableArray alloc] initWithObjects: nil];
		// end 10 may 2011	
			
			// added by pradeep on 10 may 2011 for enhancing performance issue
			[gbllatitudeary removeAllObjects];
			[gbllongitudeary removeAllObjects];
			// end 10 may 2011
			
			
		//gbldateary = [[NSMutableArray alloc] initWithObjects: nil];
		
		gbllatitude = [NSString stringWithFormat:@"%+.6f",newLocation.coordinate.latitude];
		//gbllatitude   = @"37.7681339"; // sanfransisco for discovery beat
		//gbllatitude   = @"47.6062095"; // seattle, wa for discovery beat
		[gbllatitudeary addObject:gbllatitude];
		
		gbllongitude = [NSString stringWithFormat:@"%+.6f",newLocation.coordinate.longitude];
		//gbllongitude = @"-122.3939490"; // sanfransisco for discovery beat
		//gbllongitude = @"-122.3320708"; // seattle, wa for discovery beat
		[gbllongitudeary addObject:gbllongitude];
		
		//gbllongitude = @"-122.1864364";//gbllatitude; // @"-122.1864364"
		//gbllatitude   = @"47.8779449";//gbllongitude; //@"47.8779449"	
		
		//********************************************* below section is not in use.
		
		/*rvc.longstr = gbllongitude; //@"-122.1864364"
		 rvc.latstr = gbllatitude; // @"47.8779449"
		 
		 bdvc.longstr = gbllatitude; // @"-122.1864364"
		 bdvc.latstr = gbllongitude; //@"47.8779449"*/		
		
		/*cvc = [[CriteriaViewController alloc]init];
		 
		 rvc.longstr = @"-122.1864364";//gbllongitude; //@"-122.1864364"
		 rvc.latstr = @"47.8779449";//gbllatitude; // @"47.8779449"
		 
		 bdvc.longstr = @"-122.1864364";//gbllatitude; // @"-122.1864364"
		 bdvc.latstr = @"47.8779449";//gbllongitude; //@"47.8779449"
		 
		 cvc.cvclongstr = @"-122.1864364";//gbllatitude; // @"-122.1864364"
		 cvc.cvclatstr = @"47.8779449";//gbllongitude; //@"47.8779449"	*/	
		
		//*********************************************above section is not in use.
		
		//***************************** added by pradeep on 9 september for resolving location manager's issue i.e. it is taking too much time for finding location
		
		
		if ([self getDataFromFile])
		{
			//tabBarController.selectedIndex = 0;
			//people = [[People alloc] init];
			//[window addSubview:people.view];
			[self recalliflatlongnotset];
			//[self recall4UdateBadgeEvery5Min];
			
			
		}
		else 
		{
			//tabBarController.selectedIndex = 3;
			[self recalliflatlongnotset];
			//settings = [[Settings alloc] init];
			// [window addSubview:settings.view];
			//[window addSubview:[tabBarController view]];
			
		}
			
			// commented by pradeep on 10 may 2011 for enhancing performance issue
			/*
			 //initializing arrays for all 3 segment under people tab
			 stories4peoplearoundme = [[NSMutableArray alloc] init];
			 stories4peoplemyinterest = [[NSMutableArray alloc] init];
			 stories4peoplebookmark = [[NSMutableArray alloc] init];
			 //[UnsocialAppDelegate sendNow:@"getunreadmsg":userid];
			 
			 // for implementing lazy img for people on 16 sep 2010 by pradeep
			 //******************
			 
			 imageURLs4Lazyall = [[NSMutableArray alloc]init];
			 imageURLs4Lazyauto = [[NSMutableArray alloc]init];
			 imageURLs4Lazysaved = [[NSMutableArray alloc]init];
			 
			 //******************
			 // for implementing lazy img for people on 16 sep 2010 by pradeep
			 
			 */
			// end 10 may 2011
		
		
		//***************** start three20 code
			
		// added by pradeep on 17 may 2011 for implementing foregrnd n backgrnd process
		// below code will only execute if app has killed i.e. not running in backgrnd,
			
			if (!didAppEnterBackGround)
			{
				// added by pradeep on 1 aug 2011 for fixing issue for launcherview, in which reloadData4LocationLabel calls 3 times. since didupdatetolocation calls several times and due to this LauncherViewTestController allocates every time so it calls several time
				if (!isreloadData4LocationLabelCall)
				{	
					isreloadData4LocationLabelCall = TRUE;
					// end 1 aug 2011 
					
					TTNavigator* navigator = [TTNavigator navigator];
					navigator.supportsShakeToReload = YES;
					navigator.persistenceMode = TTNavigatorPersistenceModeAll;
					
					TTURLMap* map = navigator.URLMap;
					//[map from:@"*" toViewController:[TTWebController class]];
					
					//[SettingsTableView ifDataExists];
					//if(flagStep6 == 1)
					//BOOL isalreadysignedin = [LauncherViewTestController isFileExist:@"settingsinfo4Unsocial"];
					//if (isalreadysignedin)
					BOOL flg = [self getLocationLock];
					if ([self getDataFromFile])
					{
						
						if (flg==FALSE)
						{
							[map from:@"tt://launcherTest" toViewController:[LauncherViewTestController class]];
							[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://launcherTest"]];
						}
						else {
							[map from:@"tt://locationlock" toViewController:[AppNotAvailable class]transition:1];
							[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://locationlock"]];
						}
					}
					else
					{
						if (flg==TRUE)
						{
							checklocation = 1;
						}
						//[map from:@"tt://launcherTest" toViewController:[SignIn class]];
						[map from:@"tt://welcome" toViewController:[WelcomeViewController class]];
						[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://welcome"]];
					}
					
					//[map from:@"tt://launcherTest" toViewController:[SplashScreen class]];
					//[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://launcherTest"]];
					
					
					[map from:@"*" toViewController:[TTWebController class]];
					[map from:@"tt://peoples" toModalViewController:[Peoples class]transition:1];
					[map from:@"tt://peopleauto" toModalViewController:[PeopleAutoTagged class]transition:1];
					[map from:@"tt://peopleinvite" toModalViewController:[InvitePeople class]transition:1];
					// added by pradeep on 9 june 2011 for a new springboard item "MY EVENTS"
					[map from:@"tt://myevents" toModalViewController:[MyEvents class]transition:1];
					// end 9 june 2011
					
					// added by pradeep on 15 july 2011 for a new springboard item "MY EVENTS"
					[map from:@"tt://mynotes" toModalViewController:[MyNotes class]transition:1];
					// end 15 july 2011
					
					[map from:@"tt://tips" toModalViewController:[ShowTips class]transition:1];
					[map from:@"tt://info" toModalViewController:[Info class]transition:1];
					[map from:@"tt://events" toModalViewController:[Events class]transition:1];
					[map from:@"tt://inbox" toModalViewController:[InBox class]transition:1];
					[map from:@"tt://settings" toModalViewController:[Settings class]transition:1];
					[map from:@"tt://settingstb" toModalViewController:[SettingsTableView class]transition:1];
					[map from:@"tt://unsocialmiles" toModalViewController:[MilesOptions class]transition:1];
					//*************************
					// commneted by pradeep on 24 july 2010 and added search in place of tags
					//[map from:@"tt://tags" toModalViewController:[Tags class]transition:1];
					[map from:@"tt://search" toModalViewController:[SearchViewControllerImproved class]transition:1];
					//*************************
					[map from:@"tt://sevents" toModalViewController:[SponsoredEvents class]transition:1];
					
					// added by pradeep for "Live Now Start Logic" on 22 sep 2010
					//*************************
					[map from:@"tt://sponsoredsplash" toModalViewController:[SponsoredSplash class]transition:1];
					[map from:@"tt://peoplelivenow" toViewController:[PeopleLiveNow class]];
					//*************************
					
					[map from:@"tt://billboard" toModalViewController:[SettingsStep5 class]transition:1];
					[map from:@"tt://video" toModalViewController:[ViewVideo class]transition:1];
					[map from:@"tt://eventd" toModalViewController:[EventDetails class]transition:1];
					[map from:@"tt://signup" toModalViewController:[SignUp class]transition:1];
					[map from:@"tt://signin" toModalViewController:[SignIn class]transition:1];
					[map from:@"tt://addfeature" toModalViewController:[AddExtraFeature class]transition:1];
					
					//***************
					[map from:@"tt://forgetpwd" toModalViewController:[ForgetPwd class]transition:1];
					
					//*****************************
				
				// added by pradeep on 1 aug 2011 for fixing issue for launcherview, in which reloadData4LocationLabel calls 3 times
				}
				// end 1 aug 2011
			}
			/*else 
			{
				didAppEnterBackGround = FALSE;
			}*/

		
		
			
		}
		
		
		
    }
	
	/*if (flglocationupdate < 3)
	{
		NSLog(@"How many time calls start update method: %d", flglocationupdate);
		//[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval) 0.55 target:self selector:@selector(startUpdates) userInfo:nil repeats:YES];
	}*/
    // else skip the event and process the next one.
		
}

- (void) addFeaturesToWindow
{
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"Default.png"];
	[window addSubview:imgBack];
	
	[imgBack release];
	
	gblRecordExists = [self getDataFromFile];
	/*peoples = [[[Peoples alloc] initWithNibName:nil bundle:nil] autorelease]; 
	UINavigationController *peopleviewcontroller= [[UINavigationController alloc] initWithRootViewController:peoples];
	
	events = [[Events alloc] initWithNibName:nil bundle:nil];
	UINavigationController *eventsviewcontroller= [[UINavigationController alloc] initWithRootViewController:events];
	
	inBox = [[InBox alloc] initWithNibName:nil bundle:nil];
	inBoxviewcontroller= [[UINavigationController alloc] initWithRootViewController:inBox];
	
	gblRecordExists = [self getDataFromFile];
	UINavigationController *settingsviewcontroller= [[UINavigationController alloc] init];
	
	if(!gblRecordExists){
		settings = [[Settings alloc] initWithNibName:nil bundle:nil];
		settingsviewcontroller= [[UINavigationController alloc] initWithRootViewController:settings];
	}
	else {
		settingsTableView = [[SettingsTableView alloc] initWithNibName:nil bundle:nil];
		settingsviewcontroller= [[UINavigationController alloc] initWithRootViewController:settingsTableView];
	}
	
	biMeter = [[BIMeter alloc] initWithNibName:nil bundle:nil];
	UINavigationController *biMeterviewcontroller= [[UINavigationController alloc] initWithRootViewController:biMeter];
	
	referrals = [[Referrals alloc] initWithNibName:nil bundle:nil];
	UINavigationController *referralsviewcontroller= [[UINavigationController alloc] initWithRootViewController:referrals];
	
	invites = [[Invites alloc] initWithNibName:nil bundle:nil];
	UINavigationController *invitesviewcontroller= [[UINavigationController alloc] initWithRootViewController:invites];
	
	tips = [[Tips alloc] initWithNibName:nil bundle:nil];
	UINavigationController *tipsviewcontroller= [[UINavigationController alloc] initWithRootViewController:tips];
	
	about = [[About alloc] initWithNibName:nil bundle:nil];
	UINavigationController *aboutviewcontroller= [[UINavigationController alloc] initWithRootViewController:about];
	
	//add a tab bar controller
	tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
	tabBarController.viewControllers = [NSArray arrayWithObjects:peopleviewcontroller, eventsviewcontroller, inBoxviewcontroller, settingsviewcontroller, biMeterviewcontroller, referralsviewcontroller, invitesviewcontroller, tipsviewcontroller, aboutviewcontroller, nil]; 
	
	peopleviewcontroller.tabBarItem.image = [UIImage imageNamed:@"tabbar_people.png"];
	peopleviewcontroller.title = @"People";
	[peopleviewcontroller release];
	
	eventsviewcontroller.tabBarItem.image = [UIImage imageNamed:@"tabbar_events.png"];
	eventsviewcontroller.title = @"Events";
	[eventsviewcontroller release];
	
	inBoxviewcontroller.tabBarItem.image = [UIImage imageNamed:@"tabbar_inbox.png"];
	inBoxviewcontroller.title = @"InBox";
	NSString *strbadgevalue = [NSString stringWithFormat:@"%i", unreadmsg];
	if(unreadmsg != 0)
		inBoxviewcontroller.tabBarItem.badgeValue = strbadgevalue;
	[inBoxviewcontroller release];
	
	settingsviewcontroller.tabBarItem.image = [UIImage imageNamed:@"tabbar_settings.png"];
	settingsviewcontroller.title = @"Settings";
	[settingsviewcontroller release];
	
	biMeterviewcontroller.tabBarItem.image = [UIImage imageNamed:@"tabbar_.png"];
	biMeterviewcontroller.title = @"BI meter";
	[biMeterviewcontroller release];
	
	referralsviewcontroller.tabBarItem.image = [UIImage imageNamed:@"tabbar_.png"];
	referralsviewcontroller.title = @"Referrals";
	[referralsviewcontroller release];
	
	invitesviewcontroller.tabBarItem.image = [UIImage imageNamed:@"tabbar_.png"];
	invitesviewcontroller.title = @"Invites";
	[invitesviewcontroller release];
	
	tipsviewcontroller.tabBarItem.image = [UIImage imageNamed:@"tabbar_.png"];
	tipsviewcontroller.title = @"TIPS";
	[tipsviewcontroller release];
	
	aboutviewcontroller.tabBarItem.image = [UIImage imageNamed:@"tabbar_at_symbol.png"];
	aboutviewcontroller.title = @"About";
	[aboutviewcontroller release];
	
	//this code is to set More tab bar 	
	UINavigationController *moreNC = [tabBarController moreNavigationController];
	UIColor *color = [UIColor blackColor];
	
	tabBarController.customizableViewControllers =  nil; // for hidding edit btn on tabbar 
	
	UINavigationBar *bar = [moreNC navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];*/
	
#define pragma mark set URL
	//globalUrlString = @"http://icheena.no-ip.org";
	//globalUrlString = @"http://rstrings.com/unsocial";
	//globalUrlString = @"http://192.168.1.13/unsocial";
	//globalUrlString = @"http://192.168.1.11/unsocialtest";
	
	// rackspace for production app
	//globalUrlString = @"http://67.192.58.40/unsocial";
	//globalUrlString = @"http://unsocial.us/unsocial";
	//globalUrlString = @"http://unsocial.us/uslinked";
	
	// rackspace for test app	
	globalUrlString = @"http://unsocial.us/unsocialtest";
	// comment for testing git hub stash
	
	/*UIImage *image = [UIImage imageNamed: @"header_trans.png"];
	UIImageView *imageview = [[UIImageView alloc] initWithImage: image];
	
	UINavigationItem *item1 = (UINavigationItem *) [bar.items objectAtIndex:0];
	item1.titleView = imageview;	*/
	lastVisitedFeature = [[NSMutableArray alloc]init];
	
	interestedIndustryIds1 = [[NSMutableArray alloc]init];
	interestedIndustryIds2 = [[NSMutableArray alloc]init];
	interestedIndustryIds3 = [[NSMutableArray alloc]init];
	
	interestedIndustry1 = [[NSMutableArray alloc]init];
	interestedIndustry2 = [[NSMutableArray alloc]init];
	interestedIndustry3 = [[NSMutableArray alloc]init];
	
	aryKeyword = [[NSMutableArray alloc]init];
	aryTags = [[NSMutableArray alloc]init];
	aryVideo = [[NSMutableArray alloc]init];
	aryVideoTitle = [[NSMutableArray alloc]init];
	yAxisForSettingControls = 7;
}

+ (NSString *) getLinkedInMailFromFile {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial"];
	NSMutableArray *tempArray;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
			//open it and read it 
		NSLog(@"data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];
		
		[decoder finishDecoding];
		[decoder release];	
	}
	return [[tempArray objectAtIndex:0] userlinkedinmailid];
}

+ (NSString *) getLinkedInPrefixFromFile {
	
	NSMutableArray *tempArray;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
			//open it and read it 
		NSLog(@"data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];
		
		[decoder finishDecoding];
		[decoder release];	
	}
	return [[tempArray objectAtIndex:0] userprefix];
}

+ (NSString *)getLocalTime {
	
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss Z"]; // e.g., set for mysql date strings
//	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	NSString* mysqlGMTString = [formatter stringFromDate:[NSDate date]];
		//mysqlGMTString = [mysqlGMTString stringByReplacingOccurrencesOfString:@"+0" withString:@"+"];
	NSLog(@"%@", mysqlGMTString);
	NSLog(@"%@", [NSDate date]);
	return mysqlGMTString;
}

+ (UILabel *)createLabelControl: (NSString *)title frame:(CGRect)frame txtAlignment:(UITextAlignment )txtAlignment numberoflines:(NSInteger)numberoflines linebreakmode:(UILineBreakMode)linebreakmode fontwithname:(NSString *)fontwithname fontsize:(NSInteger)fontsize txtcolor:(UIColor *)txtcolor backgroundcolor:(UIColor *)backgroundcolor
{
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.text = title;
	label.textAlignment = txtAlignment;
	label.numberOfLines = numberoflines;
	label.lineBreakMode = linebreakmode;
	[label setFont:[UIFont fontWithName:fontwithname size:fontsize]];
	label.textColor = txtcolor;
	label.backgroundColor = backgroundcolor;
	return label;
}

// added by pradeep on 3 august 2011 for creating new method that will create imageviewcontroller without auto release
+ (UILabel *)createLabelControlWithoutAutoRelease: (NSString *)title frame:(CGRect)frame txtAlignment:(UITextAlignment )txtAlignment numberoflines:(NSInteger)numberoflines linebreakmode:(UILineBreakMode)linebreakmode fontwithname:(NSString *)fontwithname fontsize:(NSInteger)fontsize txtcolor:(UIColor *)txtcolor backgroundcolor:(UIColor *)backgroundcolor
{
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = title;
	label.textAlignment = txtAlignment;
	label.numberOfLines = numberoflines;
	label.lineBreakMode = linebreakmode;
	[label setFont:[UIFont fontWithName:fontwithname size:fontsize]];
	label.textColor = txtcolor;
	label.backgroundColor = backgroundcolor;
	return label;
}
// end 3 august 2011 for without auto release

+ (UIButton *)createButtonControl:	(NSString *)title target:(id)target selector:(SEL)selector frame:(CGRect)frame imageStateNormal:(NSString *)imageStateNormal imageStateHighlighted:(NSString *)imageStateHighlighted TextColorNormal:(UIColor *)TextColorNormal TextColorHighlighted:(UIColor *)TextColorHighlighted showsTouch:(BOOL) showsTouch buttonBackgroundColor:(UIColor *)buttonBackgroundColor {	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	button.showsTouchWhenHighlighted = showsTouch;
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];	
	
	[button setTitleColor:TextColorNormal forState:UIControlStateNormal];
	[button setTitleColor:TextColorHighlighted forState:UIControlStateHighlighted];
	button.titleLabel.font = [UIFont fontWithName:kAppFontName size:kButtonFont];
	UIImage *imageNormal = [[UIImage imageNamed:imageStateNormal] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:imageNormal forState:UIControlStateNormal];
	
	UIImage *imageHighlighted = [[UIImage imageNamed:imageStateHighlighted] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = buttonBackgroundColor;
	
	return button;
}

+ (UITextView *)createTextViewControl: (NSString *)description frame:(CGRect)frame txtcolor:(UIColor *)txtcolor  backgroundcolor:(UIColor *)backgroundcolor  fontwithname:(NSString *)fontwithname fontsize:(NSInteger)fontsize returnKeyType:(UIReturnKeyType)returnKeyType keyboardType:(UIKeyboardType)keyboardType scrollEnabled:(BOOL)scrollEnabled editable:(BOOL)editable {
	
	UITextView *textView = [[UITextView alloc] initWithFrame:frame];
	textView.textColor = txtcolor;
	textView.font = [UIFont fontWithName:fontwithname size:fontsize];
	textView.delegate = self;
	textView.backgroundColor = backgroundcolor;
	textView.returnKeyType = returnKeyType;
	textView.keyboardType = keyboardType;
	textView.scrollEnabled = scrollEnabled;
	textView.editable = editable;
	textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	textView.text = description;
	return textView;
}

+ (UITextField *)createTextFieldControl:(CGRect)frame borderStyle:(UITextBorderStyle)borderStyle setTextColor:(UIColor *)setTextColor setFontSize:(NSInteger)setFontSize setPlaceholder:(NSString *)setPlaceholder backgroundColor:(UIColor *)backgroundColor keyboard:(UIKeyboardType)keyboard returnKey:(UIReturnKeyType)returnKey {
	
	UITextField *textField = [[UITextField alloc] initWithFrame:frame];
	[textField setBorderStyle:UITextBorderStyleRoundedRect];
	[textField setTextColor:setTextColor];
	[textField setFont:[UIFont systemFontOfSize:setFontSize]];
	[textField setPlaceholder:setPlaceholder];
	textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	textField.backgroundColor = [UIColor whiteColor];
	textField.keyboardType = keyboard;
	textField.returnKeyType = returnKey;
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	[textField setFont:[UIFont fontWithName:kAppFontName size:kTextFieldFont]];
	return textField;
}

+ (UIImageView *)createImageViewControl:(CGRect)frame imageName:(NSString *)imageName {
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
	imageView.image =[UIImage imageNamed: imageName];
	return imageView;
}

// added by pradeep on 3 august 2011 for creating new method that will create imageviewcontroller without auto release
+ (UIImageView *)createImageViewControlWithoutAutoRelease:(CGRect)frame imageName:(NSString *)imageName {
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
	imageView.image =[UIImage imageNamed: imageName];
	return imageView;
}
// end 3 august 2011 without auto release

- (BOOL) getDataFromFile {

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
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
		
		username = [[tempArray objectAtIndex:0] username];
		//userlocation = [[tempArray objectAtIndex:0] userlocation];
		userid = [[tempArray objectAtIndex:0] userid];
		//userpwd = [[tempArray objectAtIndex:0] userpwd];
		
		arrayForUserID = [[NSMutableArray alloc]init];
		if ([aryLoggedinUserName count] > 0)
			[aryLoggedinUserName removeAllObjects];
		if ([userid compare:@""]!=NSOrderedSame)
		{
			[arrayForUserID addObject:[[tempArray objectAtIndex:0] userid]];
			[aryLoggedinUserName addObject:[[tempArray objectAtIndex:0] username]];
			splashImage = [[NSMutableArray alloc]init];
			[splashImage addObject:[UIImage imageNamed:@"splashlauncher.png"]];
		}
		
		[decoder finishDecoding];
		[decoder release];	
		
		
		//if ( [username compare:@""] == NSOrderedSame || !username)
		if ( [userid compare:@""] == NSOrderedSame || !userid)
		{
			return NO;
		}
		else {
			// initialized global userid variable (returned usierid from web app) for tracing user in whole app
			return YES;
		}
		
		
		
	}
	else { //just in case the file is not ready yet.
		//username = @"";
		//userlocation = @"";
		[self CreateFile];
		return NO;
	}
	[pool drain];
	[pool release];
}

- (void) CreateFile {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init]; 
	
	//
	
	newPerson.username = @""; // here textfieldemail text represent user name
	NSLog(@"%@", newPerson.username);
	newPerson.userid = @""; //@"US56896821713685";
	NSLog(@"%@", newPerson.userid);
	gbluserid = @"";
	
	//if (pickerCtl.s) {
	//newPerson.useragegroup = pickerCtl.tag;
	//}
	//else {
	//	newPerson.cctouser = @"0";
	//}
	
	//NSLog(@"useragegroup is %@", newPerson.useragegroup);
	//settingsinfo4thisorthat1
	
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
	[userInfo release];
	
}

+(void)playClick {
	
	SystemSoundID klick;
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"click_off" ofType:@"wav"]isDirectory:NO],&klick);
	AudioServicesPlaySystemSound(klick);
}

+ (UIActivityIndicatorView *)createActivityView: (CGRect)frame activityViewStyle:(UIActivityIndicatorViewStyle)activityViewStyle
{
	UIActivityIndicatorView *createActivityView = [[[UIActivityIndicatorView alloc] initWithFrame:frame] autorelease];
	createActivityView.activityIndicatorViewStyle = activityViewStyle;
	return createActivityView;
}

- (void)dealloc {
	
	// added by pradeep on 29 june 2011
	//locationManager.delegate = nil;
	// end 29 june 2011
	
    [window release];
	
	//[locationManager release];
	
    [super dealloc];
}

// added by vaibhav on 10 feb 2011
+ (BOOL)validateEmail:(NSString *)emailid {
	
	NSString *email = [emailid lowercaseString];
	NSString *emailRegEx =
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
	BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:email];
	return myStringMatchesRegEx;
}

+ (BOOL) validateUrl:(NSString *)url {
	
	BOOL retbool;
	url = [url lowercaseString];
	NSArray *sepbydot = [url componentsSeparatedByString:@"."];
	NSArray *sepbyhttp = [url componentsSeparatedByString:@"http://"];
	if ([sepbydot count] > 1 && [sepbyhttp count] == 1)
		retbool = YES;
	else
		retbool = NO;
	return retbool;
}
// ****** 10 feb 2011 end

// added by pradeep on 22 september 2011 for implementing MD5 conversion
//generate md5 hash from string
+ (NSString *) returnMD5Hash:(NSString*)concat 
{
	const char *concat_str = [concat UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];	
	CC_MD5(concat_str, strlen(concat_str), result);	
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++)
		[hash appendFormat:@"%02X", result[i]];
	
	NSLog(@"AFTER ENCODE:: %@",hash);	
	return [hash lowercaseString];	
}
// end 22 september 2011



// added by pradeep on 10 Jan 2011 for releasing used memory but it is not working perfectly and still shows low memory warning 

/*+ (void) release_used_memory {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);        
	
    vm_statistics_data_t vm_stat;
	
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
	
    // Stats in bytes  
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    NSLog(@"used: %u free: %u total: %u", mem_used, mem_free, mem_total);
	
	size_t size = mem_free - (2*1024*1024);
	void *allocation = malloc(size);
	bzero(allocation, size);
	free(allocation);
	
	NSLog(@"Again call after free memory done");
	
	host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);        
	
    vm_statistics_data_t vm_stat2;
	
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat2, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
	
	mem_used = (vm_stat2.active_count +
				vm_stat2.inactive_count +
				vm_stat2.wire_count) * pagesize;
    mem_free = vm_stat2.free_count * pagesize;
    mem_total = mem_used + mem_free;
    NSLog(@"used: %u free: %u total: %u", mem_used, mem_free, mem_total);
	
}*/


@end
@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect {
	//signupbackground
	UIColor *color = [UIColor blackColor];
	UIImage *img  = [UIImage imageNamed: @"navigationbarbg.png"];
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	self.tintColor = color;
}
@end
