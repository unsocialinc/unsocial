//
//  ActivityViewForLauncher.m
//  Unsocial
//
//  Created by pradeepKsrivastava on 16/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActivityViewForLauncher.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"
#import "LauncherViewTestController.h"
#import "Person.h"

@implementation ActivityViewForLauncher
@synthesize strFrom, strFromName, strMsgDescription, strDateTime, strMsgId, strReadMsg, strPurpose;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self btnProfile_Click];
	[activityView stopAnimating];
	activityView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	
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
	// added by pradeep on 19 may 2011
	[imgHeadview release];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;
	leftbtn.hidden = YES;
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"imgback.png"];
	[self.view addSubview:imgBack];
	// added by pradeep on 19 may 2011
	[imgBack release];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)btnProfile_Click {

	[self getProfile:@""];
	[self updateDataFile4GeneralInfo:@""];
	[self updateDataFile4CompanyInfo:@""];
	[self updateDataFile4SecuritySettings:@""];
	[self updateDataFile4Status];
	[self updateDataFile4Img:@""];
	
	[self updateDataFile4MetaTags:@"" :@""];
	[self updateDataFile4Tags:@"" :@""];
		
	
	/*NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[NSThread detachNewThreadSelector:@selector(getUnsocialTile) toTarget:self withObject:nil];
	[pool release];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;*/
	
	//[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getUnsocialTile) userInfo:self repeats:NO];
	
	[self getUnsocialTile];
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	TTURLMap* map = navigator.URLMap;
	[map from:@"tt://launcherTest" toModalViewController:[LauncherViewTestController class]transition:1];
	[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://launcherTest"] applyAnimated:YES]];	
}

- (void) updateDataFile4GeneralInfo:(NSString *)uid {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];	
	newPerson.userprefix = [[stories objectAtIndex:0] objectForKey:@"prefix"];
	newPerson.username = [[stories objectAtIndex:0] objectForKey:@"username"];
	newPerson.useremail = [[stories objectAtIndex:0] objectForKey:@"email"];;
	newPerson.usercontact = [[stories objectAtIndex:0] objectForKey:@"contact"];;
	newPerson.userid = [[stories objectAtIndex:0] objectForKey:@"guid"];
	newPerson.userlinkedinmailid = [[stories objectAtIndex:0] objectForKey:@"linkedinemailid"];
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	// for getting username for sending mail during invitatio
	if ([aryLoggedinUserName count] > 0)
		[aryLoggedinUserName removeAllObjects];
	//if ([userid compare:@""]!=NSOrderedSame)
	{
		//[arrayForUserID addObject:[[tempArray objectAtIndex:0] userid]];
		[aryLoggedinUserName addObject:[[stories objectAtIndex:0] objectForKey:@"username"]];
	}
	
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
	// added by pradeep on 19 may 2011
	[userInfo release];
}

// for saving an image inside document forder
- (void) updateDataFile4Img:(NSString *)uid {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"1.png"] retain];
	//NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation([[stories objectAtIndex:0] objectForKey:@"itemPicture"], 1.0)];
	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([[stories objectAtIndex:0] objectForKey:@"itemPicture"])];
	[imageData writeToFile:dataFilePath atomically:YES];
}


- (void) updateDataFile4CompanyInfo:(NSString *)uid {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	newPerson.userid = [[stories objectAtIndex:0] objectForKey:@"guid"];
	newPerson.usercompany = [[stories objectAtIndex:0] objectForKey:@"company"];
	newPerson.userwebsite = [[stories objectAtIndex:0] objectForKey:@"userwebsite"];
	newPerson.userindustry = [[stories objectAtIndex:0] objectForKey:@"industry"];
	newPerson.userfunction = [[stories objectAtIndex:0] objectForKey:@"role"];
	
	newPerson.userindid = [[stories objectAtIndex:0] objectForKey:@"industryid"];
	newPerson.userroleid = [[stories objectAtIndex:0] objectForKey:@"roleid"];
	newPerson.userlinkedin = [[stories objectAtIndex:0] objectForKey:@"linkedinprofile"];
	newPerson.usertitle = [[stories objectAtIndex:0] objectForKey:@"usertitle"];
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial2"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
	// added by pradeep on 19 may 2011
	[userInfo release];
}

