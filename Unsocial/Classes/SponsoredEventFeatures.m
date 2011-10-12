//
//  SponsoredEventFeatures.m
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SponsoredEventFeatures.h"
#import "GlobalVariables.h"
//#import "InboxShowMessage.h"
#import "UnsocialAppDelegate.h"
#import "SponsoredEventFeatureItems.h"

@implementation SponsoredEventFeatures

@synthesize eventid;

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
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	//add background color
	self.view.backgroundColor = color;
	
	UIImage *imgHead = [UIImage imageNamed: @"healdlogo.png"];
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
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];

	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Features" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	// 13 may 2011 by pradeep //[heading release];	
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	[activityView startAnimating];
}

- (void)leftbtn_OnClick{

	[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"message"];
	[self.navigationController popViewControllerAnimated:YES];
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
- (void)rightbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	[self dismissModalViewControllerAnimated:YES];
}
// end 1 june 2011

- (void)createControls {
	
	UILabel *noMessage = [[UILabel alloc]init];
	if (!itemTableView)
		[self getSponsoredEventFeatures];
	else [itemTableView reloadData];
	if([stories count] > 0)
	{
		noMessage.hidden = YES;
		itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, 320, 350) style:UITableViewStylePlain];
		itemTableView.delegate = self;
		itemTableView.dataSource = self;
		itemTableView.rowHeight = 40;
		itemTableView.backgroundColor = [UIColor clearColor];
		itemTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		[self.view addSubview:itemTableView];
	}
	else {
		noMessage = [UnsocialAppDelegate createLabelControl:@"Selected feature has no item!" frame:CGRectMake(30, 200, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		noMessage.hidden = NO;
		[self.view addSubview:noMessage];
		// 13 may 2011 by pradeep //[noMessage release];
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
	
	SponsoredEventFeatureItems *viewcontroller = [[SponsoredEventFeatureItems alloc]init];
	
	//featureid, eventidoffeat, featuretypeid, featuretypename, featuredispname
	
	viewcontroller.featureid = [[stories objectAtIndex:indexPath.row] objectForKey:@"guid"];
	viewcontroller.eventid = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventidoffeat"];
	viewcontroller.featuretypeid = [[stories objectAtIndex:indexPath.row] objectForKey:@"featuretypeid"];
	viewcontroller.featuretypename = [[stories objectAtIndex:indexPath.row] objectForKey:@"featuretypename"];
	viewcontroller.featuredispname = [[stories objectAtIndex:indexPath.row] objectForKey:@"featuredispname"];
	[self.navigationController pushViewController:viewcontroller animated:YES];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    // Set up the cell...
	
	//UILabel *lblDate = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"msgtime"] frame:CGRectMake(210, 5, 70, itemTableView.rowHeight) txtAlignment:UITextAlignmentRight numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:10 txtcolor:[UIColor darkGrayColor] backgroundcolor:[UIColor clearColor]];
	
	UILabel *featurename = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"featuredispname"] frame:CGRectMake(15, 7, 245, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor blueColor] backgroundcolor:[UIColor clearColor]];
	
	//UILabel *msgDescription = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"msgbody"] frame:CGRectMake(15, 32, 200, 18) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:@"ArialRoundedMTBold-Italic" fontsize:12 txtcolor:[UIColor brownColor] backgroundcolor:[UIColor clearColor]];
	
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	//if([[[stories objectAtIndex:indexPath.row] objectForKey:@"isread"] compare:@"1"] == NSOrderedSame){
		
		//[lblDate setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:10]];

		[featurename setFont:[UIFont fontWithName:kAppFontName size:17]];

		//[msgDescription setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:12]];
	//}
	//[cell.contentView addSubview:lblDate];
	//NSLog(@"Date: %@", lblDate.text);
	//[lblDate release];
	[cell.contentView addSubview:featurename];
	NSLog(@"Name: %@", featurename.text);
	// 13 may 2011 by pradeep //[featurename release];
	//[cell.contentView addSubview:msgDescription];
	//NSLog(@"Description: %@", msgDescription.text);
	//[msgDescription release];

	return cell;
}

// decide what kind of accesory view (to the far right) we will use
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDetailDisclosureButton;
//	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void) getSponsoredEventFeatures {
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);

	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];

	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	NSString *urlString;
	urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getsponsoredeventfeatures&datetime=%@&userid=%@&flag2=%@", usertime, [arrayForUserID objectAtIndex:0], eventid];
	urlString = [globalUrlString stringByAppendingString:urlString];
	NSLog(urlString);
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
		featureid = [[NSMutableString alloc] init];
		eventidoffeat = [[NSMutableString alloc] init];
		featuretypeid = [[NSMutableString alloc] init];
		featuretypename = [[NSMutableString alloc] init];
		featuredispname = [[NSMutableString alloc] init];
		
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		[item setObject:featureid forKey:@"guid"]; 
		[item setObject:eventidoffeat forKey:@"eventidoffeat"]; 		
		[item setObject:featuretypeid forKey:@"featuretypeid"];
		[item setObject:featuretypename forKey:@"featuretypename"];
		[item setObject:featuredispname forKey:@"featuredispname"];
		
		NSLog(@"%@", [NSString stringWithFormat:@"Feature Type:*** %@", featuretypename]);
		
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"guid"])
	{
		[featureid appendString:string];
	}
	else if ([currentElement isEqualToString:@"eventidoffeat"])
	{
		[eventidoffeat appendString:string];
	}
	else if ([currentElement isEqualToString:@"featuretypeid"])
	{
		[featuretypeid appendString:string];
	}
	else if ([currentElement isEqualToString:@"featuretypename"])
	{
		[featuretypename appendString:string];
	}
	else if ([currentElement isEqualToString:@"featuredispname"])
	{
		[featuredispname appendString:string];
	}
	
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
