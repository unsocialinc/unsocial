	//
	//  Peoples.m
	//  Unsocial
	//
	//  Created by vaibhavsaran on 15/04/10.
	//  Copyright 2010 __MyCompanyName__. All rights reserved.
	//

#import "Peoples.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"
#import "PeopleEventSetDistance.h"
#import "Person.h"
#import "AddTags.h"

int flg4segmentctrl;
NSString *localuserid, *localdistance;
int whichsegmentselectedlasttime;
BOOL aroundme, myinterest, bookmark;

@implementation Peoples

@synthesize pusername, puserid, puserind, pusersubind, puserrole, puserindid, pusersubindid, puserroleid, puserprefix, puseremail;
@synthesize activityView, TSImageView, comingfrom;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
		// for disappearing activityvew at the header
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(createControls) userInfo:self.view repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	
	WhereIam = 0;
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	UINavigationItem *itemNV = self.navigationItem;
		//add background color
	self.view.backgroundColor = color;
	
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
	
	// added by pradeep on 19 may 2011
	[leftbtn release];
	[leftcbtnitme release];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTable_Click)] autorelease];
		//self.navigationItem.rightBarButtonItem.enabled = FALSE;
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	[imgHeadview release];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	NSArray *segmentTextContent = [NSArray arrayWithObjects: @"ALL",@"RECENT",@"SAVED", nil]; // RECENT is using all the objects earlier used for tagged // AUTO is same as AUTO TAGGED
	segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.frame = CGRectMake(20, 5, 280, 35);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;	
	segmentedControl.tintColor = [UIColor colorWithRed:240/255.0 green:141/255.0 blue:60/255.0 alpha:1.0];
	[self.view addSubview:segmentedControl];
	[segmentedControl release];
	
	imgForOverlap = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgForOverlap.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgForOverlap];
	[imgForOverlap release];
	
	// commneted and added by pradeep on 4 august 2011 for fixing memory issue for retailed object
	//loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial \nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	loading = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Searching unsocial \nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 3 august 2011
	
	
	loading.hidden = NO;
	imgForOverlap.hidden = NO;
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	
	recnotfound.hidden = YES;
	
		// added by pradeep on 24 july 2010 for adding refresh btn neighbour of segment ctrl
		//*******************************
	
	/*imgRefresh = [[UIImageView alloc]initWithFrame:CGRectMake(282, 5, 35, 35)];
	 imgRefresh.image = [UIImage imageNamed:@"refresh.png"];
	 [self.view addSubview:imgRefresh];
	 
	 btnReload = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(reloadTable_Click) frame:CGRectMake(290, 5, 35, 35) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:@"" TextColorHighlighted:@"" showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	 
	 //btnReload.backgroundColor = [UIColor redColor];
	 [self.view addSubview:btnReload];*/
		//******************************
}

- (BOOL) getDataFromFile4Tags {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4tags"];
	NSString *strusertags = @"";
	BOOL returnresult = NO;
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
		
		
		strusertags = [[tempArray objectAtIndex:0] strsettags];
		
		[decoder finishDecoding];
		[decoder release];
		if ([strusertags compare:@""] == NSOrderedSame || [strusertags compare:@""] == NSOrderedSame) 
			;
		else returnresult = YES;	
	}
	/*else {
	 
	 return NO;
	 }*/
	return returnresult;
}

-(void) addTags_OnClick
{
	AddTags *viewcontroller = [[AddTags alloc]init];
		//peopleEventSetDistance.peopleOrEvent = 2;
		//peopleEventSetDistance.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[[self navigationController] pushViewController:viewcontroller animated:YES];
	[viewcontroller release];
}

