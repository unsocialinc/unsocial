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

BOOL allInterest = NO;
NSString *localuserid, *localdistance;
int whichsegmentselectedlasttime4event;
int arivefirsttime4event;
int landfrm;
int backfrmeventdetail;

//int freemmry;


// added by pradeep on 16 dec 2010 for calendar
int whichsegmentselectedlasttime4cal;
int arivefirsttime4cal;

@implementation Events
@synthesize comingfrom, toolbar;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(createControls) userInfo:self.view repeats:NO];
}

- (void) viewDidLoad
{
	NSLog(@"call view did load");
	
	arivefirsttime4event = 0;
	arivefirsttime4cal = 0;
	whichsegmentselectedlasttime4cal = 0;
	whichsegmentselectedlasttime4event = 0;
	backfrmeventdetail = 0;

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
	
	//********************
	
	// added by pradeep on 24 dec 2010 for adding "List" btn for toggle between list and dairy for event enhancement feature
	
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(rightbtn_OnClick)] autorelease];
	
	UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(287.0, 0.0, 33, 30)];
	[rightbtn setImage:[UIImage imageNamed:@"list5lines.png"] forState:(UIControlState) nil];
	[rightbtn addTarget:self action:@selector(rightbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
	self.navigationItem.rightBarButtonItem = rightbtnitme;
	
	//********************
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	//events = [[Events alloc]init];
	
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
	
	if(!allInterest) {
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
		
		// added if condition by pradeep on 27 jan 2011 for fixing bug
		//******************* start 27 jan 2011
		if(arivefirsttime4event==0)
		{
			if(gblTotalnumberofsponevents != 0)
			{
				//segmentedControl.selectedSegmentIndex = 2;
				whichsegmentselectedlasttime4event = 2;
			}			
		}
		segmentedControl.selectedSegmentIndex = whichsegmentselectedlasttime4event;
		// ******************* end 27 jan 2011
		
		// commented by pradeep on 27 jan 2011
		//segmentedControl.selectedSegmentIndex = whichsegmentselectedlasttime4event;
		
		//[self.view addSubview:segmentedControl];	
		
	}
	
	
	
	
	//[activityView stopAnimating];
	//activityView.hidden = YES;
	
#pragma mark Calendar
	// adeed if condition by pradeep on 31 jan 2011 for fixing issue of overlapping scrollview on itself when user come back to event from event list section
	if (!scrollView)
	{
		CGRect frame= CGRectMake(0, 18, 320.0, 67); // added by pradeep on 28 jan 2011 increase height of scrollview from 57 to 67
		scrollView=[[UIScrollView alloc] initWithFrame:frame];
		scrollView.contentSize=CGSizeMake(7680, 67); // 8000, 9600
		scrollView.delegate = self;
		scrollView.decelerationRate = 0.0f;
		scrollView.pagingEnabled = YES;
		
		// do any further configuration to the scroll view
		// add a view, or views, as a subview of the scroll view.
		
		// release scrollView as self.view retains it	
		scrollView.backgroundColor = [UIColor clearColor];
		scrollView.showsHorizontalScrollIndicator = FALSE;
		
	}
	[self.view addSubview:scrollView];
	//[scrollView release]; 
	
	if (arivefirsttime4cal == 0)
		[self get120days];
	
	//NSArray *itemArray = [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", @"5",@"6", @"7",@"8", @"9",@"10", @"11",@"12", @"13",@"14", @"15",@"16", @"17", @"18", @"19", @"20",@"21", @"22",@"23", @"24",@"25", @"26",@"27", @"28",@"29", @"30", nil];
	
	// explanation of calculation of current date for calendar
	// since total width of calendar = 7680
	// total items in calendar = 120 (i.e. 4 months)
	// so, width of 1 item = 7680/120 = 64
	// total items display one time = 5
	// i.e. total width of 5 items = 320 i.e. device screen's width
	
	// first time current date is displying i.e. 30th item of calendar
	// i.e. it will be start at 1920 on calendar i.e. 320 (5 tiems width) * 6 = 1920
	
	segmentedControlcal = [[UISegmentedControl alloc] initWithItems:imgArray];
	// 8 feb 2011 by pradeep
	//segmentedControlcal.frame = CGRectMake(0, 12, 7680, 95);
	segmentedControlcal.frame = CGRectMake(0, 0, 7680, 115);
	
	//**************
	segmentedControlcal.segmentedControlStyle = UISegmentedControlStyleBar;	
	//**************
	
	//segmentedControlcal.segmentedControlStyle = UISegmentedControlStylePlain;
	if (arivefirsttime4cal == 0)
	{
		segmentedControlcal.selectedSegmentIndex = 30;
		whichsegmentselectedlasttime4cal = 30;
		[self pickOneDate];
	}
	else segmentedControlcal.selectedSegmentIndex = whichsegmentselectedlasttime4cal;
	//segmentedControl.
	[segmentedControlcal addTarget:self action:@selector(pickOneDate)forControlEvents:UIControlEventValueChanged];
	segmentedControlcal.backgroundColor = [UIColor clearColor];
	[segmentedControlcal setTintColor:[UIColor colorWithRed:201.0/255.0 green:193.0/255.0 blue:181.0/255.0 alpha:1.0]];
	//[segmentedControlcal setTintColor:[UIColor whiteColor]];
	//segmentedControlcal.tintColor = [UIColor colorWithRed:201.0/255.0 green:193.0/255.0 blue:181.0/255.0 alpha:0.5];
	
	//segmentedControlcal.tintColor = [UIColor colorWithRed:240/255.0 green:141/255.0 blue:60/255.0 alpha:1.0];
	[scrollView addSubview:segmentedControlcal];
	if (arivefirsttime4cal == 0)
	{
		scrollView.contentOffset = CGPointMake(1920.0, 0.0); // 1998 2400.0
		arivefirsttime4cal = 1;
	}
	else {
		
		//scrollView.contentOffset = CGPointMake(1920.0, 0.0); // 1998 2400.0
		// for calculating start x-axis location for last selected calendar item
		int iteminwhichpage = segmentedControlcal.selectedSegmentIndex/5;
		iteminwhichpage = iteminwhichpage*5;
		int startxloc = iteminwhichpage*64; // 64 is the width of one item in calendar
		scrollView.contentOffset = CGPointMake(startxloc, 0.0); // 1998 2400.0
	}
	
	[segmentedControlcal release];
	
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object
	//caltop = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 0, 320, 30) imageName:@"caltop.png"];	
	caltop = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(0, 0, 320, 30) imageName:@"caltop.png"];
	// end 3 august 2011
	
	[self.view addSubview:caltop];
	CGRect lblframe = CGRectMake(12, 1, 190, 25);
	lblMonthYear = [[UILabel alloc] initWithFrame:lblframe];
	//lblMonthYear.text = [monthDisp objectAtIndex:30];
	lblMonthYear.text = [NSString stringWithFormat:@"%@ %@",[monthDisp objectAtIndex:whichsegmentselectedlasttime4cal], [yearDisp objectAtIndex:whichsegmentselectedlasttime4cal]];
	
	//[[[monthDisp objectAtIndex:whichsegmentselectedlasttime4cal] stringByAppendingString:@" "] stringByAppendingString:[yearDisp objectAtIndex:whichsegmentselectedlasttime4cal]];
	lblMonthYear.textAlignment = UITextAlignmentCenter;
	[lblMonthYear setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
	lblMonthYear.textColor = [UIColor whiteColor];
	lblMonthYear.backgroundColor = [UIColor clearColor];
	[self.view addSubview:lblMonthYear];
	
	//*****************
	kNumberOfPages = 120/5;
	
	//*****************
	
	/*if (gbllatitude	!= nil)
	 {segmentedControl.selectedSegmentIndex = whichsegmentselectedlasttime4event;
	 }*/
}

//*****************

- (void)btnFilter_Onclick {
	
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
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:segmentedControlcal.selectedSegmentIndex]];
		
		NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
		
		NSMutableArray *temp4filterary = [NSMutableArray arrayWithArray:filteredArray];
		
		NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(eventindustry ==  %@)", @"Premium"];
		
		NSArray *filteredArray2 = [temp4filterary filteredArrayUsingPredicate:predicate2];
		
		NSMutableArray *temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray2];
		
		//stories = [NSMutableArray arrayWithArray:filteredArray2];
		
		//self.list = [[NSMutableArray alloc] init];
		
		[stories removeAllObjects];
		
		[stories addObjectsFromArray:temp4filterary2];
		
		
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
				itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, 320, 282) style:UITableViewStylePlain]; // added by pradeep on 28 jan 2011 increase y-axis position from 78 to 88 also change height of table from 292 to 282
				itemTableView.delegate = self;
				itemTableView.dataSource = self;
				itemTableView.rowHeight = 57;
				itemTableView.backgroundColor = [UIColor clearColor];
				itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
				[self.view addSubview:itemTableView];
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
			CGRect lableRecNotFrame = CGRectMake(30, 160, 260, 130);
			//Event not found for selected criteria
			if(!recnotfound) {
				
				recnotfound = [UnsocialAppDelegate createLabelControl:@"" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:6 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			}
			recnotfound.hidden = NO;
			if (segmentedControl.selectedSegmentIndex == 1)
				recnotfound.text = @"You have no saved events to display. If you have an event you would like to save, simply go to event's detail page, click options, and then save.";
			else if (segmentedControl.selectedSegmentIndex == 2)
				recnotfound.text = @"There are currently no premum events in your area. Try again later.";
			else
				recnotfound.text = @"There are currently no events in your area. Try again later.";
		}
		else 
		{
			recnotfound.hidden = YES;
			recnotfound.text = @"";
		}
		[self.view addSubview:recnotfound];
		//[recnotfound release];
		
		loading.hidden = YES;
		activityView.hidden = YES;
		[self.view addSubview:loading];
		loading.hidden = YES;
		[activityView stopAnimating];
		[self.view addSubview:toolbar];
		[self.view addSubview:segmentedControl];
		
		// added by pradeeo on 14 dec for event improvement i.e. calendar
		
		[self.view addSubview:scrollView];
		[scrollView addSubview:segmentedControlcal];
		[self.view addSubview:caltop];
		[self.view addSubview:lblMonthYear];
		[self.view addSubview:recnotfound];
		[self.view addSubview:btnFilter];
		
		//*******************************
		
	}
	else if(buttonIndex == 1) 
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:segmentedControlcal.selectedSegmentIndex]];
		
		NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
		
		NSMutableArray *temp4filterary = [NSMutableArray arrayWithArray:filteredArray];
		
		NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(eventindustry ==  %@)", @"Technology"];
		
		NSArray *filteredArray2 = [temp4filterary filteredArrayUsingPredicate:predicate2];
		
		NSMutableArray *temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray2];
		
		//stories = [NSMutableArray arrayWithArray:filteredArray2];
		
		//self.list = [[NSMutableArray alloc] init];
		
		[stories removeAllObjects];
		
		[stories addObjectsFromArray:temp4filterary2];
		
		
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
				itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, 320, 282) style:UITableViewStylePlain]; // added by pradeep on 28 jan 2011 increase y-axis position from 78 to 88 also change height of table from 292 to 282
				itemTableView.delegate = self;
				itemTableView.dataSource = self;
				itemTableView.rowHeight = 57;
				itemTableView.backgroundColor = [UIColor clearColor];
				itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
				[self.view addSubview:itemTableView];
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
			CGRect lableRecNotFrame = CGRectMake(30, 160, 260, 130);
			//Event not found for selected criteria
			if(!recnotfound) {
				
				recnotfound = [UnsocialAppDelegate createLabelControl:@"" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:6 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			}
			recnotfound.hidden = NO;
			if (segmentedControl.selectedSegmentIndex == 1)
				recnotfound.text = @"You have no saved events to display. If you have an event you would like to save, simply go to event's detail page, click options, and then save.";
			else if (segmentedControl.selectedSegmentIndex == 2)
				recnotfound.text = @"There are currently no premum events in your area. Try again later.";
			else
				recnotfound.text = @"There are currently no events in your area. Try again later.";
		}
		else 
		{
			recnotfound.hidden = YES;
			recnotfound.text = @"";
		}
		[self.view addSubview:recnotfound];
		//[recnotfound release];
		
		loading.hidden = YES;
		activityView.hidden = YES;
		[self.view addSubview:loading];
		loading.hidden = YES;
		[activityView stopAnimating];
		[self.view addSubview:toolbar];
		[self.view addSubview:segmentedControl];
		
		// added by pradeeo on 14 dec for event improvement i.e. calendar
		
		[self.view addSubview:scrollView];
		[scrollView addSubview:segmentedControlcal];
		[self.view addSubview:caltop];
		[self.view addSubview:lblMonthYear];
		[self.view addSubview:recnotfound];
		[self.view addSubview:btnFilter];
		
		//*******************************
		
	}
	else if(buttonIndex == 2) 
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:segmentedControlcal.selectedSegmentIndex]];
		
		NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
		
		NSMutableArray *temp4filterary = [NSMutableArray arrayWithArray:filteredArray];
		
		NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(eventindustry ==  %@)", @"Business"];
		
		NSArray *filteredArray2 = [temp4filterary filteredArrayUsingPredicate:predicate2];
		
		NSMutableArray *temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray2];
		
		//stories = [NSMutableArray arrayWithArray:filteredArray2];
		
		//self.list = [[NSMutableArray alloc] init];
		
		[stories removeAllObjects];
		
		[stories addObjectsFromArray:temp4filterary2];
		
		
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
				itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, 320, 282) style:UITableViewStylePlain]; // added by pradeep on 28 jan 2011 increase y-axis position from 78 to 88 also change height of table from 292 to 282
				itemTableView.delegate = self;
				itemTableView.dataSource = self;
				itemTableView.rowHeight = 57;
				itemTableView.backgroundColor = [UIColor clearColor];
				itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
				[self.view addSubview:itemTableView];
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
			CGRect lableRecNotFrame = CGRectMake(30, 160, 260, 130);
			//Event not found for selected criteria
			if(!recnotfound) {
				
				recnotfound = [UnsocialAppDelegate createLabelControl:@"" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:6 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			}
			recnotfound.hidden = NO;
			if (segmentedControl.selectedSegmentIndex == 1)
				recnotfound.text = @"You have no saved events to display. If you have an event you would like to save, simply go to event's detail page, click options, and then save.";
			else if (segmentedControl.selectedSegmentIndex == 2)
				recnotfound.text = @"There are currently no premum events in your area. Try again later.";
			else
				recnotfound.text = @"There are currently no events in your area. Try again later.";
		}
		else 
		{
			recnotfound.hidden = YES;
			recnotfound.text = @"";
		}
		[self.view addSubview:recnotfound];
		//[recnotfound release];
		
		loading.hidden = YES;
		activityView.hidden = YES;
		[self.view addSubview:loading];
		loading.hidden = YES;
		[activityView stopAnimating];
		[self.view addSubview:toolbar];
		[self.view addSubview:segmentedControl];
		
		// added by pradeeo on 14 dec for event improvement i.e. calendar
		
		[self.view addSubview:scrollView];
		[scrollView addSubview:segmentedControlcal];
		[self.view addSubview:caltop];
		[self.view addSubview:lblMonthYear];
		[self.view addSubview:recnotfound];
		[self.view addSubview:btnFilter];
		
		//*******************************
	}
	else if(buttonIndex == 3) 
	{ 
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:segmentedControlcal.selectedSegmentIndex]];
		
		NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
		
		NSMutableArray *temp4filterary = [NSMutableArray arrayWithArray:filteredArray];
		
		NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(eventindustry ==  %@)", @"Social"];
		
		NSArray *filteredArray2 = [temp4filterary filteredArrayUsingPredicate:predicate2];
		
		NSMutableArray *temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray2];
		
		//stories = [NSMutableArray arrayWithArray:filteredArray2];
		
		//self.list = [[NSMutableArray alloc] init];
		
		[stories removeAllObjects];
		
		[stories addObjectsFromArray:temp4filterary2];
		
		
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
				itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, 320, 282) style:UITableViewStylePlain]; // added by pradeep on 28 jan 2011 increase y-axis position from 78 to 88 also change height of table from 292 to 282
				itemTableView.delegate = self;
				itemTableView.dataSource = self;
				itemTableView.rowHeight = 57;
				itemTableView.backgroundColor = [UIColor clearColor];
				itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
				[self.view addSubview:itemTableView];
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
			CGRect lableRecNotFrame = CGRectMake(30, 160, 260, 130);
			//Event not found for selected criteria
			if(!recnotfound) {
				
				recnotfound = [UnsocialAppDelegate createLabelControl:@"" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:6 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			}
			recnotfound.hidden = NO;
			if (segmentedControl.selectedSegmentIndex == 1)
				recnotfound.text = @"You have no saved events to display. If you have an event you would like to save, simply go to event's detail page, click options, and then save.";
			else if (segmentedControl.selectedSegmentIndex == 2)
				recnotfound.text = @"There are currently no premum events in your area. Try again later.";
			else
				recnotfound.text = @"There are currently no events in your area. Try again later.";
		}
		else 
		{
			recnotfound.hidden = YES;
			recnotfound.text = @"";
		}
		[self.view addSubview:recnotfound];
		//[recnotfound release];
		
		loading.hidden = YES;
		activityView.hidden = YES;
		[self.view addSubview:loading];
		loading.hidden = YES;
		[activityView stopAnimating];
		[self.view addSubview:toolbar];
		[self.view addSubview:segmentedControl];
		
		// added by pradeeo on 14 dec for event improvement i.e. calendar
		
		[self.view addSubview:scrollView];
		[scrollView addSubview:segmentedControlcal];
		[self.view addSubview:caltop];
		[self.view addSubview:lblMonthYear];
		[self.view addSubview:recnotfound];
		[self.view addSubview:btnFilter];
		
		//*******************************
		
	}
	else 
	{
		
	}
	//}
	
	
	
}



