//
//  SettingsStep4.m
//  Unsocial
//
//  Created by vaibhavsaran on 15/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsAddKeywords.h"
#import "SettingsStep5.h"
#import "SelectIndustryPicker.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "ShowIndustryDetail.h"
#import "SecuritySettings.h"
#import "Person.h"

NSString *localuserid;
BOOL flg4tracesendreq2serverduringback2;

@implementation SettingsAddKeywords
@synthesize userid, keywordName;

- (void)viewWillAppear:(BOOL)animated {
	
	flg4tracesendreq2serverduringback2 = NO;
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
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"signupback.png"];
	[self.view addSubview:imgBack];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"My Metatags" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 40, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	UILabel *subHeading = [UnsocialAppDelegate createLabelControl:@"Enter keywords that define your work." frame:CGRectMake(30, 42, 290, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:subHeading];
	// 13 may 2011 by pradeep //[subHeading release];
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 100, 260, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 400, 260, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	txtKeyword = [UnsocialAppDelegate createTextFieldControl:CGRectMake(30, 65, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter keyword" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeAlphabet returnKey:UIReturnKeyDone];
	txtKeyword.autocapitalizationType = UITextAutocapitalizationTypeNone;
	txtKeyword.autocorrectionType = UITextAutocorrectionTypeNo;
	txtKeyword.backgroundColor = [UIColor clearColor];
	[txtKeyword setDelegate:self];
	[self.view addSubview:txtKeyword];
	
	/*UIButton *btnSetKeyword = [UnsocialAppDelegate createButtonControl:@"+" target:self selector:@selector(btnSetKeyword_Click) frame:CGRectMake(256, 65, 33, 29) imageStateNormal:@"squarebutton1.png" imageStateHighlighted:@"squarebutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor lightGrayColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnSetKeyword.titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
	[self.view addSubview:btnSetKeyword];
	
	[txtKeyword release];
	[btnSetKeyword release];*/
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"Saving..." frame:CGRectMake(100, 380, 280, 20) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];*/
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 210, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	activityView.hidden = YES;
	[activityView stopAnimating];
	
	itemTableView.hidden = NO;
	
	lblNoKeyword = [UnsocialAppDelegate createLabelControl:@"Please use keywords to define you and your company – for example web design, cars, professional services etc." frame:CGRectMake(30, 180, 260, 100) txtAlignment:UITextAlignmentCenter numberoflines:4 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	lblNoKeyword.hidden = YES;
	[self.view addSubview:lblNoKeyword];
	
	if (!itemTableView)
	{
		[self getKeywordsForUser:@""];
		NSArray *copy = [aryKeyword copy];
		NSInteger index = [copy count] - 1;
		for (id object in [copy reverseObjectEnumerator]) {
			if ([aryKeyword indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
				[aryKeyword removeObjectAtIndex:index];
			}
			index--;
		}
		[copy release];
	}
	
	if([aryKeyword count] > 0)
	{
		if (!itemTableView)
		{
			itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 105, 260, 290) style:UITableViewStylePlain];
			itemTableView.delegate = self;
			itemTableView.dataSource = self;
			itemTableView.rowHeight = 30;
			itemTableView.backgroundColor = [UIColor clearColor];
			[self.view addSubview:itemTableView];
		}
		else {
			[itemTableView reloadData];
			[self.view addSubview:itemTableView];
		}

		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete_click)] autorelease];
		editing = NO; // fal for deletion
		lblNoKeyword.hidden = YES;
	}
	else
	{
		lblNoKeyword.hidden = NO;
	}
	NSLog(@"aryKeyword- %d", [aryKeyword count]);

	/*btnSave = [UnsocialAppDelegate createButtonControl:@"Save" target:self selector:@selector(btnNext_Click) frame:CGRectMake(128, 380, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSave];
	[btnSave release];*/
}

- (void) updateDataFileOnSave:(NSString *)uid:(NSString *)str {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	newPerson.strsetkeywords = str;
	newPerson.userid = uid;
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4metatags"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];    
    // Set up the cell...
	//+ method from Delegate
	CGRect lableTtlFrame = CGRectMake(5.00, 3.00, 250, 20);
	
	lblKeywordName = [UnsocialAppDelegate createLabelControl:[aryKeyword objectAtIndex:indexPath.row] frame:lableTtlFrame txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblKeywordName];

	itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	NSLog(@"kw- ", [aryKeyword objectAtIndex:indexPath.row]);
	cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [aryKeyword count];
	//return [stories count];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		flg4tracesendreq2serverduringback2 = YES;
		// Delete the row from the data source
		[aryKeyword removeObjectAtIndex:indexPath.row];
		
		[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		if([aryKeyword count] == 0) {
			
			itemTableView.hidden = YES;
			lblNoKeyword.hidden = NO;
			self.navigationItem.leftBarButtonItem.enabled = YES;
			self.navigationItem.rightBarButtonItem.enabled = NO;
			[itemTableView setEditing:NO animated:YES];	
			editing = NO;
			isSaved = YES;
		}
		else 	lblNoKeyword.hidden = YES;
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
	
		// Insert the row from the data source
		[aryKeyword addObject:txtKeyword.text];
	}   
}

