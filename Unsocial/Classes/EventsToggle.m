//
//  Events.m
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UnsocialAppDelegate.h"
#import "PeopleEventSetDistance.h"
#import "EventDetails.h"
#import "GlobalVariables.h"
#import "Person.h"
#import "EventAdd.h"
#import "EventsToggle.h"

BOOL allInterest1 = NO;
int currentindexforscrolltableview;
NSString *localuserid, *localdistance;
int whichsegmentselectedlasttime4event;
int arivefirsttime4event;


// added by pradeep on 15 feb 2011
BOOL isfilterclick = NO;

// added by pradeep on 8 june 2011 for resolving filter view when user clicked on filter and see event detail and when come back, event list shows few other events too which are not belongs to last filtered category
BOOL vieweventdetail = NO;


// added by pradeep on 16 dec 2010 for calendar
int whichsegmentselectedlasttime4cal;
int arivefirsttime4cal;

@implementation EventsToggle
@synthesize comingfrom, toolbar;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(createControls) userInfo:self.view repeats:NO];
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	WhereIam = 6;
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor clearColor];
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
	
	//****************** 24 dec 2010 by pradeep
	
	/*self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	
	if(comingfrom == 0) {
		self.navigationItem.leftBarButtonItem = leftcbtnitme;
	}
	else {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	}*/	
	
	// added by pradeep on 24 dec 2010 for adding "List" btn for toggle between list and dairy for event enhancement feature
	
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(rightbtn_OnClick)] autorelease];
	
	// added by pradeep on 3 june 2011 for hiding back btn
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;
	leftbtn.hidden = YES;
	
	// end 2011
	
	UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(287.0, 0.0, 33, 30)];
	[rightbtn setImage:[UIImage imageNamed:@"calendar1.png"] forState:(UIControlState) nil];
	[rightbtn addTarget:self action:@selector(rightbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
	self.navigationItem.rightBarButtonItem = rightbtnitme;
	
	//******************** 24 dec 2010 end
	
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	events = [[EventsToggle alloc]init];

	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	loading.hidden = NO;
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	
}

- (void)createControls {
	
	toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 372, 320, 43)];
	toolbar.barStyle = UIBarStyleDefault;
	toolbar.tintColor = [UIColor colorWithRed:240/255.0 green:141/255.0 blue:60/255.0 alpha:1.0];
		// size up the toolbar and set its frame
	[toolbar sizeToFit];
	[self.view addSubview:toolbar];
	[toolbar release];
	
	if(!allInterest1) {
		strAll = @"event_all.png";
		strAll2 = @"event_all2.png";
		strInrst = @"event_my_interst.png";
		strInrst2 = @"event_my_interst2.png";
	}
	else {
		strAll2 = @"event_all.png";
		strAll = @"event_all2.png";
		strInrst2 = @"event_my_interst.png";
		strInrst = @"event_my_interst2.png";
	}

	if (gbllatitude	== nil)
	{
		// recursion for getting longitude and latitude value
		// timer control using threading
		[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createControls) userInfo:self.view repeats:NO];
	}
	else
	{
		//********** for filter btn added by pradeep on 22 dec 2010
		
		btnFilter = [UnsocialAppDelegate createButtonControl:@"FILTER" target:self selector:@selector(btnFilter_Onclick) frame:CGRectMake(230, 378, 85, 35) imageStateNormal:@"filter.png" imageStateHighlighted:@"filter2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
		[btnFilter.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
		// added if condition below by pradeep on 28 jan 2011 for resolving toolbar disappearing issue
		if (!itemTableView)
			[self.view addSubview:btnFilter];
		
		//********** for filter btn added by pradeep on 22 dec 2010 end
		
		NSArray *segmentTextContent = [NSArray arrayWithObjects:@"ALL", @"SAVED", @"PREMIUM", nil];
		segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
		segmentedControl.frame = CGRectMake(5, 378, 220, 35);//CGRectMake(40, 378, 240, 35);
		[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;	
		segmentedControl.tintColor = [UIColor colorWithRed:240/255.0 green:141/255.0 blue:60/255.0 alpha:1.0];
		segmentedControl.selectedSegmentIndex = whichsegmentselectedlasttime4event;
		//[self.view addSubview:segmentedControl];	
		
	}
		
	

	
	//[activityView stopAnimating];
	//activityView.hidden = YES;	
	
}

//*****************

- (void)btnFilter_Onclick {
	
	// added by pradeep on 15 feb 2011
	isfilterclick = YES;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Premium", @"Technology", @"Business", @"Social", @"Cancel",  nil];
	actionSheet.destructiveButtonIndex = 4;
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	// show from our table view (pops up in the middle of the table)
	[actionSheet release];
	//actionsheettype = 1;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	//if(actionsheettype == 1) 
	//{
		
		if(buttonIndex == 0) 
		{
			int selectedSegment = segmentedControl.selectedSegmentIndex;
			
			NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(eventindustry ==  %@)", @"Premium"];
			
			NSArray *filteredArray2 = [stories4cal filteredArrayUsingPredicate:predicate2];
			
			NSMutableArray *temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray2];
			
			[self getdifferentdatesforsectionwhensegmentchange:temp4filterary2];
			
			[stories removeAllObjects];
			
			[stories addObjectsFromArray:temp4filterary2];
			
			//************** 
			//[stories4cal removeAllObjects];
			
			//[stories4cal addObjectsFromArray:temp4filterary2];
			//**************
			
			
			//stories = [stories4cal filteredArrayUsingPredicate:predicate];
			
			/*if ([stories count] > 0)
			{
				NSLog(@"filteredArray eventname: %@", [[stories objectAtIndex:0] objectForKey:@"eventname"]);
				NSLog(@"filteredArray guid: %@", [[stories objectAtIndex:0] objectForKey:@"guid"]);
			}*/
			
			
			//*************
			
			if (!itemTableView)
			{				
				//[self getPeopleData:@"notset"];
				
				if([stories count] > 0)
				{
					itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, 320, 360) style:UITableViewStyleGrouped];
					itemTableView.delegate = self;
					itemTableView.dataSource = self;
					itemTableView.rowHeight = 55;
					itemTableView.autoresizesSubviews = YES;
					itemTableView.backgroundColor = [UIColor clearColor];
					//itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
					// for removing table's border
					itemTableView.separatorColor = [UIColor clearColor];
					[self.view addSubview:itemTableView];
					itemTableView.hidden=NO;
					
					/*itemTableView.delegate = self;
					 itemTableView.dataSource = self;
					 itemTableView.rowHeight = 115;
					 itemTableView.backgroundColor = [UIColor clearColor];
					 itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
					 [self.view addSubview:itemTableView];*/
				}
			}
			else 
			{
				[itemTableView reloadData];
				[self.view addSubview:itemTableView];
			}
			// if no records found
			if ([stories count] == 0)
			{
				// added if by pradeep on 15 feb 2011
				if (!recnotfound)
				{
				CGRect lableRecNotFrame = CGRectMake(30, 140, 260, 130);
					//Event not found for selected criteria
				recnotfound = [UnsocialAppDelegate createLabelControl:@"" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:6 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
				}
				recnotfound.hidden = NO;
				[self.view addSubview:recnotfound];
				//[recnotfound release];
				
				
				if (selectedSegment == 1)
				{
					recnotfound.text = @"You have no saved events to display. If you have an event you would like to save, simply go to event's detail page, click options, and then save.";
				}
				else if (selectedSegment == 2)
				{
					recnotfound.text = @"There are currently no premium events in your area. Try again later.";
				}
				else
				{
					recnotfound.text = @"There are currently no events in your area. Try again later.";
				}
			}
			else 
			{
				recnotfound.hidden = YES;
				recnotfound.text = @"";
			}
			
			// added by pradeep on 24 dec 2010 for reinitializing eventtoggledateary when segment change
			//************
			//if(arivefirsttime4event > 0)
			//[self getdifferentdatesforsectionwhensegmentchange];
			
			//************ end 24 dec 2010
			
			loading.hidden = YES;
			activityView.hidden = YES;
			[self.view addSubview:loading];
			loading.hidden = YES;
			[activityView stopAnimating];
			
			// commented on 14 dec 2010 for implementing event improvement i.e. calendar like awesome end
			//*********************************************
			[self.view addSubview:toolbar];
			[self.view addSubview:segmentedControl];
			
			// added by pradeeo on 14 dec for event improvement i.e. calendar
			
			
			[self.view addSubview:btnFilter];
			
			//*******************************
			 
			
		}
		else if(buttonIndex == 1) 
		{
			int selectedSegment = segmentedControl.selectedSegmentIndex;
			
			NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(eventindustry ==  %@)", @"Technology"];
			
			NSArray *filteredArray2 = [stories4cal filteredArrayUsingPredicate:predicate2];
			
			NSMutableArray *temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray2];
			
			[self getdifferentdatesforsectionwhensegmentchange:temp4filterary2];
			
			[stories removeAllObjects];
			
			[stories addObjectsFromArray:temp4filterary2];
			
			//************** 
			//[stories4cal removeAllObjects];
			
			//[stories4cal addObjectsFromArray:temp4filterary2];
			//**************
			
			
			//stories = [stories4cal filteredArrayUsingPredicate:predicate];
			
			/*if ([stories count] > 0)
			 {
			 NSLog(@"filteredArray eventname: %@", [[stories objectAtIndex:0] objectForKey:@"eventname"]);
			 NSLog(@"filteredArray guid: %@", [[stories objectAtIndex:0] objectForKey:@"guid"]);
			 }*/
			
			
			//*************
			
			if (!itemTableView)
			{				
				//[self getPeopleData:@"notset"];
				
				if([stories count] > 0)
				{
					itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, 320, 360) style:UITableViewStyleGrouped];
					itemTableView.delegate = self;
					itemTableView.dataSource = self;
					itemTableView.rowHeight = 55;
					itemTableView.autoresizesSubviews = YES;
					itemTableView.backgroundColor = [UIColor clearColor];
					//itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
					// for removing table's border
					itemTableView.separatorColor = [UIColor clearColor];
					[self.view addSubview:itemTableView];
					itemTableView.hidden=NO;
					
					/*itemTableView.delegate = self;
					 itemTableView.dataSource = self;
					 itemTableView.rowHeight = 115;
					 itemTableView.backgroundColor = [UIColor clearColor];
					 itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
					 [self.view addSubview:itemTableView];*/
				}
			}
			else 
			{
				[itemTableView reloadData];
				[self.view addSubview:itemTableView];
			}
			// if no records found
			if ([stories count] == 0)
			{
				// added if by pradeep on 15 feb 2011
				if (!recnotfound)
				{
				CGRect lableRecNotFrame = CGRectMake(30, 140, 260, 130);
				//Event not found for selected criteria
				recnotfound = [UnsocialAppDelegate createLabelControl:@"" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:6 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
				}
				recnotfound.hidden = NO;
				[self.view addSubview:recnotfound];
				//[recnotfound release];
				
				if (selectedSegment == 1)
				{
					recnotfound.text = @"You have no saved events to display. If you have an event you would like to save, simply go to event's detail page, click options, and then save.";
				}
				else if (selectedSegment == 2)
				{
					recnotfound.text = @"There are currently no premium events in your area. Try again later.";
				}
				else
				{
					recnotfound.text = @"There are currently no events in your area. Try again later.";
				}
			}
			else 
			{
				recnotfound.hidden = YES;
				recnotfound.text = @"";
			}
			
			// added by pradeep on 24 dec 2010 for reinitializing eventtoggledateary when segment change
			//************
			//if(arivefirsttime4event > 0)
			//[self getdifferentdatesforsectionwhensegmentchange];
			
			//************ end 24 dec 2010
			
			loading.hidden = YES;
			activityView.hidden = YES;
			[self.view addSubview:loading];
			loading.hidden = YES;
			[activityView stopAnimating];
			
			// commented on 14 dec 2010 for implementing event improvement i.e. calendar like awesome end
			//*********************************************
			[self.view addSubview:toolbar];
			[self.view addSubview:segmentedControl];
			
			// added by pradeeo on 14 dec for event improvement i.e. calendar
			
			
			[self.view addSubview:btnFilter];
			
			//*******************************
			
		}
		else if(buttonIndex == 2) 
		{
			int selectedSegment = segmentedControl.selectedSegmentIndex;
			
			NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(eventindustry ==  %@)", @"Business"];
			
			NSArray *filteredArray2 = [stories4cal filteredArrayUsingPredicate:predicate2];
			
			NSMutableArray *temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray2];
			
			[self getdifferentdatesforsectionwhensegmentchange:temp4filterary2];
			
			[stories removeAllObjects];
			
			[stories addObjectsFromArray:temp4filterary2];
			
			//************** 
			//[stories4cal removeAllObjects];
			
			//[stories4cal addObjectsFromArray:temp4filterary2];
			//**************
			
			
			//stories = [stories4cal filteredArrayUsingPredicate:predicate];
			
			/*if ([stories count] > 0)
			 {
			 NSLog(@"filteredArray eventname: %@", [[stories objectAtIndex:0] objectForKey:@"eventname"]);
			 NSLog(@"filteredArray guid: %@", [[stories objectAtIndex:0] objectForKey:@"guid"]);
			 }*/
			
			
			//*************
			
			if (!itemTableView)
			{				
				//[self getPeopleData:@"notset"];
				
				if([stories count] > 0)
				{
					itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, 320, 360) style:UITableViewStyleGrouped];
					itemTableView.delegate = self;
					itemTableView.dataSource = self;
					itemTableView.rowHeight = 55;
					itemTableView.autoresizesSubviews = YES;
					itemTableView.backgroundColor = [UIColor clearColor];
					//itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
					// for removing table's border
					itemTableView.separatorColor = [UIColor clearColor];
					[self.view addSubview:itemTableView];
					itemTableView.hidden=NO;
					
					/*itemTableView.delegate = self;
					 itemTableView.dataSource = self;
					 itemTableView.rowHeight = 115;
					 itemTableView.backgroundColor = [UIColor clearColor];
					 itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
					 [self.view addSubview:itemTableView];*/
				}
			}
			else 
			{
				[itemTableView reloadData];
				[self.view addSubview:itemTableView];
			}
			// if no records found
			if ([stories count] == 0)
			{
				// added if by pradeep on 15 feb 2011
				if (!recnotfound)
				{
				CGRect lableRecNotFrame = CGRectMake(30, 140, 260, 130);
				//Event not found for selected criteria
				recnotfound = [UnsocialAppDelegate createLabelControl:@"" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:6 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
				}
				recnotfound.hidden = NO;
				[self.view addSubview:recnotfound];
				//[recnotfound release];
				
				if (selectedSegment == 1)
				{
					recnotfound.text = @"You have no saved events to display. If you have an event you would like to save, simply go to event's detail page, click options, and then save.";
				}
				else if (selectedSegment == 2)
				{
					recnotfound.text = @"There are currently no premium events in your area. Try again later.";
				}
				else
				{
					recnotfound.text = @"There are currently no events in your area. Try again later.";
				}
			}
			else 
			{
				recnotfound.hidden = YES;
				recnotfound.text = @"";
			}
			
			// added by pradeep on 24 dec 2010 for reinitializing eventtoggledateary when segment change
			//************
			//if(arivefirsttime4event > 0)
			//[self getdifferentdatesforsectionwhensegmentchange];
			
			//************ end 24 dec 2010
			
			loading.hidden = YES;
			activityView.hidden = YES;
			[self.view addSubview:loading];
			loading.hidden = YES;
			[activityView stopAnimating];
			
			// commented on 14 dec 2010 for implementing event improvement i.e. calendar like awesome end
			//*********************************************
			[self.view addSubview:toolbar];
			[self.view addSubview:segmentedControl];
			
			// added by pradeeo on 14 dec for event improvement i.e. calendar
			
			
			[self.view addSubview:btnFilter];
			
			//*******************************
		}
		else if(buttonIndex == 3) 
		{ 
			int selectedSegment = segmentedControl.selectedSegmentIndex;
			
			NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(eventindustry ==  %@)", @"Social"];
			
			NSArray *filteredArray2 = [stories4cal filteredArrayUsingPredicate:predicate2];
			
			NSMutableArray *temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray2];
			
			[self getdifferentdatesforsectionwhensegmentchange:temp4filterary2];
			
			[stories removeAllObjects];
			
			[stories addObjectsFromArray:temp4filterary2];
			
			//************** 
			//[stories4cal removeAllObjects];
			
			//[stories4cal addObjectsFromArray:temp4filterary2];
			//**************
			
			
			//stories = [stories4cal filteredArrayUsingPredicate:predicate];
			
			/*if ([stories count] > 0)
			 {
			 NSLog(@"filteredArray eventname: %@", [[stories objectAtIndex:0] objectForKey:@"eventname"]);
			 NSLog(@"filteredArray guid: %@", [[stories objectAtIndex:0] objectForKey:@"guid"]);
			 }*/
			
			
			//*************
			
			if (!itemTableView)
			{				
				//[self getPeopleData:@"notset"];
				
				if([stories count] > 0)
				{
					itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, 320, 360) style:UITableViewStyleGrouped];
					itemTableView.delegate = self;
					itemTableView.dataSource = self;
					itemTableView.rowHeight = 55;
					itemTableView.autoresizesSubviews = YES;
					itemTableView.backgroundColor = [UIColor clearColor];
					//itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
					// for removing table's border
					itemTableView.separatorColor = [UIColor clearColor];
					[self.view addSubview:itemTableView];
					itemTableView.hidden=NO;
					
					/*itemTableView.delegate = self;
					 itemTableView.dataSource = self;
					 itemTableView.rowHeight = 115;
					 itemTableView.backgroundColor = [UIColor clearColor];
					 itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
					 [self.view addSubview:itemTableView];*/
				}
			}
			else 
			{
				[itemTableView reloadData];
				[self.view addSubview:itemTableView];
			}
			// if no records found
			if ([stories count] == 0)
			{
				// added if by pradeep on 15 feb 2011
				if (!recnotfound)
				{
				CGRect lableRecNotFrame = CGRectMake(30, 140, 260, 130);
				//Event not found for selected criteria
				recnotfound = [UnsocialAppDelegate createLabelControl:@"" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:6 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
				}
				recnotfound.hidden = NO;
				[self.view addSubview:recnotfound];
				//[recnotfound release];
				
				if (selectedSegment == 1)
				{
					recnotfound.text = @"You have no saved events to display. If you have an event you would like to save, simply go to event's detail page, click options, and then save.";
				}
				else if (selectedSegment == 2)
				{
					recnotfound.text = @"There are currently no premium events in your area. Try again later.";
				}
				else
				{
					recnotfound.text = @"There are currently no events in your area. Try again later.";
				}
			}
			else 
			{
				recnotfound.hidden = YES;
				recnotfound.text = @"";
			}
			
			// added by pradeep on 24 dec 2010 for reinitializing eventtoggledateary when segment change
			//************
			//if(arivefirsttime4event > 0)
			//[self getdifferentdatesforsectionwhensegmentchange];
			
			//************ end 24 dec 2010
			
			loading.hidden = YES;
			activityView.hidden = YES;
			[self.view addSubview:loading];
			loading.hidden = YES;
			[activityView stopAnimating];
			
			// commented on 14 dec 2010 for implementing event improvement i.e. calendar like awesome end
			//*********************************************
			[self.view addSubview:toolbar];
			[self.view addSubview:segmentedControl];
			
			// added by pradeeo on 14 dec for event improvement i.e. calendar
			
			
			[self.view addSubview:btnFilter];
			
			//*******************************
			
		}
		else 
		{
			
		}
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