//*****************

- (void) get120days {
	
	// commeneted by pradeep on 1 aug 2011
	//daysitems = [[NSMutableDictionary alloc] init];
	// end 1 aug 2011
	
	// commented by pradeep on 7 june 2011 due to re-declare below in for loop
	//dates = [[NSMutableString alloc] init];
	NSDate *today = [NSDate date];
	
	NSDate *earlierDate, *laterDate;
	
	if ([dayDisp count]>0)
	{
		// added by pradeep on 7 june 2011 due to memory issue
		[dayDisp release];
		[dateDisp release];
		[monthDisp release];
		[yearDisp release];
		[imgArray release];
		[dateFrmat release];
		// end 7 june 2011
	}
	
	dayDisp = [[NSMutableArray	alloc] init];
	dateDisp = [[NSMutableArray	alloc] init];
	monthDisp = [[NSMutableArray	alloc] init];
	yearDisp = [[NSMutableArray	alloc] init];
	imgArray = [[NSMutableArray alloc] init];
	dateFrmat = [[NSMutableArray alloc] init];
	
	stories2 = [[NSMutableArray alloc] init];
	
	// added by pradeep on 24 dec 2010 for toggledate ary
	//**********
	eventtoggledateary = [[NSMutableArray alloc] init];
	//********** end
	
	UIImage *img = [UIImage imageNamed:@"imgcalbar.png"];
	
	// setting last 30 dates from now
	for (int i=30,j=0; i > 0; i--,j++) 
	{
		daysitems = [[NSMutableDictionary alloc] init];
		dates = [[NSMutableString alloc] init];
		month = [[NSMutableString alloc] init];
		year = [[NSMutableString alloc] init];
		day = [[NSMutableString alloc] init];
		datefrmtstr = [[NSMutableString alloc] init];
		
		earlierDate = [today addTimeInterval:(-1.0*i*24*60*60)];
		NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init]; 
	    [dateFormatter1 setDateFormat:@"M/d/yyyy"]; // M/d/yyyy ZZZ
		NSString *strdtdeep = [dateFormatter1 stringFromDate:earlierDate];
		
		// added by pradeep on 1 aug 2011 for releasing memory
		[dateFormatter1 release];
		// end 1 aug 2011
		
		/*NSString *dateStringDeep = [dateFormatter1 stringFromDate:earlierDate];
		 NSLog(@"complete date with M/d/yyyy i.e. 2/2/2011: %@", dateStringDeep);
		 NSMutableArray *myArrayDeep = [[NSMutableArray alloc] init];
		 [myArrayDeep setArray:[dateStringDeep componentsSeparatedByString:@" "]];
		 NSString *strdtdeep = [myArrayDeep objectAtIndex:0];*/
		
		
		//*******************
		
		//NSLog(@"today: %@", earlierDate);		
		
		
		NSMutableArray *myArray = [[NSMutableArray alloc] init];
		NSMutableArray *myArray2 = [[NSMutableArray alloc] init];
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"EEE MMMM d, yyyy"];
		NSString *dateString = [dateFormat stringFromDate:earlierDate];
		//NSLog(@"complete date with name: %@", dateString);
		//[dateFormat release];
		
		
		[myArray2 setArray:[dateString componentsSeparatedByString:@","]];
		
		NSString *strdaymondt = [myArray2 objectAtIndex:0];
		NSString *stryear = [myArray2 objectAtIndex:1];
		
		[myArray setArray:[strdaymondt componentsSeparatedByString:@" "]];		
		
		NSString *strday = [myArray objectAtIndex:0];
		NSString *strmonth = [myArray objectAtIndex:1];
		NSString *strdate = [myArray objectAtIndex:2];
		//NSString *stryr = stryear;
		
		// added by pradeep on 7 june 2011 due to memory issue
		[myArray release];
		[myArray2 release];
		[dateFormat release];
		// end 7 june 2011
		
		//*******************
		
		[dates appendString:[NSString stringWithFormat:@"%@", strdate]];
		[month appendString:[NSString stringWithFormat:@"%@", strmonth]];
		[day appendString:[NSString stringWithFormat:@"%@", strday]];
		[year appendString:[NSString stringWithFormat:@"%@", stryear]];
		
		[datefrmtstr appendString:[NSString stringWithFormat:@"%@", strdtdeep]];
		
		[daysitems setObject:dates forKey:@"date"];
		[daysitems setObject:month forKey:@"month"];
		[daysitems setObject:day forKey:@"day"];
		[daysitems setObject:year forKey:@"year"];
		
		[daysitems setObject:datefrmtstr forKey:@"datesameasresponse"];
		
		[stories2 addObject:[daysitems copy]];
		
		// added by pradeep on 7 june 2011 due to memory issue
		[dates release];
		[month release];
		[day release];
		[year release];
		[datefrmtstr release];
		// end 7 june 2011
		
		// added by pradeep on 1 aug 2011 for releasing memory
		[daysitems release];
		// end 1 aug 2011
		
		
		//***************
		
		
		//NSLog(@"%@", [NSString stringWithFormat:@"%@", [[stories2 objectAtIndex:j] objectForKey:@"date"]]);
		
		//NSLog(@"date for maching with response date: %@", [NSString stringWithFormat:@"%@", [[stories2 objectAtIndex:j] objectForKey:@"datesameasresponse"]]);
		
		[dayDisp addObject:[[stories2 objectAtIndex:j] objectForKey:@"day"]];
		[dateDisp addObject:[[stories2 objectAtIndex:j] objectForKey:@"date"]];
		[monthDisp addObject:[[stories2 objectAtIndex:j] objectForKey:@"month"]];
		[yearDisp addObject:[[stories2 objectAtIndex:j] objectForKey:@"year"]];
		
		[dateFrmat addObject:[[stories2 objectAtIndex:j] objectForKey:@"datesameasresponse"]];
		
		NSString *todaydatecolor = @"";
		NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init]; 
	    [dateFormatter2 setDateFormat:@"M/d/yyyy"];
		NSString *dateStringDeep5 = [dateFormatter2 stringFromDate:today];
		
		// added by pradeep on 1 aug 2011 for releasing memory
		[dateFormatter2 release];
		// end 1 aug 2011
		
		
		//NSLog(@"checking date for color: %@", [[stories2 objectAtIndex:j] objectForKey:@"datesameasresponse"]);
		//NSLog(@"today's date checking for color: %@", dateStringDeep5);
		if ([dateStringDeep5 compare:[[stories2 objectAtIndex:j] objectForKey:@"datesameasresponse"]] == NSOrderedSame)
			todaydatecolor = @"green";
		
		//*********** 20 dec 2010 start
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:j]];
		
		NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
		
		NSMutableArray *tempnsmutableary = [NSMutableArray arrayWithArray:filteredArray];
		
		//stories = [stories4cal filteredArrayUsingPredicate:predicate];
		
		if ([tempnsmutableary count] > 0)
		{
			//NSLog(@"tempnsmutableary for * i.e. event exist eventname: %@", [[tempnsmutableary objectAtIndex:0] objectForKey:@"eventname"]);
			//NSLog(@"tempnsmutableary for * i.e. event exist guid: %@", [[tempnsmutableary objectAtIndex:0] objectForKey:@"guid"]);
			
			//****************** added by pradeep on 28 jan 2011 for adding bar on segment control for premium events if exist on perticular date
			
			NSString *issponeventexist4calbar = @"";
			// added by pradeep on 8 feb 2011 for adding calbar for normal events also
			NSString *isnormaleventexist4calbar = @"";
			
			NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(eventtype ==  %@)", @"sponsoredevent"];
			
			NSArray *filteredArray2 = [tempnsmutableary filteredArrayUsingPredicate:predicate2];
			
			//NSMutableArray *tempnsmutableary = [NSMutableArray arrayWithArray:filteredArray2];
			
			if ([filteredArray2 count] > 0)
				issponeventexist4calbar=@"yes";
			
			//*******************
			// 28 jan 2011 end
			
			// added by pradeep on 8 feb 2011 for adding calbar for normal events also
			else 
				isnormaleventexist4calbar = @"yes";			
			// 8 feb 2011 end
			
			// commented on 8 feb by pradeep for removing * for events since we are already showing cal bar for normal as well as spon events
			//[imgArray addObject:[self addText:img text:[[stories2 objectAtIndex:j] objectForKey:@"date"]  text2:[[[stories2 objectAtIndex:j] objectForKey:@"day"] stringByAppendingString:@"*"]  text3:todaydatecolor text4:issponeventexist4calbar text5:isnormaleventexist4calbar]];
			[imgArray addObject:[self addText:img text:[[stories2 objectAtIndex:j] objectForKey:@"date"]  text2:[[stories2 objectAtIndex:j] objectForKey:@"day"]  text3:todaydatecolor text4:issponeventexist4calbar text5:isnormaleventexist4calbar]];
			
			
			// added by pradeep on 24 dec 2010 for adding items in ary for eventtoggle
			[eventtoggledateary addObject:[dateFrmat objectAtIndex:j]];			
		}
		else 
		{
			[imgArray addObject:[self addText:img text:[[stories2 objectAtIndex:j] objectForKey:@"date"]  text2:[[stories2 objectAtIndex:j] objectForKey:@"day"] text3:todaydatecolor text4:@"" text5:@""]];
		}
		
		
		//***************
	}
	
	//[stories2 removeAllObjects];
	
	// setting next 90 dates from now
	for (int i=0; i < 90; i++) {
		daysitems = [[NSMutableDictionary alloc] init];
		dates = [[NSMutableString alloc] init];
		month = [[NSMutableString alloc] init];
		year = [[NSMutableString alloc] init];
		day = [[NSMutableString alloc] init];
		
		datefrmtstr = [[NSMutableString alloc] init];
		
		laterDate = [today addTimeInterval:(1.0*i*24*60*60)];
		NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init]; 
	    [dateFormatter3 setDateFormat:@"M/d/yyyy"]; // M/d/yyyy ZZZ
		NSString *strdtdeep = [dateFormatter3 stringFromDate:laterDate];
		
		/*NSString *dateStringDeep = [dateFormatter3 stringFromDate:laterDate];
		 NSLog(@"complete date with M/d/yyyy ZZZ i.e. 2/2/2011: %@", dateStringDeep);
		 NSMutableArray *myArrayDeep = [[NSMutableArray alloc] init];
		 [myArrayDeep setArray:[dateStringDeep componentsSeparatedByString:@" "]];
		 NSString *strdtdeep = [myArrayDeep objectAtIndex:0];*/
		
		
		
		
		//*******************
		
		//NSLog(@"today: %@", laterDate);		
		
		
		
		NSMutableArray *myArray = [[NSMutableArray alloc] init];
		NSMutableArray *myArray2 = [[NSMutableArray alloc] init];
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"EEE MMMM d, yyyy"];
		NSString *dateString = [dateFormat stringFromDate:laterDate];
		//NSLog(@"complete date with name: %@", dateString);
		//[dateFormat release];
		
		
		[myArray2 setArray:[dateString componentsSeparatedByString:@","]];
		
		NSString *strdaymondt = [myArray2 objectAtIndex:0];
		NSString *stryear = [myArray2 objectAtIndex:1];
		
		[myArray setArray:[strdaymondt componentsSeparatedByString:@" "]];		
		
		NSString *strday = [myArray objectAtIndex:0];
		NSString *strmonth = [myArray objectAtIndex:1];
		NSString *strdate = [myArray objectAtIndex:2];
		//NSString *stryr = stryear;
		
		//*******************
		
		// added by pradeep on 1 Aug 2011 for releasing ary
		[myArray release];
		[myArray2 release];
		[dateFormat release];
		[dateFormatter3 release];
		// end 1 Aug 2011
		
		
		[dates appendString:[NSString stringWithFormat:@"%@",strdate]];
		[month appendString:[NSString stringWithFormat:@"%@",strmonth]];
		[day appendString:[NSString stringWithFormat:@"%@",strday]];
		[year appendString:[NSString stringWithFormat:@"%@", stryear]];
		
		[datefrmtstr appendString:[NSString stringWithFormat:@"%@", strdtdeep]];
		
		[daysitems setObject:dates forKey:@"date"];
		[daysitems setObject:month forKey:@"month"];
		[daysitems setObject:day forKey:@"day"];
		[daysitems setObject:year forKey:@"year"];
		
		[daysitems setObject:datefrmtstr forKey:@"datesameasresponse"];
		
		[stories2 addObject:[daysitems copy]];
		
		// added by pradeep on 1 aug 2011 for releasing memory
		[daysitems release];
		// end 1 aug 2011
		
		
		//*******************
		
		//NSLog(@"%@", [NSString stringWithFormat:@"%@", [[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"date"]]);
		
		//NSLog(@"date for maching with response date: %@", [NSString stringWithFormat:@"%@", [[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"datesameasresponse"]]);
		
		[dayDisp addObject:[[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"day"]];
		[dateDisp addObject:[[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"date"]];
		[monthDisp addObject:[[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"month"]];
		[yearDisp addObject:[[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"year"]];
		
		[dateFrmat addObject:[[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"datesameasresponse"]];
		
		NSString *todaydatecolor = @"";
		NSDateFormatter *dateFormatter4 = [[NSDateFormatter alloc] init]; 
	    [dateFormatter4 setDateFormat:@"M/d/yyyy"];
		NSString *dateStringDeep5 = [dateFormatter4 stringFromDate:today];
		
		// added by pradeep on 1 aug 2011 for releasing memory
		[dateFormatter4 release];
		// end 1 aug 2011
		
		
		//NSLog(@"checking date for color: %@", [[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"datesameasresponse"]);
		//NSLog(@"today's date checking for color: %@", dateStringDeep5);
		if ([dateStringDeep5 compare:[[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"datesameasresponse"]] == NSOrderedSame)
			todaydatecolor = @"green";
		
		//*********** 20 dec 2010 start
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:([dateFrmat count]-1)]]; // earlier here was i when i was creating image in different loop
		
		NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
		
		NSMutableArray *tempnsmutableary = [NSMutableArray arrayWithArray:filteredArray];
		
		//stories = [stories4cal filteredArrayUsingPredicate:predicate];
		
		if ([tempnsmutableary count] > 0)
		{
			//NSLog(@"tempnsmutableary for * i.e. event exist eventname: %@", [[tempnsmutableary objectAtIndex:0] objectForKey:@"eventname"]);
			//NSLog(@"tempnsmutableary for * i.e. event exist guid: %@", [[tempnsmutableary objectAtIndex:0] objectForKey:@"guid"]);
			
			//****************** added by pradeep on 28 jan 2011 for adding bar on segment control for premium events if exist on perticular date
			
			NSString *issponeventexist4calbar = @"";
			
			// added by pradeep on 8 feb 2011 for adding calbar for normal events also
			NSString *isnormaleventexist4calbar = @"";
			
			NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(eventtype ==  %@)", @"sponsoredevent"];
			
			NSArray *filteredArray2 = [tempnsmutableary filteredArrayUsingPredicate:predicate2];
			
			//NSMutableArray *tempnsmutableary = [NSMutableArray arrayWithArray:filteredArray2];
			
			if ([filteredArray2 count] > 0)
				issponeventexist4calbar=@"yes";
			
			//*******************
			// 28 jan 2011 end
			
			// added by pradeep on 8 feb 2011 for adding calbar for normal events also
			else 
				isnormaleventexist4calbar = @"yes";			
			// 8 feb 2011 end
			
			// commented on 8 feb by pradeep for removing * for events since we are already showing cal bar for normal as well as spon events
			//[imgArray addObject:[self addText:img text:[[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"date"]  text2:[[[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"day"] stringByAppendingString:@"*"]  text3:todaydatecolor text4:issponeventexist4calbar text5:isnormaleventexist4calbar]];
			[imgArray addObject:[self addText:img text:[[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"date"]  text2:[[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"day"]  text3:todaydatecolor text4:issponeventexist4calbar text5:isnormaleventexist4calbar]];
			
			// added by pradeep on 24 dec 2010 for adding items in ary for eventtoggle
			[eventtoggledateary addObject:[dateFrmat objectAtIndex:([dateFrmat count]-1)]];			
		}
		else {
			[imgArray addObject:[self addText:img text:[[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"date"]  text2:[[stories2 objectAtIndex:([stories2 count]-1)] objectForKey:@"day"] text3:todaydatecolor text4:@"" text5:@""]];
		}
		
		//*******************
		
	}	
	
	// getting all set dates
	/*for (int i=0; i < [stories2 count] ; i++) 
	 {
	 NSLog(@"%@", [NSString stringWithFormat:@"%@", [[stories2 objectAtIndex:i] objectForKey:@"date"]]);
	 
	 NSLog(@"date for maching with response date: %@", [NSString stringWithFormat:@"%@", [[stories2 objectAtIndex:i] objectForKey:@"datesameasresponse"]]);
	 
	 [dayDisp addObject:[[stories2 objectAtIndex:i] objectForKey:@"day"]];
	 [dateDisp addObject:[[stories2 objectAtIndex:i] objectForKey:@"date"]];
	 [monthDisp addObject:[[stories2 objectAtIndex:i] objectForKey:@"month"]];
	 [yearDisp addObject:[[stories2 objectAtIndex:i] objectForKey:@"year"]];
	 
	 [dateFrmat addObject:[[stories2 objectAtIndex:i] objectForKey:@"datesameasresponse"]];
	 
	 NSString *todaydatecolor = @"";
	 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
	 [dateFormatter setDateFormat:@"M/d/yyyy"];
	 NSString *dateStringDeep5 = [dateFormatter stringFromDate:today];
	 
	 
	 NSLog(@"checking date for color: %@", [[stories2 objectAtIndex:i] objectForKey:@"datesameasresponse"]);
	 NSLog(@"today's date checking for color: %@", dateStringDeep5);
	 if ([dateStringDeep5 compare:[[stories2 objectAtIndex:i] objectForKey:@"datesameasresponse"]] == NSOrderedSame)
	 todaydatecolor = @"green";
	 
	 //*********** 20 dec 2010 start
	 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:i]];
	 
	 NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
	 
	 NSMutableArray *tempnsmutableary = [NSMutableArray arrayWithArray:filteredArray];
	 
	 //stories = [stories4cal filteredArrayUsingPredicate:predicate];
	 
	 if ([tempnsmutableary count] > 0)
	 {
	 NSLog(@"tempnsmutableary for * i.e. event exist eventname: %@", [[tempnsmutableary objectAtIndex:0] objectForKey:@"eventname"]);
	 NSLog(@"tempnsmutableary for * i.e. event exist guid: %@", [[tempnsmutableary objectAtIndex:0] objectForKey:@"guid"]);
	 [imgArray addObject:[self addText:img text:[[stories2 objectAtIndex:i] objectForKey:@"date"]  text2:[[[stories2 objectAtIndex:i] objectForKey:@"day"] stringByAppendingString:@"*"]  text3:todaydatecolor]];
	 
	 // added by pradeep on 24 dec 2010 for adding items in ary for eventtoggle
	 [eventtoggledateary addObject:[dateFrmat objectAtIndex:i]];			
	 }
	 else {
	 [imgArray addObject:[self addText:img text:[[stories2 objectAtIndex:i] objectForKey:@"date"]  text2:[[stories2 objectAtIndex:i] objectForKey:@"day"] text3:todaydatecolor]];
	 }
	 
	 //************ 20 dec 2010 end
	 
	 
	 
	 NSLog(@"here");
	 }*/
}

- (void) get120days4segmentchange // since we have to change the calendar *(i.e. item exist for changed segment i.e. saved or around me) each item
{
	NSDate *today = [NSDate date];
	UIImage *img = [UIImage imageNamed:@"imgcalbar.png"];
	imgArray = [[NSMutableArray alloc] init];
	
	// added by pradeep on 24 dec 2010 for toggledate ary
	eventtoggledateary = [[NSMutableArray alloc] init];
	//********** end
	
	// getting all set dates
	for (int i=0; i < [stories2 count] ; i++) 
	{
		//NSLog(@"%@", [NSString stringWithFormat:@"%@", [[stories2 objectAtIndex:i] objectForKey:@"date"]]);
		
		//NSLog(@"date for maching with response date: %@", [NSString stringWithFormat:@"%@", [[stories2 objectAtIndex:i] objectForKey:@"datesameasresponse"]]);
		
		//[dayDisp addObject:[[stories2 objectAtIndex:i] objectForKey:@"day"]];
		//[dateDisp addObject:[[stories2 objectAtIndex:i] objectForKey:@"date"]];
		//[monthDisp addObject:[[stories2 objectAtIndex:i] objectForKey:@"month"]];
		//[yearDisp addObject:[[stories2 objectAtIndex:i] objectForKey:@"year"]];
		
		//[dateFrmat addObject:[[stories2 objectAtIndex:i] objectForKey:@"datesameasresponse"]];
		
		NSString *todaydatecolor = @"";
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
	    [dateFormatter setDateFormat:@"M/d/yyyy"];
		NSString *dateStringDeep5 = [dateFormatter stringFromDate:today];
		
		
		//NSLog(@"checking date for color: %@", [[stories2 objectAtIndex:i] objectForKey:@"datesameasresponse"]);
		//NSLog(@"today's date checking for color: %@", dateStringDeep5);
		if ([dateStringDeep5 compare:[[stories2 objectAtIndex:i] objectForKey:@"datesameasresponse"]] == NSOrderedSame)
			todaydatecolor = @"green";
		
		//*********** 20 dec 2010 start
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:i]];
		
		NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
		
		NSMutableArray *tempnsmutableary = [NSMutableArray arrayWithArray:filteredArray];
		
		//stories = [stories4cal filteredArrayUsingPredicate:predicate];
		
		if ([tempnsmutableary count] > 0)
		{
			//NSLog(@"tempnsmutableary for * i.e. event exist eventname: %@", [[tempnsmutableary objectAtIndex:0] objectForKey:@"eventname"]);
			//NSLog(@"tempnsmutableary for * i.e. event exist guid: %@", [[tempnsmutableary objectAtIndex:0] objectForKey:@"guid"]);
			
			//****************** added by pradeep on 28 jan 2011 for adding bar on segment control for premium events if exist on perticular date
			
			NSString *issponeventexist4calbar = @"";
			// added by pradeep on 8 feb 2011 for adding calbar for normal events also
			NSString *isnormaleventexist4calbar = @"";
			
			NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(eventtype ==  %@)", @"sponsoredevent"];
			
			NSArray *filteredArray2 = [tempnsmutableary filteredArrayUsingPredicate:predicate2];
			
			//NSMutableArray *tempnsmutableary = [NSMutableArray arrayWithArray:filteredArray2];
			
			if ([filteredArray2 count] > 0)
				issponeventexist4calbar=@"yes";
			
			//*******************
			// 28 jan 2011 end
			
			// added by pradeep on 8 feb 2011 for adding calbar for normal events also
			else 
				isnormaleventexist4calbar = @"yes";			
			// 8 feb 2011 end
			
			// commented on 8 feb by pradeep for removing * for events since we are already showing cal bar for normal as well as spon events
			//[imgArray addObject:[self addText:img text:[[stories2 objectAtIndex:i] objectForKey:@"date"]  text2:[[[stories2 objectAtIndex:i] objectForKey:@"day"] stringByAppendingString:@"*"]  text3:todaydatecolor text4:issponeventexist4calbar text5:isnormaleventexist4calbar]];
			[imgArray addObject:[self addText:img text:[[stories2 objectAtIndex:i] objectForKey:@"date"]  text2:[[stories2 objectAtIndex:i] objectForKey:@"day"]  text3:todaydatecolor text4:issponeventexist4calbar text5:isnormaleventexist4calbar]];
			
			// added by pradeep on 24 dec 2010 for adding items in ary for eventtoggle
			[eventtoggledateary addObject:[dateFrmat objectAtIndex:i]];	
			
		}
		else {
			[imgArray addObject:[self addText:img text:[[stories2 objectAtIndex:i] objectForKey:@"date"]  text2:[[stories2 objectAtIndex:i] objectForKey:@"day"] text3:todaydatecolor text4:@"" text5:@""]];
		}
		
		//************ 20 dec 2010 end
		
		
		
		//NSLog(@"here");
	}
	
	// commented by pradeep on 9 feb 2011 for changing the calendar
	/*segmentedControlcal = [[UISegmentedControl alloc] initWithItems:imgArray];
	segmentedControlcal.frame = CGRectMake(0, 12, 7680, 95);
	segmentedControlcal.segmentedControlStyle = UISegmentedControlStylePlain;*/
	
	// 8 feb 2011 by pradeep
	segmentedControlcal = [[UISegmentedControl alloc] initWithItems:imgArray];
	//segmentedControlcal.frame = CGRectMake(0, 12, 7680, 95);
	segmentedControlcal.frame = CGRectMake(0, 0, 7680, 115);
	
	//**************
	segmentedControlcal.segmentedControlStyle = UISegmentedControlStyleBar;	
	//**************
	
	/*if (arivefirsttime4cal == 0)
	 {
	 segmentedControlcal.selectedSegmentIndex = 30;
	 whichsegmentselectedlasttime4cal = 30;
	 }
	 else*/ segmentedControlcal.selectedSegmentIndex = whichsegmentselectedlasttime4cal;
	//segmentedControl.
	[segmentedControlcal addTarget:self action:@selector(pickOneDate)forControlEvents:UIControlEventValueChanged];
	segmentedControlcal.backgroundColor = [UIColor clearColor];
	//segmentedControlcal.tintColor = [UIColor colorWithRed:240/255.0 green:141/255.0 blue:60/255.0 alpha:1.0];
	// added by pradeep on 9 feb 2011
	[segmentedControlcal setTintColor:[UIColor colorWithRed:201.0/255.0 green:193.0/255.0 blue:181.0/255.0 alpha:1.0]];
	[scrollView addSubview:segmentedControlcal];
	/*if (arivefirsttime4cal == 0)
	 {
	 scrollView.contentOffset = CGPointMake(1920.0, 0.0); // 1998 2400.0
	 arivefirsttime4cal = 1;
	 }
	 else*/ {
		 
		 //scrollView.contentOffset = CGPointMake(1920.0, 0.0); // 1998 2400.0
		 // for calculating start x-axis location for last selected calendar item
		 int iteminwhichpage = segmentedControlcal.selectedSegmentIndex/5;
		 iteminwhichpage = iteminwhichpage*5;
		 int startxloc = iteminwhichpage*64; // 64 is the width of one item in calendar
		 scrollView.contentOffset = CGPointMake(startxloc, 0.0); // 1998 2400.0
	 }
	
	[segmentedControlcal release];
}


-(UIImage *)addText:(UIImage *)img text:(NSString *)text1  text2:(NSString *)text2 text3:(NSString *)text3 text4:(NSString *)text4 text5:(NSString *)text5{	
    int w = img.size.width;
    int h = img.size.height; 
	//lon = h - lon;
	
	UIImage *img4calbar = [UIImage imageNamed:@"imgcalbar.png"];
	
	w = img4calbar.size.width;
    h = img4calbar.size.height;
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
	
    
	// added by pradeep for adding cal bar for spon events
	if ([text4 compare:@"yes"] == NSOrderedSame)
		//CGContextDrawImage(context, CGRectMake(0, 0, 64, 30), img.CGImage);
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), img4calbar.CGImage);
	
	// added by pradeep on 8 feb 2011 for adding cal bar for spon events
	if ([text5 compare:@"yes"] == NSOrderedSame)
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), img4calbar.CGImage);
	
    //CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);	
	
    char* t1 = (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];// date;
	char* t2 = (char *)[[text2 uppercaseString] cStringUsingEncoding:NSASCIIStringEncoding];// day;
	char* t3 = (char *)[[@"PREMIUM" uppercaseString] cStringUsingEncoding:NSASCIIStringEncoding];// premium;
	// added by pradeep on 8 feb 2011 for seperator of days
	char* t4 = (char *)[@"_____________________" cStringUsingEncoding:NSASCIIStringEncoding];// seperator of date n day;
	char* t5 = (char *)[@"EVENTS" cStringUsingEncoding:NSASCIIStringEncoding];// seperator of date n day;
	
	
    CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
	
    CGContextSetTextDrawingMode(context, kCGTextFill);
	
    if (([[text2 uppercaseString] compare:@"SAT"]==NSOrderedSame) || ([[text2 uppercaseString] compare:@"SUN"]==NSOrderedSame) || ([[text2 uppercaseString] compare:@"SAT*"]==NSOrderedSame) || ([[text2 uppercaseString] compare:@"SUN*"]==NSOrderedSame))
		CGContextSetRGBFillColor(context,176.0/255.0,  48.0/255.0, 96.0/255.0, 1); // red: 255,0,0 black: 0,0,0 white: 255,255,255
	else CGContextSetRGBFillColor(context,0,  0, 0, 1);	
	
	if ([text3 compare:@"green"] == NSOrderedSame) // green color is replaced with blue color
		// commented by pradeep on 8 feb 2011 for changing previous green color to correct green color
		//CGContextSetRGBFillColor(context,0,100,0,1);
		CGContextSetRGBFillColor(context,74.0/255,105.0/255,163.0/255,1);
	
	//rotate text
	
	//    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
	
	if (strlen(t1) > 1) {
		CGContextShowTextAtPoint(context, 22, 48, t1, strlen(t1)); //CGContextShowTextAtPoint(<#CGContextRef c#>, <#CGFloat x#>, <#CGFloat y#>, <#const char *string#>, <#size_t length#>)
	}
	else {		
		CGContextShowTextAtPoint(context, 27, 48, t1, strlen(t1));
	}
	
	//CGContextSelectFont(context, "Helvetica", 14, kCGEncodingMacRoman); // by pradeep on 8 feb 2011
	CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman);
	//CGContextShowTextAtPoint(context, 18, 68, t2, strlen(t2)); // by pradeep on 8 feb 2011
	CGContextShowTextAtPoint(context, 22, 72, t2, strlen(t2));
	
	//***************** 8 feb 2011 by pradeep for seperator of days
	CGContextSelectFont(context, "Helvetica", 6, kCGEncodingMacRoman);
	CGContextSetRGBFillColor(context,0,0,0,1);
	CGContextShowTextAtPoint(context, 0, 68, t4, strlen(t4));
	//***************** 8 feb 2011 by pradeep for seperator of days
	
	
	// added by pradeep on 28 jan 2011 for cal bar 4 premium events
	if ([text4 compare:@"yes"] == NSOrderedSame) // for premium event
	{
		CGContextSelectFont(context, "Helvetica", 11, kCGEncodingMacRoman);
		CGContextSetRGBFillColor(context,255.0/255,255.0/255,255.0/255,1);
		CGContextShowTextAtPoint(context, 6, 34, t3, strlen(t3));
	}
	
	//***************** start added by pradeep on 8 feb 2011 for cal bar for normal events
	if ([text5 compare:@"yes"] == NSOrderedSame) // for normal events
	{
		CGContextSelectFont(context, "Helvetica", 11, kCGEncodingMacRoman);
		CGContextSetRGBFillColor(context,255.0/255,255.0/255,255.0/255,1);
		CGContextShowTextAtPoint(context, 10, 34, t5, strlen(t5));
	}
	//***************** end added by pradeep on 8 feb 2011 for cal bar for normal events
	
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	
    CGContextRelease(context);
	
    CGColorSpaceRelease(colorSpace);
	
    return [UIImage imageWithCGImage:imageMasked];
}
- (void) pickOneDate//:(id)sender //- (void)segmentAction:(id)sender{
{
	
	//NSLog(@"calendar date changed i.e. touched...");
	
	//NSDate *today = [NSDate date];
	
	//NSDate *earlierDate = [today addTimeInterval:(-1.0*30*24*60*60)];
	
	//NSDate *laterDate = [today addTimeInterval:(1.0*90*24*60*60)];
	
	NSLog(@"selcted date: %@, selected month: %@, selected year: %@, selected segment index: %d", [dateDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex], [monthDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex], [yearDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex], segmentedControlcal.selectedSegmentIndex);
	
	lblMonthYear.text = [NSString stringWithFormat:@"%@ %@", [monthDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex], [yearDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex]];
	//[[[monthDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex] stringByAppendingString:@" "] stringByAppendingString:[yearDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex]];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:segmentedControlcal.selectedSegmentIndex]];
	
	NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
	
	NSMutableArray *temp4filterary2 = [NSMutableArray arrayWithArray:filteredArray];
	
	
	[stories removeAllObjects];
	
	[stories addObjectsFromArray:temp4filterary2];
	
	//stories = [NSMutableArray arrayWithArray:filteredArray];
	
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
			itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, 320, 282) style:UITableViewStylePlain]; // added by pradeep on 28 jan 2011 increase y-axis position from 78 to 88 also change height of table from 292 to 282
			itemTableView.delegate = self;
			itemTableView.dataSource = self;
			itemTableView.rowHeight = 57;
			itemTableView.backgroundColor = [UIColor clearColor];
			itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
			[self.view addSubview:itemTableView];
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
		CGRect lableRecNotFrame = CGRectMake(30, 160, 260, 130);
		//Event not found for selected criteria
		if(!recnotfound) {
			
			recnotfound = [UnsocialAppDelegate createLabelControl:@"" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:6 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		}
		recnotfound.hidden = NO;
		//[self.view addSubview:recnotfound];
		//[recnotfound release];
		if (segmentedControl.selectedSegmentIndex == 1)
			recnotfound.text = @"You have no saved events to display. If you have an event you would like to save, simply go to event's detail page, click options, and then save.";
		else if (segmentedControl.selectedSegmentIndex == 2)
			recnotfound.text = @"There are currently no premium events in your area. Try again later.";
		else			
			recnotfound.text = @"There are currently no events in your area. Try again later.";
	}
	else 
	{
		recnotfound.hidden = YES;
		recnotfound.text = @"";
	}
	loading.hidden = YES;
	activityView.hidden = YES;
	[self.view addSubview:loading];
	//loading.hidden = YES;
	[activityView stopAnimating];
	[self.view addSubview:toolbar];
	[self.view addSubview:segmentedControl];
	
	// added by pradeeo on 14 dec for event improvement i.e. calendar
	
	[self.view addSubview:scrollView];
	[scrollView addSubview:segmentedControlcal];
	[self.view addSubview:caltop];
	[self.view addSubview:lblMonthYear];
	[self.view addSubview:recnotfound];
	[self.view addSubview:btnFilter];
	
	//*******************************
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.


