    //
//  SettingsStep2.m
//  unsocialComponents
//
//  Created by vaibhavsaran on 03/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnsocialAppDelegate.h"
#import "SettingsStep2.h"
#import "GlobalVariables.h"
#import "SelectIndustry3Picker.h"
#import "Person.h"
#import "SelectIndustryPicker.h"


#define klabelFontSize  13
#define ktxtFieldsX		25
static NSString *kSourceKey = @"sourceKey";
static NSString *kViewKey = @"viewKey";
UIImageView *imgHorSep;

@implementation SettingsStep2
@synthesize dataSourceArray;
@synthesize txtCompany, txtWebsite, txtIndustry, txtFunction, txtPublicProfile, txtTitle, FillBlank;
@synthesize usercompany, userwebsite, userindustry, userfunction, userid,userindid, userroleid, aray1;
@synthesize currentElement, userdevicetocken, userlastuse, userlinkedin, userind, strFrom, userprefix;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"SettingsStep2 view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];

	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];

	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(btn_LeftOnClick)] autorelease];

	[self createControls];
	[self getPrefixFromFile];
	[self createTableView];
}	
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	/*if (flagforcompinfo == 1) {
		
		if([aryCompanyInfo count] > 0) {
		}
		else
			[self getDataFromFile];
		[self getProfile];
		[self updateDataFile4CompanyInfo];
	}*/

	itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 45, 310, 455) style:UITableViewStylePlain];
	itemTableView.delegate = self;
	itemTableView.dataSource = self;
	itemTableView.backgroundColor = [UIColor clearColor];
	itemTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	[self.view addSubview:itemTableView];
	[activityView stopAnimating];
}

- (void)createControls {
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	[imgBack release];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"signupback.png"];
	[self.view addSubview:imgBack];
	[imgBack release];

	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object i.e. without auto release
	//topImgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 40, 300, 2) imageName:@"dashboardhorizontal.png"];
	topImgHorSep = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(10, 40, 300, 2) imageName:@"dashboardhorizontal.png"];
	// end 3 august 2011
	[self.view addSubview:topImgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue
	//[topImgHorSep release];
	// end 3 august 2011
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//heading = [UnsocialAppDelegate createLabelControl:@"Company" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	heading = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Company" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object i.e. without auto release
	//loadingBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(20, 150, 280, 90) imageName:@"loadingback.png"];
	loadingBack = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(20, 150, 280, 90) imageName:@"loadingback.png"];
	// end 3 august 2011
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"saving\nplease standby" frame:CGRectMake(20, 140, 280, 90) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];*/
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view	addSubview:activityView];
	[activityView startAnimating];
}

- (void)createTableView {	
	
	self.dataSourceArray = [NSArray arrayWithObjects:
							[NSDictionary dictionaryWithObjectsAndKeys:@"Title:", kSourceKey,self.txtTitle, kViewKey,nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:@"Company Name:", kSourceKey,self.txtCompany, kViewKey,nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:@"Website:", kSourceKey,self.txtWebsite, kViewKey,nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:@"Public Profile:", kSourceKey,self.txtPublicProfile, kViewKey,nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:@"Industry:", kSourceKey,self.txtIndustry, kViewKey,nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:@"Function:", kSourceKey,self.txtFunction, kViewKey,nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:@"", kSourceKey,self.FillBlank, kViewKey,							 nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:@"", kSourceKey,self.FillBlank, kViewKey,							 nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:@"", kSourceKey,self.FillBlank, kViewKey,							 nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:@"", kSourceKey,self.FillBlank, kViewKey,							 nil],
							
							nil];
	
		// we aren't editing any fields yet, it will be in edit when the user touches an edit field
	self.editing = NO;
	
	if([aryCompanyInfo count] > 0) {
		
		txtCompany.text = [aryCompanyInfo objectAtIndex:0];
		txtWebsite.text = [aryCompanyInfo objectAtIndex:1];
		txtIndustry.text = [aryCompanyInfo objectAtIndex:2];
		txtFunction.text = [aryCompanyInfo objectAtIndex:3];
		txtPublicProfile.text = [aryCompanyInfo objectAtIndex:6];
		txtTitle.text = [aryCompanyInfo objectAtIndex:7];
	}
	else
		[self getDataFromFile];
	
	if(!aray1)
		[self checkForLeftNavClick];
}

