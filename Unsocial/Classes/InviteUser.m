//
//  InviteUser.m
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "LauncherViewTestController.h"
#import "InviteUser.h"
#import "Settings.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "UIDeviceHardware.h"
#import "Person.h"

#define klabelFontSize  13
@implementation InviteUser
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
	
	bar.hidden = NO;
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"signinback.png"];
	[self.view addSubview:imgBack];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Invite your friends" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
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
	
	UILabel *lblEmail = [UnsocialAppDelegate createLabelControl:@"Email address:" frame:CGRectMake(30, 45, 260, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblEmail];
	
	if (!txtEmail)
	{
		txtEmail = [UnsocialAppDelegate createTextFieldControl:CGRectMake(lblEmail.frame.origin.x, lblEmail.frame.origin.y + 25, lblEmail.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter email seperated by ;"  backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeAlphabet returnKey:UIReturnKeyGo];
		[txtEmail setDelegate:self];
		txtEmail.returnKeyType = UIReturnKeyGo;
		txtEmail.backgroundColor = [UIColor clearColor];
		txtEmail.autocorrectionType = UITextAutocorrectionTypeNo;
		txtEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
	}
	[self.view addSubview:txtEmail];
	
	// added by pradeep on 22 nov 2010 for "+" btn for invite feature
	//****************************
	
	UIButton *btnPlus = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(getContact) frame:CGRectMake(lblEmail.frame.size.width+30, lblEmail.frame.origin.y + 29, 20, 20) imageStateNormal:@"button_plus_contacts.png" imageStateHighlighted:@"button_plus_contacts.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnPlus.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	[self.view addSubview:btnPlus];
	
	//***************************
	
	UILabel *lblFriendName = [UnsocialAppDelegate createLabelControl:@"Friend's name:" frame:CGRectMake(lblEmail.frame.origin.x, lblEmail.frame.origin.y + 66, lblEmail.frame.size.width, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblFriendName];
	
	if (!txtFriendName)
	{
		txtFriendName = [UnsocialAppDelegate createTextFieldControl:CGRectMake(lblFriendName.frame.origin.x, lblFriendName.frame.origin.y + 25, lblFriendName.frame.size.width, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter friend's name seperated by ;"  backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeAlphabet returnKey:UIReturnKeyDone];
		//[txtFriendName becomeFirstResponder]; 
		[txtFriendName setDelegate:self];
		txtFriendName.autocorrectionType = UITextAutocorrectionTypeNo;
		txtFriendName.autocapitalizationType = UITextAutocapitalizationTypeWords;
		txtFriendName.backgroundColor = [UIColor clearColor];
	}
	[self.view addSubview:txtFriendName];
}

//adding functions to support adding email contacts by pradeep on 22 november 2010
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
		//CFStringRef email = ABMultiValueCopyValueAtIndex(emails, identifier);
	
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
	if (txtEmail.text) 
	{
		if ([txtEmail.text compare:@""] != NSOrderedSame)
		{
			[emailList appendString:txtEmail.text];
			[emailList appendString:@"; "];
		}
	}
	[emailList appendString:(NSString*)ABMultiValueCopyValueAtIndex(emails, identifier)];
	
	txtEmail.text = emailList;
		//NSLog( (NSString *) email);
	
	//*********** for name
	
	NSMutableString *nameList = [NSMutableString new];
	if (txtFriendName.text) 
	{ 
		if ([txtFriendName.text compare:@""] != NSOrderedSame)
		{
			[nameList appendString:txtFriendName.text];
			[nameList appendString:@"; "];
		}
	}
	[nameList appendString:names];
	
	txtFriendName.text = nameList;
		//NSLog((NSString *) names);
	
	//***********
	
	[self dismissModalViewControllerAnimated:YES];
	[txtEmail becomeFirstResponder];
	return NO;
} 

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
	if (alertFor == 1) {
		
		alertFor = 0;	
		[txtEmail resignFirstResponder];
		[txtFriendName resignFirstResponder];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

//****************************************************** end add contact code 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	/*printf("Clearing Keyboard\n");
	
	NSString *email = [txtEmail.text lowercaseString];
	NSString *emailRegEx =
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
		//BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:email];
	
	*/
	if(([txtFriendName.text compare:@""] == NSOrderedSame) || ([txtEmail.text compare:@""] == NSOrderedSame)){
			
		UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the required fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[showAlert show];
		[showAlert release];
		return NO;
	}
	//commented on 22 nov 2010 by pradeep for multiple invitation
	/*else if(!myStringMatchesRegEx) 
	{
			
			UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Invalid Email Address" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			[alertView show];
			[alertView release];
			//whereClicked = 1;
			return NO;
	}*/
	else 
	{
		BOOL issent = [self sendInvitation:@"invitefriend"];
		if (issent)
		{
			
			[txtEmail becomeFirstResponder];
			txtFriendName.text = @"";
			txtEmail.text = @"";
		}
		else
		{
			UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Invitation not sent, please try again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[showAlert show];
			[showAlert release];
		}
		return NO;
	}
	printf("Clearing Keyboard\n");
	return YES;
}

- (BOOL) sendInvitation: (NSString *) flag {
	
	
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
	NSString *friendname = [NSString stringWithFormat:@"%@\r\n",txtFriendName.text];
	NSString *friendemail = [NSString stringWithFormat:@"%@\r\n",txtEmail.text];
	
	//DEFAULT TERMS/////////////////////////////////////
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	//NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	//NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	//NSString *allownotification = [NSString stringWithFormat:@"%@\r\n",@"0"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"flag\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",flg1] dataUsingEncoding:NSUTF8StringEncoding]];	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[aryLoggedinUserName objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"friendname\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",friendname] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"friendemail\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",friendemail] dataUsingEncoding:NSUTF8StringEncoding]];
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
				//[self updateDataFileOnSave:[dic objectForKey:key]];
				printf("\n\n\n\n\n\n#######################-- Invitation sent successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Invitation sent successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[showAlert show];
				[showAlert release];
				alertFor = 1;
				break;
			}
			
		}	
		else if ([key isEqualToString:@"Alreadysent"])
		{
			successflg=YES;
			UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Friend(s) already invited!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[showAlert show];
			[showAlert release];
			alertFor = 0;
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
