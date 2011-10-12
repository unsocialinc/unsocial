//
//  SignIn.m
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "ForgetPwd.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "Person.h"

int flgisvalidmail = 0;

#define klabelFontSize  13

@implementation ForgetPwd
@synthesize userid, useremail;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	[activityView stopAnimating];
	activityView.hidden = YES;
	[self createControls];
}

- (void)viewDidLoad {
	
	NSLog(@"VC ForgetPwd will appear");

	UIButton *btnSelect = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(leftbtn_OnClick) frame:CGRectMake(0, 0, 43, 43) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnSelect];
	[btnSelect release];

	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 + 43, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	[imgBack release];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 + 43, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"signinback.png"];
	[self.view addSubview:imgBack];
	[imgBack release];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Forgot Password" frame:CGRectMake(15, 0 + 44, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	UIImageView *topBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navbarwithprev.png"]];
	topBg.frame = CGRectMake(0, 0, 321, 43);
	[self.view addSubview:topBg];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180 + 43, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 40 + 43, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 107 + 43, 260, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	UILabel *lblUsername = [UnsocialAppDelegate createLabelControl:@"Username:" frame:CGRectMake(30, 45 + 44, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblUsername];
	
	txtUsername = [UnsocialAppDelegate createTextFieldControl:CGRectMake(lblUsername.frame.origin.x, lblUsername.frame.origin.y + 25, lblUsername.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter email"  backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeEmailAddress returnKey:UIReturnKeyDone];

	txtUsername.text = useremail;
	[txtUsername setDelegate:self];
	txtUsername.autocorrectionType = UITextAutocorrectionTypeNo;
	txtUsername.backgroundColor = [UIColor clearColor];
	txtUsername.returnKeyType = UIReturnKeyGo;
	
	// added by pradeep on 3 june 2011 for appearing keyboard if textbox is not blank
	if ([txtUsername.text compare:@""] != NSOrderedSame)
		[txtUsername becomeFirstResponder];
	// end 3 june 2011
	
	[self.view addSubview:txtUsername];
}

	//*********** added by pradeep on 14 feb

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
	if (flgisvalidmail==1)
	{
				
		[txtUsername resignFirstResponder];
		loginmailid = txtUsername.text;
		[self dismissModalViewControllerAnimated:YES];
	}
	/*else {
		
	}*/

}
	//********* end 14 feb 2011

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	//    [textField resignFirstResponder];
	printf("Clearing Keyboard\n");
	if(([txtUsername.text compare:@""] == NSOrderedSame)){
			
		UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the required fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[showAlert show];
		[showAlert release];
		return NO;
	}
	else {
		
		BOOL loginchk = [self sendRequest4ForgotPwd:@"forgotpassword"];
		if(loginchk)
		{
			UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Your credentials have been sent to you by email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[showAlert show];
			[showAlert release];
			txtUsername.text = @"";
			loginmailid = txtUsername.text;
			flgisvalidmail = 1;
				// commented by pradeep on 14 feb 2011
				//[self dismissModalViewControllerAnimated:YES];
			return YES;
		}
		else
		{
			UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"We could not find this email account in our database, please provide a registered email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[showAlert show];
			[showAlert release];
			txtUsername.text = @"";
			flgisvalidmail = 0;
			return NO;
		}
	}
	printf("Clearing Keyboard\n");	
	return YES;
}

- (BOOL) sendRequest4ForgotPwd: (NSString *) flag {
	
	
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
		if ([key isEqualToString:@"Mailsent"])			
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
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
		else if ([key isEqualToString:@"Notsuccess"])
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
}

- (void)leftbtn_OnClick {
	
	loginmailid = @"";//txtUsername.text;
	[txtUsername resignFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
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
