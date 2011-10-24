//
//  InboxShowMessage.m
//  Unsocial
//
//  Created by vaibhavsaran on 28/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InboxShowMessage.h"
#import "ActivityViewForPeople.h"
#import "UnsocialAppDelegate.h"
#import "PeopleSendMessage.h"
#import "PeoplesUserProfile.h"
#import "GlobalVariables.h"
#import "Person.h"

int flg4rply;

@implementation InboxShowMessage
@synthesize strFrom, strFromName, strMsgDescription, strDateTime, strMsgId, strReadMsg, strPurpose;

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
	
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	//add background color
	self.view.backgroundColor = color;
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(btnDelete_Click)] autorelease];
	
	UIImageView *imgMsgBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 5, 320, 363) imageName:@"messagedetail.png"];
	[self.view addSubview:imgMsgBack];
	
	NSString *frmto;	
	if ([strPurpose compare:@"inbox"] == NSOrderedSame)
	{
		frmto = @"From: ";
		if([strReadMsg compare:@"1"] == NSOrderedSame)
			[self sendNow:@"updatereadmsg"]; // for updating msg as read
	}
	else frmto = @"To: ";
	
	lblFrom = [UnsocialAppDelegate createLabelControl:frmto frame:CGRectMake(15, imgMsgBack.frame.origin.y + 7, 290, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblFrom];
	
	lblMsgDecr = [UnsocialAppDelegate createLabelControl:@"Message:" frame:CGRectMake(lblFrom.frame.origin.x, imgMsgBack.frame.origin.y + 70, 290, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblMsgDecr];
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 135, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor darkGrayColor] backgroundcolor:[UIColor clearColor]];*/

	// Load the sound
    id sndpath = [[NSBundle mainBundle] pathForResource:@"mailsent" ofType:@"wav"];
	CFURLRef baseURL = (CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpath];
	AudioServicesCreateSystemSoundID (baseURL, &beep);
	
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgMsgBack release];
	// end 3 august 2011 for fixing memory issue
}

- (void) playSound {
	AudioServicesPlaySystemSound (beep);
}