- (void) getPrefixFromFile {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial"];
	
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
		userprefix = [[tempArray objectAtIndex:0] userprefix];
		
		[decoder finishDecoding];
		[decoder release];	
	}
}

- (void) _btnIndustry_Click {
	
	[self resignAll];	 
	CGSize contentSize = CGSizeMake(320, 480);	
	UIGraphicsBeginImageContext(contentSize);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	capturedScreen = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:UIGraphicsGetImageFromCurrentImageContext(), nil]];
	UIGraphicsEndImageContext();	
	
	[self storeToMutableArray];
	SelectIndustryPicker *viewController = [[SelectIndustryPicker alloc]init];
	[txtCompany resignFirstResponder];
	[txtWebsite resignFirstResponder];
	[self.navigationController presentModalViewController:viewController animated:YES];
	[viewController release];
}

- (void)_btnFunction_Click {

	[self resignAll];	 
	CGSize contentSize = CGSizeMake(320, 480);	
	UIGraphicsBeginImageContext(contentSize);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	capturedScreen = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:UIGraphicsGetImageFromCurrentImageContext(), nil]];
	UIGraphicsEndImageContext();	
	
	[self storeToMutableArray];
	SelectIndustry3Picker *viewController = [[SelectIndustry3Picker alloc]init];
	[txtCompany resignFirstResponder];
	[txtWebsite resignFirstResponder];
	[self.navigationController presentModalViewController:viewController animated:YES];
	[viewController release];
}

- (void)storeToMutableArray {
	
	if(aryCompanyInfo == nil)
		aryCompanyInfo = [[NSMutableArray alloc]init];
	else
		[aryCompanyInfo removeAllObjects];
	
	if([txtCompany.text compare:nil] == NSOrderedSame)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:txtCompany.text];
	
	if([txtWebsite.text compare:nil] == NSOrderedSame)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:txtWebsite.text];
	
	if([txtIndustry.text compare:nil] == NSOrderedSame)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:txtIndustry.text];
	
	if([txtFunction.text compare:nil] == NSOrderedSame)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:txtFunction.text];
	
	if (flagforcompinfo != 1) {
		
		NSLog(@"idOfSelectedInd- %@", idOfSelectedInd);
		if([arrayIndId count] > 0)
			[aryCompanyInfo addObject:idOfSelectedInd];	
		else{
			[aryCompanyInfo addObject:@""];
		}
		
		NSLog(@"arrayRoleId- %@", idOfSelectedFunction);
		if([arrayRoleId count] > 0)
			[aryCompanyInfo addObject:idOfSelectedFunction];	
		else{
			[aryCompanyInfo addObject:@""];
		}
	}
	else {
		
		NSLog(@"idOfSelectedInd- %@", userindid);
		if(userindid != nil)
			[aryCompanyInfo addObject:userindid];	
		else{
			[aryCompanyInfo addObject:@""];
		}
		
		NSLog(@"arrayRoleId- %@", userroleid);
		if(userroleid != nil)
			[aryCompanyInfo addObject:userroleid];	
		else{
			[aryCompanyInfo addObject:@""];
		}
	}
	
	/*if(idOfSelectedFunction == nil)
	 [aryCompanyInfo addObject:@""];
	 else [aryCompanyInfo addObject:idOfSelectedFunction];*/
	
	if([txtPublicProfile.text compare:nil] == NSOrderedSame)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:txtPublicProfile.text];
	
	if([txtTitle.text compare:nil] == NSOrderedSame)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:txtTitle.text];
}

- (void)btnDone_OnClick {
	
	[txtFunction resignFirstResponder];
}

- (void)btnSave_Click {
	
	[UnsocialAppDelegate playClick];
	[self storeToMutableArray];
	[self.view addSubview:loadingBack];
	loadingBack.hidden = NO;
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 210, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"saving\nplease standby" frame:CGRectMake(20, 140, 280, 90) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	loading.hidden = NO;
	[self resignAll];
		//btnSave.hidden = YES;
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess:) userInfo:self.view repeats:NO];
}

-(void)resignAll {
	
	[txtCompany resignFirstResponder];
	[txtWebsite resignFirstResponder];
	[txtPublicProfile resignFirstResponder];
	[txtTitle resignFirstResponder];
}