// commented by pradeep on 24 dec 2010 and added new method 
//*********** start

/*- (void)rightbtn_OnClick {
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
}*/

- (void)rightbtn_OnClick {
	
	/*arivefirsttime4event = 0;
	 arivefirsttime4cal = 0;
	 whichsegmentselectedlasttime4cal = 0;
	 whichsegmentselectedlasttime4event = 0;
	 if(comingfrom == 1) {
	 
	 comingfrom = 0;
	 [self.navigationController popViewControllerAnimated:YES];
	 }
	 else*/ {
		 
		 //WhereIam = 0;
		 arivefirsttime4event = 0;
		 // added by pradeep on 27 jan 2011 for fixing error for scrolling table for current date based on value of currentindexforscrolltableview variable, i.e. first time it works fine but when go back and change the tab and come again to list view, currentindexforscrolltableview contains last assigned value and give out of bound array during scrolling
		 currentindexforscrolltableview = 0;
		 
		 // commented and added by pradeep on 3 june 2011 for changing concept of flip by push due to 9dots icon i.e. home btn appears every where
		 //[self dismissModalViewControllerAnimated:YES];
		 //[self.navigationController popViewControllerAnimated:YES];
		 
		 [UIView beginAnimations:nil context:NULL];
		 [UIView setAnimationDuration: 1.0];
		 [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
		 [[self navigationController] popViewControllerAnimated:NO];
		 [UIView commitAnimations];
	 }
}

//******************** end 24 dec 2010

- (NSInteger) sendReqForDeleteSavedEvent:(NSInteger) storyIndex {
	NSLog(@"Sending....");
	//NSData *imageData1;
	
	// added by pradeep on 18 dec 2010 for event improvenent i.e. calendar
	//************* start	
	
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:segmentedControlcal.selectedSegmentIndex]];
	
	//NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
	
	//stories = [NSMutableArray arrayWithArray:filteredArray];
	
	//stories = [[NSArray alloc] init];
	
	//stories = [stories4cal filteredArrayUsingPredicate:predicate];
	
	// ********** end 18 dec 2010
	
	
	// setting up the URL to post to
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];	
	NSString *flag = @"deletesavedevent";
	
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
	
	NSLog(@"%@", [[stories objectAtIndex:storyIndex] objectForKey:@"guid"]);
	NSString *varSavedEventId = [NSString stringWithFormat:@"%@\r\n",[[stories objectAtIndex:storyIndex] objectForKey:@"guid"]];	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
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
		//if ([key isEqualToString:@"Totunreadmsg"])			
		{
			//if (![[dic objectForKey:key] isEqualToString:@""])
			{
				//unreadmsg = [[dic objectForKey:key] intValue];				
				successflg=YES;				
				//userid = [dic objectForKey:key];
				
				/*NSString *strbadgevalue = [NSString stringWithFormat:@"%i", unreadmsg];
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
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

- (void)addEvent_Click {
		
	EventAdd *eventAdd = [[EventAdd alloc]init];
	//eventAdd.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController pushViewController:eventAdd animated:YES];
	
}

- (void)segmentAction:(id)sender 
{
	// added by pradeep on 8 june 2011 for resolving filter view when user clicked on filter and see event detail and when come back, event list shows few other events too which are not belongs to last filtered category
	if (vieweventdetail != YES)	
	// end 8 june 2011	
		// added by pradeep on 15 feb 2011
		isfilterclick = NO;
	// added by pradeep on 8 june 2011 for resolving filter view when user clicked on filter and see event detail and when come back, event list shows few other events too which are not belongs to last filtered category
	else 
	{
		vieweventdetail = NO;
	}
	// end 8 june 2011	

	
	/*self.navigationItem.leftBarButtonItem.enabled = YES;
	[itemTableView setEditing:NO animated:YES];	
	editing = NO;*/
	if(arivefirsttime4event>0)
	{
	//*******************
		[self.view addSubview:imgBack];
		[self.view addSubview:activityView];
		activityView.hidden = NO;
		[self.view addSubview:loading];
		loading.hidden = NO;
		[activityView startAnimating];
	
		[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess4ChangedSegment) userInfo:self.view repeats:NO];		
	}
	else {
		[self startProcess4ChangedSegment];
	}

}