- (void)createControls {

	fromName = [UnsocialAppDelegate createLabelControl:strFromName frame:CGRectMake(lblFrom.frame.origin.x, lblFrom.frame.origin.y + 15, 290, 15) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:fromName];
	
	msgDescription = [UnsocialAppDelegate createTextViewControl:strMsgDescription frame:CGRectMake(lblFrom.frame.origin.x, lblMsgDecr.frame.origin.y + 15, 290, 255) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:13 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	msgDescription.contentInset = UIEdgeInsetsMake(-4.00, -8.00, 0.00, 0.00);
	[self.view addSubview:msgDescription];
	
	UIButton *btnProfile1 = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnProfile_Click) frame:CGRectMake(lblFrom.frame.origin.x, lblFrom.frame.origin.y + 15, 290, 50) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor blackColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnProfile1];
	
	UIButton *btnProfile = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnProfile_Click) frame:CGRectMake(280, 5, 30, 50) imageStateNormal:@"tipsright1.png" imageStateHighlighted:@"tipsright2.png" TextColorNormal:[UIColor blackColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnProfile];
	
	UIButton *btnReply = [UnsocialAppDelegate createButtonControl:@"Reply" target:self selector:@selector(btnReply_Click) frame:CGRectMake(128, 380, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnReply];
	[btnReply release];
	
	UIButton *btnDelete = [UnsocialAppDelegate createButtonControl:@"Reply with business card" target:self selector:@selector(btnReplyWithBusinessCard_Click) frame:CGRectMake(70, 375, 180, 26) imageStateNormal:@"btnBack.png" imageStateHighlighted:@"btnBack.png" TextColorNormal:[UIColor blackColor] TextColorHighlighted:[UIColor redColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnDelete.titleLabel setFont:[UIFont fontWithName:kAppFontName size:13]];
	
	NSString *strbadgevalue = [NSString stringWithFormat:@"%i", unreadmsg];
	if(unreadmsg != 0)
		inBoxviewcontroller.tabBarItem.badgeValue = strbadgevalue;
	else if (unreadmsg==0)
		inBoxviewcontroller.tabBarItem.badgeValue= nil;
}

/*- (void)willPresentAlertView:(UIAlertView *)alertView {
	
	[[[alertView subviews] objectAtIndex:1] setBackgroundColor:[UIColor colorWithRed:0.5 green:0.0f blue:0.0f alpha:1.0f]];
}*/

- (void)btnProfile_Click {
	
//	[self getProfile:@""];
	
	ActivityViewForPeople *peoplesUserProfile = [[ActivityViewForPeople alloc]init];
	peoplesUserProfile.strFrom = strFrom;
	
	/*peoplesUserProfile.userid = [[stories objectAtIndex:0] objectForKey:@"guid"];
	peoplesUserProfile.username = [[stories objectAtIndex:0] objectForKey:@"username"];
	peoplesUserProfile.myname  = [myName objectAtIndex:0];
	peoplesUserProfile.userprefix = [[stories objectAtIndex:0] objectForKey:@"prefix"];
	
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
	//peoplesUserProfile.profileforwhichtab = [[stories objectAtIndex:0] objectForKey:@"forwhichtab"];*/
	
	[self.navigationController pushViewController:peoplesUserProfile animated:YES];
	[peoplesUserProfile release];
}

// added comment by pradeep on 15 march 2011
// not in use getProfile method written below
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
	errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
		userlinkedinemailid = [[NSMutableString alloc]init];
		usertitle = [[NSMutableString alloc]init];
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
		[item setObject:userlinkedinemailid forKey:@"linkedinemailid"];
		[item setObject:usertitle forKey:@"usertitle"];
		
		//add the actual image as well right now into the stories array
		
		NSURL *url = [NSURL URLWithString:currentImageURL];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *y1 = [[UIImage alloc] initWithData:data];
		if (y1) {
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
	}else if ([currentElement isEqualToString:@"linkedinemailid"]) {
		[userlinkedinemailid appendString:string];
	}else if ([currentElement isEqualToString:@"usertitle"]) {
		[usertitle appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {		
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	//[itemTableView reloadData];
}

- (void)btnDelete_Click {
	
	errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to delete this message?" delegate:self cancelButtonTitle:
				  @"NO" otherButtonTitles:
				  @"YES", nil];
	[errorAlert show];
	[errorAlert release];
}

- (void)btnReply_Click {
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to send your Business Card also?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"No", @"Yes", @"Cancel",  nil];
	actionSheet.cancelButtonIndex = 1;
	actionSheet.destructiveButtonIndex = 2;
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	// show from our table view (pops up in the middle of the table)
	[actionSheet release];

}

- (void)btnReplyWithBusinessCard_Click {	
}

- (BOOL) getDataFromFile1 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
		//open it and read it 
		NSLog(@"data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];
		//[self setPersonArray:tempArray];
		
		NSLog(@"%@", [[tempArray objectAtIndex:0] usersubind]);
		if ( [[[tempArray objectAtIndex:0] usersubind] compare:@""] == NSOrderedSame)
		{
			NSLog(@"subind blank");
		}
				
		
		/*Person *newPerson = [[Person alloc] init];	
			
		newPerson.userprefix = [[tempArray objectAtIndex:0] userprefix];
		newPerson.username = [[tempArray objectAtIndex:0] username];
		newPerson.userid = [[tempArray objectAtIndex:0] userid];
		newPerson.useremail = [[tempArray objectAtIndex:0] useremail];
		newPerson.usercontact = [[tempArray objectAtIndex:0] usercontact];*/
		
		currentusername = [[tempArray objectAtIndex:0] username];
		NSLog(@"%@", [[tempArray objectAtIndex:0] username]);
		NSLog(@"%@", [[tempArray objectAtIndex:0] userid]);
		//userInfo = [[NSMutableArray alloc] init];
		userInfoDic = [[NSMutableDictionary alloc] init];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userprefix] forKey:@"usrpre" ];// insertObject:newPerson atIndex:0];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] username] forKey:@"usrname" ];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userid] forKey:@"usrid" ];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] useremail] forKey:@"usremail"];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] usercontact] forKey:@"usrcontact"];
		
		[userInfo addObject:[userInfoDic copy]];
		
		[decoder finishDecoding];
		[decoder release];	
		
		//newPerson.imgperson = [images objectAtIndex:0];
		//NSLog(@"\nuserid-%@\n\nusername-%@", newPerson.userid, newPerson.username);
		
		
		//[newPerson release];
		
		NSLog(@"%@", [[userInfo objectAtIndex:0] objectForKey:@"usrname"]);
		
		//if ( [username compare:@""] == NSOrderedSame || !username)
		if ( [[[tempArray objectAtIndex:0] userid] compare:@""] == NSOrderedSame || ![[tempArray objectAtIndex:0] userid])
		{
			return NO;
		}
		else {
			
			return YES;
		}		
	}
	else { 
		return NO;
	}
}

