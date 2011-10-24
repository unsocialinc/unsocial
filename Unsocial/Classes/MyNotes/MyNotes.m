//
//  MyNotes.m
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyNotes.h"
	//#import "GlobalVariables.h"
#import "InboxShowMessage.h"
#import "UnsocialAppDelegate.h"
#import "ShowNote.h"

int arivefirsttime4msg;

@implementation MyNotes
@synthesize comingfrom, userid4displayingnotes, notepurposeflag, camefromwhichoption, eventid4attendeelistofnormalevent;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self createControls];
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor blackColor];
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
	
	/*UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;*/
	
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

	// commented n added by pradeep on 13 july 2011 for ading + btn on navigation bar in place of delete (thrash) btn
	if ([notepurposeflag compare:NULL] != NSOrderedSame)
	{
		if(comingfrom != 0)
		//if ([notepurposeflag compare:@"singleuser"] == NSOrderedSame) // if user landed from userprofile > mynote > show note then no need to show btn by which user see the profile of profile saved user 
		//	and there will be an option to add note based on single user
		{
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddNote_Click)] autorelease];
		}
	}
	else //	if user come after clicking MY EVENT icon from springboard, no need to add note because we don't know note will be added for whome
	{
		notepurposeflag = @"all";
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddNote_Click)] autorelease];
	}	
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"INBOX", @"SENT", nil]];
	segmentedControl.frame = CGRectMake(20, 5, 280, 35);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;	
	segmentedControl.tintColor = [UIColor colorWithRed:240/255.0 green:141/255.0 blue:60/255.0 alpha:1.0];
	[self.view addSubview:segmentedControl];

	if (arivefirsttime4msg ==0) {
		
		segmentedControl.selectedSegmentIndex = 0;
	}
	else {
		
		segmentedControl.selectedSegmentIndex = whichsegmentselectedlasttime4msg;
	}
	segmentedControl.hidden = TRUE;
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//heading = [UnsocialAppDelegate createLabelControl:@"My Notes" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	heading = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"My Notes" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:heading];
}

-(void)displayAnimation {	
	
	imgBack2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack2.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack2];

	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//loading = [UnsocialAppDelegate createLabelControl:@"Retrieving notes\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	loading = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Retrieving notes\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

// not in use for my events feature
- (void)segmentAction:(id)sender {

	self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
	[self.view addSubview:segmentedControl];
	[self displayAnimation];
	//[self.view addSubview:heading];
	NSLog(@"segmentAction: selected segment = %d", [sender selectedSegmentIndex]);

	int selectedSegment = [sender selectedSegmentIndex];
	[itemTableView setHidden:YES];
	if (!itemTableView)
		arivefirsttime4msg = 0;
	
	if (arivefirsttime4msg == 0)
	{
		arivefirsttime4msg = 1;
		if(selectedSegment == 0) {
			
			[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getNotes) userInfo:self.view repeats:NO];
		}
		/*
		else {
			
			[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getSentMsg) userInfo:self.view repeats:NO];
		}*/
	}
	else
	{
		whichsegmentselectedlasttime4msg = selectedSegment;
			
		if(selectedSegment == 0) {
			
			[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getNotes) userInfo:self.view repeats:NO];
		}
		/*
		else {
				
			[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getSentMsg) userInfo:self.view repeats:NO];
		}*/
	}
//	activityView.hidden = loading.hidden = imgBack2.hidden = YES;
}

