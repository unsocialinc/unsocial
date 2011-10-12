    //
//  PeopleAutoTagged.m
//  Unsocial
//
//  Created by vaibhavsaran on 18/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PeopleAutoTagged.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "AddTags.h"
#import "Person.h"

NSString *localuserid, *localdistance;

@implementation PeopleAutoTagged
@synthesize comingfrom;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
		// for disappearing activityvew at the header
	loading.hidden = YES;
	[activityView stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(createControls) userInfo:self.view repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	
	WhereIam = 0;
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	UINavigationItem *itemNV = self.navigationItem;
		//add background color
	self.view.backgroundColor = color;
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(btnLeft_Clcik)] autorelease];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(btnLeft_Clcik) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	
	if(comingfrom == 0) {
		self.navigationItem.leftBarButtonItem = leftcbtnitme;
	}
	else {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(btnLeft_Clcik)] autorelease];
	}
	
	// added by pradeep on 19 may 2011
	[leftbtn release];
	[leftcbtnitme release];
	// end 19 may 2011
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btnRight_click)] autorelease];
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	[imgHeadview release];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	[imgBack release];
	
	heading = [UnsocialAppDelegate createLabelControl:@"Auto Tagged People" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	if([stories4peoplemyinterest count] == 0)
		[self getPeopleData:@"autotagged"];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {

	btnAddTags = [UnsocialAppDelegate createButtonControl:@"Add Keywords" target:self selector:@selector(addTags_OnClick) frame:CGRectMake(10, 385, 140, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]]; // change the quardinates on 7 dec 2010 by pradeep (60, 385, 200, 29)
	[btnAddTags.titleLabel setFont:[UIFont fontWithName:kAppFontName size:11.5]];
	[self.view addSubview:btnAddTags];
	[btnAddTags release];
	
		// for creating btn for "Add Tags" only if "AUTO" is selected
	btnDeletePeople4Auto = [UnsocialAppDelegate createButtonControl:@"Delete People" target:self selector:@selector(btnDeletePeople4Auto_Click) frame:CGRectMake(170, 385, 140, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]]; // change the quardinates on 7 dec 2010 by pradeep (60, 385, 200, 29)
	[btnDeletePeople4Auto.titleLabel setFont:[UIFont fontWithName:kAppFontName size:11.5]];
	[self.view addSubview:btnDeletePeople4Auto];
	[btnDeletePeople4Auto release];

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (gbllatitude	== nil)
	{
			// recursion for getting longitude and latitude value
			// timer control using threading
		[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createControls) userInfo:self.view repeats:NO];
	}
	else
	{
		if ( [gbluserid compare:@""] == NSOrderedSame || !gbluserid)
		{
			//UIAlertView *saveAlert = [[UIAlertView alloc] init];
			UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Atlease complete first step for setting your profile!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[saveAlert show];
			[saveAlert release];
			//tabBarController.selectedIndex = 3;
		}
		else
		{
			// addded by pradeep on 10 feb 2011 for showing correct msg if user/tags not exist in tagged section
			//************** start 10 feb 2011
			BOOL istagsexist = [self getDataFromFile4Tags];
			NSString *strnorecfound = @"";
			
			if (istagsexist)
				strnorecfound = @"There are currently no profiles that matches your requested tags.";
			else strnorecfound = @"For Auto Tagging to work please add tags using the button below.";
			
			// old msg that shown earlier
			// @"There are currently no people in your area.\nTry again later!"
			
			//************** end 10 feb 2011
			
			if (!itemTableView)
			{
				if([stories4peoplemyinterest count] > 0)
				{
				itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 340) style:UITableViewStylePlain];
				itemTableView.delegate = self;
				itemTableView.dataSource = self;
				itemTableView.rowHeight = 115;
				itemTableView.backgroundColor = [UIColor clearColor];
				itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
				[self.view addSubview:itemTableView];
				
				
				itemTableView.hidden=NO;
					btnAddTags.frame = CGRectMake(10, 385, 140, 29);
					btnDeletePeople4Auto.hidden = NO;
					
				}
					// if no records found
				else
				{
					CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
					recnotfound = [[UILabel alloc] init];
					recnotfound.hidden = NO;
					recnotfound = [UnsocialAppDelegate createLabelControl:strnorecfound frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];	
					recnotfound.hidden = NO;
					[self.view addSubview:recnotfound];
					// 13 may 2011 by pradeep //[recnotfound release];
					itemTableView.hidden=YES;
					
					btnAddTags.frame = CGRectMake(90, 385, 140, 29);
					btnDeletePeople4Auto.hidden = YES;
				}
			}
			else 
			{			
				
				if([stories4peoplemyinterest count] != 0) 
				{
					btnAddTags.frame = CGRectMake(10, 385, 140, 29);
					btnDeletePeople4Auto.hidden = NO;
					itemTableView.hidden=NO;
					[self.view addSubview:itemTableView];
					[itemTableView reloadData];
				}
				else 
				{
					// added by pradeep on 10 feb 2011 for resolving issue # 00221 on RTH
					// ************** start 10 feb 2011
					
					CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
					recnotfound = [[UILabel alloc] init];
					recnotfound.hidden = NO;
					recnotfound = [UnsocialAppDelegate createLabelControl:strnorecfound frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];	
					recnotfound.hidden = NO;
					[self.view addSubview:recnotfound];
					// 13 may 2011 by pradeep //[recnotfound release];
					itemTableView.hidden=YES;
					
					// ************** end 10 feb 2011
					
					
					btnAddTags.frame = CGRectMake(90, 385, 140, 29);
					btnDeletePeople4Auto.hidden = YES;
				}
				
			}
		}
	}
	[pool release];
}

