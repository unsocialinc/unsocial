//
//  Tags.m
//  Unsocial
//
//  Created by vaibhavsaran on 28/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Tags.h"
#import "GlobalVariables.h"
#import "Person.h"
#import "AddTags.h"
#import "UnsocialAppDelegate.h"
#import "SearchViewController.h"
#import "PeoplesUserProfile.h"

int whichsegmentselectedlasttime4tag;
int arivefirsttime4tag;
BOOL allInteresttag = NO;

@implementation Tags

@synthesize puserid;

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	/*imgBack = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BlankTemplate2.png"]];
	[self.view addSubview:imgBack];
	tags = [[Tags alloc]init];*/
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"BlankTemplate2.png"];
	[self.view addSubview:imgBack];
	
	imgForOverlap = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgForOverlap.image = [UIImage imageNamed:@"BlankTemplate2.png"];
	[self.view addSubview:imgForOverlap];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor darkGrayColor] backgroundcolor:[UIColor clearColor]];
	loading = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Searching unsocial\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor darkGrayColor] backgroundcolor:[UIColor clearColor]];
	loading.hidden = NO;
	imgForOverlap.hidden = NO;
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 210, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	[activityView startAnimating];
}

- (void)createControls {
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightbtn_OnClick)] autorelease];
	
	if (gbllatitude	== nil) {
		
		// recursion for getting longitude and latitude value
		// timer control using threading
		[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createControls) userInfo:self.view repeats:NO];
	}
	else	{
		
		NSArray *segmentTextContent = [NSArray arrayWithObjects:@"Auto Tagged", @"Search", nil];
		segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
		segmentedControl.frame = CGRectMake(34, 15, 252, 35);
		[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
		[segmentedControl setImage:[UIImage imageNamed:@"AutoTagged_transbg.png"] forSegmentAtIndex:0];
		[segmentedControl setImage:[UIImage imageNamed:@"Search_transbg.png"] forSegmentAtIndex:1];
		//		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;	
		//		segmentedControl.tintColor = [UIColor colorWithRed:0.00/255.0 green:157.0/255.0 blue:14.0/255.0 alpha:1.0];
		//if (arivefirsttime4event==0)
		segmentedControl.selectedSegmentIndex = whichsegmentselectedlasttime4tag;
		[self.view addSubview:segmentedControl];
		[self segmenteHoverImage:NO :YES];
		[segmentedControl release];
	}
}

- (void)segmenteHoverImage:(BOOL)seg1: (BOOL)seg2 {
	
	imgSelectedSeg1 = [UnsocialAppDelegate createImageViewControl:CGRectMake(32, 14, 126, 37) imageName:@"grey50.png"];
	[self.view addSubview:imgSelectedSeg1];
	
	imgSelectedSeg2 = [UnsocialAppDelegate createImageViewControl:CGRectMake(155, 14, 126, 37) imageName:@"grey50.png"];
	[self.view addSubview:imgSelectedSeg2];
	imgSelectedSeg1.hidden = seg1;
	imgSelectedSeg2.hidden = seg2;
}