- (void)leftbtn_OnClick { 
	
	/*[lastVisitedFeature removeAllObjects];
	 [lastVisitedFeature addObject:@"people"];
	 [self dismissModalViewControllerAnimated:YES];*/
		//[self.navigationController popViewControllerAnimated:YES];
	
	[lastVisitedFeature removeAllObjects];
	[lastVisitedFeature addObject:@"people"];
	
	if(comingfrom != 1)
	{
			// added by pradeep on 5 oct 2010 for fixing bug when clicking on refresh btn it shows wrong images in the list
		[imageURLs4Lazyall removeAllObjects];
		[imageURLs4Lazyauto removeAllObjects];
		[imageURLs4Lazysaved removeAllObjects];
		[self dismissModalViewControllerAnimated:YES];
	}
	else {
		
		comingfrom = 0;
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)reloadTable_Click {
	
	[self.view addSubview:imgBack]; 
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	[self.view addSubview:loading];
	loading.hidden = NO;
	[activityView startAnimating];
	
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
}

- (void)startProcess {
	NSLog(@"refreshing the data");
	
	[self getDataFromFile];
	[self getDataFromFile4PeopleDistance];
		//[self getPeopleData:@"notset"];
	if (segmentedControl.selectedSegmentIndex==0)
	{
		[stories4peoplearoundme removeAllObjects];//= nil;
												  //stories4peoplearoundme=[[NSMutableArray alloc]init];
												  // added by pradeep on 5 oct 2010 for fixing bug when clicking on refresh btn it shows wrong images in the list
		[imageURLs4Lazyall removeAllObjects];
		[self getPeopleData:@"everyone"];
		if ([stories4peoplearoundme count] == 0)
		{
				// if no records found8
			
			CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
			
			// commneted and added by pradeep on 4 august 2011 for fixing memory issue for retailed object
			//recnotfound = [[UILabel alloc] init];
			// end 4 august 2011 since uilabel allocated twice
			
			// commneted and added by pradeep on 3 august 2011 for fixing memory issue for retailed object
			//recnotfound = [UnsocialAppDelegate createLabelControl:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			// end 3 august 2011
			
			recnotfound.hidden = NO;
			[self.view addSubview:recnotfound];
			// 13 may 2011 by pradeep //[recnotfound release];
			itemTableView.hidden=YES;
				//the system in past four hours in your proximity
		}
		else 
		{
			if (!itemTableView)
			{
				itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 370) style:UITableViewStylePlain];
				itemTableView.delegate = self;
				itemTableView.dataSource = self;
				itemTableView.rowHeight = 115;
				itemTableView.backgroundColor = [UIColor whiteColor];
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
	/*else if (segmentedControl.selectedSegmentIndex==1)
	{
		[stories4peoplemyinterest  removeAllObjects];//= nil;
													 //stories4peoplemyinterest==[[NSMutableArray alloc]init];
													 // added by pradeep on 5 oct 2010 for fixing bug when clicking on refresh btn it shows wrong images in the list
		[imageURLs4Lazyauto removeAllObjects];
		[self getPeopleData:@"autotagged"];
		if ([stories4peoplemyinterest count] == 0)
		{
				// if no records found
			
			CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
			recnotfound = [[UILabel alloc] init];
			recnotfound.hidden = NO;
			BOOL istagsexist = [self getDataFromFile4Tags];
			NSString *strnorecfound = @"";
			
			if (istagsexist)
				strnorecfound = @"There are currently no profiles that matches your requested tags.";
			else strnorecfound = @"For Auto tagging to work please add tags using the button below.";
			recnotfound = [UnsocialAppDelegate createLabelControl:strnorecfound frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];		
			[self.view addSubview:recnotfound];
			[recnotfound release];
			itemTableView.hidden=YES;
			
		}
		else {
			[itemTableView reloadData];
			[self.view addSubview:itemTableView];
			itemTableView.hidden=NO;
		}
	}*/
	
	// added by pradeep on 22 july 2011 for adding new tab "MOST RECENT"
	else if (segmentedControl.selectedSegmentIndex==1)
	{
		[stories4peoplemyinterest  removeAllObjects];//= nil;
		//stories4peoplemyinterest==[[NSMutableArray alloc]init];
		// added by pradeep on 5 oct 2010 for fixing bug when clicking on refresh btn it shows wrong images in the list
		[imageURLs4Lazyauto removeAllObjects];
		[self getPeopleData:@"mostrecent"];
		if ([stories4peoplemyinterest count] == 0)
		{
			// if no records found
			
			CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
			// commneted by pradeep on 4 august 2011 for fixing memory issue for retailed object since label allocated twice
			//recnotfound = [[UILabel alloc] init];
			// end 4 august 2011			
			
			// commneted and added by pradeep on 3 august 2011 for fixing memory issue for retailed object
			//recnotfound = [UnsocialAppDelegate createLabelControl:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			// end 3 august 2011
			
			[self.view addSubview:recnotfound];
			recnotfound.hidden = NO;
			// 13 may 2011 by pradeep //[recnotfound release];
			btnDeletePeople.hidden = YES;
			
			// commented by pradeep on 3 june 2011 for fixing reload btn disappear issue
			//self.navigationItem.rightBarButtonItem = nil;		
			// end 3 june 2011
			
			itemTableView.hidden=YES;
			
		}
		else {
			[itemTableView reloadData];
			[self.view addSubview:itemTableView];
			itemTableView.hidden=NO;
		}
	}
	// end 22 july 2011
	
	else if (segmentedControl.selectedSegmentIndex==2)
	{
		[stories4peoplebookmark removeAllObjects];
			//stories4peoplemyinterest==[[NSMutableArray alloc]init];
			// added by pradeep on 5 oct 2010 for fixing bug when clicking on refresh btn it shows wrong images in the list
		[imageURLs4Lazysaved removeAllObjects];
		[self getPeopleData:@"bookmark"];
		if ([stories4peoplebookmark count] == 0)
		{
				// if no records found
			CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
			
			// commneted by pradeep on 4 august 2011 for fixing memory issue for retailed object since label allocated twice
			//recnotfound = [[UILabel alloc] init];
			// end 4 august 2011			
			
			// commneted and added by pradeep on 3 august 2011 for fixing memory issue for retailed object			
			//recnotfound = [UnsocialAppDelegate createLabelControl:@"There are no user profiles saved. You can save user profiles by using the Options button on the profile detail page." frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"There are no user profiles saved. You can save user profiles by using the Options button on the profile detail page." frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			// end 3 august 2011
			
			recnotfound.hidden = NO;
			[self.view addSubview:recnotfound];
			// 13 may 2011 by pradeep //[recnotfound release];
			btnDeletePeople.hidden = YES;
			
			// commented by pradeep on 3 june 2011 for fixing reload btn disappear issue
			//self.navigationItem.rightBarButtonItem = nil;		
			// end 3 june 2011
			
			itemTableView.hidden=YES;
			
		}
		else {
			[itemTableView reloadData];
			[self.view addSubview:itemTableView];
			itemTableView.hidden=NO;
			[self.view addSubview:btnDeletePeople];
			btnDeletePeople.hidden = NO;
		}
	}
	
	[self.view addSubview:segmentedControl];
	loading.hidden = YES;
	imgForOverlap.hidden = YES;
	[activityView stopAnimating];
	
	/*if(segmentedControl.selectedSegmentIndex == 1) 
	{			
		[itemTableView setEditing:NO animated:YES];	
		editing = NO;
		itemTableView.frame = CGRectMake(0, 40, 320, 340); // dynamically change the height of uitableview
		btnAddTags.hidden = FALSE;
		[self.view addSubview:btnAddTags];
			//btnDeletePeople4Auto.hidden = FALSE;
		[self.view addSubview:btnDeletePeople4Auto];
		if([stories4peoplemyinterest count] == 0){
			
			btnDeletePeople4Auto.hidden = YES;
			btnAddTags.frame = CGRectMake(90, 385, 140, 29);
			btnDeletePeople.hidden = YES;
		}
		else {
			
			btnAddTags.frame = CGRectMake(10, 385, 140, 29);
			btnDeletePeople4Auto.hidden = NO;
			btnDeletePeople.hidden = NO;
		}
			//		[self segmenteHoverImage:NO:YES];
	}
	else */
	if(segmentedControl.selectedSegmentIndex == 2) 
	{			
			//self.navigationItem.rightBarButtonItem.enabled = TRUE;
		itemTableView.frame = CGRectMake(0, 40, 320, 340); // dynamically change the height of uitableview
		[btnDeletePeople release];
		btnDeletePeople = [UnsocialAppDelegate createButtonControl:@"Delete People" target:self selector:@selector(deleteBtn_OnClick) frame:CGRectMake(110, 385, 100, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
		[btnDeletePeople.titleLabel setFont:[UIFont fontWithName:kAppFontName size:11.5]];
		[self.view addSubview:btnDeletePeople];
	}
	else 
	{
			//btnDeletePeople.hidden = NO;
		[itemTableView setEditing:NO animated:YES];	
		editing = NO;
		itemTableView.frame = CGRectMake(0, 40, 320, 370); // dynamically change the height of uitableview
		/*btnAddTags.hidden = TRUE;
		btnDeletePeople4Auto.hidden = TRUE;*/
			//		[self segmenteHoverImage:YES:NO];
	}
		//[self.view addSubview:btnSetMiles];
}

	// for future code

	// not in use added by pradeep on 24 july 2010 since "Myinterest" segment ctrl is replaced with "Auto Tagged"
- (void)btnInterest_OnClick {
	
	/*UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:@"" message:@"Please set up your profile first!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	 [alertOnChoose show];
	 [alertOnChoose release];*/
}

- (void)btnSetMiles_OnClick {
	
	PeopleEventSetDistance *peopleEventSetDistance = [[PeopleEventSetDistance alloc]init];
	peopleEventSetDistance.peopleOrEvent = 1;
	peopleEventSetDistance.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[[self navigationController] presentModalViewController:peopleEventSetDistance animated:YES];
	[peopleEventSetDistance release];
}

- (void)createControls {
	
	NSLog(@"%d", segmentedControl.selectedSegmentIndex);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (gbllatitude	== nil)
	{
			// recursion for getting longitude and latitude value
			// timer control using threading
		[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createControls) userInfo:self.view repeats:NO];
	}
	else
	{
			//BOOL isrecexist = 
		[self getDataFromFile];
		[self getDataFromFile4PeopleDistance];
		
		if ( [gbluserid compare:@""] == NSOrderedSame || !gbluserid)
		{
			// commented by pradeep on 19 may 2011
			//UIAlertView *saveAlert = [[UIAlertView alloc] init];
			UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Atlease complete first step for setting your profile!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[saveAlert show];
			[saveAlert release];
			//tabBarController.selectedIndex = 3;
		}
		else
		{
			if (!itemTableView)
			{
					// for fixing bug by pradeep, case: if user has navigate people feature from spring board once, it shows rec accordingly but again use people feature from spring board, record doesn't display :(
				flg4segmentctrl=0;
				aroundme = NO;
				bookmark = NO;
				
				// added by pradeep on 22 july 2011 for adding most recent tab as 3rd tab
				myinterest = NO;
				// end 22 july 2011
				
					// for future code
				if (flg4segmentctrl==0)
				{
					[self getPeopleData:@"everyone"];
					if ([stories count]>0)
					{
						if ([[[stories objectAtIndex:0] objectForKey:@"forwhichtab"] isEqualToString:@"everyone"])
							aroundme=TRUE;
							// commented on 31 may 2010 by pradeep since now segment control will contain only two items	
						
						// commented n added by pradeep on 22 july 2011 for adding most recent tab as 3rd tab
						//else if ([[[stories objectAtIndex:0] objectForKey:@"forwhichtab"] isEqualToString:@"autotagged"])
						//	bookmark=TRUE;
						else if ([[[stories objectAtIndex:0] objectForKey:@"forwhichtab"] isEqualToString:@"mostrecent"])
							myinterest=TRUE;
						// end 22 july 2011
							
						else if ([[[stories objectAtIndex:0] objectForKey:@"forwhichtab"] isEqualToString:@"bookmark"])
							bookmark=TRUE;
					}
					else {
						segmentedControl.selectedSegmentIndex=whichsegmentselectedlasttime;
						recnotfound.hidden = NO;
					}
				}
				
				itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 370) style:UITableViewStylePlain];
				itemTableView.delegate = self;
				itemTableView.dataSource = self;
				itemTableView.rowHeight = 115;
				itemTableView.backgroundColor = [UIColor clearColor];
				itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
				[self.view addSubview:itemTableView];
				
				if([stories count] > 0)
				{
					itemTableView.hidden=NO;
					
				}
					// if no records found
				else
				{
					segmentedControl.selectedSegmentIndex=whichsegmentselectedlasttime;
					CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
					// commneted by pradeep on 4 august 2011 for fixing memory issue for retailed object since label allocated twice
					//recnotfound = [[UILabel alloc] init];
					// end 4 august 2011			
					
					// commneted and added by pradeep on 3 august 2011 for fixing memory issue for retailed object			
					
					//recnotfound = [UnsocialAppDelegate createLabelControl:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
					recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
					// end 3 august 2011
					
					recnotfound.hidden = NO;
					[self.view addSubview:recnotfound];
					// 13 may 2011 by pradeep //[recnotfound release];
					itemTableView.hidden=YES;
						//Nobody signed in the system in past four hours in your proximity.
				}
			}
			else 
			{
				segmentedControl.selectedSegmentIndex = whichsegmentselectedlasttime;
				[itemTableView reloadData];
				[self.view addSubview:itemTableView];
				
			}
			/*
			BOOL istagsexist = [self getDataFromFile4Tags];
			NSString *btnttl = @"";
			if (istagsexist)
				btnttl = @"Add more keywords";
			else btnttl = @"Add keywords now";
			
				// for creating btn for "Add Tags" only if "AUTO" is selected
			btnAddTags = [UnsocialAppDelegate createButtonControl:btnttl target:self selector:@selector(addTags_OnClick) frame:CGRectMake(10, 385, 140, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]]; // change the quardinates on 7 dec 2010 by pradeep (60, 385, 200, 29)
			[btnAddTags.titleLabel setFont:[UIFont fontWithName:kAppFontName size:11.5]];
				//btnAddTags.hidden = TRUE;
			[self.view addSubview:btnAddTags];
			
				// for creating btn for "Add Tags" only if "AUTO" is selected
			btnDeletePeople4Auto = [UnsocialAppDelegate createButtonControl:@"Delete People" target:self selector:@selector(deleteBtn4Auto_OnClick) frame:CGRectMake(170, 385, 140, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]]; // change the quardinates on 7 dec 2010 by pradeep (60, 385, 200, 29)
			[btnDeletePeople4Auto.titleLabel setFont:[UIFont fontWithName:kAppFontName size:11.5]];
				//btnAddTags.hidden = TRUE;
			[self.view addSubview:btnDeletePeople4Auto];*/
		}
	}
	NSLog(@"%d", segmentedControl.selectedSegmentIndex);
	[pool release];
}

- (BOOL) getDataFromFile4PeopleDistance {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"setMilesForPeoples"];
	
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
		
		
		localdistance = [[tempArray objectAtIndex:0] setMilesForPeople];
		
		[decoder finishDecoding];
		[decoder release];
		return YES;
	}
	else 
	{
		localdistance = @"1";
		return NO;
	}
}

- (BOOL) getDataFromFile4CheckingIsProfileSet {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial4"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
		return YES;
	}
	return NO;	
}

	// creating this method for displaying activityview when clicked on segment control