- (void)btnRight_click {
	
	[self.view addSubview:imgBack]; 
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	[self.view addSubview:loading];
	loading.hidden = NO;
	[activityView startAnimating];
	
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
}

- (void)startProcess {
	
	NSLog(@"refreshing the data");
	
	[stories4peoplemyinterest  removeAllObjects];
	[imageURLs4Lazyauto removeAllObjects];
	[self getPeopleData:@"autotagged"];
	if ([stories4peoplemyinterest count] == 0)
	{
			// if no records found
		
		CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
		recnotfound = [[UILabel alloc] init];
		recnotfound.hidden = NO;
		BOOL istagsexist = [self getDataFromFile4Tags];
		NSString *strnorecfound = @"";
		
		if (istagsexist)
			strnorecfound = @"There are currently no profiles that matches your requested tags.";
		else strnorecfound = @"For Auto Tagging to work please add tags using the button below.";
		recnotfound = [UnsocialAppDelegate createLabelControl:strnorecfound frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];		
		[self.view addSubview:recnotfound];
		// 13 may 2011 by pradeep //[recnotfound release];
		itemTableView.hidden=YES;
		btnAddTags.frame = CGRectMake(90, 385, 140, 29);
		btnDeletePeople4Auto.hidden = YES;		
	}
	else {
		[itemTableView reloadData];
		[self.view addSubview:itemTableView];
		itemTableView.hidden=NO;
		btnAddTags.frame = CGRectMake(10, 385, 140, 29);
		btnDeletePeople4Auto.hidden = NO;		
	}
	[self.view addSubview:heading];
	[self.view addSubview:btnAddTags];
	if([stories4peoplemyinterest count] > 0 ) {

		[self.view addSubview:btnDeletePeople4Auto];
		btnAddTags.frame = CGRectMake(10, 385, 140, 29);
		btnDeletePeople4Auto.frame = CGRectMake(170, 385, 140, 29);
	}
	else {
		
		btnAddTags.frame = CGRectMake(90, 385, 140, 29);
	}
	loading.hidden = YES;
	[activityView stopAnimating];
}

- (BOOL) getDataFromFile4Tags {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4tags"];
	NSString *strusertags = @"";
	BOOL returnresult = NO;
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
		
		
		strusertags = [[tempArray objectAtIndex:0] strsettags];
		
		[decoder finishDecoding];
		[decoder release];
		if ([strusertags compare:@""] == NSOrderedSame || [strusertags compare:@""] == NSOrderedSame) 
			;
		else returnresult = YES;	
	}
	/*else {
	 
	 return NO;
	 }*/
	return returnresult;
}

