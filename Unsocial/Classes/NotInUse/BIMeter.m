//
//  BIMeter.m
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BIMeter.h"


@implementation BIMeter
@synthesize tf, tf2, scoreLabel, scoreLabel2;

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"BI view will appear");
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
	
	UIImage *leftimag = [UIImage imageNamed: @"LeftNav.png"];
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setBackgroundColor:[UIColor clearColor]];
	[leftbtn setImage:leftimag forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;
	leftbtn.hidden = YES;
	
	UIImage *rightimag = [UIImage imageNamed: @"rightNav.png"];
	UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[rightbtn setBackgroundColor:[UIColor clearColor]];
	[rightbtn setImage:rightimag forState:(UIControlState) nil];
	[rightbtn addTarget:self action:@selector(rightbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
	itemNV.rightBarButtonItem = rightcbtnitme;
	rightbtn.hidden = YES;
	
	
	//add a segment control for single vs compare
	
	NSArray *segmentTextContent = [NSArray arrayWithObjects: @"Single", @"Compare", nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	CGRect frame = CGRectMake(50.0, 10.0, 200.0, 44.0);
	[segmentedControl setFrame:frame];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.selectedSegmentIndex = 0;
	[self.view addSubview:segmentedControl];
	
	

	
	if (!tf) {
		tf = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 70.0, 300.0, 30.0)];
		tf.backgroundColor = [UIColor whiteColor];
		tf.textColor = [UIColor blackColor];
		tf.delegate = self;
		if ([segmentedControl selectedSegmentIndex] == 0) {
			tf.returnKeyType = UIReturnKeyGo; 
		}
		else {
			tf.returnKeyType = UIReturnKeyNext;
		}
		tf.placeholder = @"enter your search keyword or phrase";
		tf.clearButtonMode = UITextFieldViewModeAlways;
		[self.view addSubview:tf];
	}
	
	if (!tf2) {
		tf2 = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 110.0, 300.0, 30.0)];
		tf2.backgroundColor = [UIColor whiteColor];
		tf2.textColor = [UIColor blackColor];
		tf2.delegate = self;
		tf2.returnKeyType = UIReturnKeyGo; 
		tf2.placeholder = @"enter your compare keyword or phrase";
		tf2.clearButtonMode = UITextFieldViewModeAlways;
		[self.view addSubview:tf2];
		tf2.hidden = YES;
		
	}
	
	if (!scoreLabel) {
		scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 150.0, 310.0, 150.0)];
		scoreLabel.backgroundColor = [UIColor clearColor];
		scoreLabel.textColor = [UIColor blueColor];
		[self.view addSubview:scoreLabel];
		scoreLabel.hidden = YES;
		scoreLabel.font = [UIFont boldSystemFontOfSize:80];
		scoreLabel.textAlignment = UITextAlignmentCenter;
	}
	
	if (!scoreLabel2) {
		scoreLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(160.0, 150.0, 150.0, 150.0)];
		scoreLabel2.backgroundColor = [UIColor clearColor];
		scoreLabel2.textColor = [UIColor blueColor];
		[self.view addSubview:scoreLabel2];
		scoreLabel2.hidden = YES;
		scoreLabel2.font = [UIFont boldSystemFontOfSize:40];
		scoreLabel2.textAlignment = UITextAlignmentCenter;
	}
	
	
	//add activity View controller
	
	if (!activityView) {
		activityView = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
		activityView.frame=CGRectMake(140, 200, 50, 50);
		[self.view addSubview:activityView];
		activityView.hidden = YES;
	}

		
	//UIButton *goButton = [[UIButton alloc] initWithFrame:CGRectMake(260.0, 10.0, 50.0, 30.0)];
	//[goButton setBackgroundColor:[UIColor grayColor]];
	//[goButton addTarget:self action:@selector(goButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	//[goButton setTitle:@"GO" forState:UIControlStateNormal];
	//[self.view addSubview:goButton];
	
	//read the words in a dictionary
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:path]) {
		NSLog(@"The file exists");
	} else {
		NSLog(@"The file does not exist");
	}
	//Next create the dictionary from the contents of the file.
	//NSMutableDictionary *myDict = [[NSMutableDictionary alloc] init];
	
	//NSDictionary *myDict = [[NSDictionary alloc] init];
	
	
	wordsDict = [[NSArray alloc] initWithContentsOfFile:path];
	words = [[NSMutableSet alloc] init];
	NSLog(@"The array count: %i", [wordsDict count]);
	
	for (int i=0; i < [wordsDict count]; i++) {
		//NSLog(@"%@", [[wordsDict objectAtIndex:i] valueForKey:@"Word"]);		
	//	[myDict addEntriesFromDictionary:[thisArray objectAtIndex:i]];
		[words addObject:[[wordsDict objectAtIndex:i] valueForKey:@"Word"]];
	}
	
	NSLog(@"The words read : %i", [words count]);	
	
}

