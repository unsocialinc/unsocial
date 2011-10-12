//
//  SearchViewControllerImproved.m
//  Unsocial
//
//  Created by santosh khare on 5/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchViewControllerImproved.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "SearchViewController.h"
#import "SearchEvents.h"
#import "Person.h"

BOOL alreadysearch;
int whichsegmentselectedlasttime4search;

@implementation SearchViewControllerImproved
@synthesize puserid;

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
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;
	//******************************
	
	mySearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 43.0, 320, 35)] autorelease];
	mySearchBar.delegate = self;
	mySearchBar.tintColor = [UIColor blackColor];
	mySearchBar.barStyle = UIBarStyleBlackOpaque;
	mySearchBar.showsCancelButton = YES;
	
	// added by pradeep on 9 feb 2011 for place holder
	mySearchBar.placeholder = @"type name or tags";
	
		// note: here you can also change its "tintColor" property to a different UIColor
	
	[self.view addSubview:mySearchBar];
	/*mySearchBar = [UnsocialAppDelegate createTextFieldControl:CGRectMake(10, 5, 300, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter search criteria" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeAlphabet returnKey:UIReturnKeySearch];
	mySearchBar.backgroundColor = [UIColor clearColor];
	mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	[mySearchBar setDelegate:self];	
		
	/*btnSettags = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnSearch_Click) frame:CGRectMake(255, 2, 40, 40) imageStateNormal:@"peoplesearch.png" imageStateHighlighted:@"peoplesearch2.png" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnSettags.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
	[self.view addSubview:btnSettags];
	[self.view addSubview:mySearchBar];*/
	
	// added for new requirement for search section added by pradeep on 9 Nov 2010 start
	//**********************
	
	NSArray *segmentTextContent = [NSArray arrayWithObjects:@"PEOPLE", @"EVENTS", nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.frame = CGRectMake(20, 5, 280, 35);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;	
	segmentedControl.tintColor = [UIColor colorWithRed:240/255.0 green:141/255.0 blue:60/255.0 alpha:1.0];
	//segmentedControl.selectedSegmentIndex = 0;//whichsegmentselectedlasttime4event;
	if (whichsegmentselectedlasttime4search==1)
		itemTableView.hidden=YES;
	segmentedControl.selectedSegmentIndex = whichsegmentselectedlasttime4search;
	[self.view addSubview:segmentedControl];
	
	// added for new requirement for search section added by pradeep on 9 Nov 2010 end
	//**********************

	
}

