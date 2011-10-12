//
//  PhotoViewController.m
//  AppTango
//
//  Created by santosh khare on 6/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoSCView.h"
#import "SlideShowViewController.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"

// this view controller is used for photo feature
PhotoSCView *scview;
int temptotrows=0;
int tempvar4indexpath_row=0, tempflg = 0;
int	numofiteminrow=0;
int selindex;

@implementation PhotoViewController
@synthesize ssvc, TSImageView, activityView, images, stories, item, currimgurl4fullimg, geturl;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
	
	//NSLog(@"RV view will appear");
	
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
	
	/*UILabel *heading = [UnsocialAppDelegate createLabelControl:featuredispname frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	[heading release];*/	
	
	/*activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	[activityView startAnimating];*/
	[self displayAnimation];
	
}

- (void)leftbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"message"];
	[self.navigationController popViewControllerAnimated:YES];
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
- (void)rightbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"poll"];
	[self dismissModalViewControllerAnimated:YES];
}
// end 1 june 2011


- (void) displayAnimation
{	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	loading.hidden = NO;
	[self.view addSubview:loading];
	[NSThread detachNewThreadSelector: @selector(getNow) toTarget:self withObject:nil];
	//[self getNow];
}

- (void) displayAnimation2duringFullImgPrepared
{
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	loading.hidden = NO;
	[self.view addSubview:loading];
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
		
	//BOOL checknet=[UnsocialAppDelegate checkInternet];
	/*if(!checknet)
	{
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"You need internet connection to run this application" message:@"Please Check your wi-fi settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];	
	}*/
}	

