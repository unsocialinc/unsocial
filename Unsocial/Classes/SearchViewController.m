//
//  SearchViewController.m
//  Unsocial
//
//  Created by santosh khare on 5/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"

BOOL alreadysearch;

@implementation SearchViewController
@synthesize puserid, searchkey;

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
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	//****************************
	// commented by pradeep on 12 nov 2010 for search improvement request
	/*UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;*/
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightbtn_OnClick)] autorelease];
	//******************************
	
	/*mySearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 35)] autorelease];
	mySearchBar.delegate = self;
	mySearchBar.tintColor = [UIColor blackColor];
	mySearchBar.barStyle = UIBarStyleBlackOpaque;
	mySearchBar.showsCancelButton = YES;
	
		// note: here you can also change its "tintColor" property to a different UIColor
	
	[self.view addSubview:mySearchBar];*/
	 
	 
	/*mySearchBar = [UnsocialAppDelegate createTextFieldControl:CGRectMake(10, 5, 300, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter search criteria" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeAlphabet returnKey:UIReturnKeySearch];
	mySearchBar.backgroundColor = [UIColor clearColor];
	mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	[mySearchBar setDelegate:self];	
		
	/*btnSettags = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnSearch_Click) frame:CGRectMake(255, 2, 40, 40) imageStateNormal:@"peoplesearch.png" imageStateHighlighted:@"peoplesearch2.png" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnSettags.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
	[self.view addSubview:btnSettags];
	[self.view addSubview:mySearchBar];*/
	
	[self btnSearch_Click];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	activityView.hidden = YES;
	[activityView stopAnimating];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Searched People" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	itemTableView.hidden = NO;
	
	if (alreadysearch)
	{
		//mySearchBar.text = [searchtxt objectAtIndex:0];
		if (!itemTableView)
		{
			itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, 330) style:UITableViewStylePlain];
			itemTableView.delegate = self;
			itemTableView.dataSource = self;
			itemTableView.rowHeight = 115;
			itemTableView.backgroundColor = [UIColor clearColor];
			itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
			[self.view addSubview:itemTableView];
			itemTableView.hidden=NO;
		}
		else
		{
			[itemTableView reloadData];
			[self.view addSubview:itemTableView];
			itemTableView.hidden=NO;
		}
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	printf("Did begin editing\n");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	printf("Did end editing\n");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	[self btnSearch_Click];
	printf("Clearing Keyboard\n");
    return YES;
}
#pragma mark -
#pragma mark UISearchBarDelegate

	// called when keyboard search button pressed
/*- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[mySearchBar resignFirstResponder];
	[self btnSearch_Click];
}

	// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[mySearchBar resignFirstResponder];
}*/

- (void)btnSearch_Click {
	
	/*if(([mySearchBar.text compare:nil] == NSOrderedSame) || ([mySearchBar.text compare:@""] == NSOrderedSame))	{
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter desired search criteria" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		return;
	}*/
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	loading = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 210, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	
	alreadysearch=TRUE;
		//[mySearchBar resignFirstResponder];	
	
	//searchtxt = [[NSMutableArray alloc] init];
	//[searchtxt addObject:mySearchBar.text];
	
	[self.view addSubview:imgBack];
	[self.view addSubview:loading];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	loading.hidden = NO;
	[activityView startAnimating];
	
	[self.view addSubview:imgTBBack];
	[self.view addSubview:mySearchBar];
	[self.view addSubview:btnSettags];

	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
	
}