// added for new requirement for search section added by pradeep on 9 Nov 2010 start
//**********************
- (void)segmentAction:(id)sender 
{
	
	/*self.navigationItem.leftBarButtonItem.enabled = YES;
	 [itemTableView setEditing:NO animated:YES];	
	 editing = NO;*/
	/*if(arivefirsttime4event>0)
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
	}*/
	NSLog(@"hello segment, calls first time");
	//mySearchBar.text = @"";
	
	whichsegmentselectedlasttime4search = segmentedControl.selectedSegmentIndex;
	if (segmentedControl.selectedSegmentIndex == 0)
	{
		self.navigationItem.rightBarButtonItem.enabled = YES;
		[self btnSearch_Click];
		[self getRecentSearchTagsDataFromFile];
	}
	else {
		itemTableView.hidden=YES;
		self.navigationItem.rightBarButtonItem.enabled = NO;
		CGRect lableRecNotFrame = CGRectMake(10, 200, 300, 60);
		// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
		//recnotfound = [UnsocialAppDelegate createLabelControl:@"Please put a keyword in the search box." frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];	
		recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Please put a keyword in the search box." frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		// end 17 august 2011
		
		[self.view addSubview:recnotfound];
		// 13 may 2011 by pradeep //[recnotfound release];
	}

	
	
}
// added for new requirement for search section added by pradeep on 9 Nov 2010 end
//**********************

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	activityView.hidden = YES;
	[activityView stopAnimating];
	
	itemTableView.hidden = NO;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	if (alreadysearch)
	{
		// commented by pradeep on 9 feb 2011 for setting search text box as blank if already searched
		//*********** 9 feb start
		//mySearchBar.text = [searchtxt objectAtIndex:0];
		//*********** 9 feb end
		
		if (!itemTableView)
		{
			itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, 320, 320) style:UITableViewStyleGrouped];
			itemTableView.delegate = self;
			itemTableView.dataSource = self;
			//itemTableView.rowHeight = 50;
			itemTableView.autoresizesSubviews = YES;
			itemTableView.backgroundColor = [UIColor clearColor];
			//itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete_click)] autorelease];
	editing = NO;
	
	if (whichsegmentselectedlasttime4search==1)
	{
		itemTableView.hidden=YES;
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	if ([aryRecentSearchTags count] == 0)
	{
		self.navigationItem.rightBarButtonItem = nil;
	}
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
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[mySearchBar resignFirstResponder];
	// commented by pradeep on 12 nov 2010 for search improvement
	//[self btnSearch_Click];
	
	// aaded by pradeep on 26 nov 2010 for fixing bug related to table editing enabled
	//*******
	self.navigationItem.leftBarButtonItem.enabled = YES;
	[itemTableView setEditing:NO animated:YES];	
	editing = NO;
	//*******
	
	// ****** for checking and triming whitespaces from search item added by pradeep on 24 nov 2010
	
	 NSString *searchtext = mySearchBar.text;
	 NSString *searchfield = [searchtext stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	 if ([searchfield compare:@""]==NSOrderedSame) 
	 {
	 NSString * errorString = [NSString stringWithFormat:@"Please enter valid tag for search."];
	 UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Invalid tag" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	 [errorAlert show];
	 loading.hidden = YES;
	 imgForOverlap.hidden = YES;
	 [activityView stopAnimating];
	 mySearchBar.text = @"";
	 return;
	 }
	
	// *******
	
	
	if (segmentedControl.selectedSegmentIndex==0)
	{
		alreadysearch=TRUE;
		//[mySearchBar resignFirstResponder];	
		
		searchtxt = [[NSMutableArray alloc] init];
		[searchtxt addObject:searchfield];
		
		//[self removeLocalFiles:@"userrecentsearchtags"];
		[self updateRecentSearchDataFileOnSave:searchfield :@""];
		
		SearchViewController  *svc = [[SearchViewController alloc]init];
		svc.searchkey = searchfield;
		[self.navigationController pushViewController:svc animated:YES];
	}
	else 
	{
		searchtxt = [[NSMutableArray alloc] init];
		[searchtxt addObject:searchfield];
						
		SearchEvents  *se = [[SearchEvents alloc]init];
		se.searchkey = searchfield;
		[self.navigationController pushViewController:se animated:YES];
	}

	
	
}

// for creating local file for recent search items added by pradeep on 13 nov 2010 start
//**********************************

// i am not using just use it for testing purpose here
- (void) removeLocalFiles: (NSString *) filename
{
	// during logout, delete all persistance files locally i.e. delete files or remove files
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];	
	NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
	//documentsDirectory = [documentsDirectory stringByAppendingString:@"/settingsinfo4UnsocialVideo"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSLog(@"%@", fileManager);
	if([fileManager fileExistsAtPath:path]) // if all the videos have deleted then file should be deleted and lastVisitedFeature must be reloaded
	{
		[fileManager removeItemAtPath:path error:NULL];			
	}
}