- (void) updateDataFile4SecuritySettings:(NSString *)uid {
	
	NSString *curLoc = @"0";
	/*if(switchCtl1.on == YES)
		curLoc = @"1";
	else
		curLoc = @"0";*/
			
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];	
	
	newPerson.selectedSecurityLevel = [[stories objectAtIndex:0] objectForKey:@"securitylevel"];
	newPerson.displayedSecurityItems = [[stories objectAtIndex:0] objectForKey:@"displayitem"];
	newPerson.currentloaction = curLoc;
	newPerson.userid = [[stories objectAtIndex:0] objectForKey:@"guid"];
	
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
	// added by pradeep on 19 may 2011
	[userInfo release];
}
- (void) updateDataFile4Status {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	newPerson.strsetstatus = [[stories objectAtIndex:0] objectForKey:@"status"];
	newPerson.userid = [[stories objectAtIndex:0] objectForKey:@"guid"];
	
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
	// added by pradeep on 19 may 2011
	[userInfo release];
}

- (void) updateDataFile4DigitalBillboardImg:(NSString *)uid {
			
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"billboard.jpg"] retain];
	//imageData1 = UIImageJPEGRepresentation([capturedImage objectAtIndex:0], 1.0);
	NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation([[stories4digitalbillboard objectAtIndex:0] objectForKey:@"billboardPicture"], 1.0)];
	[imageData writeToFile:dataFilePath atomically:YES];
}

- (void) updateDataFile4MetaTags:(NSString *)uid:(NSString *)str {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	if ([[[stories objectAtIndex:0] objectForKey:@"userhasmetatags"] compare:@"yes"] == NSOrderedSame)
	newPerson.strsetkeywords = @"yes";
	else newPerson.strsetkeywords = @"";
	newPerson.userid = [[stories objectAtIndex:0] objectForKey:@"guid"];
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4metatags"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
	// added by pradeep on 19 may 2011
	[userInfo release];
}

- (void) updateDataFile4Tags:(NSString *)uid:(NSString *)str {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	if ([[[stories objectAtIndex:0] objectForKey:@"userhastags"] compare:@"yes"] == NSOrderedSame)
		newPerson.strsettags = @"yes";
	else newPerson.strsettags = @"";
	newPerson.userid = [[stories objectAtIndex:0] objectForKey:@"guid"];
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4tags"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
	// added by pradeep on 19 may 2011
	[userInfo release];
}

- (void) getProfile:(NSString *) flg4whichtab {
	
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
	
	// added by pradeep on 19 may 2011
	[myArray release];
	
	//NSString *distance = @"1"; // it should be retrieved from file that contains the set value
	
	// retreiving HH:MM from HH:MM:SS using substring
	//usertime = [[usertime substringFromIndex:0] substringToIndex:5];
	
	//if ( [gbluserid compare:@""] == NSOrderedSame || !gbluserid)
	//	gbluserid = @"none";
	gbluserid = [arrayForUserID objectAtIndex:0];
	
	NSLog(@"Sending....");
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&flag2=%@",@"getuserprofile",gbllatitude,gbllongitude,gbluserid,usertime,strFrom];
	urlString = [globalUrlString stringByAppendingString:urlString];
	
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
}

- (void) getUnsocialTile {
	
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
	
	// added by pradeep on 19 may 2011
	[myArray release];
	
	//NSString *distance = @"1"; // it should be retrieved from file that contains the set value
	
	// retreiving HH:MM from HH:MM:SS using substring
	//usertime = [[usertime substringFromIndex:0] substringToIndex:5];
	
	//if ( [gbluserid compare:@""] == NSOrderedSame || !gbluserid)
	//	gbluserid = @"none";
	gbluserid = [arrayForUserID objectAtIndex:0];
	
	NSLog(@"Sending....");
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&flag2=%@",@"getdigitalbillboard",gbllatitude,gbllongitude,gbluserid,usertime,@""];
	urlString = [globalUrlString stringByAppendingString:urlString];
	
	NSLog(urlString);
	[self parseXMLFileAtURL:urlString];	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
	
	// for updating local file for digitalbillboard
	[self updateDataFile4DigitalBillboardImg:@""];
}