- (void) startProcess4ChangedSegment
{
	recnotfound.hidden = YES;
	if (whichsegmentselectedlasttime != segmentedControl.selectedSegmentIndex)
	{
		[self getDataFromFile];
		[self getDataFromFile4PeopleDistance];
			//whichsegmentselectedlasttime= segmentedControl.selectedSegmentIndex;
			//NSLog(@"segmentAction: selected segment = %d", [sender selectedSegmentIndex]);
			//int selectedSegment = [sender selectedSegmentIndex];
			//[self getDataFromFile];
		if (flg4segmentctrl>0)	
		{
				// old code when request executed for changing each segment
				//*************************************************************
			/*if (selectedSegment==0)
			 [self getPeopleData:@"everyone"];
			 else if (selectedSegment==1)
			 {
			 BOOL isprofilecompleted = [self getDataFromFile4CheckingIsProfileSet];
			 if (isprofilecompleted)
			 [self getPeopleData:@"myinterest"];
			 else {
			 //UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Please set up your profile first!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			 //[errorAlert show];
			 //[errorAlert release];
			 
			 UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:@"" message:@"Please set up your profile first!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			 [alertOnChoose show];
			 [alertOnChoose release];
			 
			 //segmentedControl.selectedSegmentIndex = 0;
			 }
			 
			 }
			 else if (selectedSegment==2)
			 [self getPeopleData:@"bookmark"];*/
				// end old code when request executed for changing each segment
				//*************************************************************
			
			
				//use in future
			if (segmentedControl.selectedSegmentIndex==0)
			{
				if(!aroundme)
				{
					[self getPeopleData:@"everyone"];
					aroundme = TRUE;
					
					if ([stories4peoplearoundme count] == 0)
					{
							// if no records found
						
						CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
						
						// commneted by pradeep on 4 august 2011 for fixing memory issue for retailed object since label allocated twice
						//recnotfound = [[UILabel alloc] init];
						// end 4 august 2011						
						
						// commneted and added by pradeep on 3 august 2011 for fixing memory issue for retailed object
						//recnotfound = [UnsocialAppDelegate createLabelControl:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
						recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
						// end 3 august 2011
						
						recnotfound.hidden = NO;
						[self.view addSubview:recnotfound];
						// 13 may 2011 by pradeep //[recnotfound release];		
						itemTableView.hidden=YES;
					}
					else {
						[itemTableView reloadData];
						[self.view addSubview:itemTableView];
						itemTableView.hidden=NO;
					}					
				}
				else 
				{
					if ([stories4peoplearoundme count] == 0)
					{
							// if no records found
						
						CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
						
						// commneted by pradeep on 4 august 2011 for fixing memory issue for retailed object since label allocated twice
						//recnotfound = [[UILabel alloc] init];
						// end 4 august 2011						
						
						// commneted and added by pradeep on 3 august 2011 for fixing memory issue for retailed object
						//recnotfound = [UnsocialAppDelegate createLabelControl:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
						recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
						// end 3 august 2011
						
						recnotfound.hidden = NO;
						[self.view addSubview:recnotfound];
						// 13 may 2011 by pradeep //[recnotfound release];
						itemTableView.hidden=YES;
					}
					else {
						[itemTableView reloadData];
						[self.view addSubview:itemTableView];
						itemTableView.hidden=NO;
					}
					
				}
				
			}
				// commented on 31 may 2010 by pradeep since now segment control will contain only two items
			/*
			else if (segmentedControl.selectedSegmentIndex==1)
			{
					// not in use added by pradeep on 24 july 2010 since "Myinterest" segment ctrl is replaced with "Auto Tagged"
					//BOOL isprofilecompleted = [self getDataFromFile4CheckingIsProfileSet];
					//if (isprofilecompleted)
				{
					if(!myinterest)
					{
						[self getPeopleData:@"autotagged"];
						myinterest = TRUE;
						if ([stories4peoplemyinterest count] == 0)
						{
								// if no records found
							
							CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
							recnotfound = [[UILabel alloc] init];
							recnotfound.hidden = NO;
							BOOL istagsexist = [self getDataFromFile4Tags];
							NSString *strnorecfound = @"";
							
							if (istagsexist)
								strnorecfound = @"There are currently no profiles that matches your requested tags.";
							else strnorecfound = @"For Auto tagging to work please add tags using the button below.";
							recnotfound = [UnsocialAppDelegate createLabelControl:strnorecfound frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];		
							[self.view addSubview:recnotfound];
							[recnotfound release];	
							itemTableView.hidden=YES;
						}
						else {
							[itemTableView reloadData];
							[self.view addSubview:itemTableView];
							itemTableView.hidden=NO;
						}
					}
					else 
					{
						if ([stories4peoplemyinterest count] == 0)
						{
								// if no records found
							
							CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
							recnotfound = [[UILabel alloc] init];
							recnotfound.hidden = NO;
							BOOL istagsexist = [self getDataFromFile4Tags];
							NSString *strnorecfound = @"";
							
							if (istagsexist)
								strnorecfound = @"There are currently no profiles that matches your requested tags.";
							else strnorecfound = @"For Auto tagging to work please add tags using the button below.";
							recnotfound = [UnsocialAppDelegate createLabelControl:strnorecfound frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];		
							[self.view addSubview:recnotfound];
							[recnotfound release];
							itemTableView.hidden=YES;
							btnDeletePeople4Auto.hidden = YES;
							
						}
						else {
							[itemTableView reloadData];
							[self.view addSubview:itemTableView];
							itemTableView.hidden=NO;
							btnDeletePeople4Auto.hidden = YES;
						}
					}
				}
				
					// not in use added by pradeep on 24 july 2010 since "Myinterest" segment ctrl is replaced with "Auto Tagged"
							
			}
			*/
			
			// added by pradeep on 22 july 2011 for adding MOST RECENT tab for people section
			
			else if (segmentedControl.selectedSegmentIndex==1)
			{
				// not in use added by pradeep on 24 july 2010 since "Myinterest" segment ctrl is replaced with "Auto Tagged" also replaced with "MOST RECENT"
				//BOOL isprofilecompleted = [self getDataFromFile4CheckingIsProfileSet];
				//if (isprofilecompleted)
				{
					if(!myinterest)
					{
						[self getPeopleData:@"mostrecent"];
						myinterest = TRUE;
						if ([stories4peoplemyinterest count] == 0)
						{
							// if no records found
							
							CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
							
							// commneted by pradeep on 4 august 2011 for fixing memory issue for retailed object since label allocated twice
							//recnotfound = [[UILabel alloc] init];
							// end 4 august 2011
							
							// commneted and added by pradeep on 3 august 2011 for fixing memory issue for retailed object
							//recnotfound = [UnsocialAppDelegate createLabelControl:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
							recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
							// end 3 august 2011
							
							recnotfound.hidden = NO;							
							[self.view addSubview:recnotfound];
							// 13 may 2011 by pradeep //[recnotfound release];		
							itemTableView.hidden=YES;
						}
						else {
							[itemTableView reloadData];
							[self.view addSubview:itemTableView];
							itemTableView.hidden=NO;
						}
					}
					else 
					{
						if ([stories4peoplemyinterest count] == 0)
						{
							// if no records found
							
							CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
							
							// commneted by pradeep on 4 august 2011 for fixing memory issue for retailed object since label allocated twice
							//recnotfound = [[UILabel alloc] init];
							// end 4 august 2011							
							
							// commneted and added by pradeep on 3 august 2011 for fixing memory issue for retailed object
							//recnotfound = [UnsocialAppDelegate createLabelControl:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
							recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"There are currently no people in your area.\nTry again later!" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
							// end 3 august 2011
							
							recnotfound.hidden = NO;
							[self.view addSubview:recnotfound];
							// 13 may 2011 by pradeep //[recnotfound release];		
							itemTableView.hidden=YES;
						}
						else {
							[itemTableView reloadData];
							[self.view addSubview:itemTableView];
							itemTableView.hidden=NO;
						}
					}
				}
				
				// not in use added by pradeep on 24 july 2010 since "Myinterest" segment ctrl is replaced with "Auto Tagged"
				
			}
			
			// end 22 july 2001
			
			else if (segmentedControl.selectedSegmentIndex==2)
					//else if (segmentedControl.selectedSegmentIndex==1)
			{
				if(!bookmark)
				{
					[self getPeopleData:@"bookmark"];
					bookmark=TRUE;
					if ([stories4peoplebookmark count] == 0)
					{
							// if no records found
						
						CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
						
						// commneted and added by pradeep on 3 august 2011 for fixing memory issue for retailed object
						//recnotfound = [UnsocialAppDelegate createLabelControl:@"There are no user profiles saved. You can save user profiles by using the Options button on the profile detail page." frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
						recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"There are no user profiles saved. You can save user profiles by using the Options button on the profile detail page." frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
						// end 3 august 2011
						
						recnotfound.hidden = NO;
						
							//btnDeletePeople.hidden = NO;
							//self.navigationItem.rightBarButtonItem = nil;				
						[self.view addSubview:recnotfound];
						// 13 may 2011 by pradeep //[recnotfound release];	
						itemTableView.hidden=YES;
					}
					else {
							//btnDeletePeople.hidden = NO;
						[itemTableView reloadData];
						[self.view addSubview:itemTableView];
						itemTableView.hidden=NO;
					}
				}
				else 
				{
					if ([stories4peoplebookmark count] == 0)
					{
							// if no records found
						
						CGRect lableRecNotFrame = CGRectMake(10, 160, 300, 130);
						// commneted by pradeep on 4 august 2011 for fixing memory issue for retailed object since label allocated twice
						//recnotfound = [[UILabel alloc] init];
						// end 4 august 2011						
						
						// commneted and added by pradeep on 3 august 2011 for fixing memory issue for retailed object
						//recnotfound = [UnsocialAppDelegate createLabelControl:@"There are no user profiles saved. You can save user profiles by using the Options button on the profile detail page." frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
						recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"There are no user profiles saved. You can save user profiles by using the Options button on the profile detail page." frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
						// end 3 august 2011
						
						recnotfound.hidden = NO;
						
							//btnDeletePeople.hidden = YES;
							//self.navigationItem.rightBarButtonItem = nil;				
						btnAddTags.hidden = YES;
						[self.view addSubview:recnotfound];
						// 13 may 2011 by pradeep //[recnotfound release];
						itemTableView.hidden=YES;
						
					}
					else {
							//btnDeletePeople.hidden = NO;
						btnAddTags.hidden = YES;
						[itemTableView reloadData];
						[self.view addSubview:itemTableView];
						itemTableView.hidden=NO;
					}
				}				
			}
		}
		whichsegmentselectedlasttime= segmentedControl.selectedSegmentIndex; 
	}
	flg4segmentctrl=1;
	
	[self.view addSubview:segmentedControl];
	[self.view addSubview:itemTableView];
	loading.hidden = YES;
	imgForOverlap.hidden = YES;
	[activityView stopAnimating];
	activityView.hidden = YES;
	if ([stories count] ==0)
		recnotfound.hidden=NO;
	
/*
	if(segmentedControl.selectedSegmentIndex == 1)
	{
		[itemTableView setEditing:NO animated:YES];	
		editing = NO;
		itemTableView.frame = CGRectMake(0, 40, 320, 340); // dynamically change the height of uitableview
		btnAddTags.hidden = FALSE;
		[self.view addSubview:btnAddTags];
		btnDeletePeople4Auto.hidden = FALSE;
		[self.view addSubview:btnDeletePeople4Auto];
	}
	else */if(segmentedControl.selectedSegmentIndex == 2) // for deleting saved people
	{			
		itemTableView.frame = CGRectMake(0, 40, 320, 340); // dynamically change the height of uitableview
		btnDeletePeople = [UnsocialAppDelegate createButtonControl:@"Delete People" target:self selector:@selector(deleteBtn_OnClick) frame:CGRectMake(110, 385, 100, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
		[btnDeletePeople.titleLabel setFont:[UIFont fontWithName:kAppFontName size:11.5]];
		btnAddTags.hidden = YES;
		btnDeletePeople4Auto.hidden = YES;
		[self.view addSubview:btnDeletePeople];
	}
	else 
	{
		[itemTableView setEditing:NO animated:YES];	
		editing = NO;
		itemTableView.frame = CGRectMake(0, 40, 320, 370); // dynamically change the height of uitableview
		/*btnAddTags.hidden = TRUE;
		btnDeletePeople4Auto.hidden = TRUE;*/
	}
	if([stories4peoplebookmark count] == 0){

		btnDeletePeople.hidden = YES;
			//self.navigationItem.rightBarButtonItem = nil;				
	}
	else {
		
		btnDeletePeople.hidden = NO;
	}
}

- (void)segmentAction:(id)sender {
	
	self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
	[self.view addSubview:imgBack];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	[self.view addSubview:loading];
	loading.hidden = NO;
	[activityView startAnimating];
	
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess4ChangedSegment) userInfo:self.view repeats:NO];
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
		//	if (buttonIndex == 0)
		//	{
		//		segmentedControl.selectedSegmentIndex = 0;
		//	}
	
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

- (void) getPeopleData:(NSString *) flg4whichtab {
	
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
	
	if ( [gbluserid compare:@""] == NSOrderedSame || !gbluserid)
		gbluserid = @"none";
	
	NSLog(@"Sending....");
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&distance=%@&flag2=%@",@"getpeople",gbllatitude,gbllongitude,gbluserid,usertime,localdistance,flg4whichtab];
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
	
	// added by pradeep on 19 may 2011
	if (stories)
	{
		[stories release];
		[rssParser release];
	}
	// end 19 may 2011
	
	stories = [[NSMutableArray alloc] init];	
	
		// for fixing bug by pradeep, case: if user has navigate people feature from spring board once, it shows rec accordingly but again use people feature from spring board, record doesn't display :(
	if (!itemTableView)
	{
		[stories4peoplearoundme removeAllObjects];
		[stories4peoplemyinterest removeAllObjects];
		[stories4peoplebookmark removeAllObjects];
	}
	
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
		//imageURLs4Lazyall = [[NSMutableArray alloc]init];
		//imageURLs4Lazyauto = [[NSMutableArray alloc]init];
		//imageURLs4Lazysaved = [[NSMutableArray alloc]init];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down."];
	NSLog(@"error parsing XML: %@", errorString);	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
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
		
		// added by pradeep on 19 may 2011
		if (item)
		{
			// added by pradeep on 19 may 2011 for releasing objects
			[item release];
			[userid release];
			[userdevicetocken release];
			[userprefix release];
			[username release];
			[useremail release];
			[userlastuse release];
			[usercontact release];
			[usercompany release];			
			[userwebsite release];
			[userlinkedin release];
			[userabout release];
			[userind release];
			[usersubind release];
			[userrole release];
			[userallownotification release];
			[userinterestind release];
			[userinterestsubind release];
			[userinterestrole release];
			[userprofilecomplete release];
			[userdisplayitem release];
			[usersecuritylevel release];
			[userstatus release];			
			[usercurrentdistance release];
			[userforwhichtab release];
			[userlinkedinemailid release];
			[usertitle release];
			[userlevel release];

			// end 19 may 2011
		}
		
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
		userlinkedinemailid = [[NSMutableString alloc]init];
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
		[item setObject:userlinkedinemailid forKey:@"linkedinemailid"];
		[item setObject:usertitle forKey:@"usertitle"];
		[item setObject:userlevel forKey:@"level"];

			//add the actual image as well right now into the stories array
		
		/*NSURL *url = [NSURL URLWithString:currentImageURL];		
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
		 }*/
		
			//[imageURLs4Lazy addObject:currentImageURL];
		
		
		[stories addObject:[item copy]];
		if ([userforwhichtab compare:@"everyone"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==0)
		{			
			[stories4peoplearoundme addObject:[item copy]];
			[imageURLs4Lazyall addObject:currentImageURL];
		}
		
		// commented and added by pradeep on 22 july 2011 for adding MOST RECENT tab for people
		/*else if ([userforwhichtab compare:@"autotagged"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==1)
		{			
			[stories4peoplemyinterest addObject:[item copy]];
			[imageURLs4Lazyauto addObject:currentImageURL];
		}*/
		else if ([userforwhichtab compare:@"mostrecent"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==1)
		{			
			 [stories4peoplemyinterest addObject:[item copy]];
			 [imageURLs4Lazyauto addObject:currentImageURL];
		}
		// end 22 july 2011
		
		else if ([userforwhichtab compare:@"bookmark"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==2)
		{
			[stories4peoplebookmark addObject:[item copy]];
			[imageURLs4Lazysaved addObject:currentImageURL];
		}
		NSLog(@"adding story: %@", username);		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
		//NSLog(@"found characters: %@", string);
		// save the characters for the current item...
	if ([currentElement isEqualToString:@"ttl"]) 
	{
			//	[userforwhichtab appendString:string];
		
		if ([string compare:@"everyone"] == NSOrderedSame)
			whichsegmentselectedlasttime = 0;
		
		// commented and added by pradeep on 22 july 2011 for adding MOST RECENT tab for people
		/*else if ([string compare:@"autotagged"] == NSOrderedSame)
			whichsegmentselectedlasttime = 1;*/
		else if ([string compare:@"mostrecent"] == NSOrderedSame)
			whichsegmentselectedlasttime = 1;
		// end 22 july 2011
		
		else if ([string compare:@"bookmark"] == NSOrderedSame)
			whichsegmentselectedlasttime = 2;
	}
	
	else if ([currentElement isEqualToString:@"prefix"]) {
		[userprefix appendString:string];
	}else if ([currentElement isEqualToString:@"guid"]) {
		[userid appendString:string];
	}else if ([currentElement isEqualToString:@"devicetocken"]) {
		[userdevicetocken appendString:string];
	}else if ([currentElement isEqualToString:@"username"]) {
		[username appendString:string];
	}else if ([currentElement isEqualToString:@"email"]) {
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
	[itemTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// added by pradeep on 29 september for fixing issue "Selecting "Recent" while scrolling down the "ALL" tab on people page causes app to crash." i.e. app crashes during changing segment when tableview is scrolling
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
	
    //startDeceleratingPosition = scrollView.contentOffset.y;
	[segmentedControl setUserInteractionEnabled:NO];
	
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
    /*BOOL isPositionUp = startDeceleratingPosition < scrollView.contentOffset.y;     
	
    NSArray *paths = [_myTableview indexPathsForVisibleRows];
    UITableViewCell *cell;
    if(isPositionUp){
        cell = [_myTableview cellForRowAtIndexPath:[paths objectAtIndex:0]];
    } else {
        cell = [_myTableview cellForRowAtIndexPath:[paths lastObject]];
    }*/
	[segmentedControl setUserInteractionEnabled:YES];	
}
// end 29 september 2011 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		//return [stories count];
	int totelements=0;
	if (flg4segmentctrl==0)
	{
		if ([stories count]>0)
			if ([[[stories objectAtIndex:0] objectForKey:@"forwhichtab"] isEqualToString:@"everyone"])
				totelements = [stories4peoplearoundme count];
		
		// commented and added by pradeep on 22 july 2011 for adding MOST RECENT tab for people
			/*else if ([[[stories objectAtIndex:0] objectForKey:@"forwhichtab"] isEqualToString:@"autotagged"])
				totelements =  [stories4peoplebookmark count];*/
			else if ([[[stories objectAtIndex:0] objectForKey:@"forwhichtab"] isEqualToString:@"mostrecent"])
				totelements =  [stories4peoplemyinterest count];
		
		// end 22 july 2011
			else if ([[[stories objectAtIndex:0] objectForKey:@"forwhichtab"] isEqualToString:@"bookmark"])
				totelements =  [stories4peoplebookmark count];
	}
	
	else 
	{
		if (segmentedControl.selectedSegmentIndex==0)
			totelements =  [stories4peoplearoundme count];
			// commented on 31 may 2010 by pradeep since now segment control will contain only two items
		
		else if (segmentedControl.selectedSegmentIndex==1)
			totelements =  [stories4peoplemyinterest count];
		
		else if (segmentedControl.selectedSegmentIndex==2)
				//else if (segmentedControl.selectedSegmentIndex==1)
			totelements =  [stories4peoplebookmark count];
		
	}
	return totelements;
	
}

	//******** end 6 dec 2010

	// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		//if (cell == nil)
	
		// commented by pradeep for lazy img
		//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		// for lazi img feature by pradeep 
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
	}
	else {
		AsyncImageView* oldImage = (AsyncImageView*)
		[cell.contentView viewWithTag:999];
		[oldImage removeFromSuperview];
	}
	
	UIImageView *imgPplBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 0, 320, 115) imageName:@"peopleback.png"];
	[cell.contentView addSubview:imgPplBack];
	
		//Dynamic label
	lblStatus = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(89, 75, 215, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleStatus txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
		// Set up the cell...
	
		// for selecting segment controle's index
	if (flg4segmentctrl==0)
		if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"forwhichtab"] isEqualToString:@"everyone"])
			segmentedControl.selectedSegmentIndex = 0;
		// commented on 31 may 2010 by pradeep since now segment control will contain only two items	
		else if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"forwhichtab"] isEqualToString:@"mostrecent"])
			segmentedControl.selectedSegmentIndex = 1;
		else if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"forwhichtab"] isEqualToString:@"bookmark"])
			segmentedControl.selectedSegmentIndex = 2;
		//segmentedControl.selectedSegmentIndex = 1;
	
		//use in future
		//********************************************************************
		// for aroundme tab by using stories4peoplearoundme
	
