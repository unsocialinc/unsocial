//
//  InBox.m
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InBox.h"
	//#import "GlobalVariables.h"
#import "InboxShowMessage.h"
#import "UnsocialAppDelegate.h"

int arivefirsttime4msg;

@implementation InBox

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
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
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(btnDelete_Click)] autorelease];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"INBOX", @"SENT", nil]];
	segmentedControl.frame = CGRectMake(20, 5, 280, 35);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;	
	segmentedControl.tintColor = [UIColor colorWithRed:240/255.0 green:141/255.0 blue:60/255.0 alpha:1.0];
	[self.view addSubview:segmentedControl];

	if (arivefirsttime4msg ==0) {
		
		segmentedControl.selectedSegmentIndex = 0;
	}
	else {
		
		segmentedControl.selectedSegmentIndex = whichsegmentselectedlasttime4msg;
	}
}

-(void)displayAnimation {	
	
	imgBack2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack2.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack2];

	loading = [UnsocialAppDelegate createLabelControl:@"Retrieving messages\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)segmentAction:(id)sender {

	self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
	[self.view addSubview:segmentedControl];
	[self displayAnimation];
	NSLog(@"segmentAction: selected segment = %d", [sender selectedSegmentIndex]);

	int selectedSegment = [sender selectedSegmentIndex];
	[itemTableView setHidden:YES];
	if (!itemTableView)
		arivefirsttime4msg = 0;
	
	if (arivefirsttime4msg == 0)
	{
		arivefirsttime4msg = 1;
		if(selectedSegment == 0) {
			
			[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getInboxMsg) userInfo:self.view repeats:NO];
		}
		else {
			
			[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getSentMsg) userInfo:self.view repeats:NO];
		}
	}
	else
	{
		whichsegmentselectedlasttime4msg = selectedSegment;
			
		if(selectedSegment == 0) {
			
			[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getInboxMsg) userInfo:self.view repeats:NO];
		}
		else {
				
			[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getSentMsg) userInfo:self.view repeats:NO];
		}
	}
//	activityView.hidden = loading.hidden = imgBack2.hidden = YES;
}

- (void)leftbtn_OnClick{

	[lastVisitedFeature removeAllObjects];
	[lastVisitedFeature addObject:@"message"];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)createControls {
	
	if([stories count] > 0)
	{
		[self.view addSubview:imgBack];
		imgBack2.hidden = NO;
		[self.view addSubview:segmentedControl];
		itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 42, 320, 370) style:UITableViewStylePlain];
		itemTableView.delegate = self;
		itemTableView.dataSource = self;
		itemTableView.rowHeight = 56;
		itemTableView.backgroundColor = [UIColor clearColor];
		itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.view addSubview:itemTableView];
		itemTableView.hidden = NO;
		noMessage.hidden = YES;
	}
	else {
		
		itemTableView.hidden = YES;
		[self.view addSubview:imgBack];
		imgBack2.hidden = NO;
		[self.view addSubview:segmentedControl];
		NSString *nomsg = @"";
		if (segmentedControl.selectedSegmentIndex==0)
			nomsg = @"There are no new messages to display right now.";
		else nomsg = @"There are no sent messages to display right now.";
		noMessage = [UnsocialAppDelegate createLabelControl:nomsg frame:CGRectMake(30, 200, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		noMessage.hidden = NO;
		[self.view addSubview:noMessage];
		// 13 may 2011 by pradeep //[noMessage release];
	}
	loading.hidden = YES;
	[activityView stopAnimating];
	activityView.hidden = YES;
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
	
	InboxShowMessage *inboxShowMessage = [[InboxShowMessage alloc]init];
	inboxShowMessage.strFromName = [[stories objectAtIndex:indexPath.row] objectForKey:@"sendername"];
	inboxShowMessage.strMsgDescription = [[stories objectAtIndex:indexPath.row] objectForKey:@"msgbody"];
	inboxShowMessage.strFrom = [[stories objectAtIndex:indexPath.row] objectForKey:@"guid"];
	inboxShowMessage.strMsgId = [[stories objectAtIndex:indexPath.row] objectForKey:@"msgid"];
	inboxShowMessage.strReadMsg = [[stories objectAtIndex:indexPath.row] objectForKey:@"isread"];
	if (segmentedControl.selectedSegmentIndex==0)
		inboxShowMessage.strPurpose = @"inbox";
	else inboxShowMessage.strPurpose = @"sent";
	[self.navigationController pushViewController:inboxShowMessage animated:YES];
}

- (void)btnDelete_Click {
	//Do not let the user add if the app is in edit mode.
	if(!editing)
	{
		self.navigationItem.leftBarButtonItem.enabled = NO;
		[itemTableView setEditing:YES animated:YES];	
		editing = YES;
	}
	else
	{
		self.navigationItem.leftBarButtonItem.enabled = YES;
		[itemTableView setEditing:NO animated:YES];	
		editing = NO;
	}
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// Delete the row from the data source
		[self sendReqForDeleteMessage:indexPath.row];
		[stories removeObjectAtIndex:indexPath.row];
		[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		if([stories count] == 0)
		{
			NSString *nomsg = @"";
			if (segmentedControl.selectedSegmentIndex==0)
				nomsg = @"There are no new messages to display right now.";
			else nomsg = @"There are no sent messages to display right now.";
			noMessage = [UnsocialAppDelegate createLabelControl:nomsg frame:CGRectMake(30, 200, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			noMessage.hidden = NO;
			[self.view addSubview:noMessage];
			// 13 may 2011 by pradeep //[noMessage release];
			self.navigationItem.rightBarButtonItem = nil;
			self.navigationItem.leftBarButtonItem.enabled = YES;
		}
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
    // Set up the cell...
	
	UIImageView *imgCellBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 0, 320, 56) imageName:@""];
	
	imgCellBack.image = [UIImage imageNamed:@"msgread.png"];
	
	UILabel *fromName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"sendername"] frame:CGRectMake(10, 10, 212, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor  colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] backgroundcolor:[UIColor clearColor]];
	
	UILabel *msgDescription = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"msgbody"] frame:CGRectMake(10, 28, fromName.frame.size.width, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] backgroundcolor:[UIColor clearColor]];
	
	UILabel *lblDate = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"msgtime"] frame:CGRectMake(210, 12, 70, 30) txtAlignment:UITextAlignmentRight numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:10 txtcolor:[UIColor  colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] backgroundcolor:[UIColor clearColor]];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if([[[stories objectAtIndex:indexPath.row] objectForKey:@"isread"] isEqualToString:@"1"]){
		
		imgCellBack.image = [UIImage imageNamed:@"msgunread.png"];
		
		lblDate.textColor = [UIColor whiteColor];
		
		fromName.frame = CGRectMake(fromName.frame.origin.x + 22, fromName.frame.origin.y, fromName.frame.size.width - 22, fromName.frame.size.height);
		fromName.textColor = [UIColor whiteColor];
		[fromName setFont:[UIFont fontWithName:kAppFontName size:13]];
		
		msgDescription.frame = CGRectMake(msgDescription.frame.origin.x + 22, fromName.frame.origin.y + 18, fromName.frame.size.width, fromName.frame.size.height);
	}
	[cell.contentView addSubview:imgCellBack];
	[cell.contentView addSubview:lblDate];
	NSLog(@"Date: %@", lblDate.text);
	// 13 may 2011 by pradeep //[lblDate release];
	[cell.contentView addSubview:fromName];
	NSLog(@"Name: %@", fromName.text);
	// 13 may 2011 by pradeep //[fromName release];
	[cell.contentView addSubview:msgDescription];
	NSLog(@"Description: %@", msgDescription.text);
	// 13 may 2011 by pradeep //[msgDescription release];

	return cell;
}

