//
//  EventIntendedUsers.m
//  Unsocial
//
//  Created by vaibhavsaran on 01/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventIntendedUsers.h"
#import "UnsocialAppDelegate.h"
#import "PeoplesUserProfile.h"
#import "GlobalVariables.h"

@implementation EventIntendedUsers
@synthesize eventid;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	activityView.hidden = YES;
	loading.hidden = YES;
	[self createControls];
}

- (void)viewWillAppear:(BOOL)animated {

	WhereIam = 0;
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
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Attendee List" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];	
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	[activityView startAnimating];
}

- (void)createControls {
	
	UILabel *noIntended = [[UILabel alloc]init];
	if (!itemTableView)
		[self getUserList];
	if([stories count] > 0)
	{
		noIntended.hidden = YES;
		itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 370) style:UITableViewStylePlain];
		itemTableView.delegate = self;
		itemTableView.dataSource = self;
		itemTableView.rowHeight = 115;
		itemTableView.backgroundColor = [UIColor clearColor];
		itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.view addSubview:itemTableView];
		[itemTableView reloadData];
	}
	else {
		noIntended = [UnsocialAppDelegate createLabelControl:@"Nobody signed in recently in this vicinity." frame:CGRectMake(30, 200, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		noIntended.hidden = NO;
		[self.view addSubview:noIntended];
		// 13 may 2011 by pradeep //[noIntended release];
	}		
}

- (void)getUserList {
		
	//eventid4localpurpose = eventid;
		
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
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&distance=%@&flag2=%@&eventid=%@",@"getpeople",gbllatitude,gbllongitude,gbluserid,usertime,@"0",@"intended",eventid];
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
	
//	[self parseXMLFileAtURL:@""];
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
	// lazy img implemented by pradeep on 17 sep 2010
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
		userstatus = [[NSMutableString alloc]init];
		userlinkedinemailid = [[NSMutableString alloc]init];
		usertitle = [[NSMutableString alloc]init];
		userlevel = [[NSMutableString alloc]init];
	}
	if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
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
		[item setObject:userstatus forKey:@"status"];
		[item setObject:userlinkedinemailid forKey:@"linkedinemailid"];
		[item setObject:usertitle forKey:@"usertitle"];
		[item setObject:userlevel forKey:@"level"];

		//add the actual image as well right now into the stories array
		
		// commented lazy img implementation by pradeep on 17 sep 2010
		//*****************
		/*NSURL *url = [NSURL URLWithString:currentImageURL];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *y1 = [[UIImage alloc] initWithData:data];
		if (y1) {
			[item setObject:y1 forKey:@"itemPicture"];		
		}*/
		
		[imageURLs4Lazy addObject:currentImageURL];
		// lazy img implementation by pradeep on 17 sep 2010
		//*****************
		
		[stories addObject:[item copy]];
		NSLog(@"adding story: %@", username);		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"prefix"]) {
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
	}else if ([currentElement isEqualToString:@"status"]) {
		[userstatus appendString:string];
	}else if ([currentElement isEqualToString:@"linkedinemailid"]) {
		[userlinkedinemailid appendString:string];
	}else if ([currentElement isEqualToString:@"usertitle"]) {
		[usertitle appendString:string];
	}else if ([currentElement isEqualToString:@"level"]) {
		[userlevel appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {		
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	[itemTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stories count];
	//return 5;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	// lazy img implementation by pradeep *****************
	//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
	}
	else {
		AsyncImageView* oldImage = (AsyncImageView*)
		[cell.contentView viewWithTag:999];
		[oldImage removeFromSuperview];
	} 
	// lazy img implementation by pradeep *****************
	
	//***************************************** latest code start according to new design written by Pradeep on 24 july 2010
	//*************** start
	
	UIImageView *imgPplBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 0, 320, 115) imageName:@"peopleback.png"];
	[cell.contentView addSubview:imgPplBack];
	
	//Dynamic label
	lblStatus = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(89, 75, 215, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleStatus txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	lblStatus.text = [[stories objectAtIndex:indexPath.row] objectForKey:@"status"];
	[cell.contentView addSubview:lblStatus];
	
	// commented by pradeep on 17 sep 2010 for lazy img feature
	//*********************
	/*UIImage *imageforresize = [[stories  objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	CGImageRef realImage = imageforresize.CGImage;
	float realHeight = CGImageGetHeight(realImage);
	float realWidth = CGImageGetWidth(realImage);
	float ratio = realHeight/realWidth;
	float modifiedWidth, modifiedHeight;
	if(ratio < 1) {
		
		modifiedWidth = 75;
		modifiedHeight = modifiedWidth*ratio;
	}
	else {
		
		modifiedHeight = 75;
		modifiedWidth = modifiedHeight/ratio;
	}
	
	CGRect imageRect = CGRectMake(9, 11, 75, 75 );
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
	[usrImage release];
	 */
	// commented by pradeep on 17 sep 2010 for lazy img feature
	//*********************
	
	//*************** lazy img code start
	
	CGRect frame;
	frame.size.width=65; frame.size.height=65;
	frame.origin.x=9; frame.origin.y=11;
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
	
	NSString *usrname =[[stories objectAtIndex:indexPath.row] objectForKey:@"username"];
	
	if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"username"] length] > 22)			
		usrname = [[usrname substringWithRange:NSMakeRange(0,21)] stringByAppendingString:@"..."];
	
	CGRect lableNameFrame = CGRectMake(89, 4, 165, 18);	
	lblUserName = [UnsocialAppDelegate createLabelControl:usrname frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableCellHeading txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblUserName];
	
		// starts 14 Jun for linkedin user identification - v1.8vaibhav  
	NSString *prefix = [[stories objectAtIndex:indexPath.row] objectForKey:@"prefix"];
	
	NSString *firstLevel = [[stories objectAtIndex:indexPath.row] objectForKey:@"level"];
		//ends
	
	NSString *displayitem = [[stories objectAtIndex:indexPath.row] objectForKey:@"displayitem"];
	NSString *isindustryshow = [[displayitem substringFromIndex:1] substringToIndex:1];
	NSString *iscompanyshow = [[displayitem substringFromIndex:2] substringToIndex:1];
	
	UILabel *lblcompany = [UnsocialAppDelegate createLabelControl:@"Company: " frame:CGRectMake(lableNameFrame.origin.x, 27, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblcompany];
	
	UILabel *lblindustry = [UnsocialAppDelegate createLabelControl:@"Industry: " frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 16, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblindustry];
	
	UILabel *lblfunction = [UnsocialAppDelegate createLabelControl:@"Function:" frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 32, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblfunction];
	
	// for company **** start ****
	// if company is set as private then it will be as 1 else 0
	CGRect lableCompanyFrame = CGRectMake(152, lblcompany.frame.origin.y, 140, 15);		
	lblCompanyName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"company"] frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	
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
	
	
	if ([iscompanyshow compare:@"0"] != NSOrderedSame) // company is private i.e. 1
	{
		CGRect lableLockFrame = CGRectMake(149, lblcompany.frame.origin.y, 15, 15);
		userImage = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
		[cell.contentView addSubview:userImage];
	}
	else {
		
		if([lblCompanyName.text compare:@""] == NSOrderedSame)
			
			lblCompanyName.text = @"not set";
		else				
			lblCompanyName.text = [[stories objectAtIndex:indexPath.row] objectForKey:@"company"];
		
		[cell.contentView addSubview:lblCompanyName];
	}
	
	// for company **** end ****
	// if industry is set as private then it will be as 1 else 0
	CGRect lableIndustryFrame = CGRectMake(148, lblcompany.frame.origin.y + 16, 140, 15);
	
	lblIndustryName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"industry"] frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	
	if ([isindustryshow compare:@"0"] != NSOrderedSame) // industry is private i.e. 1
	{		
		CGRect lableLockFrame = CGRectMake(150, lblcompany.frame.origin.y + 16, 15, 15);
		userImage = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
		[cell.contentView addSubview:userImage];
	}
	else {
		
		if ([lblIndustryName.text compare:@""] == NSOrderedSame)
			
			lblIndustryName.text = @"not set";
		else				
			lblIndustryName.text = [[stories objectAtIndex:indexPath.row] objectForKey:@"industry"];
		[cell.contentView addSubview:lblIndustryName];
	}
	// for Industry **** end ****
	
	//for role ****start**********		
	CGRect lableRoleFrame = CGRectMake(150, lblcompany.frame.origin.y + 32, 195, 15);
	lblFunctionName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"role"] frame:lableRoleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	
	if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"role"] isEqualToString:@""])
		lblFunctionName.text = @"not set";
	
	[cell.contentView addSubview:lblFunctionName];
	// 13 may 2011 by pradeep //[lblFunctionName release];
	
	// for role *****end **********
	
	// for distance ******start*******		
	CGRect lableDistanceFrame = CGRectMake(212, lableNameFrame.origin.y, 100, 18);
	lblUserName = [UnsocialAppDelegate createLabelControl:@"" frame:lableDistanceFrame txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	
	NSString *showDistance;
	NSArray *aryMiles = [[[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"] componentsSeparatedByString:@" Miles"];
	
	float floatMiles = [[aryMiles objectAtIndex:0] floatValue];
	if(floatMiles <= 1.00) {
		
		showDistance = @"Steps Away";
		lblUserName.textColor = [UIColor orangeColor];
	}
	else if(floatMiles < 5.00) {
		
		if(floatMiles > 1.00) {
			
			showDistance = @"Short Distance";
			lblUserName.textColor = [UIColor orangeColor];
		} 
	}
	else {
		showDistance = [[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"]; 
		lblUserName.textColor = [UIColor orangeColor];
	}
	lblUserName.text = showDistance;
	[cell.contentView addSubview:lblUserName];
	
	// 13 may 2011 by pradeep //[lblcompany release];
	// 13 may 2011 by pradeep //[lblindustry release];
	// 13 may 2011 by pradeep //[lblfunction release];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
	
	//***************end
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	PeoplesUserProfile *peoplesUserProfile = [[PeoplesUserProfile alloc]init];
	peoplesUserProfile.myname  = [myName objectAtIndex:0];
	
	peoplesUserProfile.userid = [[stories objectAtIndex:indexPath.row] objectForKey:@"guid"];
	peoplesUserProfile.username = [[stories objectAtIndex:indexPath.row] objectForKey:@"username"];
	peoplesUserProfile.userprefix = [[stories objectAtIndex:indexPath.row] objectForKey:@"prefix"];
	
	/*if([[[stories objectAtIndex:indexPath.row] objectForKey:@"prefix"] isEqualToString:@"none"])
		peoplesUserProfile.useremail = [[stories objectAtIndex:indexPath.row] objectForKey:@"linkedinemailid"];
	else
		peoplesUserProfile.useremail = [[stories objectAtIndex:indexPath.row] objectForKey:@"email"];*/
	
	if([[[stories objectAtIndex:indexPath.row] objectForKey:@"prefix"] isEqualToString:@"none"]) {
		
		peoplesUserProfile.useremail = [[stories objectAtIndex:indexPath.row] objectForKey:@"linkedinemailid"];
		peoplesUserProfile.userlinkedintoken = [[stories objectAtIndex:indexPath.row] objectForKey:@"email"];
	}
	else
		peoplesUserProfile.useremail = [[stories objectAtIndex:indexPath.row] objectForKey:@"email"];
	
	peoplesUserProfile.usercontact = [[stories objectAtIndex:indexPath.row] objectForKey:@"contact"];	
	peoplesUserProfile.usercompany = [[stories objectAtIndex:indexPath.row] objectForKey:@"company"];
	peoplesUserProfile.usertitle = [[stories objectAtIndex:indexPath.row] objectForKey:@"usertitle"];	
	peoplesUserProfile.userlevel = [[stories objectAtIndex:indexPath.row] objectForKey:@"level"];	
	peoplesUserProfile.userwebsite = [[stories objectAtIndex:indexPath.row] objectForKey:@"userwebsite"];
	peoplesUserProfile.userlinkedin = [[stories objectAtIndex:indexPath.row] objectForKey:@"linkedinprofile"];	
	peoplesUserProfile.userabout = [[stories objectAtIndex:indexPath.row] objectForKey:@"aboutu"];	
	peoplesUserProfile.userind = [[stories objectAtIndex:indexPath.row] objectForKey:@"industry"];	
	peoplesUserProfile.usersubind = [[stories objectAtIndex:indexPath.row] objectForKey:@"subindustry"];
	peoplesUserProfile.userrole = [[stories objectAtIndex:indexPath.row] objectForKey:@"role"];	
	peoplesUserProfile.userintind = [[stories objectAtIndex:indexPath.row] objectForKey:@"interestind"];
	peoplesUserProfile.statusmgs = [[stories objectAtIndex:indexPath.row] objectForKey:@"status"];
	peoplesUserProfile.userintsubind = [[stories objectAtIndex:indexPath.row] objectForKey:@"interestsubind"];	
	peoplesUserProfile.userintrole = [[stories objectAtIndex:indexPath.row] objectForKey:@"interestrole"];
	peoplesUserProfile.userdisplayitem = [[stories objectAtIndex:indexPath.row] objectForKey:@"displayitem"];	
	peoplesUserProfile.userintind = [[stories objectAtIndex:indexPath.row] objectForKey:@"interestind"];
	peoplesUserProfile.fullImg = [[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	
	//******************** for lazi img start
	
	//NSURL *url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
	//[aryEventDetails addObject:[imageURLs4Lazy objectAtIndex:indexPath.row]];
	peoplesUserProfile.imgurl = [imageURLs4Lazy objectAtIndex:indexPath.row];
	peoplesUserProfile.camefromwhichoption = @"attendeelist";
	
	//******************** for lazi img end
	
	peoplesUserProfile.profileforwhichtab = [[stories objectAtIndex:indexPath.row] objectForKey:@"forwhichtab"];
	peoplesUserProfile.strdistance = [[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"];
	
	peoplesUserProfile.eventid4attendeelistofnormalevent = eventid;
	
	[self.navigationController pushViewController:peoplesUserProfile animated:YES];
}
/*// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// Delete the row from the data source
		[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
	} 
}*/

- (void)leftbtn_OnClick {
	[self.navigationController popViewControllerAnimated:YES];
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