#pragma mark People aroundme
	if (segmentedControl.selectedSegmentIndex==0)
	{
		lblStatus.text = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"status"];
		[cell.contentView addSubview:lblStatus];
		
		/*UIImage *imageforresize = [[stories4peoplearoundme  objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		 
		 // commented by pradeep on 11 august for fixing different image layout
		 CGImageRef realImage = imageforresize.CGImage;
		 float realHeight = CGImageGetHeight(realImage);
		 float realWidth = CGImageGetWidth(realImage);
		 // commented by pradeep on 11 august for fixing different image layout
		 float ratio = realHeight/realWidth;
		 float modifiedWidth, modifiedHeight;
		 
		 if(ratio < 1) {
		 
		 modifiedWidth = 75;
		 modifiedHeight = modifiedWidth*ratio;
		 }
		 else {
		 
		 modifiedHeight = 75;
		 modifiedWidth = modifiedHeight/ratio;
		 }
		 
		 CGRect imageRect = CGRectMake(9, 11, modifiedWidth, modifiedHeight );*/
		
			//******************* commented by pradeep for implementing lazy img feature on 16 sep 2010
		/*CGRect imageRect = CGRectMake(9, 11, 75, 75);
		 UIImageView *usrImage = [[UIImageView alloc] initWithFrame:imageRect];
		 usrImage.image = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		 
		 // Get the Layer of any view
		 CALayer * l = [usrImage layer];
		 [l setMasksToBounds:YES];
		 [l setCornerRadius:10.0];
		 
		 // You can even add a border
		 [l setBorderWidth:1.0];
		 [l setBorderColor:[[UIColor blackColor] CGColor]];
		 [cell.contentView addSubview:usrImage];
		 [usrImage release];*/
			//******************* commented by pradeep for implementing lazy img feature on 16 sep 2010
		
			//*************** lazy img code start
		
		CGRect frame;
		frame.size.width=65; frame.size.height=65;
		frame.origin.x=9; frame.origin.y=11;
		asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
		asyncImage.tag = 999;
		NSURL*url = [NSURL URLWithString:[imageURLs4Lazyall objectAtIndex:indexPath.row]];
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
			//[asyncImage release];
		
			//*************** lazy img code end
		NSString *usrname =[[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"username"];
		
		if ([[[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"username"] length] > 18)			
			usrname = [[usrname substringWithRange:NSMakeRange(0, 18)] stringByAppendingString:@"..."];
		
		CGRect lableNameFrame = CGRectMake(89, 4, 165, 18);	
		lblUserName = [UnsocialAppDelegate createLabelControl:usrname frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableCellHeading txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:lblUserName];
		
		NSString *prefix = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"prefix"];
		
		NSString *firstLevel = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"level"];
		
		NSString *displayitem = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"displayitem"];
		NSString *isindustryshow = [[displayitem substringFromIndex:1] substringToIndex:1];
		NSString *iscompanyshow = [[displayitem substringFromIndex:2] substringToIndex:1];
		
		UILabel *lblcompany = [UnsocialAppDelegate createLabelControl:@"Company: " frame:CGRectMake(lableNameFrame.origin.x, 27, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:lblcompany];
		
		UILabel *lblindustry = [UnsocialAppDelegate createLabelControl:@"Industry: " frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 16, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:lblindustry];
		
		UILabel *lblfunction = [UnsocialAppDelegate createLabelControl:@"Function:" frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 32, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:lblfunction];
		
			// for company **** start ****
			// if company is set as private then it will be as 1 else 0
		CGRect lableCompanyFrame = CGRectMake(152, lblcompany.frame.origin.y, 140, 15);		
		lblCompanyName = [UnsocialAppDelegate createLabelControl:[[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"company"] frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		
		
		if ([firstLevel isEqualToString:@"yes"]) // user is 1st level connection to self
		{
			CGRect flevFrame = CGRectMake(38, 85, 30, 16);
			UIImageView *flev = [UnsocialAppDelegate createImageViewControl:flevFrame imageName:@"1stlev.png"];
			[cell.contentView addSubview:flev];
		}
		
		if ([prefix isEqualToString:@"none"]) // show linkedin icon if user is linkedin
		{
			UIImageView *flev = [UnsocialAppDelegate createImageViewControl:CGRectMake(12, 85, 16, 16) imageName:@"linkedinIcon.png"];
			[cell.contentView addSubview:flev];
		}
		
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
				lblCompanyName.text = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"company"];
			
			[cell.contentView addSubview:lblCompanyName];
		}
		
			// for company **** end ****
			// if industry is set as private then it will be as 1 else 0
		CGRect lableIndustryFrame = CGRectMake(148, lblcompany.frame.origin.y + 16, 140, 15);
		
		lblIndustryName = [UnsocialAppDelegate createLabelControl:[[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"industry"] frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		
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
				lblIndustryName.text = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"industry"];
			[cell.contentView addSubview:lblIndustryName];
		}
			// for Industry **** end ****
		
			//for role ****start**********		
		CGRect lableRoleFrame = CGRectMake(150, lblcompany.frame.origin.y + 32, 195, 15);
		lblFunctionName = [UnsocialAppDelegate createLabelControl:[[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"role"] frame:lableRoleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
		
		if ([[[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"role"] isEqualToString:@""])
			lblFunctionName.text = @"not set";
		
		[cell.contentView addSubview:lblFunctionName];
			// 13 may 2011 by pradeep //[lblFunctionName release];
		
			// for role *****end **********
		
			// for distance ******start*******		
		CGRect lableDistanceFrame = CGRectMake(212, lableNameFrame.origin.y, 100, 18);
		lblUserName = [UnsocialAppDelegate createLabelControl:@"" frame:lableDistanceFrame txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
		
		NSString *showDistance;
		NSArray *aryMiles = [[[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"currentdistance"] componentsSeparatedByString:@" Miles"];
		
		float floatMiles = [[aryMiles objectAtIndex:0] floatValue];
		if(floatMiles <= 1.00) {
			
			showDistance = @"Steps Away";
				//lblUserName.textColor = [UIColor orangeColor];
		}
		else if(floatMiles < 5.00) {
			
			if(floatMiles > 1.00) {
				
				showDistance = @"Short Distance";
					//lblUserName.textColor = [UIColor yellowColor];
			} 
		}
		else {
			showDistance = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"currentdistance"]; 
				//lblUserName.textColor = [UIColor whiteColor];
		}
		lblUserName.textColor = [UIColor orangeColor];
		lblUserName.text = showDistance;
		[cell.contentView addSubview:lblUserName];
		
			// 13 may 2011 by pradeep //[lblcompany release];
			// 13 may 2011 by pradeep //[lblindustry release];
			// 13 may 2011 by pradeep //[lblfunction release];
	}
	/*
	 #pragma mark People autotagged
	 //******************************* added by pradeep on 24 july 2010 for autotagged segment ctrl
	 
	 else if (segmentedControl.selectedSegmentIndex==1)
	 {
	 // added by pradeep on 6 dec 2010 for last seen for auto*****
	 
	 NSString *strdeeptaggedon = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"logindate"];
	 
	 NSLog(@"Last seen: %@", strdeeptaggedon);
	 
	 
	 
	 // added by pradeep on 6 dec 2010 for last seen for auto*****
	 
	 lblStatus.text = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"status"];
	 [cell.contentView addSubview:lblStatus];
	 
	 //*************** lazy img code start
	 
	 CGRect frame;
	 frame.size.width=65; frame.size.height=65;
	 frame.origin.x=9; frame.origin.y=11;
	 asyncImage = [[[AsyncImageView alloc]
	 initWithFrame:frame] autorelease];
	 asyncImage.tag = 999;
	 NSURL*url = [NSURL URLWithString:[imageURLs4Lazyauto objectAtIndex:indexPath.row]];
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
	 //[asyncImage release];
	 
	 //*************** lazy img code end
	 
	 CGRect lableNameFrame = CGRectMake(89, 4, 165, 18);	
	 lblUserName = [UnsocialAppDelegate createLabelControl:[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"username"] frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableCellHeading txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	 [cell.contentView addSubview:lblUserName];
	 
	 NSString *displayitem = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"displayitem"];
	 NSString *isindustryshow = [[displayitem substringFromIndex:1] substringToIndex:1];
	 NSString *iscompanyshow = [[displayitem substringFromIndex:2] substringToIndex:1];
	 
	 UILabel *lblcompany = [UnsocialAppDelegate createLabelControl:@"Company: " frame:CGRectMake(lableNameFrame.origin.x, 27, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	 [cell.contentView addSubview:lblcompany];
	 
	 UILabel *lblindustry = [UnsocialAppDelegate createLabelControl:@"Industry: " frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 16, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	 [cell.contentView addSubview:lblindustry];
	 
	 UILabel *lblfunction = [UnsocialAppDelegate createLabelControl:@"Function:" frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 32, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	 [cell.contentView addSubview:lblfunction];
	 
	 // for company **** start ****
	 // if company is set as private then it will be as 1 else 0
	 CGRect lableCompanyFrame = CGRectMake(152, lblcompany.frame.origin.y, 140, 15);		
	 lblCompanyName = [UnsocialAppDelegate createLabelControl:[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"company"] frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	 
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
	 lblCompanyName.text = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"company"];
	 
	 [cell.contentView addSubview:lblCompanyName];
	 }
	 
	 // for company **** end ****
	 // if industry is set as private then it will be as 1 else 0
	 CGRect lableIndustryFrame = CGRectMake(148, lblcompany.frame.origin.y + 16, 140, 15);
	 
	 lblIndustryName = [UnsocialAppDelegate createLabelControl:[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"industry"] frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	 
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
	 lblIndustryName.text = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"industry"];
	 [cell.contentView addSubview:lblIndustryName];
	 }
	 // for Industry **** end ****
	 
	 //for role ****start**********		
	 CGRect lableRoleFrame = CGRectMake(150, lblcompany.frame.origin.y + 32, 195, 15);
	 lblFunctionName = [UnsocialAppDelegate createLabelControl:[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"role"] frame:lableRoleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	 
	 if ([[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"role"] isEqualToString:@""])
	 lblFunctionName.text = @"not set";
	 
	 [cell.contentView addSubview:lblFunctionName];
	 [lblFunctionName release];
	 
	 // for role *****end **********
	 
	 // for distance ******start*******		
	 CGRect lableDistanceFrame = CGRectMake(212, lableNameFrame.origin.y, 100, 18);
	 lblUserName = [UnsocialAppDelegate createLabelControl:@"" frame:lableDistanceFrame txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	 
	 NSString *showDistance;
	 NSArray *aryMiles = [[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"currentdistance"] componentsSeparatedByString:@" Miles"];
	 
	 float floatMiles = [[aryMiles objectAtIndex:0] floatValue];
	 if(floatMiles <= 1.00) {
	 
	 showDistance = @"Steps Away";
	 //lblUserName.textColor = [UIColor orangeColor];
	 }
	 else if(floatMiles < 5.00) {
	 
	 if(floatMiles > 1.00) {
	 
	 showDistance = @"Short Distance";
	 //lblUserName.textColor = [UIColor yellowColor];
	 } 
	 }
	 else {
	 showDistance = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"currentdistance"]; 
	 //lblUserName.textColor = [UIColor whiteColor];
	 }
	 lblUserName.textColor = [UIColor orangeColor];
	 lblUserName.text = showDistance;
	 [cell.contentView addSubview:lblUserName];
	 
	 [lblcompany release];
	 [lblindustry release];
	 [lblfunction release];
	 }
	 
	 //******************************* end for autotagged segment ctrl
	 */
	
	
	// added by pradeep on 22 july 2011 for MOST RECENT tab for people
	
	else if (segmentedControl.selectedSegmentIndex==1)
	{
		// added by pradeep on 6 dec 2010 for last seen for auto*****
		
		lblStatus.text = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"status"];
		[cell.contentView addSubview:lblStatus];
		
		/*UIImage *imageforresize = [[stories4peoplearoundme  objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		 
		 // commented by pradeep on 11 august for fixing different image layout
		 CGImageRef realImage = imageforresize.CGImage;
		 float realHeight = CGImageGetHeight(realImage);
		 float realWidth = CGImageGetWidth(realImage);
		 // commented by pradeep on 11 august for fixing different image layout
		 float ratio = realHeight/realWidth;
		 float modifiedWidth, modifiedHeight;
		 
		 if(ratio < 1) {
		 
		 modifiedWidth = 75;
		 modifiedHeight = modifiedWidth*ratio;
		 }
		 else {
		 
		 modifiedHeight = 75;
		 modifiedWidth = modifiedHeight/ratio;
		 }
		 
		 CGRect imageRect = CGRectMake(9, 11, modifiedWidth, modifiedHeight );*/
		
		//******************* commented by pradeep for implementing lazy img feature on 16 sep 2010
		/*CGRect imageRect = CGRectMake(9, 11, 75, 75);
		 UIImageView *usrImage = [[UIImageView alloc] initWithFrame:imageRect];
		 usrImage.image = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		 
		 // Get the Layer of any view
		 CALayer * l = [usrImage layer];
		 [l setMasksToBounds:YES];
		 [l setCornerRadius:10.0];
		 
		 // You can even add a border
		 [l setBorderWidth:1.0];
		 [l setBorderColor:[[UIColor blackColor] CGColor]];
		 [cell.contentView addSubview:usrImage];
		 [usrImage release];*/
		//******************* commented by pradeep for implementing lazy img feature on 16 sep 2010
		
		//*************** lazy img code start
		
		CGRect frame;
		frame.size.width=65; frame.size.height=65;
		frame.origin.x=9; frame.origin.y=11;
		asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
		asyncImage.tag = 999;
		NSURL*url = [NSURL URLWithString:[imageURLs4Lazyauto objectAtIndex:indexPath.row]];
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
		//[asyncImage release];
		
		//*************** lazy img code end
		NSString *usrname =[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"username"];
		
		if ([[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"username"] length] > 18)			
			usrname = [[usrname substringWithRange:NSMakeRange(0, 18)] stringByAppendingString:@"..."];
		
		CGRect lableNameFrame = CGRectMake(89, 4, 165, 18);	
		lblUserName = [UnsocialAppDelegate createLabelControl:usrname frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableCellHeading txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:lblUserName];
		
		NSString *prefix = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"prefix"];
		
		NSString *firstLevel = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"level"];
		
		NSString *displayitem = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"displayitem"];
		NSString *isindustryshow = [[displayitem substringFromIndex:1] substringToIndex:1];
		NSString *iscompanyshow = [[displayitem substringFromIndex:2] substringToIndex:1];
		
		UILabel *lblcompany = [UnsocialAppDelegate createLabelControl:@"Company: " frame:CGRectMake(lableNameFrame.origin.x, 27, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:lblcompany];
		
		UILabel *lblindustry = [UnsocialAppDelegate createLabelControl:@"Industry: " frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 16, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:lblindustry];
		
		UILabel *lblfunction = [UnsocialAppDelegate createLabelControl:@"Function:" frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 32, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:lblfunction];
		
		// for company **** start ****
		// if company is set as private then it will be as 1 else 0
		CGRect lableCompanyFrame = CGRectMake(152, lblcompany.frame.origin.y, 140, 15);		
		lblCompanyName = [UnsocialAppDelegate createLabelControl:[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"company"] frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		
		
		if ([firstLevel isEqualToString:@"yes"]) // user is 1st level connection to self
		{
			CGRect flevFrame = CGRectMake(38, 85, 30, 16);
			UIImageView *flev = [UnsocialAppDelegate createImageViewControl:flevFrame imageName:@"1stlev.png"];
			[cell.contentView addSubview:flev];
		}
		
		if ([prefix isEqualToString:@"none"]) // show linkedin icon if user is linkedin
		{
			UIImageView *flev = [UnsocialAppDelegate createImageViewControl:CGRectMake(12, 85, 16, 16) imageName:@"linkedinIcon.png"];
			[cell.contentView addSubview:flev];
		}
		
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
				lblCompanyName.text = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"company"];
			
			[cell.contentView addSubview:lblCompanyName];
		}
		
		// for company **** end ****
		// if industry is set as private then it will be as 1 else 0
		CGRect lableIndustryFrame = CGRectMake(148, lblcompany.frame.origin.y + 16, 140, 15);
		
		lblIndustryName = [UnsocialAppDelegate createLabelControl:[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"industry"] frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		
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
				lblIndustryName.text = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"industry"];
			[cell.contentView addSubview:lblIndustryName];
		}
		// for Industry **** end ****
		
		//for role ****start**********		
		CGRect lableRoleFrame = CGRectMake(150, lblcompany.frame.origin.y + 32, 195, 15);
		lblFunctionName = [UnsocialAppDelegate createLabelControl:[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"role"] frame:lableRoleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
		
		if ([[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"role"] isEqualToString:@""])
			lblFunctionName.text = @"not set";
		
		[cell.contentView addSubview:lblFunctionName];
		// 13 may 2011 by pradeep //[lblFunctionName release];
		
		// for role *****end **********
		
		// for distance ******start*******		
		CGRect lableDistanceFrame = CGRectMake(212, lableNameFrame.origin.y, 100, 18);
		lblUserName = [UnsocialAppDelegate createLabelControl:@"" frame:lableDistanceFrame txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
		
		NSString *showDistance;
		NSArray *aryMiles = [[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"currentdistance"] componentsSeparatedByString:@" Miles"];
		
		float floatMiles = [[aryMiles objectAtIndex:0] floatValue];
		if(floatMiles <= 1.00) {
			
			showDistance = @"Steps Away";
			//lblUserName.textColor = [UIColor orangeColor];
		}
		else if(floatMiles < 5.00) {
			
			if(floatMiles > 1.00) {
				
				showDistance = @"Short Distance";
				//lblUserName.textColor = [UIColor yellowColor];
			} 
		}
		else {
			showDistance = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"currentdistance"]; 
			//lblUserName.textColor = [UIColor whiteColor];
		}
		lblUserName.textColor = [UIColor orangeColor];
		lblUserName.text = showDistance;
		[cell.contentView addSubview:lblUserName];
		
		// 13 may 2011 by pradeep //[lblcompany release];
		// 13 may 2011 by pradeep //[lblindustry release];
		// 13 may 2011 by pradeep //[lblfunction release];
	}
	
	// end 22 july 2011 for MOST RECENT
	
		// for bookmark tab by using stories4peoplebookmark