- (void) getPeopleData:(NSString *) flg4whichtab {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		// Time Formats
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];

	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	[myArray release];
	
	gbluserid = [arrayForUserID objectAtIndex:0];
		//if ([gbluserid isEqualToString:@""] || !gbluserid)
		//gbluserid = @"none";
	
	NSLog(@"Sending....");
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&distance=%@&flag2=%@",@"getpeople",gbllatitude,gbllongitude,gbluserid,usertime,localdistance,flg4whichtab];
	urlString = [globalUrlString stringByAppendingString:urlString];
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
}


- (void)parseXMLFileAtURL:(NSString *)URL {
	
	// added by pradeep on 19 may 211
	if (stories)
	{
		[stories release];
		[rssParser release];
	}
	
	stories = [[NSMutableArray alloc] init];	
	
		// for fixing bug by pradeep, case: if user has navigate people feature from spring board once, it shows rec accordingly but again use people feature from spring board, record doesn't display :(
	if (!itemTableView)
	{
		[stories4peoplearoundme removeAllObjects];
		[stories4peoplemyinterest removeAllObjects];
		[stories4peoplebookmark removeAllObjects];
	}
	
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
		//imageURLs4Lazyall = [[NSMutableArray alloc]init];
		//imageURLs4Lazyauto = [[NSMutableArray alloc]init];
		//imageURLs4Lazysaved = [[NSMutableArray alloc]init];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down."];
	NSLog(@"error parsing XML: %@", errorString);	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
		//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"ttl"])
	{
			//item4whichtab = [[NSMutableDictionary alloc]init];
			//userforwhichtab = [[NSMutableString alloc]init];
	}
	
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
			[usersubind release];
			[userrole release];
			[userallownotification release];
			[userinterestind release];
			[userinterestsubind release];
			[userinterestrole release];
			[userprofilecomplete release];
			[userdisplayitem release];
			[usersecuritylevel release];
			[userstatus release];			
			[usercurrentdistance release];
			[userforwhichtab release];
			[userlinkedinemailid release];
			[usertitle release];
			[userlevel release];
			
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
		usersubind = [[NSMutableString alloc] init];
		userrole = [[NSMutableString alloc] init];
		userallownotification = [[NSMutableString alloc] init];
		userinterestind = [[NSMutableString alloc] init];
		userinterestsubind = [[NSMutableString alloc] init];
		userinterestrole = [[NSMutableString alloc] init];		
		userprofilecomplete = [[NSMutableString alloc]init];
		userdisplayitem = [[NSMutableString alloc]init];
		usersecuritylevel = [[NSMutableString alloc]init];
		usercurrentdistance = [[NSMutableString alloc]init];
		userforwhichtab = [[NSMutableString alloc]init];
		userstatus = [[NSMutableString alloc]init];
		userlinkedinemailid = [[NSMutableString alloc]init];
		usertitle = [[NSMutableString alloc]init];
		userlevel = [[NSMutableString alloc]init];
	}
	if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
		//if ([elementName isEqualToString:@"ttl"])
		//	[item4whichtab setObject:userforwhichtab forKey:@"whichtab"];
	
	
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
		[item setObject:usersubind forKey:@"subindustry"];
		[item setObject:userrole forKey:@"role"];
		[item setObject:userallownotification forKey:@"allownotification"];
		[item setObject:userinterestind forKey:@"interestind"];		
		[item setObject:userinterestsubind forKey:@"interestsubind"];		
		[item setObject:userinterestrole forKey:@"interestrole"];		
		[item setObject:userprofilecomplete forKey:@"profilecomplete"];
		[item setObject:userdisplayitem forKey:@"displayitem"];		
		[item setObject:usersecuritylevel forKey:@"securitylevel"];
		[item setObject:usercurrentdistance forKey:@"currentdistance"];
		[item setObject:userforwhichtab forKey:@"forwhichtab"];
		[item setObject:userstatus forKey:@"status"];
		[item setObject:userlinkedinemailid forKey:@"linkedinemailid"];
		[item setObject:usertitle forKey:@"usertitle"];
		[item setObject:userlevel forKey:@"level"];

		[stories addObject:[item copy]];
		[stories4peoplemyinterest addObject:[item copy]];
		[imageURLs4Lazyauto addObject:currentImageURL];
		NSLog(@"adding story: %@", username);		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

	if ([currentElement isEqualToString:@"ttl"]) 
	{
		/*
			//	[userforwhichtab appendString:string];
		
		if ([string compare:@"everyone"] == NSOrderedSame)
			whichsegmentselectedlasttime = 0;
		else if ([string compare:@"autotagged"] == NSOrderedSame)
			whichsegmentselectedlasttime = 1;
		else if ([string compare:@"bookmark"] == NSOrderedSame)
			whichsegmentselectedlasttime = 2;*/
	}
	
	else if ([currentElement isEqualToString:@"prefix"]) {
		[userprefix appendString:string];
	}else if ([currentElement isEqualToString:@"guid"]) {
		[userid appendString:string];
	}else if ([currentElement isEqualToString:@"devicetocken"]) {
		[userdevicetocken appendString:string];
	}else if ([currentElement isEqualToString:@"username"]) {
		[username appendString:string];
	}else if ([currentElement isEqualToString:@"email"]) {
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
	}else if ([currentElement isEqualToString:@"subindustry"]) {
		[usersubind appendString:string];
	}else if ([currentElement isEqualToString:@"role"]) {
		[userrole appendString:string];
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
	}else if ([currentElement isEqualToString:@"linkedinemailid"]) {
		[userlinkedinemailid appendString:string];
	}else if ([currentElement isEqualToString:@"usertitle"]) {
		[usertitle appendString:string];
	}else if ([currentElement isEqualToString:@"level"]) {
		[userlevel appendString:string];
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

	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
	}
	else {
		AsyncImageView* oldImage = (AsyncImageView*)
		[cell.contentView viewWithTag:999];
		[oldImage removeFromSuperview];
	}
	
	UIImageView *imgPplBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 0, 320, 115) imageName:@"peopleback.png"];
	[cell.contentView addSubview:imgPplBack];
	
		//Dynamic label
	lblStatus = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(89, 75, 215, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleStatus txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
		// Set up the cell...
	
	#pragma mark People aroundme
	
	NSString *strdeeptaggedon = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"logindate"];	
	NSLog(@"Last seen: %@", strdeeptaggedon);

	lblStatus.text = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"status"];
	[cell.contentView addSubview:lblStatus];
	
		//*************** lazy img code start
	
	CGRect frame;
	frame.size.width=65; frame.size.height=65;
	frame.origin.x=9; frame.origin.y=11;
	asyncImage = [[[AsyncImageView alloc]
				   initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	NSURL*url = [NSURL URLWithString:[imageURLs4Lazyauto objectAtIndex:indexPath.row]];
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
		//[asyncImage release];
	
		//*************** lazy img code end
	
	NSString *usrname =[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"username"];
	
	if ([[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"username"] length] > 18)			
		usrname = [[usrname substringWithRange:NSMakeRange(0, 18)] stringByAppendingString:@"..."];
	
	CGRect lableNameFrame = CGRectMake(89, 4, 165, 18);	
	lblUserName = [UnsocialAppDelegate createLabelControl:usrname frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableCellHeading txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblUserName];
		// starts 14 Jun for linkedin user identification - v1.8vaibhav  
	NSString *prefix = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"prefix"];
	
	NSString *firstLevel = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"level"];
		//ends
	NSString *displayitem = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"displayitem"];
	NSString *isindustryshow = [[displayitem substringFromIndex:1] substringToIndex:1];
	NSString *iscompanyshow = [[displayitem substringFromIndex:2] substringToIndex:1];
	
	UILabel *lblcompany = [UnsocialAppDelegate createLabelControl:@"Company: " frame:CGRectMake(lableNameFrame.origin.x, 27, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblcompany];
	
	UILabel *lblindustry = [UnsocialAppDelegate createLabelControl:@"Industry: " frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 16, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblindustry];
	
	UILabel *lblfunction = [UnsocialAppDelegate createLabelControl:@"Function:" frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 32, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblfunction];
	
		// for company **** start ****
		// if company is set as private then it will be as 1 else 0
	CGRect lableCompanyFrame = CGRectMake(152, lblcompany.frame.origin.y, 140, 15);		
	lblCompanyName = [UnsocialAppDelegate createLabelControl:[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"company"] frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	
		// starts 14 jun - vaibhav v1.8
	if ([firstLevel isEqualToString:@"yes"]) // user is 1st level connection to self
	{
		CGRect flevFrame = CGRectMake(38, 85, 30, 16);
		UIButton *btnFLev = [UnsocialAppDelegate  createButtonControl:@"" target:self selector:@selector(btnFLev_click:) frame:flevFrame imageStateNormal:@"1stlev.png" imageStateHighlighted:@"1stlev.png" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
			//createImageViewControl:flevFrame imageName:@"1stlev.png"];
		[cell.contentView addSubview:btnFLev];
	}
	
	if ([prefix isEqualToString:@"none"]) // show linkedin icon if user is linkedin
	{
		UIImageView *flev = [UnsocialAppDelegate createImageViewControl:CGRectMake(12, 85, 16, 16) imageName:@"linkedinIcon.png"];
		[cell.contentView addSubview:flev];
	}
		//ends
	
	if ([iscompanyshow compare:@"0"] != NSOrderedSame) // company is private i.e. 1
	{
		CGRect lableLockFrame = CGRectMake(149, lblcompany.frame.origin.y, 15, 15);
		userImage = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
		[cell.contentView addSubview:userImage];
	}
	else {
		
		if([lblCompanyName.text compare:@""] == NSOrderedSame)
			
			lblCompanyName.text = @"not set";
		else				
			lblCompanyName.text = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"company"];
		
		[cell.contentView addSubview:lblCompanyName];
	}
	
		// for company **** end ****
		// if industry is set as private then it will be as 1 else 0
	CGRect lableIndustryFrame = CGRectMake(148, lblcompany.frame.origin.y + 16, 140, 15);
	
	lblIndustryName = [UnsocialAppDelegate createLabelControl:[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"industry"] frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	
	if ([isindustryshow compare:@"0"] != NSOrderedSame) // industry is private i.e. 1
	{		
		CGRect lableLockFrame = CGRectMake(150, lblcompany.frame.origin.y + 16, 15, 15);
		userImage = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
		[cell.contentView addSubview:userImage];
	}
	else {
		
		if ([lblIndustryName.text compare:@""] == NSOrderedSame)
			
			lblIndustryName.text = @"not set";
		else				
			lblIndustryName.text = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"industry"];
		[cell.contentView addSubview:lblIndustryName];
	}
		// for Industry **** end ****
	
		//for role ****start**********		
	CGRect lableRoleFrame = CGRectMake(150, lblcompany.frame.origin.y + 32, 195, 15);
	lblFunctionName = [UnsocialAppDelegate createLabelControl:[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"role"] frame:lableRoleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	
	if ([[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"role"] isEqualToString:@""])
		lblFunctionName.text = @"not set";
	
	[cell.contentView addSubview:lblFunctionName];
	// 13 may 2011 by pradeep //[lblFunctionName release];
	
		// for role *****end **********
	
		// for distance ******start*******		
	CGRect lableDistanceFrame = CGRectMake(212, lableNameFrame.origin.y, 100, 18);
	lblUserName = [UnsocialAppDelegate createLabelControl:@"" frame:lableDistanceFrame txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	
	NSString *showDistance;
	NSArray *aryMiles = [[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"currentdistance"] componentsSeparatedByString:@" Miles"];
	
	float floatMiles = [[aryMiles objectAtIndex:0] floatValue];
	if(floatMiles <= 1.00) {
		
		showDistance = @"Steps Away";
			//lblUserName.textColor = [UIColor orangeColor];
	}
	else if(floatMiles < 5.00) {
		
		if(floatMiles > 1.00) {
			
			showDistance = @"Short Distance";
				//lblUserName.textColor = [UIColor yellowColor];
		} 
	}
	else {
		showDistance = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"currentdistance"]; 
			//lblUserName.textColor = [UIColor whiteColor];
	}
	lblUserName.textColor = [UIColor orangeColor];
	lblUserName.text = showDistance;
	[cell.contentView addSubview:lblUserName];
	
	// 13 may 2011 by pradeep //[lblcompany release];
	// 13 may 2011 by pradeep //[lblindustry release];
	// 13 may 2011 by pradeep //[lblfunction release];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	// added by pradeep on 2 june 2011 for updating newly tagged user's status as visited
	[self updateNewlyTaggedUserAsViewed4Badge:@"updatenewlytaggeduservisitedstatus" :[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"guid"]];
	// end 2 june 2011
	
	// Navigation logic may go here. Create and push another view controller.
	peoplesUserProfile = [[PeoplesUserProfile alloc]init];
	peoplesUserProfile.myname  = [myName objectAtIndex:0];
	 peoplesUserProfile.userid = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"guid"];				peoplesUserProfile.username = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"username"];
	 peoplesUserProfile.userprefix = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"prefix"];
	 
	if([[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"prefix"] isEqualToString:@"none"]) {
		
		peoplesUserProfile.useremail = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"linkedinemailid"];
		peoplesUserProfile.userlinkedintoken = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"email"];
	}
	else
		peoplesUserProfile.useremail = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"email"];
	 
	 peoplesUserProfile.usercontact = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"contact"];
	 peoplesUserProfile.usertitle = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"usertitle"];
	peoplesUserProfile.userlevel = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"level"];	
	 peoplesUserProfile.usercompany = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"company"];	
	 peoplesUserProfile.userwebsite = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"userwebsite"];
	 peoplesUserProfile.userlinkedin = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"linkedinprofile"];	
	 peoplesUserProfile.userabout = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"aboutu"];	
	 peoplesUserProfile.userind = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"industry"];	
	 peoplesUserProfile.usersubind = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"subindustry"];
	 peoplesUserProfile.userrole = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"role"];	
	 peoplesUserProfile.userintind = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"interestind"];
	 
	 peoplesUserProfile.userintsubind = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"interestsubind"];	
	 peoplesUserProfile.userintrole = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"interestrole"];
	 peoplesUserProfile.userdisplayitem = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"displayitem"];	
	 peoplesUserProfile.userintind = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"interestind"];
	 peoplesUserProfile.fullImg = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	 
	 //******************** for lazi img start
	 
	 //NSURL *url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
	 //[aryEventDetails addObject:[imageURLs4Lazy objectAtIndex:indexPath.row]];
	 peoplesUserProfile.imgurl = [imageURLs4Lazyauto objectAtIndex:indexPath.row];	
	 peoplesUserProfile.camefromwhichoption = @"peopleautotags";
	 
	 //******************** for lazi img end
	 
	 peoplesUserProfile.profileforwhichtab = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"forwhichtab"];
	 
	 peoplesUserProfile.statusmgs = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"status"];
	 peoplesUserProfile.strdistance = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"currentdistance"];
	 
	 // added by pradeep for implementing auto tagged feature 7 dec 2010
	 //*****
	 peoplesUserProfile.taggedon = [NSString stringWithFormat:@"Tagged on: %@",[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"logindate"]];
	[self.navigationController pushViewController:peoplesUserProfile animated:YES];
	[peoplesUserProfile release];
}

