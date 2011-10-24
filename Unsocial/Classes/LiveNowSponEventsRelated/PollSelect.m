//
//  SignIn.m
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "PollSelect.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "Person.h"

#define klabelFontSize  13
UILabel *lblOp1, *lblOp2, *lblOp3, *lblOp4, *lblTip;
UIButton *btn1, *btn2, *btn3, *btn4;
@implementation PollSelect
@synthesize userid, pollquestionid, sponfeatid, sponeventid, questions, noofoptions;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self createControls];
	// for disappearing activityvew at the header
	[activityView stopAnimating];
	activityView.hidden = loading.hidden = YES;
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
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	// added by pradeep on 1 june 2011 for returning to dashboard requirement
	
	UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(285.0, 0.0, 33, 30)];
	[rightbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[rightbtn addTarget:self action:@selector(rightbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
	itemNV.rightBarButtonItem = rightbtnitme;
	//rightbtn.hidden = YES;
	
	// end 1 june 2011
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"signupback.png"];
	[self.view addSubview:imgBack];
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 42, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue

	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Poll" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	loading.hidden = NO;
	[self.view addSubview:loading];
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
- (void)rightbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"poll"];
	[self dismissModalViewControllerAnimated:YES];
}
// end 1 june 2011

- (void)createControls {
	
	if(!stories)
		[self getpollquestionoptions];
	//if([stories count] > 0)
	//{
	
	UITextView *tvQuestion = [UnsocialAppDelegate createTextViewControl:questions frame:CGRectMake(15, 50, 290, 45) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:15 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:NO editable:NO];
	tvQuestion.contentInset = UIEdgeInsetsMake(-4.00, -8.00, 0.00, 0.00);
	[self.view addSubview:tvQuestion];
	[tvQuestion release];
	
	NSString *option1, *option3, *option4; //= [[stories objectAtIndex: 0] objectForKey: @"option"];
	NSString *option2; //= [[stories objectAtIndex: 1] objectForKey: @"option"];
	
	//********** added by pradeep on 4 jan 2011 
	
	//if ([stories4result count] > 0)
	//{
	NSString *isalreadyvoted = [[stories4result objectAtIndex: 0] objectForKey: @"alreadyvoted"];
	NSString *rslt = [[stories4result objectAtIndex: 0] objectForKey: @"result"];
	NSLog(@"result: %@", rslt);
	if ([[NSString stringWithFormat:isalreadyvoted] compare:@"yes"]==NSOrderedSame)
	{
		UIAlertView * alreadyvotedAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have already voted. Current results are displayed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alreadyvotedAlert show];
		
		NSArray *split = [rslt componentsSeparatedByString:@"#"];
		/*
		 NSString *option1 = [split objectAtIndex:0];
		 NSLog(@"%@", option1);
		 NSString *option2 = [split objectAtIndex:1];
		 NSLog(@"%@", option2);
		 
		 lblOp1.text = [@"A) " stringByAppendingString:option1];
		 lblOp2.text = [@"B) " stringByAppendingString:option2];;
		 lblTip.hidden = btn1.hidden = btn2.hidden = YES;*/
		
		//NSString *option1 = @"";
		//NSString *option2 = @"";
		//NSString *option3 = @"";
		//NSString *option4 = @"";
		//[split objectAtIndex:0];
		//NSLog(@"%@", option1);
		//NSString *option2 = [split objectAtIndex:1];
		//NSLog(@"%@", option2);
		
		if ([split count] == 2)
		{
			option1 = [split objectAtIndex:0];
			option2 = [split objectAtIndex:1];
			lblOp1 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 100, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
			[self.view addSubview:lblOp1];
			// 13 may 2011 by pradeep //[lblOp1 release];
			
			lblOp2 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 150, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
			[self.view addSubview:lblOp2];
			// 13 may 2011 by pradeep //[lblOp2 release];
			
			lblOp1.text = [@"A) " stringByAppendingString:option1];
			lblOp2.text = [@"B) " stringByAppendingString:option2];
			lblTip.hidden = btn1.hidden = btn2.hidden = YES;
		}
		else if ([split count] == 3)
		{
			option1 = [split objectAtIndex:0];
			option2 = [split objectAtIndex:1];
			option3 = [split objectAtIndex:2];
			
			lblOp1 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 100, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
			[self.view addSubview:lblOp1];
			// 13 may 2011 by pradeep //[lblOp1 release];
			
			lblOp2 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 150, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
			[self.view addSubview:lblOp2];
			// 13 may 2011 by pradeep //[lblOp2 release];
			
			lblOp3 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 200, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
			[self.view addSubview:lblOp3];
			// 13 may 2011 by pradeep //[lblOp3 release];
			
			lblOp1.text = [@"A) " stringByAppendingString:option1];
			lblOp2.text = [@"B) " stringByAppendingString:option2];
			lblOp3.text = [@"C) " stringByAppendingString:option3];
			lblTip.hidden = btn1.hidden = btn2.hidden = btn3.hidden = YES;
		}
		else if ([split count] == 4)
		{
			option1 = [split objectAtIndex:0];
			option2 = [split objectAtIndex:1];
			option3 = [split objectAtIndex:2];
			option4 = [split objectAtIndex:3];
			
			lblOp1 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 100, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
			[self.view addSubview:lblOp1];
			// 13 may 2011 by pradeep //[lblOp1 release];
			
			lblOp2 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 150, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
			[self.view addSubview:lblOp2];
			// 13 may 2011 by pradeep //[lblOp2 release];
			
			lblOp3 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 200, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
			[self.view addSubview:lblOp3];
			// 13 may 2011 by pradeep //[lblOp3 release];
			
			lblOp4 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 250, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
			[self.view addSubview:lblOp4];
			// 13 may 2011 by pradeep //[lblOp4 release];
			
			lblOp1.text = [@"A) " stringByAppendingString:option1];
			lblOp2.text = [@"B) " stringByAppendingString:option2];
			lblOp3.text = [@"C) " stringByAppendingString:option3];
			lblOp4.text = [@"D) " stringByAppendingString:option4];
			lblTip.hidden = btn1.hidden = btn2.hidden = btn3.hidden = btn4.hidden = YES;
		}
	}
	else 
	{
	//********************
	// end 4 jan 2011
		for (int i=0; i < [stories count]; i++)
		{
			if(i==0)
			{
				option1 = [[stories objectAtIndex: i] objectForKey: @"option"];
				lblOp1 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 100, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
				[self.view addSubview:lblOp1];
				// 13 may 2011 by pradeep //[lblOp1 release];
				
				btn1 = [UnsocialAppDelegate createButtonControl:[NSString stringWithFormat:@"A) %@", option1] target:self selector:@selector(btn1_click) frame:CGRectMake(15, 100, 290, 45) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
				btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
				btn1.titleLabel.font = [UIFont fontWithName:kAppFontName size:15];
				[self.view  addSubview:btn1];
				[btn1 release];
			}
			
			else if(i==1)
			{
				option2 = [[stories objectAtIndex: i] objectForKey: @"option"];
				lblOp2 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 150, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
				[self.view addSubview:lblOp2];
				// 13 may 2011 by pradeep //[lblOp2 release];
				
				btn2 = [UnsocialAppDelegate createButtonControl:[NSString stringWithFormat:@"B) %@", option2] target:self selector:@selector(btn2_click) frame:CGRectMake(15, 150, 290, 45) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
				btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
				btn2.titleLabel.font = [UIFont fontWithName:kAppFontName size:15];
				[self.view  addSubview:btn2];
				[btn2 release];
			}
			else if(i==2)
			{
				option3 = [[stories objectAtIndex: i] objectForKey: @"option"];
				lblOp3 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 200, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
				[self.view addSubview:lblOp3];
				// 13 may 2011 by pradeep //[lblOp3 release];
				
				btn3 = [UnsocialAppDelegate createButtonControl:[NSString stringWithFormat:@"C) %@", option3] target:self selector:@selector(btn3_click) frame:CGRectMake(15, 200, 290, 45) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
				btn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
				btn3.titleLabel.font = [UIFont fontWithName:kAppFontName size:15];
				[self.view  addSubview:btn3];
				[btn3 release];
			}
			
			else if(i==3)
			{
				option4 = [[stories objectAtIndex: i] objectForKey: @"option"];
				lblOp4 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 250, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
				[self.view addSubview:lblOp4];
				// 13 may 2011 by pradeep //[lblOp4 release];
				
				btn4 = [UnsocialAppDelegate createButtonControl:[NSString stringWithFormat:@"D) %@", option4] target:self selector:@selector(btn4_click) frame:CGRectMake(15, 250, 290, 45) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
				btn4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
				btn4.titleLabel.font = [UIFont fontWithName:kAppFontName size:15];
				[self.view  addSubview:btn4];
				[btn4 release];
			}
		}
		
		lblTip = [UnsocialAppDelegate createLabelControl:@"Please touch an option to vote!" frame:CGRectMake(15, 350, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:lblTip];
		// 13 may 2011 by pradeep //[lblTip release];
	
	} // added by pradeep on 4 jan 2011
	
	/*lblOp1 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 100, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblOp1];
	[lblOp1 release];
	
	btn1 = [UnsocialAppDelegate createButtonControl:[NSString stringWithFormat:@"A) %@", option1] target:self selector:@selector(btn1_click) frame:CGRectMake(15, 100, 290, 45) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	btn1.titleLabel.font = [UIFont fontWithName:kAppFontName size:15];
	[self.view  addSubview:btn1];
	[btn1 release];
	
	lblOp2 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(15, 140, 290, 45) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblOp2];
	[lblOp2 release];
	
	btn2 = [UnsocialAppDelegate createButtonControl:[NSString stringWithFormat:@"B) %@", option2] target:self selector:@selector(btn2_click) frame:CGRectMake(15, 140, 290, 45) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	btn2.titleLabel.font = [UIFont fontWithName:kAppFontName size:15];
	[self.view  addSubview:btn2];
	[btn2 release];*/

	
}

- (void) btn1_click {
	
	NSString *optionid = [[stories objectAtIndex: 0] objectForKey: @"guid"]; // for getting option id
	NSLog(@"%@", optionid);
	BOOL isvoteadd = [self sendRequest4VoteNGetResult:@"addvote" :optionid];
	if (isvoteadd)
	{
		if ([pollresult count] > 0)
		{
			NSArray *split = [[pollresult objectAtIndex:0] componentsSeparatedByString:@"#"];
			/*
			NSString *option1 = [split objectAtIndex:0];
			NSLog(@"%@", option1);
			NSString *option2 = [split objectAtIndex:1];
			NSLog(@"%@", option2);
			
			lblOp1.text = [@"A) " stringByAppendingString:option1];
			lblOp2.text = [@"B) " stringByAppendingString:option2];;
			lblTip.hidden = btn1.hidden = btn2.hidden = YES;*/
			
			NSString *option1 = @"";
			NSString *option2 = @"";
			NSString *option3 = @"";
			NSString *option4 = @"";
			//[split objectAtIndex:0];
			//NSLog(@"%@", option1);
			//NSString *option2 = [split objectAtIndex:1];
			//NSLog(@"%@", option2);
			
			if ([split count] == 2)
			{
				option1 = [split objectAtIndex:0];
				option2 = [split objectAtIndex:1];
				lblOp1.text = [@"A) " stringByAppendingString:option1];
				lblOp2.text = [@"B) " stringByAppendingString:option2];
				lblTip.hidden = btn1.hidden = btn2.hidden = YES;
			}
			else if ([split count] == 3)
			{
				option1 = [split objectAtIndex:0];
				option2 = [split objectAtIndex:1];
				option3 = [split objectAtIndex:2];
				lblOp1.text = [@"A) " stringByAppendingString:option1];
				lblOp2.text = [@"B) " stringByAppendingString:option2];
				lblOp3.text = [@"C) " stringByAppendingString:option3];
				lblTip.hidden = btn1.hidden = btn2.hidden = btn3.hidden = YES;
			}
			else if ([split count] == 4)
			{
				option1 = [split objectAtIndex:0];
				option2 = [split objectAtIndex:1];
				option3 = [split objectAtIndex:2];
				option4 = [split objectAtIndex:3];
				lblOp1.text = [@"A) " stringByAppendingString:option1];
				lblOp2.text = [@"B) " stringByAppendingString:option2];
				lblOp3.text = [@"C) " stringByAppendingString:option3];
				lblOp4.text = [@"D) " stringByAppendingString:option4];
				lblTip.hidden = btn1.hidden = btn2.hidden = btn3.hidden = btn4.hidden = YES;
			}
		}
	}
}

- (void) btn2_click {
	
	NSString *optionid = [[stories objectAtIndex: 1] objectForKey: @"guid"]; // for getting option id
	NSLog(@"%@", optionid);
	BOOL isvoteadd = [self sendRequest4VoteNGetResult:@"addvote" :optionid];
	if (isvoteadd)
	{
		if ([pollresult count] > 0)
		{
			NSArray *split = [[pollresult objectAtIndex:0] componentsSeparatedByString:@"#"];
			NSString *option1 = @"", *option2 = @"", *option3 = @"", *option4 = @"";
			//[split objectAtIndex:0];
			//NSLog(@"%@", option1);
			//NSString *option2 = [split objectAtIndex:1];
			//NSLog(@"%@", option2);

			if ([split count] == 2)
			{
				option1 = [split objectAtIndex:0];
				option2 = [split objectAtIndex:1];
				lblOp1.text = [@"A) " stringByAppendingString:option1];
				lblOp2.text = [@"B) " stringByAppendingString:option2];
				lblTip.hidden = btn1.hidden = btn2.hidden = YES;
			}
			else if ([split count] == 3)
			{
				option1 = [split objectAtIndex:0];
				option2 = [split objectAtIndex:1];
				option3 = [split objectAtIndex:2];
				lblOp1.text = [@"A) " stringByAppendingString:option1];
				lblOp2.text = [@"B) " stringByAppendingString:option2];
				lblOp3.text = [@"C) " stringByAppendingString:option3];
				lblTip.hidden = btn1.hidden = btn2.hidden = btn3.hidden = YES;
			}
			else if ([split count] == 4)
			{
				option1 = [split objectAtIndex:0];
				option2 = [split objectAtIndex:1];
				option3 = [split objectAtIndex:2];
				option4 = [split objectAtIndex:3];
				lblOp1.text = [@"A) " stringByAppendingString:option1];
				lblOp2.text = [@"B) " stringByAppendingString:option2];
				lblOp3.text = [@"C) " stringByAppendingString:option3];
				lblOp4.text = [@"D) " stringByAppendingString:option4];
				lblTip.hidden = btn1.hidden = btn2.hidden = btn3.hidden = btn4.hidden = YES;
			}
		}
	}
}

- (void) btn3_click {
	
	NSString *optionid = [[stories objectAtIndex: 2] objectForKey: @"guid"]; // for getting option id
	NSLog(@"%@", optionid);
	BOOL isvoteadd = [self sendRequest4VoteNGetResult:@"addvote" :optionid];
	if (isvoteadd)
	{
		if ([pollresult count] > 0)
		{
			NSArray *split = [[pollresult objectAtIndex:0] componentsSeparatedByString:@"#"];
			/*NSString *option1 = [split objectAtIndex:0];
			NSLog(@"%@", option1);
			NSString *option2 = [split objectAtIndex:1];
			NSLog(@"%@", option2);
			
			lblOp1.text = [@"A) " stringByAppendingString:option1];
			lblOp2.text = [@"B) " stringByAppendingString:option2];;
			lblTip.hidden = btn1.hidden = btn2.hidden = YES;*/
			
			NSString *option1 = @"", *option2 = @"", *option3 = @"", *option4 = @"";
			//[split objectAtIndex:0];
			//NSLog(@"%@", option1);
			//NSString *option2 = [split objectAtIndex:1];
			//NSLog(@"%@", option2);
			
			if ([split count] == 2)
			{
				option1 = [split objectAtIndex:0];
				option2 = [split objectAtIndex:1];
				lblOp1.text = [@"A) " stringByAppendingString:option1];
				lblOp2.text = [@"B) " stringByAppendingString:option2];
				lblTip.hidden = btn1.hidden = btn2.hidden = YES;
			}
			else if ([split count] == 3)
			{
				option1 = [split objectAtIndex:0];
				option2 = [split objectAtIndex:1];
				option3 = [split objectAtIndex:2];
				lblOp1.text = [@"A) " stringByAppendingString:option1];
				lblOp2.text = [@"B) " stringByAppendingString:option2];
				lblOp3.text = [@"C) " stringByAppendingString:option3];
				lblTip.hidden = btn1.hidden = btn2.hidden = btn3.hidden = YES;
			}
			else if ([split count] == 4)
			{
				option1 = [split objectAtIndex:0];
				option2 = [split objectAtIndex:1];
				option3 = [split objectAtIndex:2];
				option4 = [split objectAtIndex:3];
				lblOp1.text = [@"A) " stringByAppendingString:option1];
				lblOp2.text = [@"B) " stringByAppendingString:option2];
				lblOp3.text = [@"C) " stringByAppendingString:option3];
				lblOp4.text = [@"D) " stringByAppendingString:option4];
				lblTip.hidden = btn1.hidden = btn2.hidden = btn3.hidden = btn4.hidden = YES;
			}
		}
	}
}

- (void) btn4_click {
	
	NSString *optionid = [[stories objectAtIndex: 3] objectForKey: @"guid"]; // for getting option id
	NSLog(@"%@", optionid);
	BOOL isvoteadd = [self sendRequest4VoteNGetResult:@"addvote" :optionid];
	if (isvoteadd)
	{
		if ([pollresult count] > 0)
		{
			NSArray *split = [[pollresult objectAtIndex:0] componentsSeparatedByString:@"#"];
			/*NSString *option1 = [split objectAtIndex:0];
			NSLog(@"%@", option1);
			NSString *option2 = [split objectAtIndex:1];
			NSLog(@"%@", option2);
			
			lblOp1.text = [@"A) " stringByAppendingString:option1];
			lblOp2.text = [@"B) " stringByAppendingString:option2];;
			lblTip.hidden = btn1.hidden = btn2.hidden = YES;*/
			
			NSString *option1 = @"", *option2 = @"", *option3 = @"", *option4 = @"";
			//[split objectAtIndex:0];
			//NSLog(@"%@", option1);
			//NSString *option2 = [split objectAtIndex:1];
			//NSLog(@"%@", option2);
			
			if ([split count] == 2)
			{
				option1 = [split objectAtIndex:0];
				option2 = [split objectAtIndex:1];
				lblOp1.text = [@"A) " stringByAppendingString:option1];
				lblOp2.text = [@"B) " stringByAppendingString:option2];
				lblTip.hidden = btn1.hidden = btn2.hidden = YES;
			}
			else if ([split count] == 3)
			{
				option1 = [split objectAtIndex:0];
				option2 = [split objectAtIndex:1];
				option3 = [split objectAtIndex:2];
				lblOp1.text = [@"A) " stringByAppendingString:option1];
				lblOp2.text = [@"B) " stringByAppendingString:option2];
				lblOp3.text = [@"C) " stringByAppendingString:option3];
				lblTip.hidden = btn1.hidden = btn2.hidden = btn3.hidden = YES;
			}
			else if ([split count] == 4)
			{
				option1 = [split objectAtIndex:0];
				option2 = [split objectAtIndex:1];
				option3 = [split objectAtIndex:2];
				option4 = [split objectAtIndex:3];
				lblOp1.text = [@"A) " stringByAppendingString:option1];
				lblOp2.text = [@"B) " stringByAppendingString:option2];
				lblOp3.text = [@"C) " stringByAppendingString:option3];
				lblOp4.text = [@"D) " stringByAppendingString:option4];
				lblTip.hidden = btn1.hidden = btn2.hidden = btn3.hidden = btn4.hidden = YES;
			}
		}
	}
}

- (void) getpollquestionoptions {
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	NSString *urlString;
	NSLog(@"%@", [NSString stringWithFormat:@"question id: %@", pollquestionid]);
	urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getpollquestionoptions&datetime=%@&userid=%@&flag2=%@&featuretype=%@", usertime, [arrayForUserID objectAtIndex:0], pollquestionid, @""];
 	urlString = [globalUrlString stringByAppendingString:urlString];
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];
}

- (void)parseXMLFileAtURL:(NSString *)URL {
	stories = [[NSMutableArray alloc] init];
	stories4result = [[NSMutableArray alloc] init];
	
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
	//imageURLs4Lazy = [[NSMutableArray alloc]init];
	
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
		pollquestionoptionid = [[NSMutableString alloc] init];
		pollquestionsid = [[NSMutableString alloc] init];
		currentquestionsoption = [[NSMutableString alloc] init];		
	}
	if ([elementName isEqualToString:@"item2"])
	{
		item4result = [[NSMutableDictionary alloc] init];
		alreadyvoted = [[NSMutableString alloc] init];
		result = [[NSMutableString alloc] init];
	}
	/*if ([elementName isEqualToString:@"enclosure"]) {
	 currentImageURL = [attributeDict valueForKey:@"url"];
	 }*/
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if ([elementName isEqualToString:@"item"])
	{		
		[item setObject:pollquestionoptionid forKey:@"guid"]; // option id
		[item setObject:pollquestionsid forKey:@"questionid"]; 	
		[item setObject:currentquestionsoption forKey:@"option"]; 		
				
		NSLog(@"%@", [NSString stringWithFormat:@"option ID:*** %@", pollquestionid]);
		
		//[imageURLs4Lazy addObject:currentImageURL];
		
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
	}
	
	// DDED BY PRADEEP ON 4 JAN 2011
	if ([elementName isEqualToString:@"item2"])
	{
		[item4result setObject:alreadyvoted forKey:@"alreadyvoted"]; // option id
		[item4result setObject:result forKey:@"result"]; 	
				
		NSLog(@"%@", [NSString stringWithFormat:@"RESULT:*** %@", result]);
		
		//[imageURLs4Lazy addObject:currentImageURL];
		
		[stories4result addObject:[item4result copy]];
		NSLog(@"%d ^^", [stories4result count]);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"guid"])
	{
		[pollquestionoptionid appendString:string];
	}
	else if ([currentElement isEqualToString:@"questionid"])
	{
		NSLog(@"question id---   %@", string);
		[pollquestionsid appendString:string];
	}
	else if ([currentElement isEqualToString:@"option"])
	{
		NSLog(@"option---   %@", string);
		[currentquestionsoption appendString:string];
	}	
	else if ([currentElement isEqualToString:@"alreadyvoted"])
	{
		NSLog(@"alreadyvoted---   %@", string);
		[alreadyvoted appendString:string];
	}
	else if ([currentElement isEqualToString:@"result"])
	{
		NSLog(@"result---   %@", string);
		[result appendString:string];
	}
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
}

- (BOOL) sendRequest4VoteNGetResult: (NSString *) flag: (NSString *) quesoptionid{
	
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	NSLog(@"Sending.... 4 result");
	
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
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",quesoptionid];
	NSString *quesid = [NSString stringWithFormat:@"%@\r\n",pollquestionid];
	NSString *usrid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	//NSString *username = [NSString stringWithFormat:@"%@\r\n",txtUsername.text];
		
	//DEFAULT TERMS/////////////////////////////////////
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	//NSString *allownotification = [NSString stringWithFormat:@"%@\r\n",@"0"];
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"devicetocken\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",deviceTocken] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	//DEFAULT TERMS/////////////////////////////////////
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"questionid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",quesid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
	//DEFAULT TERMS/////////////////////////////////////
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	/*[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"isallownotification\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",allownotification] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];*/
	//DEFAULT TERMS/////////////////////////////////////
	
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
	pollresult = [[NSMutableArray alloc] init];
		
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Resmsg"])
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				//[self updateDataFileOnSave:[dic objectForKey:key]];
				printf("\n\n\n\n\n\n#######################-- Polling successfully and get result --#######################\n\n\n\n\n\n");
				[pollresult addObject:[dic objectForKey:key]]; 
				
				
				successflg=YES;
				//UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"your credentials have been sent to you by email" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				//[showAlert show];
				//[showAlert release];
				break;
			}
		}
		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[pool release];
	return successflg;
}


- (void)leftbtn_OnClick {
	
	[self.navigationController popViewControllerAnimated:YES];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	printf("Did begin editing\n");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	printf("Did end editing\n");
}

- (void)dealloc {
    [super dealloc];
}


@end