- (void)leftbtn_OnClick{

	[lastVisitedFeature removeAllObjects];
	[lastVisitedFeature addObject:@"notes"];
	if(comingfrom != 1)
	{
		[self dismissModalViewControllerAnimated:YES];
	}
	else {
		
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)createControls {
	
	if([stories count] > 0)
	{
		[self.view addSubview:imgBack];
		imgBack2.hidden = NO;
		[self.view addSubview:segmentedControl];
		[self.view addSubview:heading];
		itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 42, 320, 370) style:UITableViewStylePlain];
		itemTableView.delegate = self;
		itemTableView.dataSource = self;
		itemTableView.rowHeight = 56;
		itemTableView.backgroundColor = [UIColor clearColor];
		itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.view addSubview:itemTableView];
		itemTableView.hidden = NO;
		noMessage.hidden = YES;
	}
	else {
		
		itemTableView.hidden = YES;
		[self.view addSubview:imgBack];
		imgBack2.hidden = NO;
		[self.view addSubview:segmentedControl];
		[self.view addSubview:heading];
		NSString *nomsg = @"";
		if (segmentedControl.selectedSegmentIndex==0)
			nomsg = @"There are no notes to display right now.";
		else nomsg = @"There are no notes to display right now.";
		
		// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
		//noMessage = [UnsocialAppDelegate createLabelControl:nomsg frame:CGRectMake(30, 200, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		noMessage = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:nomsg frame:CGRectMake(30, 200, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];		
		// end 17 august 2011
		
		noMessage.hidden = NO;
		[self.view addSubview:noMessage];
		// 13 may 2011 by pradeep //[noMessage release];
	}
	loading.hidden = YES;
	[activityView stopAnimating];
	activityView.hidden = YES;
}

// added by pradeep on 13 july 2011 for add (+) btn for adding note feature start
#pragma mark add note feature start

- (void) btnAddNote_Click {
	
	/*UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Enter Note"];
	[dialog setMessage:@"\n\n\n\n\n"];
	[dialog addButtonWithTitle:@"Cancel"];
	[dialog addButtonWithTitle:@"Save"];
	
	tvNote = [[UITextView alloc] initWithFrame:CGRectMake(20.0, 40.0, 245.0, 110.0)];
	tvNote.text = @"";
	tvNote.delegate = self;
	tvNote.returnKeyType = UIReturnKeyDefault;
	tvNote.keyboardType = UIKeyboardTypeDefault;
	tvNote.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
	tvNote.layer.cornerRadius = 5;
	[tvNote setBackgroundColor:[UIColor whiteColor]];
	[dialog addSubview:tvNote];
	[tvNote becomeFirstResponder];
	//CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, -100.0);
	//[dialog setTransform: moveUp];
	[dialog show];
	[dialog release];
	//[tvNote release];
	//messageType = 3;*/
	
	TTPostController *postController = [[TTPostController alloc] init]; 
	postController.delegate = self; // self must implement the TTPostControllerDelegate protocol 
	self.popupViewController = postController; 
	postController.navigationItem.rightBarButtonItem.title = @"Save";
	//postController.textView.text = @"Hello";
	postController.superController = self; // assuming self to be the current UIViewController 
	[postController showInView:self.view animated:YES]; 
	[postController release];
}

// added by pradeep on 9 august 2011 for making save notes UI similar to send msg UI of Inbox feature

- (BOOL) postController:	(TTPostController *) 	postController willPostText: (NSString *) text {
	
	//NSLog(@"Text: %@", text); 
	/*if([text compare:nil] == NSOrderedSame || [text compare:@""] == NSOrderedSame)
	 {
	 errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please write message." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	 [errorAlert show];
	 [errorAlert release];
	 return NO;
	 }
	 else*/ {
		 return YES;
	 }
}

- (void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result { 
	
	BOOL isuserbookmarked = [self addNoteRequest:text];
	if (isuserbookmarked)
	{
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Note added successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alertOnChoose show];
		[alertOnChoose release];
		//self.navigationItem.rightBarButtonItem = nil;
	}
	else 
	{
		//if ([alreadybookmark isEqualToString:@"alreadybookmark"])
		{
			UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Note has not added successfully, please try again later!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alertOnChoose show];
			[alertOnChoose release];
			//self.navigationItem.rightBarButtonItem = nil;
		}
	}
	
	//[tvNote resignFirstResponder];
	//self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
}

// end 9 august 2011

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	//printf("\nshouldChangeTextInRange\n");
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 200) ? NO : YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	printf("\nDid begin editing\n");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	printf("\nDid end editing\n");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
    [textField resignFirstResponder];
	printf("\nClearing Keyboard\n");
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	// provide my own Save button to dismiss the keyboard
	
}