- (void)startProcess {
	NSLog(@"refreshing the data");
	
	[self getDataFromFile];
	{
		[stories removeAllObjects];//= nil;
		[self getPeopleData:@"search"];
		if ([stories count] == 0)
		{
			// if no records found
			
			CGRect lableRecNotFrame = CGRectMake(10, 200, 300, 60);
			
			// commneted by pradeep on 17 august 2011 for fixing memory issue for retailed object
			//recnotfound = [[UILabel alloc] init];
			
			recnotfound = [UnsocialAppDelegate createLabelControl:@"There are currently no profiles that match your requested tags." frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];	
						
			recnotfound.hidden = NO;
			[self.view addSubview:recnotfound];
			// 13 may 2011 by pradeep //[recnotfound release];
			itemTableView.hidden=YES;
		}
		else 
		{
			if (!itemTableView)
			{
				itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 370) style:UITableViewStylePlain];
				itemTableView.delegate = self;
				itemTableView.dataSource = self;
				itemTableView.rowHeight = 115;
				itemTableView.backgroundColor = [UIColor clearColor];
				itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
				[self.view addSubview:itemTableView];
				itemTableView.hidden=NO;
			}
			else
			{
				[itemTableView reloadData];
				[self.view addSubview:itemTableView];
				itemTableView.hidden=NO;
			}
		}
	}	
	loading.hidden = YES;
	imgForOverlap.hidden = YES;
	[activityView stopAnimating];
}

// aaded by pradeep for adding search tag to user's auto taging table on 25 nov 2010
//**************