- (void) updateRecentSearchDataFileOnSave:(NSString *)searchitem:(NSString *)str { // updating file for user's recent search tags 
	// here uid 
	BOOL issearchedtagalreadyadded = FALSE;
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	// working on this but pause by pradeep due to resolving location update issue
	NSString *tempAllRecentTags = [[NSString alloc] init];
	if ([aryRecentSearchTags count] > 0)
	{
		for (int i=0; i<[aryRecentSearchTags count]; i++)
		{
			if ([str compare:@""] == NSOrderedSame) // update file according to search text box only not during deleting rows from section 2 i.e. recent search
			{
				if([[aryRecentSearchTags objectAtIndex:i] compare:[searchitem lowercaseString]] == NSOrderedSame)
				{
					issearchedtagalreadyadded = TRUE;
					break;
				}
			}
		}	
		//NSLog(str);
			
	}
	if (!issearchedtagalreadyadded) // issearchedtagalreadyadded i.e. tag is not added already
	{
		// for testing purpose added by pradeep on 23 nov 2010
		/*for (int i=0; i < [aryRecentSearchTags count]; i++)
		{
			NSLog(@"arry item at index %d is: %@",i, [aryRecentSearchTags objectAtIndex:i]);
		}*/
		// reverse the nsmutable array items
		NSArray* reversed = [[aryRecentSearchTags reverseObjectEnumerator] allObjects];
		[aryRecentSearchTags removeAllObjects];
		for(int i=0; i < [reversed count]; i++)
		{
			NSLog([reversed objectAtIndex:i]);
			[aryRecentSearchTags addObject:[reversed objectAtIndex:i]];
		}		
		
		// update file method is calling from two ways, during adding and deleting
		// here i am checking from where method is called
		if ([str compare:@""] == NSOrderedSame) // update file according to search text box only not during deleting rows from section 2 i.e. recent search			
			[aryRecentSearchTags addObject:searchitem]; // added text box value to aray 
		
		//for (int i=0; i<[aryRecentSearchTags count]; i++)
		for (int j=[aryRecentSearchTags count]-1; j >= 0; j--) 
		{	
			NSLog(@"loops counter value: %d",j);
			NSLog([aryRecentSearchTags objectAtIndex:j]);
			if ([tempAllRecentTags compare:@""] == NSOrderedSame)
			{
				tempAllRecentTags = [tempAllRecentTags stringByAppendingString:[aryRecentSearchTags objectAtIndex:j]];
				//[tempAllRecentTags appendString:@","];
			}
			else {
				tempAllRecentTags = [tempAllRecentTags stringByAppendingString:@","];
				tempAllRecentTags = [tempAllRecentTags stringByAppendingString:[aryRecentSearchTags objectAtIndex:j]];
			}			
		}
		NSLog(tempAllRecentTags);
		newPerson.strrecentsearchtags = tempAllRecentTags;
		//newPerson.userid = [arrayForUserID objectAtIndex:0];
		
		[userInfo insertObject:newPerson atIndex:0];
		[newPerson release];
		
		NSMutableData *theData;
		NSKeyedArchiver *encoder;
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"userrecentsearchtags"];	
		theData = [NSMutableData data];
		encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
		
		[encoder encodeObject:userInfo forKey:@"userInfo"];
		[encoder finishEncoding];
		
		[theData writeToFile:path atomically:YES];
		[encoder release];
	}
	if ([str compare:@""] != NSOrderedSame)
	{
		if ([aryRecentSearchTags count] == 0)
		{
			[self removeLocalFiles:@"userrecentsearchtags"]; // since all the recent serch items have deleted
		}
	}
	
	
}

