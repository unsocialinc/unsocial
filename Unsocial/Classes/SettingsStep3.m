//
//  SettingsStep3.m
//  Unsocial
//
//  Created by vaibhavsaran on 15/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsStep3.h"
#import "SettingsStep4.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "SettingsStep2.h"
#import "Person.h"
#import "UIDeviceHardware.h"

BOOL isAddClick=NO;

NSString *localuserid3;

@implementation SettingsStep3
@synthesize imgPicker, userid, userabout, controlCamefrom;

- (void)viewWillAppear:(BOOL)animated
{
	//NSLog(userid);
	//localuserid3 = userid;
	
	NSLog(@"SettingsStep3 view will appear");
	NSLog(@"User's Userid- %@", [arrayForUserID objectAtIndex:0]);
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
	
	// commented by pradeep on 13 may 2011 and pasted below
	/*loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];*/
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {
	
	UILabel *about = [UnsocialAppDelegate createLabelControl:@"About:" frame:CGRectMake(25, 35 + yAxisForSettingControls, 130, 30) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:about];
	// 13 may 2011 by pradeep //[about release];

	textViewAbout = [[[UITextView alloc] initWithFrame:CGRectMake(25, 65 + yAxisForSettingControls, 270, 155)] autorelease];
	textViewAbout.textColor = [UIColor blackColor];
	textViewAbout.font = [UIFont fontWithName:kAppFontName size:15];
	textViewAbout.delegate = self;
	textViewAbout.backgroundColor = [UIColor blackColor];
	textViewAbout.returnKeyType = UIReturnKeyDefault;
	textViewAbout.keyboardType = UIKeyboardTypeDefault;
	textViewAbout.scrollEnabled = YES;
	textViewAbout.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	if([capturedText count] > 0)
		textViewAbout.text = [capturedText objectAtIndex:0];
	[self.view addSubview:textViewAbout];

	UILabel *picture = [UnsocialAppDelegate createLabelControl:@"Picture:" frame:CGRectMake(25, 220 + yAxisForSettingControls, 130, 30) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:picture];
	// 13 may 2011 by pradeep //[picture release];
	
	UIButton *btnAddPhoto = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnAddPhoto_Click) frame:CGRectMake(30, 286 + yAxisForSettingControls, 127, 34) imageStateNormal:@"add_now.png" imageStateHighlighted:@"add_now2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnAddPhoto];
	[btnAddPhoto release];
	
	UILabel *bgImageGrabed = [UnsocialAppDelegate createLabelControl:@":" frame:CGRectMake(162, 224 + yAxisForSettingControls, 134, 100) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor blackColor]];
	[self.view addSubview:bgImageGrabed];
	// 13 may 2011 by pradeep //[bgImageGrabed release];

	imageGrabed = [[UIImageView alloc] initWithFrame:CGRectMake(164, 226 + yAxisForSettingControls, 130, 96)];
	if ([capturedImage count] > 0)
		imageGrabed.image = [capturedImage objectAtIndex:0];
	else
		imageGrabed.image = [UIImage imageNamed:@"imgNoUserImage.png"];
	[self.view addSubview:imageGrabed];
	

	UIButton *btnSkip = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnSkip_Click) frame:CGRectMake(30, 365, 127, 34) imageStateNormal:@"skip.png" imageStateHighlighted:@"skip2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSkip];
	[btnSkip release];
	
//	if(gblRecordExists){
		UIButton *btnSave = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnNext_Click) frame:CGRectMake(165, 365, 127, 34) imageStateNormal:@"save.png" imageStateHighlighted:@"save2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
		[self.view addSubview:btnSave];
		[btnSave release];
//	}
//	else {
//		UIButton *btnNext = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnNext_Click) frame:CGRectMake(165, 300, 127, 34) imageStateNormal:@"next.png" imageStateHighlighted:@"next2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
//	[self.view addSubview:btnNext];
//	[btnNext release];
//	}
}

- (BOOL) sendNow: (NSString *) flag
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
	
	NSString *usrabout;
		
	if ([textViewAbout.text compare:nil] == NSOrderedSame)
		usrabout = [NSString stringWithFormat:@"%@\r\n",@""];
	else usrabout = [NSString stringWithFormat:@"%@\r\n",textViewAbout.text];
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
	
	if ([flag compare:@"updateprofilestep3"] == NSOrderedSame)
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
			
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"aboutuser\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrabout] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
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
				[self updateDataFileOnSave:[dic objectForKey:key]];
				if ([isimgexist compare:@"yes"] == NSOrderedSame)
					[self updateDataFileOnSave4Img:[dic objectForKey:key]];
				NSLog(@"\n\n\n\n\n\n#######################-- post for Settings Step 3 added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				
				//takePictureBtn.enabled = NO;
				userid = [dic objectForKey:key];
				//localuserid = userid;
				break;
			}			
		}
		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	//NSData *returnRes = [returnString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//now see what the status came back as
	//TSXMLParser *myparser = [[TSXMLParser alloc] init];
	//[myparser parseXMLFileAtData:(NSData *)returnRes];
	
	//NSLog(myparser.status);
	//NSLog(returnString);
	
	NSLog(returnString);
	
	//NSString *strraffleid = raffleid;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
	//return;
}