- (BOOL) addSearchTagAsUsersAutoTag: (NSString *) flag {
	NSLog(@"Sending addSearchTagAsUsersAutoTag....");
	
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
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"smarttagging"]; // here is the diffrence between normal adding tags and adding smart tags (in case of adding normal tags flag2=aaa, and smart tagging flag2=smarttagging
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	//NSString *deviceTocken;
	
	NSString *CollectionTags = [NSString stringWithFormat:@"%@\r\n",searchkey];
	
	/*if ([[strCollectionTags objectAtIndex:0] compare:nil] == NSOrderedSame)
	 CollectionTags = [NSString stringWithFormat:@"%@\r\n",@""];
	 else CollectionTags = [NSString stringWithFormat:@"%@\r\n",strCollectionTags];*/
	
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
	
	if ([flag compare:@"managetags"] == NSOrderedSame)
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"tags\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",CollectionTags] dataUsingEncoding:NSUTF8StringEncoding]];
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
				NSLog(@"\n\n\n\n\n\n#######################-- post for tags added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;				
				//useridForTable = [dic objectForKey:key];
				
				UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Tags added successfully to your “interested in” tags list!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
				
				[alertOnChoose show];
				[alertOnChoose release];
				
				
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

//**************


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stories count];
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
	lblStatus = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(89, 75, 215, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	lblStatus.text = [[stories objectAtIndex:indexPath.row] objectForKey:@"status"];
	[cell.contentView addSubview:lblStatus];
	
	/*UIImage *imageforresize = [[stories  objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	
	// commented by pradeep on 11 august for fixing different image layout
	CGImageRef realImage = imageforresize.CGImage;
	float realHeight = CGImageGetHeight(realImage);
	float realWidth = CGImageGetWidth(realImage);
	// commented by pradeep on 11 august for fixing different image layout
	float ratio = realHeight/realWidth;
	float modifiedWidth, modifiedHeight;
	// commented by pradeep on 11 august for fixing different image layout
	if(ratio < 1) {
		
		modifiedWidth = 75;
		modifiedHeight = modifiedWidth*ratio;
	}
	else {
		
		modifiedHeight = 75;
		modifiedWidth = modifiedHeight/ratio;
	}
	
	CGRect imageRect = CGRectMake(9, 11, modifiedWidth, modifiedHeight );*/
	
	// commented by pradeep on 17 sep 2010 for lazy img feature
	//*********************
	/*CGRect imageRect = CGRectMake(9, 11, 75, 75 );
	
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
	
	CGRect lableNameFrame = CGRectMake(89, 4, 314, 18);	
	lblUserName = [UnsocialAppDelegate createLabelControl:usrname frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblUserName];
	
		// starts 14 Jun for linkedin user identification - v1.8vaibhav  
	NSString *prefix = [[stories objectAtIndex:indexPath.row] objectForKey:@"prefix"];
	
	NSString *firstLevel = [[stories objectAtIndex:indexPath.row] objectForKey:@"level"];
		//ends
	
	NSString *displayitem = [[stories objectAtIndex:indexPath.row] objectForKey:@"displayitem"];
	NSString *isindustryshow = [[displayitem substringFromIndex:1] substringToIndex:1];
	NSString *iscompanyshow = [[displayitem substringFromIndex:2] substringToIndex:1];
	
	UILabel *lblcompany = [UnsocialAppDelegate createLabelControl:@"Company: " frame:CGRectMake(lableNameFrame.origin.x, 27, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblcompany];
	
	UILabel *lblindustry = [UnsocialAppDelegate createLabelControl:@"Industry: " frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 16, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblindustry];
	
	UILabel *lblfunction = [UnsocialAppDelegate createLabelControl:@"Function:" frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 32, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblfunction];
	
	// for company **** start ****
	// if company is set as private then it will be as 1 else 0
	CGRect lableCompanyFrame = CGRectMake(152, lblcompany.frame.origin.y, 140, 15);		
	lblCompanyName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"company"] frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	
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
	
	lblIndustryName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"industry"] frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	
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
	lblFunctionName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"role"] frame:lableRoleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	
	if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"role"] compare:@""] == NSOrderedSame)
		lblFunctionName.text = @"not set";
	
	[cell.contentView addSubview:lblFunctionName];
	// 13 may 2011 by pradeep //[lblFunctionName release];
	
	// for role *****end **********
	
	// for distance ******start*******		
	CGRect lableDistanceFrame = CGRectMake(212, lableNameFrame.origin.y, 100, 18);
	lblUserName = [UnsocialAppDelegate createLabelControl:@"" frame:lableDistanceFrame txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	
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
	//***************************************** latest code end according to new design written by Pradeep on 24 july 2010
	
	
	
	
    // Set up the cell...
	//+ method from Delegate
	//CGRect lableTtlFrame = CGRectMake(2, 2, 100, 66 );
	//userImage = [UnsocialAppDelegate createImageViewControl:lableTtlFrame imageName:[[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"]];
	
	// for selecting segment controle's index	
	//use in future
	//********************************************************************
	// for aroundme tab by using stories4peoplearoundme
	//if (segmentedControl.selectedSegmentIndex==0)
	
	
	
	//*********************** comment start
	//commented by pradeep on 24 july 2010 for changing the search people according to new design
	/*{
	 UIImage *imageforresize = [[stories  objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	 CGImageRef realImage = imageforresize.CGImage;
	 float realHeight = CGImageGetHeight(realImage);
	 float realWidth = CGImageGetWidth(realImage);
	 float ratio = realHeight/realWidth;
	 float modifiedWidth = 60/ratio;
	 
	 CGRect imageRect = CGRectMake(3, 20, modifiedWidth + 15, 75 );
	 
	 UIImageView *usrImage = [[UIImageView alloc] initWithFrame:imageRect];
	 usrImage.image = [[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	 [cell.contentView addSubview:usrImage];
	 [usrImage release];
	 [cell.contentView addSubview:usrImage];
	 cell.selectionStyle = UITableViewCellSelectionStyleNone;
	 
	 UIImageView *userImageOver = [[UIImageView alloc] initWithFrame:imageRect];
	 userImageOver.image = [UIImage imageNamed:@"ovrlay.png"];
	 [cell.contentView addSubview:userImageOver];
	 [userImageOver release];
	 
	 CGRect lableNameFrame = CGRectMake(3, 1, 314, 18);
	 
	 lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"username"] frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor darkGrayColor]];
	 [cell.contentView addSubview:lblUserName];
	 
	 NSString *displayitem = [[stories objectAtIndex:indexPath.row] objectForKey:@"displayitem"];
	 //NSString *isemailshow = [[displayitem substringFromIndex:0] substringToIndex:1];
	 NSString *isindustryshow = [[displayitem substringFromIndex:1] substringToIndex:1];
	 NSString *iscompanyshow = [[displayitem substringFromIndex:2] substringToIndex:1];
	 //NSString *iscontactshow = [[displayitem substringFromIndex:3] substringToIndex:1];
	 
	 // for company **** start ****
	 // if company is set as private then it will be as 1 else 0
	 if ([iscompanyshow compare:@"0"] != NSOrderedSame) // company is private i.e. 1
	 {
	 CGRect lableCompanyFrame = CGRectMake(110, 22.0+20, 55, 15);
	 
	 lblUserName = [UnsocialAppDelegate createLabelControl:@"Company:" frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];	
	 [cell.contentView addSubview:lblUserName];
	 
	 CGRect lableLockFrame = CGRectMake(160, 22.0+20, 15, 15);
	 userImage = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
	 [cell.contentView addSubview:userImage];
	 }
	 else {
	 CGRect lableCompanyFrame = CGRectMake(110, 22.0+20, 240, 15);
	 
	 lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"company"] frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];	
	 
	 if ([lblUserName.text compare:@""] == NSOrderedSame)
	 lblUserName = [UnsocialAppDelegate createLabelControl:@"Company: not set" frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:10 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	 else {
	 lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"company"] frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	 }
	 
	 
	 [cell.contentView addSubview:lblUserName];
	 }
	 // for company **** end ****
	 
	 // if industry is set as private then it will be as 1 else 0
	 if ([isindustryshow compare:@"0"] != NSOrderedSame) // industry is private i.e. 1
	 {
	 CGRect lableIndustryFrame = CGRectMake(110, 38.0+20, 195, 15);
	 
	 lblUserName = [UnsocialAppDelegate createLabelControl:@"Industry:" frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];	
	 [cell.contentView addSubview:lblUserName];
	 
	 CGRect lableLockFrame = CGRectMake(160, 38.0+20, 15, 15);
	 userImage = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
	 [cell.contentView addSubview:userImage];
	 }
	 else {
	 CGRect lableIndustryFrame = CGRectMake(110, 38.0+20, 195, 15);
	 
	 lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"industry"] frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];	
	 
	 if ([lblUserName.text compare:@""] == NSOrderedSame)
	 lblUserName = [UnsocialAppDelegate createLabelControl:@"Industry: not set" frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	 else {
	 lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"industry"] frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	 }
	 
	 
	 [cell.contentView addSubview:lblUserName];
	 }
	 // for Industry **** end ****
	 
	 //for role ****start**********
	 
	 CGRect lableRoleFrame = CGRectMake(110, 54.0+20, 195, 15);
	 //NSString *looking4 = @"looking for";
	 //looking4 = [looking4
	 lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"role"] frame:lableRoleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blueColor] backgroundcolor:[UIColor clearColor]];	
	 
	 if ([lblUserName.text compare:@""] == NSOrderedSame)
	 lblUserName = [UnsocialAppDelegate createLabelControl:@"Role: not set" frame:lableRoleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	 
	 [cell.contentView addSubview:lblUserName];
	 
	 
	 // for role *****end **********
	 
	 // for distance ******start*******
	 
	 CGRect lableDistanceFrame = CGRectMake(217, 1, 100, 18);
	 lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"] frame:lableDistanceFrame txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor darkGrayColor]];	
	 [cell.contentView addSubview:lblUserName];		
	 } // close if for aroundme
	 cell.backgroundColor = [UIColor whiteColor];	
	 return cell;*/
	
	//*********************** comment end
	//commented by pradeep on 24 july 2010 for changing the search people according to new design
	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	PeoplesUserProfile *peoplesUserProfile = [[PeoplesUserProfile alloc]init];
	peoplesUserProfile.myname  = [myName objectAtIndex:0];
	
	// for aroundme tab by using stories
	//if (segmentedControl.selectedSegmentIndex==0)
	{
		peoplesUserProfile.userid = [[stories objectAtIndex:indexPath.row] objectForKey:@"guid"];			
		peoplesUserProfile.username = [[stories objectAtIndex:indexPath.row] objectForKey:@"username"];
		peoplesUserProfile.userprefix = [[stories objectAtIndex:indexPath.row] objectForKey:@"prefix"];
						
		// commented by pradeep on 7 feb 2011
		//peoplesUserProfile.useremail = [[stories objectAtIndex:indexPath.row] objectForKey:@"email"]; 
		// added by vaibhav for fixing issue linkedin uid is displaying in place of email
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
		peoplesUserProfile.userintsubind = [[stories objectAtIndex:indexPath.row] objectForKey:@"interestsubind"];	
		peoplesUserProfile.userintrole = [[stories objectAtIndex:indexPath.row] objectForKey:@"interestrole"];
		peoplesUserProfile.userdisplayitem = [[stories objectAtIndex:indexPath.row] objectForKey:@"displayitem"];	
		peoplesUserProfile.userintind = [[stories objectAtIndex:indexPath.row] objectForKey:@"interestind"];
		peoplesUserProfile.fullImg = [[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		
		//******************** for lazi img start
		
		//NSURL *url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
		//[aryEventDetails addObject:[imageURLs4Lazy objectAtIndex:indexPath.row]];
		peoplesUserProfile.imgurl = [imageURLs4Lazy objectAtIndex:indexPath.row];
		peoplesUserProfile.camefromwhichoption = @"searchpeople";
		
		//******************** for lazi img end		
		
		peoplesUserProfile.profileforwhichtab = [[stories objectAtIndex:indexPath.row] objectForKey:@"forwhichtab"];
		peoplesUserProfile.strdistance = [[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"];
	}
	
	[self.navigationController pushViewController:peoplesUserProfile animated:YES];
}

- (void) getPeopleData:(NSString *) flg4whichtab { // here flg4whichtab = search
	
	//NSString *searchfield = searchkey; //mySearchBar.text;//[NSString stringWithFormat:@"%@\r\n",mySearchBar.text];
	
	// ****** for checking and triming whitespaces from search item added by pradeep on 24 nov 2010
	
	NSString *searchtext = searchkey;
	NSString *searchfield = [searchtext stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	if ([searchfield compare:@""]==NSOrderedSame) 
	{
		NSString * errorString = [NSString stringWithFormat:@"Please enter valid tag for search."];
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Invalid tag" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		loading.hidden = YES;
		imgForOverlap.hidden = YES;
		[activityView stopAnimating];
		return;
	}
	
	// since blank space etc occurs problem in sending request to perticular url
	// here eventsubflg contains search keyword entered by user during searching events added by pradeep on 26 nov 2010
	searchfield = [searchfield stringByReplacingOccurrencesOfString:@" " withString:@"$0M"]; 
	
	
	// *******
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	// Time Formats
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	//NSString *searchfield = searchkey; //mySearchBar.text;//[NSString stringWithFormat:@"%@\r\n",mySearchBar.text];
	
	//[collectionindustry stringByAppendingString:@","] stringByAppendingString:[interestedIndustryIds1 objectAtIndex:i]
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	//NSString *distance = @"1"; // it should be retrieved from file that contains the set value
	
	// retreiving HH:MM from HH:MM:SS using substring
	//usertime = [[usertime substringFromIndex:0] substringToIndex:5];
	
	if ( [gbluserid compare:@""] == NSOrderedSame || !gbluserid)
		gbluserid = @"none";
	
	NSLog(@"Sending....");
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&distance=%@&flag2=%@",@"getpeople",gbllatitude,gbllongitude,gbluserid,usertime,searchfield,flg4whichtab]; // NOTE: here searchfield is placed with discatncemiles field from other people criteria
	
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

- (BOOL) getDataFromFile {
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
		
		myName = [[NSMutableArray alloc]init];
		[myName addObject:[[tempArray objectAtIndex:0] username]];
		
		/*pusername = [[tempArray objectAtIndex:0] username];
		 puserprefix = [[tempArray objectAtIndex:0] userprefix];
		 puserid = [[tempArray objectAtIndex:0] userid];
		 puseremail = [[tempArray objectAtIndex:0] useremail];
		 puserind = [[tempArray objectAtIndex:0] userind];
		 pusersubind = [[tempArray objectAtIndex:0] usersubind];
		 puserrole = [[tempArray objectAtIndex:0] userrole];		
		 puserindid = [[tempArray objectAtIndex:0] userindid];
		 pusersubindid = [[tempArray objectAtIndex:0] usersubindid];
		 puserroleid = [[tempArray objectAtIndex:0] userroleid];*/
		
		//for setting global variables
		NSLog(@"%@", [[tempArray objectAtIndex:0] userid]);
		gbluserid = [[tempArray objectAtIndex:0] userid];
		//arrayForUserID = [[NSMutableArray alloc]init];
		if ([arrayForUserID count]==0)
			[arrayForUserID addObject:[[tempArray objectAtIndex:0] userid]];
		
		[decoder finishDecoding];
		[decoder release];	
		
		//if ( [username compare:@""] == NSOrderedSame || !username)
		if ( [puserid compare:@""] == NSOrderedSame || !puserid)
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
	// commented by pradeep on 24 nov 2010 for user friendly error message
	//NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down"];
	NSString * errorString = [NSString stringWithFormat:@"Please enter valid tag for search."];
	NSLog(@"error parsing XML: %@", errorString);	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Invalid tag" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"ttl"])
	{
		//item4whichtab = [[NSMutableDictionary alloc]init];
		//userforwhichtab = [[NSMutableString alloc]init];
	}
	
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
		usertitle = [[NSMutableString alloc]init];
		userlevel = [[NSMutableString alloc]init];
	}
	if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//if ([elementName isEqualToString:@"ttl"])
	//	[item4whichtab setObject:userforwhichtab forKey:@"whichtab"];
	
	
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
		/*if ([userforwhichtab compare:@"everyone"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==0)
			[stories4peoplearoundme addObject:[item copy]];
		else if ([userforwhichtab compare:@"myinterest"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==1)
			[stories4peoplemyinterest addObject:[item copy]];
		else if ([userforwhichtab compare:@"bookmark"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==2)
			[stories4peoplebookmark addObject:[item copy]];*/
		NSLog(@"adding story: %@", username);		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"ttl"]) 
	{
		//	[userforwhichtab appendString:string];
		
		
		//whichsegmentselectedlasttime4tag = 0;
	}
	
	else if ([currentElement isEqualToString:@"prefix"]) {
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
	loading.hidden = YES;
	[activityView stopAnimating];
}

- (void)leftbtn_OnClick {
	
	// commented on 24 july 2010 by pradeep since search will open directly from springboard now
	//[self.navigationController popViewControllerAnimated:YES];
	
	// commented by pradeep on 12 nov 2010 for search improvement	
	//[self dismissModalViewControllerAnimated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) rightbtn_OnClick
{
	UIAlertView *alertOnChoose;
	
	alertOnChoose = [[UIAlertView alloc] initWithTitle:@"Adding following tags to your “interested in” tags list!" message:searchkey delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO", @"YES", nil];
	
	[alertOnChoose show];
	[alertOnChoose release];	
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
	
	if(buttonIndex == 0){
	}
	else {
		
		[self addSearchTagAsUsersAutoTag:@"managetags"];
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
	
	// added by pradeep on 29 june 2011
	//itemTableView.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
}


@end
