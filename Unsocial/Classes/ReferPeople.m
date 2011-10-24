//
//  SignIn.m
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "ReferPeople.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "Person.h"

#define klabelFontSize  13
@implementation ReferPeople
@synthesize userid, eventid, referralemail, referralphone, referraltags, referralname;

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
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"signinback.png"];
	[self.view addSubview:imgBack];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Refer" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	[self createControls];
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
	
	UILabel *lblUsername = [UnsocialAppDelegate createLabelControl:@"E-Mail Address:" frame:CGRectMake(30, 45, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblUsername];
	// 13 may 2011 by pradeep //[lblUsername release];
	
	if(!txtUseremail) {
		
	txtUseremail = [UnsocialAppDelegate createTextFieldControl:CGRectMake(lblUsername.frame.origin.x, lblUsername.frame.origin.y + 25, lblUsername.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter email seperated by ;" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeAlphabet returnKey:UIReturnKeyDone];
	[txtUseremail setDelegate:self];
	txtUseremail.autocorrectionType = UITextAutocorrectionTypeNo;
	txtUseremail.backgroundColor = [UIColor clearColor];
	txtUseremail.returnKeyType = UIReturnKeyGo;
	}
	[self.view addSubview:txtUseremail];
	
		// added by pradeep on 22 nov 2010 for "+" btn for invite feature
		//****************************
	
	UIButton *btnPlus = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(getContact) frame:CGRectMake(lblUsername.frame.size.width+30, lblUsername.frame.origin.y + 29, 20, 20) imageStateNormal:@"button_plus_contacts.png" imageStateHighlighted:@"button_plus_contacts.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnPlus.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	[self.view addSubview:btnPlus];
	
		//***************************
	
	lblUsername = [UnsocialAppDelegate createLabelControl:@"Name:" frame:CGRectMake(lblUsername.frame.origin.x, lblUsername.frame.origin.y + 66, lblUsername.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblUsername];
	// 13 may 2011 by pradeep //[lblUsername release];
	
	if(!txtUsername) {
		
	txtUsername = [UnsocialAppDelegate createTextFieldControl:CGRectMake(lblUsername.frame.origin.x, lblUsername.frame.origin.y + 25, lblUsername.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter name seperated by ;"  backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeAlphabet returnKey:UIReturnKeyDone];
	[txtUsername setDelegate:self];
	txtUsername.autocorrectionType = UITextAutocorrectionTypeNo;
	txtUsername.backgroundColor = [UIColor clearColor];
	txtUsername.returnKeyType = UIReturnKeyGo;
	}
	[self.view addSubview:txtUsername];
}

-(void)getContact {
		// creating the picker
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
		// place the delegate of the picker to the controll
	
	picker.peoplePickerDelegate = self;
	NSArray *na = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]];
		//[picker setDisplayedProperties:na];
	[picker setDisplayedProperties:na];
	
		//get access to the recordview controller
	
	
	
		// showing the picker
	[self presentModalViewController:picker animated:YES];
		// releasing
	[picker release];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {

	[self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	
	return YES;
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	
	ABMultiValueRef emails = ABRecordCopyValue(person, property);

	NSString *firstName;
	NSString *surname;
	firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	if (firstName == nil)
		firstName = @"";

	surname = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	if (surname == nil)		
		surname = @"";
	
	NSString *names = [firstName stringByAppendingString:surname];
	
	
		//now add to the text
	NSMutableString *emailList = [NSMutableString new];
	if (txtUseremail.text) 
	{
		if ([txtUseremail.text compare:@""] != NSOrderedSame)
		{
			[emailList appendString:txtUseremail.text];
			[emailList appendString:@"; "];
		}
	}
	[emailList appendString:(NSString*)ABMultiValueCopyValueAtIndex(emails, identifier)];
	
	txtUseremail.text = emailList;

		//*********** for name
	
	NSMutableString *nameList = [NSMutableString new];
	if (txtUsername.text) 
	{ 
		if ([txtUsername.text compare:@""] != NSOrderedSame)
		{
			[nameList appendString:txtUsername.text];
			[nameList appendString:@"; "];
		}
	}
	[nameList appendString:names];
	
	txtUsername.text = nameList;
	
	[self dismissModalViewControllerAnimated:YES];
	[txtUseremail becomeFirstResponder];
	return NO;
} 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	//    [textField resignFirstResponder];
	printf("Clearing Keyboard\n");
	//if(([txtUsername.text isEqualToString:@""] ) || ([txtUseremail.text isEqualToString:@""] ))
	if(([txtUsername.text compare:@""] == NSOrderedSame) || ([txtUseremail.text compare:@""] == NSOrderedSame))
	{
		
		UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the required fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[showAlert show];
		[showAlert release];
		return NO;
	}
	else {
		
		BOOL loginchk = [self sendRequest4ShareEvent:@"referpeople"];
		if(loginchk)
		{
			NSString *alrtmsg = [[[[@"You have successfully referred " stringByAppendingString:referralname] stringByAppendingString:@" to "] stringByAppendingString:txtUsername.text] stringByAppendingString:@"."]; 
			UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:alrtmsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[showAlert show];
			[showAlert release];
			//[txtUsername becomeFirstResponder];
			txtUsername.text = @"";			
			[self.navigationController popViewControllerAnimated:YES];
			return YES;
		}
		else
		{
			UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Unable to share people, please provide correct email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[showAlert show];
			[showAlert release];
			return NO;
		}
	}
	//[textField resignFirstResponder];
	printf("Clearing Keyboard\n");	
	return YES;
}

- (BOOL) sendRequest4ShareEvent: (NSString *) flag {
	
	
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
	
	userid = [arrayForUserID objectAtIndex:0];
	NSString *unsocialuserid = [NSString stringWithFormat:@"%@\r\n",userid];
	
	NSString *shareusername = [NSString stringWithFormat:@"%@\r\n",txtUsername.text];
	NSString *sharewithemail = [NSString stringWithFormat:@"%@\r\n",txtUseremail.text];
	
	NSString *referralemailid = [NSString stringWithFormat:@"%@\r\n",referralemail];
	NSString *referralph = [NSString stringWithFormat:@"%@\r\n",referralphone];
	NSString *referraltag = [NSString stringWithFormat:@"%@\r\n",referraltags];
	NSString *referralusername = [NSString stringWithFormat:@"%@\r\n",referralname];
	
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
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",unsocialuserid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"sharewithname\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",shareusername] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"sharewithemail\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",sharewithemail] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"referralname\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",referralusername] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"referralemail\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",referralemailid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"referralphone\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",referralph] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"referraltags\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",referraltag] dataUsingEncoding:NSUTF8StringEncoding]];
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
		if ([key isEqualToString:@"Mailsent"] )			
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				//[self updateDataFileOnSave:[dic objectForKey:key]];
				printf("\n\n\n\n\n\n#######################-- share event successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				//UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"your credentials have been sent to you by email" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				//[showAlert show];
				//[showAlert release];
				break;
			}
		}
		else if ([key isEqualToString:@"Notsuccess"] )
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
