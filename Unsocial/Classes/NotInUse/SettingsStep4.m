//
//  SettingsStep4.m
//  Unsocial
//
//  Created by vaibhavsaran on 15/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsStep4.h"
#import "SettingsStep5.h"
#import "SelectIndustryPicker.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "ShowIndustryDetail.h"
#import "SecuritySettings.h"
#import "Person.h"

NSString *localuserid;

@implementation SettingsStep4
@synthesize userid, industryID, industryName, subIndustryID, subIndustryName, roleID, roleName;

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"SettingsStep4 view will appear");
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
	imgBack.image = [UIImage imageNamed:@"BlankTemplate2.png"];
	[self.view addSubview:imgBack];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightbtn_OnClick)] autorelease];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Set Industry" frame:CGRectMake(0, 0, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];	
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"Saving\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];*/
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
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
		[self getIndustryNames:@""];
		
		if([stories count] > 0)
		{
			interestedIndustry1 = industryNames;			
			interestedIndustry2 = subIndustryNames;			
			interestedIndustry3 = roleNames;
		}
		else {
		}
	}
	
	if([interestedIndustry1 count] > 0)
	{
		if (!itemTableView)
		{
			itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(19, 39 + yAxisForSettingControls, 282, 310) style:UITableViewStylePlain];
			itemTableView.delegate = self;
			itemTableView.dataSource = self;
			itemTableView.rowHeight = 40;
			itemTableView.backgroundColor = [UIColor clearColor];
			itemTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
			[self.view addSubview:itemTableView];
		}
		else {
			[itemTableView reloadData];
			[self.view addSubview:itemTableView];
		}
		btnSkip.hidden = YES;
//		if(gblRecordExists){
			UIButton *btnSave = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnNext_Click) frame:CGRectMake(100, 365, 127, 34) imageStateNormal:@"save.png" imageStateHighlighted:@"save2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor blackColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
			[self.view addSubview:btnSave];
			[btnSave release];
//		}
//		else {
//			UIButton *btnNext = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnNext_Click) frame:CGRectMake(100, 365, 127, 34) imageStateNormal:@"next.png" imageStateHighlighted:@"next2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor blackColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
//		[self.view addSubview:btnNext];
//		[btnNext release];
//		}
	}
	else
	{
		noIndustry = [UnsocialAppDelegate createLabelControl:@"Click '+' sign above to add interested industry" frame:CGRectMake(20, 125, 280, 100) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:noIndustry];
		// 13 may 2011 by pradeep //[noIndustry release];
		
		btnSkip = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnSkip_Click) frame:CGRectMake(100, 365, 127, 34) imageStateNormal:@"skip.png" imageStateHighlighted:@"skip2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor blackColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
		[self.view addSubview:btnSkip];
		[btnSkip release];
	}
	NSLog(@"interestedIndustry1- %d", [interestedIndustry1 count]);
	NSLog(@"interestedIndustry2- %d", [interestedIndustry2 count]);
	NSLog(@"interestedIndustry3- %d", [interestedIndustry3 count]);
	
	if([interestedIndustryIds1 count] > 0)
	{
		for(int i = 0; i < [interestedIndustryIds1 count]; i++)
		{
			NSLog(@"interestedIndustryIds1 - %@", [interestedIndustryIds1 objectAtIndex:i]);
			NSLog(@"interestedIndustryIds2 - %@", [interestedIndustryIds2 objectAtIndex:i]);
			NSLog(@"interestedIndustryIds3 - %@\n\n", [interestedIndustryIds3 objectAtIndex:i]);
		}
	}
	//	if ([localuserid compare:nil] == NSOrderedSame)
	//		localuserid = useridForTable;	
}

- (void)btnSkip_Click {

	//tabBarController.selectedIndex = 0;
}

