//
//  SettingsStep4.m
//  Unsocial
//
//  Created by vaibhavsaran on 15/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsAddVideo.h"
#import "SettingsStep5.h"
#import "SelectIndustryPicker.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "ShowIndustryDetail.h"
#import "SecuritySettings.h"
#import "Person.h"

NSString *localuserid;

@implementation SettingsAddVideo
@synthesize userid, videoName, videoTitleName, comingfrom;

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"SettingsStep4 view will appear");
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
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"BlankTemplate2.png"];
	[self.view addSubview:imgBack];
	
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
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"Saving\nplease standby" frame:CGRectMake(25, 125 + yAxisForSettingControls, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];*/
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180 + yAxisForSettingControls, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	activityView.hidden = YES;
	[activityView stopAnimating];
	
	itemTableView.hidden = NO;	
	
	txtVideo = [UnsocialAppDelegate createTextFieldControl:CGRectMake(18, 7, 283, 29) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter video url" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeAlphabet returnKey:UIReturnKeyDone];
	txtVideo.borderStyle = UITextBorderStyleRoundedRect;
	txtVideo.backgroundColor = [UIColor clearColor];
	[txtVideo setDelegate:self];
	txtVideo.autocorrectionType = UITextAutocorrectionTypeNo;
	txtVideo.autocapitalizationType = UITextAutocapitalizationTypeNone;
	[self.view addSubview:txtVideo];
	
	txtTitle = [UnsocialAppDelegate createTextFieldControl:CGRectMake(18, 38 + yAxisForSettingControls, 209, 29) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:18 setPlaceholder:@"enter title" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeAlphabet returnKey:UIReturnKeyDone];
	txtTitle.borderStyle = UITextBorderStyleRoundedRect;
	txtTitle.backgroundColor = [UIColor clearColor];
	txtTitle.autocorrectionType = UITextAutocorrectionTypeNo;
	txtTitle.autocapitalizationType = UITextAutocapitalizationTypeNone;
	[txtTitle setDelegate:self];
	[self.view addSubview:txtTitle];
	
	UIButton *btnSetVideo = [UnsocialAppDelegate createButtonControl:@"Add" target:self selector:@selector(btnSetVideo_Click) frame:CGRectMake(230, 38 + yAxisForSettingControls, 71, 30) imageStateNormal:@"plainblue.png" imageStateHighlighted:@"plainblue2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnSetVideo.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
	[self.view addSubview:btnSetVideo];
	
	
	if (!itemTableView)
	{
		[self getVideoForUser:@""];
	}
	
	if([aryVideo count] > 0)
	{
		if (!itemTableView)
		{
			itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(19, 77, 282, 275) style:UITableViewStylePlain];
			itemTableView.delegate = self;
			itemTableView.dataSource = self;
			itemTableView.rowHeight = 65;
			itemTableView.backgroundColor = [UIColor clearColor];
			itemTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
			[self.view addSubview:itemTableView];
		}
		else {
			[itemTableView reloadData];
			[self.view addSubview:itemTableView];
		}
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete_click)] autorelease];
		editing = NO; // fal for deletion
	}
	else
	{
		lblNoVideo = [UnsocialAppDelegate createLabelControl:@"Currently you have no video url" frame:CGRectMake(20, 150, 280, 100) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:lblNoVideo];
		// 13 may 2011 by pradeep //[lblNoVideo release];
	}
	NSLog(@"aryVideo- %d", [aryVideo count]);

	UIButton *btnSave = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnNext_Click) frame:CGRectMake(100, 365, 127, 34) imageStateNormal:@"save.png" imageStateHighlighted:@"save2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSave];
	[btnSave release];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];    
    // Set up the cell...
	//+ method from Delegate
	CGRect lableTtlFrame = CGRectMake(0.00, 0.00, 300, 25);
	
	lblVideoName = [UnsocialAppDelegate createLabelControl:[aryVideoTitle objectAtIndex:indexPath.row] frame:lableTtlFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor lightGrayColor]];
	cell.selectionStyle = UITableViewCellSeparatorStyleNone;
	[cell.contentView addSubview:lblVideoName];
	
	lblVideoTitle = [UnsocialAppDelegate createLabelControl:[aryVideo objectAtIndex:indexPath.row] frame:CGRectMake(0.00, 25, 300, 40) txtAlignment:UITextAlignmentLeft numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:@"ArialRoundedMTBold-Italic" fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor lightGrayColor]];
	cell.selectionStyle = UITableViewCellSeparatorStyleNone;
	[cell.contentView addSubview:lblVideoTitle];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [aryVideo count];
	//return [stories count];
}

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here. Create and push another view controller.
 if(industryNames)
 {
 ShowIndustryDetail *viewController = [[ShowIndustryDetail alloc]init];
 viewController.industryName = [aryVideo objectAtIndex:indexPath.row];
 viewController.subIndustryName = [interestedIndustry2 objectAtIndex:indexPath.row];
 viewController.jobRole = [interestedIndustry3 objectAtIndex:indexPath.row];		
 [self.navigationController pushViewController:viewController animated:YES];
 [viewController release];
 }
 }*/
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// Delete the row from the data source
		[aryVideo removeObjectAtIndex:indexPath.row];
		[aryVideoTitle removeObjectAtIndex:indexPath.row];
		
		[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		if([aryVideo count] == 0) {
			
			itemTableView.hidden = YES;
			lblNoVideo = [UnsocialAppDelegate createLabelControl:@"Currently you have no video url" frame:CGRectMake(20, 150, 280, 100) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
			[self.view addSubview:lblNoVideo];
			// 13 may 2011 by pradeep //[lblNoVideo release];
		
			self.navigationItem.leftBarButtonItem.enabled = YES;
			self.navigationItem.rightBarButtonItem.enabled = NO;
			[itemTableView setEditing:NO animated:YES];	
			editing = NO;
			isSaved = YES;
		}
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
	
		// Insert the row from the data source
	}   
}

