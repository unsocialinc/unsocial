//
//  SponsoredEvents.m
//  Unsocial
//
//  Created by santosh khare on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SponsoredEvents.h"
#import "UnsocialAppDelegate.h"
//#import "PeopleEventSetDistance.h"
#import "EventDetails.h"
#import "GlobalVariables.h"
#import "Person.h"
#import "SponsoredSplash.h"

//BOOL allInterest = NO;
//NSString *localuserid, *localdistance;
int whichsegmentselectedlasttime4sponevent;
int arivefirsttime4sponevent;

@implementation SponsoredEvents

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	activityView.hidden = YES;
	[self createControls];
}

- (void)viewWillAppear:(BOOL)animated {
	
	WhereIam = 0;
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
	itemNV.leftBarButtonItem = leftcbtnitme;
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	[activityView startAnimating];
	recnotfound.hidden = YES;	

	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Live Now" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
}

- (void)createControls {
	
	if (gbllatitude	== nil)
	{
		// recursion for getting longitude and latitude value
		// timer control using threading
		[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createControls) userInfo:self.view repeats:NO];
	}
	else
	{
		NSArray *segmentTextContent = [NSArray arrayWithObjects:@"Live Now", nil];
		segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
		segmentedControl.frame = CGRectMake(20, 5, 280, 35);
		[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		segmentedControl.selectedSegmentIndex = 0;
		segmentedControl.tintColor = [UIColor colorWithRed:240/255.0 green:141/255.0 blue:60/255.0 alpha:1.0];
		[self.view addSubview:segmentedControl];
		segmentedControl.hidden = YES;
	}
	[addEvent.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
	[self.view addSubview:addEvent];
}

/*- (void)rightbtn_OnClick {
	
	PeopleEventSetDistance *peopleEventSetDistance = [[PeopleEventSetDistance alloc]init];
	peopleEventSetDistance.peopleOrEvent = 2;
	peopleEventSetDistance.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[[self navigationController] presentModalViewController:peopleEventSetDistance animated:YES];
	[peopleEventSetDistance release];
}*/

/*- (void)leftbtn_OnClick {
 
 }*/

/*- (void)btnAll_Click 
 {
 if (allInterest)
 {
 arivefirsttime4sponevent = 0; // for reloading if parent criteria changes i.e. if user navigate from all to my interest of my interest to all
 allInterest = NO;
 [self.navigationController pushViewController:events animated:NO];
 }
 }*/

/*- (void)btnInterest_Click {
 if (!allInterest)
 {
 arivefirsttime4sponevent = 0; // for reloading if parent criteria changes i.e. if user navigate from all to my interest of my interest to all
 allInterest = YES;	
 [self.navigationController pushViewController:events animated:NO];	
 }
 }*/

- (void)leftbtn_OnClick {
	
	//[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"sponsoredevents"];
	[self dismissModalViewControllerAnimated:YES];
//	[self.navigationController popViewControllerAnimated:YES];
}

/*- (void)addEvent_Click {
	
	EventAdd *eventAdd = [[EventAdd alloc]init];
	//eventAdd.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController pushViewController:eventAdd animated:YES];
	
}*/

- (void)segmentAction:(id)sender {
	[self getDataFromFile];
	//[self getDataFromFile4EventDistance];
	NSLog(@"segmentAction: selected segment = %d", [sender selectedSegmentIndex]);	
	int selectedSegment = [sender selectedSegmentIndex];
	
	// for fixing bug, case: if user has navigate event feature from spring board once, it shows rec accordingly but again use event feature from spring board, record doesn't display :(
	
	if (!itemTableView)
		arivefirsttime4sponevent = 0;
	
	if(arivefirsttime4sponevent==0)
	{
		arivefirsttime4sponevent = 1;
		whichsegmentselectedlasttime4sponevent = segmentedControl.selectedSegmentIndex;
		//if (!allInterest) // i.e. allInterest=NO i.e. All tab is selected
		{
			NSLog(@"for sponsored events");
			if (selectedSegment==0)
			{
				[self getEventData:@"sponsoredevents" :@"all"];
				NSLog(@"0");
			}
			/*else if (selectedSegment==1)
			{
				NSLog(@"1");
				//[self getEventData:@"myevents" :@"today"];
				[self getEventData:@"bookmarkedevents" :@"future"];
			}*/
			// since now segment control contains only two tabs so below else commented by pradeep on 31 may 2010
			/*else if (selectedSegment==2)
			 {
			 NSLog(@"2");
			 [self getEventData:@"bookmarkedevents" :@"future"];
			 }*/
			/*else if (selectedSegment==3)
			 {
			 NSLog(@"3");
			 [self getEventData:@"allevents" :@"past"];
			 }*/
			
		}
		// else is not in use commented by pradeep on 31 may 2010
		/*else
		 {
		 NSLog(@"for my interested event");
		 if (selectedSegment==0)
		 {
		 [self getEventData:@"myinterestedevents" :@"all"];
		 NSLog(@"0");
		 }
		 else if (selectedSegment==1)
		 {
		 NSLog(@"1");
		 [self getEventData:@"myinterestedevents" :@"today"];
		 }
		 else if (selectedSegment==2)
		 {
		 NSLog(@"2");
		 [self getEventData:@"myinterestedevents" :@"future"];
		 }
		 //else if (selectedSegment==3)
		 // {
		 // NSLog(@"3");
		 // [self getEventData:@"myinterestedevents" :@"past"];
		 // }
		 }*/
	} // close arivefirsttime4sponevent if
	else 
	{
		if (whichsegmentselectedlasttime4sponevent != segmentedControl.selectedSegmentIndex)
		{
			whichsegmentselectedlasttime4sponevent = segmentedControl.selectedSegmentIndex;
			//if (!allInterest) // i.e. allInterest=NO i.e. All tab is selected
			{
				NSLog(@"for sponsored events");
				if (selectedSegment==0)
				{
					[self getEventData:@"sponsoredevents" :@"all"];
					NSLog(@"0");
				}
				/*else if (selectedSegment==1)
				{
					NSLog(@"1");
					//[self getEventData:@"myevents" :@"today"];
					[self getEventData:@"bookmarkedevents" :@"future"];
				}*/
				// since now segment control contains only two tabs so below else commented by pradeep on 31 may 2010
				/*else if (selectedSegment==2)
				 {
				 NSLog(@"2");
				 [self getEventData:@"bookmarkedevents" :@"future"];
				 }*/
				/*
				 else if (selectedSegment==3)
				 {
				 NSLog(@"3");
				 [self getEventData:@"allevents" :@"past"];
				 }*/
				
			}
			// else is not in use commented by pradeep on 31 may 2010
			/*else
			 {
			 NSLog(@"for my interested event");
			 if (selectedSegment==0)
			 {
			 [self getEventData:@"myinterestedevents" :@"all"];
			 NSLog(@"0");
			 }
			 else if (selectedSegment==1)
			 {
			 NSLog(@"1");
			 [self getEventData:@"myinterestedevents" :@"today"];
			 }
			 else if (selectedSegment==2)
			 {
			 NSLog(@"2");
			 [self getEventData:@"myinterestedevents" :@"future"];
			 }
			 //else if (selectedSegment==3)
			 // {
			 // NSLog(@"3");
			 //[self getEventData:@"myinterestedevents" :@"past"];
			 // }
			 }*/
		}
	}
	
	
	//NSLog(@"hello");
	
	if (!itemTableView)
	{				
		if([stories count] > 0)
		{
			itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 370) style:UITableViewStylePlain];
			itemTableView.delegate = self;
			itemTableView.dataSource = self;
			itemTableView.rowHeight = 115;
			itemTableView.backgroundColor = [UIColor clearColor];
			itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
			[self.view addSubview:itemTableView];
		}
	}
	else 
	{
		[itemTableView reloadData];
		[self.view addSubview:itemTableView];
		//segmentedControl.selectedSegmentIndex = whichsegmentselectedlasttime;
	}
	// if no records found
	if ([stories count] == 0)
	{
		//[self dialogSelection];
		
		CGRect lableRecNotFrame = CGRectMake(30, 200, 260, 50);
		recnotfound = [[UILabel alloc] init];
		recnotfound = [UnsocialAppDelegate createLabelControl:@"No sponsored events!" frame:lableRecNotFrame txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor redColor] backgroundcolor:[UIColor clearColor]];	
		[self.view addSubview:recnotfound];
		recnotfound.hidden = NO;
		// 13 may 2011 by pradeep //[recnotfound release];
		
	}
	else 
	{
		recnotfound.hidden = YES;
		recnotfound.text = @"";
	}
	
	
}