/*- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate {
 
 
 
 int offind = 0;
 offind = scrollView1.contentOffset.x/(7680/120); // 66.66 9600
 
 
 NSLog(@"dragging finished %f %f %d", scrollView1.contentOffset.x, scrollView1.contentOffset.y, offind);
 
 NSLog(@"scrollView1.frame.size.width: %d", scrollView1.frame.size.width);
 
 if (offind > 0)
 {
 //	lblMonthYear.text = [monthDisp objectAtIndex:offind];
 //NSLog(@"selcted date: %@, selected month: %@, selected year: %@, selected segment index: %d", [dateDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex], [monthDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex], [yearDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex], segmentedControlcal.selectedSegmentIndex);
 
 lblMonthYear.text = [NSString stringWithFormat:@"%@ %@",[monthDisp objectAtIndex:offind], [yearDisp objectAtIndex:offind]];
 //[[[monthDisp objectAtIndex:offind] stringByAppendingString:@" "] stringByAppendingString:[yearDisp objectAtIndex:offind]];
 }
 
 if(scrollView1.contentOffset.x > scrollView1.frame.size.width) 
 {
 // We are moving forward. Load the current doc data on the first page.
 NSLog(@"We are moving forward. Load the current doc data on the first page.");
 
 }
 if(scrollView1.contentOffset.x < scrollView1.frame.size.width) {
 // We are moving backward. Load the current doc data on the last page.
 NSLog(@"We are moving backward. Load the current doc data on the last page.");		
 }	
 }*/

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1 {
	
	int offind = 0;
	
	offind = scrollView1.contentOffset.x/(7680/120); // 66.66 9600 
	
	/*int xOff = x % 50;
	 
	 if(offind < 25)
	 
	 x -= offind;
	 
	 else
	 
	 x += 50 - offind;*/ 
	
	
	
	//NSLog(@"end dec %f %d %@", scrollView1.contentOffset.x, offind,[monthDisp objectAtIndex:offind]); 
	
	// NSLog(@"scrollView1.frame.size.width: %d", scrollView1.frame.size.width); 
	
	if (offind > 0 && [monthDisp count] >= offind)
		
	{
		
		//lblMonthYear.text = [monthDisp objectAtIndex:offind];
		
		//NSLog(@"selcted date: %@, selected month: %@, selected year: %@, selected segment index: %d", [dateDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex], [monthDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex], [yearDisp objectAtIndex:segmentedControlcal.selectedSegmentIndex], segmentedControlcal.selectedSegmentIndex); 
		
		lblMonthYear.text = [NSString stringWithFormat:@"%@ %@", [monthDisp objectAtIndex:offind], [yearDisp objectAtIndex:offind]];// [[[monthDisp objectAtIndex:offind] stringByAppendingString:@" "] stringByAppendingString:[yearDisp objectAtIndex:offind]];
		
	}
	
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // Detemine if it's in editing mode
    if (itemTableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
	else
		return UITableViewCellEditingStyleNone;
}

// commented by pradeep on 24 dec 2010 for adding "List" btn for toggle between list and dairy for event enhancement feature
// now delete button will be any other place
//*********************

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
	
	arivefirsttime4event = 0;
	
	//freemmry = 0;
	
	NSLog(@"total item in togglelist ary: %d", [eventtoggledateary count]);
	
	//eventtogglelistary = [[NSMutableArray alloc] init];
	
	eventtogglelistary = [NSMutableArray arrayWithArray:stories4cal];	
	
	// commented and added by pradeep on 3 june 2011 for changing concept of flip by push due to 9dots icon i.e. home btn appears every where
	
	/*TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	TTURLMap* map = navigator.URLMap;
	[map from:@"tt://eventtoggle" toModalViewController:[EventsToggle class]transition:1];
	[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://eventtoggle"] applyAnimated:YES]];	*/
	
	// added by pradeep on 3 june 2011
	EventsToggle *et = [[EventsToggle alloc] init];
	/*[self.navigationController pushViewController:et animated:YES];
	[et release];*/
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: 1];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
	[[self navigationController] pushViewController:et animated:NO];
	[UIView commitAnimations];
	
	// end 3 june 2011
}