- (BOOL) getRecentSearchTagsDataFromFile {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"userrecentsearchtags"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	aryRecentSearchTags = [[NSMutableArray alloc] init];
	if ([aryRecentSearchTags count] > 0)
		[aryRecentSearchTags removeAllObjects];
	if([fileManager fileExistsAtPath:path]) 
	{
		//open it and read it 
		NSLog(@"data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];
		//[self setPersonArray:tempArray];	
		
		/*for (int i=0; i < [tempArray count]; i++) 
		{
			NSLog([NSString stringWithFormat:@"saved item at %d index in file item:",i,[[tempArray objectAtIndex:i] strrecentsearchtags]]);

		}*/
		
		NSString *temprecenttags4test = [[tempArray objectAtIndex:0] strrecentsearchtags];
		NSLog(@"saved recent search item: %@", temprecenttags4test);
		
		NSArray *split = [[[tempArray objectAtIndex:0] strrecentsearchtags] componentsSeparatedByString:@","];
		
		for(int i=0; i < [split count]; i++)
		{			
			NSLog(@"all recent search tags with comma %@", [split objectAtIndex:i]);			
			
			[aryRecentSearchTags addObject:[split objectAtIndex:i]];
		}
		
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
		
		//******* commented by pradeep on 13 nov 2010
		
		/*NSLog(@"%@", [[tempArray objectAtIndex:0] userid]);
		gbluserid = [[tempArray objectAtIndex:0] userid];
		//arrayForUserID = [[NSMutableArray alloc]init];
		if ([arrayForUserID count]==0)
			[arrayForUserID addObject:[[tempArray objectAtIndex:0] userid]];
		
		//*******************
		*/
		
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

//*****************************************
// for creating local file for recent search items added by pradeep on 13 nov 2010 end

	// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// aaded by pradeep on 26 nov 2010 for fixing bug related to table editing enabled
	//*******
	self.navigationItem.leftBarButtonItem.enabled = YES;
	[itemTableView setEditing:NO animated:YES];	
	editing = NO;
	//*******
	[mySearchBar resignFirstResponder];
}

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
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 220, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	
	
	[self.view addSubview:imgBack];
	[self.view addSubview:loading];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	loading.hidden = NO;
	[activityView startAnimating];
	
	[self.view addSubview:imgTBBack];
	[self.view addSubview:mySearchBar];
	[self.view addSubview:btnSettags];
	
	// added for new requirement for search section added by pradeep on 9 Nov 2010 end
	//**********************
	[self.view addSubview:segmentedControl];
	
	// added for new requirement for search section added by pradeep on 9 Nov 2010 end
	//**********************

	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
	
}

- (void)startProcess {
	NSLog(@"refreshing the data");
	
	[self getDataFromFile];
	{
		//[self getRecentSearchTagsDataFromFile];
		[stories removeAllObjects];//= nil;
		[self getPeopleData:@"searchpopulartabsforpeople"];
		
		// added by pradeep on 9 feb 2011 for disabling recnot found
		//if ([stories count] == 0)
		if ([stories count] == 0 && [aryRecentSearchTags count] == 0)
		{
			// if no records found
			
			CGRect lableRecNotFrame = CGRectMake(10, 200, 300, 60);
			// commented by pradeep on 17 august 2011
			//recnotfound = [[UILabel alloc] init];
			
			// commented by pradeep on 10 feb 2011 for changing the current message
			// ************ 10 feb start
			//recnotfound = [UnsocialAppDelegate createLabelControl:@"There are currently no profiles that match your requested tags." frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];		
			//[self.view addSubview:recnotfound];
			
			// added by pradeep on 10 feb 2011
			// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
			//recnotfound = [UnsocialAppDelegate createLabelControl:@"Please put a keyword in the search box." frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			recnotfound = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Please put a keyword in the search box." frame:lableRecNotFrame txtAlignment:UITextAlignmentCenter numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			// end 17 august 2011
			recnotfound.hidden = NO;
			[self.view addSubview:recnotfound];
			
			// ***************** end 10 feb 2011
			
			// 13 may 2011 by pradeep //[recnotfound release];
			itemTableView.hidden=YES;
		}
		else 
		{
			if (!itemTableView)
			{
				itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, 320, 320) style:UITableViewStyleGrouped];
				itemTableView.delegate = self;
				itemTableView.dataSource = self;
				//itemTableView.rowHeight = 50;
				itemTableView.autoresizesSubviews = YES;
				itemTableView.backgroundColor = [UIColor clearColor];
				//itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *title = @"";
	if (section == 0)
		title = @"Popular tabs";
	else if (section == 1) 
		title = @"Your recent searches";
	return title;
	
}*/

// for creating customize title for header section in grouped table added by pradeep on 12 nov 2010
//*********************

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:20];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
	
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	
	//headerLabel.text = <Put here whatever you want to display> // i.e. array element
	
	
	NSString *title = @"";
	if (section == 0)
		headerLabel.text = @"Popular tags";
	else if (section == 1) 
		headerLabel.text = @"Your recent searches";
	
	[customView addSubview:headerLabel];
	//return title;
	
	return customView;
}

// add heightForHeaderInSection function added by pradeep on 12 nov 2010
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}

//*********************