- (void)rightbtn_OnClick
{
	addIndustry = YES;
	SelectIndustryPicker *viewController = [[SelectIndustryPicker alloc] init];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (void)btnNext_Click {
	
	[self.view addSubview:imgBack];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Saving\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	loading.hidden = NO;
	[activityView startAnimating];
	
	NSLog(@"%d",[industryIDs count]); 
	NSLog(@"%d",[subIndustryIDs count]); 
	NSLog(@"%d",[roleIDs count]); 
	
	collectionindustry  = collectionsubindustry = collectionrole = @"";
	collectionindustryAry = [[NSMutableArray alloc]init];
	collectionsubindustryAry = [[NSMutableArray alloc]init];
	collectionroleAry = [[NSMutableArray alloc]init];
	for(int i = 0; i  < [interestedIndustryIds1 count]; i++)
	{
		collectionindustry = (collectionindustry ==@"")?[interestedIndustryIds1 objectAtIndex:i]:[[collectionindustry stringByAppendingString:@","] stringByAppendingString:[interestedIndustryIds1 objectAtIndex:i]];
		
		collectionsubindustry = (collectionsubindustry ==@"")?[interestedIndustryIds2 objectAtIndex:i]:[[collectionsubindustry stringByAppendingString:@","] stringByAppendingString:[interestedIndustryIds2 objectAtIndex:i]];
		
		collectionrole = (collectionrole ==@"")?[interestedIndustryIds3 objectAtIndex:i]:[[collectionrole stringByAppendingString:@","] stringByAppendingString:[interestedIndustryIds3 objectAtIndex:i]];
		
	}
	[collectionindustryAry addObject:collectionindustry];
	[collectionsubindustryAry addObject:collectionsubindustry];
	[collectionroleAry addObject:collectionrole];
	NSLog(@"collectionIndustry1- %@", collectionindustry);
	NSLog(@"collectionIndustry2- %@", collectionsubindustry);
	NSLog(@"collectionIndustry3- %@", collectionrole);
	
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
}

- (void)startProcess
{	
	[self sendNow:@"updateprofilestep4"];
	SecuritySettings *viewController = [[SecuritySettings alloc]init];
	if(gblRecordExists)
		[self.navigationController popToRootViewControllerAnimated:YES];
	else
		[self.navigationController popViewControllerAnimated:YES];// pushViewController:viewController animated:YES];
	[viewController release];
	saveLevel1 = NO;
}

- (void) getIndustryNames:(NSString *)inid
{
	NSString *urlString;
	urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getuserinterestedinfo&userid=%@", [arrayForUserID objectAtIndex:0]];
	urlString = [globalUrlString stringByAppendingString:urlString];
	NSLog(urlString);
	[self parseXMLFileAtURL:urlString];
}

- (void)parseXMLFileAtURL:(NSString *)URL {
	stories = [[NSMutableArray alloc] init];
	
	industryNames = [[NSMutableArray alloc] init];
	industryIDs = [[NSMutableArray alloc] init];
	subIndustryNames = [[NSMutableArray alloc] init];
	subIndustryIDs = [[NSMutableArray alloc] init];
	roleNames = [[NSMutableArray alloc] init];
	roleIDs = [[NSMutableArray alloc] init];
	
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
		//currentTitle = [[NSMutableString alloc] init];
		industryID = [[NSMutableString alloc] init];
		industryName = [[NSMutableString alloc] init];
		indNameFromServer = [[NSMutableString alloc] init];
		subIndustryID = [[NSMutableString alloc] init];
		subIndustryName = [[NSMutableString alloc] init];
		roleID = [[NSMutableString alloc] init];
		roleName = [[NSMutableString alloc] init];
		
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		//[item setObject:currentTitle forKey:@"title"];
		[item setObject:industryID forKey:@"interestindid"]; 
		[item setObject:industryName forKey:@"interestindname"]; 
		
		[item setObject:subIndustryID forKey:@"interestsubindid"]; 
		[item setObject:subIndustryName forKey:@"interestsubindname"]; 
		
		[item setObject:roleID forKey:@"interestroleid"]; 
		[item setObject:roleName forKey:@"interestrolename"]; 
		[item setObject:indNameFromServer forKey:@"interestindname"];
		
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
		
		NSLog(@"adding story currentTitle: %@", currentTitle);
		NSLog(@"adding story industryID: %@", industryID);
		NSLog(@"adding story indNameFromServer: %@", industryName);
		
		[industryNames addObject:industryName];
		[interestedIndustryIds1 addObject:industryID];		
		
		[subIndustryNames addObject:subIndustryName];
		[interestedIndustryIds2 addObject:subIndustryID];		
		
		[roleNames addObject:roleName];
		[interestedIndustryIds3 addObject:roleID];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"interestindid"])
	{
		[industryID appendString:string];
	}
	else if ([currentElement isEqualToString:@"interestindname"])
	{
		[industryName appendString:string];
	}
	else if ([currentElement isEqualToString:@"interestsubindid"])
	{
		[subIndustryID appendString:string];
	}
	else if ([currentElement isEqualToString:@"interestsubindname"])
	{
		[subIndustryName appendString:string];
	}
	else if ([currentElement isEqualToString:@"interestroleid"])
	{
		[roleID appendString:string];
	}
	else if ([currentElement isEqualToString:@"interestrolename"])
	{
		[roleName appendString:string];
	}
	
	/*if ([currentElement isEqualToString:@"title"])
	 {
	 [currentTitle appendString:string];
	 }*/
	else if ([currentElement isEqualToString:@"interestindname"])
	{
		[indNameFromServer appendString:string];
	}
	/*else if ([currentElement isEqualToString:@"guid"])
	 {
	 [industryID appendString:string];
	 }*/
	
	
	
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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];    
    // Set up the cell...
	//+ method from Delegate
	CGRect lableTtlFrame = CGRectMake(0, 0.00, 300, 40);
	lblIndustryName = [UnsocialAppDelegate createLabelControl:[interestedIndustry1 objectAtIndex:indexPath.row] frame:lableTtlFrame txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor blackColor] backgroundcolor:[UIColor blackColor]];	
	[cell.contentView addSubview:lblIndustryName];	
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [interestedIndustry1 count];
	//return [stories count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	if(industryNames)
	{
		ShowIndustryDetail *viewController = [[ShowIndustryDetail alloc]init];
		viewController.industryName = [interestedIndustry1 objectAtIndex:indexPath.row];
		viewController.subIndustryName = [interestedIndustry2 objectAtIndex:indexPath.row];
		viewController.jobRole = [interestedIndustry3 objectAtIndex:indexPath.row];		
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// Delete the row from the data source
		[interestedIndustry1 removeObjectAtIndex:indexPath.row];
		[interestedIndustry2 removeObjectAtIndex:indexPath.row];
		[interestedIndustry3 removeObjectAtIndex:indexPath.row];
		
		[interestedIndustryIds1 removeObjectAtIndex:indexPath.row];
		[interestedIndustryIds2 removeObjectAtIndex:indexPath.row];
		[interestedIndustryIds3 removeObjectAtIndex:indexPath.row];
		
		[itemTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		if([interestedIndustry1 count] == 0) {
			
			itemTableView.hidden = YES;
			noIndustry = [UnsocialAppDelegate createLabelControl:@"Click '+' sign above to add interested industry" frame:CGRectMake(20, 125, 280, 100) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTableItemNotFound txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
			[self.view addSubview:noIndustry];
			// 13 may 2011 by pradeep //[noIndustry release];
			
			btnSkip = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnSkip_Click) frame:CGRectMake(100, 365, 127, 34) imageStateNormal:@"skip.png" imageStateHighlighted:@"skip2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor blackColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
			[self.view addSubview:btnSkip];
			[btnSkip release];
		}
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
	}   
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

// decide what kind of accesory view (to the far right) we will use
/*- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryDisclosureIndicator;
}*/
- (void)leftbtn_OnClick
{
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

- (BOOL) sendNow: (NSString *) flag {
	NSLog(@"Sending....");
	//NSData *imageData1;
	
	
	// setting up the URL to post to
	
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",flag];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	//NSString *deviceTocken;
	
	NSString *CollectionIndustry = [NSString stringWithFormat:@"%@\r\n",[collectionindustryAry objectAtIndex:0]];
	NSString *CollectionSubIndustry = [NSString stringWithFormat:@"%@\r\n",[collectionsubindustryAry objectAtIndex:0]];
	NSString *CollectionRole = [NSString stringWithFormat:@"%@\r\n",[collectionroleAry objectAtIndex:0]];
	
	if ([[collectionindustryAry objectAtIndex:0] compare:nil] == NSOrderedSame)
		CollectionIndustry = [NSString stringWithFormat:@"%@\r\n",@""];
	else CollectionIndustry = [NSString stringWithFormat:@"%@\r\n",collectionindustry];
	//NSString *role = [NSString stringWithFormat:@"%@\r\n",txtPersonRole.text];
	
	if ([[collectionsubindustryAry objectAtIndex:0] compare:nil] == NSOrderedSame)
		CollectionSubIndustry = [NSString stringWithFormat:@"%@\r\n",@""];
	else CollectionSubIndustry = [NSString stringWithFormat:@"%@\r\n",collectionsubindustry];
	//NSString *role = [NSString stringWithFormat:@"%@\r\n",txtPersonRole.text];
	
	if ([[collectionroleAry objectAtIndex:0] compare:nil] == NSOrderedSame)
		CollectionRole = [NSString stringWithFormat:@"%@\r\n",@""];
	else CollectionRole = [NSString stringWithFormat:@"%@\r\n",collectionrole];
	//NSString *role = [NSString stringWithFormat:@"%@\r\n",txtPersonRole.text];
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
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
	
	if ([flag compare:@"updateprofilestep4"] == NSOrderedSame)
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"interestedind\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",CollectionIndustry] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"interestedsubind\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",CollectionSubIndustry] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"interestedrole\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",CollectionRole] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
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
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key compare:@"Userid"] == NSOrderedSame)			
		{
			//userid = [dic objectForKey:key];
			
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				[self updateDataFileOnSave:[dic objectForKey:key]];
				NSLog(@"\n\n\n\n\n\n#######################-- post for SettingsStep4 added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;				
				useridForTable = [dic objectForKey:key];
				break;
			}			
		}
		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(returnString);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
	//return;
}