- (void)delete_click {
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

- (void)btnSetVideo_Click {
	
	NSString *trimmedString= txtVideo.text;
	trimmedString= [trimmedString lowercaseString];
	trimmedString = [trimmedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // trim
	NSArray *arr = [trimmedString componentsSeparatedByString:@","];
	
	if(([trimmedString compare:nil] == NSOrderedSame) || ([trimmedString compare:@""] == NSOrderedSame)) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter video URL." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		traceClick = 1;
		return;
	}
	else if ([arr count] > 1) {
		
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Comma is not allowed!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		traceClick = 1;
		return;
	}

	NSString *trimmedStringTtl= txtTitle.text;
	trimmedStringTtl= [trimmedStringTtl lowercaseString];
	trimmedStringTtl = [trimmedStringTtl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // trim
	NSArray *arrTtl = [trimmedStringTtl componentsSeparatedByString:@","];
	
	if(([trimmedStringTtl compare:nil] == NSOrderedSame) || ([trimmedStringTtl compare:@""] == NSOrderedSame)) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter video Title." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		traceClick = 1;
		return;
	}
	else if ([arrTtl count] > 1) {
		
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Comma is not allowed!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		traceClick = 1;
		return;
	}
	else if([trimmedStringTtl length] > 100) {
		
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Title can't be more than 100 of length." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		return;
	}
	
	[aryVideo addObject:txtVideo.text];
	[aryVideoTitle addObject:txtTitle.text];
 
	if(!itemTableView) {
		
		itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(19, 77, 282, 275) style:UITableViewStylePlain];
		itemTableView.delegate = self;
		itemTableView.dataSource = self;
		itemTableView.rowHeight = 65;
		itemTableView.backgroundColor = [UIColor clearColor];
		itemTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		[itemTableView reloadData];
		[self.view addSubview:itemTableView];
	}
	else {
		
		[itemTableView reloadData];
		[self.view addSubview:itemTableView];
	}
	txtVideo.text = @"";
	txtTitle.text = @"";
	if([aryVideo count] > 0) {
		lblNoVideo.hidden = YES;
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete_click)] autorelease];
		editing = NO;
	}
	[txtVideo resignFirstResponder];
	[txtTitle resignFirstResponder];
	isSaved = YES;
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
	
	if(traceClick != 1) {
		
		if (buttonIndex == 0)
		{
			[self.navigationController popViewControllerAnimated:YES];
		}
		else
		{
			
		}
	}
}