- (void) getNow {
	NSAutoreleasePool *pool = [ [ NSAutoreleasePool alloc ] init ];
	
	NSLog(@"ViewDidShow now running");
	if (!stories) {
		stories = [[NSMutableArray alloc] init];
		[self getFlickrData];
	}
	[stories retain];

	//Add a a grid view	
	[self addGridNow];

	
	
	[activityView stopAnimating];
	activityView.hidden = YES;
	TSImageView.hidden = YES;
	loading.hidden = YES;
	
	// added by pradeep on 25 Jan 2011 for fixing bug reported on RTH
	//********************* start 25 jan 2011
	UILabel *noItems = [[UILabel alloc]init];
	if ([stories count] == 0)
	{
		noItems = [UnsocialAppDelegate createLabelControl:@"Records not found." frame:CGRectMake(30, 170, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		noItems.hidden = NO;
		[self.view addSubview:noItems];
		// 13 may 2011 by pradeep //[noItems release];
	}
	//********************* end 25 jan 2011
	[pool release];
	
}

- (void) addGridNow {
	
	NSLog(@"Adding grid");

	int totalitems = [stories count];
	if(totalitems == 0)
		return;
	
	scview = [[PhotoSCView alloc] initWithFrame:CGRectMake(0,0, 320, 480) NVView:self];
	
	[scview setContentSize:CGSizeMake(320, 1000)];
	CGRect frame;
	photoFullImgs = [[NSMutableArray alloc] init];
	
	for (int i=0; i < totalitems; i++) {
		int row = i/4;
		int xoffset = 1;
		if (row == 0) { xoffset = i; } 
		else {
			xoffset = i - 4*row;
		}
			
		frame = CGRectMake(xoffset*78+5, row*78.0+5, 74, 74);
		UIImageView *tempView = [[UIImageView alloc] initWithFrame:frame];
		NSDictionary *tempDict = [stories objectAtIndex:i];
		UIImage *tempImage = [tempDict objectForKey:@"itemPicture"];
		tempView.image = tempImage;
		tempView.userInteractionEnabled = YES;
		[scview addSubview:tempView];
		[photoFullImgs addObject:[[stories objectAtIndex:i] objectForKey:@"itemPicture"]];
	}
	
	scview.scrollEnabled = YES;
	scview.userInteractionEnabled = YES;
	scview.backgroundColor = [UIColor clearColor];
	[self.view addSubview:scview];
	[scview release];
}

- (void) isGlbFullImgVarInstantiate
{
	//if ([photoFullImgs count] == 0)
}

// for calling this method by timer
- (void) photoSelect2 {
	
	//rearrange imageArray to be the 0th element being the currentPhoto and last element being the current element -1;
	//call slideshow using that array
	// replace the images array with global photoimg4full array on 27 Aug 09
	if ([photoFullImgs count] == 0)
	{
		activityView.hidden = YES;
		[self displayAnimation2duringFullImgPrepared];
		//[self photoSelect:photoIndex];
		//[NSTimer scheduledTimerWithTimeInterval:3 selector:@selector  repeats:YES];
		
		[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(photoSelect2) userInfo:self.view repeats:NO];
	}
	else {
		NSAutoreleasePool *pool = [ [ NSAutoreleasePool alloc ] init ];
		[activityView stopAnimating];
		activityView.hidden = YES;
		TSImageView.hidden = YES;
		[pool release];
		
		if (selindex < [photoFullImgs count])
			if ([photoFullImgs count] > 0) 
			{
				NSMutableArray *tempImages = [[NSMutableArray alloc] init];
				
				//first pass
				for (int i=selindex; i< [photoFullImgs count]; i++) {
					[tempImages addObject:[photoFullImgs objectAtIndex:i]];
				}
				
				//second pass for rest of the images
				for (int j=0; j < selindex; j++) {
					[tempImages addObject:[photoFullImgs objectAtIndex:j]];
				}
				
				NSLog(@"PhotoSelect called total images %d", [tempImages count]);
				SlideShowViewController *viewController = [[SlideShowViewController alloc] initWithImages:tempImages imageIndex:0];
				[self.navigationController pushViewController:viewController animated:YES];
				[viewController release];
			}
		
	}
	
}


- (void) photoSelect: (int) photoIndex {
	
	//rearrange imageArray to be the 0th element being the currentPhoto and last element being the current element -1;
	//call slideshow using that array
	// replace the images array with global photoimg4full array on 27 Aug 09
	selindex = photoIndex;
	if ([photoFullImgs count] == 0)
	{
		[self displayAnimation2duringFullImgPrepared];
		//[self photoSelect:photoIndex];
		//[NSTimer scheduledTimerWithTimeInterval:3 selector:@selector  repeats:YES];
		
		[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(photoSelect2) userInfo:self.view repeats:NO];
	}
	else {
		NSAutoreleasePool *pool = [ [ NSAutoreleasePool alloc ] init ];
		[activityView stopAnimating];
		activityView.hidden = YES;
		TSImageView.hidden = loading.hidden = YES;
		[pool release];
	
		if (photoIndex < [photoFullImgs count])
			if ([photoFullImgs count] > 0) 
			{
				NSMutableArray *tempImages = [[NSMutableArray alloc] init];
				
				//first pass
				for (int i=photoIndex; i< [photoFullImgs count]; i++) {
					[tempImages addObject:[photoFullImgs objectAtIndex:i]];
				}
				
				//second pass for rest of the images
				for (int j=0; j < photoIndex; j++) {
					[tempImages addObject:[photoFullImgs objectAtIndex:j]];
				}
				
				NSLog(@"PhotoSelect called total images %d", [tempImages count]);
				SlideShowViewController *viewController = [[SlideShowViewController alloc] initWithImages:tempImages imageIndex:0];
				[self.navigationController pushViewController:viewController animated:YES];
				[viewController release];
			}
		
	}

}



- (void) getFlickrData {
		
	//get flicker feed url from the website first - hardcoded right now		
	//NSString *urlString = @"http://api.flickr.com/services/feeds/photos_public.gne?id=39219916@N04";
	//NSString *urlString = @"http://feed797.photobucket.com/albums/f83/apptango/account.rss";
	//NSString *urlString = @"http://feed625.photobucket.com/albums/tt340/prod_apptango/feed.rss";
	//NSString *urlString = @"http://feed619.photobucket.com/albums/tt279/druckerinst/account.rss";
	NSString *urlString = geturl;
	
	if([geturl isEqualToString:@""])
	{	
		scview.userInteractionEnabled = NO;
		scview.scrollEnabled = NO;
		return;		
	}
	//urlString = @"http://feed619.photobucket.com/albums/tt279/druckerinst/account.rss";
	[self parseXMLFileAtURL:urlString];
}

- (void)parseXMLFileAtURL:(NSString *)URL {
	
	
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
	NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		//currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
		currentImageURL = [[NSMutableString alloc] init];
		currentImageURL2 = [[NSMutableString alloc] init];		
	}
	if ([elementName isEqualToString:@"media:thumbnail"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}
	/*if ([elementName isEqualToString:@"media:content"]) {
		currentImageURL2 = [attributeDict valueForKey:@"url"];
	}*/
	/*if ([elementName isEqualToString:@"link"]) {
		if ([[attributeDict valueForKey:@"rel"] isEqualToString:@"enclosure"]) {
			NSLog(@"processing enclosure");
			currentImageURL = [attributeDict valueForKey:@"href"];
		}
	}*/
}



- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	NSDictionary *tempDict;
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		// save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:currentLink forKey:@"link"];
		//[item setObject:currentSummary forKey:@"summary"];
		[item setObject:currentDate forKey:@"published"];
		[item setObject:currentImageURL forKey:@"media:thumbnail"];
		[item setObject:currentImageURL2 forKey:@"media:content"];		
		//add the actual image as well right now into the stories array		
		//commenting this item because we do not want to fetch everything right now
		NSURL *url = [NSURL URLWithString:currentImageURL];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *y1 = [[UIImage alloc] initWithData:data];
		if (y1) {
			[item setObject:y1 forKey:@"itemPicture"];		
		}
		//commenting this item because we do not want to fetch everything right now
		NSURL *url2 = [NSURL URLWithString:currentImageURL2];
		NSData *data2 = [NSData dataWithContentsOfURL:url2];
		UIImage *y2 = [[UIImage alloc] initWithData:data2];
		if (y2) {
			[item setObject:y2 forKey:@"itemPicture2"];		
		}
		tempDict = [item copy];
		[stories addObject:tempDict];
		[tempDict retain];
		NSLog(@"adding story: %@", currentTitle);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"link"]) {
		[currentLink appendString:string];
	} else if ([currentElement isEqualToString:@"description"]) {
		[currentSummary appendString:string];
	} else if ([currentElement isEqualToString:@"pubDate"]) {
		[currentDate appendString:string];
	}	
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	//populate the images Array
	
	[stories retain];		
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