//************************

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
	
	//NSLog(@"%@", [[stories objectAtIndex:storyIndex] objectForKey:@"guid"]);
	NSString *varSavedEventId = [NSString stringWithFormat:@"%@\r\n",[[stories objectAtIndex:storyIndex] objectForKey:@"guid"]];	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	//NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
	// added by pradeep on 7 june 2011 for releasing ary
	[myArray release];
	
	// end 7 june 2011
	
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
		//if ([key compare:@"Totunreadmsg"] == NSOrderedSame)			
		{
			//if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
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
	[returnString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

- (void)leftbtn_OnClick {
	
	arivefirsttime4event = 0;
	arivefirsttime4cal = 0;
	whichsegmentselectedlasttime4cal = 0;
	whichsegmentselectedlasttime4event = 0;
	
	//freemmry = 0;
	
	if(comingfrom == 1) {
		
		comingfrom = 0;
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
		
		WhereIam = 0;
		[self dismissModalViewControllerAnimated:YES];
	}
}

- (void)addEvent_Click {
	
	EventAdd *eventAdd = [[EventAdd alloc]init];
	//eventAdd.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController pushViewController:eventAdd animated:YES];
	
}

- (void)segmentAction:(id)sender 
{
	
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
	
	int selectedSegment = segmentedControl.selectedSegmentIndex;
	NSLog(@"segmentAction: selected segment = %d", selectedSegment);
	
	// for fixing bug, case: if user has navigate event feature from spring board once, it shows rec accordingly but again use event feature from spring board, record doesn't display :(
	
	if (!itemTableView)
		arivefirsttime4event = 0;
	
	//int temp4whichsegmentselectedlasttime4event = whichsegmentselectedlasttime4event;
	
	if(arivefirsttime4event==0)
	{
		arivefirsttime4event = 1;
		whichsegmentselectedlasttime4event = segmentedControl.selectedSegmentIndex;
		if (!allInterest) // i.e. allInterest=NO i.e. All tab is selected
		{
			if(gblTotalnumberofsponevents != 0)
			{
				//segmentedControl.selectedSegmentIndex = 2;
				whichsegmentselectedlasttime4event = 2;
				NSLog(@"2");
				[self getEventData:@"premiumevents" :@"future"];
				gblTotalnumberofsponevents = 0;
			}
			else {
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
				else if (selectedSegment==2)
				{
					NSLog(@"2");
					[self getEventData:@"premiumevents" :@"future"];
				}
			}
			
			// since now segment control contains only two tabs so below else commented by pradeep on 31 may 2010
			/*else if (selectedSegment==2)
			 {
			 NSLog(@"2");
			 [self getEventData:@"bookmarkedevents" :@"future"];
			 }*/
			/*else if (selectedSegment==3)
			 {
			 NSLog(@"3");
			 [self getEventData:@"allevents" :@"past"];
			 }*/
			
		}
		// else is not in use commented by pradeep on 31 may 2010
		/*else
		 {
		 NSLog(@"for my interested event");
		 if (selectedSegment==0)
		 {
		 [self getEventData:@"myinterestedevents" :@"all"];
		 NSLog(@"0");
		 }
		 else if (selectedSegment==1)
		 {
		 NSLog(@"1");
		 [self getEventData:@"myinterestedevents" :@"today"];
		 }
		 else if (selectedSegment==2)
		 {
		 NSLog(@"2");
		 [self getEventData:@"myinterestedevents" :@"future"];
		 }
		 //else if (selectedSegment==3)
		 // {
		 // NSLog(@"3");
		 // [self getEventData:@"myinterestedevents" :@"past"];
		 // }
		 }*/
	} // close arivefirsttime4event if
	else 
	{
		if (whichsegmentselectedlasttime4event != segmentedControl.selectedSegmentIndex)
		{
			whichsegmentselectedlasttime4event = segmentedControl.selectedSegmentIndex;
			if (!allInterest) // i.e. allInterest=NO i.e. All tab is selected
			{
				//NSLog(@"for all events");
				if (selectedSegment==0)
				{
					self.navigationItem.leftBarButtonItem.enabled = YES;
					
					// commented on 27 dec 2010 by pradeep, it will work for delete btn (since now rite navbar btn is replaced with toggle btn, earlier it was for delete saved items frm list
					//************
					//self.navigationItem.rightBarButtonItem = nil;
					//************
					
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
				else if (selectedSegment==2)
				{
					NSLog(@"2");
					[self getEventData:@"premiumevents" :@"future"];
				}
				// since now segment control contains only two tabs so below else commented by pradeep on 31 may 2010
				/*else if (selectedSegment==2)
				 {
				 NSLog(@"2");
				 [self getEventData:@"bookmarkedevents" :@"future"];
				 }*/
				/*
				 else if (selectedSegment==3)
				 {
				 NSLog(@"3");
				 [self getEventData:@"allevents" :@"past"];
				 }*/
				
			}
			// else is not in use commented by pradeep on 31 may 2010
			/*else
			 {
			 NSLog(@"for my interested event");
			 if (selectedSegment==0)
			 {
			 [self getEventData:@"myinterestedevents" :@"all"];
			 NSLog(@"0");
			 }
			 else if (selectedSegment==1)
			 {
			 NSLog(@"1");
			 [self getEventData:@"myinterestedevents" :@"today"];
			 }
			 else if (selectedSegment==2)
			 {
			 NSLog(@"2");
			 [self getEventData:@"myinterestedevents" :@"future"];
			 }
			 //else if (selectedSegment==3)
			 // {
			 // NSLog(@"3");
			 //[self getEventData:@"myinterestedevents" :@"past"];
			 // }
			 }*/
		}
	}
	
	// commented on 14 dec 2010 for implementing event improvement i.e. calendar like awesome start
	//*********************************************
	/*if (!itemTableView)
	 {				
	 //[self getPeopleData:@"notset"];
	 
	 if([stories count] > 0)
	 {
	 itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, 320, 330) style:UITableViewStylePlain];
	 itemTableView.delegate = self;
	 itemTableView.dataSource = self;
	 itemTableView.rowHeight = 115;
	 itemTableView.backgroundColor = [UIColor clearColor];
	 itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	 [self.view addSubview:itemTableView];
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
	 CGRect lableRecNotFrame = CGRectMake(30, 160, 260, 100);
	 //Event not found for selected criteria
	 recnotfound = [UnsocialAppDelegate createLabelControl:@"" frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:4 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	 recnotfound.hidden = NO;
	 [self.view addSubview:recnotfound];
	 [recnotfound release];
	 if (selectedSegment == 1)
	 recnotfound.text = @"You have no saved events to display. If you have an event you would like to save, simply go to event's detail page, click options, and then save.";
	 else
	 recnotfound.text = @"There are currently no events in your area. Try again later";
	 }
	 else 
	 {
	 recnotfound.hidden = YES;
	 recnotfound.text = @"";
	 }*/
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
	
	[self.view addSubview:scrollView];
	[scrollView addSubview:segmentedControlcal];
	[self.view addSubview:caltop];
	[self.view addSubview:lblMonthYear];
	[self.view addSubview:btnFilter];
	
	//[itemTableView reloadData];
	//[self.view addSubview:itemTableView];
	
	// calling pickOneDate
	if(arivefirsttime4cal>0)
	{
		// added if and else statement by pradeep on 28 jan 2011 for solving issue tool bar disappear
		if (backfrmeventdetail==0)
		{
			[self get120days4segmentchange];
			[self pickOneDate];
		}
		else 
		{
			backfrmeventdetail = 0;
			[itemTableView reloadData];
			[self.view addSubview:itemTableView];
		}
		
		// commented by pradeep on 28 jan 2011
		//[self get120days4segmentchange];
		//[self pickOneDate];
		
	}
	
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
	[itemTableView reloadData];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
	
    // Set up the cell...	
	UIImageView *imgPplBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 0, 320, 55) imageName:@"eventrowback.png"];
	[cell.contentView addSubview:imgPplBack];
	
	// commented by pradeep on 26 aug 2010 for lazy img feature
	//*********************
	
	/*UIImage *imageforresize = [[stories  objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	 CGImageRef realImage = imageforresize.CGImage;
	 float realHeight = CGImageGetHeight(realImage);
	 float realWidth = CGImageGetWidth(realImage);
	 float ratio = realHeight/realWidth;
	 float modifiedWidth = 60/ratio;
	 
	 CGRect imageRect = CGRectMake(9, 7, modifiedWidth + 15, 60 );	
	 usrImage = [[UIImageView alloc] initWithFrame:imageRect];
	 usrImage.image = [[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	 
	 // Get the Layer of any view
	 CALayer * l = [usrImage layer];
	 [l setMasksToBounds:YES];
	 [l setCornerRadius:10.0];
	 
	 // You can even add a border
	 [l setBorderWidth:1.0];
	 [l setBorderColor:[[UIColor clearColor] CGColor]];
	 [cell.contentView addSubview:usrImage];
	 [usrImage release];*/
	// commented by pradeep on 26 aug 2010 for lazy img feature
	//*********************
	
	//*************** lazy img code start
	
	// added by pradeep on 16 dec 2010 for event improvenent i.e. calendar
	//************* start	
	
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:segmentedControlcal.selectedSegmentIndex]];
	
	//NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
	
	//stories = [NSMutableArray arrayWithArray:filteredArray];
	
	//stories = [[NSArray alloc] init];
	
	//stories = [stories4cal filteredArrayUsingPredicate:predicate];
	
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
	if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
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

		
	}
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
	lblEvent = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventname"] frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:13 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
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
	
	lblEventDtFrom = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"fromtime"] frame:CGRectMake(lablefromFrame.origin.x + 20, lablefromFrame.origin.y, 70, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDtFrom];
	/*EVENT DATE FROM ENDS*/
	