- (void) getSentMsg {
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getsentmessage&datetime=%@&userid=%@", usertime, [arrayForUserID objectAtIndex:0]];
	urlString = [globalUrlString stringByAppendingString:urlString];
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];
}

- (void) getInboxMsg {
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);

	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];

	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getmessage&datetime=%@&userid=%@", usertime, [arrayForUserID objectAtIndex:0]];
	urlString = [globalUrlString stringByAppendingString:urlString];
	NSLog(@"%@", urlString);
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
	[self.view addSubview:segmentedControl];
	loading.hidden = activityView.hidden = YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"])
	{
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		strFrom = [[NSMutableString alloc] init];
		strDescription = [[NSMutableString alloc] init];
		strFromName = [[NSMutableString alloc] init];
		strDateTime = [[NSMutableString alloc] init];
		strMsgId = [[NSMutableString alloc] init];
		strReadMsg = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		[item setObject:strFrom forKey:@"guid"]; 
		[item setObject:strDescription forKey:@"msgbody"]; 		
		[item setObject:strFromName forKey:@"sendername"];
		[item setObject:strDateTime forKey:@"msgtime"];
		[item setObject:strMsgId forKey:@"msgid"];
		[item setObject:strReadMsg forKey:@"isread"];
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"guid"])
	{
		[strFrom appendString:string];
	}
	else if ([currentElement isEqualToString:@"msgbody"])
	{
		[strDescription appendString:string];
	}
	else if ([currentElement isEqualToString:@"sendername"])
	{
		[strFromName appendString:string];
	}
	else if ([currentElement isEqualToString:@"msgtime"])
	{
		[strDateTime appendString:string];
	}
	else if ([currentElement isEqualToString:@"msgid"])
	{
		[strMsgId appendString:string];
	}
	else if ([currentElement isEqualToString:@"isread"])
	{
		[strReadMsg appendString:string];
	}
}

- (NSInteger) sendReqForDeleteMessage:(NSInteger) storyIndex {
	NSLog(@"Sending....");
	//NSData *imageData1;
	
	
	// setting up the URL to post to
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];	
	NSString *flag = @"";
	if (segmentedControl.selectedSegmentIndex == 0)		
		flag = @"deleteinboxmessage";
	else flag = @"deletesentmessage";
	
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
	
	NSString *varMessageId = [NSString stringWithFormat:@"%@\r\n",[[stories objectAtIndex:storyIndex] objectForKey:@"msgid"]];	
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
		if ([key compare:@"Totunreadmsg"] == NSOrderedSame)			
		{
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
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

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	if([stories count] != 0)
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(btnDelete_Click)] autorelease];
	else self.navigationItem.rightBarButtonItem = nil;
	[self createControls];
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