#pragma mark People saved
		// commented on 31 may 2010 by pradeep since now segment control will contain only two items
	else if (segmentedControl.selectedSegmentIndex == 2)
			//else if (segmentedControl.selectedSegmentIndex==1)
	{
		lblStatus.text = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"status"];
		[cell.contentView addSubview:lblStatus];
		
			// commented by pradeep on 11 august for fixing different image layout
		/*UIImage *imageforresize = [[stories4peoplebookmark  objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		 CGImageRef realImage = imageforresize.CGImage;
		 float realHeight = CGImageGetHeight(realImage);
		 float realWidth = CGImageGetWidth(realImage);
		 float ratio = realHeight/realWidth;
		 float modifiedWidth, modifiedHeight;
		 if(ratio < 1) {
		 
		 modifiedWidth = 75;
		 modifiedHeight = modifiedWidth*ratio;
		 }
		 else {
		 
		 modifiedHeight = 75;
		 modifiedWidth = modifiedHeight/ratio;
		 }
		 
		 CGRect imageRect = CGRectMake(9, 11, modifiedWidth, modifiedHeight );*/
		
			// commented by pradeep on 16 sep 2010 for lazi img implementation
		/*CGRect imageRect = CGRectMake(9, 11, 75, 75 );
		 UIImageView *usrImage = [[UIImageView alloc] initWithFrame:imageRect];
		 usrImage.image = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		 
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
			// commented by pradeep on 16 sep 2010 for lazi img implementation
		
			//*************** lazy img code start
		
		CGRect frame;
		frame.size.width=65; frame.size.height=65;
		frame.origin.x=9; frame.origin.y=11;
		asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
		asyncImage.tag = 999;
		NSURL*url = [NSURL URLWithString:[imageURLs4Lazysaved objectAtIndex:indexPath.row]];
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
			//[asyncImage release];
		
			//*************** lazy img code end
		
		NSString *usrname =[[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"username"];
		
		if ([[[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"username"] length] > 18)			
			usrname = [[usrname substringWithRange:NSMakeRange(0, 18)] stringByAppendingString:@"..."];
		
		CGRect lableNameFrame = CGRectMake(89, 4, 165, 18);	
		lblUserName = [UnsocialAppDelegate createLabelControl:usrname frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableCellHeading txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:lblUserName];
		
		NSString *prefix = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"prefix"];
		
		NSString *firstLevel = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"level"];
		
		NSString *displayitem = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"displayitem"];
		NSString *isindustryshow = [[displayitem substringFromIndex:1] substringToIndex:1];
		NSString *iscompanyshow = [[displayitem substringFromIndex:2] substringToIndex:1];
		
		UILabel *lblcompany = [UnsocialAppDelegate createLabelControl:@"Company: " frame:CGRectMake(lableNameFrame.origin.x, 27, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:lblcompany];
		
		UILabel *lblindustry = [UnsocialAppDelegate createLabelControl:@"Industry: " frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 16, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:lblindustry];
		
		UILabel *lblfunction = [UnsocialAppDelegate createLabelControl:@"Function:" frame:CGRectMake(lableNameFrame.origin.x, lblcompany.frame.origin.y + 32, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:lblfunction];
		
			// for company **** start ****
			// if company is set as private then it will be as 1 else 0
		CGRect lableCompanyFrame = CGRectMake(152, lblcompany.frame.origin.y, 140, 15);		
		lblCompanyName = [UnsocialAppDelegate createLabelControl:[[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"company"] frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		
		if ([firstLevel isEqualToString:@"yes"]) // user is 1st level connection to self
		{
			CGRect flevFrame = CGRectMake(38, 85, 30, 16);
			UIImageView *flev = [UnsocialAppDelegate createImageViewControl:flevFrame imageName:@"1stlev.png"];
			[cell.contentView addSubview:flev];
		}
		
		if ([prefix isEqualToString:@"none"]) // show linkedin icon if user is linkedin
		{
			UIImageView *flev = [UnsocialAppDelegate createImageViewControl:CGRectMake(12, 85, 16, 16) imageName:@"linkedinIcon.png"];
			[cell.contentView addSubview:flev];
		}
		
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
				lblCompanyName.text = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"company"];
			
			[cell.contentView addSubview:lblCompanyName];
		}
		
			// for company **** end ****
			// if industry is set as private then it will be as 1 else 0
		CGRect lableIndustryFrame = CGRectMake(148, lblcompany.frame.origin.y + 16, 140, 15);
		
		lblIndustryName = [UnsocialAppDelegate createLabelControl:[[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"industry"] frame:lableIndustryFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		
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
				lblIndustryName.text = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"industry"];
			[cell.contentView addSubview:lblIndustryName];
		}
			// for Industry **** end ****
		
			//for role ****start**********		
		CGRect lableRoleFrame = CGRectMake(150, lblcompany.frame.origin.y + 32, 195, 15);
		lblFunctionName = [UnsocialAppDelegate createLabelControl:[[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"role"] frame:lableRoleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
		
		if ([[[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"role"] isEqualToString:@""])
			lblFunctionName.text = @"not set";
		
		[cell.contentView addSubview:lblFunctionName];
			// 13 may 2011 by pradeep //[lblFunctionName release];
		
			// for role *****end **********
		
			// for distance ******start*******		
		CGRect lableDistanceFrame = CGRectMake(212, lableNameFrame.origin.y, 100, 18);
		lblUserName = [UnsocialAppDelegate createLabelControl:@"" frame:lableDistanceFrame txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
		
		NSString *showDistance;
		NSArray *aryMiles = [[[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"currentdistance"] componentsSeparatedByString:@" Miles"];
		
		float floatMiles = [[aryMiles objectAtIndex:0] floatValue];
		if(floatMiles <= 1.00) {
			
			showDistance = @"Steps Away";
				//lblUserName.textColor = [UIColor orangeColor];
		}
		else if(floatMiles < 5.00) {
			
			if(floatMiles > 1.00) {
				
				showDistance = @"Short Distance";
					//lblUserName.textColor = [UIColor yellowColor];
			} 
		}
		else {
			showDistance = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"currentdistance"]; 
				//lblUserName.textColor = [UIColor whiteColor];
		}
		lblUserName.textColor = [UIColor orangeColor];
		lblUserName.text = showDistance;
		[cell.contentView addSubview:lblUserName];
		
			// 13 may 2011 by pradeep //[lblcompany release];
			// 13 may 2011 by pradeep //[lblindustry release];
			// 13 may 2011 by pradeep //[lblfunction release];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		// Navigation logic may go here. Create and push another view controller.
	peoplesUserProfile = [[PeoplesUserProfile alloc]init];
	peoplesUserProfile.myname  = [myName objectAtIndex:0];
	
		// for aroundme tab by using stories4peoplearoundme
	if (segmentedControl.selectedSegmentIndex==0)
	{
		peoplesUserProfile.userid = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"guid"];
		peoplesUserProfile.username = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"username"];
		peoplesUserProfile.userprefix = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"prefix"];
		
		if([[[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"prefix"] isEqualToString:@"none"]) {
			
			peoplesUserProfile.useremail = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"linkedinemailid"];
			peoplesUserProfile.userlinkedintoken = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"email"];
		}
		else
			peoplesUserProfile.useremail = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"email"];
		
		peoplesUserProfile.usercontact = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"contact"];
		peoplesUserProfile.usercompany = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"company"];
		peoplesUserProfile.usertitle = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"usertitle"];
		peoplesUserProfile.userlevel = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"level"];
		peoplesUserProfile.userwebsite = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"userwebsite"];
		peoplesUserProfile.userlinkedin = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"linkedinprofile"];
		peoplesUserProfile.userabout = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"aboutu"];	
		peoplesUserProfile.userind = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"industry"];	
		peoplesUserProfile.usersubind = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"subindustry"];
		peoplesUserProfile.userrole = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"role"];	
		peoplesUserProfile.userintind = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"interestind"];
		
		peoplesUserProfile.userintsubind = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"interestsubind"];	
		peoplesUserProfile.userintrole = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"interestrole"];
		peoplesUserProfile.userdisplayitem = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"displayitem"];	
		peoplesUserProfile.userintind = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"interestind"];
		peoplesUserProfile.fullImg = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		
			//******************** for lazi img start
		
			//NSURL *url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
			//[aryEventDetails addObject:[imageURLs4Lazy objectAtIndex:indexPath.row]];
		peoplesUserProfile.imgurl = [imageURLs4Lazyall objectAtIndex:indexPath.row];
		peoplesUserProfile.camefromwhichoption = @"people";
		
			//******************** for lazi img end
		
		peoplesUserProfile.profileforwhichtab = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"forwhichtab"];
		peoplesUserProfile.statusmgs = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"status"];
		peoplesUserProfile.strdistance = [[stories4peoplearoundme objectAtIndex:indexPath.row] objectForKey:@"currentdistance"];
		
			// added by pradeep for implementing auto tagged feature 7 dec 2010
			//*****
		peoplesUserProfile.taggedon = @"";
			//*****
			// added by pradeep for implementing auto tagged feature 7 dec 2010
	}
	
	// added by pradeepon 22 july 2011 for adding MOST RECENT tab for people
	else if (segmentedControl.selectedSegmentIndex==1)
		//else if (segmentedControl.selectedSegmentIndex==1)
	{
		peoplesUserProfile.userid = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"guid"];				peoplesUserProfile.username = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"username"];
		peoplesUserProfile.userprefix = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"prefix"];
		
		if([[[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"prefix"] isEqualToString:@"none"]) {
			
			peoplesUserProfile.useremail = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"linkedinemailid"];
			peoplesUserProfile.userlinkedintoken = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"email"];
		}
		else
			peoplesUserProfile.useremail = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"email"];
		peoplesUserProfile.usercontact = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"contact"];
		peoplesUserProfile.usertitle = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"usertitle"];
		peoplesUserProfile.userlevel = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"level"];	
		peoplesUserProfile.usercompany = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"company"];	
		peoplesUserProfile.userwebsite = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"userwebsite"];
		peoplesUserProfile.userlinkedin = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"linkedinprofile"];	
		peoplesUserProfile.userabout = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"aboutu"];	
		peoplesUserProfile.userind = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"industry"];	
		peoplesUserProfile.usersubind = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"subindustry"];
		peoplesUserProfile.userrole = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"role"];	
		peoplesUserProfile.userintind = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"interestind"];
		
		peoplesUserProfile.userintsubind = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"interestsubind"];	
		peoplesUserProfile.userintrole = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"interestrole"];
		peoplesUserProfile.userdisplayitem = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"displayitem"];	
		peoplesUserProfile.userintind = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"interestind"];
		peoplesUserProfile.fullImg = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		
		//******************** for lazi img start
		
		//NSURL *url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
		//[aryEventDetails addObject:[imageURLs4Lazy objectAtIndex:indexPath.row]];
		peoplesUserProfile.imgurl = [imageURLs4Lazyauto objectAtIndex:indexPath.row];						peoplesUserProfile.camefromwhichoption = @"people";
		
		//******************** for lazi img end
		
		peoplesUserProfile.profileforwhichtab = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"forwhichtab"];
		peoplesUserProfile.statusmgs = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"status"];
		peoplesUserProfile.strdistance = [[stories4peoplemyinterest objectAtIndex:indexPath.row] objectForKey:@"currentdistance"];
		
		// added by pradeep for implementing auto tagged feature 7 dec 2010
		//*****
		peoplesUserProfile.taggedon = @"";
		//*****
		// added by pradeep for implementing auto tagged feature 7 dec 2010
	}
	// end 22 july 2011 MOST RECENT tab
	
	else if (segmentedControl.selectedSegmentIndex==2)
			//else if (segmentedControl.selectedSegmentIndex==1)
	{
		peoplesUserProfile.userid = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"guid"];					peoplesUserProfile.username = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"username"];
		peoplesUserProfile.userprefix = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"prefix"];
		
		if([[[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"prefix"] isEqualToString:@"none"]) {
			
			peoplesUserProfile.useremail = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"linkedinemailid"];
			peoplesUserProfile.userlinkedintoken = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"email"];
		}
		else
			peoplesUserProfile.useremail = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"email"];
		peoplesUserProfile.usercontact = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"contact"];
		peoplesUserProfile.usertitle = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"usertitle"];
		peoplesUserProfile.userlevel = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"level"];	
		peoplesUserProfile.usercompany = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"company"];	
		peoplesUserProfile.userwebsite = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"userwebsite"];
		peoplesUserProfile.userlinkedin = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"linkedinprofile"];	
		peoplesUserProfile.userabout = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"aboutu"];	
		peoplesUserProfile.userind = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"industry"];	
		peoplesUserProfile.usersubind = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"subindustry"];
		peoplesUserProfile.userrole = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"role"];	
		peoplesUserProfile.userintind = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"interestind"];
		
		peoplesUserProfile.userintsubind = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"interestsubind"];	
		peoplesUserProfile.userintrole = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"interestrole"];
		peoplesUserProfile.userdisplayitem = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"displayitem"];	
		peoplesUserProfile.userintind = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"interestind"];
		peoplesUserProfile.fullImg = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
		
			//******************** for lazi img start
		
			//NSURL *url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
			//[aryEventDetails addObject:[imageURLs4Lazy objectAtIndex:indexPath.row]];
		peoplesUserProfile.imgurl = [imageURLs4Lazysaved objectAtIndex:indexPath.row];						peoplesUserProfile.camefromwhichoption = @"people";
		
			//******************** for lazi img end
		
		peoplesUserProfile.profileforwhichtab = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"forwhichtab"];
		peoplesUserProfile.statusmgs = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"status"];
		peoplesUserProfile.strdistance = [[stories4peoplebookmark objectAtIndex:indexPath.row] objectForKey:@"currentdistance"];
		
			// added by pradeep for implementing auto tagged feature 7 dec 2010
			//*****
		peoplesUserProfile.taggedon = @"";
			//*****
			// added by pradeep for implementing auto tagged feature 7 dec 2010
	}
	[self.navigationController pushViewController:peoplesUserProfile animated:YES];
	[peoplesUserProfile release];
}

	// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
		// commented by pradeep on 7 dec 2010 for adding delete people btn for "AUTO" tab
	/*if (editingStyle == UITableViewCellEditingStyleDelete)
	 {
	 // Delete the row from the data source
	 [self sendReqForDeleteSavedPeople:indexPath.row];
	 [stories4peoplebookmark removeObjectAtIndex:indexPath.row];
	 [imageURLs4Lazysaved removeObjectAtIndex:indexPath.row];
	 [itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	 if([stories4peoplebookmark count] == 0)
	 {
	 recnotfound = [UnsocialAppDelegate createLabelControl:@"There are no user profiles saved. You can save user profiles by using the Options button on the profile detail page." frame:CGRectMake(10, 160, 300, 130) txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	 recnotfound.hidden = NO;
	 btnDeletePeople.hidden = YES;
	 [self.view addSubview:recnotfound];
	 [recnotfound release];
	 self.navigationItem.rightBarButtonItem.enabled = YES;
	 self.navigationItem.leftBarButtonItem.enabled = YES;
	 [itemTableView setEditing:NO animated:YES];	
	 editing = NO;
	 }
	 }*/
	
		// added by pradeep on 7 dec 2010 for deleting auto tagged people
		//*********************
	
		//*********************
		// added below if statement by pradeep on 7 dec 2010 for deleting auto tagged people
	if (segmentedControl.selectedSegmentIndex==2)
	{
			// ******* end 7 dec 2010
		
		if (editingStyle == UITableViewCellEditingStyleDelete)
		{
				// Delete the row from the data source
			[self sendReqForDeleteSavedPeople:indexPath.row];
			[stories4peoplebookmark removeObjectAtIndex:indexPath.row];
			[imageURLs4Lazysaved removeObjectAtIndex:indexPath.row];
			[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			if([stories4peoplebookmark count] == 0)
			{
				// commneted and added by pradeep on 3 august 2011 for fixing memory issue for retailed object
				
				//recnotfound = [UnsocialAppDelegate createLabelControl:@"There are no user profiles saved. You can save user profiles by using the Options button on the profile detail page." frame:CGRectMake(10, 160, 300, 130) txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
				recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"There are no user profiles saved. You can save user profiles by using the Options button on the profile detail page." frame:CGRectMake(10, 160, 300, 130) txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
				// end 3 august 2011
				
				recnotfound.hidden = NO;
				
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationDuration:0.5];
				[UIView setAnimationBeginsFromCurrentState:YES];
				
				btnDeletePeople.frame = CGRectMake(btnDeletePeople.frame.origin.x, btnDeletePeople.frame.origin.y + 50, btnDeletePeople.frame.size.width, btnDeletePeople.frame.size.height);
				
				// commented by pradeep on 3 june 2011 for fixing reload btn disappear issue
				//self.navigationItem.rightBarButtonItem = nil;		
				// end 3 june 2011
				
				[UIView commitAnimations];
				[self.view addSubview:recnotfound];
				// 13 may 2011 by pradeep //[recnotfound release];
				self.navigationItem.rightBarButtonItem.enabled = YES;
				self.navigationItem.leftBarButtonItem.enabled = YES;
				[itemTableView setEditing:NO animated:YES];	
				editing = NO;
			}
		}
	}
	
		// added by pradeep on 7 dec 2010 for deleting auto tagged people
		//*********************
	
		//*********************
		// added below if statement by pradeep on 7 dec 2010 for deleting auto tagged people
	/*
	else if (segmentedControl.selectedSegmentIndex==1)
	{
			// ******* end 7 dec 2010
		
		if (editingStyle == UITableViewCellEditingStyleDelete)
		{
				// Delete the row from the data source
			[self sendReqForDeleteAutoTaggedPeople:indexPath.row];
			[stories4peoplemyinterest removeObjectAtIndex:indexPath.row];
			[imageURLs4Lazyauto removeObjectAtIndex:indexPath.row];
			[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			if([stories4peoplemyinterest count] == 0)
			{
				recnotfound = [UnsocialAppDelegate createLabelControl:@"There are currently no profiles that matches your requested tags." frame:CGRectMake(10, 160, 300, 130) txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
				recnotfound.hidden = NO;
				btnDeletePeople.hidden = YES;
				
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationDuration:0.5];
				[UIView setAnimationBeginsFromCurrentState:YES];
				
				btnDeletePeople4Auto.hidden = YES;
				btnAddTags.frame = CGRectMake(90, 385, 140, 29);
				
				[UIView commitAnimations];
				[self.view addSubview:recnotfound];
				[recnotfound release];
				self.navigationItem.rightBarButtonItem.enabled = YES;
				self.navigationItem.leftBarButtonItem.enabled = YES;
				[itemTableView setEditing:NO animated:YES];	
				editing = NO;
			}
		}*/
		//}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
		// Detemine if it's in editing mode
    if (itemTableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
	else
		return UITableViewCellEditingStyleNone;
}

