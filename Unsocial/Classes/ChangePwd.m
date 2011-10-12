//
//  SignIn.m
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "ChangePwd.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "Person.h"

#define klabelFontSize  13

@implementation ChangePwd
@synthesize userid;

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
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	[imgBack release];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"signinback.png"];
	[self.view addSubview:imgBack];
	[imgBack release];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//heading = [UnsocialAppDelegate createLabelControl:@"Change Password" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	heading = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Change Password" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	[self createControls];
}

- (void)createControls {
	
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object
	//imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 40, 300, 2) imageName:@"dashboardhorizontal.png"];
	imgHorSep = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(10, 40, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// end 3 august 2011
	[imgHorSep release];
	
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object
	//imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 107, 260, 2) imageName:@"dashboardhorizontal.png"];
	imgHorSep = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(30, 107, 260, 2) imageName:@"dashboardhorizontal.png"];
	// end 3 august 2011
	[self.view addSubview:imgHorSep];
	// end 3 august 2011
	[imgHorSep release];
	
	// commneted and added by pradeep on 3 august for fixing memory issue for retailed object
	//imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 174, 260, 2) imageName:@"dashboardhorizontal.png"];
	imgHorSep = [UnsocialAppDelegate createImageViewControlWithoutAutoRelease:CGRectMake(30, 174, 260, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	//[imgHorSep release]; // since below it is using added on 3 august 2011
	// end 3 august 2011
	
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//lblCurrPwd = [UnsocialAppDelegate createLabelControl:@"Current Password:" frame:CGRectMake(30, 45, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	lblCurrPwd = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Current Password:" frame:CGRectMake(30, 45, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:lblCurrPwd];
	
	txtCurrPwd = [UnsocialAppDelegate createTextFieldControl:CGRectMake(lblCurrPwd.frame.origin.x, lblCurrPwd.frame.origin.y + 25, lblCurrPwd.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter your current password" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyGo];
	txtCurrPwd.backgroundColor = [UIColor clearColor];
	txtCurrPwd.secureTextEntry = YES;
	[txtCurrPwd setDelegate:self];
	[self.view addSubview:txtCurrPwd];
	[txtCurrPwd becomeFirstResponder];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//lblNewPwd = [UnsocialAppDelegate createLabelControl:@"New Password:" frame:CGRectMake(lblCurrPwd.frame.origin.x, lblCurrPwd.frame.origin.y + 66, lblCurrPwd.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	lblNewPwd = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"New Password:" frame:CGRectMake(lblCurrPwd.frame.origin.x, lblCurrPwd.frame.origin.y + 66, lblCurrPwd.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011

	[self.view addSubview:lblNewPwd];
	
	txtNewPwd = [UnsocialAppDelegate createTextFieldControl:CGRectMake(lblCurrPwd.frame.origin.x, lblNewPwd.frame.origin.y + 25, lblCurrPwd.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter your new password" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeURL returnKey:UIReturnKeyGo];
	[txtNewPwd setDelegate:self];
	txtNewPwd.secureTextEntry = YES;
	txtNewPwd.backgroundColor = [UIColor clearColor];
	[self.view addSubview:txtNewPwd];
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//lblRePwd = [UnsocialAppDelegate createLabelControl:@"Re-type Password:" frame:CGRectMake(lblNewPwd.frame.origin.x, lblNewPwd.frame.origin.y + 66, lblCurrPwd.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	lblRePwd = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Re-type Password:" frame:CGRectMake(lblNewPwd.frame.origin.x, lblNewPwd.frame.origin.y + 66, lblCurrPwd.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:lblRePwd];
	
	txtRePwd = [UnsocialAppDelegate createTextFieldControl:CGRectMake(lblCurrPwd.frame.origin.x, lblRePwd.frame.origin.y + 25, lblRePwd.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"re-enter your new password" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyGo];
	[txtRePwd setDelegate:self];
	txtRePwd.secureTextEntry = YES;
	txtRePwd.backgroundColor = [UIColor clearColor];
	[self.view addSubview:txtRePwd];
	
	// 13 may 2011 by pradeep //[lblCurrPwd release];
	// 13 may 2011 by pradeep //[lblNewPwd release];
	// 13 may 2011 by pradeep //[lblRePwd release];
	[txtCurrPwd release];
	[txtNewPwd release];
	[txtRePwd release];
}

- (void) viewMovedUp:(NSInteger) yAxis {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	imgHorSep.frame = CGRectMake(imgHorSep.frame.origin.x, (imgHorSep.frame.origin.y + yAxis), imgHorSep.frame.size.width, imgHorSep.frame.size.height);
	
	imgBack.frame = CGRectMake(imgBack.frame.origin.x, (imgBack.frame.origin.y + yAxis), imgBack.frame.size.width, imgBack.frame.size.height);
	
	heading.frame = CGRectMake(heading.frame.origin.x, (heading.frame.origin.y + yAxis), heading.frame.size.width, heading.frame.size.height);
	
	lblCurrPwd.frame = CGRectMake(lblCurrPwd.frame.origin.x, (lblCurrPwd.frame.origin.y + yAxis), lblCurrPwd.frame.size.width, lblCurrPwd.frame.size.height);
	
	txtCurrPwd.frame = CGRectMake(txtCurrPwd.frame.origin.x, (txtCurrPwd.frame.origin.y + yAxis), txtCurrPwd.frame.size.width, txtCurrPwd.frame.size.height);
	
	lblNewPwd.frame = CGRectMake(lblNewPwd.frame.origin.x, (lblNewPwd.frame.origin.y + yAxis), lblNewPwd.frame.size.width, lblNewPwd.frame.size.height);
	
	txtNewPwd.frame = CGRectMake(txtNewPwd.frame.origin.x, (txtNewPwd.frame.origin.y + yAxis), txtNewPwd.frame.size.width, txtNewPwd.frame.size.height);
	
	lblRePwd.frame = CGRectMake(lblRePwd.frame.origin.x, (lblRePwd.frame.origin.y + yAxis), lblRePwd.frame.size.width, lblRePwd.frame.size.height);
	
	txtRePwd.frame = CGRectMake(txtRePwd.frame.origin.x, (txtRePwd.frame.origin.y + yAxis), txtRePwd.frame.size.width, txtRePwd.frame.size.height);
	[UIView commitAnimations];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {	
	
	if (textField == txtRePwd || textField == txtNewPwd) {
		
		[self viewMovedUp:-40];
	}
	//allInfo2 = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:txtPrefix.text, txtPersonName.text, txtPersonEmail.text, txtPersonContact.text, nil]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {	
	
	if (textField == txtRePwd || textField == txtNewPwd) {
		
		[self viewMovedUp:+40];
	}
}

- (void) rightbtn_OnClick {
	
	self.navigationItem.rightBarButtonItem = nil;
	[txtRePwd resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	NSString *_txtNewPwd = [txtNewPwd.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	NSString *_txtRePwd = [txtRePwd.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	NSString *_txtCurrPwd = [txtCurrPwd.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

	if([_txtNewPwd compare:_txtRePwd] != NSOrderedSame) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Password does not match." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		return NO;
	}
	if(([_txtCurrPwd compare:@""] == NSOrderedSame) ||([_txtNewPwd compare:@""] == NSOrderedSame) ||([_txtRePwd compare:@""] == NSOrderedSame)) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Fill the required fields." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		return NO;
	}
	[textField resignFirstResponder];
	
	BOOL pwdchange = [self sendRequest4ChangePwd:@"changepwd"];
	if(pwdchange) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Password changed." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		[self.navigationController popViewControllerAnimated:YES];
		return YES;
	}
	else {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Your current password is not correct." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];return NO;
		return NO;
	}
}

- (BOOL) sendRequest4ChangePwd: (NSString *) flag {
	
	
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
	NSString *struserid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];
	NSString *strpassword = [NSString stringWithFormat:@"%@\r\n",txtCurrPwd.text];
	NSString *strnewpassword = [NSString stringWithFormat:@"%@\r\n",txtNewPwd.text];
		
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
	//DEFAULT TERMS/////////////////////////////////////
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",struserid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"password\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strpassword] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"newpassword\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strnewpassword] dataUsingEncoding:NSUTF8StringEncoding]];
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
		if ([key isEqualToString:@"Passwordchanged"])			
		{
			printf("\n\n\n\n\n\n#######################-- Password changed successfully --#######################\n\n\n\n\n\n");
			
			successflg=YES;
			break;
		}
		else if ([key isEqualToString:@"Notsuccess"])
		{
			successflg=NO;
			break;
		}
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	return successflg;
	[pool release];
}
 

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

- (void)dealloc {
    [super dealloc];
}


@end
