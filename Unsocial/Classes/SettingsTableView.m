//
//  SettingsTableView.m
//  Unsocial
//
//  Created by vaibhavsaran on 03/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "UnsocialAppDelegate.h"
#import "SettingsTableView.h"
#import "Settings.h"
#import "SettingsStep2.h"
#import "SettingsStep3.h"
#import "SettingsStep4.h"
#import "SettingsStep5.h"
#import "SettingsAddVideo.h"
#import "Person.h"
#import "SecuritySettingsLevel1.h"
#import "GlobalVariables.h"
#import "LauncherViewTestController.h"
#import "SettingsAddKeywords.h"
#import "SettingsCurrentStatus.h"
#import "MyProfile.h"
#import "webViewForLinkedIn.h"

NSInteger intFlagGenInfo = 0;
NSInteger intFlagMetatags = 0;
NSInteger intFlagNetNWeb = 0;
NSInteger intFlagVideoAd = 0;
NSInteger intFlagInterest = 0;
NSInteger intFlagDigiBill = 0;
NSInteger intFlagSecurSett = 0;
NSInteger intFlagDefineYou = 0;

@implementation SettingsTableView
@synthesize userid;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(createTableView) userInfo:self.view repeats:NO];
	[self ifDataExists];
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
}

- (void)viewWillAppear:(BOOL)animated {
	
	NSString *linkedmail = [UnsocialAppDelegate getLinkedInMailFromFile];
	if (flagforlinkedinmailset == 1 && ![linkedmail isEqualToString:@""]) {
		
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"E-Mail set successfully." message:@"Please check your mailbox and get your unsocial credentials from there\n(You can use this mail id as your login id)." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		flagforlinkedinmailset = 0;
	}
	else if (flagforlinkedinmailset == 2) {
		
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"E-Mail changed successfully." message:@"Please check your mailbox and get your unsocial credentials from there." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[errorAlert show];
		[errorAlert release];
		flagforlinkedinmailset = 0;
	}
	
	NSLog(@"VC view will appear");
	NSLog(@"User's Userid- %@", [arrayForUserID objectAtIndex:0]);
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
		
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createTableView {
	
	NSMutableDictionary *item1, *item2, *item3, *item5, *item6, *item7;
	item1 = [self setOptions:@"General Information" index:0];
	item2 = [self setOptions:@"Company " index:1];
	item3 = [self setOptions:@"My Metatags" index:2];
		//item5 = [self setOptions:@"unsocial Tile" index:4];
	item6 = [self setOptions:@"Privacy Settings" index:5];
	item7 = [self setOptions:@"View Profile" index:6];
	items = [[NSMutableArray alloc] initWithObjects:item1, item2, item3, item6, item7, nil];
	
	itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
	itemTableView.delegate = self;
	itemTableView.dataSource = self;
	itemTableView.rowHeight = 70;
	itemTableView.backgroundColor = [UIColor clearColor];
	itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:itemTableView];	
}

- (NSMutableDictionary *) setOptions:(NSString *)itemName index: (int) i {
	NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
	[item setObject:itemName forKey:@"Name"];
	return item;
}
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)leftbtn_OnClick {
	
	//[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"settings"];
//	LauncherViewTestController *viewController = [[LauncherViewTestController alloc]init];
//	if(gblRecordExists)
		[self dismissModalViewControllerAnimated:YES];
//		[self.navigationController popToRootViewControllerAnimated:YES];
//	else
//		[self.navigationController pushViewController:viewController animated:YES];
//	[viewController release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
	// Set up the cell
	UILabel *lblOptions = [UnsocialAppDelegate createLabelControl:[[items objectAtIndex: indexPath.row] objectForKey: @"Name"] frame:CGRectMake(25, 0.00, 290, itemTableView.rowHeight) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	UIImageView *imgCheckMark = [UnsocialAppDelegate createImageViewControl:CGRectMake(5, (itemTableView.rowHeight - 13)/2, 13, 13) imageName:@"checkmark.png"];
	
	if(indexPath.row == 0)
		[cell.contentView addSubview:imgCheckMark];
	
	else if(indexPath.row == 1 && intFlagNetNWeb == 1)
		[cell.contentView addSubview:imgCheckMark];
	
	else if(indexPath.row == 2 && intFlagMetatags == 1)
		[cell.contentView addSubview:imgCheckMark];
	
		//else if(indexPath.row == 3 && intFlagDigiBill == 1)
		//[cell.contentView addSubview:imgCheckMark];
	
	else if(indexPath.row == 3 && intFlagSecurSett == 1)
		[cell.contentView addSubview:imgCheckMark];
	
	else if(indexPath.row == 4)// && intFlagMetatags == 1)
	 [cell.contentView addSubview:imgCheckMark];
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(5, itemTableView.rowHeight - 2, 310, 2) imageName:@"dashboardhorizontal.png"];
	if(indexPath.row != 4 || indexPath.row != 0)
		[cell.contentView addSubview:imgHorSep];
	
	UIImageView *imgDisclouser = [UnsocialAppDelegate createImageViewControl:CGRectMake(300, (itemTableView.rowHeight - 36)/2, 18, 36) imageName:@"disclouser.png"];
	[cell.contentView addSubview:imgDisclouser];
	
	[cell.contentView addSubview:lblOptions];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	[activityView stopAnimating];
	activityView.hidden = YES;
	
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	//[imgDisclouser release];
	// end 3 august 2011 for fixing memory issue
	
	// 13 may 2011 by pradeep //[lblOptions release];
	return cell;
}

