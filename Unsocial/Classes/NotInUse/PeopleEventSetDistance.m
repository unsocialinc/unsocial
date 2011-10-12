//
//  PeopleEventSetDistance.m
//  Unsocial
//
//  Created by vaibhavsaran on 27/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PeopleEventSetDistance.h"
#import "UnsocialAppDelegate.h"
#import "Person.h"
#import "GlobalVariables.h"

int intSelectedLevel;

@implementation PeopleEventSetDistance
@synthesize varSetMilesPeoples,  varSetMilesEvents,  peopleOrEvent;;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	activityView.hidden = YES;
	[self createControls];
}

- (void)viewWillAppear:(BOOL)animated {
	
	levelChanged = NO;
	NSLog(@"ShowIndustryDetail view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	//add background color
	self.view.backgroundColor = color;
	
	// Main Back Image
	UIImageView *mainBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 44, 320, 410)];
	mainBackImage.image = [UIImage imageNamed:@"BlankTemplate2.png"];
	[self.view addSubview:mainBackImage];
	
	UIImageView *imgNav = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBarmodel.png"]];
	[self.view addSubview:imgNav];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Set Distance " frame:CGRectMake(0, 43, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	CGRect coachFrame = CGRectMake(5, 5, 36, 28);
	UIButton *backBtn = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(leftbtn_OnClick) frame:coachFrame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:backBtn];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 135, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 260, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)leftbtn_OnClick {
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)createControls {
	
	pickerViewArray = [[NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",nil] retain];
	CGRect rect = CGRectMake(0, 156, 150, 100);
	myPickerView = [[UIPickerView alloc] initWithFrame:rect];
	
	myPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	myPickerView.showsSelectionIndicator = YES;	// note this is default to NO
	
	// this view controller is the data source and delegate
	myPickerView.delegate = self;
	myPickerView.dataSource = self;
	
	BOOL fileFound = [self getDataFromFile];
	if(fileFound)
	{
		if(peopleOrEvent == 1)
			intSelectedLevel = [varSetMilesPeoples integerValue]; 
		else
			intSelectedLevel = [varSetMilesEvents integerValue]; 
		[myPickerView selectRow:intSelectedLevel-1 inComponent:0 animated:YES];
	}	
	// add this picker to our view controller, initially hidden
	[self.view addSubview:myPickerView];
	
	UIImageView *blackVertical = [[UIImageView alloc]initWithFrame:CGRectMake(0, 130, 18, 250)];
	blackVertical.image = [UIImage imageNamed:@"blackVertical.png"];
	[self.view addSubview:blackVertical];
	
	blackVertical = [[UIImageView alloc]initWithFrame:CGRectMake(304, 130, 18, 250)];
	blackVertical.image = [UIImage imageNamed:@"blackVerticalRight.png"];
	[self.view addSubview:blackVertical];
	
	UILabel *lblDistance = [UnsocialAppDelegate createLabelControl:@"Miles" frame:CGRectMake(145, 249, 80, 30) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:@"Arial" fontsize:13 txtcolor:[UIColor colorWithRed:50.00/255.0 green:55.00/255.0 blue:71.00/255.0 alpha:1.0] backgroundcolor:[UIColor clearColor]];
	[lblDistance setFont:[UIFont boldSystemFontOfSize:18]];
	[self.view addSubview:lblDistance];
	
	UIButton *btnSave = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnSave_Click) frame:CGRectMake(95, 393, 127, 34) imageStateNormal:@"save.png" imageStateHighlighted:@"save2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor blackColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSave];
	[btnSave release];
}

- (BOOL) getDataFromFile {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path;
	if(peopleOrEvent == 1)
		path = [documentsDirectory stringByAppendingPathComponent:@"setMilesForPeoples"];
	else
		path = [documentsDirectory stringByAppendingPathComponent:@"setMilesForEvents"];
	
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
		
		NSLog(@"%@", [[tempArray objectAtIndex:0] usersubind]);
		if ( [[[tempArray objectAtIndex:0] usersubind] compare:@""] == NSOrderedSame)
		{
			NSLog(@"subind blank");
		}
		varSetMilesPeoples = [[tempArray objectAtIndex:0] setMilesForPeople];
		varSetMilesEvents = [[tempArray objectAtIndex:0] setMilesForEvents];
		
		[decoder finishDecoding];
		[decoder release];	
		
		if(peopleOrEvent == 1)
		{
			if ( [varSetMilesPeoples compare:@""] == NSOrderedSame || !varSetMilesPeoples) {
				return NO;
			}
			else {
				return YES;
			}		
		}
		else
		{
			if ( [varSetMilesEvents compare:@""] == NSOrderedSame || !varSetMilesEvents) {
				return NO;
			}
			else {
				return YES;
			}		
		}
	}
	else { //just in case the file is not ready yet.
		//username = @"";
		//userlocation = @"";
		//[self CreateFile];
		return NO;
	}
}

- (void) updateDataFileOnSave {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	if(peopleOrEvent == 1)
	{
		if(!levelChanged)
			newPerson.setMilesForPeople = [NSString stringWithFormat:@"%i", intSelectedLevel];
		else
			newPerson.setMilesForPeople = varSetMilesPeoples;
	}
	else
	{
		if(!levelChanged)
			newPerson.setMilesForEvents =  [NSString stringWithFormat:@"%i", intSelectedLevel];
		else
			newPerson.setMilesForEvents = varSetMilesEvents;
	}
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path;
	if(peopleOrEvent == 1)
		path = [documentsDirectory stringByAppendingPathComponent:@"setMilesForPeoples"];
	else
		path = [documentsDirectory stringByAppendingPathComponent:@"setMilesForEvents"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
}

- (void)btnSave_Click {

	[self updateDataFileOnSave];
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


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (pickerView == myPickerView)	// don't show selection for the custom picker
	{
		// report the selection to the UI label
		selectedComponent = [NSString stringWithFormat:@"%@",[pickerViewArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
		NSLog(@"Selected Component- %@", selectedComponent);
		varSetMilesPeoples = [pickerViewArray objectAtIndex:[pickerView selectedRowInComponent:0]];
		varSetMilesEvents = [pickerViewArray objectAtIndex:[pickerView selectedRowInComponent:0]];
		levelChanged = YES;
	}
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [pickerViewArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString *returnStr = @"";
	
	// note: custom picker doesn't care about titles, it uses custom views
	if (pickerView == myPickerView)
	{
		if (component == 0)
		{
			returnStr = [pickerViewArray objectAtIndex:row];
		}
		else
		{
			returnStr = [[NSNumber numberWithInt:row] stringValue];
		}
	}
	
	return returnStr;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat componentWidth;
	componentWidth = 100;	// second column is narrower to show numbers
	return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 30;
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
