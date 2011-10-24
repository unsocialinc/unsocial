//
//  SponsoredEventFeatureItems.m
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SponsoredEventFeatureItems.h"
#import "GlobalVariables.h"
#import "BlogViewController.h"
#import "UnsocialAppDelegate.h"
#import "WebViewController.h"
#import "YouTubeWebViewController.h"
#import "PhotoViewController.h"
#import "CalendarViewController.h"
#import "WebViewForWebsites.h"

@implementation SponsoredEventFeatureItems

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
	
	/*UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(285.0, 0.0, 33, 30)];
	[rightbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[rightbtn addTarget:self action:@selector(rightbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
	itemNV.rightBarButtonItem = rightbtnitme;
	//rightbtn.hidden = YES;*/
	
	// end 1 june 2011
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];

	UILabel *heading = [UnsocialAppDelegate createLabelControl:featuredispname frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
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

- (void)leftbtn_OnClick{

	WhereIam = 2;
	[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"message"];
	[self.navigationController popViewControllerAnimated:YES];
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
/*- (void)rightbtn_OnClick{
	
	[lastVisitedFeature removeAllObjects];
	[self dismissModalViewControllerAnimated:YES];
}*/
// end 1 june 2011

- (void)createControls {
	
	UILabel *noMessage = [[UILabel alloc]init];
	
	if(!stories)
		[self getSponsoredEventFeatureItems];
	if([stories count] > 0)
	{
		noMessage.hidden = YES;
		itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 42, 320, 370) style:UITableViewStylePlain];
		itemTableView.delegate = self;
		itemTableView.dataSource = self;
		itemTableView.rowHeight = 117;
		itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		itemTableView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:itemTableView];
	}
	else {
		noMessage = [UnsocialAppDelegate createLabelControl:@"Selected feature has no items!" frame:CGRectMake(30, 200, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
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
	
	/*InboxShowMessage *inboxShowMessage = [[InboxShowMessage alloc]init];
	inboxShowMessage.strFromName = [[stories objectAtIndex:indexPath.row] objectForKey:@"sendername"];
	inboxShowMessage.strMsgDescription = [[stories objectAtIndex:indexPath.row] objectForKey:@"msgbody"];
	inboxShowMessage.strFrom = [[stories objectAtIndex:indexPath.row] objectForKey:@"guid"];
	inboxShowMessage.strMsgId = [[stories objectAtIndex:indexPath.row] objectForKey:@"msgid"];
	inboxShowMessage.strReadMsg = [[stories objectAtIndex:indexPath.row] objectForKey:@"isread"];
	[self.navigationController pushViewController:inboxShowMessage animated:YES];*/
	
	// for adding TT's navigation controller for website
	
	NSLog(@"Wthevideo");
	
	if ([featuretypeid compare:@"FT00000002"] == NSOrderedSame) // video
	{
		
		NSString *geturlvideo = [[stories objectAtIndex:indexPath.row] objectForKey:@"weburl"];
		int getlengthurl = [geturlvideo length];
		int getlengthurl1 = getlengthurl - 4;
		NSString *checkurl = [geturlvideo substringWithRange:NSMakeRange(getlengthurl1, 4)];
		//NSArray *tempary;
		
		if([checkurl compare:@".mp4"] == NSOrderedSame){
			NSLog(@"Wthevideo");
			YouTubeWebViewController *ytvc = [[YouTubeWebViewController alloc]init];
			/*ytvc.title1 = @"REP SIGWIN09";
			 ytvc.twitType = @"http://www.youtube.com/v/G4UzjgLUv6c?fs=1&amp;hl=en_US";
			 [self.navigationController pushViewController:ytvc animated:YES];*/
			
			NSString *urlvideo = [[stories objectAtIndex:indexPath.row] objectForKey:@"weburl"];
			NSString *titlevideo = [[stories objectAtIndex:indexPath.row] objectForKey:@"name"];
			
			ytvc.title1 = titlevideo;
			ytvc.twitType = urlvideo;
			[self.navigationController pushViewController:ytvc animated:YES];
		}
		else {
			
			/*NSLog(@"Wthevideo");
			WebViewController *viewcontroller  = [[WebViewController alloc]init];
			viewcontroller.videourl = [[stories objectAtIndex:indexPath.row] objectForKey:@"weburl"];
			[self.navigationController pushViewController:viewcontroller animated:YES];
			[viewcontroller release];*/
			
			NSString *url4vurl = [[stories objectAtIndex:indexPath.row] objectForKey:@"weburl"];
			if (url4vurl!= @"")
			{
				
				WebViewForWebsites *webViewForWebsites = [[WebViewForWebsites alloc]init];
				webViewForWebsites.webAddress = url4vurl;
				[self.navigationController pushViewController:webViewForWebsites animated:YES];				
				[webViewForWebsites release];
				//[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:properWebsite4v]];
			}
				
		}
	}
	else if ([featuretypeid compare:@"FT00000004"] == NSOrderedSame) // blog
	{
		BlogViewController *bvc = [[BlogViewController alloc]init];
		bvc.featid = [[stories objectAtIndex:indexPath.row] objectForKey:@"name"];
		bvc.urlfromnews = [[stories objectAtIndex:indexPath.row] objectForKey:@"weburl"];
		[self.navigationController pushViewController:bvc animated:YES];
	}
	else // multiplewebsite & audio case
	{
	[self.navigationItem setTitle:[[stories objectAtIndex:indexPath.row] objectForKey:@"name"]];
	NSString *url = [[stories objectAtIndex:indexPath.row] objectForKey:@"weburl"];
	if (url!= @"")
	{
		WebViewForWebsites *webViewForWebsites = [[WebViewForWebsites alloc]init];
		webViewForWebsites.webAddress = url;
		[self.navigationController pushViewController:webViewForWebsites animated:YES];
		
		[webViewForWebsites release];
		//[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:properWebsite]];
	}
	else {
		NSLog(@"url not found");
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Website url is not added for %@.", [[stories objectAtIndex:indexPath.row] objectForKey:@"featuretypename"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertOnChoose show];
		[alertOnChoose release];					 
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


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    // Set up the cell...
	UIImageView *imgCellBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 0, 320, 115) imageName:@""];
	imgCellBack.image = [UIImage imageNamed:@"peopleback.png"];
	[cell.contentView addSubview:imgCellBack];
	
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

	UILabel *featurename = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"name"] frame:CGRectMake(89, 7, 220, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;		
	[featurename setFont:[UIFont fontWithName:kAppFontName size:14]];

	[cell.contentView addSubview:featurename];
	NSLog(@"Name: %@", featurename.text);
	// 13 may 2011 by pradeep //[featurename release];
	
	//UILabel *featuredesc = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"description"] frame:CGRectMake(89, 30, 200, 30) txtAlignment:UITextAlignmentLeft numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	UITextView *featuredesc = [UnsocialAppDelegate createTextViewControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"description"] frame:CGRectMake(89, 30, 200, 30)  txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:17 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:NO editable:NO];
	featuredesc.userInteractionEnabled = FALSE;
	featuredesc.contentInset = UIEdgeInsetsMake(-4, -8, 0, 0);
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;		
	[featuredesc setFont:[UIFont fontWithName:kAppFontName size:10]];
	
	[cell.contentView addSubview:featuredesc];
	NSLog(@"Name: %@", featuredesc.text);
	[featuredesc release];
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
	imageURLs4Lazy = [[NSMutableArray alloc]init];

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
		about = [[NSMutableString alloc] init];
		weburl = [[NSMutableString alloc] init];
		description = [[NSMutableString alloc] init];
		
		
	}
	if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		if ([featuredispname compare:@"People"] == NSOrderedSame)
		{
			[item setObject:featureitemid forKey:@"guid"]; 
			[item setObject:name forKey:@"name"]; 		
			[item setObject:phone forKey:@"phone"];
			[item setObject:email forKey:@"email"];
			[item setObject:company forKey:@"company"];
			[item setObject:industry forKey:@"industry"]; 		
			[item setObject:role forKey:@"role"];
			[item setObject:about forKey:@"about"];
			[item setObject:weburl forKey:@"weburl"];		
		}
		else
		{
			[item setObject:featureitemid forKey:@"guid"]; 
			[item setObject:name forKey:@"name"]; 
			[item setObject:description forKey:@"description"];
			[item setObject:weburl forKey:@"weburl"];	
		}
		
		NSLog([NSString stringWithFormat:@"Feature ID:*** %@", featureid]);
		
		[imageURLs4Lazy addObject:currentImageURL];
		
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"guid"])
	{
		[featureitemid appendString:string];
	}
	else if ([currentElement isEqualToString:@"name"])
	{
		[name appendString:string];
	}
	else if ([currentElement isEqualToString:@"phone"])
	{
		[phone appendString:string];
	}
	else if ([currentElement isEqualToString:@"email"])
	{
		[email appendString:string];
	}
	else if ([currentElement isEqualToString:@"company"])
	{
		[company appendString:string];
	}
	else if ([currentElement isEqualToString:@"industry"])
	{
		[industry appendString:string];
	}
	else if ([currentElement isEqualToString:@"role"])
	{
		[role appendString:string];
	}
	else if ([currentElement isEqualToString:@"about"])
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