#pragma mark EVENT DATE TO STARTS
	CGRect lableToFrame = CGRectMake(lablefromFrame.origin.x + 80, lablefromFrame.origin.y, 90, 15);
	lblEventDtTo = [UnsocialAppDelegate createLabelControl:@"To:" frame:lableToFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	[cell.contentView addSubview:lblEventDtTo];
	
	NSString *evttodate = [[stories objectAtIndex:indexPath.row] objectForKey:@"totime"];
	if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventdescription"] isEqualToString:@"meetup"]) {
		evttodate = @"NA";
	}
	
	lblEventDtTo = [UnsocialAppDelegate createLabelControl:evttodate frame:CGRectMake(lableToFrame.origin.x + 22, lableToFrame.origin.y, 90, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	//lblEventDtTo = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"totime"] frame:CGRectMake(lableToFrame.origin.x + 22, lableToFrame.origin.y, 90, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblEventDtTo];
	/*EVENT DATE TO ENDS*/
	
#pragma mark EVENT INDUSTRY
	CGRect lableIndFrame = CGRectMake(lableNameFrame.origin.x, lblEventDtFrom.origin.y + 15, 200, 15);	
	// commented and added  by pradeep on 31 jan 2011 for displaying industry as "Premium event" for premium events
	// 31 jan 2011 start******************
	//lblEventInd = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] frame:lableIndFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
	{
	lblEventInd = [UnsocialAppDelegate createLabelControl:@"Premium Event" frame:lableIndFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	}
	else {
		lblEventInd = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] frame:lableIndFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	}
	// end 31 jan 2011 ************

	[cell.contentView addSubview:lblEventInd];
	
#pragma mark EVENT DISTANCE STARTS
	// commented by pradeep on 8 feb 2011 for changing the x-axis co-ordinates
	//CGRect lableDistanceFrame = CGRectMake(9, lblEventDtFrom.origin.y + 15, 300, 15);
	CGRect lableDistanceFrame = CGRectMake(-10, lblEventDtFrom.origin.y + 15, 300, 15);
	/*
	 lblEventDistance = [UnsocialAppDelegate createLabelControl:@"Distance:" frame:lableDistanceFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];	
	 [cell.contentView addSubview:lblEventDistance];
	 */
	lblEventDistance = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"] frame:lableDistanceFrame txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblEventDistance];
	/*EVENT DISTANCE ENDS*/
	
#pragma mark Check Event Type
	// commented by pradeep on 8 feb 2011 for removing preeventicon.png for premium events i.e. zic-zag image
	/*
	if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
	{
		
		premiumeventico = [UnsocialAppDelegate createImageViewControl:CGRectMake(280, 8, 21, 25) imageName:@"preeventicon.png"];
		[cell.contentView addSubview:premiumeventico];
	}*/
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return 10;
	return [stories count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	// added by pradeep on 28 jan 2011 for fixing bug i.e. toolbar disappearing
	backfrmeventdetail = 1;
	
	// added by pradeep on 16 dec 2010 for event improvenent i.e. calendar
	//************* start	
	
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventdate ==  %@)", [dateFrmat objectAtIndex:segmentedControlcal.selectedSegmentIndex]];
	
	//NSArray *filteredArray = [stories4cal filteredArrayUsingPredicate:predicate];
	
	//stories = [NSMutableArray arrayWithArray:filteredArray];
	
	//stories = [[NSArray alloc] init];
	
	//stories = [stories4cal filteredArrayUsingPredicate:predicate];
	
	// added by pradeep on 16 dec 2010 for event improvenent i.e. calendar
	//************* end
	
	
	aryEventDetails = [[NSMutableArray alloc]init];
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"guid"]]; //0
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventname"]]; //1
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventdescription"]]; //2
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventaddress"]]; //3
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"]];//4
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventdate"]];//5
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"fromtime"]];//6
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"totime"]];//7
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventcontact"]];//8
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventwebsite"]];//9
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"isrecurring"]];//10
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventtype"]];//11
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"currentdistance"]];//12
	[aryEventDetails addObject:[NSString stringWithFormat:@"%i",1]]; // 13 comingfrom
	[aryEventDetails addObject:[NSString stringWithFormat:@"%i",segmentedControl.selectedSegmentIndex]]; // 14
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventlongitude"]];//15
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventlatitude"]];//16
	
	
	//UIImage *eImage = [[stories objectAtIndex:indexPath.row] objectForKey:@"itemPicture"];
	//if(eImage)
	//	[aryEventDetails addObject:eImage];//17
	
	//******************** for lazi img start
	
	//NSURL *url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
	
	
	// commented by pradeep on 16 dec 2010 and added new one below
	//[aryEventDetails addObject:[imageURLs4Lazy objectAtIndex:indexPath.row]];//17
	
	// commented by pradeep on 9 feb 2011 and added for event detail page image
	// **************** start 9 feb 2011
	//[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"isrecurring"]];//17
	
	// added by pradeep on 9 feb 2011 for changing images according to event industry
	//NSURL *url;
	if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
	{
		[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"isrecurring"]];//17
	}
	else 
	{
		if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] isEqualToString:@"Business"])
		{
			[aryEventDetails addObject:[globalUrlString stringByAppendingString:@"/images/business.png"]];//17
		}
		else if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] isEqualToString:@"Social"])
		{
			[aryEventDetails addObject:[globalUrlString stringByAppendingString:@"/images/social.png"]];//17
		}
		else if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventindustry"] isEqualToString:@"Technology"])
		{
			[aryEventDetails addObject:[globalUrlString stringByAppendingString:@"/images/technology.png"]];//17
		}
		else {
			[aryEventDetails addObject:[globalUrlString stringByAppendingString:@"/images/dashevents.png"]];//17
		}
	}
	
	// ********* end 9 feb 2011
	
	// **************** end 9 feb 2011
	
	//******************** for lazi img end
	[aryEventDetails addObject:[[stories objectAtIndex:indexPath.row] objectForKey:@"eventdateto"]];//18
	
	
	
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
	if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"eventtype"] isEqualToString:@"sponsoredevent"])
	{
		SponsoredSplash *eventDetails = [[SponsoredSplash alloc] init];
		//eventDetails.calendarselectedindex = [NSString stringWithFormat:@"%d",segmentedControlcal.selectedSegmentIndex];
		
		whichsegmentselectedlasttime4cal = segmentedControlcal.selectedSegmentIndex;
		//****** added by pradeep on 17 dec 2010 start
		startLogicSponSplashCameFrom = [[NSMutableArray alloc] init];
		[startLogicSponSplashCameFrom addObject:@"eventlist"];		
		[self.navigationController pushViewController:eventDetails animated:YES];
	}
	else 
	{
		EventDetails *eventDetails = [[EventDetails alloc]init];
		whichsegmentselectedlasttime4cal = segmentedControlcal.selectedSegmentIndex;
		[self.navigationController pushViewController:eventDetails animated:YES];
	}
	
	
	
}

