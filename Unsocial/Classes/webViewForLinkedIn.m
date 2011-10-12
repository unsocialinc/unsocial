//
//  webViewForLinkedIn.m
//  Unsocial
//
//  Created by vaibhavsaran on 06/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "webViewForLinkedIn.h"
#import "GlobalVariables.h"
#import "Person.h"
#import "UnsocialAppDelegate.h"
#import "ActivityViewForLauncher.h"
#import "SettingsStep2.h"

@implementation webViewForLinkedIn
@synthesize webView, status, camefrom, arraySignIn;
@synthesize deviceTocken, deviceUDID, deviceType, ursprefix, urspassword, urslastlogindate, urslongitude, urslatitude, ursisallow, usrid, fname, lname, useremail, linkedInToken;

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	UIImageView	*imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 463)];
	imgBack.image = [UIImage imageNamed:@"signupback.png"];
	[self.view addSubview:imgBack];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	
	if([camefrom compare:@"UnsocialUpdateStatus"] == NSOrderedSame) {
		self.navigationItem.leftBarButtonItem = leftcbtnitme;
	}
	else {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	}
	//URL Requst Object	
	CGRect webFrame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	
	//CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	webView = [[UIWebView alloc] initWithFrame:webFrame];
	webView.opaque = NO;
	[webView setBackgroundColor:[UIColor clearColor]];
	webView.scalesPageToFit = YES;
	webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	webView.delegate = self;
	[self.view addSubview:webView];
}

- (void)createProgressionAlertWithMessage {
		// Create the progress bar and add it to the alert
	pactivityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(135, 75,20,20)];
	pactivityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	
	progressAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Page load is in progress\nplease standby" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[progressAlert show];
	
	[progressAlert addSubview:pactivityView];
	
	[pactivityView startAnimating];
	[progressAlert release];
}

- (void)viewDidAppear:(BOOL)animated {
	
	activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(240, 11, 20, 20)];
	activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[self.view addSubview:activityView];
	[activityView startAnimating];
	[super viewDidAppear:animated];
	activityView.hidden = YES;

	if([camefrom compare:@"UnsocialUpdateStatus"] == NSOrderedSame)
		status = [NSString stringWithFormat:@"&status=%@", status];
	else if([camefrom compare:@"UnsocialSignInLinkedIn"] == NSOrderedSame) {
		
		self.deviceTocken = [self.arraySignIn objectAtIndex:0];
		self.deviceUDID = [self.arraySignIn objectAtIndex:1];
		self.deviceType =[self.arraySignIn objectAtIndex:2];
		self.ursprefix = @"none";
		self.urspassword = @"LinkedIn";
		self.urslastlogindate = [self.arraySignIn objectAtIndex:8];
		self.urslongitude = [self.arraySignIn objectAtIndex:5];
		self.urslatitude  =[self.arraySignIn objectAtIndex:6];
		self.ursisallow =  [self.arraySignIn objectAtIndex:7];
		status = [NSString stringWithFormat:@"&devicetocken=%@&deviceid=%@&devicetype=%@&prefix=%@&userpassword=%@&lastlogindate=%@&longitude=%@&latitude=%@&isallownotification=%@", self.deviceTocken, self.deviceUDID, self.deviceType, self.ursprefix, self.urspassword, self.urslastlogindate, self.urslongitude, self.urslatitude, self.ursisallow];
	}
	else if([camefrom compare:@"UnsocialSendInvitation"] == NSOrderedSame) {
		
		self.fname = [self.arraySignIn objectAtIndex:0];
		self.lname = [self.arraySignIn objectAtIndex:1];
		self.useremail =[self.arraySignIn objectAtIndex:2];
		self.linkedInToken =[self.arraySignIn objectAtIndex:3];
		status = [NSString stringWithFormat:@"&email=%@&fname=%@&lname=%@&memberid=%@", self.useremail, self.fname, self.lname, self.linkedInToken];
	}
	else
		status = @"";
	
	//NSString *completeURL = [NSString stringWithFormat:@"http://rstrings.com/unsocial/%@.aspx?camefrom=%@%@",camefrom, camefrom, status];
	NSString *completeURL = [NSString stringWithFormat:@"%@/%@.aspx?camefrom=%@%@",globalUrlString, @"AccessLinkedIn", self.camefrom, self.status];
	NSLog(@"%@", completeURL);	
	NSURL *url = [NSURL URLWithString:completeURL];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];	
	[webView loadRequest:requestObj];
	[self.view addSubview:webView];

	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createProgressionAlertWithMessage) userInfo:self.view repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(removeProgressionAlert) userInfo:self.view repeats:NO];
}