//*******************

// creating this method for displaying activityview when clicked on segment control
- (void)startProcess4ChangedSegment
{
	
	[self getDataFromFile];
	[self getDataFromFile4EventDistance];
	
	//int temp4arivefirsttime4event = 0;
	
	int selectedSegment = segmentedControl.selectedSegmentIndex;
	NSLog(@"segmentAction: selected segment = %d", selectedSegment);
	
	// for fixing bug, case: if user has navigate event feature from spring board once, it shows rec accordingly but again use event feature from spring board, record doesn't display :(
	
	if (!itemTableView)
	{
		if (whichsegmentselectedlasttime4event == segmentedControl.selectedSegmentIndex)
			arivefirsttime4event = 0;
		//arivefirsttime4event = 0;
	}
	
	//int temp4whichsegmentselectedlasttime4event = whichsegmentselectedlasttime4event;
	
	if(arivefirsttime4event==0)
	{
		arivefirsttime4event = 1;
		whichsegmentselectedlasttime4event = segmentedControl.selectedSegmentIndex;
		if (!allInterest1) // i.e. allInterest1=NO i.e. All tab is selected
		{
			//NSLog(@"for all events");
			if (selectedSegment==0)
			{
				[self getEventData:@"allevents" :@"all"];
				NSLog(@"0");
			}
			else if (selectedSegment==1)
			{
				NSLog(@"1");
				//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(rightbtn_OnClick)] autorelease];
				[self getEventData:@"bookmarkedevents" :@"future"];
			}
			else if (selectedSegment == 2)
			{
				[self getEventData:@"premiumevents" :@"future"];
				NSLog(@"2");
			}
		}
		
	} // close arivefirsttime4event if
	else 
	{
		if (whichsegmentselectedlasttime4event != segmentedControl.selectedSegmentIndex)
		{
			whichsegmentselectedlasttime4event = segmentedControl.selectedSegmentIndex;
			if (!allInterest1) // i.e. allInterest1=NO i.e. All tab is selected
			{
				//NSLog(@"for all events");
				if (selectedSegment==0)
				{
					//self.navigationItem.leftBarButtonItem.enabled = YES;
					//self.navigationItem.rightBarButtonItem = nil;
					[itemTableView setEditing:NO animated:YES];	
					editing = NO;
					[self getEventData:@"allevents" :@"all"];
					NSLog(@"0");
				}
				else if (selectedSegment==1)
				{
					NSLog(@"1");
					//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(rightbtn_OnClick)] autorelease];
					[self getEventData:@"bookmarkedevents" :@"future"];
				}				
				else if (selectedSegment == 2)
				{
					[self getEventData:@"premiumevents" :@"future"];
					NSLog(@"2");
				}
			}
			
			// added by pradeep on 24 dec 2010 for reinitializing eventtoggledateary when segment change
			//************
			//[self getdifferentdatesforsectionwhensegmentchange];
			[self getdifferentdatesforsectionwhensegmentchange:stories4cal];
			
			//************ end 24 dec 2010
			
		}
	}
	
	
	if (!itemTableView)
	{				
		//[self getPeopleData:@"notset"];
		// added if by pradeep on 11 feb 2011 
		//***********
		if (whichsegmentselectedlasttime4event == segmentedControl.selectedSegmentIndex)
			//******** end 11 feb
			[self getindexforscrollingtableview];
		
		if([stories4cal count] > 0)
		{
			itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, 320, 360) style:UITableViewStyleGrouped];
			itemTableView.delegate = self;
			itemTableView.dataSource = self;
			itemTableView.rowHeight = 55;
			itemTableView.autoresizesSubviews = YES;
			itemTableView.backgroundColor = [UIColor clearColor];
			//itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
			// for removing table's border
			itemTableView.separatorColor = [UIColor clearColor];
			[self.view addSubview:itemTableView];
			itemTableView.hidden=NO;
			
			/*itemTableView.delegate = self;
			itemTableView.dataSource = self;
			itemTableView.rowHeight = 115;
			itemTableView.backgroundColor = [UIColor clearColor];
			itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
			[self.view addSubview:itemTableView];*/
			
			[itemTableView reloadData];
			
			// for scrolling tableview at certain position
			//************************ start
			
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:currentindexforscrolltableview];
			[itemTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
			
			//************************ end
		}
	}
	else 
	{
		[itemTableView reloadData];
		[self.view addSubview:itemTableView];
		
		if ([stories4cal count] > 0)
		{
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:currentindexforscrolltableview];
			[itemTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
		}
	}
	// if no records found
	if ([stories4cal count] == 0)
	{
		// added if by pradeep on 15 feb 2011
		if (!recnotfound)
		{
		CGRect lableRecNotFrame = CGRectMake(30, 140, 260, 130);
			//Event not found for selected criteria
		recnotfound = [UnsocialAppDelegate createLabelControl:@"" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:6 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		}
			//recnotfound.hidden = NO;
		[self.view addSubview:recnotfound];
		//[recnotfound release];

		if (selectedSegment == 1)
		{
		
			recnotfound.text = @"You have no saved events to display. If you have an event you would like to save, simply go to event's detail page, click options, and then save.";
		}
		else if (selectedSegment == 2)
		{
			recnotfound.text = @"There are currently no premium events in your area. Try again later.";
		}
		else
		{
			recnotfound.text = @"There are currently no events in your area. Try again later.";
		}
	}
	else 
	{
			//recnotfound.hidden = YES;
			//recnotfound.text = @"";
	}
	
	// added by pradeep on 24 dec 2010 for reinitializing eventtoggledateary when segment change
	//************
	//if(arivefirsttime4event > 0)
		//[self getdifferentdatesforsectionwhensegmentchange];
	
	//************ end 24 dec 2010
	
	loading.hidden = YES;
	activityView.hidden = YES;
	[self.view addSubview:loading];
	loading.hidden = YES;
	[activityView stopAnimating];
	
	// commented on 14 dec 2010 for implementing event improvement i.e. calendar like awesome end
	//*********************************************
	[self.view addSubview:toolbar];
	[self.view addSubview:segmentedControl];
	
	// added by pradeeo on 14 dec for event improvement i.e. calendar
	
	
	[self.view addSubview:btnFilter];
}

