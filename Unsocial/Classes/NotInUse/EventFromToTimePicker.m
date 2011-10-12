//
//  RelationPickerController.m
//  CLINIC App
//
//  Created by santosh khare on 11/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EventFromToTimePicker.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"

@implementation EventFromToTimePicker
@synthesize timeToFrom;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	[activityView stopAnimating];
	activityView.hidden = YES;
	loading.hidden = YES;
	[self createPicker];
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	//add background color
	self.view.backgroundColor = color;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"use_case_311.png"];
	[self.view addSubview:imgBack];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Select Time" frame:CGRectMake(0, 0, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Retrieving\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

-(void)leftbtn_OnClick
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)createPicker
{
	CGRect rect = CGRectMake(0, 60, 100, 100);
	myPickerView = [[UIDatePicker alloc] initWithFrame:rect];
	myPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	myPickerView.datePickerMode = UIDatePickerModeTime;
//	if(timeToFrom == 2)
//		myPickerView.minimumDate = [arrayAddFromTime objectAtIndex:0];
	[myPickerView addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:myPickerView];
	
	UIImageView *blackVertical = [[UIImageView alloc]initWithFrame:CGRectMake(-1, 60, 18, 250)];
	blackVertical.image = [UIImage imageNamed:@"blackVertical.png"];
	[self.view addSubview:blackVertical];
	
	blackVertical = [[UIImageView alloc]initWithFrame:CGRectMake(303, 60, 18, 250)];
	blackVertical.image = [UIImage imageNamed:@"blackVerticalRight.png"];
	[self.view addSubview:blackVertical];
	
	UIButton *btnAdd = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnAdd_Click) frame:CGRectMake(100, 365, 127, 34) imageStateNormal:@"add.png" imageStateHighlighted:@"add2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor blackColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnAdd];
	[btnAdd release];
}

- (void)btnAdd_Click {
	
	if(timeToFrom == 1)
	{
		if([arrayAddFromTime count] == 0)
		{
			arrayAddFromTime = [[NSMutableArray alloc]init];
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			[df setTimeStyle:NSDateFormatterShortStyle];
			NSString *dt = [df stringFromDate:[UnsocialAppDelegate getLocalTime]];
			[arrayAddFromTime addObject:dt];
		}
	}
	else
	{
		if([arrayAddToTime count] == 0)
		{
			arrayAddToTime = [[NSMutableArray alloc]init];
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			[df setTimeStyle:NSDateFormatterShortStyle];
			NSString *dt = [df stringFromDate:[UnsocialAppDelegate getLocalTime]];
			[arrayAddToTime addObject:dt];
		}
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)changeDateInLabel:(id)sender{
	
	//Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setTimeStyle:NSDateFormatterShortStyle];
	dateArray = [[NSMutableArray alloc]init]; // just to check time picked or not
	if(timeToFrom == 1) {
		arrayAddFromTime = [[NSMutableArray alloc]init];
		[arrayAddFromTime addObject:[NSString stringWithFormat:@"%@", [df stringFromDate:myPickerView.date]]];
	}
	else 	{
		arrayAddToTime = [[NSMutableArray alloc]init];
		[arrayAddToTime addObject:[NSString stringWithFormat:@"%@", [df stringFromDate:myPickerView.date]]];
	}
	[df release];
}

- (CGRect)pickerFrameWithSize:(CGSize)size
{
	//CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(0.0, 280.0,size.width,size.height);
	return pickerRect;
}

- (void)showPicker:(UIView *)picker
{
	picker.hidden = NO;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *returnStr;
	returnStr = [pickerViewArray objectAtIndex:row];
	return returnStr;
}

# pragma mark pickerView
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 50.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerViewArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
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
	
	//	[labelSelect release];
}


@end