- (BOOL) getDataFromFile2 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial2"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
		//open it and read it 
		NSLog(@"data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];	
		
		NSLog(@"%@", [[tempArray objectAtIndex:0] username]);
		NSLog(@"%@", [[tempArray objectAtIndex:0] userid]);

		userInfoDic = [[NSMutableDictionary alloc] init];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] usercompany] forKey:@"usrcompany" ];// insertObject:newPerson atIndex:0];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userwebsite] forKey:@"usrwebsite" ];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userindustry] forKey:@"usrind" ];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userfunction] forKey:@"usrfunc"];
		
		[userInfo addObject:[userInfoDic copy]];
		
		NSLog(@"%@", [[userInfo objectAtIndex:0] objectForKey:@"usrcompany"]);
		
		if ([[[tempArray objectAtIndex:0] userid] compare:@""] == NSOrderedSame || ![[tempArray objectAtIndex:0] userid])
		{
			[decoder finishDecoding];
			[decoder release];
			return NO;
		}
		else {
			[decoder finishDecoding];
			[decoder release];
			return YES;
		}
	}
	else { //just in case the file is not ready yet.
		return NO;
	}
}


- (BOOL) postController:	(TTPostController *) 	postController willPostText: (NSString *) text {
	
	//NSLog(@"Text: %@", text); 
	/*if([text compare:nil] == NSOrderedSame || [text compare:@""] == NSOrderedSame)
	{
		errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please write message." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
		return NO;
	}
	else*/ {
		return YES;
	}
}

