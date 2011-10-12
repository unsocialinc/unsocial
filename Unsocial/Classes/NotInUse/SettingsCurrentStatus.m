//
//  SettingsCurrentStatus.m
//  Unsocial
//
//  Created by vaibhavsaran on 02/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsCurrentStatus.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"
#import "Person.h"

@implementation SettingsCurrentStatus
@synthesize userid, strsetstatus;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[activityView stopAnimating];
	activityView.hidden = YES;
	[self createControls];
}	

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"SettingsStep2 view will appear");
	NSLog(@"User's Userid- %@", [arrayForUserID objectAtIndex:0]);
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
	
	UIImage *rightimag = [UIImage imageNamed: @"rightNav.png"];
	UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[rightbtn setBackgroundColor:[UIColor clearColor]];
	[rightbtn setImage:rightimag forState:(UIControlState) nil];
	[rightbtn addTarget:self action:@selector(rightbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
	itemNV.rightBarButtonItem = rightcbtnitme;
	rightbtn.hidden = YES;
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"BlankTemplate2.png"];
	[self.view addSubview:imgBack];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Set Profile" frame:CGRectMake(0, 0, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"Saving\nplease standby" frame:CGRectMake(25, 125 + yAxisForSettingControls, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];*/
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180 + yAxisForSettingControls, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {

	UILabel *about = [UnsocialAppDelegate createLabelControl:@"Current Status:" frame:CGRectMake(25, 35 + yAxisForSettingControls, 130, 30) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:about];
	// 13 may 2011 by pradeep //[about release];
	
//	[self getStatusOfUser:@""];
	
	textViewAbout = [[[UITextView alloc] initWithFrame:CGRectMake(25, 65 + yAxisForSettingControls, 270, 200)] autorelease];
	textViewAbout.delegate = self;
	textViewAbout.textColor = [UIColor blackColor];
	textViewAbout.font = [UIFont fontWithName:@"Arial" size:15];
	textViewAbout.backgroundColor = [UIColor clearColor];
	textViewAbout.scrollEnabled = YES;
	textViewAbout.userInteractionEnabled = NO;
//	textViewAbout.text = [aryStatus objectAtIndex:0];
	[self.view addSubview:textViewAbout];
	
	UIButton *btnSave = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnNext_Click) frame:CGRectMake(165, 365, 127, 34) imageStateNormal:@"save.png" imageStateHighlighted:@"save2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSave];
	[btnSave release];
	
	btnEdit = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnEdit_Click) frame:CGRectMake(30, 365, 127, 34) imageStateNormal:@"edit.png" imageStateHighlighted:@"edit2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnEdit];
	[btnEdit release];

	BOOL isrecexist = [self getDataFromFile];
	if(isrecexist) {
		
		textViewAbout.text = strsetstatus;
	}
}

- (void)btnNext_Click {
	
	if([textViewAbout.text length] > 140) {
		
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Status message is too lengthly to submit." message:@"maximum 140 charectors accepted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		return;
	}

	[self.view addSubview:imgBack];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Saving\nplease standby" frame:CGRectMake(25, 125 + yAxisForSettingControls, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	loading.hidden = NO;
	[activityView startAnimating];
	
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess:) userInfo:self.view repeats:NO];
}

- (void)startProcess:(id)sender {
	
	NSLog(gbluserid);
	[self sendNowStatus:@"updatestatus"];
	//[self sendNow:@"updateprofilestep6.png"];
	
	imgBack.hidden = YES;
	[activityView stopAnimating];
	activityView.hidden = YES;
	loading.hidden = YES;
	
	UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Status saved successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[saveAlert show];
	[saveAlert release];
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) getDataFromFile {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4UnsocialStatus"];
	
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
		
		strsetstatus = [[tempArray objectAtIndex:0] strsetstatus];
		userid = [[tempArray objectAtIndex:0] userid];
		
		[decoder finishDecoding];
		[decoder release];	
		
		if ( [userid compare:@""] == NSOrderedSame || !userid)
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

- (void) updateDataFileOnSave {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	newPerson.strsetstatus = textViewAbout.text;
	newPerson.userid = [arrayForUserID objectAtIndex:0];
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4UnsocialStatus"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
}

- (void) getStatusOfUser:(NSString *)inid {
	// Time Formats
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	NSString *urlString;
	urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getstatus&userid=%@&datetime=%@", [arrayForUserID objectAtIndex:0], usertime];
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
	aryStatus = [[NSMutableArray alloc]init];
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
		statusUser = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		[item setObject:statusUser forKey:@"userstatus"]; 
		[stories addObject:[item copy]];
		[aryStatus addObject:statusUser];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"userstatus"])
	{
		[statusUser appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
}

- (BOOL) sendNowStatus: (NSString *) flag {
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",flag];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	//NSString *deviceTocken;
	
	NSString *userstatus;
	
	if ([textViewAbout.text compare:nil] == NSOrderedSame)
		userstatus = [NSString stringWithFormat:@"%@\r\n",@""];
	else userstatus = [NSString stringWithFormat:@"%@\r\n",textViewAbout.text];

	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	
	
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
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"status\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",userstatus] dataUsingEncoding:NSUTF8StringEncoding]];
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
	
    NSHTTPURLResponse *response11;
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response11 error:nil];
	
	NSLog(@"response header: %@", [response11 allHeaderFields]);
	
	NSDictionary *dic = [response11 allHeaderFields];
	BOOL successflg=NO;
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key compare:@"Userid"] == NSOrderedSame)			
		{
			//userid = [dic objectForKey:key];
			
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				[self updateDataFileOnSave];				
				NSLog(@"\n\n\n\n\n\n#######################-- post for status added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				
				//takePictureBtn.enabled = NO;
				userid = [dic objectForKey:key];
				//localuserid = userid;
				break;
			}			
		}
		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(returnString);

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

- (void)btnEdit_Click {
	
	textViewAbout.userInteractionEnabled = YES;
	textViewAbout.backgroundColor = [UIColor blackColor];
	textViewAbout.textColor = [UIColor blackColor];
	btnEdit.enabled = NO;
}

- (void)leftbtn_OnClick {	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	// provide my own Save button to dismiss the keyboard
	UIBarButtonItem* saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
	self.navigationItem.rightBarButtonItem = saveItem;
	[saveItem release];
}

- (void)saveAction:(id)sender {
	// finish typing text/dismiss the keyboard by removing it as the first responder
	//
	[textViewAbout resignFirstResponder];
	self.navigationItem.rightBarButtonItem = nil;	// this will remove the "save" button
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