- (void) getindexforscrollingtableview
{
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init]; 
	[dateFormatter1 setDateFormat:@"M/d/yyyy"];
	NSString *strdtdeep = [dateFormatter1 stringFromDate:today];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", strdtdeep];
	
	NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
	
	if ([filteredArray count] > 0)
	{
		for (int i = 0; i < [eventtoggledateary count]; i++) 
		{
			// for getting index to scroll tableview automatically first time
			if ([[eventtoggledateary objectAtIndex:i] isEqualToString:strdtdeep])
			{
				NSLog([NSString stringWithFormat:@"%d", i]);
				currentindexforscrolltableview = i;		
				break;
			}
		}
	}
	//if (currentindexforscrolltableview==0)
	else
	{
		for (int i = 0; i < [eventtoggledateary count]; i++) 
		{
			NSDate *futuredt = [[NSDate alloc] init];
			futuredt = [dateFormatter1 dateFromString:[eventtoggledateary objectAtIndex:i]];
			
			NSComparisonResult result = [today compare:futuredt];
			
			if(result==NSOrderedAscending)
			{
				NSLog(@"futuredt is in the future");
				NSLog([NSString stringWithFormat:@"%d", i]);
				currentindexforscrolltableview = i;
				break;
				
			}
			else if(result==NSOrderedDescending)
				NSLog(@"Date1 is in the past");
			else
				NSLog(@"Both dates are the same");
		
		}
		
	}
}