/*- (BOOL) getDataFromFile4EventDistance {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"setMilesForEvents"];
	
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
		
		
		localdistance = [[tempArray objectAtIndex:0] setMilesForEvents];
		
		[decoder finishDecoding];
		[decoder release];
		return YES;
	}
	else {
		localdistance = @"1";
		return NO;
	}
}*/

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

		//for setting global variables
		NSLog(@"%@", [[tempArray objectAtIndex:0] userid]);
		gbluserid = [[tempArray objectAtIndex:0] userid];
		if ([arrayForUserID count]==0)
			[arrayForUserID addObject:[[tempArray objectAtIndex:0] userid]];
		
		[decoder finishDecoding];
		[decoder release];	
		
		return YES;		
		
		
	}
	else { //just in case the file is not ready yet.
		//username = @"";
		//userlocation = @"";
		//[self CreateFile];
		return NO;
	}
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
		eventdateto = [[NSMutableString alloc] init];
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
		
		//		NSURL *url = [NSURL URLWithString:currentImageURL];
		/*NSData *data = [NSData dataWithContentsOfURL:url];
		 UIImage *y1 = [[UIImage alloc] initWithData:data];
		 if (y1) {
		 [item setObject:y1 forKey:@"itemPicture"];		
		 }*/
		
		
		/*[item setObject:userrole forKey:@"role"];
		 [item setObject:userallownotification forKey:@"allownotification"];
		 [item setObject:userinterestind forKey:@"interestind"];		
		 [item setObject:userinterestsubind forKey:@"interestsubind"];		
		 [item setObject:userinterestrole forKey:@"interestrole"];		
		 [item setObject:userprofilecomplete forKey:@"profilecomplete"];
		 [item setObject:userdisplayitem forKey:@"displayitem"];		
		 [item setObject:usersecuritylevel forKey:@"securitylevel"];
		 [item setObject:usercurrentdistance forKey:@"currentdistance"];
		 [item setObject:userforwhichtab forKey:@"forwhichtab"];
		 
		 //add the actual image as well right now into the stories array
		 
		 NSURL *url = [NSURL URLWithString:currentImageURL];
		 NSData *data = [NSData dataWithContentsOfURL:url];
		 UIImage *y1 = [[UIImage alloc] initWithData:data];
		 if (y1) {
		 [item setObject:y1 forKey:@"itemPicture"];		
		 }*/
		
		[imageURLs4Lazy addObject:currentImageURL];
		[stories addObject:[item copy]];
		NSLog(@"adding story: %@", eventname);		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
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
	
	// commented by pradeep on 26 aug 2010 for lazy img feature
	//************************
	
	/*UIImage *imageforresize = [[stories  objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	CGImageRef realImage = imageforresize.CGImage;
	float realHeight = CGImageGetHeight(realImage);
	float realWidth = CGImageGetWidth(realImage);
	float ratio = realHeight/realWidth;
	float modifiedWidth = 60/ratio;
	
	CGRect imageRect = CGRectMake(9, 7, modifiedWidth + 15, 60 );	
	UIImageView *usrImage = [[UIImageView alloc] initWithFrame:imageRect];
	usrImage.image = [[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	
	// Get the Layer of any view
	CALayer * l = [usrImage layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:10.0];
	
	// You can even add a border
	[l setBorderWidth:1.0];
	[l setBorderColor:[[UIColor blackColor] CGColor]];
	[cell.contentView addSubview:usrImage];
	[usrImage release];*/
	
	// commented by pradeep on 26 aug 2010 for lazy img feature
	//************************
	
	//*************** lazy img code start
	
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
	lblEvent = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventname"] frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableCellHeading txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblEvent];
	/*EVENT NAME ENDS*/
	
	NSArray *split = [[[stories objectAtIndex:indexPath.row] objectForKey:@"eventdate"]componentsSeparatedByString:@" "];
	NSString *eventdt = [NSString stringWithFormat:@"%@",[split objectAtIndex:0]];
	
	// event to date
	NSArray *split2 = [[[stories objectAtIndex:indexPath.row] objectForKey:@"eventdateto"]componentsSeparatedByString:@" "];
	NSString *eventdt2 = [NSString stringWithFormat:@"%@",[split2 objectAtIndex:0]];
	
