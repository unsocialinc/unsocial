//
//  ActivityViewForPeople.m
//  Unsocial
//
//  Created by vaibhavsaran on 16/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActivityViewForPeople.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"

@implementation ActivityViewForPeople
@synthesize strFrom, strFromName, strMsgDescription, strDateTime, strMsgId, strReadMsg, strPurpose;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self btnProfile_Click];
}

- (void)viewWillAppear:(BOOL)animated {
	
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
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;
	leftbtn.hidden = YES;
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	UILabel *loading = [UnsocialAppDelegate createLabelControl:@"Retrieving profile\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)btnProfile_Click {

	[self getProfile:@""];
	
	PeoplesUserProfile *peoplesUserProfile = [[PeoplesUserProfile alloc]init];
	
	peoplesUserProfile.userid = [[stories objectAtIndex:0] objectForKey:@"guid"];
	peoplesUserProfile.username = [[stories objectAtIndex:0] objectForKey:@"username"];
	peoplesUserProfile.myname  = [myName objectAtIndex:0];
	peoplesUserProfile.userprefix = [[stories objectAtIndex:0] objectForKey:@"prefix"];
	
	/*if([[[stories objectAtIndex:0] objectForKey:@"prefix"]isEqualToString:@"none"])
		peoplesUserProfile.useremail = [[stories objectAtIndex:0] objectForKey:@"linkedinemailid"];
	else
		peoplesUserProfile.useremail = [[stories objectAtIndex:0] objectForKey:@"email"];*/
	
	if([[[stories objectAtIndex:0] objectForKey:@"prefix"] isEqualToString:@"none"]) {
		
		peoplesUserProfile.useremail = [[stories objectAtIndex:0] objectForKey:@"linkedinemailid"];
		peoplesUserProfile.userlinkedintoken = [[stories objectAtIndex:0] objectForKey:@"email"];
	}
	else
		peoplesUserProfile.useremail = [[stories objectAtIndex:0] objectForKey:@"email"];
	
	peoplesUserProfile.usercontact = [[stories objectAtIndex:0] objectForKey:@"contact"];	
	peoplesUserProfile.usercompany = [[stories objectAtIndex:0] objectForKey:@"company"];	
	peoplesUserProfile.userwebsite = [[stories objectAtIndex:0] objectForKey:@"userwebsite"];
	peoplesUserProfile.userlinkedin = [[stories objectAtIndex:0] objectForKey:@"linkedinprofile"];	
	peoplesUserProfile.userabout = [[stories objectAtIndex:0] objectForKey:@"aboutu"];	
	peoplesUserProfile.userind = [[stories objectAtIndex:0] objectForKey:@"industry"];	
	peoplesUserProfile.usersubind = [[stories objectAtIndex:0] objectForKey:@"subindustry"];
	peoplesUserProfile.userrole = [[stories objectAtIndex:0] objectForKey:@"role"];	
	peoplesUserProfile.userintind = [[stories objectAtIndex:0] objectForKey:@"interestind"];
	
	peoplesUserProfile.userintsubind = [[stories objectAtIndex:0] objectForKey:@"interestsubind"];	
	peoplesUserProfile.userintrole = [[stories objectAtIndex:0] objectForKey:@"interestrole"];
	peoplesUserProfile.userdisplayitem = [[stories objectAtIndex:0] objectForKey:@"displayitem"];	
	peoplesUserProfile.userintind = [[stories objectAtIndex:0] objectForKey:@"interestind"];
	peoplesUserProfile.fullImg = [[stories objectAtIndex:0] objectForKey:@"itemPicture"];
	//peoplesUserProfile.camefrom = 1;
	peoplesUserProfile.statusmgs = [[stories objectAtIndex:0] objectForKey:@"status"];
	peoplesUserProfile.profileforwhichtab = [[stories objectAtIndex:0] objectForKey:@"forwhichtab"];
	peoplesUserProfile.usertitle = [[stories objectAtIndex:0] objectForKey:@"usertitle"];
	peoplesUserProfile.userlevel = [[stories objectAtIndex:0] objectForKey:@"level"];
	
	NSLog(@"peoplesUserProfile.userlevel - %@", [[stories objectAtIndex:0] objectForKey:@"level"]);
	peoplesUserProfile.camefrom = 1;
	
	// added below single line by pradeep on 15 march 2011 for fixing issue > if inbox > showmsg > userprofile, distance always shows "Steps away"
	peoplesUserProfile.camefromwhichoption = @"inbox";
	
	[self.navigationController pushViewController:peoplesUserProfile animated:NO];
	
}

- (void) getProfile:(NSString *) flg4whichtab {
	
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
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&flag2=%@",@"getuserprofile",gbllatitude,gbllongitude,gbluserid,usertime,strFrom];
	urlString = [globalUrlString stringByAppendingString:urlString];
	
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down."];
	NSLog(@"error parsing XML: %@", errorString);	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
		[item setObject:userstatus forKey:@"status"];
		[item setObject:userlinkedinemailid forKey:@"linkedinemailid"];
		[item setObject:usertitle forKey:@"usertitle"];
		[item setObject:userlevel forKey:@"level"];
		
		//[item setObject:usercurrentdistance forKey:@"currentdistance"];
		//[item setObject:userforwhichtab forKey:@"forwhichtab"];
		
		//add the actual image as well right now into the stories array
		
		/*NSURL *url = [NSURL URLWithString:currentImageURL];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *y1 = [[UIImage alloc] initWithData:data];
		if (y1) {
			[item setObject:y1 forKey:@"itemPicture"];		
		}*/
		
		NSURL *url = [NSURL URLWithString:currentImageURL];		
		NSString *searchForMe = @"images.png";
		NSRange range = [currentImageURL rangeOfString:searchForMe];// [searchThisString rangeOfString : searchForMe];
		// if image exist for user then use it else use default shooted img locally for user
		if (range.location == NSNotFound) 
		{
			NSLog(@"Thumbnail Image exist for this user.");
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *y1 = [[UIImage alloc] initWithData:data];
			if (y1) {
				[item setObject:y1 forKey:@"itemPicture"];		
			}
		}
		else
		{
			UIImage *y1 = [UIImage imageNamed: @"imgNoUserImage.png"];;
			//if (y1) {
			[item setObject:y1 forKey:@"itemPicture"];	
		}
		
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
	//[itemTableView reloadData];
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