- (void)deleteBtn_OnClick {
		//Do not let the user add if the app is in edit mode.
	if(!editing)
	{
		self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = NO;
		[itemTableView setEditing:YES animated:YES];	
		editing = YES;
	}
	else
	{
		self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
		[itemTableView setEditing:NO animated:YES];	
		editing = NO;
	}
}

	// added by pradeep on 7 dec 2010 for deleting auto tagged people
	//*********************
- (void)deleteBtn4Auto_OnClick {
		//Do not let the user add if the app is in edit mode.
	if(!editing)
	{
		self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = NO;
		[itemTableView setEditing:YES animated:YES];	
		editing = YES;
	}
	else
	{
		self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
		[itemTableView setEditing:NO animated:YES];	
		editing = NO;
	}
}
	//********************** end 7 dec 2010

	// ********************* START 8 DEC 2010 for deleting auto tagged user

- (NSInteger) sendReqForDeleteAutoTaggedPeople:(NSInteger) storyIndex {
	NSLog(@"Sending....");
		//NSData *imageData1;
	
	
		// setting up the URL to post to
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];	
		// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	NSString *flag = @"deleteautotaggedpeople";
	
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
	
	NSString *varAutoTaggedPeopleId = [NSString stringWithFormat:@"%@\r\n",[[stories objectAtIndex:storyIndex] objectForKey:@"guid"]];	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	[myArray release];
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"taggeduserid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varAutoTaggedPeopleId] dataUsingEncoding:NSUTF8StringEncoding]];
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
			//if ([key compare:@"Totunreadmsg"] == NSOrderedSame)			
		{
				//if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				/*unreadmsg = [[dic objectForKey:key] intValue];				
				 successflg=YES;				
				 //userid = [dic objectForKey:key];
				 
				 NSString *strbadgevalue = [NSString stringWithFormat:@"%i", unreadmsg];
				 if(unreadmsg != 0)
				 inBoxviewcontroller.tabBarItem.badgeValue = strbadgevalue;
				 else if (unreadmsg==0)
				 inBoxviewcontroller.tabBarItem.badgeValue= nil;*/
				
					//break;
			}
		}
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	[returnString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

	// ********************* end 8 dec 2010 

- (NSInteger) sendReqForDeleteSavedPeople:(NSInteger) storyIndex {
	NSLog(@"Sending....");
		//NSData *imageData1;
	
	
		// setting up the URL to post to
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];	
		// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	NSString *flag = @"deletesavedpeople";
	
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
	
	NSString *varSavedEventId = [NSString stringWithFormat:@"%@\r\n",[[stories objectAtIndex:storyIndex] objectForKey:@"guid"]];	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	[myArray release];
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"saveduserid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varSavedEventId] dataUsingEncoding:NSUTF8StringEncoding]];
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
			//if ([key compare:@"Totunreadmsg"] == NSOrderedSame)			
		{
				//if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				/*unreadmsg = [[dic objectForKey:key] intValue];				
				 successflg=YES;				
				 //userid = [dic objectForKey:key];
				 
				 NSString *strbadgevalue = [NSString stringWithFormat:@"%i", unreadmsg];
				 if(unreadmsg != 0)
				 inBoxviewcontroller.tabBarItem.badgeValue = strbadgevalue;
				 else if (unreadmsg==0)
				 inBoxviewcontroller.tabBarItem.badgeValue= nil;*/
				
					//break;
			}
		}
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	[returnString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

- (void)dealloc {
	// added by pradeep on 29 june 2011
	//itemTableView.delegate = nil;
	// end 29 june 2011
				 
    [super dealloc];
}


@end
