#import "SponsoredEventFeaturesLauncherView.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "SponsoredEventFeatureItems.h"
#import "Raffle.h"
#import "PhotoViewController.h"
#import "CalendarViewController.h"
#import "WebViewForWebsites.h"

#import "Poll.h"

int cnt4img;

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SponsoredEventFeaturesLauncherView

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

@synthesize eventid, eventname;

- (id)init {
  if (self = [super init]) {
    //self.title = @"Launcher";
  }
  return self;
}

// called after this controller's view will appear
- (void)viewWillAppear:(BOOL)animated {
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 40, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
		//[activityView startAnimating];
	
	WhereIam = 2;
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
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	// added by pradeep on 1 june 2011 for returning to dashboard requirement
	
	/*UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(285.0, 0.0, 33, 30)];
	[rightbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[rightbtn addTarget:self action:@selector(rightbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
	itemNV.rightBarButtonItem = rightbtnitme;
	//rightbtn.hidden = YES;*/
	
	// end 1 june 2011

	// for adding TT's navigation controller for website
	TTNavigator *navigator = [TTNavigator  navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	TTURLMap *map = navigator.URLMap;
	[map from:@"*" toViewController:[TTWebController class]];
	
	//[self imgBanner];
	
	kNumberOfPages = [imageURLs4Lazy count];
	
	if (!pageControl) {
		CGRect frame = CGRectMake(6.0, 3, 308.0, 5.0); // CGRectMake(6.0, 0, 308.0, 5.0); added by pradeep on 10 feb 2011
		pageControl = [[UIPageControl alloc] initWithFrame:frame];
		[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
		[pageControl setBackgroundColor:[UIColor clearColor]];
		pageControl.numberOfPages = [imageURLs4Lazy count];
		pageControl.enabled = YES;
		[self.view addSubview:pageControl];
	}
	
	if (!scrollView) {
		//CGRect frame = CGRectMake(5, 3, 310, 89); //added by pradeep on 10 feb 2011
		CGRect frame = CGRectMake(5, 7, 310, 80);
		scrollView = [[UIScrollView alloc] initWithFrame:frame];
		scrollView.pagingEnabled = YES;
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		scrollView.delegate = self;
		scrollView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:scrollView];
		//[scrollView release];
		
		[self loadScrollViewFirstTimeWithOutScrollCreatedByPradeep];
	}
}

//*************************

// added by pradeep on 1 june 2011 for returning to dashboard requirement
/*- (void)rightbtn_OnClick{
	
	[lastVisitedFeature removeAllObjects];
	[self dismissModalViewControllerAnimated:YES]; 
}*/
// end 1 june 2011

- (void) loadScrollViewFirstTimeWithOutScrollCreatedByPradeep
{
	// We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
	
	//find out index
	int page; 
	
	
	CGFloat pageWidth = scrollView.frame.size.width;
	page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	pageControl.currentPage = page;
	
	
	
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
	NSLog(@"view scrolled");
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)loadScrollViewWithPage:(int)page {
	
	NSLog(@"Scroll View");
	
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
	//first remove the subview
	
	
	//CGRect frame = CGRectMake(page*310, 5, 310, 55);
    // replace the placeholder if necessary
	//if (!controller) {
	
	//take existing one out first
	/*imgBannerView = [[UIImageView alloc] initWithFrame:frame];
	imgBannerView.image = [imageURLs4Lazy objectAtIndex:page];
	imgBannerView.backgroundColor = [UIColor clearColor];*/
	
	//***********
	
	CGRect frame;
	frame.size.width=310; frame.size.height=89;
	frame.origin.x=page*310; frame.origin.y=3;
	asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	NSURL*url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:page]];
	[asyncImage loadImageFromURL:url];
	asyncImage.backgroundColor = [UIColor clearColor];
	
	//***********
	
	
	[scrollView addSubview:asyncImage];	
	
		//Added By Ashutosh Srivastava
		//Start
	if (page == 0)
	{
		UIButton *btnBanner1 = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 89.0)];
		[btnBanner1 setBackgroundColor:[UIColor clearColor]];
		[btnBanner1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
		[btnBanner1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
		[btnBanner1 setTitle:@"" forState:UIControlStateNormal];	
			//[self.view addSubview:(UIButton *)btntoyland];
		[btnBanner1 addTarget:self action:@selector(btnBanner1_OnClick) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:btnBanner1];
		[btnBanner1 release];
	}
	if (page == 1)
	{
		UIButton *btnBanner2 = [[UIButton alloc] initWithFrame:CGRectMake(310.0, 0.0, 310.0, 89.0)];
		[btnBanner2 setBackgroundColor:[UIColor clearColor]];
		[btnBanner2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
		[btnBanner2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
		[btnBanner2 setTitle:@"" forState:UIControlStateNormal];	
			//[self.view addSubview:(UIButton *)btntoyland];
		[btnBanner2 addTarget:self action:@selector(btnBanner2_OnClick) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:btnBanner2];
		[btnBanner2 release];
	}
	if (page == 2)
	{
		UIButton *btnBanner3 = [[UIButton alloc] initWithFrame:CGRectMake(610.0, 0.0, 310.0, 89.0)];
		[btnBanner3 setBackgroundColor:[UIColor clearColor]];
		[btnBanner3 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
		[btnBanner3 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
		[btnBanner3 setTitle:@"" forState:UIControlStateNormal];	
			//[self.view addSubview:(UIButton *)btntoyland];
		[btnBanner3 addTarget:self action:@selector(btnBanner3_OnClick) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:btnBanner3];
		[btnBanner3 release];
}
	if (page == 3)
	{
		UIButton *btnBanner4 = [[UIButton alloc] initWithFrame:CGRectMake(910.0, 0.0, 310.0, 89.0)];
		[btnBanner4 setBackgroundColor:[UIColor clearColor]];
		[btnBanner4 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
		[btnBanner4 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
		[btnBanner4 setTitle:@"" forState:UIControlStateNormal];	
			//[self.view addSubview:(UIButton *)btntoyland];
		[btnBanner4 addTarget:self action:@selector(btnBanner4_OnClick) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:btnBanner4];
		[btnBanner4 release];
}
	if (page == 4)
	{
		UIButton *btnBanner5 = [[UIButton alloc] initWithFrame:CGRectMake(1220.0, 0.0, 350.0, 89.0)];
		[btnBanner5 setBackgroundColor:[UIColor clearColor]];
		[btnBanner5 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
		[btnBanner5 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
		[btnBanner5 setTitle:@"" forState:UIControlStateNormal];	
			//[self.view addSubview:(UIButton *)btntoyland];
		[btnBanner5 addTarget:self action:@selector(btnBanner5_OnClick) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:btnBanner5];
		[btnBanner5 release];
}
		//End
}

	//Added By Ashutosh Srivastava
	//Start

- (void) clickBanner:(NSString *)url{
	
	NSLog(@"BannerWebSite$$$$$$$$$$$$$ - %@", url);
	
	if (![url isEqualToString:@""])
	{
		if ([url rangeOfString:@"."].location != NSNotFound) {
			
			WebViewForWebsites *ww = [[WebViewForWebsites alloc]init];
			ww.webAddress = url;
			[self.navigationController pushViewController:ww animated:YES];
		}
		else {
			UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Not a proper url." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertOnChoose show];
			[alertOnChoose release];             					 
		}
		
	}
	else {
		
		NSLog(@"url not found");
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Url is currently not set." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertOnChoose show];
		[alertOnChoose release];             					 
	}
}

-(void)btnBanner1_OnClick
{
	NSLog(@"Button1 Press");
	NSString *url = [[EVBanner objectAtIndex:0] objectForKey:@"bannertext"];
	[self clickBanner:url];
}

-(void)btnBanner2_OnClick
{
	NSLog(@"Button2 Press");
	NSString *url = [[EVBanner objectAtIndex:1] objectForKey:@"bannertext"];
	[self clickBanner:url];
}

-(void)btnBanner3_OnClick
{
	NSLog(@"Button3 Press");
	NSString *url = [[EVBanner objectAtIndex:2] objectForKey:@"bannertext"];
	[self clickBanner:url];
}

-(void)btnBanner4_OnClick
{
	NSLog(@"Button4 Press");
	NSString *url = [[EVBanner objectAtIndex:3] objectForKey:@"bannertext"];
	[self clickBanner:url];
}

-(void)btnBanner5_OnClick
{
	NSLog(@"Button5 Press");
	NSString *url = [[EVBanner objectAtIndex:4] objectForKey:@"bannertext"];
	[self clickBanner:url];
}
	//End


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
	
	//find out index
	int page; 
	
	
		CGFloat pageWidth = scrollView.frame.size.width;
		page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		pageControl.currentPage = page;
	
	
	
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
	NSLog(@"view scrolled");
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)changePage:(id)sender {
	
	NSLog(@"change page");
    int page = pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
	
	CGRect frame = scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	[scrollView scrollRectToVisible:frame animated:YES];
	
	pageControlUsed = YES;
}


// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

//*************************

- (void) imgBanner
{
	UIImageView *imgStatusBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(6, 6, 308, 80) imageName:@"dashimgstatusback.png"];
	[self.view addSubview:imgStatusBack];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgStatusBack release];
	// end 3 august 2011 for fixing memory issue
}

- (void)leftbtn_OnClick {
	
	// commented and added by pradeep on 28 july 2011 for fixing issue syncronization failed message display multiple times
	issyncfailedmsgdisplayed4premiumeventlauncher = FALSE;
	// end by pradeep on 28 july 2011 for fixing issue syncronization failed message display multiple times
	
	WhereIam = 0;
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
	// added by pradeep on 29 june 2011
	//_launcherView.delegate = nil;
	//scrollView.delegate = nil;
	// end 29 june 2011
  [super dealloc];
	[activityView release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (CGFloat)rowHeight {
	//  if (UIInterfaceOrientationIsPortrait(TTInterfaceOrientation())) {
    return 103;
	//  } else {
	//    return 74;
	//  }
	
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
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];
}

- (void)parseXMLFileAtURL:(NSString *)URL {
	stories = [[NSMutableArray alloc] init];
		//Added By Ashutosh Srivastava
		//Start
	EVBanner = [[NSMutableArray alloc] init];
		//End
	
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
	
	// commented and added by pradeep on 28 july 2011 for fixing issue syncronization failed message display multiple times
	
	/*
	 NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down."];
	 NSLog(@"error parsing XML: %@", errorString);	
	 UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	 [errorAlert show];
	 [self.navigationController popViewControllerAnimated:YES]; 
	 */ 
	
	if (!issyncfailedmsgdisplayed4premiumeventlauncher)
	{
		issyncfailedmsgdisplayed4premiumeventlauncher = TRUE;
		NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down."];
		NSLog(@"error parsing XML: %@", errorString);	
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[self.navigationController popViewControllerAnimated:YES];	
	}
	
	// end 28 july 2011 for fixing issue syncronization failed message display multiple times		
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
		featiconid = [[NSMutableString alloc] init];
		
	}
		//Added By Ashutosh Srivastava
		//Start
	if ([elementName isEqualToString:@"item2"])
	{
		item2 = [[NSMutableDictionary alloc] init];
		BannerURL = [[NSMutableString alloc] init];
	}
		//End
	if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
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
		[item setObject:featiconid forKey:@"featureiconid"];
		
		
		NSLog(@"%@", [NSString stringWithFormat:@"Feature Type:*** %@", featuretypename]);
		
		
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
	}
	if ([elementName isEqualToString:@"item2"])
	{
		[imageURLs4Lazy addObject:currentImageURL];
			//[stories4banner addObject:[item2 copy]];
			//Added By Ashutosh Srivastava
			//Start
		[item2 setObject:BannerURL forKey:@"bannertext"];
		NSLog(@"%@", [NSString stringWithFormat:@"BANNER WEBSITE: %@", BannerURL]);
		[EVBanner addObject:[item2 copy]];
		NSLog(@"%d ^^", [EVBanner count]);
			//End
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
	}else if ([currentElement isEqualToString:@"featureiconid"])
	{
		[featiconid appendString:string];
	}
		//Added By Ashutosh Srivastava
		//Start
	else if ([currentElement isEqualToString:@"bannertext"])
	{
		[BannerURL appendString:string];
	}
		//End
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
}

		
+ (BOOL) isFileExist: (NSString *) filename {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if([fileManager fileExistsAtPath:path]) {
			//open it and read it 
			/*NSLog(@"data file found. reading into memory");
			NSMutableData *theData;
			NSKeyedUnarchiver *decoder;
			NSMutableArray *tempArray;
			
			theData = [NSData dataWithContentsOfFile:path];
			decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
			tempArray = [decoder decodeObjectForKey:@"userInfo"];
			//[self setPersonArray:tempArray];
			
			
			localdistance = [[tempArray objectAtIndex:0] setMilesForEvents];
			
			[decoder finishDecoding];
			[decoder release];*/
			return YES;
		}
		else {
			
			return NO;
		}
	}

- (void) getTabs {
	NSMutableDictionary *items = [[NSMutableDictionary alloc] init];
	springBoardTabsAry = [[NSMutableArray alloc] init];
	
	//cnt4img = 0;
	
	// for filling arrary for people added by pradeep on 24 sep 2010
	[items setObject:@"PEOPLE" forKey:@"title"];
	[items setObject:@"bundle://dashpeople.png" forKey:@"image"];
	[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",1]]  forKey:@"URL"];
	[items setObject:@"NO" forKey:@"candelete"];
	
	[springBoardTabsAry addObject:[items copy]];
	
	// for filling array for intended events
	
	for (int i=0; i < [stories count]; i++)
	{
		NSString *strevntnm = [NSString stringWithFormat:[[[stories objectAtIndex:i] objectForKey:@"featuredispname"] uppercaseString]];
		int length = [strevntnm length];
		if (length > 10)
		{
			strevntnm = [[strevntnm substringWithRange: NSMakeRange (0, 9)] stringByAppendingString:@"..."];
		}
		
		[items setObject:strevntnm forKey:@"title"];
		
		//NSString *icon = [@"bundle://" stringByAppendingString:[[stories objectAtIndex:i] objectForKey:@"featureiconid"]];
		NSString *icon = [NSString stringWithFormat:@"%@/images/sponevefeatureimagesthumb/%@.png",globalUrlString,[[stories objectAtIndex:i] objectForKey:@"guid"]];
		//icon = [icon stringByAppendingString:@".png"];
		[items setObject:icon forKey:@"image"];
		
		[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",i+2]]  forKey:@"URL"];
		[items setObject:@"NO" forKey:@"candelete"];
		
		[springBoardTabsAry addObject:[items copy]];
	}
}

- (void)loadView {
	[super loadView];

	//add background color
	imgBackgrnd = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainbackground.png"] highlightedImage:[UIImage imageNamed:@"mainbackground.png"]];
	[self.view addSubview:imgBackgrnd];
	
	// for background grid i.e. horizontal & vertical lines
	imgBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 90, 320, 320)];
	imgBackgrnd.image = [UIImage imageNamed:@"dashboardgrid.png"];
	[self.view addSubview:imgBackgrnd];
	
	_launcherView = [[TTLauncherView alloc] initWithFrame:CGRectMake(0, 85, 320, 320)];
	_launcherView.delegate = self;
	_launcherView.columnCount = 3;
	[self getSponsoredEventFeatures];
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
			//[ary1 addObject:[[[TTLauncherItem alloc] initWithTitle:@"People" image:@"bundle://backbutton.png" URL:@"fb://item1" canDelete:YES] autorelease]];
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
	}
	
	[self.view addSubview:_launcherView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTLauncherViewDelegate


- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)items {
	
	// commented and added by pradeep on 28 july 2011 for fixing issue syncronization failed message display multiple times
	issyncfailedmsgdisplayed4premiumeventlauncher = FALSE;
	// end by pradeep on 28 july 2011 for fixing issue syncronization failed message display multiple times
	
	WhereIam = 0;
	[UnsocialAppDelegate playClick];
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	NSLog(@"%@", [NSString stringWithFormat:@"%@", items]);
	if ([items.title compare:@"PEOPLE"] == NSOrderedSame)
	{		
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://peoplelivenow"] applyAnimated:YES]];
			//peoples  = [[Peoples alloc]init];
			//[self.navigationController pushViewController:peoples animated:YES];
	}
	
	else
	{
		
		for (int i=0; i < [stories count]; i++)
		{
			NSString *strevntnm = [NSString stringWithFormat:@"%@", [[[stories objectAtIndex:i] objectForKey:@"featuredispname"] uppercaseString]];
			int length = [strevntnm length];
			if (length > 10)
			{
				strevntnm = [[strevntnm substringWithRange: NSMakeRange (0, 9)] stringByAppendingString:@"..."];
					//[strevntnm stringByAppendingString:@"..."];
			}
			
				//if ([items.title compare:[[stories objectAtIndex:i] objectForKey:@"featuredispname"]] == NSOrderedSame) 
			if ([items.title compare:strevntnm] == NSOrderedSame)
			{
				
				NSLog(@"%@", [[stories objectAtIndex:i] objectForKey:@"featuredispname"]);
				NSLog(@"%@", [[stories objectAtIndex:i] objectForKey:@"featuretypename"]);
				NSLog(@"%@", items.title);
				
					//NSLog(@"%@", [[stories objectAtIndex:i] objectForKey:@"guid"]);
				NSString *getfeaturetypeid = [[stories objectAtIndex:i] objectForKey:@"featuretypeid"];
				
				
				if ([[[stories objectAtIndex:i] objectForKey:@"featuretypename"] isEqualToString:@"SingleWebsite"])
				{
						// for adding TT's navigation controller for website
					[self.navigationItem setTitle:[[stories objectAtIndex:i] objectForKey:@"featuredispname"]];
					
					NSString *url = [self getURL4SingleWebsite:@"geturl4singlewebsite" :[[stories objectAtIndex:i] objectForKey:@"guid"]];
					if (url!= @"")
					{
						WebViewForWebsites *ww = [[WebViewForWebsites alloc]init];
						ww.webAddress = url;
						[self.navigationController pushViewController:ww animated:YES];
							//[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:properWebsite]];
						break;
					}
					else {
						NSLog(@"url not found");
						UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Url is currently not set." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
						[alertOnChoose show];
						[alertOnChoose release];					 
					}				 
				}	
				else if ([[[stories objectAtIndex:i] objectForKey:@"featuretypename"] isEqualToString:@"Raffle"])
				{
						//NSString *url = [self getRaffleTicket:@"getraffleticket" :[[stories objectAtIndex:i] objectForKey:@"guid"]];
					Raffle *viewcontroller = [[Raffle alloc]init];
					
						//featureid, eventidoffeat, featuretypeid, featuretypename, featuredispname
					
					viewcontroller.featureid = [[stories objectAtIndex:i] objectForKey:@"guid"];
					viewcontroller.eventid = [[stories objectAtIndex:i] objectForKey:@"eventidoffeat"];
					viewcontroller.featuretypeid = [[stories objectAtIndex:i] objectForKey:@"featuretypeid"];
					viewcontroller.featuretypename = [[stories objectAtIndex:i] objectForKey:@"featuretypename"];
					viewcontroller.featuredispname = [[stories objectAtIndex:i] objectForKey:@"featuredispname"];
					[self.navigationController pushViewController:viewcontroller animated:YES];
					break;
					
				}
					//**********
				else if([getfeaturetypeid compare:@"FT00000003"] == NSOrderedSame) // photo/image
				{
					NSString *urlphoto = [self getURL4SingleWebsite:@"geturl4singlewebsite" :[[stories objectAtIndex:i] objectForKey:@"guid"]];
					PhotoViewController * pvc = [[PhotoViewController alloc]init];
					pvc.geturl = urlphoto;
					[self.navigationController pushViewController:pvc animated:YES];
					break;
				}
				
				else if([getfeaturetypeid compare:@"FT00000009"] == NSOrderedSame) // calendar
				{
					
					CalendarViewController *viewcontroller  = [[CalendarViewController alloc]init];
						//viewcontroller.videourl = [[stories objectAtIndex:indexPath.row] objectForKey:@"weburl"];
					viewcontroller.featureid = [[stories objectAtIndex:i] objectForKey:@"guid"];
					viewcontroller.eventid = [[stories objectAtIndex:i] objectForKey:@"eventidoffeat"];
					viewcontroller.featuretypeid = [[stories objectAtIndex:i] objectForKey:@"featuretypeid"];
					viewcontroller.featuretypename = [[stories objectAtIndex:i] objectForKey:@"featuretypename"];
					viewcontroller.featuredispname = [[stories objectAtIndex:i] objectForKey:@"featuredispname"];
					[self.navigationController pushViewController:viewcontroller animated:YES];
					break;
						//[viewcontroller release];
				}
				
				else if([getfeaturetypeid compare:@"FT00000005"] == NSOrderedSame) // poll
				{
					
					Poll *viewcontroller  = [[Poll alloc]init];
						//viewcontroller.videourl = [[stories objectAtIndex:indexPath.row] objectForKey:@"weburl"];
					viewcontroller.featureid = [[stories objectAtIndex:i] objectForKey:@"guid"];
					viewcontroller.eventid = [[stories objectAtIndex:i] objectForKey:@"eventidoffeat"];
					viewcontroller.featuretypeid = [[stories objectAtIndex:i] objectForKey:@"featuretypeid"];
					viewcontroller.featuretypename = [[stories objectAtIndex:i] objectForKey:@"featuretypename"];
					viewcontroller.featuredispname = [[stories objectAtIndex:i] objectForKey:@"featuredispname"];
					[self.navigationController pushViewController:viewcontroller animated:YES];
					break;
						//[viewcontroller release];
				}
					//***************
				
				else
				{
					NSLog(@"others");
					SponsoredEventFeatureItems *viewcontroller = [[SponsoredEventFeatureItems alloc]init];
					
						//featureid, eventidoffeat, featuretypeid, featuretypename, featuredispname
					
					viewcontroller.featureid = [[stories objectAtIndex:i] objectForKey:@"guid"];
					viewcontroller.eventid = [[stories objectAtIndex:i] objectForKey:@"eventidoffeat"];
					viewcontroller.featuretypeid = [[stories objectAtIndex:i] objectForKey:@"featuretypeid"];
					viewcontroller.featuretypename = [[stories objectAtIndex:i] objectForKey:@"featuretypename"];
					viewcontroller.featuredispname = [[stories objectAtIndex:i] objectForKey:@"featuredispname"];
					
					[self.navigationController pushViewController:viewcontroller animated:YES];
					break;
				}
			}
		}
	}
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex 
{
	
	NSLog(@"%@", [NSString stringWithFormat:@"selected alert: %i",buttonIndex]);
	
	if(buttonIndex == 0) // no, here nothing happen since this condition is fullfill for more than on options i.e. for smart tag, for save (bookmark)
	{
		
		//method to add tag
		/*UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:@"Smart Tags added successfully" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		 [alertOnChoose show];
		 [alertOnChoose release];
		 tagsadded = YES;*/
	}
	else if(buttonIndex == 1) // yes
	{
		NSLog(@"yes");
		//[self sendNow4SmartTagging:@"managetags"]; // for smart tagging
		//tagsadded = NO;
	}
	
}

- (NSString *) getURL4SingleWebsite: (NSString *) flag : (NSString *) featid {
	NSLog(@"Sending.... 4 getURL4SingleWebsite");
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
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",featid];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	//NSString *varMessageId = [NSString stringWithFormat:@"%@\r\n",strMsgId];	
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
	
	/*[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventfeatid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varMessageId] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];*/
	
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
	NSString *weburl = @"";
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Singleweburl"])			
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				NSLog(@"\n\n\n\n\n\n#######################-- Single website url found successfully --#######################\n\n\n\n\n\n");
				weburl = [dic objectForKey:key];				
				successflg=YES;				
				
				
				break;
			}
		}
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return weburl;
	[pool release];
}



- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
  [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] 
    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
    target:_launcherView action:@selector(endEditing)] autorelease] animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
  [self.navigationItem setRightBarButtonItem:nil animated:YES];
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