- (BOOL) getDataFromFile {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial4"];
	
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
		
		collectionindustry = [[tempArray objectAtIndex:0] collectionindustry];
		collectionsubindustry = [[tempArray objectAtIndex:0] collectionsubindustry];
		collectionrole = [[tempArray objectAtIndex:0] collectionrole];
		
		int collectionindustryLength = [collectionindustry length];
		int countTotalIndustry = collectionindustryLength%10;
		int j = 0; 
		
		industryNames = [[NSMutableArray alloc] init];
		industryIDs = [[NSMutableArray alloc] init];
		for(int i = 1; i <= countTotalIndustry ;  i++)
		{
			NSString *industryid= [collectionindustry substringWithRange:NSMakeRange(j, 10)];
			[self getIndustryNames:industryid];
			j = j + 11;
		}
		
		[decoder finishDecoding];
		[decoder release];	
		
		if ( [collectionindustry compare:@""] == NSOrderedSame || !collectionindustry)
		{
			return NO;
		}
		else {
			return YES;
		}		
	}
	else {
		//just in case the file is not ready yet.
		return NO;
	}
}

- (void) updateDataFileOnSave:(NSString *)uid {
	
	//NSLog(@"Selected Value- %d", selitem);
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	
	newPerson.collectionindustry = collectionindustry;
	newPerson.collectionsubindustry = collectionsubindustry;
	newPerson.collectionrole = collectionrole;
	newPerson.userid = useridForTable;
	
	if ([collectionindustry compare:nil] == NSOrderedSame)
		newPerson.collectionindustry = @"";
	else newPerson.collectionindustry = collectionindustry;
	
	if ([collectionsubindustry compare:nil] == NSOrderedSame)
		newPerson.collectionsubindustry = @"";
	else newPerson.collectionsubindustry = collectionsubindustry;
	
	if ([collectionrole compare:nil] == NSOrderedSame)
		newPerson.collectionrole = @"";
	else newPerson.collectionrole = collectionrole;
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial4"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
}

- (void)dealloc {
    [super dealloc];
	
}

- (void)viewDidLoad {
}

@end