- (void)startProcess:(id)sender {
	
	[self send4CompanyInfo:@"updateprofilestep2"];
	if ([arrayForUserID count]==0)
		[arrayForUserID addObject:userid];
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) send4CompanyInfo: (NSString *) flag {
	NSLog(@"Sending....");
	
		// setting up the URL to post to
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];	
		// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
	 */
	
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",flag];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	
	NSString *usrcompany = [NSString stringWithFormat:@"%@\r\n",[aryCompanyInfo objectAtIndex:0]];
	NSString *usrwebsite = [NSString stringWithFormat:@"%@\r\n",[aryCompanyInfo objectAtIndex:1]];
	NSString *usrindustry = [NSString stringWithFormat:@"%@\r\n",[aryCompanyInfo objectAtIndex:4]];
	NSString *usrfunction = [NSString stringWithFormat:@"%@\r\n",[aryCompanyInfo objectAtIndex:5]];
	NSString *usrpublicprofile = [NSString stringWithFormat:@"%@\r\n",[aryCompanyInfo objectAtIndex:6]];
	NSString *usrtitle = [NSString stringWithFormat:@"%@\r\n",[aryCompanyInfo objectAtIndex:7]];
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];	
	
	/*
	 now lets create the body of the post
	 */
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
	
	if ([flag compare:@"updateprofilestep2"] == NSOrderedSame)
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"usercompany\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrcompany] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userwebsite\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrwebsite] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
		//***************
		// added by Pradeep on 3 Aug 2010 for adding Public Profile field
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userlinkedin\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrpublicprofile] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		//***************
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"usertitle\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrtitle] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		//***************
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userind\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrindustry] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userrole\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrfunction] dataUsingEncoding:NSUTF8StringEncoding]];
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
		if ([key isEqualToString:@"Userid"])			
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				[self updateDataFileOnSave:[dic objectForKey:key]];
				NSLog(@"\n\n\n\n\n\n#######################-- post for SettingsStep2 added successfully --#######################\n\n\n\n\n\n");
				successflg=YES;
				[aryCompanyInfo removeAllObjects];
				userid = [dic objectForKey:key];
				break;
			}			
		}
		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

- (void) updateDataFileOnSave:(NSString *)uid {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	newPerson.userid = uid;
	newPerson.usercompany = [aryCompanyInfo objectAtIndex:0];
	newPerson.userwebsite = [aryCompanyInfo objectAtIndex:1];
	newPerson.userindustry = [aryCompanyInfo objectAtIndex:2];
	newPerson.userfunction = [aryCompanyInfo objectAtIndex:3];
	newPerson.userlinkedin = [aryCompanyInfo objectAtIndex:6];
	newPerson.usertitle = [aryCompanyInfo objectAtIndex:7];
	
	newPerson.userindid = [aryCompanyInfo objectAtIndex:4];
	newPerson.userroleid = [aryCompanyInfo objectAtIndex:5];
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial2"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
}

