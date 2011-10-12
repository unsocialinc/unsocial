//
//  SettingsStep5.m
//  unsocial
//
//  Created by vaibhavsaran on 19/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIDeviceHardware.h"
#import "SettingsStep5.h"
#import "SecuritySettings.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"
#import "Person.h"

BOOL captimage = NO;

@implementation SettingsStep5
@synthesize imgPicker, videourl, userid, controlCamefrom, comingfrom, userid4digiboard;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header

	[activityView stopAnimating];
	activityView.hidden = YES;
	NSLog(@"hello digitalbillboard");
		//NSLog(@"%@", controlCamefrom);
	gbluserid = [arrayForUserID objectAtIndex:0];
	if ([lastVisitedFeature count] > 0)
	{
		if ([[lastVisitedFeature objectAtIndex:0] isEqualToString:@"viewdigitalbillboard"] || [[lastVisitedFeature objectAtIndex:0] isEqualToString:@"digitalbillboard"])
		{
			[self getImageFromFile];
		}
		else if ([[lastVisitedFeature objectAtIndex:0] isEqualToString:@"viewdigitalbillboardfrmusrprofile"])
		{
			[self getUnsocialTile:userid4digiboard];
		}
	}
	if (controlCamefrom == nil)
	{
			//START unsocial tile downloads first time for self -vaibhav(V1.1)
		BOOL checkForLocalBB = [self checkForFlagUnsocialTile:@"flagunsocialtile.jpg"];
		if(checkForLocalBB) // flag image exists
			
			[self getImageFromFile];
		else
			[self getUnsocialTile:gbluserid];
			//END
			
		controlCamefrom = @"securitylevel";
	}
	[self createControls];
}

- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"SettingsStep4 view will appear");
	NSLog(@"User's Userid- %@", [arrayForUserID objectAtIndex:0]);
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	//add background color
	self.view.backgroundColor = color;	
	imgHead = [UIImage imageNamed: @"headlogo.png"];
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	
	if(comingfrom == 0) {
		self.navigationItem.leftBarButtonItem = leftcbtnitme;
	}
	else {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	}

	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//loading = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	loading = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:loading];

		//START 
		// loading text -vaibhav(V1.1)
	BOOL checkForLocalBB = [self checkForFlagUnsocialTile:@"flagunsocialtile.jpg"];
	if(!checkForLocalBB)
		loading.text = @"loading unsocial tile first time\nplease standby";
	else {
		if([lastVisitedFeature count] > 0) {
			
			if ([[lastVisitedFeature objectAtIndex:0] isEqualToString:@"viewdigitalbillboardfrmusrprofile"])
				loading.text = @"loading unsocial tile\nplease standby";
		}
		else
			loading.text = @"";
		
	}
	/*
	checkForLocalBB = [self checkForFlagUnsocialTile:@"billboard.jpg"];
	if(!checkForLocalBB)
		loading.text = @"";*/
	//END
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(rightbtn_OnClick)] autorelease];

	CGRect frame = CGRectMake(10, 45, 300, 320);
	self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
	
	_scrollView = [[TTScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.dataSource = self;
	_scrollView.backgroundColor = [UIColor clearColor];
	_scrollView.scrollEnabled = YES;
	[self.view addSubview:_scrollView];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[_scrollView addSubview:imgBack];
	[imgBack release];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"signupback.png"];
	[_scrollView addSubview:imgBack];
	[imgBack release];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"unsocial Tile" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	if(comingfrom == 2) // comingfrom is set as 2 when user user wants to see other's digital billboard using "Media" feature from user profile
		heading.text = @"unsocial Tile";
	[_scrollView addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];

	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 40, 300, 2) imageName:@"dashboardhorizontal.png"];
	[_scrollView addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 410, 300, 2) imageName:@"dashboardhorizontal.png"];
	[_scrollView addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	if ([lastVisitedFeature count] > 0)
	{
		if ([[lastVisitedFeature objectAtIndex:0] isEqualToString:@"viewdigitalbillboard"])
		{
			btnSave.hidden = TRUE;
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(rightbtn_OnClick)] autorelease];
//			btnGrab.hidden = TRUE;
		}
		else if ([[lastVisitedFeature objectAtIndex:0] isEqualToString:@"viewdigitalbillboardfrmusrprofile"])
		{
			btnSave.hidden = TRUE;
			self.navigationItem.rightBarButtonItem = nil;
//			btnGrab.hidden = TRUE;
		}
	}
