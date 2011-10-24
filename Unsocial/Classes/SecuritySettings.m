//
//  SecuritySettings.m
//  Unsocial
//
//  Created by vaibhavsaran on 16/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SecuritySettings.h"
#import "SecuritySettingsLevel1.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "SettingsStep5.h"
#import "Person.h"

NSString *localuserid;
UISwitch *switchCtl1;

@implementation SecuritySettings
@synthesize varSelectedLevel, varSecurityItems, varUserid, userid;

- (void)viewWillAppear:(BOOL)animated {
	
	editedLevel1 = NO;
	NSLog(@"ShowIndustryDetail view will appear");
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
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"BlankTemplate2.png"];
	[self.view addSubview:imgBack];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Privacy Settings " frame:CGRectMake(0, 0, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"Saving\nplease standby" frame:CGRectMake(25, 125 + (yAxisForSettingControls*4), 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];*/

	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180 + (yAxisForSettingControls*4), 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {
	
	UILabel *whiteLine, *describeLevels;
	NSString *labelTitle, *levelDecsription;
	int yForHeading = 38 + (yAxisForSettingControls*4);
	int yForDescription = 55 + (yAxisForSettingControls*4);

	whiteLine = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(25, 150, 270, 2) txtAlignment:UITextAlignmentCenter numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:1 txtcolor:[UIColor clearColor] backgroundcolor:[UIColor blackColor]];
	[self.view addSubview:whiteLine];
	
	whiteLine = [[UILabel alloc]initWithFrame:CGRectMake(25, 250, 270, 2)];
	[self.view addSubview:whiteLine];
	
	for(int j = 0; j < 2; j++)
	{
		if(j ==0)
		{
			labelTitle = @"Level 0";
			levelDecsription = @"Display every one everything about me";
		}
		else if(j == 1)
		{
			labelTitle = @"Level 1";	
			levelDecsription = @"Display me with selected info that i choose";
		}
		else if(j == 2)
		{
			labelTitle = @"Level 2";
			levelDecsription = @"Do not display my profile but I can see people";
		}
		describeLevels = [UnsocialAppDelegate createLabelControl:labelTitle frame:CGRectMake(22, yForHeading, 276, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:22 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:describeLevels];
		yForHeading = yForHeading + 100;

		describeLevels = [UnsocialAppDelegate createLabelControl:levelDecsription frame:CGRectMake(22, yForDescription, 276, 60) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:@"ArialRoundedMTBold-Italic" fontsize:19 txtcolor:[UIColor darkGrayColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:describeLevels];
		yForDescription = yForDescription + 100;
	}
	
	NSArray *segmentTextContent = [NSArray arrayWithObjects: @"Level 0", @"Level 1", nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.frame = CGRectMake(34, 320, 252, 35);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	[segmentedControl setImage:[UIImage imageNamed:@"securseg1.png"] forSegmentAtIndex:0];
	[segmentedControl setImage:[UIImage imageNamed:@"securseg2.png"] forSegmentAtIndex:1];
//	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;	
//	segmentedControl.tintColor = [UIColor colorWithRed:9.00/255.0 green:94.0/255.0 blue:140.0/255.0 alpha:1.0];
	
	BOOL isDataEsists = [self getDataFromFile];
	if(isDataEsists)
		segmentedControl.selectedSegmentIndex = [varSelectedLevel intValue];
	
	[self.view addSubview:segmentedControl];
	[segmentedControl release];
	
	btnEdit = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnEdit_Click) frame:CGRectMake(30, 365, 127, 34) imageStateNormal:@"edit.png" imageStateHighlighted:@"edit2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor blackColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnEdit];
	[btnEdit release];
	
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object
	//imgSelectedSeg1 = [UnsocialAppDelegate createImageViewControl:CGRectMake(34, 320, 126, 35) imageName:@"grey50.png"];
	imgSelectedSeg1 = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(34, 320, 126, 35) imageName:@"grey50.png"];
	// end 3 august 2011
	
	[self.view addSubview:imgSelectedSeg1];
	
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object
	//imgSelectedSeg2 = [UnsocialAppDelegate createImageViewControl:CGRectMake(160, 320, 126, 35) imageName:@"grey50.png"];
	imgSelectedSeg2 = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(160, 320, 126, 35) imageName:@"grey50.png"];
	// end 3 august 2011
	
	[self.view addSubview:imgSelectedSeg2];
	
	if(saveLevel1 == YES)
	{
		segmentedControl.selectedSegmentIndex = 1;
		btnEdit.enabled = YES;
		imgSelectedSeg2.hidden = NO;
		imgSelectedSeg1.hidden = YES;
	}
	else {
		
		btnEdit.enabled = NO;
		imgSelectedSeg2.hidden = YES;
		imgSelectedSeg1.hidden = NO;
	}
	UIButton *btnSave = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnNext_Click) frame:CGRectMake(165, 365, 127, 34) imageStateNormal:@"save.png" imageStateHighlighted:@"save2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor blackColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSave];
	[btnSave release];
}

- (void)updateLocation:(id)sender {
	
}

- (void) btnEdit_Click {
	
	editedLevel1 = YES;
	SecuritySettingsLevel1 *viewController = [[SecuritySettingsLevel1 alloc]init];
//	viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController presentModalViewController:viewController animated:YES];
	[viewController release];
}