- (void) getCompanyInfoForLinkedIn {
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@",@"0"];
	else deviceTocken = [NSString stringWithFormat:@"%@",[devTocken objectAtIndex:0]];
	deviceTocken = [deviceTocken stringByReplacingOccurrencesOfString:@" " withString:@"$"];
	NSString *deviceType = [NSString stringWithFormat:@"%@",@"iphone"];
	
		//DEFAULT TERMS/////////////////////////////////////
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@"$"];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = dt;//[userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@",gbllatitude];
	NSString *allownotification = [NSString stringWithFormat:@"%@",@"0"];
	
	NSArray *arraySignIn = [[NSArray alloc] initWithObjects:deviceTocken, deviceUDID, deviceType, [arrayForUserID objectAtIndex:0], @"LinkedIn", strlongitude, strlatitude, allownotification, userdatetime, nil];
	
	webViewForLinkedIn *wvli = [[webViewForLinkedIn alloc]init];
	wvli.camefrom = @"UnsocialCompanyInfo";
	wvli.arraySignIn = arraySignIn;
	[self.navigationController pushViewController:wvli animated:YES];
	flagforlinkedincaompanynavigation = 1;
	[wvli release];
}

- (NSString *)getIndustryFromFile {
	
	NSMutableData *theData;
	NSKeyedUnarchiver *decoder;
	NSMutableArray *tempArray;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial2"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
			//open it and read it 
		NSLog(@"data file found. reading into memory");
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];
		userid = [[tempArray objectAtIndex:0] userid];
		[decoder finishDecoding];
		[decoder release];	
	}
	else { //just in case the file is not ready yet.
		return NO;
	}
	return [[tempArray objectAtIndex:0] userindustry];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // Navigation logic may go here. Create and push another view controller.
	Settings *s0 = [[Settings alloc]init]; // Gen Info
	SettingsStep2 *s1 = [[SettingsStep2 alloc]init]; // Company
	SettingsAddKeywords *s2 = [[SettingsAddKeywords alloc]init]; // Metatags
	
	//NSString *strindustry = [self getIndustryFromFile];
	NSString *findPrefix = [UnsocialAppDelegate getLinkedInPrefixFromFile];
	//SettingsAddVideo *s3 = [[SettingsAddVideo alloc]init]; // Videos
	//SettingsStep5 *s4 = [[SettingsStep5 alloc]init]; // Billboard
	SecuritySettingsLevel1 *s5 = [[SecuritySettingsLevel1 alloc]init]; // security
	MyProfile *pp = [[MyProfile alloc]init]; // My Profile
	
	switch (indexPath.row) {
		case 0:
			s0.userid = userid;
			s0.comingfrom = 1;
			[self.navigationController pushViewController:s0 animated:YES];
			[s0 release];
			break;
		case 1:
			s1.userid = userid;
			[self.navigationController pushViewController:s1 animated:YES];
			[s1 release];
			break;
		case 2:
			[aryKeyword removeAllObjects];
			s2.userid = userid;
			[self.navigationController pushViewController:s2 animated:YES];
			//commented by pradeep on 7 june 2011 since if user is in airplane mode and click on "My Metatag" then it opens and automatically bcaked and prompt sync error msg and as soon as user clicked on "OK" app crashes
			//[s2 release];
			break;
		/*case 3:
			s3.userid = userid;
			s3.comingfrom = 1;
			[aryVideo removeAllObjects];
			[aryVideoTitle removeAllObjects];
			[self.navigationController pushViewController:s3 animated:YES];
			[s3 release];
			break;
		case 3:
			s4.userid = userid;
			s4.comingfrom = 1;
			[self.navigationController pushViewController:s4 animated:YES];
			[s4 release];
			break;*/
		case 3:
			s5.userid = userid;
			[self.navigationController pushViewController:s5 animated:YES];
			[s5 release];
			break;
		case 4:
			pp.userid = userid;
			[self.navigationController pushViewController:pp animated:YES];
			[pp release];
			break;
	}
}

