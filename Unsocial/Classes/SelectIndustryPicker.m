//
//  SelectIndustryPicker.m
//  unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectIndustryPicker.h"
#import "SelectIndustry3Picker.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"

@implementation SelectIndustryPicker
@synthesize strcompany, strwebsite, strindustry, strfunction, strroleid, strindid;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	[activityView stopAnimating];
	activityView.hidden = YES;
	loading.hidden = YES;
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
	
	// Main Back Image
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	UIImageView *navBarForModelView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navbarwithprev.png"]];
	[self.view addSubview:navBarForModelView];
	
	UIButton *leftbtn = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(leftbtn_OnClick) frame:CGRectMake(0, 0, 40, 40) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:leftbtn];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Retrieving Industry list\nplease standby" frame:CGRectMake(25, 200, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 255, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {
	
	[self getIndustryList];
	UIImageView *capBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 480)];
	capBackImage.image = [capturedScreen objectAtIndex:0];
	[self.view addSubview:capBackImage];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
	imgBack.image = [UIImage imageNamed:@"semitransmainback.png"];
	[self.view addSubview:imgBack];
	
	UIImageView *topBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 43)];
	topBg.image = [UIImage imageNamed:@"navbarwithprev.png"];
	[self.view addSubview:topBg];
	
	CGRect rect = CGRectMake(0, 200, 100, 100);
	pickerViewArray = [[NSArray alloc]init]; 
	pickerViewArray = industryNames;
	
	myPickerView = [[UIPickerView alloc] initWithFrame:rect];	
	myPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	myPickerView.delegate = self;
	myPickerView.backgroundColor = [UIColor redColor];
	myPickerView.showsSelectionIndicator = YES;// note this is default to NO
	
	// add this picker to our view controller, initially hidden
	[self.view addSubview:myPickerView];
	
	UIButton *btnAdd = [UnsocialAppDelegate createButtonControl:@"Add" target:self selector:@selector(btnAdd_Click) frame:CGRectMake(128, 420, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnAdd];
	[btnAdd release];
}	

- (void)leftbtn_OnClick {
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)btnAdd_Click {
	
	industryArray1 = [[NSMutableArray alloc]init];
	if([arySelected count] > 0)
	{
		[industryArray1 addObject:[arySelected objectAtIndex:0]];
	}
	else
	{
		idOfSelectedInd = [industryIDs objectAtIndex:0];
		[industryArray1 addObject:[pickerViewArray objectAtIndex:0]];			
	}
	
	NSMutableArray *tempArray = [[NSMutableArray alloc]init];
	tempArray = aryCompanyInfo;
	
	aryCompanyInfo = [[NSMutableArray alloc]init];
	[aryCompanyInfo addObjectsFromArray:[NSArray arrayWithObjects:[tempArray objectAtIndex:0], [tempArray objectAtIndex:1], [industryArray1 objectAtIndex:0], [tempArray objectAtIndex:3], idOfSelectedInd, [tempArray objectAtIndex:5],[tempArray objectAtIndex:6],[tempArray objectAtIndex:7], nil]];
	
	NSLog(@"Industry - %@, Industry ID- %@", [industryArray1 objectAtIndex:0], idOfSelectedInd);
	[self dismissModalViewControllerAnimated:YES];
	[tempArray release];
	[capturedScreen release];
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
	arySelected = [[NSMutableArray alloc]init];
	[arySelected addObject:selIndstry];
	
	idOfSelectedInd = [industryIDs objectAtIndex:[pickerView selectedRowInComponent:0]];
	
	NSLog(@"Selected ID - %@", idOfSelectedInd);
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
	componentWidth = 250;
	return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 30;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [pickerViewArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
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

- (void) getIndustryList {
	NSString *urlString;
	industryNames = [[NSMutableArray alloc] init];
	industryIDs = [[NSMutableArray alloc] init];
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
	NSString * errorString = [NSString stringWithFormat:@"Error retrieving Industry list. Your internet connection may be down."];
	NSLog(@"error parsing XML: %@", errorString);	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDic {
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"])
	{
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		industryID = [[NSMutableString alloc] init];
		industryName = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:industryID forKey:@"guid"]; 
		[item setObject:industryName forKey:@"indname"];
		
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
		
		NSLog(@"adding story currentTitle: %@", currentTitle);
		NSLog(@"adding story industryID: %@", industryID);
		NSLog(@"adding story industryName: %@", industryName);
		[industryNames addObject:industryName];
		[industryIDs addObject:industryID];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"title"])
	{
		[currentTitle appendString:string];
	}
	else if ([currentElement isEqualToString:@"indname"])
	{
		[industryName appendString:string];
	}
	else if ([currentElement isEqualToString:@"guid"])
	{
		[industryID appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
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
	
	// added by pradeep on 29 june 2011
	//myPickerView.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
}

@end