- (void)leftbtn_OnClick {
	
	// lastVisitedFeature defined in startprocess for reloading spring board
	
	if(isSaved) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to go back without saving video?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES", @"NO", nil];
		[errorAlert show];
		return;		
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)btnNext_Click {
	
	[self.view addSubview:imgBack];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Saving\nplease standby" frame:CGRectMake(25, 125 + yAxisForSettingControls, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	loading.hidden = NO;
	[activityView startAnimating];
	
	strCollectionVideo = @"";
	strCollectionVideoTitle = @"";
	collectionAryVideo = [[NSMutableArray alloc]init];
	collectionAryVideoTitle = [[NSMutableArray alloc]init];
	for(int i = 0; i  < [aryVideo count]; i++) {
		
		strCollectionVideo = (strCollectionVideo ==@"")?[aryVideo objectAtIndex:i]:[[strCollectionVideo stringByAppendingString:@","] stringByAppendingString:[aryVideo objectAtIndex:i]];
		
		strCollectionVideoTitle = (strCollectionVideoTitle ==@"")?[aryVideoTitle objectAtIndex:i]:[[strCollectionVideoTitle stringByAppendingString:@","] stringByAppendingString:[aryVideoTitle objectAtIndex:i]];
	}
	[collectionAryVideo addObject:strCollectionVideo];
	[collectionAryVideoTitle addObject:strCollectionVideoTitle];
	NSLog(@"collectionVideo- %@", strCollectionVideo);
	NSLog(@"collectionVideoURL- %@", strCollectionVideoTitle);
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
}

- (void)startProcess {	
	
	[self sendNow:@"managevideos"];
	if([aryVideo count] == 0) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];	
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4UnsocialVideo"];
		//documentsDirectory = [documentsDirectory stringByAppendingString:@"/settingsinfo4UnsocialVideo"];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSLog(@"%@", fileManager);
		if([fileManager fileExistsAtPath:path]) // if all the videos have deleted then file should be deleted and lastVisitedFeature must be reloaded
		{
			[fileManager removeItemAtPath:path error:NULL];	
			// reinitializing lastVisitedFeature for reloading spring board
			[lastVisitedFeature removeAllObjects];
			[lastVisitedFeature addObject:@"videoad"];
		}
	}
	
	
	
	[self.navigationController popViewControllerAnimated:YES];
	isSaved = NO;
}

- (void) updateDataFileOnSave {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	newPerson.userid = [arrayForUserID objectAtIndex:0];
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4UnsocialVideo"];	
	
	//**********************
	// added case for reloading the spring board by pradeep on 10 june 2010
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSLog(@"%@", fileManager);
	if(![fileManager fileExistsAtPath:path]) // if all the videos have deleted then file should be deleted and lastVisitedFeature must be reloaded
	{
		[lastVisitedFeature removeAllObjects];
		[lastVisitedFeature addObject:@"videoad"];
	}
	//**********************
	
	
	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
}

- (BOOL) sendNow: (NSString *) flag {
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",flag];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	//NSString *deviceTocken;
	
	NSString *CollectionVideo = [NSString stringWithFormat:@"%@\r\n",[collectionAryVideo objectAtIndex:0]];
	
	NSString *CollectionVideoTitle = [NSString stringWithFormat:@"%@\r\n",[collectionAryVideoTitle objectAtIndex:0]];
	
	if ([[collectionAryVideo objectAtIndex:0] compare:nil] == NSOrderedSame)
		CollectionVideo = [NSString stringWithFormat:@"%@\r\n",@""];
	else CollectionVideo = [NSString stringWithFormat:@"%@\r\n",strCollectionVideo];
	
	if ([[collectionAryVideoTitle objectAtIndex:0] compare:nil] == NSOrderedSame)
		CollectionVideoTitle = [NSString stringWithFormat:@"%@\r\n",@""];
	else CollectionVideoTitle = [NSString stringWithFormat:@"%@\r\n",strCollectionVideoTitle];
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
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
	
	if ([flag compare:@"managevideos"] == NSOrderedSame)
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"video\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",CollectionVideo] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"videotitle\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",CollectionVideoTitle] dataUsingEncoding:NSUTF8StringEncoding]];
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
		if ([key compare:@"Userid"] == NSOrderedSame)			
		{
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				[self updateDataFileOnSave];
				NSLog(@"\n\n\n\n\n\n#######################-- post for video added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;				
				useridForTable = [dic objectForKey:key];
				break;
			}			
		}		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(returnString);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
	//return;
}

- (void) getVideoForUser:(NSString *)inid {
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
	urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getvideos&userid=%@&datetime=%@", [arrayForUserID objectAtIndex:0], usertime];
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
		videoName = [[NSMutableString alloc] init];
		videoTitleName = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		[item setObject:videoName forKey:@"videourl"]; 
		[item setObject:videoTitleName forKey:@"videottl"]; 
		[stories addObject:[item copy]];

		[aryVideo addObject:videoName];
		[aryVideoTitle addObject:videoTitleName];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"videourl"])
	{
		[videoName appendString:string];
	}
	if ([currentElement isEqualToString:@"videottl"])
	{
		[videoTitleName appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	printf("Did begin editing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	printf("Did end editing\n");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	printf("Clearing Keyboard\n");
    return YES;
}

- (void)viewDidLoad {
}
@end