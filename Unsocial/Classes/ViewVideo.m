//
//  SettingsStep4.m
//  Unsocial
//
//  Created by vaibhavsaran on 15/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ViewVideo.h"
#import "SettingsStep5.h"
#import "SelectIndustryPicker.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "ShowIndustryDetail.h"
#import "SecuritySettings.h"
#import "Person.h"
#import "PlayVideo.h"

NSString *localuserid;

@implementation ViewVideo
@synthesize userid, videoName, videoTitleName;

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"ViewVideo view will appear");
	NSLog(@"User's Userid- %@", [arrayForUserID objectAtIndex:0]);
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
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"use_case_311.png"];
	[self.view addSubview:imgBack];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	self.navigationItem.leftBarButtonItem = leftcbtnitme;
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"My Videos" frame:CGRectMake(0, 0, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Saving\nplease standby" frame:CGRectMake(25, 125 + yAxisForSettingControls, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180 + yAxisForSettingControls, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	activityView.hidden = YES;
	[activityView stopAnimating];
	
	itemTableView.hidden = NO;	
	
	if (!itemTableView)
	{
		[self getVideoForUser:@""];
	}
	
	if([aryVideo count] > 0)
	{
		if (!itemTableView)
		{
			itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(19, 45, 282, 350) style:UITableViewStylePlain];
			itemTableView.delegate = self;
			itemTableView.dataSource = self;
			itemTableView.rowHeight = 65;
			itemTableView.backgroundColor = [UIColor clearColor];
			itemTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
			[self.view addSubview:itemTableView];
		}
		else {
			[itemTableView reloadData];
			[self.view addSubview:itemTableView];
		}
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete_click)] autorelease];
	}
	else
	{
		lblNoVideo = [UnsocialAppDelegate createLabelControl:@"Currently you have no video url" frame:CGRectMake(20, 150, 280, 100) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:lblNoVideo];
		// 13 may 2011 by pradeep //[lblNoVideo release];
	}
	NSLog(@"aryVideo- %d", [aryVideo count]);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];    
    // Set up the cell...
	//+ method from Delegate
	CGRect lableTtlFrame = CGRectMake(0.00, 0.00, 300, 25);
	
	lblVideoName = [UnsocialAppDelegate createLabelControl:[aryVideoTitle objectAtIndex:indexPath.row] frame:lableTtlFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor darkGrayColor] backgroundcolor:[UIColor whiteColor]];
	cell.selectionStyle = UITableViewCellSeparatorStyleNone;
	[cell.contentView addSubview:lblVideoName];
	
	lblVideoTitle = [UnsocialAppDelegate createLabelControl:[aryVideo objectAtIndex:indexPath.row] frame:CGRectMake(0.00, 25, 300, 40) txtAlignment:UITextAlignmentLeft numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:@"ArialRoundedMTBold-Italic" fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor whiteColor]];
	cell.selectionStyle = UITableViewCellSeparatorStyleNone;
	[cell.contentView addSubview:lblVideoTitle];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [aryVideo count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	PlayVideo *viewController = [[PlayVideo alloc]init];
	viewController.websUrl = [aryVideo objectAtIndex:indexPath.row];		
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
 }

- (void)leftbtn_OnClick {
	
	[lastVisitedFeature removeAllObjects];
	[lastVisitedFeature addObject:@"viewvideo"];
	[self dismissModalViewControllerAnimated:YES];
//	[self.navigationController popViewControllerAnimated:YES];
}

- (void) getVideoForUser:(NSString *)inid {
	// Time Formats
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	NSString *urlString;
	urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getvideos&userid=%@&datetime=%@", [arrayForUserID objectAtIndex:0], usertime];
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

- (void)delete_click {
	
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
		videoName = [[NSMutableString alloc] init];
		videoTitleName = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		[item setObject:videoName forKey:@"videourl"]; 
		[item setObject:videoTitleName forKey:@"videottl"]; 
		[stories addObject:[item copy]];

		[aryVideo addObject:videoName];
		[aryVideoTitle addObject:videoTitleName];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"videourl"])
	{
		[videoName appendString:string];
	}
	if ([currentElement isEqualToString:@"videottl"])
	{
		[videoTitleName appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	printf("Did begin editing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	printf("Did end editing\n");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	printf("Clearing Keyboard\n");
    return YES;
}

- (void)viewDidLoad {
}
@end