//
//  SignIn.m
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "LauncherViewTestController.h"
#import "SignIn.h"
#import "SignUp.h"
#import "Settings.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "UIDeviceHardware.h"
#import "Person.h"
#import "webViewForLinkedIn.h"
#import "ForgetPwd.h"

#define klabelFontSize  13

UITextField *txtUsername, *txtPassword;
@implementation SignIn
@synthesize userid;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	[activityView stopAnimating];
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
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];

	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"signinback.png"];
	[self.view addSubview:imgBack];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Login" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)rightbtn_OnClick {
	
	[self resignAll];
}

- (void)createControls {
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 40, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 107, 260, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 174, 260, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue	
		
	UILabel *lblUsername = [UnsocialAppDelegate createLabelControl:@"Username:" frame:CGRectMake(30, 45, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblUsername];
	
	txtUsername = [UnsocialAppDelegate createTextFieldControl:CGRectMake(lblUsername.frame.origin.x, lblUsername.frame.origin.y + 25, lblUsername.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter email"  backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeEmailAddress returnKey:UIReturnKeyDone];
	[txtUsername setDelegate:self];
	txtUsername.autocapitalizationType = UITextAutocapitalizationTypeNone;
	txtUsername.autocorrectionType = UITextAutocorrectionTypeNo;
	txtUsername.backgroundColor = [UIColor clearColor];
	txtUsername.returnKeyType = UIReturnKeyGo;
		//if(loginmailid)
		//txtUsername.text = loginmailid;
	[self.view addSubview:txtUsername];
	
	UILabel *lblPassword = [UnsocialAppDelegate createLabelControl:@"Password:" frame:CGRectMake(lblUsername.frame.origin.x, lblUsername.frame.origin.y + 66, lblUsername.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblPassword];
	
	txtPassword = [UnsocialAppDelegate createTextFieldControl:CGRectMake(lblPassword.frame.origin.x, lblPassword.frame.origin.y + 25, lblPassword.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"password"  backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
	[txtPassword setDelegate:self];
	txtPassword.returnKeyType = UIReturnKeyGo;
	txtPassword.secureTextEntry = YES;
	txtPassword.backgroundColor = [UIColor clearColor];
	[self.view addSubview:txtPassword];
	
	// for adding TT's navigation controller for website
	TTNavigator *navigator = [TTNavigator  navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	TTURLMap *map = navigator.URLMap;
	[map from:@"*" toViewController:[TTWebController class]];
	
	UILabel *lblSignUp = [[UILabel alloc]initWithFrame:CGRectMake(lblUsername.frame.origin.x, 175, 300, 20)];
	lblSignUp.text = @"Forgot password?";
	[lblSignUp setTextColor:[UIColor whiteColor]];
	[lblSignUp setFont:[UIFont fontWithName:kAppFontName size:klabelFontSize]];
	[lblSignUp setFont:[UIFont boldSystemFontOfSize:klabelFontSize]];
	[lblSignUp setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:lblSignUp];
	
	UIButton *btnforGot = [UnsocialAppDelegate createButtonControl:@"Click Here" target:self selector:@selector(btnforGot_Click) frame:CGRectMake(lblUsername.frame.origin.x + 120, 175, 300, 20) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnforGot.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[btnforGot.titleLabel setFont:[UIFont boldSystemFontOfSize:klabelFontSize]];
	[self.view addSubview:btnforGot];

	/*
	NSString* strWebsite =  @"<a href=\"tt://forgetpwd\">Click Here</a>";	
	TTStyledTextLabel* lblTTWebsite = [[[TTStyledTextLabel alloc] initWithFrame:CGRectMake(lblUsername.frame.origin.x + 120, 177, 300, 25)] autorelease];
	[lblTTWebsite setFont:[UIFont fontWithName:kAppFontName size:klabelFontSize]];
	lblTTWebsite.backgroundColor = [UIColor clearColor];
	lblTTWebsite.text = [TTStyledText textFromXHTML:strWebsite lineBreaks:YES URLs:YES];
	lblTTWebsite.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[lblTTWebsite sizeToFit];
	[self.view addSubview:lblTTWebsite];*/
	[btnforGot release];
	// 13 may 2011 by pradeep //[lblUsername release];
	
	lblLinkedIn = [[UILabel alloc]initWithFrame:CGRectMake(30, 225, 150, 35)];
	lblLinkedIn.text = @"Login using Linked";
	[lblLinkedIn setTextColor:[UIColor whiteColor]];
	[lblLinkedIn setFont:[UIFont fontWithName:kAppFontName size:klabelFontSize]];
	[lblLinkedIn setFont:[UIFont boldSystemFontOfSize:klabelFontSize]];
	[lblLinkedIn setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:lblLinkedIn];
	[lblLinkedIn release];
	
	btnLinkedIn = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnLinkedIn_Click) frame:CGRectMake(163, 225, 35, 35) imageStateNormal:@"linkedinlogo.png" imageStateHighlighted:@"linkedinlogo2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnLinkedIn];
}

- (void) btnforGot_Click {

	[self resignAll];
	ForgetPwd *forgetPwd = [[ForgetPwd alloc]init];
	
	if(txtUsername.text)
		forgetPwd.useremail = txtUsername.text;
	else
		forgetPwd.useremail = @"";

	forgetPwd.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[[self navigationController] presentModalViewController:forgetPwd animated:YES];
	[forgetPwd release];
}

- (void) btnLinkedIn_Click {
	
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
	
	NSArray *arraySignIn = [[NSArray alloc] initWithObjects:deviceTocken, deviceUDID, deviceType, @"", @"LinkedIn", strlongitude, strlatitude, allownotification, userdatetime, nil];
	
	webViewForLinkedIn *wvli = [[webViewForLinkedIn alloc]init];
	wvli.camefrom = @"UnsocialSignInLinkedIn";
	wvli.arraySignIn = arraySignIn;
	[self.navigationController pushViewController:wvli animated:YES];
	[wvli release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	//    [textField resignFirstResponder];
	printf("Clearing Keyboard\n");
	if(([txtUsername.text compare:@""] == NSOrderedSame) || ([txtPassword.text compare:@""] == NSOrderedSame)){
			
		UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the required fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[showAlert show];
		[showAlert release];
		return NO;
	}
	else {
		
		if(![UnsocialAppDelegate checkInternet:@"http://www.google.com"]) {
			
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:@"Error during sign in. Your internet connection may be down." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
						
			return NO;
		}
		if([txtUsername.text length] > 80) {
			
			UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"E-Mail is too long to accept." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			[alertView show];
			[alertView release];
			return NO;
		}
		if([txtPassword.text length] > 80) {
			
			UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Password can't be more than 80 characters." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			[alertView show];
			[alertView release];
			return NO;
		}
		BOOL loginchk = [self sendUserLogingInfo:@"userlogincheck"];
		if(!loginchk) {
			UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"username/password incorrect." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[showAlert show];
			[showAlert release];
			return NO;
		}
		else {
			
			if(checklocation == 1) {
				
				AppNotAvailable *ana = [[AppNotAvailable alloc]init];
				ana.stronlocation = @"Thanks for signing in, ";
				[self.navigationController pushViewController:ana animated:YES];
				[ana release];
			}
			else {
				
				TTNavigator* navigator = [TTNavigator navigator];
				navigator.supportsShakeToReload = YES;
				navigator.persistenceMode = TTNavigatorPersistenceModeAll;
				TTURLMap* map = navigator.URLMap;
				[map from:@"tt://launcherTest" toViewController:[LauncherViewTestController class]];
				[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://launcherTest"] applyAnimated:YES]];
			}
		}

	}
	[textField resignFirstResponder];
	printf("Clearing Keyboard\n");
	return YES;
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
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	NSString *deviceType = [NSString stringWithFormat:@"%@\r\n",@"iphone"];
	NSString *username = [NSString stringWithFormat:@"%@\r\n",txtUsername.text];
	NSString *password = [NSString stringWithFormat:@"%@\r\n",txtPassword.text];
	
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
				printf("\n\n\n\n\n\n#######################-- User may logged in --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				userid = [dic objectForKey:key];
				arrayForUserID = [[NSMutableArray alloc]init];
				[arrayForUserID addObject:userid];
				//[allInfoNewUser release];
				[allInfoNewUser removeAllObjects];
				[capturedImageNewUser release];
#pragma mark Setting lastVisitedFeature array as signup for not opening splash during LauncherViewTestController
				[lastVisitedFeature removeAllObjects];
				[lastVisitedFeature addObject:@"signin"];
				
				/*TTURLMap* map = navigator.URLMap;
				[map from:@"tt://launcherTest" toViewController:[LauncherViewTestController class]];
				[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://launcherTest"] applyAnimated:YES]];*/
				break;
			}
		}		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
	return successflg;
	
}

- (void) resignAll {
	
	self.navigationItem.rightBarButtonItem = nil;
	[txtUsername resignFirstResponder];
	[txtPassword resignFirstResponder];
}

- (void)leftbtn_OnClick {
	
	[UnsocialAppDelegate playClick];
	// added by pradeep on 7 august 2010
	[lastVisitedFeature removeAllObjects];
	[lastVisitedFeature addObject:@"welcome"];
	[self.navigationController popViewControllerAnimated:YES];
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) viewMovedUp:(NSInteger) yAxis {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	lblLinkedIn.frame = CGRectMake(140, yAxis, lblLinkedIn.frame.size.width, lblLinkedIn.frame.size.height);
	btnLinkedIn.frame = CGRectMake(280, yAxis, btnLinkedIn.frame.size.width, btnLinkedIn.frame.size.height);
	
	[UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	printf("Did begin editing\n");
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(rightbtn_OnClick)] autorelease];
		//	[self viewMovedUp:7];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	printf("Did end editing\n");
}

- (void)dealloc {
    [super dealloc];
	[txtPassword release];
	[txtUsername release];
}


@end
