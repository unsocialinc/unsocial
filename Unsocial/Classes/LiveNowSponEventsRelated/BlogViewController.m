//
//  VideoViewController.m
//  AppTango
//
//  Created by santosh khare on 6/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BlogViewController.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"


//#import <MediaPlayer/MPMoviePlayerController.h>

@implementation BlogViewController
@synthesize bwvc, labelTtl, label, featid, urlfromnews, redirectFromNews;

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
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:featid frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
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

- (void)leftbtn_OnClick {
	
	[self.navigationController popViewControllerAnimated:YES];
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
- (void)rightbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"poll"];
	[self dismissModalViewControllerAnimated:YES];
}
// end 1 june 2011

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];

	activityView.hidden = YES;
	UILabel *noIntended = [[UILabel alloc]init];
	if (!stories) {
		[self getBlogData:urlfromnews];
		
	}
	if ([stories count] > 0)
	{
		noIntended.hidden = YES;
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
	
	}
	else {
		noIntended = [UnsocialAppDelegate createLabelControl:@"Records not found." frame:CGRectMake(30, 200, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		noIntended.hidden = NO;
		[self.view addSubview:noIntended];
		// 13 may 2011 by pradeep //[noIntended release];
	}
	[activityView stopAnimating];
	[loading setHidden:YES];

}	
- (void) getBlogData:(NSString *)url {

	urlString  = [NSString stringWithFormat:@"%@", url];
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];	
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)selection {
	return [stories count]; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	printf("Loading data...!\n");
	static NSString *MyIdentifier = @"MyIdentifier";
	CGRect cellFrame = CGRectMake(0, 0, 300, 59);
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	cell = [[[UITableViewCell alloc] initWithFrame:cellFrame reuseIdentifier:MyIdentifier] autorelease];
	
    // Set up the cell...
	UIImageView *imgCellBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 0, 320, 56) imageName:@""];
	imgCellBack.image = [UIImage imageNamed:@"msgread.png"];
	[cell.contentView addSubview:imgCellBack];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgCellBack release];
	// end 3 august 2011 for fixing memory issue
	
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	NSString *itemDesc, *itemDate;
	NSLog(@"stories array has %d items", [stories count]);
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	itemDesc = [[stories objectAtIndex: storyIndex] objectForKey: @"title"];
	itemDate = [[stories objectAtIndex: storyIndex] objectForKey: @"pubDate"];
	
	//strip off the tabs
	itemDesc = [itemDesc stringByReplacingOccurrencesOfString: @"\t" withString: @" "];
	itemDesc = [itemDesc stringByReplacingOccurrencesOfString: @"\n" withString: @" "];
	
	UILabel *featurename = [UnsocialAppDelegate createLabelControl:itemDesc frame:CGRectMake(10, 10, 200, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[featurename setFont:[UIFont boldSystemFontOfSize:kPeopleTableContent]];
	[cell.contentView addSubview:(UILabel *) featurename];	
	
	UILabel *featuredate = [UnsocialAppDelegate createLabelControl:itemDate frame:CGRectMake(210, 12, 70, 30) txtAlignment:UITextAlignmentRight numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:10 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:featuredate];
	// 13 may 2011 by pradeep //[featuredate release];
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	BlogWebViewController *viewController = [[BlogWebViewController alloc] init];
	self.bwvc = viewController;
	[viewController release];
	int storyIndex = [indexPath indexAtPosition:[indexPath length] -1];
	self.bwvc.description = (NSString *)[[stories objectAtIndex:storyIndex] objectForKey:@"content:encoded"];
	[self.navigationController pushViewController:self.bwvc animated:YES];
	
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

	if ([stories count] == 0) {
		UILabel *noIntended = [UnsocialAppDelegate createLabelControl:@"Records not found." frame:CGRectMake(30, 200, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:noIntended];
		// 13 may 2011 by pradeep //[noIntended release];
		return;
	}
	/*NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down."];
	NSLog(@"error parsing XML: %@", errorString);	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];*/
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	//commented on 2sep 09 by pradeep for fetching the data from new rss feed (static)
	//if ([elementName isEqualToString:@"item"]) {
	
	if ([elementName isEqualToString:@"entry"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
		currentImageURL = [[NSMutableString alloc] init];
		currentDescription = [[NSMutableString alloc] init];
		currentAppName = [[NSMutableString alloc] init];
	}
	// for News feature getting from "http://www.druckerinstitute.com/WhatsNewRSS.aspx"
	if ([elementName isEqualToString:@"item"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		//currentSummary = [[NSMutableString alloc] init];
		//currentLink = [[NSMutableString alloc] init];
		//currentImageURL = [[NSMutableString alloc] init];
		currentDescription = [[NSMutableString alloc] init];
		//currentAppName = [[NSMutableString alloc] init];
	}
	if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	//commented on 2sep 09 by pradeep for fetching the data from new rss feed (static)
	//if ([elementName isEqualToString:@"item"]) {
	
	if ([elementName isEqualToString:@"entry"]) {
		// save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:currentDescription forKey:@"content"];
		[item setObject:currentDate forKey:@"pubDate"];

		[stories addObject:[item copy]];
		NSLog(@"adding story: %@", currentTitle);		
	}

	if ([elementName isEqualToString:@"item"]) {
		// save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:currentDescription forKey:@"content:encoded"];
		[item setObject:currentDate forKey:@"pubDate"];
		
		[stories addObject:[item copy]];
		NSLog(@"adding story: %@", currentTitle);		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	}
	else if ([currentElement isEqualToString:@"content:encoded"]) {
		[currentDescription appendString:string];
	}else if ([currentElement isEqualToString:@"pubDate"]) {
		[currentDate appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {		
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	[blogTableView reloadData];
}
// decide what kind of accesory view (to the far right) we will use

/*- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
 {
 //return UITableViewCellAccessoryDisclosureIndicator;
 }*/


- (void)dealloc
{
	// added by pradeep on 29 june 2011
	//blogTableView.delegate = nil;
	// end 29 june 2011	
	
	[super dealloc];
}
@end