- (void)delete_click {
	//Do not let the user add if the app is in edit mode.
	flg4tracesendreq2serverduringback2 = YES;
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

- (void)btnSetKeyword_Click {
	
	[UnsocialAppDelegate playClick];
	if([txtKeyword.text length] > 40) {
		
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Keyword can't be more than 40 of length." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		traceClick = 1;
		return;
	}
	
	NSString *trimmedString= txtKeyword.text;
	trimmedString= [trimmedString lowercaseString];
	trimmedString = [trimmedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // trim
	NSArray *arr = [trimmedString componentsSeparatedByString:@","];
	
	if(([trimmedString compare:nil] == NSOrderedSame) || ([trimmedString compare:@""] == NSOrderedSame)) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter keyword." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		traceClick = 1;
		return;
	}
	else if ([arr count] > 1) {

		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Comma is not allowed in keywords." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		traceClick = 1;
		return;
	}
	
	for (int i = 0; i < [aryKeyword count]; i++) {

		if([trimmedString compare:[aryKeyword objectAtIndex:i]] == NSOrderedSame) {
			printf("Repeated\n");
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Keyword already exists." message:trimmedString delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			[errorAlert show];
			[errorAlert release];
			traceClick = 1;
			return;
		}
	}

	trimmedString = [trimmedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	[aryKeyword addObject:trimmedString];
 
	if(!itemTableView) {
		
		itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 105, 260, 290) style:UITableViewStylePlain];
		itemTableView.delegate = self;
		itemTableView.dataSource = self;
		itemTableView.rowHeight = 30;
		itemTableView.backgroundColor = [UIColor clearColor];
	}
	itemTableView.hidden = NO;
	[itemTableView reloadData];
	[self.view addSubview:itemTableView];

	txtKeyword.text = @"";
	if([aryKeyword count] > 0) {
		lblNoKeyword.hidden = YES;
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete_click)] autorelease];
		editing = NO;
	}
	[txtKeyword resignFirstResponder];
	lblNoKeyword.hidden = YES;
	isSaved = YES;
}

- (void)leftbtn_OnClick {
	
	/*if(isSaved) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to go back without saving keywords?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES", @"NO", nil];
		[errorAlert show];
		return;		
	}*/
	if (flg4tracesendreq2serverduringback2)
	[self btnNext_Click];
	[self.navigationController popViewControllerAnimated:YES];
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

- (void)btnNext_Click {
	
	[UnsocialAppDelegate playClick];
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(180, 380, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Saving..." frame:CGRectMake(100, 380, 280, 20) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	loading.hidden = NO;
	btnSave.hidden = YES;
	[activityView startAnimating];
	
	strCollectionKeywords = @"";
	collectionAryKeywords = [[NSMutableArray alloc]init];
	for(int i = 0; i  < [aryKeyword count]; i++)
	{
		strCollectionKeywords = (strCollectionKeywords ==@"")?[aryKeyword objectAtIndex:i]:[[strCollectionKeywords stringByAppendingString:@","] stringByAppendingString:[aryKeyword objectAtIndex:i]];
	}
	[collectionAryKeywords addObject:strCollectionKeywords];
	NSLog(@"collectionIndustry1- %@", strCollectionKeywords);
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
}

- (void)startProcess {	
	[self sendNow:@"managekeywords"];
	[self.navigationController popViewControllerAnimated:YES];
	isSaved = NO;
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
	
	NSString *CollectionKeywords = [NSString stringWithFormat:@"%@\r\n",[collectionAryKeywords objectAtIndex:0]];
	
	if ([[collectionAryKeywords objectAtIndex:0] compare:nil] == NSOrderedSame)
		CollectionKeywords = [NSString stringWithFormat:@"%@\r\n",@""];
	else CollectionKeywords = [NSString stringWithFormat:@"%@\r\n",strCollectionKeywords];
	
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
	
	if ([flag compare:@"managekeywords"] == NSOrderedSame)
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"keywords\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",CollectionKeywords] dataUsingEncoding:NSUTF8StringEncoding]];
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
		[self updateDataFileOnSave:[dic objectForKey:key]:CollectionKeywords];
		if ([key isEqualToString:@"Userid"])			
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				[self updateDataFileOnSave:[dic objectForKey:key]:CollectionKeywords];
				NSLog(@"\n\n\n\n\n\n#######################-- post for keywords added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;				
				useridForTable = [dic objectForKey:key];
				break;
			}			
		}		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
	//return;
}

- (void) getKeywordsForUser:(NSString *)inid {
	
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
	urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getkeywords&userid=%@&datetime=%@", [arrayForUserID objectAtIndex:0], usertime];
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
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"])
	{
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		keywordName = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		[item setObject:keywordName forKey:@"keywords"]; 
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);

		NSLog(@"adding story keywordName: %@", keywordName);
		[aryKeyword addObject:keywordName];
		NSLog(@"aryKeyword has %d itmes", [aryKeyword count]);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"keywords"])
	{
		[keywordName appendString:string];
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
	
	// added by pradeep on 29 june 2011
	//itemTableView.delegate = nil;
	// end 29 june 2011
	
	[super dealloc];
	// 13 may 2011 by pradeep //[lblNoKeyword release];	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	printf("Did begin editing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	printf("Did end editing\n");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	[self btnSetKeyword_Click];
	flg4tracesendreq2serverduringback2 = YES;
	printf("Clearing Keyboard\n");
    return YES;
}

- (void)viewDidLoad {
}

@end