- (void)segmentAction:(id)sender {
	NSLog(@"segmentAction: selected segment = %d", [sender selectedSegmentIndex]);
	selectedSegment = [sender selectedSegmentIndex];
	
	arrayForSelectedIndex = [[NSMutableArray alloc]init];
	[arrayForSelectedIndex addObject:[NSString stringWithFormat:@"%i", selectedSegment]];
	
	if(selectedSegment != 1) {
		
		btnEdit.enabled = NO;
		imgSelectedSeg2.hidden = YES;
		imgSelectedSeg1.hidden = NO;
		saveLevel1 = NO;
	}
	else {
		
		saveLevel1 = YES;
		btnEdit.enabled = YES;
		imgSelectedSeg2.hidden = NO;
		imgSelectedSeg1.hidden = YES;
	}
}

- (void) btnNext_Click {
	
	UIAlertView *errorAlert = [[UIAlertView alloc] init];
	if(!arrayForSelectedIndex)
	{
		errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"You must select a security level." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		return;
	}

	[self.view addSubview:imgBack];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Saving\nplease standby" frame:CGRectMake(25, 125 + (yAxisForSettingControls*4), 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	loading.hidden = NO;
	[activityView startAnimating];

	[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
}

- (void)startProcess
{
	if(selectedSegment == 0)
	{
		[self sendSecurityLevel:@"0000":@"0"];
	}
	else if(selectedSegment == 1)
	{
		if(!editedLevel1)
		{
			if([selectedLevels compare:@""] == NSOrderedSame)
				selectedLevels = @"1111";
			}
		[self sendSecurityLevel:selectedLevels :@"1"];
	}
	else if (selectedSegment == 2)
	{
		[self sendSecurityLevel:@"0000":@"2"];
	}
//	SettingsStep5 *viewController = [[SettingsStep5 alloc] init];
//	viewController.controlCamefrom = @"securitylevel";
//	if(gblRecordExists)
//		[self.navigationController popToRootViewControllerAnimated:YES];
//	else
		[self.navigationController popViewControllerAnimated:YES];// pushViewController:viewController animated:YES];
//	[viewController release];
}

- (BOOL)sendSecurityLevel:(NSString *)selsecurity:(NSString *)selectedLevel {
	
	NSLog(@"Sending....");
	
	// setting up the URL to post to	
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];	
	
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSString *flag = [NSString stringWithFormat:@"%@\r\n",@"updateprofilestep5"];
	
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
		
	NSString *selSecurity = [NSString stringWithFormat:@"%@\r\n",selsecurity];
	NSString *securityLevel = [NSString stringWithFormat:@"%@\r\n",selectedLevel];
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	NSString *allownotification = [NSString stringWithFormat:@"%@\r\n",@"0"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];		
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"flag\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",flag] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"displayitem4security\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",selSecurity] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"securitylevel\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",securityLevel] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"isallownotification\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",allownotification] dataUsingEncoding:NSUTF8StringEncoding]];
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
				[self updateDataFileOnSave:[arrayForUserID objectAtIndex:0] :selectedLevel:selsecurity];
				NSLog(@"\n\n\n\n\n\n#######################-- post for SecuritySettings added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				localuserid = [dic objectForKey:key];
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

- (BOOL) getDataFromFile {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"securitysettings"];
	
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
		varSelectedLevel = [[tempArray objectAtIndex:0] selectedSecurityLevel];
		varSecurityItems = [[tempArray objectAtIndex:0] displayedSecurityItems];
		varUserid = [[tempArray objectAtIndex:0] userid];
		NSString *curLoc = [[tempArray objectAtIndex:0] currentloaction];
		
		if([curLoc compare:@"1"] == NSOrderedSame)
			[switchCtl1 setOn:YES animated:YES];

		else
			[switchCtl1 setOn:NO animated:YES];
		
		[decoder finishDecoding];
		[decoder release];	
		
		if ( [varUserid compare:@""] == NSOrderedSame || !varUserid)
		{
			return NO;
		}
		else {
			// initialized global userid variable (returned usierid from web app) for tracing user in whole app
			
			return YES;
		}		
	}
	else {
		//just in case the file is not ready yet.
		return NO;
	}
}

- (void) updateDataFileOnSave:(NSString *)uid:(NSString *)level:(NSString *)securityItems {
	
	NSString *curLoc;
	if(switchCtl1.on == YES)
		curLoc = @"1";
	else
		curLoc = @"0";

	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];	
	
	newPerson.selectedSecurityLevel = level;
	newPerson.displayedSecurityItems = securityItems;
	newPerson.currentloaction = curLoc;
	newPerson.userid = uid;
	
	//newPerson.imgperson = [images objectAtIndex:0];
	NSLog(@"\nselectedSecurityLevel-%@\n\ndisplayedSecurityItems-%@", 	  
		  newPerson.selectedSecurityLevel, 
		  newPerson.displayedSecurityItems
		  );
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"securitysettings"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
}

- (void)leftbtn_OnClick
{
	[self.navigationController popViewControllerAnimated:YES];
}

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	activityView.hidden = YES;
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
    [super dealloc];
}


@end