- (void)ifDataExists {
	
	intFlagDigiBill = 0;
	NSMutableArray *numberOfItems = [[NSMutableArray alloc]init];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSFileManager *manager = [NSFileManager defaultManager];
	NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
		//[manager contentsOfDirectoryAtPath:documentsDirectory];
	for (NSString *s in fileList)
	{
		[numberOfItems addObject:s];
	}
	for(int i = 0; i < [numberOfItems count]; i++){
		
		NSLog(@"Searching- %@", [numberOfItems objectAtIndex:i]);
		if([[numberOfItems objectAtIndex:i] isEqualToString:@"settingsinfo4Unsocial2"])
			intFlagNetNWeb = [self lookRecordIntoFile:@"settingsinfo4Unsocial2"];
		else if([[numberOfItems objectAtIndex:i] isEqualToString:@"settingsinfo4metatags"])
			intFlagMetatags = [self lookRecordIntoFile:@"settingsinfo4metatags"];
		else if([[numberOfItems objectAtIndex:i] isEqualToString:@"settingsinfo4Unsocial4"])
			intFlagInterest = 1;
		else if([[numberOfItems objectAtIndex:i] isEqualToString:@"billboard.jpg"])
			intFlagDigiBill = 1;
		else if([[numberOfItems objectAtIndex:i] isEqualToString:@"settingsinfo4Unsocial7"])
			intFlagVideoAd = 1;
		else if([[numberOfItems objectAtIndex:i] isEqualToString:@"securitysettings"])
			intFlagSecurSett = [self lookRecordIntoFile:@"securitysettings"];
	}
}

-(NSInteger)lookRecordIntoFile:(NSString *)fileName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSString *foundrecord;
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
		
		if([fileName compare:@"settingsinfo4Unsocial2"] == NSOrderedSame) 
		{

			NSLog(@"%@", [[tempArray objectAtIndex:0] usercompany]);
			NSLog(@"%@", [[tempArray objectAtIndex:0] userwebsite]);
			NSLog(@"%@", [[tempArray objectAtIndex:0] userindustry]);
			NSLog(@"%@", [[tempArray objectAtIndex:0] userfunction]);
			NSString *compname = [[tempArray objectAtIndex:0] usercompany];
			NSString *compwebname = [[tempArray objectAtIndex:0] userwebsite];
			NSString *indname = [[tempArray objectAtIndex:0] userindustry];
			NSString *fxnname = [[tempArray objectAtIndex:0] userfunction];
			
			if(([compname compare:@""] != NSOrderedSame) || ([compwebname compare:@""] != NSOrderedSame) || ([indname compare:@""] != NSOrderedSame) || ([fxnname compare:@""] != NSOrderedSame))

				foundrecord = @"1";
			else
				foundrecord = @"";
		}
		
		else if([fileName compare:@"settingsinfo4metatags"] == NSOrderedSame)
			foundrecord = [[tempArray objectAtIndex:0] strsetkeywords];
		
		else if([fileName compare:@"securitysettings"] == NSOrderedSame)
			foundrecord = [[tempArray objectAtIndex:0] selectedSecurityLevel];
		else
			foundrecord = @"";
		
		[decoder finishDecoding];
		[decoder release];	
		
		if ([foundrecord compare:@""] == NSOrderedSame || !foundrecord ||[foundrecord compare:@"\r\n"] == NSOrderedSame ||[foundrecord compare:@"0"] == NSOrderedSame)
		{
			return 0;
		}
		else {
			// initialized global userid variable (returned usierid from web app) for tracing user in whole app
			
			return 1;
		}		
	}
	else {
		//just in case the file is not ready yet.
		return 0;
	}
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
	//itemTableView.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
}


@end