- (BOOL) getDataFromFile {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial2"];
	
	NSLog(@"%@", path);
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
		
		txtCompany.text = [[tempArray objectAtIndex:0] usercompany];
		
		//******* CHECKING WHETHER OLDER VERSION HAS WEBSITE WITH 'http://' START
		NSString *_strwebsite = [[tempArray objectAtIndex:0] userwebsite];
		
		if ([_strwebsite length] > 6) {
			
			NSArray *_sepbyhttp = [_strwebsite componentsSeparatedByString:@"http://"];
			if([_sepbyhttp count] > 1)
				_strwebsite = [_sepbyhttp objectAtIndex:1];
			else
				_strwebsite = [_sepbyhttp objectAtIndex:0];
		}
		txtWebsite.text = _strwebsite;
		//******* CHECKING WHETHER OLDER VERSION HAS WEBSITE WITH 'http://' ENDS
		
		txtIndustry.text = [[tempArray objectAtIndex:0] userindustry];
		txtFunction.text = [[tempArray objectAtIndex:0] userfunction];
		
		//******* CHECKING WHETHER OLDER VERSION HAS WEBSITE WITH 'http://' START
		NSString *_strpubpro = [[tempArray objectAtIndex:0] userlinkedin];
		
		if ([_strpubpro length] > 6) {
			
			NSArray *_sepbyhttp2 = [_strpubpro componentsSeparatedByString:@"http://"];
			if([_sepbyhttp2 count] > 1)
				_strpubpro = [_sepbyhttp2 objectAtIndex:1];
			else
				_strpubpro = [_sepbyhttp2 objectAtIndex:0];
		}
		txtPublicProfile.text = _strpubpro;
		//******* CHECKING WHETHER OLDER VERSION HAS WEBSITE WITH 'http://' ENDS

		txtTitle.text = [[tempArray objectAtIndex:0] usertitle];
		userid = [[tempArray objectAtIndex:0] userid];
		
		if (!arrayIndId)
			arrayIndId = [[NSMutableArray alloc]init];
		else
			[arrayIndId removeAllObjects];
		if (!arrayRoleId)
			arrayRoleId = [[NSMutableArray alloc]init];
		else
			[arrayRoleId removeAllObjects];
		
		idOfSelectedInd = [[tempArray objectAtIndex:0] userindid];
		[arrayIndId addObject:idOfSelectedInd];
		
		idOfSelectedFunction = [[tempArray objectAtIndex:0] userroleid];
		[arrayRoleId addObject:idOfSelectedFunction];
		
		[self storeToMutableArray];
		[decoder finishDecoding];
		[decoder release];	
		
		if ( [userid isEqualToString:@""] || !userid)
		{
			return NO;
		}
		else {
			return YES;
		}
		
		
		
	}
	else { //just in case the file is not ready yet.
		return NO;
	}
}

- (void)btnSkip_Click
{
	//tabBarController.selectedIndex = 0;
}

- (void)checkForLeftNavClick {
	
	NSString *str1, *str2, *str3, *str4, *str5, *str6;
	str1 = txtCompany.text;
	str2 = txtWebsite.text;
	str3 = txtPublicProfile.text;
	str4 = txtIndustry.text;
	str5 = txtFunction.text;
	str6 = txtTitle.text;
	
	if(!str1) str1 = @"";
	if(!str2) str2 = @"";
	if(!str3) str3 = @"";
	if(!str4) str4 = @"";
	if(!str5) str5 = @"";
	if(!str6) str6 = @"";
	
	self.aray1 = [NSArray arrayWithObjects:str1, str2, str3, str4, str5, str6, nil];
}