/*-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex 
{	
	if(buttonIndex == 0){
		
		[tvNote resignFirstResponder];
	}
	else 
	{
		
		BOOL isuserbookmarked = [self addNoteRequest:@""];
		if (isuserbookmarked)
		{
			UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Note added successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alertOnChoose show];
			[alertOnChoose release];
			self.navigationItem.rightBarButtonItem = nil;
		}
		else 
		{
			//if ([alreadybookmark isEqualToString:@"alreadybookmark"])
			{
				UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Note has not added successfully, please try again later!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
				[alertOnChoose show];
				[alertOnChoose release];
				self.navigationItem.rightBarButtonItem = nil;
			}
		}
		 
		[tvNote resignFirstResponder];
		self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
	}
}*/

- (BOOL) addNoteRequest: (NSString *) shortnotetxt {
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"addnote"];
	
	// commented added by pradeep on 6 july 2011 for adding NOTE feature
	//NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	// end 6 july 2011
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	//NSString *deviceTocken;
	
	//NSString *usrabout;
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *usrid = [arrayForUserID objectAtIndex:0];
	usrid = [NSString stringWithFormat:@"%@\r\n",usrid];
	
	NSString *contactuserid = @"";
	NSString *notecategory;
	if(comingfrom != 0) // i.e. coming from user profile's option > note
	{
		NSLog(@"camefromwhichoption: %@", camefromwhichoption);	
		contactuserid = [NSString stringWithFormat:@"%@\r\n",userid4displayingnotes];
		notecategory = [NSString stringWithFormat:@"%@\r\n",camefromwhichoption];
	}
	else 
	{
		NSLog(@"camefromwhichoption: %@", camefromwhichoption);		
		camefromwhichoption = @"mynote";
		
		notecategory = [NSString stringWithFormat:@"%@\r\n",camefromwhichoption];
	}

	
		
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"contactpersonid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",contactuserid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// added by pradeep on 6 july 2011 for adding NOTE feature	
	
	// commented n added by pradeep on 9 august 2011 
	//NSString *shortnote = [NSString stringWithFormat:@"%@\r\n",tvNote.text];
	NSString *shortnote = [NSString stringWithFormat:@"%@\r\n",shortnotetxt];
	// end 9 august 2011
	
	//if (tvNote.text == nil) {
		//bookmarkednote = @"";
	//}	
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"notecategory\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",notecategory] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"shortnote\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",shortnote] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	if (camefromwhichoption == @"liveattendeelist")
	{		
		NSString *eventid = [NSString stringWithFormat:@"%@\r\n",[liveNowEventID objectAtIndex:0]];
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",eventid] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	else if (camefromwhichoption == @"attendeelist")
	{		
		NSString *eventid = [NSString stringWithFormat:@"%@\r\n",eventid4attendeelistofnormalevent];
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",eventid] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	else 
	{
		NSString *eventid = [NSString stringWithFormat:@"%@\r\n",@""];
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",eventid] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
	}
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	
	// end 6 july 2011
	
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
	//alreadybookmark = nil;
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Userid"])
		{
			//userid = [dic objectForKey:key];
			
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				
				NSLog(@"\n\n\n\n\n\n#######################-- post for note added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				//messageType = 0;
				break;
			}			
		}
		else if ([key isEqualToString:@"Notsuccess"])
		{
			//userid = [dic objectForKey:key];
			
			if ([[dic objectForKey:key] isEqualToString:@"Note has not added successfully"])
			{
				
				NSLog(@"\n\n\n\n\n\n#######################-- post for note has not added successfully --#######################\n\n\n\n\n\n");
				//messageType = 0;
				//alreadybookmark = @"alreadybookmark";
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

#pragma mark end note feature

// end by pradeep on 13 july 2011 for add (+) btn for adding note feature

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return [stories count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	ShowNote *shownote = [[ShowNote alloc]init];
	shownote.strAssociatedUserID = [[stories objectAtIndex:indexPath.row] objectForKey:@"guid"];
	shownote.strNoteHeader = [[stories objectAtIndex:indexPath.row] objectForKey:@"noteheader"];
	shownote.strAssociatedUserName = [[stories objectAtIndex:indexPath.row] objectForKey:@"associatedusername"];
	shownote.strNoteCreationDate = [[stories objectAtIndex:indexPath.row] objectForKey:@"notecreationdate"];
	shownote.strNoteId = [[stories objectAtIndex:indexPath.row] objectForKey:@"noteid"];
	
	shownote.strIsNoteRead = [[stories objectAtIndex:indexPath.row] objectForKey:@"isnoteread"];
	shownote.strAtEvent = [[stories objectAtIndex:indexPath.row] objectForKey:@"atevent"];
	shownote.strNoteCategory = [[stories objectAtIndex:indexPath.row] objectForKey:@"notecategory"];
	shownote.strShortNote = [[stories objectAtIndex:indexPath.row] objectForKey:@"shortnote"];
	shownote.strSavedAt = [[stories objectAtIndex:indexPath.row] objectForKey:@"savedat"];
	shownote.strPurpose = notepurposeflag;
	shownote.camefromwhichoption = camefromwhichoption;
	shownote.eventid4attendeelistofnormalevent = eventid4attendeelistofnormalevent;
	
	//if (segmentedControl.selectedSegmentIndex==0)
	//	shownote.strPurpose = @"inbox";
	//else shownote.strPurpose = @"sent";
	[self.navigationController pushViewController:shownote animated:YES];
}

/*- (void)btnDelete_Click {
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// Delete the row from the data source
		[self sendReqForDeleteMessage:indexPath.row];
		[stories removeObjectAtIndex:indexPath.row];
		[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		if([stories count] == 0)
		{
			NSString *nomsg = @"";
			if (segmentedControl.selectedSegmentIndex==0)
				nomsg = @"There are no notes to display right now.";
			else nomsg = @"There are no notes to display right now.";
			noMessage = [UnsocialAppDelegate createLabelControl:nomsg frame:CGRectMake(30, 200, 260, 50) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
			noMessage.hidden = NO;
			[self.view addSubview:noMessage];
			// 13 may 2011 by pradeep //[noMessage release];
			self.navigationItem.rightBarButtonItem = nil;
			self.navigationItem.leftBarButtonItem.enabled = YES;
		}
	}
}*/

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
    // Set up the cell...
	
	UIImageView *imgCellBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 0, 320, 56) imageName:@""];
	
	imgCellBack.image = [UIImage imageNamed:@"msgread.png"];
	[cell.contentView addSubview:imgCellBack];
	
	UILabel *lblDate = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"notecreationdate"] frame:CGRectMake(210, 12, 70, 30) txtAlignment:UITextAlignmentRight numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:10 txtcolor:[UIColor  colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] backgroundcolor:[UIColor clearColor]];
	
	[cell.contentView addSubview:lblDate];
	//NSLog(@"Date: %@", lblDate.text);
	
	NSString *shortnote =[[stories objectAtIndex:indexPath.row] objectForKey:@"shortnote"];	
	
	UILabel *fromName; 
	if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"noteheader"] compare:@"Profile Saved"] == NSOrderedSame)
	{
		if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"shortnote"] length] > 25)			
			shortnote = [[shortnote substringWithRange:NSMakeRange(0, 25)] stringByAppendingString:@"..."];
		
		fromName = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"noteheader"] frame:CGRectMake(10, 10, 212, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor  colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] backgroundcolor:[UIColor clearColor]];	
		
		[cell.contentView addSubview:fromName];
		//NSLog(@"Name: %@", fromName.text);
	}
	else 
	{
		if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"shortnote"] length] > 75)
		{
			shortnote = [[shortnote substringWithRange:NSMakeRange(0, 75)] stringByAppendingString:@"..."];
		
		fromName = [UnsocialAppDelegate createLabelControl:shortnote frame:CGRectMake(10, 10, 212, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor  colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] backgroundcolor:[UIColor clearColor]];	
		}
		else 
		{
			if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"shortnote"] length] <= 43)
			{
				fromName = [UnsocialAppDelegate createLabelControl:shortnote frame:CGRectMake(10, 10, 212, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor  colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] backgroundcolor:[UIColor clearColor]];
			}
			else 
			{
				fromName = [UnsocialAppDelegate createLabelControl:shortnote frame:CGRectMake(10, 10, 212, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor  colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] backgroundcolor:[UIColor clearColor]];
			}
		}	
		
		[cell.contentView addSubview:fromName];
		NSLog(@"Name: %@", fromName.text);
	}

	
	//UILabel *msgDescription = [UnsocialAppDelegate createLabelControl:[[stories objectAtIndex:indexPath.row] objectForKey:@"associatedusername"] frame:CGRectMake(10, 28, fromName.frame.size.width, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] backgroundcolor:[UIColor clearColor]];
	 
	if ([[[stories objectAtIndex:indexPath.row] objectForKey:@"noteheader"] compare:@"Profile Saved"] == NSOrderedSame)
	{
		UILabel *msgDescription = [UnsocialAppDelegate createLabelControl:shortnote frame:CGRectMake(10, 28, fromName.frame.size.width, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] backgroundcolor:[UIColor clearColor]];	
		
		[cell.contentView addSubview:msgDescription];
		NSLog(@"Description: %@", msgDescription.text);
	}
	/*else {
		msgDescription = [UnsocialAppDelegate createLabelControl:shortnote frame:CGRectMake(10, 28, fromName.frame.size.width, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] backgroundcolor:[UIColor clearColor]];
	}*/	
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	// for unread notes or unread messages
	/*
	if([[[stories objectAtIndex:indexPath.row] objectForKey:@"isnoteread"] isEqualToString:@"1"]){
		
		// for showing unread notes image or unread messages image
		//imgCellBack.image = [UIImage imageNamed:@"msgunread.png"];
		
		lblDate.textColor = [UIColor whiteColor];
		
		fromName.frame = CGRectMake(fromName.frame.origin.x + 22, fromName.frame.origin.y, fromName.frame.size.width - 22, fromName.frame.size.height);
		fromName.textColor = [UIColor whiteColor];
		[fromName setFont:[UIFont fontWithName:kAppFontName size:13]];
		
		msgDescription.frame = CGRectMake(msgDescription.frame.origin.x + 22, fromName.frame.origin.y + 18, fromName.frame.size.width, fromName.frame.size.height);
	}*/
	
	
	// 13 may 2011 by pradeep //[lblDate release];
	
	// 13 may 2011 by pradeep //[fromName release];
	
	// 13 may 2011 by pradeep //[msgDescription release];

	return cell;
}