// added by pradeep on 2 june 2011 for updating tagged user's badge as viewed
- (NSInteger) updateNewlyTaggedUserAsViewed4Badge: (NSString *) flag: (NSString *) taggedUserID
{
	NSLog(@"Sending  for updateNewlyTaggedUserAsViewed4Badge....");
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
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	NSString *varTaggedUserID = [NSString stringWithFormat:@"%@\r\n",taggedUserID];	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"taggeduserid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varTaggedUserID] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
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
		if ([key isEqualToString:@"Resmsg"])
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				NSLog(@"\n\n\n\n\n\n#######################-- post For updating newly tagged user's status as viewd successfully --#######################\n\n\n\n\n\n");
				//unreadmsg = [[dic objectForKey:key] intValue];				
				successflg=YES;				
				//userid = [dic objectForKey:key];
				
				/*NSString *strbadgevalue = [NSString stringWithFormat:@"%i", gblTotalNewlyTaggedUsers4Badge];
				if(gblTotalNewlyTaggedUsers4Badge != 0)
					inBoxviewcontroller.tabBarItem.badgeValue = strbadgevalue;
				else if (unreadmsg==0)
					inBoxviewcontroller.tabBarItem.badgeValue= nil;*/
				
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
// end 2 june 2011

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		//return [stories count];
	int totelements=0;
	if ([stories count]>0)
		if ([[[stories objectAtIndex:0] objectForKey:@"forwhichtab"] isEqualToString:@"everyone"])
			totelements = [stories4peoplearoundme count];
		else if ([[[stories objectAtIndex:0] objectForKey:@"forwhichtab"] isEqualToString:@"autotagged"])
			totelements =  [stories4peoplemyinterest count];
		else if ([[[stories objectAtIndex:0] objectForKey:@"forwhichtab"] isEqualToString:@"bookmark"])
			totelements =  [stories4peoplebookmark count];
	return totelements;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

	
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
			// Delete the row from the data source
		[self sendReqForDeleteAutoTaggedPeople:indexPath.row];
		[stories4peoplemyinterest removeObjectAtIndex:indexPath.row];
		[imageURLs4Lazyauto removeObjectAtIndex:indexPath.row];
		[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		if([stories4peoplemyinterest count] == 0)
		{
			recnotfound = [UnsocialAppDelegate createLabelControl:@"There are currently no profiles that matches your requested tags." frame:CGRectMake(10, 160, 300, 130) txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			recnotfound.hidden = NO;
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDuration:0.5];
			[UIView setAnimationBeginsFromCurrentState:YES];
			
			btnDeletePeople4Auto.hidden = YES;
			btnAddTags.frame = CGRectMake(90, 385, 140, 29);
			
			[UIView commitAnimations];
			[self.view addSubview:recnotfound];
			// 13 may 2011 by pradeep //[recnotfound release];
			self.navigationItem.rightBarButtonItem.enabled = YES;
			self.navigationItem.leftBarButtonItem.enabled = YES;
			[itemTableView setEditing:NO animated:YES];	
			editing = NO;
		}
	}
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
		// Detemine if it's in editing mode
    if (itemTableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
	else
		return UITableViewCellEditingStyleNone;
}


-(void) addTags_OnClick
{
	AddTags *viewcontroller = [[AddTags alloc]init];
	[[self navigationController] pushViewController:viewcontroller animated:YES];
	//[viewcontroller release];
}

// added by pradeep on 7 dec 2010 for deleting auto tagged people
//*********************
- (void)btnDeletePeople4Auto_Click {
		//Do not let the user add if the app is in edit mode.
	if(!editing)
	{
		self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = NO;
		[itemTableView setEditing:YES animated:YES];	
		editing = YES;
	}
	else
	{
		self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
		[itemTableView setEditing:NO animated:YES];	
		editing = NO;
	}
}
	//********************** end 7 dec 2010

	// ********************* START 8 DEC 2010 for deleting auto tagged user

- (NSInteger) sendReqForDeleteAutoTaggedPeople:(NSInteger) storyIndex {
	NSLog(@"Sending....");
		//NSData *imageData1;
	
	
		// setting up the URL to post to
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];	
		// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	NSString *flag = @"deleteautotaggedpeople";
	
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
	
	NSString *varAutoTaggedPeopleId = [NSString stringWithFormat:@"%@\r\n",[[stories objectAtIndex:storyIndex] objectForKey:@"guid"]];	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	[myArray release];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"taggeduserid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varAutoTaggedPeopleId] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
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
			//if ([key compare:@"Totunreadmsg"] == NSOrderedSame)			
		{
				//if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				/*unreadmsg = [[dic objectForKey:key] intValue];				
				 successflg=YES;				
				 //userid = [dic objectForKey:key];
				 
				 NSString *strbadgevalue = [NSString stringWithFormat:@"%i", unreadmsg];
				 if(unreadmsg != 0)
				 inBoxviewcontroller.tabBarItem.badgeValue = strbadgevalue;
				 else if (unreadmsg==0)
				 inBoxviewcontroller.tabBarItem.badgeValue= nil;*/
				
					//break;
			}
		}
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	[returnString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}


- (void)btnLeft_Clcik { 
	
	[stories4peoplemyinterest removeAllObjects];
	[lastVisitedFeature removeAllObjects];
	[lastVisitedFeature addObject:@"peopleautotagged"];
	
	if(comingfrom != 1)
	{
		[imageURLs4Lazyall removeAllObjects];
		[imageURLs4Lazyauto removeAllObjects];
		[imageURLs4Lazysaved removeAllObjects];
		[self dismissModalViewControllerAnimated:YES];
	}
	else {
		
		comingfrom = 0;
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	// added by pradeep on 29 june 2011
	//itemTableView.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
}


@end