// Override to support editing the table view.
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
			recnotfound = [UnsocialAppDelegate createLabelControl:nomsg frame:CGRectMake(30, 170, 260, 130) txtAlignment:UITextAlignmentCenter numberoflines:6 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			recnotfound.hidden = NO;
			[self.view addSubview:recnotfound];
			//[recnotfound release];
			
			// commented on 27 dec 2010 by pradeep, it will work for delete btn (since now rite navbar btn is replaced with toggle btn, earlier it was for delete saved items frm list
			//************
			//self.navigationItem.rightBarButtonItem = nil;
			//************
			
			self.navigationItem.leftBarButtonItem.enabled = YES;
		}
	}
}

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
	
	// added by pradeep on 10 Jan 2011 for releasing used memory but it is not working perfectly and still shows low memory warning 
	/*if (freemmry==0)
	 {
	 [UnsocialAppDelegate release_used_memory];
	 freemmry = 1;
	 }*/
	NSLog(@"didReceiveMemoryWarning called");
	
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	//self.view = nil;
	NSLog(@"viewDidUnload called");
	[super viewDidUnload];
	
}


- (void)dealloc {
    NSLog(@"event.m dealloc called");
	
	// added by pradeep on 29 june 2011
	//itemTableView.delegate = nil;
	//scrollView.delegate = nil;
	// end 29 june 2011
	
	[super dealloc];
}


@end