//*************** for setting editable table added by pradeep on 23 nov 2010

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
		return UITableViewCellEditingStyleNone;
	}
	else {
		return UITableViewCellEditingStyleDelete;
	}
	
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
		// Delete the row from the data source
		/*[aryTags removeObjectAtIndex:indexPath.row];
		flg4tracesendreq2serverduringback = YES;
		[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		if([aryTags count] == 0) {
			
			itemTableView.hidden = YES;
			//lblNotags.hidden = NO;			
			self.navigationItem.leftBarButtonItem.enabled = YES;
			self.navigationItem.rightBarButtonItem.enabled = NO;
			[itemTableView setEditing:NO animated:YES];	
			editing = NO;
			isSaved = YES;
		}
		//else 
		//	lblNotags.hidden = YES;
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		
		// Insert the row from the data source
		[aryTags addObject:txttags.text];
	} */
		//NSLog([NSString stringWithFormat:@"deleted row index: %@",indexPath]);
		//int rowindex = [aryRecentSearchTags count]-1-indexPath.row;
		if (indexPath.section == 1)
		{
			NSInteger row = [indexPath row];
			NSLog([NSString stringWithFormat:@"deleted row index: %d",row]);
			[aryRecentSearchTags removeObjectAtIndex:row];
			[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			if ([aryRecentSearchTags count] == 0)
			{
				self.navigationItem.leftBarButtonItem.enabled = YES;
				[itemTableView setEditing:NO animated:YES];	
				editing = NO;
				self.navigationItem.rightBarButtonItem = nil;
			}
			[self updateRecentSearchDataFileOnSave:@"" :@"deleteupdate"];
		}
	}
}

- (void)delete_click {
	//Do not let the user add if the app is in edit mode.
	//flg4tracesendreq2serverduringback = YES;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	printf("Did begin editing\n");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	printf("Did end editing\n");
}

