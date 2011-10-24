//
//  SelectIndustry2Picker.m
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectIndustry2Picker.h"
#import "SelectIndustry3Picker.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"

@implementation SelectIndustry2Picker
//@synthesize idOfSelectedInd;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	loading.hidden = YES;
	activityView.hidden = YES;
	[self createControls];
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"SelectIndustry2Picker view will appear\n");
	
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	//add background color
	self.view.backgroundColor = color;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	UIImageView *imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"BlankTemplate2.png"];
	[self.view addSubview:imgBack];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Select Subcategory" frame:CGRectMake(0, 0, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Retrieving\nplease standby" frame:CGRectMake(25, 125 + yAxisForSettingControls, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];

	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180 + yAxisForSettingControls, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls
{
	[self getSubIndustryList];
	
	if([subIndustryNames count] == 0)
	{
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Sorry, this industry does not contain sub industries." message:@"Press 'Add' button to proceed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
	}
	
	//Add a Label for the item
	CGRect rect = CGRectMake(0, 60 + yAxisForSettingControls, 100, 100);
	//pickerViewArray = [[NSArray arrayWithObjects: @"Sub Category 1",@"Sub Category 2",@"Sub Category 3",@"Sub Category 4",@"Sub Category 5", nil] retain];
	
	pickerViewArray = [[NSArray alloc]init]; // arrayWithObjects:@"Industry 1",	@"Industry 2", @"Industry 3", @"Industry 4", @"Industry 5", nil] retain];
	pickerViewArray = subIndustryNames;
	myPickerView = [[UIPickerView alloc] initWithFrame:rect];	
	myPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	myPickerView.delegate = self;
	myPickerView.backgroundColor = [UIColor redColor];
	myPickerView.showsSelectionIndicator = YES;	// note this is default to NO
	
	// add this picker to our view controller, initially hidden
	[self.view addSubview:myPickerView];
	
	/*UIImageView *blackVertical = [[UIImageView alloc]initWithFrame:CGRectMake(-1, 60, 18, 250)];
	blackVertical.image = [UIImage imageNamed:@"blackVertical.png"];
	[self.view addSubview:blackVertical];
	
	blackVertical = [[UIImageView alloc]initWithFrame:CGRectMake(303, 60, 18, 250)];
	blackVertical.image = [UIImage imageNamed:@"blackVerticalRight.png"];
	[self.view addSubview:blackVertical];*/
	
	UIButton *btnNext = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnNext_Click) frame:CGRectMake(100, 365, 127, 34) imageStateNormal:@"next.png" imageStateHighlighted:@"next2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor blackColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnNext];
	[btnNext release];
	NSLog(@"Selected ID - %@", idOfSelectedInd);
	[self getSubIndustryList];
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
	if (buttonIndex == 0)
	{
		if(!addIndustry)
			industryArray2 = [[NSMutableArray alloc]init];
		else
		{
			if([interestedIndustry1 count] == 0)
			{
			}
			else
			{
				[interestedIndustryIds1 removeLastObject];
				[interestedIndustry1 removeLastObject];
			}
		}
		[self.navigationController popViewControllerAnimated:YES];
	}
	
}

- (void)leftbtn_OnClick {
	
	if(!addIndustry)
		industryArray2 = [[NSMutableArray alloc]init];
	else
	{
		if([interestedIndustry1 count] == 0)
		{
		}
		else
		{
			[interestedIndustryIds1 removeLastObject];
			[interestedIndustry1 removeLastObject];
		}
	}
	[self.navigationController popViewControllerAnimated:YES];	
}

- (void)btnNext_Click {
	
	if(!addIndustry) {
		industryArray2 = [[NSMutableArray alloc]init];
		if([arySelected count] > 0)
		{
			NSString *selectedRow = [arySelected objectAtIndex:0];
			[industryArray2 addObject:selectedRow];
		}
		else
		{
			IdOfSubIndustry4Step1 = [subIndustryIDs objectAtIndex:0];
			[industryArray2 addObject:[pickerViewArray objectAtIndex:0]];
		}
	}
	else
	{
		//if(!interestedIndustry2)
		//	interestedIndustry2 = [[NSMutableArray alloc]init];
		if([arySelected count] > 0)
		{
			NSString *selectedRow = [arySelected objectAtIndex:0];
			[interestedIndustry2 addObject:selectedRow];
			[interestedIndustryIds2 addObject:idOfSelectedSubInd];
		}
		else
		{
			[interestedIndustryIds2 addObject:[subIndustryIDs objectAtIndex:0]];
			[interestedIndustry2 addObject:[pickerViewArray objectAtIndex:0]];
		}
	}
	SelectIndustry3Picker *viewController = [[SelectIndustry3Picker alloc]init];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *retval = (id)view;
	if (!retval) {
		retval= [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
	}
	retval.text = [pickerViewArray objectAtIndex:row];
	retval.font = [UIFont systemFontOfSize:15];
	return retval;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
	selectedComponent = [NSString stringWithFormat:@"%@",[pickerViewArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
	NSLog(@"%@", [NSString stringWithFormat:@"%@",selectedComponent]);
	NSString *selIndstry = [NSString stringWithFormat:@"%@",selectedComponent];
	arySelected = [[NSMutableArray alloc]init];
	[arySelected addObject:selIndstry];
	
	idOfSelectedSubInd = IdOfSubIndustry4Step1 = [subIndustryIDs objectAtIndex:[pickerView selectedRowInComponent:0]];
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
	//if (component == 0)
	//componentWidth = 240.0;	// first column size is wider to hold names
	//else
	componentWidth = 230;
	return componentWidth;
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

- (void) getSubIndustryList
{
	NSString *urlString;
	subIndustryNames = [[NSMutableArray alloc] init];
	subIndustryIDs = [[NSMutableArray alloc] init];
	urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getsubindustries&industryid=%@", idOfSelectedInd];
	urlString = [globalUrlString stringByAppendingString:urlString];
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
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"])
	{
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		subIndustryID = [[NSMutableString alloc] init];
		subIndustryName = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:subIndustryID forKey:@"guid"]; 
		[item setObject:subIndustryName forKey:@"subindname"];
		
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
		
		NSLog(@"adding story currentTitle: %@", currentTitle);
		NSLog(@"adding story subIndustryID: %@", subIndustryID);
		NSLog(@"adding story subIndustryName: %@", subIndustryName);
		[subIndustryNames addObject:subIndustryName];
		[subIndustryIDs addObject:subIndustryID];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([currentElement isEqualToString:@"title"])
	{
		[currentTitle appendString:string];
	}
	else if ([currentElement isEqualToString:@"subindname"])
	{
		[subIndustryName appendString:string];
	}
	else if ([currentElement isEqualToString:@"guid"])
	{
		[subIndustryID appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
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