- (void)leftbtn_OnClick { 
	
	[lastVisitedFeature removeAllObjects];
	[lastVisitedFeature addObject:@"tags"];
	[self dismissModalViewControllerAnimated:YES];
//	[self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadTable_Click {
	
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
	
	[self getDataFromFile];
	//[self getDataFromFile4PeopleDistance];
	//[self getPeopleData:@"notset"];
	if (segmentedControl.selectedSegmentIndex==0)
	{
		[stories removeAllObjects];//= nil;
		//stories4peoplearoundme=[[NSMutableArray alloc]init];
		[self getPeopleData:@"autotagged"];
		if ([stories count] == 0)
		{
			// if no records found
			
			CGRect lableRecNotFrame = CGRectMake(22, 40, 270, 30);
			//recnotfound = [[UILabel alloc] init];
			
			recnotfound = [UnsocialAppDelegate createLabelControl:@"People not found for selected criteria!" frame:lableRecNotFrame txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor redColor] backgroundcolor:[UIColor clearColor]];	
			recnotfound.hidden = NO;
			[self.view addSubview:recnotfound];
			// 13 may 2011 by pradeep //[recnotfound release];
			itemTableView.hidden=YES;
		}
		else 
		{
			if (!itemTableView)
			{
				itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, 320, 350) style:UITableViewStylePlain];
				itemTableView.delegate = self;
				itemTableView.dataSource = self;
				itemTableView.rowHeight = 100;
				itemTableView.backgroundColor = [UIColor clearColor];
				itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
				[self.view addSubview:itemTableView];
				itemTableView.hidden=NO;
			}
			else
			{
				[itemTableView reloadData];
				[self.view addSubview:itemTableView];
				itemTableView.hidden=NO;
			}
		}
	}
	else if (segmentedControl.selectedSegmentIndex==1)
	{
		SearchViewController *viewcontroller = [[SearchViewController alloc] init];
		[self.navigationController pushViewController:viewcontroller animated:YES];
	}
	/*else if (segmentedControl.selectedSegmentIndex==2)
	{
		[stories4peoplebookmark removeAllObjects];
		//stories4peoplemyinterest==[[NSMutableArray alloc]init];
		[self getPeopleData:@"bookmark"];
		if ([stories4peoplebookmark count] == 0)
		{
			// if no records found
			
			CGRect lableRecNotFrame = CGRectMake(22, 40, 270, 30);
			recnotfound = [[UILabel alloc] init];
			recnotfound.hidden = NO;
			recnotfound = [UnsocialAppDelegate createLabelControl:@"People not found for selected criteria!" frame:lableRecNotFrame txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor redColor] backgroundcolor:[UIColor clearColor]];	
			[self.view addSubview:recnotfound];
			[recnotfound release];
			itemTableView.hidden=YES;
			
		}
		else {
			[itemTableView reloadData];
			[self.view addSubview:itemTableView];
			itemTableView.hidden=NO;
		}
	}*/
	
	[self.view addSubview:segmentedControl];
	[self segmenteHoverImage:NO :YES];
	loading.hidden = YES;
	imgForOverlap.hidden = YES;
	[activityView stopAnimating];
	//[self.view addSubview:btnSetMiles];
}

- (void)rightbtn_OnClick {
	
	AddTags *viewcontroller = [[AddTags alloc]init];
	//peopleEventSetDistance.peopleOrEvent = 2;
	//peopleEventSetDistance.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[[self navigationController] pushViewController:viewcontroller animated:YES];
	[viewcontroller release];
}

- (void) getPeopleData:(NSString *) flg4whichtab {
	
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
	
	if ( [gbluserid compare:@""] == NSOrderedSame || !gbluserid)
		gbluserid = @"none";
	
	NSLog(@"Sending....");
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&distance=%@&flag2=%@",@"getpeople",gbllatitude,gbllongitude,gbluserid,usertime,@"0",flg4whichtab];
	urlString = [globalUrlString stringByAppendingString:urlString];
	
	NSLog(urlString);
	
	//old request format
	//NSString *urlString = [NSString stringWithFormat:@"http://rstrings.com/eatngo/iPhone/IPhoneEatNGoRSS.aspx?flg=%@&latitude=%@&longitude=%@",@"bestdeal",latstr,longstr];
	//new request format
	//NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.10/eatngo/iPhone/IPhoneEatNGoRSS.aspx?flg=%@&latitude=%@&longitude=%@&reqtime=%@&location=%@&searchfilter=%@",@"opennow",latstr,longstr,usertime,currentlocation,searchcriteria];
	//NSString *urlString = [NSString stringWithFormat:@"http://rstrings.com/eatngo/iPhone/IPhoneEatNGoRSS.aspx?flg=%@&latitude=%@&longitude=%@&reqtime=%@&location=%@&searchfilter=%@",@"opennow",latstr,longstr,usertime,currentlocation,searchcriteria];
	//NSString *urlString = [NSString stringWithFormat:@"http://rstrings.com/eatngo/iPhone/IPhoneEatNGoRSS.aspx?flg=%@&latitude=%@&longitude=%@&reqtime=%@&location=%@&searchfilter=%@",@"opennow",latstr,longstr,usertime,currentlocation,searchcriteria];
	[self parseXMLFileAtURL:urlString];	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//return successflg;
	[pool release];
}