#pragma mark EVENT DATE STARTS
	CGRect lableDateFrame = CGRectMake(lableNameFrame.origin.x, 30, 100, 15);
	lblEventDt = [UnsocialAppDelegate createLabelControl:@"Date:" frame:lableDateFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblEventDt];
	
	//lblEventDt = [UnsocialAppDelegate createLabelControl:eventdt frame:CGRectMake(lableNameFrame.origin.x, lableDateFrame.origin.y + 12, 100, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	//changed by pradeep on 28 july 2010 according to icheena ID 31
	lblEventDt = [UnsocialAppDelegate createLabelControl:eventdt frame:CGRectMake(lableNameFrame.origin.x+40, 30, 70, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	[cell.contentView addSubview:lblEventDt];
	
	// event to date
	
	lblEventDt = [UnsocialAppDelegate createLabelControl:@"to" frame:CGRectMake(lableNameFrame.origin.x+115, 30, 20, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	[cell.contentView addSubview:lblEventDt];
	
	lblEventDt = [UnsocialAppDelegate createLabelControl:eventdt2 frame:CGRectMake(lableNameFrame.origin.x+140, 30, 100, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	[cell.contentView addSubview:lblEventDt];
	
	/*EVENT DATE ENDS*/
	
#pragma mark EVENT DATE FROM STARTS
	CGRect lablefromFrame = CGRectMake(lableDateFrame.origin.x, lableDateFrame.origin.y + 20, 100, 15);	
	lblEventDtFrom = [UnsocialAppDelegate createLabelControl:@"At:" frame:lablefromFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDtFrom];
	
	lblEventDtFrom = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"fromtime"] frame:CGRectMake(lablefromFrame.origin.x+20, lablefromFrame.origin.y, 100, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDtFrom];
	/*EVENT DATE FROM ENDS*/
	
#pragma mark EVENT DATE TO STARTS
	CGRect lableToFrame = CGRectMake(lablefromFrame.origin.x+90, lablefromFrame.origin.y, 90, 15);
	lblEventDtTo = [UnsocialAppDelegate createLabelControl:@"To:" frame:lableToFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDtTo];
	
	lblEventDtTo = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"totime"] frame:CGRectMake(lableToFrame.origin.x+20, lableToFrame.origin.y, 90, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblEventDtTo];
	/*EVENT DATE TO ENDS*/
	
#pragma mark EVENT DISTANCE STARTS
	CGRect lableDistanceFrame = CGRectMake(lableNameFrame.origin.x, lableToFrame.origin.y+20, 150, 15);
	lblEventDistance = [UnsocialAppDelegate createLabelControl:@"Distance:" frame:lableDistanceFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDistance];
	
	lblEventDistance = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"] frame:CGRectMake(lableDistanceFrame.origin.x+80, lableDistanceFrame.origin.y, 90, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];	
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
	
	// commented by PRadeep on 23 sep 2010 for implementing splash start logic
	//EventDetails *eventDetails = [[EventDetails alloc]init];
	SponsoredSplash *eventDetails = [[SponsoredSplash alloc] init];
	
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

	//UIImage *eImage = [[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	//if(eImage)
	//	[aryEventDetails addObject:eImage];//17
	
	//******************** for lazi img start
	
	//NSURL *url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
	[aryEventDetails addObject:[imageURLs4Lazy objectAtIndex:indexPath.row]];//17
	
	
	//******************** for lazi img end
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventdateto"]];//18

	/*eventDetails.eventid = [[stories objectAtIndex:indexPath.row] objectForKey:@"guid"];
	eventDetails.eventname = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventname"];
	eventDetails.eventdesc = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventdescription"];
	eventDetails.eventaddress = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventaddress"];
	eventDetails.eventindustry = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"];
	eventDetails.eventdate = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventdate"];
	eventDetails.fromtime = [[stories objectAtIndex:indexPath.row] objectForKey:@"fromtime"];
	eventDetails.totime = [[stories objectAtIndex:indexPath.row] objectForKey:@"totime"];
	eventDetails.eventcontact = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventcontact"];
	eventDetails.eventwebsite = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventwebsite"];
	eventDetails.isrecurring = [[stories objectAtIndex:indexPath.row] objectForKey:@"isrecurring"];
	eventDetails.eventcurrentdistance = [[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"];
	
	eventDetails.fromwhichsegment = [NSString stringWithFormat:@"%i",segmentedControl.selectedSegmentIndex];
	eventDetails.eventtype =[[stories objectAtIndex:indexPath.row] objectForKey:@"eventtype"];
	eventDetails.comingfrom = 1;
	eventDetails.liveNow = 1;*/
	
	[self.navigationController pushViewController:eventDetails animated:YES];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

/*- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
 return UITableViewCellAccessoryDisclosureIndicator;
 }*/

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
	// added by pradeep on 29 june 2011
	//itemTableView.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
}


@end