//	[btnGrab release];
	[btnSave release];
}

- (NSInteger)numberOfPagesInScrollView:(TTScrollView*)scrollView {
	return 1;
}

- (UIView*)scrollView:(TTScrollView*)scrollView pageAtIndex:(NSInteger)pageIndex {

	TTView* pageView = nil;
	if (!pageView) {
		pageView = [[[TTView alloc] init] autorelease];
		pageView.backgroundColor = [UIColor clearColor];
		pageView.userInteractionEnabled = NO;
	
		imageGrabed = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 300, 360)];
		
		if([stories4digitalbillboard count] == 0) {
			
			if ([capturedImage count] > 0)
				imageGrabed.image = [capturedImage objectAtIndex:0];
			else
				imageGrabed.image = [UIImage imageNamed:@"billboard.png"];
		}
		else if([stories4digitalbillboard count] == 1) {
			imageGrabed.image = [[stories4digitalbillboard objectAtIndex:0] objectForKey:@"billboardPicture"];
		}
		else {
			imageGrabed.image = [capturedImage objectAtIndex:0];
		}

		CGImageRef realImage = imageGrabed.image.CGImage;
		float realHeight = CGImageGetHeight(realImage);
		float realWidth = CGImageGetWidth(realImage);
		float ratio = realHeight/realWidth;
		float modifiedWidth, modifiedHeight;
		if(ratio > 1) {
			
			modifiedWidth = 360/ratio;
			modifiedHeight = 360;
		}
		else {
			
			modifiedWidth = 300;
			modifiedHeight = ratio*300;
		}
		imageGrabed.frame = CGRectMake(10, 45, modifiedWidth, modifiedHeight);
		
		CALayer * l = [imageGrabed layer];
		[l setMasksToBounds:YES];
		[l setCornerRadius:10.0];
		
		// You can even add a border
		[l setBorderWidth:1.0];
		[l setBorderColor:[[UIColor blackColor] CGColor]];
		imageGrabed.contentMode = UIViewContentModeScaleAspectFit;
		[pageView addSubview:imageGrabed];
	}
	return pageView;
}

- (CGSize)scrollView:(TTScrollView*)scrollView sizeOfPageAtIndex:(NSInteger)pageIndex {
	return CGSizeMake(320, 416);
}

- (void) getUnsocialTile:(NSString *)usrid {
	
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
	
	NSLog(@"Sending....");
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&flag2=%@",@"getdigitalbillboard",gbllatitude,gbllongitude,usrid,usertime,@""];
	urlString = [globalUrlString stringByAppendingString:urlString];
	
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
	
}