- (void) goButtonClicked {

	//first check if both the text boxes are full
	if ([segmentedControl selectedSegmentIndex] == 0) {
		if ([tf.text length] == 0) {
			NSLog(@"empty...");
			return;
		}
	}
	else {
		if ([tf.text length] == 0 || [tf2.text length] == 0) {
			return;
		}
	}
	
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  
	activityView.hidden = NO;
	[activityView startAnimating];
	
	NSLog(@"Go button clicked");
	NSLog(@"%@", tf.text);
	
	//call twitter now
	
	NSString *URL = [NSString stringWithFormat:@"%@%@%@", @"http://search.twitter.com/search.atom?q=", tf.text, @"&rpp=100"];
	NSString *URL1 = [NSString stringWithFormat:@"%@%@%@", @"http://search.twitter.com/search.atom?q=", tf.text, @"&rpp=100&page=2"];
	NSString *URL2 = [NSString stringWithFormat:@"%@%@%@", @"http://search.twitter.com/search.atom?q=", tf.text, @"&rpp=100&page=3"];
	NSString *URL3 = [NSString stringWithFormat:@"%@%@%@", @"http://search.twitter.com/search.atom?q=", tf.text, @"&rpp=100&page=4"];
	NSLog(@"%@",URL);
	stories = [[NSMutableArray alloc] init];
	
	
	NSString* escapedURL = [URL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString* escapedURL1 = [URL1 stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString* escapedURL2 = [URL2 stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString* escapedURL3 = [URL3 stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	[self parseXMLFileAtURL:escapedURL];
	[self parseXMLFileAtURL:escapedURL1];
	[self parseXMLFileAtURL:escapedURL2];
	[self parseXMLFileAtURL:escapedURL3];
	
	
	[self analyzeStories: 0];
	
	if ([segmentedControl selectedSegmentIndex] == 1) {
		URL = [NSString stringWithFormat:@"%@%@%@", @"http://search.twitter.com/search.atom?q=", tf2.text, @"&rpp=100"];
		URL1 = [NSString stringWithFormat:@"%@%@%@", @"http://search.twitter.com/search.atom?q=", tf2.text, @"&rpp=100&page=2"];
		URL2 = [NSString stringWithFormat:@"%@%@%@", @"http://search.twitter.com/search.atom?q=", tf2.text, @"&rpp=100&page=3"];
		URL3 = [NSString stringWithFormat:@"%@%@%@", @"http://search.twitter.com/search.atom?q=", tf2.text, @"&rpp=100&page=4"];
		
		//restart stories
		stories = [[NSMutableArray alloc] init];
		
		
		escapedURL = [URL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		escapedURL1 = [URL1 stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		escapedURL2 = [URL2 stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		escapedURL3 = [URL3 stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		
		[self parseXMLFileAtURL:escapedURL];
		[self parseXMLFileAtURL:escapedURL1];
		[self parseXMLFileAtURL:escapedURL2];
		[self parseXMLFileAtURL:escapedURL3];
		
		
		[self analyzeStories: 1];
		

		
	}
	
	[pool release];  
	[activityView stopAnimating];
	activityView.hidden = YES;
	
	

}

- (void) segmentAction:(id) sender {
	
	NSLog(@"segment changed %d", [sender selectedSegmentIndex]);
	int sel = [sender selectedSegmentIndex];
	if (sel == 0) {
		
		//hide sel2 
		tf2.hidden = YES;
	}
	else {
		tf.returnKeyType = UIReturnKeyNext;
		tf2.hidden = NO;
	}
	
}

- (void) analyzeStories: (int) index {
	
	//break the title in words
	NSArray *tempWords;
	NSMutableSet *twitSet;
	NSMutableArray *wordsMatched;
	NSMutableSet *tempMatch;
	
	wordsMatched = [[NSMutableArray alloc] init];
	tempMatch = [[NSMutableSet alloc] init];
	tempWords = [[NSArray alloc] init];
	
	NSMutableCharacterSet *separators = [NSMutableCharacterSet punctuationCharacterSet];
	
	[separators formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	/*
	NSDate *date1 = [[stories objectAtIndex:0] objectForKey:@"published"];
	NSDate *date2 = [[stories objectAtIndex:[stories count]-1] objectForKey:@"published"];
	
	NSRange wholeShebang = NSMakeRange(0, [date1 length]);
	
	[date1 replaceOccurrencesOfString: @"\n" withString: @"" options: 0 range: wholeShebang];
	wholeShebang = NSMakeRange(0, [date2 length]);
	[date2 replaceOccurrencesOfString: @"\n" withString: @"" options: 0 range: wholeShebang];

	
	
	NSTimeInterval span = [date2 timeIntervalSinceDate:date1];
	NSLog(@"time span %i", span);
	*/
	
	
	for (int i = 0; i < [stories count]; i++) {
		NSString *temp = [[stories objectAtIndex:i] valueForKey:@"title"];

		tempWords = [temp componentsSeparatedByCharactersInSet:separators];		
		twitSet = [[NSMutableSet alloc] initWithArray:tempWords];
	
		//match with the list of emotion words
		
		[twitSet intersectSet:words];
		
		if ([twitSet count] > 0) {
			//NSLog(@"adding twit %i for %i words", i, [twitSet count]);	
			//if match found add to the bucket 
			NSLog(@"%@", [[twitSet allObjects] objectAtIndex:0]);
			[wordsMatched addObjectsFromArray:[twitSet allObjects]];
		}
		else {
			NSLog(@"Nothing found at twit %i", i);
		}
	}
		
	//finalize the buckets
	float score = 0.0f;
	NSString *tempscore;
	NSString *s1;
	//create score
	for (int j=0; j < [wordsMatched count]; j++) {
		s1 = [wordsMatched objectAtIndex:j];
		for (int k=0; k < [wordsDict count]; k++) {
			if ([s1 isEqualToString:[[wordsDict objectAtIndex:k] valueForKey:@"Word"]]) {
				tempscore = [[wordsDict objectAtIndex:k] valueForKey:@"Score"];
				NSLog(@"temp score is %@", tempscore);
				score = score + [tempscore intValue];
			}	
		}
	}
	
	score = ((score / [wordsMatched count]));
	NSLog(@"Final score %f \%", score);
	if (index == 0) {
		if ([segmentedControl selectedSegmentIndex] == 1) {
			CGRect frame = CGRectMake(10.0, 150.0, 150.0, 150.0);
			scoreLabel.frame = frame;	
			scoreLabel.font = [UIFont boldSystemFontOfSize:40];
		}
		else {
			CGRect frame = CGRectMake(10.0, 150.0, 310.0, 150.0);
			scoreLabel.frame = frame;	
			scoreLabel.font = [UIFont boldSystemFontOfSize:80];
			scoreLabel2.hidden = YES;
		}
		scoreLabel.hidden = NO;
		scoreLabel.text = [NSString stringWithFormat:@"%.2f", score];
	}	
	
	if (index == 1) {
		
		scoreLabel2.hidden = NO;
		scoreLabel2.text = [NSString stringWithFormat:@"%.2f", score];
		
	}

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
		//currentDate = [[NSMutableString alloc] init];
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
		[item setObject:currentDate forKey:@"published"];
		/*[item setObject:currentLink forKey:@"link"];
		 [item setObject:currentSummary forKey:@"summary"]; 
		 [item setObject:currentDescription forKey:@"description"]; // for blog description also date but not rite now
		 [item setObject:currentAppName forKey:@"dc:creator"]; // for display who posted this blog
		 [item setObject:currentDate forKey:@"pubDate"];*/
		//[item setObject:currentImageURL forKey:@"enclosure"];
		
		//add the actual image as well right now into the stories array
		
		//NSURL *url = [NSURL URLWithString:currentImageURL];
		//NSData *data = [NSData dataWithContentsOfURL:url];
		//UIImage *y1 = [[UIImage alloc] initWithData:data];
		//[item setObject:y1 forKey:@"itemPicture"];
		
		[stories addObject:[item copy]];
		NSLog(@"adding story: %@", currentTitle);		
	}
	// for News feature getting from "http://www.druckerinstitute.com/WhatsNewRSS.aspx"
	if ([elementName isEqualToString:@"item"]) {
		// save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:currentDescription forKey:@"description"];
		[item setObject:currentDate forKey:@"published"];
		
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
	else if ([currentElement isEqualToString:@"content"]) {
		[currentDescription appendString:string];
	} 
	else if ([currentElement isEqualToString:@"description"]) {
		[currentDescription appendString:string];
	}
	else if ([currentElement isEqualToString:@"published"]) {
		[currentDate appendString:string];
	}
	/*else if ([currentElement isEqualToString:@"link"]) {
	 [currentLink appendString:string];
	 } else if ([currentElement isEqualToString:@"description"]) {
	 [currentDescription appendString:string];
	 } else if ([currentElement isEqualToString:@"dc:creator"]) {
	 [currentAppName appendString:string];
	 } else if ([currentElement isEqualToString:@"pubDate"]) {
	 [currentDate appendString:string];
	 }*/
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {		
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	//[blogTableView reloadData];
}




/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	activityView.hidden = NO;
	[activityView startAnimating];
	[NSThread detachNewThreadSelector:@selector(goButtonClicked) toTarget:self withObject:nil];
	//[self goButtonClicked];
	NSLog(@"clearing");
    return YES;
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
