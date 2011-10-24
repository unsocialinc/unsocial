//
//  SignIn.m
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "ShareEvent.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "Person.h"

#define klabelFontSize  13
@implementation ShareEvent
@synthesize userid, eventid;

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
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Share Event" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	[self createControls];
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
- (void)rightbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	[self dismissModalViewControllerAnimated:YES];
}
// end 1 june 2011

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
	
	
	if (!txtUseremail)
	{
	txtUseremail = [UnsocialAppDelegate createTextFieldControl:CGRectMake(lblUsername.frame.origin.x, lblUsername.frame.origin.y + 25, lblUsername.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter email"  backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeEmailAddress returnKey:UIReturnKeyDone];
	//[txtUsername becomeFirstResponder]; 
	[txtUseremail setDelegate:self];
	txtUseremail.autocapitalizationType = UITextAutocapitalizationTypeNone;
	txtUseremail.autocorrectionType = UITextAutocorrectionTypeNo;
	txtUseremail.backgroundColor = [UIColor clearColor];
	txtUseremail.returnKeyType = UIReturnKeyGo;
	
	//[txtUseremail release];
	}
	[self.view addSubview:txtUseremail];
	// after launch: added by pradeep on 15 sep 2010 for adding "+" btn for selecting email from iphone contacts controll
	//****************************
	
	UIButton *btnPlus = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(getContact) frame:CGRectMake(lblUsername.frame.size.width+30, lblUsername.frame.origin.y + 29, 20, 20) imageStateNormal:@"button_plus_contacts.png" imageStateHighlighted:@"button_plus_contacts.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnPlus.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	[self.view addSubview:btnPlus];
	
	// after launch: added by pradeep on 15 sep 2010 for adding "+" btn for selecting email from iphone contacts controll
	/*
	 
	 CGRect btn = CGRectMake(280.0, 235.0, 29, 29);
	 UIButton *plusSign = [[UIButton alloc] initWithFrame:btn];
	 [plusSign setBackgroundColor:[UIColor clearColor]];
	 [plusSign setFont:[UIFont fontWithName:@"Arial" size:12.0]];
	 [plusSign setImage:[UIImage imageNamed:@"button_plus_contacts.png"] forState:(UIControlState)nil];
	 [plusSign addTarget:self action:@selector(getContact) forControlEvents:UIControlEventTouchUpInside];
	 [self.view addSubview:(UIButton *)plusSign];
	 
	 UIButton *btnOptions = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnOptions_Onclick) frame:CGRectMake(lblUsername.frame.origin.x+10, lblUsername.frame.origin.y + 25, 29, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button_plus_contacts.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	 [btnOptions.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	 [self.view addSubview:btnOptions];
	 
	 */
	//****************************
	
	
	lblUsername = [UnsocialAppDelegate createLabelControl:@"Name:" frame:CGRectMake(lblUsername.frame.origin.x, lblUsername.frame.origin.y + 66, lblUsername.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblUsername];
	// 13 may 2011 by pradeep //[lblUsername release];
	
	if (!txtUsername)
	{
	txtUsername = [UnsocialAppDelegate createTextFieldControl:CGRectMake(lblUsername.frame.origin.x, lblUsername.frame.origin.y + 25, lblUsername.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter name"  backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
	//[txtUsername becomeFirstResponder]; 
	[txtUsername setDelegate:self];
	txtUsername.autocorrectionType = UITextAutocorrectionTypeNo;
	txtUsername.autocapitalizationType = UITextAutocapitalizationTypeWords;
	txtUsername.backgroundColor = [UIColor clearColor];
	txtUsername.returnKeyType = UIReturnKeyGo;
	
	//[txtUsername release];
	}
	[self.view addSubview:txtUsername];
}

// after launch: added by pradeep on 15 sep 2010 for adding "+" btn for selecting email from iphone contacts controll
//adding functions to support adding email contacts
//****************************************************** start add contact code

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
 // assigning control back to the main controller
 [self dismissModalViewControllerAnimated:YES];
 }
 
 
 - (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
 
 
 // setting the email
 
 //this function will set the first number it finds
 
 //if you do not set a number for a contact it will probably
 //crash
 
//ABMultiValueRef multi = (NSString *)ABRecordCopyValue(person, kABPersonEmailProperty);
//tv.text = (NSString*)ABMultiValueCopyValueAtIndex(multi, 0);

// remove the controller
//[tvc dismissModalViewControllerAnimated:YES];

return YES;
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	
	ABMultiValueRef emails = ABRecordCopyValue(person, property);
	CFStringRef email = ABMultiValueCopyValueAtIndex(emails, identifier);
	
	//*********** for name
	
	NSString *firstName;// = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty) ;
	NSString *surname;// = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty) ;
	//if ((NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty) != "")
		firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	if (firstName == nil)
		firstName = @"";
	//if ((NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty) != "")
	surname = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	if (surname == nil)		
		surname = @"";
	
	NSString *names = [firstName stringByAppendingString:surname];
	
		
	//NSString *names = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);//[(NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty) stringByAppendingFormat:(NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty)];
	
	//ABMultiValueRef names = ABRecordCopyValue(person, kABPersonFirstNameProperty);	
	
	//CFStringRef name = ABMultiValueCopyValueAtIndex(names, identifier);
	
	//*********** for name
	
	
	//now add to the text
	
	NSMutableString *emailList = [NSMutableString new];
	if (txtUseremail.text) { 
		[emailList appendString:txtUseremail.text];
		[emailList appendString:@"; "];
	}
	[emailList appendString:(NSString*)ABMultiValueCopyValueAtIndex(emails, identifier)];
	
	txtUseremail.text = emailList;
	NSLog( (NSString *) email);
	
	//*********** for name
	
	NSMutableString *nameList = [NSMutableString new];
	if (txtUsername.text) { 
		[nameList appendString:txtUsername.text];
		[nameList appendString:@"; "];
	}
	[nameList appendString:names];
	
	txtUsername.text = nameList;
	NSLog( (NSString *) names);
	
	//***********
	
	[self dismissModalViewControllerAnimated:YES];
	[txtUseremail becomeFirstResponder];
	return NO;
} 

//****************************************************** end add contact code 
 
 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	    [textField resignFirstResponder];
	printf("Clearing Keyboard\n");
	if(([txtUsername.text compare:@""] == NSOrderedSame) || ([txtUseremail.text compare:@""] == NSOrderedSame)){
		
		UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the required fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[showAlert show];
		[showAlert release];
		return NO;
	}
	else {
		
		BOOL loginchk = [self sendRequest4ShareEvent:@"shareevent"];
		if(loginchk)
		{
			NSString *alrtmsg = [NSString stringWithFormat:@"You have successfully shared this event with %@.", txtUsername.text]; 
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
			UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Unable to share event, please provide correct email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
	
	NSString *eventttl = [NSString stringWithFormat:@"%@\r\n",[aryEventDetails objectAtIndex:1]];
	NSString *eventindustry = [NSString stringWithFormat:@"%@\r\n",[aryEventDetails objectAtIndex:4]];
	NSString *eventdt = [NSString stringWithFormat:@"%@\r\n",[aryEventDetails objectAtIndex:5]];
	NSString *timefrm = [NSString stringWithFormat:@"%@\r\n",[aryEventDetails objectAtIndex:6]];
	NSString *timeto = [NSString stringWithFormat:@"%@\r\n",[aryEventDetails objectAtIndex:7]];
	NSString *phone = [NSString stringWithFormat:@"%@\r\n",[aryEventDetails objectAtIndex:8]];
	NSString *eventaddress = [NSString stringWithFormat:@"%@\r\n",[aryEventDetails objectAtIndex:3]];
	NSString *eventdesc = [NSString stringWithFormat:@"%@\r\n",[aryEventDetails objectAtIndex:2]];
	NSString *eventwebsite = [NSString stringWithFormat:@"%@\r\n",[aryEventDetails objectAtIndex:9]];
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventttl\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",eventttl] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventindustry\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",eventindustry] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventdt\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",eventdt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventfrm\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",timefrm] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventto\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",timeto] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventphone\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",phone] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventaddress\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",eventaddress] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventdesc\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",eventdesc] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventwebsite\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",eventwebsite] dataUsingEncoding:NSUTF8StringEncoding]];
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
				printf("\n\n\n\n\n\n#######################-- share event successfully --#######################\n\n\n\n\n\n");
				
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
	
	NSLog(returnString);
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