- (void)parseXMLFileAtURL:(NSString *)URL {
	stories = [[NSMutableArray alloc] init];	
	stories4digitalbillboard = [[NSMutableArray alloc] init];
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
	
	currentElement = [elementName copy];	
	// for digital billboard image
	if ([elementName isEqualToString:@"enclosuredigitalbillboard"]) {
		item = [[NSMutableDictionary alloc] init];
		digitalBillBoardImageURL = [attributeDict valueForKey:@"url"];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
			
	// for digital billboard image
	if ([elementName isEqualToString:@"enclosuredigitalbillboard"]) {
		NSURL *url = [NSURL URLWithString:digitalBillBoardImageURL];		
		NSString *searchForMe = @"images.png";
		NSRange range = [digitalBillBoardImageURL rangeOfString:searchForMe];// [searchThisString rangeOfString : searchForMe];
		// if image exist for user then use it else use default shooted img locally for user
		if (range.location == NSNotFound) 
		{
			NSLog(@"Thumbnail Image exist for this user.");
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *imgDigi = [[UIImage alloc] initWithData:data];
			if (imgDigi) {
				[item setObject:imgDigi forKey:@"billboardPicture"];
				
					//START 
					//Check condition to save unsocial tile locally -vaibhav(V1.1)
				if (!userid4digiboard)
					[self saveLocalBillBoardFromRSS:imgDigi];
					//save unsocial tile locally if user comes to his profile first time -vaibhav(V1.1)
					//END
			}
		}
		else
		{
			UIImage *imgDigi = [UIImage imageNamed: @"billboard.png"];;
			[item setObject:imgDigi forKey:@"billboardPicture"];
		}
		
		[stories4digitalbillboard addObject:[item copy]];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	NSLog(@"found characters: %@", string);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	NSLog(@"all done!");
	NSLog(@"stories array for activityviewforlauncher has %d items", [stories count]);
}

- (void)leftbtn_OnClick {
	
	// lastVisitedFeature defined in startprocess
	// accding coment given below by pradeep on 24 June 2010
	// adding if condition for useing this view controller in two modes, one for setting digital billboard img and another for viewing digital billboard img
	if ([lastVisitedFeature count] > 0)
	{
		if ([[lastVisitedFeature objectAtIndex:0] isEqualToString:@"viewdigitalbillboard"])
		{
			[lastVisitedFeature removeAllObjects];
			[self dismissModalViewControllerAnimated:YES];
		}
		else if ([[lastVisitedFeature objectAtIndex:0] isEqualToString:@"viewdigitalbillboardfrmusrprofile"])
		{
			[lastVisitedFeature removeAllObjects];
			[self.navigationController popViewControllerAnimated:YES];
		}
		else [self.navigationController popViewControllerAnimated:YES];
	}
	else [self.navigationController popViewControllerAnimated:YES];
	
	if(captimage) {
		
		captimage = NO;
		[self btnSave_Click];
	}
}

- (void)btnSave_Click {
	
	[UnsocialAppDelegate playClick];
	if([capturedImage count] == 0) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Please add a unsocial Tile" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
		[actionSheet showInView:self.view];
		// show from our table view (pops up in the middle of the table)
		[actionSheet release];
		return;
	}
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(180, 380, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	activityView.hidden = NO;
	[self.view addSubview:loading];
	loading.hidden = NO;
	btnSave.hidden = YES;
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess:) userInfo:self.view repeats:NO];
}

- (void)startProcess:(id)sender {
	
	savingProfile = YES;
	if(![UnsocialAppDelegate checkInternet:@"http://www.google.com"]) {
		
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Failed to upload" message:@"Check your internet connectivity." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
		savingProfile = YES;
		activityView.hidden = YES;
		loading.hidden = YES;
		btnSave.hidden = NO;
		return;
	}
	
	NSLog(@"%@", gbluserid);
	[self sendNow4DigiBill:@"updateprofilestep6"];
	
	[activityView stopAnimating];
	activityView.hidden = YES;
	loading.hidden = YES;

	[lastVisitedFeature removeAllObjects];
	[lastVisitedFeature addObject:@"digitalbillboard"];

	[capturedImage release];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)rightbtn_OnClick {
	
	savingProfile = NO;
	[self dialogSelection];
}

- (void)dialogSelection
{
	// open an alert with two custom buttons
	UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
	deviceString=[h platformString];
	NSLog(@"%@", deviceString);
	
	// open an alert with two custom buttons
	if(!capturedImage)
		capturedImage = [[NSMutableArray alloc] init];
	
	// checking for device in which camera feature is enabled
	if ([deviceString isEqualToString:@"iPod Touch 1G"] || [deviceString isEqualToString:@"iPod Touch 2G"] || [deviceString isEqualToString:@"iPhone Simulator"])
	{
		iscemera = NO;
		alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"From Gallery" otherButtonTitles:@"Cancel", nil];
	}
	else
	{
		iscemera = YES;
		alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Choose From Gallery", @"Take Photo",@"Cancel", nil];
	}
	[alertOnChoose show];
	[alertOnChoose release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
}


-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {

	if(!savingProfile)
	{
		if(iscemera){
			cameraUse = YES;
			if (buttonIndex == 0)
			{
				NSLog(@"chose existing photo");
				[self switchTouched];
			}
			else if (buttonIndex == 1)
			{
				NSLog(@"take photo from camera");
				[self recordNow];
			}
			else if (buttonIndex == 2)
			{
				NSLog(@"Cancel");
			}
		}
		else {
			if (buttonIndex == 0)
			{
				NSLog(@"chose existing photo");
				[self switchTouched];
			}
			else if (buttonIndex == 1)
			{
				NSLog(@"Cancel");
			}
		}
	}
	else
	{
		if (buttonIndex == 0)
		{

		}
	}
}

