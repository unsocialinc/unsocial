//
//  AppNotAvailable.m
//  unsocial
//
//  Created by vaibhavsaran on 07/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppNotAvailable.h"
#import "UnsocialAppDelegate.h"

@implementation AppNotAvailable
@synthesize stronlocation;

 # pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	[activityView stopAnimating];
	activityView.hidden = YES;
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
	[imgHeadview release];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	self.navigationItem.leftBarButtonItem = leftcbtnitme;
	leftbtn.hidden = YES;
		
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"signinback.png"];
	[self.view addSubview:imgBack];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Welcome to unsocial" frame:CGRectMake(15, 120, 290, 30) txtAlignment:UITextAlignmentCenter numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:23 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {
	
	NSString *txtType;
	
	if(!stronlocation)
	{
		txtType = @"";
	}
	else {
		txtType = stronlocation;
	}

	
	/*********************
	if (<#condition#>) { // signing in
		
		txtType = @"Thanks for signing in, ";
	}
	else if (<#condition#>) { // signing up
		
		txtType = @"Thanks for signing up, ";
	}
	else { //already signed in
		txtType = @"";
	}
	*********************/
	NSString *welocmetxt = [NSString stringWithFormat:@"unsocial is currently not available in your area. Please check back periodically. Thank you.", txtType];
	UILabel *lblWelcome = [UnsocialAppDelegate createLabelControl:welocmetxt frame:CGRectMake(15, 0, 290, 400) txtAlignment:UITextAlignmentCenter numberoflines:5 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];		
	[self.view addSubview:lblWelcome];
	// 13 may 2011 by pradeep //[lblWelcome release];
	
	UIButton *btnClose = [UnsocialAppDelegate createButtonControl:@"Close" target:self selector:@selector(btnClose_Onclick) frame:CGRectMake(128, 280, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnClose.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	[self.view addSubview:btnClose];
	[btnClose release];
}

- (void)btnClose_Onclick {
	
	exit(0);
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


- (void)dealloc {
    [super dealloc];
}


@end