//*************** 23 nov end


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0)
        return [stories count];
	else if (section == 1)
		return [aryRecentSearchTags count]; //3;//[stories count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // lazy img implementation by pradeep *****************
	//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
	}
	//CGRect lableNameFrame = CGRectMake(89, 4, 314, 18);	
	CGRect textframe = CGRectMake(5.0, 10.0, 280.0, 25.0);
	UILabel *textLabel = [[UILabel alloc] initWithFrame:textframe];
	[textLabel setFont:[UIFont fontWithName:kAppFontName size:15]];
	textLabel.backgroundColor = [UIColor clearColor];
	NSString *occuranceofpopulartags = @"";
	NSString *populartag = @"";
	
	if (indexPath.section == 0)
	{		
		//[cell.contentView addSubview:lblUserName];
		if (row == 0)
		{
			occuranceofpopulartags = [NSString stringWithFormat:@"(%@)", [[stories objectAtIndex:row] objectForKey:@"occurance"]];
			if ([[[stories objectAtIndex:row] objectForKey:@"keywords"] length] > 32)
			{
				populartag = [[[[stories objectAtIndex:row] objectForKey:@"keywords"] substringWithRange:NSMakeRange(0,31)] stringByAppendingString:@"..."];
			}
			else {
				populartag = [[stories objectAtIndex:row] objectForKey:@"keywords"];
			}

				
			//textLabel.text = [populartag stringByAppendingString:occuranceofpopulartags];
			textLabel.text = [[populartag stringByAppendingString:@" "] stringByAppendingString:occuranceofpopulartags];
			[cell.contentView addSubview:textLabel];
		}
		else if (row == 1)
		{
			//textLabel.text = [[stories objectAtIndex:row] objectForKey:@"keywords"];
			occuranceofpopulartags = [NSString stringWithFormat:@"(%@)", [[stories objectAtIndex:row] objectForKey:@"occurance"]];
			if ([[[stories objectAtIndex:row] objectForKey:@"keywords"] length] > 32)
			{
				populartag = [[[[stories objectAtIndex:row] objectForKey:@"keywords"] substringWithRange:NSMakeRange(0,31)] stringByAppendingString:@"..."];
			}
			else {
				populartag = [[stories objectAtIndex:row] objectForKey:@"keywords"];
			}
			
			
			//textLabel.text = [populartag stringByAppendingString:occuranceofpopulartags];
			textLabel.text = [[populartag stringByAppendingString:@" "] stringByAppendingString:occuranceofpopulartags];
			
			//textLabel.text = [[[stories objectAtIndex:row] objectForKey:@"keywords"] stringByAppendingString:occuranceofpopulartags];
			[cell.contentView addSubview:textLabel];
		}
		else if (row == 2)
		{
			//textLabel.text = [[stories objectAtIndex:row] objectForKey:@"keywords"];
			occuranceofpopulartags = [NSString stringWithFormat:@"(%@)", [[stories objectAtIndex:row] objectForKey:@"occurance"]];
			
			if ([[[stories objectAtIndex:row] objectForKey:@"keywords"] length] > 32)
			{
				populartag = [[[[stories objectAtIndex:row] objectForKey:@"keywords"] substringWithRange:NSMakeRange(0,31)] stringByAppendingString:@"..."];
			}
			else {
				populartag = [[stories objectAtIndex:row] objectForKey:@"keywords"];
			}
			
			
			//textLabel.text = [populartag stringByAppendingString:occuranceofpopulartags];
			textLabel.text = [[populartag stringByAppendingString:@" "] stringByAppendingString:occuranceofpopulartags];
			//textLabel.text = [[[stories objectAtIndex:row] objectForKey:@"keywords"] stringByAppendingFormat:occuranceofpopulartags];
			[cell.contentView addSubview:textLabel];
		}
		else if (row == 3)
		{
			//textLabel.text = [[stories objectAtIndex:row] objectForKey:@"keywords"];
			occuranceofpopulartags = [NSString stringWithFormat:@"(%@)", [[stories objectAtIndex:row] objectForKey:@"occurance"]];
			
			if ([[[stories objectAtIndex:row] objectForKey:@"keywords"] length] > 32)
			{
				populartag = [[[[stories objectAtIndex:row] objectForKey:@"keywords"] substringWithRange:NSMakeRange(0,31)] stringByAppendingString:@"..."];
			}
			else {
				populartag = [[stories objectAtIndex:row] objectForKey:@"keywords"];
			}
			
			
			//textLabel.text = [populartag stringByAppendingString:occuranceofpopulartags];
			textLabel.text = [[populartag stringByAppendingString:@" "] stringByAppendingString:occuranceofpopulartags];
			//textLabel.text = [[[stories objectAtIndex:row] objectForKey:@"keywords"] stringByAppendingString:occuranceofpopulartags];
			[cell.contentView addSubview:textLabel];
		}
		else if (row == 4)
		{
			//textLabel.text = [[stories objectAtIndex:row] objectForKey:@"keywords"];
			occuranceofpopulartags = [NSString stringWithFormat:@"(%@)", [[stories objectAtIndex:row] objectForKey:@"occurance"]];
			
			if ([[[stories objectAtIndex:row] objectForKey:@"keywords"] length] > 32)
			{
				populartag = [[[[stories objectAtIndex:row] objectForKey:@"keywords"] substringWithRange:NSMakeRange(0,31)] stringByAppendingString:@"..."];
			}
			else {
				populartag = [[stories objectAtIndex:row] objectForKey:@"keywords"];
			}
			
			
			//textLabel.text = [populartag stringByAppendingString:occuranceofpopulartags];
			textLabel.text = [[populartag stringByAppendingString:@" "] stringByAppendingString:occuranceofpopulartags];
			//textLabel.text = [[[stories objectAtIndex:row] objectForKey:@"keywords"] stringByAppendingString:occuranceofpopulartags];
			[cell.contentView addSubview:textLabel];
		}
	}
	else if (indexPath.section == 1){
		NSLog(@"Section 2");
		/*if (row == 0)
		{
			textLabel.text = [aryRecentSearchTags objectAtIndex:row];
			[cell.contentView addSubview:textLabel];
		}
		else if (row == 1)
		{
			textLabel.text = @"2";
			[cell.contentView addSubview:textLabel];
		}
		else if (row == 2)
		{
			textLabel.text = @"3";
			[cell.contentView addSubview:textLabel];
		}*/
		
		for (int i=0; i < [aryRecentSearchTags count]; i++) 
		{
			if (row == i)
			{
				NSLog([aryRecentSearchTags objectAtIndex:i]);
				//NSLog([aryRecentSearchTags objectAtIndex:j]);
				textLabel.text = [aryRecentSearchTags objectAtIndex:i];
				[cell.contentView addSubview:textLabel];
				break;
			}
		}
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;

	
	
	/*else {
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

	CGRect lableNameFrame = CGRectMake(89, 4, 314, 18);	
	lblUserName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"username"] frame:lableNameFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblUserName];
	
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
	[lblFunctionName release];
	
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
	
	[lblcompany release];
	[lblindustry release];
	[lblfunction release];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;*/
	
	//***************end
	
	
	
	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*PeoplesUserProfile *peoplesUserProfile = [[PeoplesUserProfile alloc]init];
	peoplesUserProfile.myname  = [myName objectAtIndex:0];
	
	// for aroundme tab by using stories
	//if (segmentedControl.selectedSegmentIndex==0)
	{
		peoplesUserProfile.userid = [[stories objectAtIndex:indexPath.row] objectForKey:@"guid"];			peoplesUserProfile.username = [[stories objectAtIndex:indexPath.row] objectForKey:@"username"];
		peoplesUserProfile.userprefix = [[stories objectAtIndex:indexPath.row] objectForKey:@"prefix"];
		
		peoplesUserProfile.useremail = [[stories objectAtIndex:indexPath.row] objectForKey:@"email"];
		peoplesUserProfile.usercontact = [[stories objectAtIndex:indexPath.row] objectForKey:@"contact"];	
		peoplesUserProfile.usercompany = [[stories objectAtIndex:indexPath.row] objectForKey:@"company"];	
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
	
	[self.navigationController pushViewController:peoplesUserProfile animated:YES];*/
	
	[mySearchBar resignFirstResponder];
	SearchViewController  *svc = [[SearchViewController alloc]init];
	if (segmentedControl.selectedSegmentIndex==0)
	{
		if (indexPath.section == 0) // for section: popular tags
			svc.searchkey = [[stories objectAtIndex:indexPath.row] objectForKey:@"keywords"];
		else svc.searchkey = [aryRecentSearchTags objectAtIndex:indexPath.row];
	}
	[self.navigationController pushViewController:svc animated:YES];
}

- (void) getPeopleData:(NSString *) flg4whichtab {
	
	NSString *searchfield = @""; //mySearchBar.text;//[NSString stringWithFormat:@"%@\r\n",mySearchBar.text];	
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	// Time Formats
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	
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
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&distance=%@&flag2=%@",@"searchimprovement",gbllatitude,gbllongitude,gbluserid,usertime,searchfield,flg4whichtab]; // NOTE: here searchfield is placed with discatncemiles field from other people criteria
	
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
		//if ([arrayForUserID count]==0)
		//	[arrayForUserID addObject:[[tempArray objectAtIndex:0] userid]];
		
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
	//imageURLs4Lazy = [[NSMutableArray alloc]init];
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
	
	/*if ([elementName isEqualToString:@"ttl"])
	{
		//item4whichtab = [[NSMutableDictionary alloc]init];
		//userforwhichtab = [[NSMutableString alloc]init];
	}*/
	
	if ([elementName isEqualToString:@"item"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		occurance = [[NSMutableString alloc] init];
		keywords = [[NSMutableString alloc] init];
		
		/*userid = [[NSMutableString alloc] init];
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
		userstatus = [[NSMutableString alloc]init];*/
	}
	/*if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}*/
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//if ([elementName isEqualToString:@"ttl"])
	//	[item4whichtab setObject:userforwhichtab forKey:@"whichtab"];
	
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		[item setObject:occurance forKey:@"occurance"];
		[item setObject:keywords forKey:@"keywords"];
		
		// save values to an item, then store that item into the array...
		/*[item setObject:userprefix forKey:@"prefix"];
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
		
				
		[imageURLs4Lazy addObject:currentImageURL];*/
		
		
		[stories addObject:[item copy]];
		/*if ([userforwhichtab compare:@"everyone"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==0)
			[stories4peoplearoundme addObject:[item copy]];
		else if ([userforwhichtab compare:@"myinterest"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==1)
			[stories4peoplemyinterest addObject:[item copy]];
		else if ([userforwhichtab compare:@"bookmark"] == NSOrderedSame)//if (segmentedControl.selectedSegmentIndex==2)
			[stories4peoplebookmark addObject:[item copy]];*/
		//NSLog(@"adding story: %@", username);		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	NSLog(@"found characters: %@", string);
	if ([currentElement isEqualToString:@"occurance"]) {
		[occurance appendString:string];
	}else if ([currentElement isEqualToString:@"keywords"]) {
		[keywords appendString:string];
	}
	
	
	// save the characters for the current item...
	
	/*if ([currentElement isEqualToString:@"ttl"]) 
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
	}*/
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
	//mySearchBar.text = @"";	
	[searchtxt removeAllObjects];
	alreadysearch = FALSE;
	[self dismissModalViewControllerAnimated:YES];
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
	//mySearchBar.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
}


@end