- (void) getdifferentdatesforsectionwhensegmentchange: (NSMutableArray *) tempstories4cal // since we have to change the calendar *(i.e. item exist for changed segment i.e. saved or around me) each item
{
	
	NSMutableArray *tempnsmutableary = [[NSMutableArray alloc]init];
	BOOL isalreadyexist = NO;
	
	/*for (int i = 0; i < [stories4cal count]; i++) 
	{
		isalreadyexist = NO;
		if ([tempnsmutableary count] > 0)
		{
			for (int j = 0; j < [tempnsmutableary count]; j++)
			{
				NSLog(@"tempnsmutableary: %@", [tempnsmutableary objectAtIndex:j]);
				NSLog(@"stories4cal: %@", [[stories4cal objectAtIndex:i] objectForKey:@"eventdate"]);
				if ([[tempnsmutableary objectAtIndex:j] isEqualToString:[[stories4cal objectAtIndex:i] objectForKey:@"eventdate"]])
				{
					isalreadyexist = YES;
					break;
				}
			}
			
			if (!isalreadyexist)
			{
				[tempnsmutableary addObject:[[stories4cal objectAtIndex:i] objectForKey:@"eventdate"]];
			}
		}
		else
		{
			 [tempnsmutableary addObject:[[stories4cal objectAtIndex:i] objectForKey:@"eventdate"]];
		}	 	 
			 
			 
	}
	
	[eventtoggledateary removeAllObjects];
	//eventtoggledateary = [NSMutableArray arrayWithArray:tempnsmutableary];
	[eventtoggledateary addObjectsFromArray:tempnsmutableary];
	 */
	
	//******* added by pradeep on 11 feb
	currentindexforscrolltableview =0;
	// ***** end 11 feb 2011
	
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init]; 
	[dateFormatter1 setDateFormat:@"M/d/yyyy"];
	NSString *strdtdeep = [dateFormatter1 stringFromDate:today];
	for (int i = 0; i < [tempstories4cal count]; i++) 
	{
		isalreadyexist = NO;
		if ([tempnsmutableary count] > 0)
		{
			for (int j = 0; j < [tempnsmutableary count]; j++)
			{
				//NSLog(@"tempnsmutableary: %@", [tempnsmutableary objectAtIndex:j]);
				//NSLog(@"stories4cal: %@", [[tempstories4cal objectAtIndex:i] objectForKey:@"eventdate"]);
				if ([[tempnsmutableary objectAtIndex:j] isEqualToString:[[tempstories4cal objectAtIndex:i] objectForKey:@"eventdate"]])
				{
					isalreadyexist = YES;
					break;
				}
			}
			
			if (!isalreadyexist)
			{
				[tempnsmutableary addObject:[[tempstories4cal objectAtIndex:i] objectForKey:@"eventdate"]];
				
				// for getting index to scroll tableview automatically first time
				if ([[tempnsmutableary objectAtIndex:([tempnsmutableary count]-1)] isEqualToString:strdtdeep])
					currentindexforscrolltableview = ([tempnsmutableary count]-1);
			}
			
			
				
		}
		else
		{
			[tempnsmutableary addObject:[[tempstories4cal objectAtIndex:i] objectForKey:@"eventdate"]];
			
			// for getting index to scroll tableview automatically first time
			if ([[tempnsmutableary objectAtIndex:([tempnsmutableary count]-1)] isEqualToString:strdtdeep])
				currentindexforscrolltableview = ([tempnsmutableary count]-1);
		}	 	 
		
		
	}
	
	// added by pradeep on 11 feb 2011 for fixing crash
	//************ 11 feb 2011
	if (currentindexforscrolltableview==0)
	{
		for (int i = 0; i < [tempnsmutableary count]; i++) 
		{
			NSDate *futuredt = [[NSDate alloc] init];
			futuredt = [dateFormatter1 dateFromString:[tempnsmutableary objectAtIndex:i]];
			
			NSComparisonResult result = [today compare:futuredt];
			
			if(result==NSOrderedAscending)
			{
				NSLog(@"futuredt is in the future");
				NSLog([NSString stringWithFormat:@"%d", i]);
				currentindexforscrolltableview = i;
				break;
				
			}
			else if(result==NSOrderedDescending)
				NSLog(@"Date1 is in the past");
			else
				NSLog(@"Both dates are the same");
			
		}
	}
	
	[eventtoggledateary removeAllObjects];
	//eventtoggledateary = [NSMutableArray arrayWithArray:tempnsmutableary];
	[eventtoggledateary addObjectsFromArray:tempnsmutableary];
	
		
}


- (BOOL) getDataFromFile4EventDistance {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"setMilesForEvents"];
	
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
		
		
		localdistance = [[tempArray objectAtIndex:0] setMilesForEvents];
		
		[decoder finishDecoding];
		[decoder release];
		return YES;
	}
	else {
		localdistance = @"1";
		return NO;
	}
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
		
		//for setting global variables
		NSLog(@"%@", [[tempArray objectAtIndex:0] userid]);
		gbluserid = [[tempArray objectAtIndex:0] userid];
		//arrayForUserID = [[NSMutableArray alloc]init];
		if ([arrayForUserID count]==0)
		[arrayForUserID addObject:[[tempArray objectAtIndex:0] userid]];
		
		[decoder finishDecoding];
		[decoder release];	
		
		return YES;		
		
		
	}
	else { //just in case the file is not ready yet.
		return NO;
	}
}

- (void) getEventData:(NSString *) eventflg: (NSString *) eventsubflg {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	// Time Formats
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];

	gbluserid = [arrayForUserID objectAtIndex:0];
	
	NSLog(@"Sending....");
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&distance=%@&eventflag=%@&eventsubflag=%@",@"getevents",gbllatitude,gbllongitude,gbluserid,usertime,localdistance,eventflg,eventsubflg];
	urlString = [globalUrlString stringByAppendingString:urlString];
	
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
}