- (BOOL) getDataFromFile {
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
		
		myName = [[NSMutableArray alloc]init];
		[myName addObject:[[tempArray objectAtIndex:0] username]];
		
		//for setting global variables
		NSLog(@"%@", [[tempArray objectAtIndex:0] userid]);
		gbluserid = [[tempArray objectAtIndex:0] userid];
		//arrayForUserID = [[NSMutableArray alloc]init];
		if ([arrayForUserID count]==0)
			[arrayForUserID addObject:[[tempArray objectAtIndex:0] userid]];
		
		[decoder finishDecoding];
		[decoder release];	
		
		//if ( [username compare:@""] == NSOrderedSame || !username)
		if ( [puserid compare:@""] == NSOrderedSame || !puserid)
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
		//[self CreateFile];
		return NO;
	}
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
		[item setObject:userlevel forKey:@"level"];
		
		//add the actual image as well right now into the stories array
		
		NSURL *url = [NSURL URLWithString:currentImageURL];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *y1 = [[UIImage alloc] initWithData:data];
		if (y1) {
			[item setObject:y1 forKey:@"itemPicture"];		
		}
		
		[stories addObject:[item copy]];
		if ([userforwhichtab compare:@"everyone"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==0)
			[stories4peoplearoundme addObject:[item copy]];
		else if ([userforwhichtab compare:@"myinterest"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==1)
			[stories4peoplemyinterest addObject:[item copy]];
		else if ([userforwhichtab compare:@"bookmark"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==2)
			[stories4peoplebookmark addObject:[item copy]];
		NSLog(@"adding story: %@", username);		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"ttl"]) 
	{
		//	[userforwhichtab appendString:string];
		
		
			whichsegmentselectedlasttime4tag = 0;
			}
	
	else if ([currentElement isEqualToString:@"prefix"]) {
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
	}else if ([currentElement isEqualToString:@"level"]) {
		[userlevel appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {		
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stories count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil)
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];    
    // Set up the cell...

	//use in future
	//********************************************************************
	// for aroundme tab by using stories4peoplearoundme
	if (segmentedControl.selectedSegmentIndex==0)
	{
		UIImage *imageforresize = [[stories  objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		CGImageRef realImage = imageforresize.CGImage;
		float realHeight = CGImageGetHeight(realImage);
		float realWidth = CGImageGetWidth(realImage);
		float ratio = realHeight/realWidth;
		float modifiedWidth = 60/ratio;
		
		CGRect imageRect = CGRectMake(3, 20, modifiedWidth + 15, 75 );
		
		UIImageView *usrImage = [[UIImageView alloc] initWithFrame:imageRect];
		usrImage.image = [[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		[cell.contentView addSubview:usrImage];
		[usrImage release];
		[cell.contentView addSubview:usrImage];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UIImageView *userImageOver = [[UIImageView alloc] initWithFrame:imageRect];
		userImageOver.image = [UIImage imageNamed:@"ovrlay.png"];
		[cell.contentView addSubview:userImageOver];
		[userImageOver release];
		
		NSString *usrname =[[stories objectAtIndex:indexPath.row] objectForKey:@"username"];
		
		if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"username"] length] > 22)			
			usrname = [[usrname substringWithRange:NSMakeRange(0,21)] stringByAppendingString:@"..."];
		
		
		CGRect lableNameFrame = CGRectMake(3, 1, 314, 18);		
		lblUserName = [UnsocialAppDelegate createLabelControl:usrname frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor darkGrayColor]];
		[cell.contentView addSubview:lblUserName];
		
			// starts 14 Jun for linkedin user identification - v1.8vaibhav  
		NSString *prefix = [[stories objectAtIndex:indexPath.row] objectForKey:@"prefix"];
		
		NSString *firstLevel = [[stories objectAtIndex:indexPath.row] objectForKey:@"level"];
			//ends		
		
		NSString *displayitem = [[stories objectAtIndex:indexPath.row] objectForKey:@"displayitem"];
		NSString *isindustryshow = [[displayitem substringFromIndex:1] substringToIndex:1];
		NSString *iscompanyshow = [[displayitem substringFromIndex:2] substringToIndex:1];
		
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
		
		// for company **** start ****
		// if company is set as private then it will be as 1 else 0
		if ([iscompanyshow compare:@"0"] != NSOrderedSame) // company is private i.e. 1
		{
			CGRect lableCompanyFrame = CGRectMake(110, 22.0+20, 55, 15);
			
			lblUserName = [UnsocialAppDelegate createLabelControl:@"Company:" frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];	
			[cell.contentView addSubview:lblUserName];
			
			CGRect lableLockFrame = CGRectMake(160, 22.0+20, 15, 15);
			userImage = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
			[cell.contentView addSubview:userImage];
		}
		else {
			CGRect lableCompanyFrame = CGRectMake(110, 22.0+20, 240, 15);
			
			lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"company"] frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];	
			
			if ([lblUserName.text compare:@""] == NSOrderedSame)
				lblUserName = [UnsocialAppDelegate createLabelControl:@"Company: not set" frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
			else {
				lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"company"] frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
			}
			
			
			[cell.contentView addSubview:lblUserName];
		}
		// for company **** end ****
		
		// if industry is set as private then it will be as 1 else 0
		if ([isindustryshow compare:@"0"] != NSOrderedSame) // industry is private i.e. 1
		{
			CGRect lableIndustryFrame = CGRectMake(110, 38.0+20, 195, 15);
			
			lblUserName = [UnsocialAppDelegate createLabelControl:@"Industry:" frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];	
			[cell.contentView addSubview:lblUserName];
			
			CGRect lableLockFrame = CGRectMake(160, 38.0+20, 15, 15);
			userImage = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
			[cell.contentView addSubview:userImage];
		}
		else {
			CGRect lableIndustryFrame = CGRectMake(110, 38.0+20, 195, 15);
			
			lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"industry"] frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];	
			
			if ([lblUserName.text compare:@""] == NSOrderedSame)
				lblUserName = [UnsocialAppDelegate createLabelControl:@"Industry: not set" frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
			else {
				lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"industry"] frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
			}
			
			
			[cell.contentView addSubview:lblUserName];
		}
		// for Industry **** end ****
		
		//for role ****start**********
		
		CGRect lableRoleFrame = CGRectMake(110, 54.0+20, 195, 15);
		lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"role"] frame:lableRoleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blueColor] backgroundcolor:[UIColor clearColor]];	
		
		if ([lblUserName.text compare:@""] == NSOrderedSame)
			lblUserName = [UnsocialAppDelegate createLabelControl:@"Role: not set" frame:lableRoleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
		
		[cell.contentView addSubview:lblUserName];
		
		
		// for role *****end **********
		
		// for distance ******start*******
		
		CGRect lableDistanceFrame = CGRectMake(217, 1, 100, 18);
		lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"] frame:lableDistanceFrame txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor darkGrayColor]];	
		[cell.contentView addSubview:lblUserName];
		
		
	} // close if for aroundme
	UIImageView *imgDisClo = [[UIImageView alloc]initWithFrame:CGRectMake(295, 45, 19, 22)];
	imgDisClo.image = [UIImage imageNamed:@"disclouserindic.png"];
	[cell.contentView addSubview:imgDisClo];
	return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	PeoplesUserProfile *peoplesUserProfile = [[PeoplesUserProfile alloc]init];
	peoplesUserProfile.myname  = [myName objectAtIndex:0];
	
	// for aroundme tab by using stories
	if (segmentedControl.selectedSegmentIndex==0)
	{
		peoplesUserProfile.userid = [[stories objectAtIndex:indexPath.row] objectForKey:@"guid"];	
		peoplesUserProfile.username = [[stories objectAtIndex:indexPath.row] objectForKey:@"username"];
		peoplesUserProfile.userprefix = [[stories objectAtIndex:indexPath.row] objectForKey:@"prefix"];
		
		//peoplesUserProfile.useremail = [[stories objectAtIndex:indexPath.row] objectForKey:@"email"];
		if([[[stories objectAtIndex:indexPath.row] objectForKey:@"prefix"] isEqualToString:@"none"]) {
			
			peoplesUserProfile.useremail = [[stories objectAtIndex:indexPath.row] objectForKey:@"linkedinemailid"];
			peoplesUserProfile.userlinkedintoken = [[stories objectAtIndex:indexPath.row] objectForKey:@"email"];
		}
		else
			peoplesUserProfile.useremail = [[stories objectAtIndex:indexPath.row] objectForKey:@"email"];
		
		peoplesUserProfile.usercontact = [[stories objectAtIndex:indexPath.row] objectForKey:@"contact"];
		peoplesUserProfile.usercompany = [[stories objectAtIndex:indexPath.row] objectForKey:@"company"];	
		peoplesUserProfile.userlevel = [[stories objectAtIndex:indexPath.row] objectForKey:@"level"];	
		peoplesUserProfile.userwebsite = [[stories objectAtIndex:indexPath.row] objectForKey:@"userwebsite"];
		peoplesUserProfile.userlinkedin = [[stories objectAtIndex:indexPath.row] objectForKey:@"linkedinprofile"];	
		peoplesUserProfile.userabout = [[stories objectAtIndex:indexPath.row] objectForKey:@"aboutu"];	
		peoplesUserProfile.userind = [[stories objectAtIndex:indexPath.row] objectForKey:@"industry"];	
		peoplesUserProfile.usersubind = [[stories objectAtIndex:indexPath.row] objectForKey:@"subindustry"];
		peoplesUserProfile.userrole = [[stories objectAtIndex:indexPath.row] objectForKey:@"role"];	
		peoplesUserProfile.userintind = [[stories objectAtIndex:indexPath.row] objectForKey:@"interestind"];
		
		peoplesUserProfile.userintsubind = [[stories objectAtIndex:indexPath.row] objectForKey:@"interestsubind"];	
		peoplesUserProfile.userintrole = [[stories objectAtIndex:indexPath.row] objectForKey:@"interestrole"];
		peoplesUserProfile.userdisplayitem = [[stories objectAtIndex:indexPath.row] objectForKey:@"displayitem"];	
		peoplesUserProfile.userintind = [[stories objectAtIndex:indexPath.row] objectForKey:@"interestind"];
		peoplesUserProfile.fullImg = [[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		peoplesUserProfile.profileforwhichtab = [[stories objectAtIndex:indexPath.row] objectForKey:@"forwhichtab"];
		
		// addded by pradeep on 6 july 2011 for getting from where we are going to user profile section for note feature
		peoplesUserProfile.camefromwhichoption = @"tags";
		// end 6 july 2011
	}
	
	[self.navigationController pushViewController:peoplesUserProfile animated:YES];
}

- (void)segmentAction:(id)sender {
	[self getDataFromFile];
	//[self getDataFromFile4tagDistance];
	NSLog(@"segmentAction: selected segment = %d", [sender selectedSegmentIndex]);	
	int selectedSegment = [sender selectedSegmentIndex];
	
	if(selectedSegment==0)
	{
		arivefirsttime4tag = 1;
		whichsegmentselectedlasttime4tag = 0;//segmentedControl.selectedSegmentIndex;
		if (!itemTableView)
			[self getPeopleData:@"autotagged"];
		
		if (!itemTableView)
		{				
			//[self getPeopleData:@"notset"];
			
			if([stories count] > 0)
			{
				
				itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, 320, 350) style:UITableViewStylePlain];
				itemTableView.delegate = self;
				itemTableView.dataSource = self;
				itemTableView.rowHeight = 100;
				itemTableView.backgroundColor = [UIColor clearColor];
				itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
				[self.view addSubview:itemTableView];
			}
		}
		else {
			[itemTableView reloadData];
			[self.view addSubview:itemTableView];
			//segmentedControl.selectedSegmentIndex = whichsegmentselectedlasttime4tag;
		}
		// if no records found
		if ([stories count] == 0)
		{
		
			CGRect lableRecNotFrame = CGRectMake(22, 65.0, 270, 30);
			UILabel *recnotfound2 = [[UILabel alloc] init];
			recnotfound2 = [UnsocialAppDelegate createLabelControl:@"tag not found for selected criteria!" frame:lableRecNotFrame txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor redColor] backgroundcolor:[UIColor clearColor]];	
			[self.view addSubview:recnotfound2];
			// 13 may 2011 by pradeep //[recnotfound2 release];
			
		}
		
	} // close arivefirsttime4event if
	else {
		SearchViewController *viewcontroller = [[SearchViewController alloc] init];
		[self.navigationController pushViewController:viewcontroller animated:YES];
	}
	[itemTableView reloadData];
	loading.hidden = YES;
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
	
	// added by pradeep on 29 june 2011
	//itemTableView.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
}


@end