- (void)parseXMLFileAtURL:(NSString *)URL {
	
	// added by pradeep on 19 may 2011
	if (stories)
	{
		[stories release];
		[stories4digitalbillboard release];		
		[rssParser release];
	}
	// end 19 may 2011
	
	stories = [[NSMutableArray alloc] init];	
	stories4digitalbillboard = [[NSMutableArray alloc] init];
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
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
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
			[userid release];
			[userdevicetocken release];
			[userprefix release];
			[username release];
			[useremail release];
			[userlastuse release];
			[usercontact release];
			[usercompany release];
			
			[userwebsite release];
			[userlinkedin release];
			[userabout release];
			[userind release];
			[userindid release];
			[usersubind release];
			[userrole release];
			[userroleid release];
			
			[userallownotification release];
			[userinterestind release];
			[userinterestsubind release];
			[userinterestrole release];
			[userprofilecomplete release];
			[userdisplayitem release];
			[usersecuritylevel release];
			[userstatus release];
			
			[userhasmetatags release];
			[userhastags release];
			[userlinkedinmailid release];
			[usertitle release];
			
			// end 19 may 2011
		}
		
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		userid = [[NSMutableString alloc] init];
		userdevicetocken= [[NSMutableString alloc] init];
		userprefix = [[NSMutableString alloc] init];
		username = [[NSMutableString alloc] init];
		useremail = [[NSMutableString alloc] init];
		userlastuse = [[NSMutableString alloc] init];
		usercontact = [[NSMutableString alloc] init];
		
		usercompany = [[NSMutableString alloc] init];
		userwebsite = [[NSMutableString alloc] init];
		userlinkedin = [[NSMutableString alloc] init];
		userabout = [[NSMutableString alloc] init];
		userind = [[NSMutableString alloc] init];
		userindid = [[NSMutableString alloc] init];
		usersubind = [[NSMutableString alloc] init];
		userrole = [[NSMutableString alloc] init];
		userroleid = [[NSMutableString alloc] init];
		userallownotification = [[NSMutableString alloc] init];
		userinterestind = [[NSMutableString alloc] init];
		userinterestsubind = [[NSMutableString alloc] init];
		userinterestrole = [[NSMutableString alloc] init];		
		userprofilecomplete = [[NSMutableString alloc]init];
		userdisplayitem = [[NSMutableString alloc]init];
		usersecuritylevel = [[NSMutableString alloc]init];
		userstatus = [[NSMutableString alloc]init];
		userhasmetatags = [[NSMutableString alloc]init];
		userhastags = [[NSMutableString alloc]init]; 
		userlinkedinmailid = [[NSMutableString alloc]init];
		usertitle = [[NSMutableString alloc]init];
	}
	if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}
	// for digital billboard image
	if ([elementName isEqualToString:@"enclosuredigitalbillboard"]) {
		digitalBillBoardImageURL = [attributeDict valueForKey:@"url"];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		// save values to an item, then store that item into the array...
		[item setObject:userprefix forKey:@"prefix"];
		[item setObject:userid forKey:@"guid"];
		[item setObject:userdevicetocken forKey:@"devicetocken"]; 
		[item setObject:username forKey:@"username"]; // for blog description also date but not rite now
		[item setObject:useremail forKey:@"email"];
		
		[item setObject:userlastuse forKey:@"logindate"];
		[item setObject:usercontact forKey:@"contact"];
		[item setObject:usercompany forKey:@"company"];
		[item setObject:userwebsite forKey:@"userwebsite"];
		[item setObject:userlinkedin forKey:@"linkedinprofile"];
		[item setObject:userabout forKey:@"aboutu"];
		
		[item setObject:userind forKey:@"industry"];
		[item setObject:userindid forKey:@"industryid"];
		[item setObject:usersubind forKey:@"subindustry"];
		[item setObject:userrole forKey:@"role"];
		[item setObject:userroleid forKey:@"roleid"];
		[item setObject:userallownotification forKey:@"allownotification"];
		[item setObject:userinterestind forKey:@"interestind"];		
		[item setObject:userinterestsubind forKey:@"interestsubind"];		
		[item setObject:userinterestrole forKey:@"interestrole"];		
		[item setObject:userprofilecomplete forKey:@"profilecomplete"];
		[item setObject:userdisplayitem forKey:@"displayitem"];		
		[item setObject:usersecuritylevel forKey:@"securitylevel"];
		[item setObject:userstatus forKey:@"status"];
		[item setObject:userhasmetatags forKey:@"userhasmetatags"];
		[item setObject:userhastags forKey:@"userhastags"];
		[item setObject:userlinkedinmailid forKey:@"linkedinemailid"];		
		[item setObject:usertitle forKey:@"usertitle"];		
		
		//add the actual image as well right now into the stories array
		
		/*NSURL *url = [NSURL URLWithString:currentImageURL];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *y1 = [[UIImage alloc] initWithData:data];
		if (y1) {
			[item setObject:y1 forKey:@"itemPicture"];		
		}*/
		
		// check weather image exist for user, if not then take local shooted image by default
		
		NSURL *url = [NSURL URLWithString:currentImageURL];		
		NSString *searchForMe = @"images.png";
		NSRange range = [currentImageURL rangeOfString:searchForMe];// [searchThisString rangeOfString : searchForMe];
		// if image exist for user then use it else use default shooted img locally for user
		if (range.location == NSNotFound) 
		{
			NSLog(@"Thumbnail Image exist for this user.");
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *y1 = [[UIImage alloc] initWithData:data];
			if (y1) {
				[item setObject:y1 forKey:@"itemPicture"];		
			}
			[y1	release];
		}
		else
		{
			UIImage *y1 = [UIImage imageNamed: @"imgNoUserImage.png"];;
			//if (y1) {
			[item setObject:y1 forKey:@"itemPicture"];
			[y1	release];
		}
		
		[stories addObject:[item copy]];
		
		NSLog(@"adding story: %@", username);		
	}
	
	// for digital billboard image
	if ([elementName isEqualToString:@"enclosuredigitalbillboard"]) {
			//NSURL *url = [NSURL URLWithString:digitalBillBoardImageURL];		
		NSString *searchForMe = @"images.png";
		NSRange range = [digitalBillBoardImageURL rangeOfString:searchForMe];// [searchThisString rangeOfString : searchForMe];
		// if image exist for user then use it else use default shooted img locally for user
		if (range.location == NSNotFound) 
		{
			NSLog(@"Billboard exists for this user.");
				//START saving a small image from from local. Not downloading, to prevent login time- vaibhav (V1.1)
			//NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *y1 = [UIImage imageNamed:@"disclouser.png"];
			//END
			if (y1) {
				[item setObject:y1 forKey:@"billboardPicture"];		
			}
		}
		else
		{
			UIImage *y1 = [UIImage imageNamed: @"billboard.png"];;
			//if (y1) {
			[item setObject:y1 forKey:@"billboardPicture"];	
		}
		
		[stories4digitalbillboard addObject:[item copy]];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"prefix"]) {
		[userprefix appendString:string];
	}else if ([currentElement isEqualToString:@"guid"]) {
		[userid appendString:string];
	}else if ([currentElement isEqualToString:@"devicetocken"]) {
		[userdevicetocken appendString:string];
	}else if ([currentElement isEqualToString:@"username"]) {
		[username appendString:string];
	} 
	
	else if ([currentElement isEqualToString:@"email"]) {
		[useremail appendString:string];
	}else if ([currentElement isEqualToString:@"logindate"]) {
		[userlastuse appendString:string];
	}else if ([currentElement isEqualToString:@"contact"]) {
		[usercontact appendString:string];
	}else if ([currentElement isEqualToString:@"company"]) {
		[usercompany appendString:string];
	}else if ([currentElement isEqualToString:@"userwebsite"]) {
		[userwebsite appendString:string];
	}else if ([currentElement isEqualToString:@"linkedinprofile"]) {
		[userlinkedin appendString:string];
	}else if ([currentElement isEqualToString:@"aboutu"]) {
		[userabout appendString:string];
	}else if ([currentElement isEqualToString:@"industry"]) {
		[userind appendString:string];
	}else if ([currentElement isEqualToString:@"industryid"]) {
		[userindid appendString:string];
	}else if ([currentElement isEqualToString:@"subindustry"]) {
		[usersubind appendString:string];
	}else if ([currentElement isEqualToString:@"role"]) {
		[userrole appendString:string];
	}else if ([currentElement isEqualToString:@"roleid"]) {
		[userroleid appendString:string];
	}else if ([currentElement isEqualToString:@"allownotification"]) {
		[userallownotification appendString:string];
	}else if ([currentElement isEqualToString:@"interestind"]) {
		[userinterestind appendString:string];
	}else if ([currentElement isEqualToString:@"interestsubind"]) {
		[userinterestsubind appendString:string];
	}else if ([currentElement isEqualToString:@"interestrole"]) {
		[userinterestrole appendString:string];
	}else if ([currentElement isEqualToString:@"profilecomplete"]) {
		[userprofilecomplete appendString:string];
	}else if ([currentElement isEqualToString:@"displayitem"]) {
		[userdisplayitem appendString:string];
	}else if ([currentElement isEqualToString:@"securitylevel"]) {
		[usersecuritylevel appendString:string];
	}else if ([currentElement isEqualToString:@"currentdistance"]) {
		[usercurrentdistance appendString:string];
	}else if ([currentElement isEqualToString:@"forwhichtab"]) {
		[userforwhichtab appendString:string];
	}else if ([currentElement isEqualToString:@"status"]) {
		[userstatus appendString:string];
	}else if ([currentElement isEqualToString:@"userhasmetatags"]) {
		[userhasmetatags appendString:string];
	}else if ([currentElement isEqualToString:@"userhastags"]) {
		[userhastags appendString:string];
	}else if ([currentElement isEqualToString:@"linkedinemailid"]) {
		[userlinkedinmailid appendString:string];
	}else if ([currentElement isEqualToString:@"usertitle"]) {
		[usertitle appendString:string];
	}
	NSLog(@"%@",currentElement);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {		
	NSLog(@"all done!");
	NSLog(@"stories array for activityviewforlauncher has %d items", [stories count]);
	//[itemTableView reloadData];
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
