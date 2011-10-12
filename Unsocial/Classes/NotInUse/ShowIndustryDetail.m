//
//  ShowIndustryDetail.m
//  Unsocial
//
//  Created by vaibhavsaran on 16/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShowIndustryDetail.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"


@implementation ShowIndustryDetail
@synthesize industryName, subIndustryName, jobRole;

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"ShowIndustryDetail view will appear");
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

	UIImageView *imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"BlankTemplate2.png"];
	[self.view addSubview:imgBack];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Industry Details" frame:CGRectMake(0, 0, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 125 + yAxisForSettingControls, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180 + yAxisForSettingControls, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls
{
	UILabel *whiteLine, *describeLevelsLabel;
	UITextView *describeLevelsTextView;
	NSString *labelTitle, *levelDecsription;
	int yForHeading = 68;
	int yForDescription = 90;
	int yForLine = 130;
	for(int i = 0; i < 2; i++)
	{
		whiteLine = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(25, yForLine, 270, 2) txtAlignment:UITextAlignmentCenter numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:1 txtcolor:[UIColor clearColor] backgroundcolor:[UIColor blackColor]];
		[self.view addSubview:whiteLine];
		yForLine = yForLine + 72;		
	}
	
	for(int j = 0; j < 3; j++)
	{
		if(j ==0)
		{
			labelTitle = @"Industry:";
			levelDecsription = industryName;
		}
		else if(j == 1)
		{
			labelTitle = @"Subcategory";	
			levelDecsription = subIndustryName;
		}
		else if(j == 2)
		{
			labelTitle = @"Job Title:";
			levelDecsription = jobRole;
		}
		describeLevelsLabel = [UnsocialAppDelegate createLabelControl:labelTitle frame:CGRectMake(24, yForHeading, 276, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:describeLevelsLabel];
		yForHeading = yForHeading + 73;
		
		describeLevelsTextView = [UnsocialAppDelegate createTextViewControl:levelDecsription frame:CGRectMake(17, yForDescription, 276, 60) txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor] fontwithname:@"ArialRoundedMTBold-Italic" fontsize:14 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:NO editable:NO];
		[self.view addSubview:describeLevelsTextView];
		yForDescription = yForDescription + 73;
	}	
/*
	UILabel *lblIndustry = [UnsocialAppDelegate createLabelControl:@"Industry:" frame:CGRectMake(20, 45, 280, 25) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor blackColor] backgroundcolor:[UIColor darkGrayColor]];
	[self.view addSubview:lblIndustry];
	[lblIndustry release];
	
	UILabel *lblIndustryName = [UnsocialAppDelegate createLabelControl:industryName frame:CGRectMake(20, 70, 280, 25) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor blackColor] backgroundcolor:[UIColor lightGrayColor]];
	[self.view addSubview:lblIndustryName];
	[lblIndustryName release];

	UILabel *lblSubIndustry = [UnsocialAppDelegate createLabelControl:@"Subcategory:" frame:CGRectMake(20, 100, 280, 25) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor blackColor] backgroundcolor:[UIColor darkGrayColor]];
	[self.view addSubview:lblSubIndustry];
	[lblSubIndustry release];
	
	UILabel *lblSubIndustryName = [UnsocialAppDelegate createLabelControl:subIndustryName frame:CGRectMake(20, 130, 280, 20) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor lightGrayColor]];
	[self.view addSubview:lblSubIndustryName];
	[lblSubIndustryName release];
	
	UILabel *lbljobRole = [UnsocialAppDelegate createLabelControl:@"Job Title:" frame:CGRectMake(20, 200, 280, 25) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor blackColor] backgroundcolor:[UIColor darkGrayColor]];
	[self.view addSubview:lbljobRole];
	[lbljobRole release];
	
	UILabel *lbljobRoleName = [UnsocialAppDelegate createLabelControl:jobRole frame:CGRectMake(20, 240, 280, 25) txtAlignment:UITextAlignmentLeft numberoflines:10 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor lightGrayColor]];
	[self.view addSubview:lbljobRoleName];
	[lbljobRoleName release];*/
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