- (void)removeProgressionAlert
{
	[progressAlert dismissWithClickedButtonIndex:0 animated:YES];
	[pactivityView stopAnimating];	
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 43)];
	[loadingView addSubview:activityView];
	
	imgHeadview.frame = CGRectMake(37, 6, 151, 31);
	imgHeadview.image = [UIImage imageNamed: @"headlogo.png"];
	[loadingView addSubview:imgHeadview];
	UINavigationItem *item1 = self.navigationItem;
	item1.titleView = loadingView;
	[activityView startAnimating];
	self.navigationItem.rightBarButtonItem = nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView1 {
	
		// finished loading, hide the activity indicator in the status bar
	[activityView stopAnimating];
	UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[rightbtn setImage:[UIImage imageNamed:@"linkedinlogo.png"] forState:(UIControlState) nil];
	UIBarButtonItem *rightcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
	itemNV.rightBarButtonItem = rightcbtnitme;
	itemNV.rightBarButtonItem.enabled = NO;
	
	doctitle = [webView1 stringByEvaluatingJavaScriptFromString:@"document.title"];
	NSLog(@"%@", doctitle);
	doctitle = [doctitle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSLog(@"%@", doctitle);
	doctitle = [doctitle stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	NSLog(@"%@", doctitle);
	if([camefrom compare:@"UnsocialSignInLinkedIn"] == NSOrderedSame)
	{
		
		arrayUseridFromWebview = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:doctitle, nil]];
		BOOL loginchk = [self sendUserLogingInfo:@"userlogincheck"];
		if(loginchk){
			
			BOOL flg = [self getLocationLock];
			
			if(!flg) { // yes app is locked for this location -vaibhav(v1.1)
				
				printf("User May logged in");
				[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(pushToActivity) userInfo:self.view repeats:NO];
			}
			else {
				
				printf("Location is invalid for this application");
				[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(pushToAppNot) userInfo:self.view repeats:NO];
			}
		}
	}
	else if([camefrom compare:@"UnsocialUpdateStatus"] == NSOrderedSame) {
		
		if([doctitle compare:@"statusupdate"] == NSOrderedSame)
			[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(popView) userInfo:self.view repeats:NO];
			//[self.navigationController popViewControllerAnimated:YES];
	}
	else if([camefrom compare:@"UnsocialCompanyInfo"] == NSOrderedSame) {
		
		if([doctitle compare:@"company_finished"] == NSOrderedSame) {
			
			SettingsStep2 *settingsStep2 = [[SettingsStep2 alloc]init];
			[self.navigationController pushViewController:settingsStep2 animated:NO];
			[settingsStep2 release];
				//[self.navigationController popViewControllerAnimated:YES];
			flagforcompinfo = 1;
		}
	}
	else if([camefrom compare:@"UnsocialSendInvitation"] == NSOrderedSame) {
		
		if([doctitle isEqualToString:@"invitation"]) {
			flagforcompinfo = 1;
			[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(popView) userInfo:self.view repeats:NO];
				//[self.navigationController popViewControllerAnimated:YES];
		}
		else if([doctitle isEqualToString:@"notinvited"]) {
			flagforcompinfo = 2;
			[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(popView) userInfo:self.view repeats:NO];
				//[self.navigationController popViewControllerAnimated:YES];
		}
		
	}
	else {
		
		if([doctitle compare:@"networkupdate"] == NSOrderedSame)
			[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(popToVC) userInfo:self.view repeats:NO];
			//[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
	}
	if([doctitle isEqualToString:@"User Agreement | LinkedIn"] || [doctitle isEqualToString:@"Sign In | LinkedIn"] || [doctitle isEqualToString:@"Join LinkedIn | LinkedIn"]){
		
		[webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 5.0;"];
	}
}

- (void) pushToActivity {
	
	ActivityViewForLauncher *activityViewForLauncher = [[ActivityViewForLauncher alloc]init];
	activityViewForLauncher.strFrom = [arrayForUserID objectAtIndex:0];
	[self.navigationController pushViewController:activityViewForLauncher animated:YES];
	[activityViewForLauncher release];
	
}

- (void) pushToAppNot {
	
	AppNotAvailable *ana = [[AppNotAvailable alloc]init];
	ana.stronlocation = @"Thanks for signing in, ";
	[self.navigationController pushViewController:ana animated:YES];
	[ana release];
}

- (void) popView {
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) popToVC {
	
	[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

#pragma mark location lock
- (BOOL) getLocationLock {
	NSLog(@"Sending 4 getLocationLock....");
		//NSData *imageData1;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"locationlock"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	/*UIDevice *myDevice = [UIDevice currentDevice];
	 NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	 NSString *deviceTocken;
	 if ([devTocken count] == 0)
	 deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	 else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	 
	 NSString *varuserid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];	
	 NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	 NSLog(@"%@", dt);
	 NSMutableArray *myArray = [[NSMutableArray alloc] init];
	 [myArray setArray:[dt componentsSeparatedByString:@" "]];	
	 NSString *userdatetime = [myArray objectAtIndex:0];
	 userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	 userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];*/
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"flag\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",flg1] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];			
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"flag2\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",flg2] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	/*[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"devicetocken\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	 [body appendData:[[NSString stringWithFormat:@"\r\n%@",deviceTocken] dataUsingEncoding:NSUTF8StringEncoding]];
	 [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	 
	 [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	 [body appendData:[[NSString stringWithFormat:@"\r\n%@",varuserid] dataUsingEncoding:NSUTF8StringEncoding]];
	 [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	 
	 [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	 [body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	 [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];*/
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
		// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
		// now lets make the connection to the web
		//we need an activity indicator here.	
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	BOOL retflg = FALSE;
	
		//[activityView startAnimating];
	
    NSHTTPURLResponse *response11;
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response11 error:nil];
	
	NSLog(@"response header: %@", [response11 allHeaderFields]);
	
	NSDictionary *dic = [response11 allHeaderFields];
		//BOOL successflg=NO;
	
	for (id key in dic)
	{
			// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Locationlock"])			
		{
			if ([[dic objectForKey:key] isEqualToString:@"yes"])
			{
				NSLog(@"\n\n\n\n\n\n#######################-- app is locked for this location --#######################\n\n\n\n\n\n");				
				retflg = TRUE;
				break;
			}
		}
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	[returnString release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
	[pool release];
	return retflg;
}

- (void)leftbtn_OnClick {
	
    webView.delegate = nil;
    [webView stopLoading];
    [webView release];
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) sendUserLogingInfo: (NSString *) flag {	
	
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
	//NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	NSString *deviceType = [NSString stringWithFormat:@"%@\r\n",@"iphone"];
	NSString *username = [NSString stringWithFormat:@"%@\r\n",[arrayUseridFromWebview objectAtIndex:0]];
	NSString *password = [NSString stringWithFormat:@"%@\r\n",@"linkedin"];
	
	//DEFAULT TERMS/////////////////////////////////////
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	[myArray release];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	NSString *allownotification = [NSString stringWithFormat:@"%@\r\n",@"0"];
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"devicetocken\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",deviceTocken] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// added by pradeep on 28 aug 2010 for persisting device type of user
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"devicetype\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",deviceType] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	//DEFAULT TERMS/////////////////////////////////////
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",username] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"password\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",password] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	//DEFAULT TERMS/////////////////////////////////////
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"isallownotification\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",allownotification] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	//DEFAULT TERMS/////////////////////////////////////
	
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	//we need an activity indicator here.	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
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
				printf("\n\n\n\n\n\n#######################-- User may logged in --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				NSString *userid = [dic objectForKey:key];
				arrayForUserID = [[NSMutableArray alloc]init];
				[arrayForUserID addObject:userid];
				
#pragma mark Setting lastVisitedFeature array as signup for not opening splash during LauncherViewTestController
				[lastVisitedFeature removeAllObjects];
				[lastVisitedFeature addObject:@"signinlinkedin"];
				
				/*TTURLMap* map = navigator.URLMap;
				 [map from:@"tt://launcherTest" toViewController:[LauncherViewTestController class]];
				 [navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://launcherTest"] applyAnimated:YES]];*/
				break;
			}
		}		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	[pool release];
	return successflg;
	
}

- (void) updateDataFileOnSave:(NSString *)uid {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	
	newPerson.userid = uid;
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"userlogininfo"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];	
	[theData writeToFile:path atomically:YES];
	[encoder release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {

	webView.delegate = nil;
    [webView stopLoading];
    [webView release];
    [super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