- (void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result { 
	
	//NSLog(@"Text: %@", text); 
	//[self sendMessage:text];
	if (flg4rply==0) // for normal reply
	{
		BOOL _checkprimeryinfo = [self getDataFromFile1];
		_checkprimeryinfo = YES;

		text = [NSString stringWithFormat:@"%@\n\n-------------------------------------------------\nFrom- %@\n-------------------------------------------------\n\n------Original Message------\n\n%@"
				, text
				, currentusername
				, strMsgDescription];
		
		NSLog(@"Total Text %@", text);
		
		
			// appending current msg + 'From' + username + 'Original Message' + pervious msg
			// 7 Jan v1.3.8
		/*
		text = [text stringByAppendingString:[@"\n\n------Original Message------\n\n" stringByAppendingString: strMsgDescription]];

		NSLog(@"rply without business card");		
		userInfo = [[NSMutableArray alloc] init];

		BOOL _checkprimeryinfo = [self getDataFromFile1];
		_checkprimeryinfo = YES;
		
		text = [NSString stringWithFormat:@"\n%@\n-------------------------------------------------\nFrom- %@\n-------------------------------------------------", text,[[userInfo objectAtIndex:0] objectForKey:@"usrname"]];*/
	}
	else // for reply with business card
	{
		NSLog(@"rply with business card");
		
		userInfo = [[NSMutableArray alloc] init];
		
		BOOL isPrimaryInfoExist = [self getDataFromFile1];
		NSLog(@"%@", [[userInfo objectAtIndex:0] objectForKey:@"usrname"]);
		BOOL isContactInfoExist = [self getDataFromFile2];
		NSLog(@"hello");
		if (isPrimaryInfoExist)
		{	
			/*
			text = [text stringByAppendingString:@"\n\n------Business Card------\n\n"];
			text = [text stringByAppendingString:[@"Name: " stringByAppendingString:[[userInfo objectAtIndex:0] objectForKey:@"usrname"]]];
			text = [text stringByAppendingString:[@"\nEmail: " stringByAppendingString:[[userInfo objectAtIndex:0] objectForKey:@"usremail"]]];
			text = [text stringByAppendingString:[@"\nContact: " stringByAppendingString:[[userInfo objectAtIndex:0] objectForKey:@"usrcontact"]]];
			 */
			
				// BugId- 00146 fixed -Vaibhav(v1.3.6) 
			if (![[[userInfo objectAtIndex:0] objectForKey:@"usrpre"] isEqualToString:@"none"]) {
				
				text = [NSString stringWithFormat:@"%@\n\n------Business Card------\n\nName: %@\nEmail: %@\nContact: %@", 
						text,[[userInfo objectAtIndex:0] objectForKey:@"usrname"], 
						[[userInfo objectAtIndex:0] objectForKey:@"usremail"], 
						[[userInfo objectAtIndex:0] objectForKey:@"usrcontact"]];
			}
			else {
				
					// BugId- 00145 fixed -Vaibhav(v1.3.6) 
				NSString *_getlinkedinmail = [UnsocialAppDelegate getLinkedInMailFromFile];
				if (![_getlinkedinmail isEqualToString:@""]) {

					text = [NSString stringWithFormat:@"%@\n\n------Business Card------\n\nName: %@\nEmail: %@\nContact: %@", 
							text,[[userInfo objectAtIndex:0] objectForKey:@"usrname"], 
							_getlinkedinmail, 
							[[userInfo objectAtIndex:0] objectForKey:@"usrcontact"]];
				}
				else {
					
					text = [NSString stringWithFormat:@"%@\n\n------Business Card------\n\nName: %@\nContact: %@", 
							text,[[userInfo objectAtIndex:0] objectForKey:@"usrname"], 
							[[userInfo objectAtIndex:0] objectForKey:@"usrcontact"]];
				}
			}
		}
			if (isContactInfoExist)
			{
				if ([[userInfo objectAtIndex:1] objectForKey:@"usrcompany"]) 
				text = [text stringByAppendingString:[@"\nCompany: " stringByAppendingString:[[userInfo objectAtIndex:1] objectForKey:@"usrcompany"]]];
				if ([[userInfo objectAtIndex:1] objectForKey:@"usrind"]) 
				text = [text stringByAppendingString:[@"\nIndustry: " stringByAppendingString:[[userInfo objectAtIndex:1] objectForKey:@"usrind"]]];
				if ([[userInfo objectAtIndex:1] objectForKey:@"usrfunc"]) 
				text = [text stringByAppendingString:[@"\nFunction: " stringByAppendingString:[[userInfo objectAtIndex:1] objectForKey:@"usrfunc"]]];
				if ([[userInfo objectAtIndex:1] objectForKey:@"usrwebsite"]) 
				text = [text stringByAppendingString:[@"\nWebsite: " stringByAppendingString:[[userInfo objectAtIndex:1] objectForKey:@"usrwebsite"]]];
			}
		text = [text stringByAppendingString:[@"\n\n------Original Message------\n\n" stringByAppendingString: strMsgDescription]];
	}
	
	NSLog(@"Text: %@", text);
	
	[self sendMessage:text];
}

- (BOOL) sendMessage:(NSString *)msgSentText {
	NSLog(@"Sending....");
	
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"sendmsg"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	//NSString *deviceTocken;
	
	//NSString *usrabout;
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	NSString *bookmarkedid, *usrid;
	
	bookmarkedid = [NSString stringWithFormat:@"%@\r\n",strFrom];
	usrid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];
	
	usrid = [NSString stringWithFormat:@"%@\r\n",strFrom];
	bookmarkedid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];
	NSString *strMessage = [NSString stringWithFormat:@"%@\r\n",msgSentText];
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"senderid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",bookmarkedid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"msgbody\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strMessage] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
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
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Userid"])			
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				NSLog(@"Message is- %@", strMessage);
				NSLog(@"\n\n\n\n\n\n#######################-- post for Send Message added successfully --#######################\n\n\n\n\n\n");
				successflg=YES;
				UIAlertView *saveAlert = [[UIAlertView  alloc] initWithTitle:nil message:@"Message sent successfully." delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil];
				[saveAlert show];
				[saveAlert release];
				[self playSound];
				break;
			}			
		}		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"%@", returnString);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

