//
//  SelectIndustryPicker.m
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "EventSelectIndustry.h"
#import "EventAdd.h"

@implementation EventSelectIndustry

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	[activityView stopAnimating];
	activityView.hidden = YES;
	loading.hidden = YES;
	[self createControls];
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
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Select Industry" frame:CGRectMake(0, 0, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Retrieving\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {
	[self getIndustryList];
	//Add a Label for the item
	CGRect rect = CGRectMake(0, 60, 100, 100);
	UILabel *label = [[UILabel alloc] initWithFrame:rect];
	label.text = @"";
	label.backgroundColor = [UIColor clearColor];
	[self.view addSubview:label];
	pickerViewArray = [[NSArray alloc]init]; 
	pickerViewArray = eventIndustryNames;
	
	myPickerView = [[UIPickerView alloc] initWithFrame:rect];	
	myPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	myPickerView.delegate = self;
	myPickerView.backgroundColor = [UIColor redColor];
	myPickerView.showsSelectionIndicator = YES;// note this is default to NO
	
	// add this picker to our view controller, initially hidden
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

- (void)leftbtn_OnClick {
	
	[self.navigationController popViewControllerAnimated:YES];	
}

- (void)btnAdd_Click {
	
	arrayAddEvent = [[NSMutableArray alloc]init];
	arrayAddEventID = [[NSMutableArray alloc]init];
	if(!arySelected) {
		
		[arrayAddEvent addObject:[pickerViewArray objectAtIndex:0]];
		[arrayAddEventID addObject:[eventIndustryIDs objectAtIndex:0]];
	}
	else {
		
		[arrayAddEvent addObject:[arySelected objectAtIndex:0]];
		[arrayAddEventID addObject:[arySelectedID objectAtIndex:0]];
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)showPicker:(UIView *)picker
{
	// hide the current picker and show the new one
	if (currentPicker)
	{
		currentPicker.hidden = YES;
	}
	picker.hidden = NO;
	currentPicker = picker;	// remember the current picker so we can remove it later when another one is chosen
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
	selectedComponent = [NSString stringWithFormat:@"%@",[pickerViewArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
	NSLog(@"%@", [NSString stringWithFormat:@"%@",selectedComponent]);
	NSString *selIndstry = [NSString stringWithFormat:@"%@",selectedComponent];
	arySelected = [[NSMutableArray alloc]init];
	arySelectedID = [[NSMutableArray alloc]init];
	
	[arySelected addObject:selIndstry];
	[arySelectedID addObject:[eventIndustryIDs objectAtIndex:[pickerView selectedRowInComponent:0]]];
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view 
{

	/*NSString *returnStr;
	returnStr = [pickerViewArray objectAtIndex:row];
	return returnStr;*/
	
	UILabel *retval = (id)view;
	if (!retval) {
		retval= [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
	}
	retval.text = [pickerViewArray objectAtIndex:row];
	retval.font = [UIFont systemFontOfSize:15];
	return retval;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat componentWidth;
	componentWidth = 200;	// second column is narrower to show numbers
	return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 35;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerViewArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (void) getIndustryList
{
	NSString *urlString;
	eventIndustryNames = [[NSMutableArray alloc] init];
	eventIndustryIDs = [[NSMutableArray alloc] init];
	urlString = [NSString stringWithFormat:[globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx?flag=getindustries"]];
	NSLog(urlString);
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
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"])
	{
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		eventIndustryID = [[NSMutableString alloc] init];
		eventIndustryName = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:eventIndustryID forKey:@"guid"]; 
		[item setObject:eventIndustryName forKey:@"indname"];
		
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
		
		NSLog(@"adding story currentTitle: %@", currentTitle);
		NSLog(@"adding story eventIndustryID: %@", eventIndustryID);
		NSLog(@"adding story eventIndustryName: %@", eventIndustryName);
		[eventIndustryNames addObject:eventIndustryName];
		[eventIndustryIDs addObject:eventIndustryID];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([currentElement isEqualToString:@"title"])
	{
		[currentTitle appendString:string];
	}
	else if ([currentElement isEqualToString:@"indname"])
	{
		[eventIndustryName appendString:string];
	}
	else if ([currentElement isEqualToString:@"guid"])
	{
		[eventIndustryID appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
}

// decide what kind of accesory view (to the far right) we will use
/*- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDetailDisclosureButton;
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
    [super dealloc];
}


@end