- (void)btn_LeftOnClick {

	[self resignAll];	 
	NSString *str1, *str2, *str3, *str4, *str5, *str6;
	str1 = [txtCompany.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	str2 = [txtWebsite.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	str3 = [txtPublicProfile.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	str4 = [txtIndustry.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	str5 = [txtFunction.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	str6 = [txtTitle.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if(!str1) str1 = @"";
	if(!str2) str2 = @"";
	if(!str3) str3 = @"";
	if(!str4) str4 = @"";
	if(!str5) str5 = @"";
	if(!str6) str6 = @"";
	
	NSString *strA1, *strA2, *strA3, *strA4, *strA5, *strA6;

	strA1 = [[self.aray1 objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

	strA2 = [[self.aray1 objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

	strA3 = [[self.aray1 objectAtIndex:2] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

	strA4 = [[self.aray1 objectAtIndex:3] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

	strA5 = [[self.aray1 objectAtIndex:4] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	strA6 = [[self.aray1 objectAtIndex:5] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if ([strA1 isEqualToString: str1] && [strA2 isEqualToString: str2] && [strA3 isEqualToString: str3] && [strA4 isEqualToString: str4] && [strA5 isEqualToString: str5] && [strA6 isEqualToString: str6]) {
		
		printf("Matched");
		[aryCompanyInfo removeAllObjects];
		
		if (flagforlinkedincaompanynavigation == 1) {
			
			[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
		}
		else {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
	else {
		
		printf("Not Matched");
		if ([str6 length] > 80) {
			
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Title is too long to accept." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
			return;
		}
		
		if ([str1 length] > 80) {
			
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Company name is too long to accept." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
			return;
		}
		
		if(![str2 isEqualToString:@""]) {
			
			BOOL _strwebsite = [UnsocialAppDelegate validateUrl:str2];
			if (!_strwebsite) {
				
				UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Website url is not in correct format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[errorAlert show];
				[errorAlert release];
				return;
			}
		}
		if(![str3 isEqualToString:@""]) {
			
			BOOL _strpubpro = [UnsocialAppDelegate validateUrl:str3];
			if (!_strpubpro) {
				
				UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Pulic profile url is not in correct format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[errorAlert show];
				[errorAlert release];
				return;
			}
		}
		[self btnSave_Click];
	}
	flagforcompinfo = 0;
}

// added comment by pradeep on 15 march 2011
// not in use getProfile method written below
- (void) getProfile {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		// Time Formats
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
		//dt = [[dt substringFromIndex:0] substringToIndex:19];
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
		//[collectionindustry stringByAppendingString:@","] stringByAppendingString:[interestedIndustryIds1 objectAtIndex:i]
	
		// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	gbluserid = [arrayForUserID objectAtIndex:0];
	
	NSLog(@"Sending....");
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&flag2=%@",@"getuserprofile",gbllatitude,gbllongitude,gbluserid,usertime,gbluserid];
	urlString = [globalUrlString stringByAppendingString:urlString];
	
	[self parseXMLFileAtURL:urlString];	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
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
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
		//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) {
			// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		userid = [[NSMutableString alloc] init];
		userdevicetocken= [[NSMutableString alloc] init];
		userlastuse = [[NSMutableString alloc] init];
		
		usercompany = [[NSMutableString alloc] init];
		userwebsite = [[NSMutableString alloc] init];
		userlinkedin = [[NSMutableString alloc] init];
		userind = [[NSMutableString alloc] init];
		userindid = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
		//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
			// save values to an item, then store that item into the array...
		[item setObject:userid forKey:@"guid"];
		[item setObject:userdevicetocken forKey:@"devicetocken"]; 
		[item setObject:userlastuse forKey:@"logindate"];
		[item setObject:usercompany forKey:@"company"];
		[item setObject:userwebsite forKey:@"userwebsite"];
		[item setObject:userlinkedin forKey:@"linkedinprofile"];
		[item setObject:userind forKey:@"industry"];
		[item setObject:userindid forKey:@"industryid"];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
		//NSLog(@"found characters: %@", string);
		// save the characters for the current item...
	if ([currentElement isEqualToString:@"guid"]) {
		[userid appendString:string];
	}else if ([currentElement isEqualToString:@"devicetocken"]) {
		[userdevicetocken appendString:string];
	}else if ([currentElement isEqualToString:@"logindate"]) {
		[userlastuse appendString:string];
	}else if ([currentElement isEqualToString:@"company"]) {
		[usercompany appendString:string];
	}else if ([currentElement isEqualToString:@"userwebsite"]) {
		[userwebsite appendString:string];
	}else if ([currentElement isEqualToString:@"linkedinprofile"]) {
		[userlinkedin appendString:string];
	}else if ([currentElement isEqualToString:@"industry"]) {
		[userind appendString:string];
	}else if ([currentElement isEqualToString:@"industryid"]) {
		[userindid appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {		
	NSLog(@"all done!");
	NSLog(@"stories array for activityviewforlauncher has %d items", [stories count]);
		//[itemTableView reloadData];
}

- (void) updateDataFile4CompanyInfo {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	newPerson.userid = self.userid;
	newPerson.usercompany = self.usercompany;
	newPerson.userwebsite = self.userwebsite;
	newPerson.userindustry = self.userind;
		//newPerson.userfunction = [[stories objectAtIndex:0] objectForKey:@"role"];
	
	newPerson.userindid = self.userindid;
		//newPerson.userroleid = [[stories objectAtIndex:0] objectForKey:@"roleid"];
	newPerson.userlinkedin = self.userlinkedin;
	
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial2"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];
	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];
	
	[theData writeToFile:path atomically:YES];
	[encoder release];
	
	if(aryCompanyInfo)
		[aryCompanyInfo removeAllObjects];
	else
		aryCompanyInfo = [[NSMutableArray alloc]init];
	
	if(usercompany == nil)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:self.usercompany];
	
	if(userwebsite == nil)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:self.userwebsite];
	
	if(userind == nil)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:self.userind];
	
	if(userfunction == nil)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:self.userfunction];
	
	if(userindid == nil)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:self.userindid];
	
	if(userroleid == nil)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:self.userroleid];
	
	if(userlinkedin == nil)
		[aryCompanyInfo addObject:@""];
	else [aryCompanyInfo addObject:self.userlinkedin];
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

#pragma mark cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = nil;
	NSInteger row = indexPath.section;
	static NSString *kSourceCell_ID = @"SourceCell_ID";
	cell = [tableView dequeueReusableCellWithIdentifier:kSourceCell_ID];
	
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCell_ID] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UILabel *lblControl = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(ktxtFieldsX, 0, 167, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	lblControl.text = [[self.dataSourceArray objectAtIndex: indexPath.section] valueForKey:kSourceKey];
	[cell.contentView addSubview:lblControl];
	
	UITextField *textField = [[self.dataSourceArray objectAtIndex: indexPath.section] valueForKey:kViewKey];
	[cell.contentView addSubview:textField];
	
	if(row == 3 || row == 2) {
		
		UIImageView *imghttp = [UnsocialAppDelegate createImageViewControl:CGRectMake(ktxtFieldsX, 18, 47, 30) imageName:@"urlhttp.png"];
		[cell.contentView addSubview:imghttp];
		/*UILabel *_lblhttp = [UnsocialAppDelegate createLabelControl:@"http://" frame:CGRectMake(ktxtFieldsX, txtWebsite.frame.origin.y, txtWebsite.frame.size.width, txtWebsite.frame.size.height) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize-1 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[cell.contentView addSubview:_lblhttp];*/
	}
	else if(row == 4) {
		
		UIButton *_btnIndustry = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(_btnIndustry_Click) frame:txtIndustry.frame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
		[cell.contentView addSubview:_btnIndustry];
	}
	else if(row == 5) {
		
		UIButton *_btnFunction = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(_btnFunction_Click) frame:txtFunction.frame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
		[cell.contentView addSubview:_btnFunction];
	}
	if(row < 6) {

		// commneted and added by pradeep on 3 august for fixing memory issue for retailed object i.e. without auto release
		//imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(ktxtFieldsX, 55, 260, 2) imageName:@"dashboardhorizontal.png"];
		imgHorSep = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(ktxtFieldsX, 55, 260, 2) imageName:@"dashboardhorizontal.png"];
		// end 3 august 2011
		
			//[cell.contentView addSubview:imgHorSep];
	}
	[tableView setSeparatorColor:[UIColor clearColor]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger rowHeight;
	rowHeight = 60;
	return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.dataSourceArray count];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	if (textField == txtPublicProfile) {
		
		self.navigationItem.rightBarButtonItem = nil;
		[self viewMoveToUpDown:-75];
	}
	
	else if (textField == txtWebsite) {
		
		self.navigationItem.rightBarButtonItem = nil;
		[self viewMoveToUpDown:-15];
	}
	[textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	if (textField == txtPublicProfile) {
		
		self.navigationItem.rightBarButtonItem = nil;
		[self viewMoveToUpDown:+75];
	}
	
	else if (textField == txtWebsite) {
		
		self.navigationItem.rightBarButtonItem = nil;
		[self viewMoveToUpDown:+15];
	}
	[textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[itemTableView reloadData];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	return YES;
}

- (void) viewMoveToUpDown:(NSInteger) yAxis {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	topImgHorSep.frame = CGRectMake(topImgHorSep.frame.origin.x, (topImgHorSep.frame.origin.y + yAxis), topImgHorSep.frame.size.width, topImgHorSep.frame.size.height);
	
	imgHorSep.frame = CGRectMake(imgHorSep.frame.origin.x, (imgHorSep.frame.origin.y + yAxis), imgHorSep.frame.size.width, imgHorSep.frame.size.height);
	
	loadingBack.frame = CGRectMake(loadingBack.frame.origin.x, (loadingBack.frame.origin.y + yAxis), loadingBack.frame.size.width, loadingBack.frame.size.height);
	
	itemTableView.frame = CGRectMake(itemTableView.frame.origin.x, itemTableView.frame.origin.y + yAxis, itemTableView.frame.size.width, itemTableView.frame.size.height);
	
	imgBack.frame = CGRectMake(imgBack.frame.origin.x, (imgBack.frame.origin.y + yAxis), imgBack.frame.size.width, imgBack.frame.size.height);
	
	heading.frame = CGRectMake(heading.frame.origin.x, (heading.frame.origin.y + yAxis), heading.frame.size.width, heading.frame.size.height);
	[UIView commitAnimations];
}

#pragma mark txtTitle

- (UITextField *)txtTitle {
	if (txtTitle == nil)
	{
		txtTitle = [UnsocialAppDelegate createTextFieldControl:CGRectMake(ktxtFieldsX, 18, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter your job title" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		[txtTitle setDelegate:self];
		txtTitle.backgroundColor = [UIColor clearColor];
		txtTitle.autocapitalizationType = UITextAutocapitalizationTypeNone;
		txtTitle.autocorrectionType = UITextAutocorrectionTypeNo;
			//[txtTitle setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return txtTitle;
}

#pragma mark txtCompany
- (UITextField *)txtCompany {
	if (txtCompany == nil)
	{
		txtCompany = [UnsocialAppDelegate createTextFieldControl:CGRectMake(ktxtFieldsX, 18, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter your company name" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		[txtCompany setDelegate:self];
		txtCompany.backgroundColor = [UIColor clearColor];
		txtCompany.autocapitalizationType = UITextAutocapitalizationTypeNone;
		txtCompany.autocorrectionType = UITextAutocorrectionTypeNo;
			//[txtCompany setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return txtCompany;
}

#pragma mark txtWebsite
- (UITextField *)txtWebsite {
	if (txtWebsite == nil)
	{
		txtWebsite = [UnsocialAppDelegate createTextFieldControl:CGRectMake(ktxtFieldsX + 40, 18, 220, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter your website" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeURL returnKey:UIReturnKeyDone];
		[txtWebsite setDelegate:self];
		txtWebsite.backgroundColor = [UIColor clearColor];
		txtWebsite.autocapitalizationType = UITextAutocapitalizationTypeNone;
		txtWebsite.autocorrectionType = UITextAutocorrectionTypeNo;
			//[txtWebsite setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return txtWebsite;
}

#pragma mark txtPublicProfile
- (UITextField *)txtPublicProfile {
	if (txtPublicProfile == nil)
	{
		txtPublicProfile = [UnsocialAppDelegate createTextFieldControl:CGRectMake(ktxtFieldsX + 40, 18, 220, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"LinkedIn, Plaxo" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeURL returnKey:UIReturnKeyDone];
		[txtPublicProfile setDelegate:self];
		txtPublicProfile.backgroundColor = [UIColor clearColor];
		txtPublicProfile.autocapitalizationType = UITextAutocapitalizationTypeNone;
		txtPublicProfile.autocorrectionType = UITextAutocorrectionTypeNo;
			//[txtPublicProfile setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return txtPublicProfile;
}

#pragma mark txtIndustry
- (UITextField *)txtIndustry {
	if (txtIndustry == nil)
	{
		txtIndustry = [UnsocialAppDelegate createTextFieldControl:CGRectMake(ktxtFieldsX, 18, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter your industry" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeEmailAddress returnKey:UIReturnKeyDone];
		[txtIndustry setDelegate:self];
		txtIndustry.backgroundColor = [UIColor clearColor];
		txtIndustry.autocapitalizationType = UITextAutocapitalizationTypeNone;
		txtIndustry.autocorrectionType = UITextAutocorrectionTypeNo;
			//[txtIndustry setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return txtIndustry;
}

#pragma mark txtFunction
- (UITextField *)txtFunction {
	if (txtFunction == nil)
	{
		txtFunction = [UnsocialAppDelegate createTextFieldControl:CGRectMake(ktxtFieldsX, 18, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter your function" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeEmailAddress returnKey:UIReturnKeyDone];
		[txtFunction setDelegate:self];
		txtFunction.backgroundColor = [UIColor clearColor];
		txtFunction.autocapitalizationType = UITextAutocapitalizationTypeNone;
		txtFunction.autocorrectionType = UITextAutocorrectionTypeNo;
			//[txtFunction setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return txtFunction;
}

#pragma mark FillBlank
- (UILabel *)FillBlank {
	if (FillBlank == nil)
	{
		FillBlank = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(ktxtFieldsX, 18, 260, 30) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor clearColor] backgroundcolor:[UIColor clearColor]];
		[FillBlank setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return FillBlank;
}

- (void)dealloc {
	
	// added by pradeep on 29 june 2011
	//itemTableView.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
	//[allInfo release];
	[aray1 release];
	[uv release];
}

@end