// not in use
/*- (void) getSentMsg {
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getsentmessage&datetime=%@&userid=%@", usertime, [arrayForUserID objectAtIndex:0]];
	urlString = [globalUrlString stringByAppendingString:urlString];
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];
}*/

- (void) getNotes {
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);

	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];

	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	NSString *urlString;
	NSLog(@"notepurposeflag: %@", notepurposeflag);
	if(comingfrom != 0) // i.e. coming from user profile's option > note
	//if ([notepurposeflag compare:@"singleuser"] == NSOrderedSame) // if user landed from userprofile > mynote > show note then no need to show btn by which user see the profile of profile saved user 
		//	and there will be an option to add note based on single user
	{
	urlString= [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getnotes&flag2=%@&datetime=%@&userid=%@&userid4displayingnotes=%@", notepurposeflag, usertime, [arrayForUserID objectAtIndex:0], userid4displayingnotes];
	}
	else {
		urlString= [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getnotes&flag2=%@&datetime=%@&userid=%@&userid4displayingnotes=%@", notepurposeflag, usertime, [arrayForUserID objectAtIndex:0], @""];
	}

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
	[self.view addSubview:segmentedControl];
	loading.hidden = activityView.hidden = YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"])
	{
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		strAssociatedUserID = [[NSMutableString alloc] init];
		strNoteHeader = [[NSMutableString alloc] init];
		strAssociatedUserName = [[NSMutableString alloc] init];
		strNoteCreationDate = [[NSMutableString alloc] init];
		strNoteId = [[NSMutableString alloc] init];
		strIsNoteRead = [[NSMutableString alloc] init];
		
		strAtEvent = [[NSMutableString alloc] init];
		strNoteCategory = [[NSMutableString alloc] init];
		strShortNote = [[NSMutableString alloc] init];
		strSavedAt = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		[item setObject:strAssociatedUserID forKey:@"guid"]; 
		[item setObject:strNoteHeader forKey:@"noteheader"]; 		
		[item setObject:strAssociatedUserName forKey:@"associatedusername"];
		[item setObject:strNoteCreationDate forKey:@"notecreationdate"];
		[item setObject:strNoteId forKey:@"noteid"];
		[item setObject:strIsNoteRead forKey:@"isnoteread"];
		
		[item setObject:strAtEvent forKey:@"atevent"]; 		
		[item setObject:strNoteCategory forKey:@"notecategory"];
		[item setObject:strShortNote forKey:@"shortnote"];
		[item setObject:strSavedAt forKey:@"savedat"];
		
		
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"guid"])
	{
		[strAssociatedUserID appendString:string];
	}
	else if ([currentElement isEqualToString:@"noteheader"])
	{
		[strNoteHeader appendString:string];
	}
	else if ([currentElement isEqualToString:@"associatedusername"])
	{
		[strAssociatedUserName appendString:string];
	}
	else if ([currentElement isEqualToString:@"notecreationdate"])
	{
		[strNoteCreationDate appendString:string];
	}
	else if ([currentElement isEqualToString:@"noteid"])
	{
		[strNoteId appendString:string];
	}
	else if ([currentElement isEqualToString:@"isnoteread"])
	{
		[strIsNoteRead appendString:string];
	}
	else if ([currentElement isEqualToString:@"atevent"])
	{
		[strAtEvent appendString:string];
	}
	else if ([currentElement isEqualToString:@"notecategory"])
	{
		[strNoteCategory appendString:string];
	}
	else if ([currentElement isEqualToString:@"shortnote"])
	{
		[strShortNote appendString:string];
	}
	else if ([currentElement isEqualToString:@"savedat"])
	{
		[strSavedAt appendString:string];
	}
}

