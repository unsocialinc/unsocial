//
//  SignIn.m
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "Calendardesc.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "Person.h"

#define klabelFontSize  13

@implementation Calendardesc
@synthesize userid, caldesc, caltitle, calfrom, calto, caldate;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	[activityView stopAnimating];
	activityView.hidden = YES;
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
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	// added by pradeep on 1 june 2011 for returning to dashboard requirement
	
	UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(285.0, 0.0, 33, 30)];
	[rightbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[rightbtn addTarget:self action:@selector(rightbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
	itemNV.rightBarButtonItem = rightbtnitme;
	//rightbtn.hidden = YES;
	
	// end 1 june 2011
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	[imgBack release];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"signinback.png"];
	[self.view addSubview:imgBack];
	[imgBack release];
	
	UITextView *heading = [UnsocialAppDelegate createTextViewControl:caltitle frame:CGRectMake(15, 7, 290, 40) txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:kTextFieldFont returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	heading.contentInset = UIEdgeInsetsMake(-4.00, -8.00, 0.00, 0.00);
	[self.view addSubview:heading];
	[heading flashScrollIndicators];
	[heading release];
	
	/*btnSave = [UnsocialAppDelegate createButtonControl:@"Save" target:self selector:@selector(btnSave_Click) frame:CGRectMake(128, 380, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSave];*/
	
	btnSave = [UnsocialAppDelegate createButtonControl:@"Save to calendar" target:self selector:@selector(btnSave_Click) frame:CGRectMake(60, 385, 200, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnSave.titleLabel setFont:[UIFont fontWithName:kAppFontName size:11.5]];
	[self.view addSubview:btnSave];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	[self createControls];
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
- (void)rightbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"poll"];
	[self dismissModalViewControllerAnimated:YES];
}
// end 1 june 2011

-(void)btnSave_Click{
	
	/*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
	
	[dateFormatter release];*/

	/*NSString *usertime = [[caldate stringByAppendingString:[@", " stringByAppendingString:calfrom]] stringByAppendingString:calto];
	NSLog(usertime);*/
	
	//**********
	// version check
	NSString *os_verson = [[UIDevice currentDevice] systemVersion];
	NSLog(@"%@", os_verson);
	float os_versionflt = [os_verson floatValue];
	
	// open an alert with two custom buttons
	//UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
	//deviceString=[h platformString];
	//NSLog(@"%@", deviceString);

	if (os_versionflt >= 4) 
	{

	NSString *calfromdate, *caltodate;
	EKEventStore *eventStore = [[EKEventStore alloc] init];
	
	EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
	event.title     = caltitle; //@"EVENT TITLE";
	
	NSString *dateStrfrom = [caldate stringByAppendingString:[@" " stringByAppendingString:calfrom]];
	NSLog(@"%@", dateStrfrom);
	// Convert string to date object
	NSDateFormatter *dateFormatfrom = [[NSDateFormatter alloc] init];
	[dateFormatfrom setDateFormat:@"MM/dd/yyyy hh:mm a"];
	NSDate *datefrom = [dateFormatfrom dateFromString:dateStrfrom];	
	[dateFormatfrom setDateFormat:@"LLL dd yyyy hh:mm a"];
	dateStrfrom = [dateFormatfrom stringFromDate:datefrom];
	datefrom = [dateFormatfrom dateFromString:dateStrfrom];
	
	NSString *dateStrto = [caldate stringByAppendingString:[@" " stringByAppendingString:calto]];
	NSLog(@"%@", dateStrto);
	NSDateFormatter *dateFormatto = [[NSDateFormatter alloc] init];
	[dateFormatto setDateFormat:@"MM/dd/yyyy hh:mm a"];
	NSDate *dateto = [dateFormatto dateFromString:dateStrto];	
	[dateFormatto setDateFormat:@"LLL dd yyyy hh:mm a"];
	dateStrto = [dateFormatfrom stringFromDate:dateto];
	dateto = [dateFormatto dateFromString:dateStrto];
	
	//NSLog(@"%@", datefrom);
	//NSLog(@"%@", dateto);
	
	//NSLog(@"%@", @"%@", [dateFormat stringFromDate:datefrom]);
	event.startDate = datefrom;//[NSDate date];
	event.endDate   = dateto;//[[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
	
	[event setCalendar:[eventStore defaultCalendarForNewEvents]];
	NSError *err;
	[eventStore saveEvent:event span:EKSpanThisEvent error:&err];
	
	UIAlertView *savealert = [[UIAlertView alloc]initWithTitle:nil message:@"Item saved to your Calendar." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[savealert show];
	[savealert release];
	}
	else {
		
		UIAlertView *savealert = [[UIAlertView alloc]initWithTitle:nil message:@"Feature is not available on your iPhone." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
		[savealert show];
		[savealert release];
	}

}

- (void)createControls {
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 48, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	UILabel *lblDate = [UnsocialAppDelegate createLabelControl:[@"Date- " stringByAppendingString:caldate] frame:CGRectMake(15, 45, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblDate];
	// 13 may 2011 by pradeep //[lblDate release];
	
	UILabel *lblFrom = [UnsocialAppDelegate createLabelControl:[@"From- " stringByAppendingString:calfrom] frame:CGRectMake(15, 60, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblFrom];
	// 13 may 2011 by pradeep //[lblFrom release];
	
	UILabel *lblTo = [UnsocialAppDelegate createLabelControl:[@"To- " stringByAppendingString:calto] frame:CGRectMake(120, 60, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblTo];
	// 13 may 2011 by pradeep //[lblTo release];
	
	UILabel *lblDesc = [UnsocialAppDelegate createLabelControl:@"Detail:" frame:CGRectMake(15, 80, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kTextFieldFont txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblDesc];
	// 13 may 2011 by pradeep //[lblDesc release];
	
	UITextView *featuredesc = [UnsocialAppDelegate createTextViewControl:caldesc frame:CGRectMake(15, 105, 290, 250)  txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:kTextFieldFont returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	featuredesc.backgroundColor = [UIColor clearColor];
	//featuredesc.userInteractionEnabled = FALSE;
	featuredesc.contentInset = UIEdgeInsetsMake(-4, -8, 0, 0);
	[self.view addSubview:featuredesc];
	NSLog(@"Name: %@", featuredesc.text);
	[featuredesc flashScrollIndicators];
	[featuredesc release];
}

/*- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	//    [textField resignFirstResponder];
	printf("Clearing Keyboard\n");
	if(([txtUsername.text compare:@""] == NSOrderedSame)){
			
		UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the required fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[showAlert show];
		[showAlert release];
		return NO;
	}
	else {
		
		if(![UnsocialAppDelegate checkInternet:@"http://www.google.com"]) {
			
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:@"Error during request for forgot password. Your internet connection may be down" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];			
			
			return NO;
		}
		
		BOOL loginchk = [self sendRequest4ForgotPwd:@"forgotpassword"];
		if(loginchk)
		{
			UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Your credentials have been sent to you by email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[showAlert show];
			[showAlert release];
			//[txtUsername becomeFirstResponder];
			txtUsername.text = @"";			
			[self dismissModalViewControllerAnimated:YES];
			return YES;
		}
		else
		{
			UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"We could not found this email account in our database, please provide a registered email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[showAlert show];
			[showAlert release];
			return NO;
		}
	}
	//[textField resignFirstResponder];
	printf("Clearing Keyboard\n");	
	return YES;
}*/

/*- (BOOL) sendRequest4ForgotPwd: (NSString *) flag {
	
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",flag];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	NSString *username = [NSString stringWithFormat:@"%@\r\n",txtUsername.text];
		
	//DEFAULT TERMS/////////////////////////////////////
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	NSString *allownotification = [NSString stringWithFormat:@"%@\r\n",@"0"];
	
	//now lets create the body of the post
	
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
	//DEFAULT TERMS/////////////////////////////////////
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",username] dataUsingEncoding:NSUTF8StringEncoding]];
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
		if ([key compare:@"Mailsent"] == NSOrderedSame)			
		{
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				//[self updateDataFileOnSave:[dic objectForKey:key]];
				printf("\n\n\n\n\n\n#######################-- Mail sent for forgot pwd --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				//UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"your credentials have been sent to you by email" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				//[showAlert show];
				//[showAlert release];
				break;
			}
		}
		else if ([key compare:@"Notsuccess"] == NSOrderedSame)
		{
			successflg=NO;
			//UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"We did not find this email account in our database, please provide a registered email address" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			//[showAlert show];
			//[showAlert release];
			break;
		}
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	return successflg;
	[pool release];
}*/


- (void)leftbtn_OnClick {
	
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	printf("Did begin editing\n");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	printf("Did end editing\n");
}

- (void)dealloc {
    [super dealloc];
}


@end