- (void)showTabOne {
	
	//tabBarController.selectedIndex = 0;
}

- (void) switchTouched
{
	cameraUse = NO;
	printf("switch touched - %d", cameraUse);
	[self recordNow];
}

- (IBAction)recordNow {
	
	[self captureImage];
	//set this flag back to yes for the next time.
	cameraUse = YES;
}

-(void) captureImage
{	
	self.imgPicker = [[UIImagePickerController alloc] init];
	//self.imgPicker.allowsEditing = YES;
	self.imgPicker.hidesBottomBarWhenPushed = YES;
	self.imgPicker.navigationBarHidden = YES;
	self.imgPicker.delegate = self;		
	
	if (cameraUse) {
		self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		//self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	else {
		self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	[self presentModalViewController:self.imgPicker animated:YES];
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo 
{	
	if ([capturedImage count] > 0)
	{
		//[capturedImage removeAllObjects];
		capturedImage = [[NSMutableArray alloc] init];
	}
	[stories4digitalbillboard removeAllObjects];
	[capturedImage addObject:img];
	captimage = YES;
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
	printf("Did begin editing\n");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	printf("Did end editing\n");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	printf("Clearing Keyboard\n");
    return YES;
}

- (BOOL) sendNow4DigiBill: (NSString *) flag
{
	NSLog(@"Sending....");
	//NSData *imageData1;
	
	NSData *imageData1 = [[NSData alloc] init];;
	NSString *isimg1exist = [NSString stringWithFormat:@"%@\r\n", @"no"];
	NSString *isimgexist = @"no";
	
	if ([capturedImage count] > 0)
	{
		
		isimg1exist = [NSString stringWithFormat:@"%@\r\n", @"yes"];
		isimgexist = @"yes";
		//imageData1 = [capturedImage objectAtIndex:0];//UIImageJPEGRepresentation([imgarry1 objectAtIndex:0], 1.0);
		imageData1 = UIImageJPEGRepresentation([capturedImage objectAtIndex:0], 1.0);
	}
	
	
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
	
	NSString *videourllocal;
	
//	if ([txtVideoUrl.text compare:nil] == NSOrderedSame)
		videourllocal = [NSString stringWithFormat:@"%@\r\n",@""];
//	else videourllocal = [NSString stringWithFormat:@"%@\r\n",txtVideoUrl.text];
	//NSString *role = [NSString stringWithFormat:@"%@\r\n",txtPersonRole.text];	
	
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
	
	if ([flag compare:@"updateprofilestep6"] == NSOrderedSame)
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	/*[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"videourl\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",videourllocal] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];*/
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"pic1exist\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",isimg1exist] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	if ([isimgexist compare:@"yes"] == NSOrderedSame)
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"pic1\"; filename=\"pic1.jpg\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[NSData dataWithData:imageData1]];
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
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
		if ([key compare:@"Userid"] == NSOrderedSame)			
		{
			//userid = [dic objectForKey:key];
			
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				//[self updateDataFileOnSave:[dic objectForKey:key]];
				if ([isimgexist compare:@"yes"] == NSOrderedSame)
					[self updateDataFileOnSave4Img:[dic objectForKey:key]];
				NSLog(@"\n\n\n\n\n\n#######################-- post for SettingsStep5 added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				//takePictureBtn.enabled = NO;
				userid = [dic objectForKey:key];
				//localuserid = userid;
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

// not in use comment added by pradeep on 23 June 2010
- (BOOL) getDataFromFile {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial6"];
	
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
		
		videourl = [[tempArray objectAtIndex:0] videourl];
		userid = [[tempArray objectAtIndex:0] userid];
		
		[decoder finishDecoding];
		[decoder release];	
		
		if ( [userid compare:@""] == NSOrderedSame || !userid)
		{
			return NO;
		}
		else {
			// initialized global userid variable (returned usierid from web app) for tracing user in whole app
			return YES;
		}
		
		
		
	}
	else { //just in case the file is not ready yet.
		//username = @"";
		//userlocation = @"";
		//[self CreateFile];
		return NO;
	}
}

- (BOOL)getImageFromFile{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"billboard.jpg"] retain];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isimgfilefound = NO;
	if(!captimage) {
		
	if([fileManager fileExistsAtPath:dataFilePath]) 
	{
		if ([capturedImage count] == 0)
			capturedImage = [[NSMutableArray alloc] init];
		else
		{
			capturedImage = nil;
			capturedImage = [[NSMutableArray alloc] init];
		}
		[capturedImage addObject:[UIImage imageWithContentsOfFile:dataFilePath ]];
		imageGrabed.image = [UIImage imageWithContentsOfFile:dataFilePath ];
		isimgfilefound = YES;		
	}
	else
	{
		imageGrabed.image = [UIImage imageNamed:@"imgNoUserImage.png"];
		isimgfilefound = NO;		
	}
	}
	return isimgfilefound;
}

// not in use comment added by pradeep on 22 june 2010
- (void) updateDataFileOnSave:(NSString *)uid {
	
	//NSLog(@"Selected Value- %d", selitem);
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	
	newPerson.videourl = @"";
	newPerson.userid = [arrayForUserID objectAtIndex:0];
	//newPerson.userimg = [capturedImage objectAtIndex:0];
	
//	if ([txtVideoUrl.text compare:nil] == NSOrderedSame)
		newPerson.videourl = @"";
//	else newPerson.videourl = txtVideoUrl.text;
	
	//newPerson.imgperson = [images objectAtIndex:0];
	/*NSLog(@"\nUsername-%@\n\nuseremail-%@\n\nuseraddress1-%@\n\nuserid", 	  
	 newPerson.username, 
	 newPerson.useremail,
	 newPerson.userid
	 );*/
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial6"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
}

	// for saving an image inside document forder

- (void) updateDataFileOnSave4Img:(NSString *)uid {
	
		//NSLog(@"Selected Value- %d", selitem);
		//NSMutableArray *userInfo;
	/*userInfo = [[NSMutableArray alloc] init];
	 Person *newPerson = [[Person alloc] init];
	 
	 
	 newPerson.userabout = textViewAbout.text;	
	 newPerson.userid = localuserid3;
	 //newPerson.userimg = [capturedImage objectAtIndex:0];
	 
	 if ([textViewAbout.text compare:nil] == NSOrderedSame)
	 newPerson.userabout = @"";
	 else newPerson.userabout = textViewAbout.text;
	 
	 //newPerson.imgperson = [images objectAtIndex:0];
	 
	 [userInfo insertObject:newPerson atIndex:0];
	 [newPerson release];
	 
	 NSMutableData *theData;
	 NSKeyedArchiver *encoder;
	 
	 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 NSString *documentsDirectory = [paths objectAtIndex:0];
	 NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial3.png"];	
	 theData = [NSMutableData data];
	 encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	 
	 [encoder encodeObject:userInfo forKey:@"userInfo"];
	 [encoder finishEncoding];
	 
	 [theData writeToFile:path atomically:YES];
	 [encoder release];*/
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"billboard.jpg"] retain];
		//imageData1 = UIImageJPEGRepresentation([capturedImage objectAtIndex:0], 1.0);
	NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation([capturedImage objectAtIndex:0], 1.0)];
	[imageData writeToFile:dataFilePath atomically:YES];
}
	// for saving an image inside document forder

- (void) saveLocalBillBoardFromRSS:(UIImage *)userimage {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *unsocialTileFilePath = [[documentsDirectory stringByAppendingPathComponent:@"billboard.jpg"] retain];
	NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(userimage, 1.0)];
	[imageData writeToFile:unsocialTileFilePath atomically:YES];

		//adding a aditional image as a flag and unsocial Tile will not download from rss again for self -vaibhav (V1.1)
	NSString *flagBillBoardFilePath = [[documentsDirectory stringByAppendingPathComponent:@"flagunsocialtile.jpg"] retain];
	NSData *flagImageData = [NSData dataWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"disclouser.png"], 1.0)];
	[flagImageData writeToFile:flagBillBoardFilePath atomically:YES];
}

- (BOOL) checkForFlagUnsocialTile:(NSString *)filename {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];

	if([fileManager fileExistsAtPath:path]) {
		//open it and read it 
		NSLog(@"Additional unsocial Tile Image found");
		return YES;
	}
	else { 
		return NO;
	}
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