- (NSInteger) sendReqForDeleteMessage:(NSInteger) storyIndex {
	NSLog(@"Sending....");
	//NSData *imageData1;
	
	
	// setting up the URL to post to
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];	
	NSString *flag = @"";
	if (segmentedControl.selectedSegmentIndex == 0)		
		flag = @"deleteinboxmessage";
	else flag = @"deletesentmessage";
	
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
	
	NSString *varMessageId = [NSString stringWithFormat:@"%@\r\n",[[stories objectAtIndex:storyIndex] objectForKey:@"msgid"]];	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"msgid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varMessageId] dataUsingEncoding:NSUTF8StringEncoding]];
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
		if ([key compare:@"Totunreadmsg"] == NSOrderedSame)			
		{
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				unreadmsg = [[dic objectForKey:key] intValue];				
				successflg=YES;				
				//userid = [dic objectForKey:key];
				
				NSString *strbadgevalue = [NSString stringWithFormat:@"%i", unreadmsg];
				if(unreadmsg != 0)
					inBoxviewcontroller.tabBarItem.badgeValue = strbadgevalue;
				else if (unreadmsg==0)
					inBoxviewcontroller.tabBarItem.badgeValue= nil;
				
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

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	//if([stories count] != 0)
		// commented n added by pradeep on 13 july 2011 for ading + btn on navigation bar in place of delete (thrash) btn
	//if(comingfrom != 0)
	//if ([notepurposeflag compare:@"singleuser"] == NSOrderedSame) // if user landed from userprofile > mynote > show note then no need to show btn by which user see the profile of profile saved user 
		//	and there will be an option to add note based on single user
	{
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddNote_Click)] autorelease];
	}
	//else //	if user come after clicking MY EVENT icon from springboard, no need to add note because we don't know note will be added for whome
	{
		/*if([stories count] != 0)
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(btnDelete_Click)] autorelease];
		else self.navigationItem.rightBarButtonItem = nil; */
	}
	
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
	// added by pradeep on 29 june 2011
	//itemTableView.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
}


@end
