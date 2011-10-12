//
//  VideoViewController.m
//  AppTango
//
//  Created by santosh khare on 6/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Poll.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"
#import "PollSelect.h"

//#import <MediaPlayer/MPMoviePlayerController.h>

@implementation Poll
@synthesize eventid, featureid, featuretypeid, featuretypename, featuredispname;
@synthesize labelTtl,label,featid;

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
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Poll" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
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

- (void)leftbtn_OnClick {
	
	[self.navigationController popViewControllerAnimated:YES];
}

/*- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];

	activityView.hidden = YES;
	if (!stories) {
		[self getBlogData:@"http://feeds.venturebeat.com/venturebeat_mobile"];
		
	}
	if(!blogTableView)
	{
		//Add a table view
		blogTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 42, 320, 370) style:UITableViewStylePlain];
		blogTableView.delegate = self;
		blogTableView.dataSource = self;
		blogTableView.rowHeight = 56;
		blogTableView.backgroundColor = [UIColor clearColor];
		blogTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	[self.view addSubview:blogTableView];
	[activityView stopAnimating];
	[loading setHidden:YES];
}	*/

- (void)createControls {
	
	UILabel *noMessage = [[UILabel alloc]init];
	
	if(!stories)
		[self getpollquestions];
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
	}
	else {
		noMessage = [UnsocialAppDelegate createLabelControl:@"Poll has no items!" frame:CGRectMake(30, 200, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		noMessage.hidden = NO;
		[self.view addSubview:noMessage];
		// 13 may 2011 by pradeep //[noMessage release];
	}		
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (id) init
{
	self = [super init];
	if (self != nil) {self.title=@"Blog"; 
	}
	//[self loadView];
	return self;
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
	PollSelect *viewcontroller = [[PollSelect alloc]init];
	viewcontroller.pollquestionid = [[stories objectAtIndex: indexPath.row] objectForKey: @"guid"];
	viewcontroller.sponfeatid = [[stories objectAtIndex: indexPath.row] objectForKey: @"sponfeatid"];
	viewcontroller.sponeventid = [[stories objectAtIndex: indexPath.row] objectForKey: @"sponeventid"];
	viewcontroller.questions = [[stories objectAtIndex: indexPath.row] objectForKey: @"questions"];
	viewcontroller.noofoptions = [[stories objectAtIndex: indexPath.row] objectForKey: @"noofoptions"];
	[self.navigationController pushViewController:viewcontroller animated:YES];
	
	
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
	NSString *itemQuestion;
	NSLog(@"stories array has %d items", [stories count]);
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	itemQuestion = [[stories objectAtIndex: storyIndex] objectForKey: @"questions"];
	
	
	//strip off the tabs
	//itemDesc = [itemDesc stringByReplacingOccurrencesOfString: @"\t" withString: @" "];
	//itemDesc = [itemDesc stringByReplacingOccurrencesOfString: @"\n" withString: @" "];
	
	UILabel *featurename = [UnsocialAppDelegate createLabelControl:itemQuestion frame:CGRectMake(10, 2, 300, 40) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	//[featurename setFont:[UIFont boldSystemFontOfSize:kPeopleTableContent]];
	[cell.contentView addSubview:(UILabel *) featurename];
	
	
	return cell;
}

- (void) getpollquestions {
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	NSString *urlString;
	NSLog(@"%@", [NSString stringWithFormat:@"featureid: %@", featureid]);
	urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getpollquestions&datetime=%@&userid=%@&flag2=%@&featuretype=%@", usertime, [arrayForUserID objectAtIndex:0], featureid, featuretypename];
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
		pollquestionid = [[NSMutableString alloc] init];
		currentsponfeatid = [[NSMutableString alloc] init];
		currentsponeventid = [[NSMutableString alloc] init];
		currentquestions = [[NSMutableString alloc] init];
		currentnoofoptions = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		
		
		
	}
	/*if ([elementName isEqualToString:@"enclosure"]) {
	 currentImageURL = [attributeDict valueForKey:@"url"];
	 }*/
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if ([elementName isEqualToString:@"item"])
	{		
		[item setObject:pollquestionid forKey:@"guid"]; 
		[item setObject:currentsponfeatid forKey:@"sponfeatid"]; 	
		[item setObject:currentsponeventid forKey:@"sponeventid"]; 		
		[item setObject:currentquestions forKey:@"questions"];
		[item setObject:currentnoofoptions forKey:@"noofoptions"];
		[item setObject:currentDate forKey:@"pubDate"];
		
		
		NSLog(@"%@", [NSString stringWithFormat:@"Feature ID:*** %@", featureid]);
		
		//[imageURLs4Lazy addObject:currentImageURL];
		
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"guid"])
	{
		[pollquestionid appendString:string];
	}
	else if ([currentElement isEqualToString:@"sponeventid"])
	{
		NSLog(@"lololo---   %@", string);
		[currentsponeventid appendString:string];
	}
	else if ([currentElement isEqualToString:@"sponfeatid"])
	{
		NSLog(@"lololo---   %@", string);
		[currentsponfeatid appendString:string];
	}
	else if ([currentElement isEqualToString:@"questions"])
	{
		[currentquestions appendString:string];
	}
	else if ([currentElement isEqualToString:@"noofoptions"])
	{
		[currentnoofoptions appendString:string];
	}
	else if ([currentElement isEqualToString:@"pubDate"])
	{
		[currentDate appendString:string];
	}
		
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
}
// decide what kind of accesory view (to the far right) we will use

/*- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
 {
 //return UITableViewCellAccessoryDisclosureIndicator;
 }*/


- (void)dealloc
{	
	// added by pradeep on 29 june 2011
	//itemTableView.delegate = nil;
	// end 29 june 2011
	
	[super dealloc];
}
@end