- (void)leftbtn_OnClick {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(buttonIndex == 0) {
		
		flg4rply = 0;
		TTPostController *postController = [[TTPostController alloc] init]; 
		postController.delegate = self; // self must implement the TTPostControllerDelegate protocol 
		self.popupViewController = postController; 
		postController.navigationItem.rightBarButtonItem.title = @"Send";
		postController.superController = self; // assuming self to be the current UIViewController 
		[postController showInView:self.view animated:YES]; 
		[postController release]; 
	}
	if(buttonIndex == 1) {
		
		flg4rply = 1;
		TTPostController *postController = [[TTPostController alloc] init]; 
		postController.delegate = self; // self must implement the TTPostControllerDelegate protocol 
		self.popupViewController = postController; 
		postController.navigationItem.rightBarButtonItem.title = @"Send";
		postController.superController = self; // assuming self to be the current UIViewController 
		[postController showInView:self.view animated:YES]; 
		[postController release]; 
	}
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {

	if(buttonIndex == 0){
	}
	else {
		
		[self.view addSubview:imgBack];
		[self.view addSubview:activityView];
		activityView.hidden = NO;
		
		loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 135, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor darkGrayColor] backgroundcolor:[UIColor clearColor]];		
		[self.view addSubview:loading];
		
		loading.hidden = NO;
		[activityView startAnimating];
		[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
	}
}

- (void)startProcess {
	
	if ([strPurpose compare:@"inbox"] == NSOrderedSame)		
		[self sendNow:@"deleteinboxmessage"];
	else [self sendNow:@"deletesentmessage"];
	[activityView stopAnimating];
	[self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger) sendNow: (NSString *) flag {
	NSLog(@"Sending....");
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
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	NSString *varMessageId = [NSString stringWithFormat:@"%@\r\n",strMsgId];	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"msgid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varMessageId] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
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
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Totunreadmsg"])
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				if ([flag compare:@"deletemessage"] == NSOrderedSame)
					NSLog(@"\n\n\n\n\n\n#######################-- post For Delete Message Executed successfully --#######################\n\n\n\n\n\n");
				else if ([flag compare:@"updatereadmsg"] == NSOrderedSame)
					NSLog(@"\n\n\n\n\n\n#######################-- post For updating read msg Executed successfully --#######################\n\n\n\n\n\n");
				unreadmsg = [[dic objectForKey:key] intValue];				
				successflg=YES;				
				//userid = [dic objectForKey:key];
				
				NSString *strbadgevalue = [NSString stringWithFormat:@"%i", unreadmsg];
				if(unreadmsg != 0)
					inBoxviewcontroller.tabBarItem.badgeValue = strbadgevalue;
				else if (unreadmsg==0)
					inBoxviewcontroller.tabBarItem.badgeValue= nil;
				
				break;
			}
		}
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
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
	[activityView release];
	//[loading release];
}


@end