- (void)parseXMLFileAtURL:(NSString *)URL {
	//stories = [[NSMutableArray alloc] init];
	
	stories = [[NSMutableArray alloc] init];
	
	stories4cal = [[NSMutableArray alloc] init];
	
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
	imageURLs4Lazy = [[NSMutableArray alloc]init];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Error retrieving latest updates. Your internet connection may be down."];
	NSLog(@"error parsing XML: %@", errorString);	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		eventid = [[NSMutableString alloc] init];
		eventname= [[NSMutableString alloc] init];
		eventdesc = [[NSMutableString alloc] init];
		eventaddress = [[NSMutableString alloc] init];
		eventindustry = [[NSMutableString alloc] init];
		eventdate = [[NSMutableString alloc] init];
		eventdateto = [[NSMutableString alloc] init];
		fromtime = [[NSMutableString alloc] init];
		eventtype = [[NSMutableString alloc] init];
		
		totime = [[NSMutableString alloc] init];
		eventcontact = [[NSMutableString alloc] init];
		eventwebsite = [[NSMutableString alloc] init];
		eventlatitude = [[NSMutableString alloc] init];
		eventlongitude = [[NSMutableString alloc] init];
		isrecurring = [[NSMutableString alloc] init];
		eventcurrentdistance = [[NSMutableString alloc] init];
	}
	if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		// save values to an item, then store that item into the array...
		//[item setObject:userprefix forKey:@"prefix"];
		[item setObject:eventid forKey:@"guid"];
		[item setObject:eventname forKey:@"eventname"]; 
		[item setObject:eventdesc forKey:@"eventdescription"]; // for blog description also date but not rite now
		[item setObject:eventaddress forKey:@"eventaddress"];
		
		[item setObject:eventindustry forKey:@"eventindustry"];
		[item setObject:eventdate forKey:@"eventdate"];
		[item setObject:eventdateto forKey:@"eventdateto"];
		[item setObject:fromtime forKey:@"fromtime"];
		[item setObject:totime forKey:@"totime"];
		[item setObject:eventcontact forKey:@"eventcontact"];
		[item setObject:eventwebsite forKey:@"eventwebsite"];
		[item setObject:eventlongitude forKey:@"eventlongitude"];
		[item setObject:eventlatitude forKey:@"eventlatitude"];
		
		[item setObject:isrecurring forKey:@"isrecurring"];
		[item setObject:eventcurrentdistance forKey:@"currentdistance"];
		[item setObject:eventtype forKey:@"eventtype"];
		
		//add the actual image as well right now into the stories array
		
		/*NSURL *url = [NSURL URLWithString:currentImageURL];		
		NSString *searchForMe = @"eventimgnotavailable.png";
		NSRange range = [currentImageURL rangeOfString:searchForMe];// [searchThisString rangeOfString : searchForMe];
		// if image exist for user then use it else use default img locally for event
		if (range.location == NSNotFound) 
		{
			NSLog(@"Thumbnail Image exist for this event.");
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *y1 = [[UIImage alloc] initWithData:data];
			if (y1) {
				[item setObject:y1 forKey:@"itemPicture"];		
			}
		}
		else
		{
			UIImage *y1 = [UIImage imageNamed: @"dashnoevent.png"];;
			//if (y1) {
			[item setObject:y1 forKey:@"itemPicture"];	
		}*/
		[imageURLs4Lazy addObject:currentImageURL];
		//[stories addObject:[item copy]];
		//NSLog(@"adding story: %@", eventname);
		
		[stories4cal addObject:[item copy]];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"guid"]) {
		[eventid appendString:string];
	}else if ([currentElement isEqualToString:@"eventname"]) {
		[eventname appendString:string];
	}else if ([currentElement isEqualToString:@"eventdescription"]) {
		[eventdesc appendString:string];
	} 
	
	else if ([currentElement isEqualToString:@"eventaddress"]) {
		[eventaddress appendString:string];
	}else if ([currentElement isEqualToString:@"eventaddress"]) {
		[eventaddress appendString:string];
	}else if ([currentElement isEqualToString:@"eventindustry"]) {
		[eventindustry appendString:string];
	}else if ([currentElement isEqualToString:@"eventdate"]) {
		[eventdate appendString:string];
	}else if ([currentElement isEqualToString:@"eventdateto"]) {
		[eventdateto appendString:string];
	}else if ([currentElement isEqualToString:@"fromtime"]) {
		[fromtime appendString:string];
	}else if ([currentElement isEqualToString:@"totime"]) {
		[totime appendString:string];
	}else if ([currentElement isEqualToString:@"eventcontact"]) {
		[eventcontact appendString:string];
	}else if ([currentElement isEqualToString:@"eventwebsite"]) {
		[eventwebsite appendString:string];
	}else if ([currentElement isEqualToString:@"eventlongitude"]) {
		[eventlongitude appendString:string];
	}else if ([currentElement isEqualToString:@"eventlatitude"]) {
		[eventlatitude appendString:string];
	}else if ([currentElement isEqualToString:@"isrecurring"]) {
		[isrecurring appendString:string];
	}else if ([currentElement isEqualToString:@"currentdistance"]) {
		[eventcurrentdistance appendString:string];
	}else if ([currentElement isEqualToString:@"eventtype"]) {
		[eventtype appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {		
	NSLog(@"all done!");
	//NSLog(@"stories array has %d items", [stories count]);
	loading.hidden = YES;
	//[itemTableView reloadData];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	 NSInteger row = [indexPath row];
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	

	// lazy img implementation by pradeep
	//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
	}
	else {
		AsyncImageView* oldImage = (AsyncImageView*)
		[cell.contentView viewWithTag:999];
		[oldImage removeFromSuperview];
	}
	
	cell.backgroundColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	//cell.
	
    // Set up the cell...	
	UIImageView *imgPplBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 0, 310, 55) imageName:@"eventrowback.png"];
	[cell.contentView addSubview:imgPplBack];
	//cell.backgroundView = nil;
	
	
	/*if (indexPath.section == 0)
	{		
		//[cell.contentView addSubview:lblUserName];
		if (row == 0)
		{*/
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [eventtoggledateary objectAtIndex:indexPath.section]];
	
	// ********* commented by pradeep on 15 feb 2011
	/*NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
	
	NSMutableArray *temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray];
	
	
	[stories removeAllObjects];
	
	[stories addObjectsFromArray:temp4filterary2];
	 */
	// ******* 15 feb 2011 commented end
	
	//*************** 15 feb 2011 start by pradeep
	
	 
	// added by pradeep on 15 feb 2011 for fixing issue of filter btn mentioned in RTH as 00244 
	// ******* 15 feb 2011 start
	NSArray *filteredArray; 
	NSMutableArray *temp4filterary2;
	if (isfilterclick == NO)
	{
		filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
		
		temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray];
		
		
		//[stories removeAllObjects];
		
		//[stories addObjectsFromArray:temp4filterary2];
	}
	else
	{
		filteredArray = [stories filteredArrayUsingPredicate:predicate];
		temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray];
	}
	
	// ******* 15 feb 2011 3nd
	
	//*************** 15 feb 2011 end by pradeep
	
	//NSLog(@"total items in story: %d", [stories count]);
	//NSLog(@"filteredArray eventname: %@", [[stories objectAtIndex:indexPath.row] objectForKey:@"eventname"]);
	//NSLog(@"filteredArray guid: %@", [[stories objectAtIndex:indexPath.row] objectForKey:@"guid"]);
	//NSLog(@"filteredArray isrecurring i.e. image url: %@", [[stories objectAtIndex:indexPath.row] objectForKey:@"isrecurring"]);
	
	// commented by pradeep on 16 dec 2010 and added new one below
	//NSURL*url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
	
	// commented and added  by pradeep on 31 jan 2011 for displaying live now image for premium events
	// 31 jan 2011 start******************
	//NSURL*url = [NSURL URLWithString:[[stories objectAtIndex:indexPath.row] objectForKey:@"isrecurring"]];
	NSURL *url;
	
	
	// ********* commented by pradeep on 15 feb 2011
	/*if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
	{
		url = [NSURL URLWithString:[globalUrlString stringByAppendingString:@"/images/dashlive.png"]];
	}
	else 
	{
		// commented by pradeep on 9 feb 2011 for changing images according to event industry 		
		// url = [NSURL URLWithString:[[stories objectAtIndex:indexPath.row] objectForKey:@"isrecurring"]];
		
		// added by pradeep on 9 feb 2011 for changing images according to event industry
		if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] isEqualToString:@"Business"])
		{
			url = [NSURL URLWithString:[globalUrlString stringByAppendingString:@"/images/business.png"]];
		}
		else if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] isEqualToString:@"Social"])
		{
			url = [NSURL URLWithString:[globalUrlString stringByAppendingString:@"/images/social.png"]];
		}
		else if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] isEqualToString:@"Technology"])
		{
			url = [NSURL URLWithString:[globalUrlString stringByAppendingString:@"/images/technology.png"]];
		}
		else {
			url = [NSURL URLWithString:[globalUrlString stringByAppendingString:@"/images/dashevents.png"]];
		}
		
		// ********* end 9 feb 2011
		// end by pradeep on 9 feb 2011 for changing images according to event industry
	}*/
	// ***** 15 feb 2011 commneted end
	
	// ****** 15 feb 2011 added by pradeep start
	
	if ([[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
	{
		url = [NSURL URLWithString:[globalUrlString stringByAppendingString:@"/images/dashlive.png"]];
	}
	else 
	{
		// commented by pradeep on 9 feb 2011 for changing images according to event industry 		
		// url = [NSURL URLWithString:[[stories objectAtIndex:indexPath.row] objectForKey:@"isrecurring"]];
		
		// added by pradeep on 9 feb 2011 for changing images according to event industry
		if ([[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] isEqualToString:@"Business"])
		{
			url = [NSURL URLWithString:[globalUrlString stringByAppendingString:@"/images/business.png"]];
		}
		else if ([[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] isEqualToString:@"Social"])
		{
			url = [NSURL URLWithString:[globalUrlString stringByAppendingString:@"/images/social.png"]];
		}
		else if ([[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] isEqualToString:@"Technology"])
		{
			url = [NSURL URLWithString:[globalUrlString stringByAppendingString:@"/images/technology.png"]];
		}
		else {
			url = [NSURL URLWithString:[globalUrlString stringByAppendingString:@"/images/dashevents.png"]];
		}
		
		// ********* end 9 feb 2011
		// end by pradeep on 9 feb 2011 for changing images according to event industry
	}
	
	//* ****** 15 feb 2011 code end
	
	// end 31 jan 2011
	
	
	// added by pradeep on 16 dec 2010 for event improvenent i.e. calendar
	//************* end
		
	CGRect frame;
	frame.size.width = 40;
	frame.size.height = 40;
	frame.origin.x = 9; 
	frame.origin.y = 5;
	asyncImage = [[[AsyncImageView alloc]
				   initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	
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
	
	#pragma mark EVENT NAME STARTS	
	
	CGRect lableNameFrame = CGRectMake(60, 5, 220, 15);	
	lblEvent = [UnsocialAppDelegate createLabelControl:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventname"] frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:13 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblEvent];
	/*EVENT NAME ENDS*/
	
	// event from date
	/*
	NSArray *split = [[[stories objectAtIndex:indexPath.row] objectForKey:@"eventdate"]componentsSeparatedByString:@" "];
	NSString *eventdt = [NSString stringWithFormat:@"%@",[split objectAtIndex:0]];
	
	// event to date
	NSArray *split2 = [[[stories objectAtIndex:indexPath.row] objectForKey:@"eventdateto"]componentsSeparatedByString:@" "];
	NSString *eventdt2 = [NSString stringWithFormat:@"%@",[split2 objectAtIndex:0]];
	
	#pragma mark EVENT DATE STARTS
	CGRect lableDateFrame = CGRectMake(lableNameFrame.origin.x, 30, 100, 15);
	lblEventDt = [UnsocialAppDelegate createLabelControl:@"Date:" frame:lableDateFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblEventDt];
	
	//lblEventDt = [UnsocialAppDelegate createLabelControl:eventdt frame:CGRectMake(lableNameFrame.origin.x, lableDateFrame.origin.y + 12, 100, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	//changed by pradeep on 28 july 2010 according to icheena ID 31
	lblEventDt = [UnsocialAppDelegate createLabelControl:eventdt frame:CGRectMake(lableNameFrame.origin.x+40, 30, 70, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	[cell.contentView addSubview:lblEventDt];
	
	// event to date
	
	lblEventDt = [UnsocialAppDelegate createLabelControl:@"to" frame:CGRectMake(lableNameFrame.origin.x+115, 30, 20, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	[cell.contentView addSubview:lblEventDt];
	
	lblEventDt = [UnsocialAppDelegate createLabelControl:eventdt2 frame:CGRectMake(lableNameFrame.origin.x+140, 30, 100, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kEventTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	[cell.contentView addSubview:lblEventDt];*/
	
	/*EVENT DATE ENDS*/
	
	#pragma mark EVENT DATE FROM STARTS
	CGRect lablefromFrame = CGRectMake(lableNameFrame.origin.x, lableNameFrame.origin.y + 15, 25, 15);	
	lblEventDtFrom = [UnsocialAppDelegate createLabelControl:@"At:" frame:lablefromFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDtFrom];
	
	lblEventDtFrom = [UnsocialAppDelegate createLabelControl:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"fromtime"] frame:CGRectMake(lablefromFrame.origin.x + 20, lablefromFrame.origin.y, 70, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDtFrom];
	/*EVENT DATE FROM ENDS*/
	
	#pragma mark EVENT DATE TO STARTS
	CGRect lableToFrame = CGRectMake(lablefromFrame.origin.x + 80, lablefromFrame.origin.y, 90, 15);
	lblEventDtTo = [UnsocialAppDelegate createLabelControl:@"To:" frame:lableToFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDtTo];

	lblEventDtTo = [UnsocialAppDelegate createLabelControl:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"totime"] frame:CGRectMake(lableToFrame.origin.x + 22, lableToFrame.origin.y, 90, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblEventDtTo];
	/*EVENT DATE TO ENDS*/

	#pragma mark EVENT INDUSTRY
	CGRect lableIndFrame = CGRectMake(lableNameFrame.origin.x, lblEventDtFrom.origin.y + 15, 200, 15);	
	// commented and added  by pradeep on 31 jan 2011 for displaying industry as "Premium event" for premium events
	// 31 jan 2011 start******************
	//lblEventInd = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] frame:lableIndFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	if ([[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
	{
		lblEventInd = [UnsocialAppDelegate createLabelControl:@"Premium Event" frame:lableIndFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	}
	else {
		lblEventInd = [UnsocialAppDelegate createLabelControl:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] frame:lableIndFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	}
	// end 31 jan 2011 ************	
	[cell.contentView addSubview:lblEventInd];
	
	#pragma mark EVENT DISTANCE STARTS
	// commented by pradeep on 8 feb 2011 for changing the x-axis co-ordinates
	//CGRect lableDistanceFrame = CGRectMake(9, lblEventDtFrom.origin.y + 15, 300, 15);
	CGRect lableDistanceFrame = CGRectMake(-10, lblEventDtFrom.origin.y + 15, 290, 15);
	/*
	lblEventDistance = [UnsocialAppDelegate createLabelControl:@"Distance:" frame:lableDistanceFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDistance];
	 */
	lblEventDistance = [UnsocialAppDelegate createLabelControl:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"currentdistance"] frame:lableDistanceFrame txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblEventDistance];
	/*EVENT DISTANCE ENDS*/
	
	#pragma mark Check Event Type
	// commented by pradeep on 8 feb 2011 for removing preeventicon.png for premium events i.e. zic-zag image
	/* 8 feb 2011 start ************
	if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
	{
		
		premiumeventico = [UnsocialAppDelegate createImageViewControl:CGRectMake(268, 8, 21, 25) imageName:@"preeventicon.png"]; // CGRectMake(280, 8, 21, 25) changed by pradeep on 1 feb 2011 since zigma image is overlapping on carrot sign
		[cell.contentView addSubview:premiumeventico];
	}*/ 
	// 8 feb 2011 end ************
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [eventtoggledateary count];
}

// for creating customize title for header section in grouped table added by pradeep on 24 dec 2010
//*********************

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 20.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:15];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 20.0);
	
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	
	//headerLabel.text = <Put here whatever you want to display> // i.e. array element
	
	
	//NSString *title = @"";
	
	headerLabel.text = [NSString stringWithFormat:@"%@", [eventtoggledateary objectAtIndex:section]];
	
	/*if (section == 0)
		headerLabel.text = @"Popular tags";
	else if (section == 1) 
		headerLabel.text = @"Your recent searches";*/
	
	[customView addSubview:headerLabel];
	//return title;
	
	return customView;
}

// add heightForHeaderInSection function added by pradeep on 24 dec 2010
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 20.0;
}

//*********************


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	/*if (section == 0)
        return [stories count];
	else if (section == 1)
		return [aryRecentSearchTags count]; //3;//[stories count];*/
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [eventtoggledateary objectAtIndex:section]];
	
	// commented by pradeep on 15 feb 2011 for fixing issue of filter btn mentioned in RTH as 	00244 
	//NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
	// added by pradeep on 15 feb 2011 for fixing issue of filter btn mentioned in RTH as 00244 
	// ******* 15 feb 2011 start
	NSArray *filteredArray; 
	if (isfilterclick == NO)
		filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
	else filteredArray = [stories filteredArrayUsingPredicate:predicate];
	
	// ******* 15 feb 2011 3nd
	
	NSMutableArray *temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray];
		
	return [temp4filterary2 count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	// added by pradeep on 16 dec 2010 for event improvenent i.e. calendar
	//************* start	
	
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:segmentedControlcal.selectedSegmentIndex]];
	
	//NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
	
	//stories = [NSMutableArray arrayWithArray:filteredArray];
	
	//stories = [[NSArray alloc] init];
	
	//stories = [stories4cal filteredArrayUsingPredicate:predicate];
	
	// added by pradeep on 16 dec 2010 for event improvenent i.e. calendar
	//************* end
	
	//if (indexPath.section == 0)
	
	//*************
	
	// added by pradeep on 8 june 2011 for resolving filter view when user clicked on filter and see event detail and when come back, event list shows few other events too which are not belongs to last filtered category
	vieweventdetail = YES;
	
	// end 8 june 2011
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [eventtoggledateary objectAtIndex:indexPath.section]];
	
	// commented by pradeep on 15 feb 2011
	// 15 feb 2011 start ******
	/*
	 NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
	
	NSMutableArray *temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray];
	 */
	// 15 feb commented end
	
	//**** 15 feb 2011 added by pradeep start
	// added by pradeep on 15 feb 2011 for fixing issue of filter btn mentioned in RTH as 00244 
	// ******* 15 feb 2011 start
	NSArray *filteredArray; 
	NSMutableArray *temp4filterary2;
	if (isfilterclick == NO)
	{
		filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
		
		temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray];
		
		
		//[stories removeAllObjects];
		
		//[stories addObjectsFromArray:temp4filterary2];
	}
	else
	{
		filteredArray = [stories filteredArrayUsingPredicate:predicate];
		temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray];
	}
	
	// ******* 15 feb 2011 end
	// ***** 15 feb 2011 code end
	
	
	//[stories removeAllObjects];
	
	//[stories addObjectsFromArray:temp4filterary2];
	
	//*************
	
		
	aryEventDetails = [[NSMutableArray alloc]init];
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"guid"]]; //0
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventname"]]; //1
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventdescription"]]; //2
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventaddress"]]; //3
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventindustry"]];//4
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventdate"]];//5
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"fromtime"]];//6
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"totime"]];//7
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventcontact"]];//8
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventwebsite"]];//9
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"isrecurring"]];//10
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventtype"]];//11
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"currentdistance"]];//12
	[aryEventDetails addObject:[NSString stringWithFormat:@"%i",1]]; // 13 comingfrom
	[aryEventDetails addObject:[NSString stringWithFormat:@"%i",segmentedControl.selectedSegmentIndex]]; // 14
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventlongitude"]];//15
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventlatitude"]];//16
	
	
	//UIImage *eImage = [[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	//if(eImage)
	//	[aryEventDetails addObject:eImage];//17
	
	//******************** for lazi img start
	
	//NSURL *url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
	
		
	// commented by pradeep on 16 dec 2010 and added new one below
	//[aryEventDetails addObject:[imageURLs4Lazy objectAtIndex:indexPath.row]];//17
	
	// commented by pradeep on 9 feb 2011 and added for event detail page image
	// **************** start 9 feb 2011
	//[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"isrecurring"]];//17
	
	//******************** for lazi img end	
	
	// added by pradeep on 9 feb 2011 for changing images according to event industry
	//NSURL *url;
	if ([[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
	{		
		[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"isrecurring"]];//17
	}
	else 
	{
		// here we are adding our fixed image url for 3 types of event industry i.e. Business, Social, Technology. Comment added by pradeep on 10 feb 2011
		if ([[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] isEqualToString:@"Business"])
		{			
			[aryEventDetails addObject:[globalUrlString stringByAppendingString:@"/images/business.png"]];//17
		}
		else if ([[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] isEqualToString:@"Social"])
		{
			[aryEventDetails addObject:[globalUrlString stringByAppendingString:@"/images/social.png"]];//17
		}
		else if ([[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] isEqualToString:@"Technology"])
		{
			[aryEventDetails addObject:[globalUrlString stringByAppendingString:@"/images/technology.png"]];//17
		}
		else 
		{
			[aryEventDetails addObject:[globalUrlString stringByAppendingString:@"/images/dashevents.png"]];//17
		}
	}
	
	// ********* end 9 feb 2011
		
	//******************** for lazi img end
	[aryEventDetails addObject:[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventdateto"]];//18

	
	
	/*eventDetails.eventid = [[stories objectAtIndex:indexPath.row] objectForKey:@"guid"];
	eventDetails.eventname = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventname"];
	eventDetails.eventdesc = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventdescription"];
	eventDetails.eventaddress = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventaddress"];
	eventDetails.eventindustry = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"];
	eventDetails.eventdate = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventdate"];
	eventDetails.fromtime = [[stories objectAtIndex:indexPath.row] objectForKey:@"fromtime"];
	eventDetails.totime = [[stories objectAtIndex:indexPath.row] objectForKey:@"totime"];
	eventDetails.eventcontact = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventcontact"];
	eventDetails.eventwebsite = [[stories objectAtIndex:indexPath.row] objectForKey:@"eventwebsite"];
	eventDetails.isrecurring = [[stories objectAtIndex:indexPath.row] objectForKey:@"isrecurring"];
	eventDetails.eventcurrentdistance = [[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"];
//	eventDetails.eventImage = [[stories objectAtIndex:indexPath.row] objectForKey:@"image"];
	eventDetails.fromwhichsegment = [NSString stringWithFormat:@"%i",segmentedControl.selectedSegmentIndex];
	eventDetails.eventtype =[[stories objectAtIndex:indexPath.row] objectForKey:@"eventtype"];
	eventDetails.comingfrom = 1;*/	
	
	// added by pradeep on 16 dec 2010 for cal feature
	if ([[[temp4filterary2 objectAtIndex:indexPath.row] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
	{
		SponsoredSplash *eventDetails = [[SponsoredSplash alloc] init];
		//eventDetails.calendarselectedindex = [NSString stringWithFormat:@"%d",segmentedControlcal.selectedSegmentIndex];
		
		//whichsegmentselectedlasttime4cal = segmentedControlcal.selectedSegmentIndex;
			//****** added by pradeep on 17 dec 2010 start
		startLogicSponSplashCameFrom = [[NSMutableArray alloc] init];
		[startLogicSponSplashCameFrom addObject:@"eventlist"];		
		[self.navigationController pushViewController:eventDetails animated:YES];
	}
	else 
	{
		EventDetails *eventDetails = [[EventDetails alloc]init];
		//whichsegmentselectedlasttime4cal = segmentedControlcal.selectedSegmentIndex;
		[self.navigationController pushViewController:eventDetails animated:YES];
	}

	
	
}

// Override to support editing the table view.
// not in use added by pradeep 15 feb 2011
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// Delete the row from the data source
		[self sendReqForDeleteSavedEvent:indexPath.row];
		
		// added by pradeep on 18 dec 2010 for event improvenent i.e. calendar
		//************* start	
		
		//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:segmentedControlcal.selectedSegmentIndex]];
		//NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
		
		//stories = [NSMutableArray arrayWithArray:filteredArray];		
		
		// ********** end 18 dec 2010
		
		[stories removeObjectAtIndex:indexPath.row];
		[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		if([stories count] == 0)
		{
			NSString *nomsg = @"";
			nomsg = @"You have no saved events to display. If you have an event you would like to save, simply go to event's detail page, click options, and then save.";
			recnotfound = [UnsocialAppDelegate createLabelControl:nomsg frame:CGRectMake(30, 140, 260, 130) txtAlignment:UITextAlignmentCenter numberoflines:6 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			recnotfound.hidden = NO;
			[self.view addSubview:recnotfound];
			[recnotfound release];
			//self.navigationItem.rightBarButtonItem = nil;
			//self.navigationItem.leftBarButtonItem.enabled = YES;
		}
	}
}
 */

// Override to support conditional editing of the table view.
/*- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
 return UITableViewCellAccessoryDisclosureIndicator;
 }

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// Delete the row from the data source
		[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
	}   
}*/

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
