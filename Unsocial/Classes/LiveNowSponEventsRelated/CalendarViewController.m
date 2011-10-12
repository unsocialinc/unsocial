    //
//  CalendarViewController.m
//  Unsocial
//
//  Created by Ashutosh Srivastava on 25/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "WebViewController.h"
#import "YouTubeWebViewController.h"
#import "PhotoViewController.h"
#import "Calendardesc.h"


@implementation CalendarViewController

@synthesize eventid, featureid, featuretypeid, featuretypename, featuredispname;

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
	
	/*UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	 [leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	 [leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	 UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	 itemNV.leftBarButtonItem = leftcbtnitme;*/
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	// added by pradeep on 1 june 2011 for returning to dashboard requirement
	
	UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(285.0, 0.0, 33, 30)];
	[rightbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[rightbtn addTarget:self action:@selector(rightbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
	itemNV.rightBarButtonItem = rightbtnitme;
	//rightbtn.hidden = YES;
	
	// end 1 june 2011
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:featuredispname frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	// commented calendar feature
	
	btnSave = [UnsocialAppDelegate createButtonControl:@"Save to calendar" target:self selector:@selector(btnSave_Click) frame:CGRectMake(60, 385, 200, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnSave.titleLabel setFont:[UIFont fontWithName:kAppFontName size:11.5]];
	[self.view addSubview:btnSave];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	loading.hidden = NO;
	[self.view addSubview:loading];
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
- (void)rightbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"poll"];
	[self dismissModalViewControllerAnimated:YES];
}
// end 1 june 2011

// commented calendar feature
-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
	
	if(buttonIndex ==0)
	{
	}
	else {
		int i = 0;
		for(i=0;i<[stories count];i++)
		{
			NSString *calfromdate, *caltodate;
			EKEventStore *eventStore = [[EKEventStore alloc] init];
			
			EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
			event.title     = [[stories objectAtIndex:i] objectForKey: @"calendartitle"]; //@"EVENT TITLE";
			
			NSString *dateStrfrom = [[[stories objectAtIndex:i] objectForKey: @"calendardate"] stringByAppendingString:[@" " stringByAppendingString:[[stories objectAtIndex: i] objectForKey: @"timefrom"]]];
			NSLog(@"%@", dateStrfrom);
			// Convert string to date object
			NSDateFormatter *dateFormatfrom = [[NSDateFormatter alloc] init];
			[dateFormatfrom setDateFormat:@"MM/dd/yyyy hh:mm a"];
			NSDate *datefrom = [dateFormatfrom dateFromString:dateStrfrom];	
			[dateFormatfrom setDateFormat:@"LLL dd yyyy hh:mm a"];
			dateStrfrom = [dateFormatfrom stringFromDate:datefrom];
			datefrom = [dateFormatfrom dateFromString:dateStrfrom];
			
			NSString *dateStrto = [[[stories objectAtIndex:i] objectForKey: @"calendardate"] stringByAppendingString:[@" " stringByAppendingString:[[stories objectAtIndex: i] objectForKey: @"timeto"]]];
			NSLog(@"%@", dateStrto);
			NSDateFormatter *dateFormatto = [[NSDateFormatter alloc] init];
			[dateFormatto setDateFormat:@"MM/dd/yyyy hh:mm a"];
			NSDate *dateto = [dateFormatto dateFromString:dateStrto];	
			[dateFormatto setDateFormat:@"LLL dd yyyy hh:mm a"];
			dateStrto = [dateFormatfrom stringFromDate:dateto];
			dateto = [dateFormatto dateFromString:dateStrto];
			//NSLog(@"%@", [dateFormat stringFromDate:datefrom]);
			event.startDate = datefrom;//[NSDate date];
			event.endDate   = dateto;//[[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
			
			[event setCalendar:[eventStore defaultCalendarForNewEvents]];
			NSError *err;
			[eventStore saveEvent:event span:EKSpanThisEvent error:&err];
		}
	}

}

-(void)btnSave_Click{
	
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
	
	UIAlertView *savealert = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure you want save all items to your iphone?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES",nil];
	[savealert show];
	[savealert release];
	}
	else {
		
		UIAlertView *savealert = [[UIAlertView alloc]initWithTitle:nil message:@"Feature is not available on your iPhone." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[savealert show];
		[savealert release];
	}
	
	
}

- (void)leftbtn_OnClick{
	
	[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"message"];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)createControls {
	
	UILabel *noMessage = [[UILabel alloc]init];
	
	if(!stories)
		[self getSponsoredEventFeatureItems];
	if([stories count] > 0)
	{
		noMessage.hidden = YES;
		itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 42, 320, 336) style:UITableViewStylePlain];
		itemTableView.delegate = self;
		itemTableView.dataSource = self;
		itemTableView.rowHeight = 56;
		itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		itemTableView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:itemTableView];
		btnSave.hidden = NO;
	}
	else {
		noMessage = [UnsocialAppDelegate createLabelControl:@"Selected feature has no items!" frame:CGRectMake(30, 200, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		noMessage.hidden = NO;
		[self.view addSubview:noMessage];
		// 13 may 2011 by pradeep //[noMessage release];
		btnSave.hidden = YES;
	}		
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [stories count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	Calendardesc *cal = [[Calendardesc alloc]init];
	cal.caldesc = [[stories objectAtIndex: indexPath.row] objectForKey: @"description"];
	cal.caltitle = [[stories objectAtIndex: indexPath.row] objectForKey: @"calendartitle"];
	cal.caldate = [[stories objectAtIndex: indexPath.row] objectForKey: @"calendardate"];
	cal.calfrom = [[stories objectAtIndex: indexPath.row] objectForKey: @"timefrom"];
	cal.calto = [[stories objectAtIndex: indexPath.row] objectForKey: @"timeto"];
	[self.navigationController pushViewController:cal animated:YES];
	
		
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	// Set up the cell...
	UIImageView *imgCellBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 0, 320, 56) imageName:@""];
	imgCellBack.image = [UIImage imageNamed:@"msgread.png"];
	[cell.contentView addSubview:imgCellBack];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgCellBack release];
	// end 3 august 2011 for fixing memory issue
	
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	NSString *itemDesc, *itemDate, *itemDate2, *itemDate3, *itemloc;
	NSLog(@"stories array has %d items", [stories count]);
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	itemDesc = [[stories objectAtIndex: storyIndex] objectForKey: @"calendartitle"];
	itemDate = [[stories objectAtIndex: storyIndex] objectForKey: @"calendardate"];
	itemDate2 = [[stories objectAtIndex: storyIndex] objectForKey: @"timefrom"];
	itemDate3 = [[stories objectAtIndex: storyIndex] objectForKey: @"timeto"];
	itemloc = [[stories objectAtIndex: storyIndex] objectForKey: @"location"];
	
	//strip off the tabs
	itemDesc = [itemDesc stringByReplacingOccurrencesOfString: @"\t" withString: @" "];
	itemDesc = [itemDesc stringByReplacingOccurrencesOfString: @"\n" withString: @" "];
	
	UILabel *featurename = [UnsocialAppDelegate createLabelControl:itemDesc frame:CGRectMake(10, 5, 200, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[featurename setFont:[UIFont boldSystemFontOfSize:kPeopleTableContent]];
	[cell.contentView addSubview:(UILabel *) featurename];
	
	UILabel *featuredate = [UnsocialAppDelegate createLabelControl:itemDate frame:CGRectMake(210, 5, 70, 15) txtAlignment:UITextAlignmentRight numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:10 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:featuredate];
	// 13 may 2011 by pradeep //[featuredate release];
	
	UILabel *featurefromtime = [UnsocialAppDelegate createLabelControl:[NSString stringWithFormat:@"At: %@", itemDate2] frame:CGRectMake(10, 15, 100, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:10 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:featurefromtime];
	// 13 may 2011 by pradeep //[featurefromtime release];
	
	UILabel *featuretotime = [UnsocialAppDelegate createLabelControl:[NSString stringWithFormat:@"To: %@", itemDate3] frame:CGRectMake(80, 15, 100, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:10 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:featuretotime];
	// 13 may 2011 by pradeep //[featuretotime release];

	UILabel *featureloc = [UnsocialAppDelegate createLabelControl:itemloc frame:CGRectMake(10, 30, 270, 30) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:featureloc];
	// 13 may 2011 by pradeep //[featureloc release];
	return cell;
}

- (void) getSponsoredEventFeatureItems {
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	NSString *urlString;
	urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getsponsoredeventfeatureitems&datetime=%@&userid=%@&flag2=%@&featuretype=%@", usertime, [arrayForUserID objectAtIndex:0], featureid, featuretypename];
 	urlString = [globalUrlString stringByAppendingString:urlString];
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];
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
	//imageURLs4Lazy = [[NSMutableArray alloc]init];
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down."];
	NSLog(@"error parsing XML: %@", errorString);	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"])
	{
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		featureitemid = [[NSMutableString alloc] init];
		name = [[NSMutableString alloc] init];
		phone = [[NSMutableString alloc] init];
		email = [[NSMutableString alloc] init];
		company = [[NSMutableString alloc] init];
		industry = [[NSMutableString alloc] init];
		role = [[NSMutableString alloc] init];
		/*about = [[NSMutableString alloc] init];
		weburl = [[NSMutableString alloc] init];
		description = [[NSMutableString alloc] init];*/
		
		
	}
	/*if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}*/
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		/*if ([featuredispname compare:@"calendar"] == NSOrderedSame)
		{
			
			//[item setObject:about forKey:@"about"];
			//[item setObject:weburl forKey:@"weburl"];		
		}
		else
		{
			/*[item setObject:featureitemid forKey:@"guid"]; 
			[item setObject:name forKey:@"name"]; 
			[item setObject:description forKey:@"description"];
			[item setObject:weburl forKey:@"weburl"];*/	
		//}
		
		[item setObject:featureitemid forKey:@"guid"]; 
		[item setObject:name forKey:@"calendartitle"]; 		
		[item setObject:phone forKey:@"calendardate"];
		[item setObject:email forKey:@"timefrom"];
		[item setObject:company forKey:@"timeto"];
		[item setObject:industry forKey:@"location"]; 		
		[item setObject:role forKey:@"description"];
		
		NSLog(@"%@", [NSString stringWithFormat:@"Feature ID:*** %@", featureid]);
		
		//[imageURLs4Lazy addObject:currentImageURL];
		
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"guid"])
	{
		[featureitemid appendString:string];
	}
	else if ([currentElement isEqualToString:@"calendartitle"])
	{
		NSLog(@"lololo---   %@", string);
		[name appendString:string];
	}
	else if ([currentElement isEqualToString:@"calendardate"])
	{
		[phone appendString:string];
	}
	else if ([currentElement isEqualToString:@"timefrom"])
	{
		[email appendString:string];
	}
	else if ([currentElement isEqualToString:@"timeto"])
	{
		[company appendString:string];
	}
	else if ([currentElement isEqualToString:@"location"])
	{
		[industry appendString:string];
	}
	else if ([currentElement isEqualToString:@"description"])
	{
		[role appendString:string];
	}
	
	/*else if ([currentElement isEqualToString:@"about"])
	{
		[about appendString:string];
	}
	else if ([currentElement isEqualToString:@"weburl"])
	{
		[weburl appendString:string];
	}
	else if ([currentElement isEqualToString:@"description"])
	{
		[description appendString:string];
	}*/
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
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
