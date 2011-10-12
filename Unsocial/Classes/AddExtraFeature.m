//
//  AddExtraFeature.m
//  unsocial
//
//  Created by vaibhavsaran on 20/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddExtraFeature.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"

#define klabelFontSize  13
@implementation AddExtraFeature

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
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
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	self.navigationItem.leftBarButtonItem = leftcbtnitme;
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];	
	
	UIImageView *imgProfileBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 320, 359)];
	imgProfileBack.image = [UIImage imageNamed:@"peopleprofileback.png"];
	[self.view addSubview:imgProfileBack];
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"Saving\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];*/
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	//[activityView startAnimating];
}

- (void) createControls
{
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Add Icons" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 42, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 80, 260, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 162, 260, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	UILabel *lbl1 = [UnsocialAppDelegate createLabelControl:@"Your unsocial miles:" frame:CGRectMake(30, 100, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lbl1];
	
	switchCtl1 = [[UISwitch alloc] initWithFrame:CGRectMake(lbl1.frame.origin.x, lbl1.frame.origin.y + 25, lbl1.frame.size.width, 30)];
	[switchCtl1 addTarget:self action:@selector(takeAction1:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:switchCtl1];
	if ([[aryIsLiveNowEventsExist objectAtIndex:1] isEqualToString:@"1"])
		switchCtl1.on = YES;
	else switchCtl1.on = NO;
	[switchCtl1 release];
	
	UILabel *lbl2 = [UnsocialAppDelegate createLabelControl:@"Live Now Events:" frame:CGRectMake(lbl1.frame.origin.x, lbl1.frame.origin.y + 66, lbl1.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lbl2];
	
	switchCtl2 = [[UISwitch alloc] initWithFrame:CGRectMake(lbl1.frame.origin.x, lbl2.frame.origin.y + 25, lbl1.frame.size.width, 30)];
	[switchCtl2 addTarget:self action:@selector(takeAction2:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:switchCtl2];
	if ([[aryIsLiveNowEventsExist objectAtIndex:2] isEqualToString:@"1"])
		switchCtl2.on = YES;
	else switchCtl2.on = NO;
	switchCtl2.hidden = TRUE;
	[switchCtl2 release];
	
	UILabel *subHeading = [UnsocialAppDelegate createLabelControl:@"You can add following quick launch icons to your springboard" frame:CGRectMake(30, 44, 260, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:subHeading];
	// 13 may 2011 by pradeep //[subHeading release];
	
	UIButton *btnUN = [UnsocialAppDelegate createButtonControl:@"?" target:self selector:@selector(btnUN_Click) frame:CGRectMake(280, 100, 29, 20) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];	
	[self.view addSubview:btnUN];
	[btnUN.titleLabel setFont:[UIFont boldSystemFontOfSize:klabelFontSize]];
	[btnUN release];
	
	UIButton *btnLN = [UnsocialAppDelegate createButtonControl:@"?" target:self selector:@selector(btnLN_Click) frame:CGRectMake(280, 166, 29, 20) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
	[btnLN.titleLabel setFont:[UIFont boldSystemFontOfSize:klabelFontSize]];
	[self.view addSubview:btnLN];
	[btnLN release];
	
	/*btnSave = [UnsocialAppDelegate createButtonControl:@"Save" target:self selector:@selector(btnSave_Click) frame:CGRectMake(128, 380, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];	
	[self.view addSubview:btnSave];
	[btnSave release];*/
	
	NSString *flg4livenowdisplay = [aryIsLiveNowEventsExist objectAtIndex:0];
	if ([flg4livenowdisplay compare:@"yes"] == NSOrderedSame)
	{
		switchCtl2.hidden = NO;
		lbl2.hidden = NO;
		btnLN.hidden = NO;
	}
	else {
		switchCtl2.hidden = YES;
		lbl2.hidden = YES;
		btnLN.hidden = YES;
	}

}

- (void)btnUN_Click {
	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn unsocial miles ON to have an icon on your home page. Using miles icon you will be able to view – what are unsocial miles, how to earn them and your current unsocial miles." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}


- (void)btnLN_Click {
	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn Live now ON to have an icon on your home page. Using “live now” icon you will be able to view special live events in your proximity." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

- (void)takeAction1:(id)sender {
	
	if([sender isOn])
	{
		NSLog(@"Display unsocial miles on spring board");
		//btnSave.enabled = TRUE;
	}
	else 
	{
		NSLog(@"Don't Display unsocial miles on spring board");
		//btnSave.enabled = FALSE;
	}
}
- (void)takeAction2:(id)sender {
	
	if([sender isOn])
	{
		NSLog(@"Display Live Now on spring board");
		//btnSave.enabled = TRUE;
	}
	else 
	{
		NSLog(@"Don't Display Live Now on spring board");
		//btnSave.enabled = FALSE;
	}
}

- (void)btnSave_Click {	
	
	[self.view addSubview:imgBack];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Saving\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	loading.hidden = NO;
	[activityView startAnimating];
	
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
	
}

- (void)startProcess
{
	NSString *featureValue;
	
	if(switchCtl1.on == YES)
		featureValue = @"1";
	else featureValue = @"0";
	// for other features if added in future commented by pradeep on 21 July 2010
	if (switchCtl2.on == YES)
		featureValue = [featureValue stringByAppendingString:@"1"];
	else featureValue = [featureValue stringByAppendingString:@"0"];
	
	[self sendReq4AddExtraFeature:featureValue :@""]; // sending request for updating useraddextrafeature
	
	//NSLog(featureValue);
	
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)sendReq4AddExtraFeature:(NSString *)featurevalue:(NSString *)futureflg {
	
	NSLog(@"Sending....");
	
	// setting up the URL to post to	
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];	
	
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSString *flag = [NSString stringWithFormat:@"%@\r\n",@"useraddextrafeature"];
	
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	NSString *featureValue = [NSString stringWithFormat:@"%@\r\n",featurevalue];
	
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	NSString *allownotification = [NSString stringWithFormat:@"%@\r\n",@"0"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];		
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"flag\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",flag] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"addfeaturevalue\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",featureValue] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
			
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"isallownotification\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",allownotification] dataUsingEncoding:NSUTF8StringEncoding]];
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
			//userid = [dic objectForKey:key];
			
			if (![[dic objectForKey:key] isEqualToString:@""])
			{				
				NSLog(@"\n\n\n\n\n\n#######################-- post for addextrafeaturevalue added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				//localuserid = [dic objectForKey:key];
				[lastVisitedFeature removeAllObjects];
				[lastVisitedFeature addObject:@"addextrafeature"];
				break;
			}			
		}
		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"", returnString);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

- (void)leftbtn_OnClick{
	
	[self dismissModalViewControllerAnimated:YES];
	[self btnSave_Click];
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