- (BOOL) getDataFromFile {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial3"];
	
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
		
		userabout = [[tempArray objectAtIndex:0] userabout];
		userid = [[tempArray objectAtIndex:0] userid];
		
		[decoder finishDecoding];
		[decoder release];	
		
		//if ( [username compare:@""] == NSOrderedSame || !username)
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
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"1.png"] retain];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isimgfilefound = NO;
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
	return isimgfilefound;
}

- (void) updateDataFileOnSave:(NSString *)uid {
	
	//NSLog(@"Selected Value- %d", selitem);
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	
	newPerson.userabout = textViewAbout.text;	
	newPerson.userid = [arrayForUserID objectAtIndex:0];
	//newPerson.userimg = [capturedImage objectAtIndex:0];
	
	if ([textViewAbout.text compare:nil] == NSOrderedSame)
		newPerson.userabout = @"";
	else newPerson.userabout = textViewAbout.text;
		
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
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial3"];	
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
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"1.png"] retain];
	//imageData1 = UIImageJPEGRepresentation([capturedImage objectAtIndex:0], 1.0);
	NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation([capturedImage objectAtIndex:0], 1.0)];
	[imageData writeToFile:dataFilePath atomically:YES];
}

- (void)btnNext_Click {
	
	[self.view addSubview:imgBack];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	loading.hidden = NO;
	[activityView startAnimating];
	
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess:) userInfo:self.view repeats:NO];
}

- (void)startProcess:(id)sender {
	
	gbluserid = [arrayForUserID objectAtIndex:0];
	NSLog(gbluserid);
	[self sendNow:@"updateprofilestep3"];
	[self sendNow:@"updateprofilestep3.png"];

	[industryNames removeAllObjects];
	[interestedIndustryIds1 removeAllObjects];
	
	[subIndustryNames removeAllObjects];
	[interestedIndustryIds2 removeAllObjects];
	
	[roleNames removeAllObjects];
	[interestedIndustryIds3 removeAllObjects];
	
	SettingsStep4 *viewController = [[SettingsStep4 alloc]init];
	if(gblRecordExists)
		[self.navigationController popToRootViewControllerAnimated:YES];
	else
		[self.navigationController popViewControllerAnimated:YES];// pushViewController:viewController animated:YES];
	[viewController release];
}

- (void)btnSkip_Click
{
	//tabBarController.selectedIndex = 0;
}

- (void)leftbtn_OnClick {	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)btnAddPhoto_Click
{
	capturedText = [[NSMutableArray alloc]initWithObjects:textViewAbout.text, nil];
	[self dialogSelection];
}

- (void)dialogSelection
{
	// open an alert with two custom buttons
	UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
	deviceString=[h platformString];
	NSLog(deviceString);
	
	// open an alert with two custom buttons
	if(!capturedImage)
		capturedImage = [[NSMutableArray alloc] init];
	
	// checking for device in which camera feature is enabled
	if ([deviceString isEqualToString:@"iPod Touch 1G"] || [deviceString isEqualToString:@"iPod Touch 2G"] || [deviceString isEqualToString:@"iPhone Simulator"])
	{
		iscemera = NO;
		alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:
						 @"From Gallery" otherButtonTitles:
						 @"Cancel", nil];
	}
	else
	{
		iscemera = YES;
		alertOnChoose = [[UIAlertView alloc] initWithTitle:
						 @"" message:@"" delegate:self cancelButtonTitle:
						 @"Cancel" otherButtonTitles:
						 @"Choose From Gallery", 
						 @"Take Photo", nil];
	}
	[alertOnChoose show];
	[alertOnChoose release];
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
	cameraUse = YES;
	if(iscemera){
		if (buttonIndex == 0)
		{		
			NSLog(@"From Camera");
			[self recordNow];
		}
		else if (buttonIndex == 1)
		{		
			NSLog(@"From Gallery");
			[self switchTouched];
		}
		else if (buttonIndex == 2)
		{
			NSLog(@"Cancel");
		}
	}
	else {
		if (buttonIndex == 0)
		{		
			NSLog(@"From Gallery");
			[self switchTouched];
		}
		else if (buttonIndex == 1)
		{
			NSLog(@"Cancel");
		}	}
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
	self.imgPicker.allowsEditing = YES;
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
		capturedImage = nil;
		capturedImage = [[NSMutableArray alloc] init];
	}
	[capturedImage addObject:img];
	
		imageGrabed.image = [capturedImage objectAtIndex:0];
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
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

- (void)viewDidLoad {
}

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	activityView.hidden = YES;
	[self createControls];
	
	BOOL isrecexist = [self getDataFromFile];
	if (isrecexist)
	{
		if([capturedText count] > 0)
			textViewAbout.text = [capturedText objectAtIndex:0];
		else
			textViewAbout.text = userabout;
	}
	if ([controlCamefrom compare:@"step2"] == NSOrderedSame)
	{
		controlCamefrom = @"step3";
		[self getImageFromFile];
	}
	localuserid3 = userid;
}

@end
