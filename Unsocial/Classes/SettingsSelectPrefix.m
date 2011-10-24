//
//  SettingsSelectPrefix.m
//  Unsocial
//
//  Created by vaibhavsaran on 07/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsSelectPrefix.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"

@implementation SettingsSelectPrefix
@synthesize selectedComponent, strPrefix;

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
	
	self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"mainbackground.png"]];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 205 + yAxisForSettingControls, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {
	
	UIImageView *topBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 43)];
	topBg.image = [UIImage imageNamed:@"navbarwithprev.png"];
	[self.view addSubview:topBg];
	
	UIImageView *capBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 480)];
	capBackImage.image = [capturedScreen objectAtIndex:0];
	[self.view addSubview:capBackImage];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
	imgBack.image = [UIImage imageNamed:@"semitransmainback.png"];
	[self.view addSubview:imgBack];
	
	levelChanged = NO;
	CGRect rect = CGRectMake(0, 242, 100, 100);
	pickerViewArray = [[NSArray alloc]init]; 
	pickerViewArray = [[NSArray alloc]initWithObjects:@"Mr", @"Mrs", @"Miss", nil];
	
	myPickerView = [[UIPickerView alloc] initWithFrame:rect];	
	myPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	myPickerView.delegate = self;
	myPickerView.backgroundColor = [UIColor redColor];
	myPickerView.showsSelectionIndicator = YES;// note this is default to NO
	
	// add this picker to our view controller, initially hidden
	[self.view addSubview:myPickerView];
	
	btnSelect = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(saveAndGoback) frame:CGRectMake(128, 320, 64, 50) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSelect];
	
	if([strPrefix compare:nil] != NSOrderedSame) {
		
		if([strPrefix compare:@"Mr"] == NSOrderedSame)
			[myPickerView selectRow:0 inComponent:0 animated:YES];
		else if([strPrefix compare:@"Mrs"] == NSOrderedSame) {
			
			[myPickerView selectRow:1 inComponent:0 animated:YES];
		}
		else if([strPrefix compare:@"Miss"] == NSOrderedSame) {
			
			[myPickerView selectRow:2 inComponent:0 animated:YES];
		}
	}
}

- (void)saveAndGoback {
	
	if(!levelChanged) {
		
		arySelectedPrefix = [[NSMutableArray alloc]init];
		[arySelectedPrefix addObject:[pickerViewArray objectAtIndex:0]];
	}
	
	// commented and added by pradeep on 17 august for fixing crash i.e. 
	/*
	 Changing "Prefix:" on "General Information" page causes application to crash and exit to iPhone dashboard.
	 
	 Steps:
	 
	 Launch "unsocial".
	 Select "Register".
	 Enter in a valid info and select "Save".
	 Select "PROFILE".
	 Select "General Information".
	 Select the "Prefix*:" field.
	 Select "Mrs".
	 Observe application crashes. 
	*/
	/*if (allInfo)
	{		 
		NSLog(@"total items in allInfo array is: %d", [allInfo count]);
	}
	if (allInfoNewUser)
	NSLog(@"total items in allInfoNewUser array is: %d", [allInfoNewUser count]);*/
	
	//if(!allInfoNewUser) 
	if([allInfoNewUser count] == 0)
	// end 17 august 2011
	{
		
		NSMutableArray *tempArray = [[NSMutableArray alloc]init];
		tempArray = allInfo;
		
		NSLog(@"1st Object- %@", [tempArray objectAtIndex:0]);
		NSLog(@"2nd Object- %@", [tempArray objectAtIndex:1]);
		NSLog(@"3rd Object- %@", [tempArray objectAtIndex:2]);
		NSLog(@"4th Object- %@", [tempArray objectAtIndex:3]);
		NSLog(@"5th Object- %@", [tempArray objectAtIndex:4]);
		
		allInfo = [[NSMutableArray alloc]init];
		[allInfo addObjectsFromArray:[NSArray arrayWithObjects:[arySelectedPrefix objectAtIndex:0], [tempArray objectAtIndex:1], [tempArray objectAtIndex:2], [tempArray objectAtIndex:3], [tempArray objectAtIndex:4], nil]];
		[tempArray release];
	}
	else {
		
		NSMutableArray *tempArray = [[NSMutableArray alloc]init];
		tempArray = allInfoNewUser;
		
		allInfoNewUser = [[NSMutableArray alloc]init];
		[allInfoNewUser addObjectsFromArray:[NSArray arrayWithObjects:[tempArray objectAtIndex:0], [tempArray objectAtIndex:1], [tempArray objectAtIndex:2], [arySelectedPrefix objectAtIndex:0], [tempArray objectAtIndex:4], [tempArray objectAtIndex:5], nil]];
		[tempArray release];
	}
	[capturedScreen release];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)showPicker:(UIView *)picker {
	
	// hide the current picker and show the new one
	if (currentPicker)
	{
		currentPicker.hidden = YES;
	}
	picker.hidden = NO;
	currentPicker = picker;	// remember the current picker so we can remove it later when another one is chosen
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	selectedComponent = [NSString stringWithFormat:@"%@",[pickerViewArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
	NSLog(@"%@", [NSString stringWithFormat:@"%@",selectedComponent]);
	NSString *selIndstry = [NSString stringWithFormat:@"%@",selectedComponent];
	arySelectedPrefix = [[NSMutableArray alloc]init];
	[arySelectedPrefix addObject:selIndstry];
	levelChanged = YES;
	[self saveAndGoback];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *returnStr;
	returnStr = [pickerViewArray objectAtIndex:row];
	return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat componentWidth;
	componentWidth = 60;
	return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 30;
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
	// added by pradeep on 29 june 2011
	//myPickerView.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
}


@end
