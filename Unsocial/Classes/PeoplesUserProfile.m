//
//  PeoplesUserProfile.m
//  unsocial
//
//  Created by vaibhavsaran on 23/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PeoplesUserProfile.h"
#import "PeopleSendMessage.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"
#import "SettingsStep5.h"
#import "ReferPeople.h"
#import "Person.h"
#import "WebViewForWebsites.h"
#import "webViewForLinkedIn.h"
#import "MyNotes.h"

NSInteger flagLogoOnActionSheet = 0;
NSString *alreadybookmark, *ownerKeywords;
BOOL isemailavailable4referral, isphoneavailable4referral;

int flg4rply2;

@implementation PeoplesUserProfile

@synthesize username, userid, userind, usersubind, userrole, userintind, userintsubind, userintrole, userprefix, useremail, usercontact, userwebsite, usercompany, userlinkedin, userabout, userdisplayitem, profileforwhichtab, myname, statusmgs, camefrom, strdistance, usertitle, userlinkedintoken, userlevel;

// added by pradeep on 15 may 2011 for getting eventid for note, when user came from attendeelist of normal event's detail section
@synthesize eventid4attendeelistofnormalevent;
//end 15 july 2011

//******** lazy img implementation by praeep on 17 sep 2010
@synthesize camefromwhichoption, imgurl;
//********
// ******** added by pradeep on 7 dec 2010
@synthesize taggedon;
// ******** 7 dec 2010 end
@synthesize fullImg;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	[activityView stopAnimating];
	isemailavailable4referral = NO;
	isphoneavailable4referral = NO;
	[self createControls];
}

- (BOOL) postController:	(TTPostController *) 	postController willPostText: (NSString *) text {
	
	/*BOOL retbool;
	NSLog(@"Text: %@", text);
	text = [text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if(text) {
		
		if([text isEqualToString:@""])
		{
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please write message." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];			 
				//[self btnContact_Onclick];
			retbool = NO;
		}
		else {
			retbool = YES;
		}
	}*/
	return YES;
}

- (void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result {
	
	if (flg4rply2==0) // for normal reply
	{
		NSLog(@"rply with business card");
		
		userInfo = [[NSMutableArray alloc] init];
		
		BOOL _checkprimeryinfo = [self getDataFromFile1];
		_checkprimeryinfo = YES;
		
		text = [NSString stringWithFormat:@"\n%@\n-------------------------------------------------\nFrom- %@\n-------------------------------------------------", text,[[userInfo objectAtIndex:0] objectForKey:@"usrname"]];
	}
	else // for reply with business card
	{
		NSLog(@"rply with business card");
		
		userInfo = [[NSMutableArray alloc] init];
		
		BOOL isPrimaryInfoExist = [self getDataFromFile1];
		NSLog(@"%@", [[userInfo objectAtIndex:0] objectForKey:@"usrname"]);
		BOOL isContactInfoExist = [self getDataFromFile2];
		NSLog(@"hello");
		if (isPrimaryInfoExist)
		{
				// BugId- 00146 fixed -Vaibhav(v1.3.6) 
			if (![[[userInfo objectAtIndex:0] objectForKey:@"usrpre"] isEqualToString:@"none"]) {
				
				text = [NSString stringWithFormat:@"%@\n\n------Business Card------\n\nName: %@\nEmail: %@\nContact: %@", 
						text,[[userInfo objectAtIndex:0] objectForKey:@"usrname"], 
						[[userInfo objectAtIndex:0] objectForKey:@"usremail"], 
						[[userInfo objectAtIndex:0] objectForKey:@"usrcontact"]];
			}
			else {
				
					// BugId- 00145 fixed -Vaibhav(v1.3.6) 
				NSString *_getlinkedinmail = [UnsocialAppDelegate getLinkedInMailFromFile];
				if (![_getlinkedinmail isEqualToString:@""]) {
					
					text = [NSString stringWithFormat:@"%@\n\n------Business Card------\n\nName: %@\nEmail: %@\nContact: %@", 
							text,[[userInfo objectAtIndex:0] objectForKey:@"usrname"], 
							_getlinkedinmail, 
							[[userInfo objectAtIndex:0] objectForKey:@"usrcontact"]];
				}
				else {
					
					text = [NSString stringWithFormat:@"%@\n\n------Business Card------\n\nName: %@\nContact: %@", 
							text,[[userInfo objectAtIndex:0] objectForKey:@"usrname"], 
							[[userInfo objectAtIndex:0] objectForKey:@"usrcontact"]];
				}
			}
		}
		if (isContactInfoExist)
		{
			if ([[userInfo objectAtIndex:1] objectForKey:@"usrcompany"]) 
				text = [text stringByAppendingString:[@"\nCompany: " stringByAppendingString:[[userInfo objectAtIndex:1] objectForKey:@"usrcompany"]]];
			if ([[userInfo objectAtIndex:1] objectForKey:@"usrind"]) 
				text = [text stringByAppendingString:[@"\nIndustry: " stringByAppendingString:[[userInfo objectAtIndex:1] objectForKey:@"usrind"]]];
			if ([[userInfo objectAtIndex:1] objectForKey:@"usrfunc"]) 
				text = [text stringByAppendingString:[@"\nFunction: " stringByAppendingString:[[userInfo objectAtIndex:1] objectForKey:@"usrfunc"]]];
			if ([[userInfo objectAtIndex:1] objectForKey:@"usrwebsite"]) 
				text = [text stringByAppendingString:[@"\nWebsite: " stringByAppendingString:[[userInfo objectAtIndex:1] objectForKey:@"usrwebsite"]]];
		}
		//text = [text stringByAppendingString:@"\n\n------Original Message------\n\n"];// stringByAppendingString: strMsgDescription]];
	}
	
	NSLog(@"Text: %@", text);
	
	[self sendMessage:text];
}

- (BOOL) getDataFromFile1 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
		//open it and read it 
		NSLog(@"data file found. getDataFromFile1");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];
		//[self setPersonArray:tempArray];
		
		NSLog(@"%@", [[tempArray objectAtIndex:0] usersubind]);
		if ( [[[tempArray objectAtIndex:0] usersubind] isEqualToString:@""])
		{
			NSLog(@"subind blank");
		}
		
		
		/*Person *newPerson = [[Person alloc] init];	
		 
		 newPerson.userprefix = [[tempArray objectAtIndex:0] userprefix];
		 newPerson.username = [[tempArray objectAtIndex:0] username];
		 newPerson.userid = [[tempArray objectAtIndex:0] userid];
		 newPerson.useremail = [[tempArray objectAtIndex:0] useremail];
		 newPerson.self.usercontact = [[tempArray objectAtIndex:0] self.usercontact];*/
		
		NSLog(@"%@", [[tempArray objectAtIndex:0] username]);
		NSLog(@"%@", [[tempArray objectAtIndex:0] userid]);
		//userInfo = [[NSMutableArray alloc] init];
		userInfoDic = [[NSMutableDictionary alloc] init];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userprefix] forKey:@"usrpre" ];// insertObject:newPerson atIndex:0];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] username] forKey:@"usrname" ];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userid] forKey:@"usrid" ];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] useremail] forKey:@"usremail"];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] usercontact] forKey:@"usrcontact"];
		
		[userInfo addObject:[userInfoDic copy]];
		
		[decoder finishDecoding];
		[decoder release];	
		
		//newPerson.imgperson = [images objectAtIndex:0];
		//NSLog(@"\nuserid-%@\n\nusername-%@", newPerson.userid, newPerson.username);
		
		
		//[newPerson release];
		
		NSLog(@"%@", [[userInfo objectAtIndex:0] objectForKey:@"usrname"]);
		
		//if ( [username isEqualToString:@""] || !username)
		if ( [[[tempArray objectAtIndex:0] userid] isEqualToString:@""] || ![[tempArray objectAtIndex:0] userid])
		{
			return NO;
		}
		else {
			
			return YES;
		}		
	}
	else { 
		return NO;
	}
}

- (BOOL) getDataFromFile2 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial2"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
		//open it and read it 
		NSLog(@"data file found. getDataFromFile2");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];	
		
		NSLog(@"%@", [[tempArray objectAtIndex:0] username]);
		NSLog(@"%@", [[tempArray objectAtIndex:0] userid]);
		//userInfo = [[NSMutableArray alloc] init];
		userInfoDic = [[NSMutableDictionary alloc] init];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] usercompany] forKey:@"usrcompany" ];// insertObject:newPerson atIndex:0];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userwebsite] forKey:@"usrwebsite" ];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userindustry] forKey:@"usrind" ];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userfunction] forKey:@"usrfunc"];
		
		[userInfo addObject:[userInfoDic copy]];
		
		
		
		//newPerson.imgperson = [images objectAtIndex:0];
		//NSLog(@"\nuserid-%@\n\nusername-%@", newPerson.userid, newPerson.username);
		
		
		//[newPerson release];
		
		NSLog(@"%@", [[userInfo objectAtIndex:0] objectForKey:@"usrcompany"]);
		
		if ([[[tempArray objectAtIndex:0] userid] isEqualToString:@""] || ![[tempArray objectAtIndex:0] userid])
		{
			[decoder finishDecoding];
			[decoder release];
			return NO;
		}
		else {
			[decoder finishDecoding];
			[decoder release];
			return YES;
		}
		
		
		
	}
	else { //just in case the file is not ready yet.
		return NO;
	}
}

- (BOOL) sendMessage:(NSString *)msgSentText {
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"sendmsg"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	//NSString *deviceTocken;
	
	//NSString *usrabout;
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	NSString *bookmarkedid, *usrid;
	
	bookmarkedid = [NSString stringWithFormat:@"%@\r\n",userid];
	usrid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];

	usrid = [NSString stringWithFormat:@"%@\r\n",userid];
	bookmarkedid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];
	NSString *strMessage = [NSString stringWithFormat:@"%@\r\n",msgSentText];
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"senderid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",bookmarkedid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"msgbody\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strMessage] dataUsingEncoding:NSUTF8StringEncoding]];
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
				NSLog(@"Message is- %@", strMessage);
				NSLog(@"\n\n\n\n\n\n#######################-- post for Send Message added successfully --#######################\n\n\n\n\n\n");
				successflg=YES;
				
				if(successflg) {

					[self playSound];
					UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Message sent successfully." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
					[errorAlert show];
					[errorAlert release];
				}
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

- (void) playSound {
	AudioServicesPlaySystemSound (beep);
}

- (void)viewWillAppear:(BOOL)animated {
	
	if (flagforcompinfo == 1) {
		
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:@"Invitation sent successfully." message:@"You have successfully sent a LinkedIn invitation to this person." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertOnChoose show];
		[alertOnChoose release];
		flagforcompinfo = 0;
	}
	else if (flagforcompinfo == 2) {
		
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:@"Invitation unsuccessful." message:@"Either you have already invited this person or this person is beyond your network reach." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertOnChoose show];
		[alertOnChoose release];
		flagforcompinfo = 0;
	}
	
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	//add background color
	self.view.backgroundColor = color;
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	UIImageView *imgProfileBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 320, 380)];
	imgProfileBack.image = [UIImage imageNamed:@"peopleprofileback.png"];
	[self.view addSubview:imgProfileBack];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];	
	
	UIButton *btnOptions = [UnsocialAppDelegate createButtonControl:@"Options" target:self selector:@selector(btnOptions_Onclick) frame:CGRectMake(30, 385, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnOptions.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	[self.view addSubview:btnOptions];
	
	UIButton *btnMyAds = [UnsocialAppDelegate createButtonControl:@"Website" target:self selector:@selector(btnMedia) frame:CGRectMake(128, btnOptions.frame.origin.y, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnMyAds.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	[self.view addSubview:btnMyAds];
	
	UIButton *btnSendMsg = [UnsocialAppDelegate createButtonControl:@"Contact" target:self selector:@selector(btnContact_Onclick) frame:CGRectMake(225, btnOptions.frame.origin.y, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnSendMsg.titleLabel setFont:[UIFont fontWithName:kAppFontName size:12]];
	[self.view addSubview:btnSendMsg];
	
	[btnOptions release];
	[btnMyAds release];
	[btnSendMsg release];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 210, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	
	// for adding TT's navigation controller for website
	TTNavigator *navigator = [TTNavigator  navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	TTURLMap *map = navigator.URLMap;
	[map from:@"*" toViewController:[TTWebController class]];
	
	// Load the sound
    id sndpath = [[NSBundle mainBundle] pathForResource:@"mailsent" ofType:@"wav"];
	CFURLRef baseURL = (CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpath];
	AudioServicesCreateSystemSoundID (baseURL, &beep);
}

- (void)createControls {
	
	if(!stories)
		[self getKeywordsForUser:@""];
	collectionAryKeywords = [[NSMutableArray alloc]init];
	
	// for fixing tag mixing issue added by pradeep on 13 nov 2010
	ownerKeywords = @"";
	
	if ([stories count] >0)
	{		
		// commented by pradeep on 13 nov 2010 for fixing tag mixing issue
		//ownerKeywords = @"";
		
		for (int cnt=0; cnt < [stories count]; cnt++) 
		{
			ownerKeywords = (ownerKeywords==@"")?[[stories objectAtIndex:cnt] objectForKey:@"keywords"]:[ownerKeywords stringByAppendingString:[@", " stringByAppendingString:[[stories objectAtIndex:cnt] objectForKey:@"keywords"]]]; 
		}
		[collectionAryKeywords addObject:ownerKeywords];
		NSLog(@"profile owner's who am i keywords are- %@", ownerKeywords);
	}
	
	// commented by pradeep on 11 august for fixing different image layout
	/*CGImageRef realImage = fullImg.CGImage;
	float realHeight = CGImageGetHeight(realImage);
	float realWidth = CGImageGetWidth(realImage);
	float ratio = realHeight/realWidth;
	float modifiedWidth, modifiedHeight;
	// commented by pradeep on 11 august for fixing different image layout
	if(ratio >= 1) {
		
		modifiedWidth = 75/ratio;
		modifiedHeight = 75;
	}
	else {
		
		modifiedWidth = 75;
		modifiedHeight = ratio*75;
	}
	
	userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, modifiedWidth, modifiedHeight)];*/
	WhereIam = 4;
	if ((camefromwhichoption == @"people") || (camefromwhichoption == @"attendeelist") || (camefromwhichoption == @"searchpeople") || (camefromwhichoption == @"liveattendeelist") || (camefromwhichoption == @"peopleautotags"))
	{
		//userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 75, 75)];
		CGRect frame;
		frame.size.width=75; frame.size.height=75;
		frame.origin.x=10; frame.origin.y=13;
		asyncImage = [[[AsyncImageView alloc]
					   initWithFrame:frame] autorelease];
		asyncImage.tag = 999;
		//NSURL*url = [NSURL URLWithString:[imageURLs4Lazy objectAtIndex:indexPath.row]];
		NSURL*url = [NSURL URLWithString:imgurl];
		[asyncImage loadImageFromURL:url];
		asyncImage.backgroundColor = [UIColor clearColor];
		//[cell.contentView addSubview:asyncImage];
		
		// Get the Layer of any view
		CALayer * l = [asyncImage layer];
		[l setMasksToBounds:YES];
		[l setCornerRadius:10.0];
		
		// You can even add a border
		[l setBorderWidth:1.0];
		[l setBorderColor:[[UIColor blackColor] CGColor]];
		[self.view addSubview:asyncImage];
	}
	else 
	{
	userImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 75, 75)];
	
	userImage.image = fullImg;
	
	// Get the Layer of any view
	CALayer * l = [userImage layer];
	[l setMasksToBounds:YES];
	[l setCornerRadius:10.0];
	
	// You can even add a border
	[l setBorderWidth:1.0];
	[l setBorderColor:[[UIColor blackColor] CGColor]];
	[self.view addSubview:userImage];
		// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
		//[userImage release];
		// end 3 august 2011 for fixing memory issue	
	}
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(90, 85, 220, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	// added by pradeep on 4 may 2011 for spliting usermane since it is overlapping on "Tagged on:
	NSString *usrnamedeep = username;
	if ([usrnamedeep length] > 40)			
		usrnamedeep = [[usrnamedeep substringWithRange:NSMakeRange(0,37)] stringByAppendingString:@"..."];
	
	// end 4 may 2011
	
	heading = [UnsocialAppDelegate createTextViewControl:usrnamedeep frame:CGRectMake(90, 13, 220, 72) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize-1 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	heading.contentInset = UIEdgeInsetsMake(-8.00, -8.00, 0.00, 0.00);
	heading.scrollsToTop = YES;
	[self.view addSubview:heading];
	
	UILabel *lblDistance = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(10, 90, 300, 15) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];

	NSString *showDistance;
	NSArray *aryMiles = [strdistance componentsSeparatedByString:@" Miles"];
	
	float floatMiles = [[aryMiles objectAtIndex:0] floatValue];
	if(floatMiles <= 1.00) {
		
		showDistance = @"Steps Away";
	}
	else if(floatMiles < 5.00) {
		
		if(floatMiles > 1.00) {
			
			showDistance = @"Short Distance";
		} 
	}
	else {
		showDistance = strdistance; 
	}
	lblDistance.textColor = [UIColor orangeColor];
	lblDistance.text = showDistance;
	
	// added below if (camefromwhichoption != @"inbox") condition pradeep on 15 march 2011 for fixing issue > if inbox > showmsg > userprofile, distance always shows "Steps away"
	if (camefromwhichoption != @"inbox")
		[self.view addSubview:lblDistance];
	
	// added by pradeep on 7 dec 2010 for implementing auto tagged improvement feature
	//*********
	if (camefromwhichoption == @"peopleautotags")
	{
		UILabel *lblTaggedOn = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(90, 68, 200, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		
		lblTaggedOn.textColor = [UIColor orangeColor];
		lblTaggedOn.text = taggedon;
		[self.view addSubview:lblTaggedOn];
	}
	//********* 7 dec 2010 end

	// for adding TT's navigation controller for website
	[self.navigationItem setTitle:username];
	
	NSString *displayitem = userdisplayitem;
	isemailshow = [[displayitem substringFromIndex:0] substringToIndex:1];
	NSString *isindustryshow = [[displayitem substringFromIndex:1] substringToIndex:1];
	NSString *iscompanyshow = [[displayitem substringFromIndex:2] substringToIndex:1];
	iscontactshow = [[displayitem substringFromIndex:3] substringToIndex:1];
	
	UILabel *lbltitle = [UnsocialAppDelegate createLabelControl:@"Title: " frame:CGRectMake(10, 90, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lbltitle];
	
	UILabel *lblcompany = [UnsocialAppDelegate createLabelControl:@"Company: " frame:CGRectMake(lbltitle.frame.origin.x, lbltitle.frame.origin.y + 16, 270, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblcompany];
	
	UILabel *lblindustry = [UnsocialAppDelegate createLabelControl:@"Industry:" frame:CGRectMake(lblcompany.frame.origin.x, lblcompany.frame.origin.y + 16, 270, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblindustry];
	
	UILabel *lblemail = [UnsocialAppDelegate createLabelControl:@"E-Mail: " frame:CGRectMake(lblcompany.frame.origin.x, lblindustry.frame.origin.y + 16, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblemail];
	
	UILabel *lblcontact = [UnsocialAppDelegate createLabelControl:@"Contact:" frame:CGRectMake(lblcompany.frame.origin.x, lblemail.frame.origin.y + 16, 60, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblcontact];
	
	UILabel *lbllinkedIn = [UnsocialAppDelegate createLabelControl:@"Public Profile:" frame:CGRectMake(lblcompany.frame.origin.x, lblcontact.frame.origin.y + 16, 80, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:11 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lbllinkedIn];
	
	NSString *ttl = usertitle;
	if ([usertitle length] > 32)
		ttl = [[usertitle substringWithRange:NSMakeRange(0,31)] stringByAppendingString:@"..."];
	
	CGRect lableTitleFrame = CGRectMake(lblcompany.frame.origin.x + 58, lbltitle.frame.origin.y, 178, 15);
	UILabel *lblTitle = [UnsocialAppDelegate createLabelControl:ttl frame:lableTitleFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblTitle];
	
	// for company **** start ****
	// if company is set as private then it will be as 1 else 0
	CGRect lableCompanyFrame = CGRectMake(lblcompany.frame.origin.x + 58, lblcompany.frame.origin.y, 240, 15);
	
	// commented by pradeep on 12 august for fixing issue for auto release
	//lblCompny = [UnsocialAppDelegate createLabelControl:@"" frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	lblCompny = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"" frame:lableCompanyFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	// end 12 august 2011
	
	[self.view addSubview:lblCompny];
	
	if (![iscompanyshow isEqualToString:@"0"]) // company is private i.e. 1
	{
		CGRect lableLockFrame = CGRectMake(lblCompny.frame.origin.x, lblcompany.frame.origin.y, 15, 15);
		userImage = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
		[self.view addSubview:userImage];
	}
	else {
		
		if ([usercompany isEqualToString:@""])
			lblCompny.text = @"";
		else {
			lblCompny.text = usercompany;
		}
	}
	// for company **** end ****

	
	CGRect lableIntIndFrame = CGRectMake(lableCompanyFrame.origin.x, lableCompanyFrame.origin.y + 16, lblCompny.frame.size.width, 15);
	UILabel *lblIndustry = [UnsocialAppDelegate createLabelControl:@"" frame:lableIntIndFrame txtAlignment:UITextAlignmentLeft numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	[self.view addSubview:lblIndustry];
	
	if (![isindustryshow isEqualToString:@"0"])//industry is private i.e. 1
	{
		CGRect lableLockFrame = CGRectMake(lblIndustry.frame.origin.x, lblIndustry.frame.origin.y, 15, 15);
		userImage = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
		[self.view addSubview:userImage];
	}
	else {
		
		if ([userind isEqualToString:@""]) // added on 15 march 2011 for fixing bug if industry set then userprofile does not show industry
			lblIndustry.text = @"";
		else
			lblIndustry.text = userind;
	}

	// for email **** start ****
	// if email is set as private then it will be as 1 else 0
	CGRect lableEmailFrame = CGRectMake(lblIndustry.origin.x, lblIndustry.origin.y + 16, lblCompny.frame.size.width, 15);
	
	// commented by pradeep on 12 august for fixing issue for auto release
	//lblEmail = [UnsocialAppDelegate createLabelControl:@"" frame:lableEmailFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	lblEmail = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"" frame:lableEmailFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 12 august 2011
	
	[self.view addSubview:lblEmail];

	if (![isemailshow isEqualToString:@"0"]) {// email is private i.e. 1
		
		CGRect lableLockFrame = CGRectMake(lblEmail.frame.origin.x, lblEmail.origin.y, 15, 15);
		imgLockForEmail = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
		[self.view addSubview:imgLockForEmail];
	}
	else 
	{
		isemailavailable4referral = YES;
		lblEmail.text = useremail;		
		if ([useremail isEqualToString:@""]) // if email is blank
			lblEmail.text = @"";
		[self.view addSubview:lblEmail];
	}
	// for email **** end ****
	
	// for phone # **** start ****
	// if phone # is set as private then it will be as 1 else 0
	CGRect lableContactFrame = CGRectMake(lblEmail.origin.x, lblEmail.origin.y + 16, lblCompny.frame.size.width, 15);	
	
	// commented by pradeep on 12 august for fixing issue for auto release
	//lblPhone = [UnsocialAppDelegate createLabelControl:@"" frame:lableContactFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	lblPhone = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"" frame:lableContactFrame txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	// end 12 august 2011
	
	[self.view addSubview:lblPhone];
	
	btnCallTheNumber = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(callTheNumber) frame:CGRectMake(lblEmail.origin.x, lblEmail.origin.y + 16, 100, 15) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnCallTheNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[self.view addSubview:btnCallTheNumber];
	
	if (![iscontactshow isEqualToString:@"0"]) // company is private i.e. 1
	{		
		//btnCallTheNumber.text = @"Phone:";
		CGRect lableLockFrame = CGRectMake(btnCallTheNumber.origin.x, btnCallTheNumber.origin.y, 15, 15);
		imgLockForPhone = [UnsocialAppDelegate createImageViewControl:lableLockFrame imageName:@"lock.png"];
		[self.view addSubview:imgLockForPhone];
		btnCallTheNumber.hidden = YES;
	}
	else 
	{
		// commented by pradeep on 24 nov 2010 for fixing bug related to "Add to phone" option i.e. app crashes when clicked on "Add to phone" option
		// isphoneavailable4referral = YES;
		if ([self.usercontact isEqualToString:@""]) {
			
			[btnCallTheNumber setTitle:@"" forState:UIControlStateNormal];// .text = @"";
			[btnCallTheNumber setHidden:YES];
		}
		else 
		{
			// added by pradeep on 24 nov 2010 for fixing bug related to "Add to phone" option i.e. app crashes when clicked on "Add to phone" option
			isphoneavailable4referral = YES;
			[btnCallTheNumber setTitle:usercontact forState:UIControlStateNormal];// .text = @"";
			[btnCallTheNumber setHidden:NO];
				//			btnCallTheNumber.text = self.usercontact;
				//			btnCallTheNumber.hidden = NO;	
		}
	}

	CGRect lableLinkedInFrame = CGRectMake(btnCallTheNumber.origin.x + 20, btnCallTheNumber.origin.y + 16, lblCompny.frame.size.width - 15, 15);	
	
	/*tvLinkedIn = [UnsocialAppDelegate createTextViewControl:@"" frame:lableLinkedInFrame txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:kPeopleTableContent returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:NO editable:NO];
	tvLinkedIn.contentInset = UIEdgeInsetsMake(-8, -8, 0, 0);
	[self.view addSubview:tvLinkedIn];*/
	
	btnOpenLinkedIn = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnOpenLinkedIn_Click) frame:lableLinkedInFrame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnOpenLinkedIn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, btnOpenLinkedIn.origin.y + 17, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	if ([userlinkedin isEqualToString:@""]){
			//[btnOpenLinkedIn setTitle:@"" forState:UIControlStateNormal];
		btnOpenLinkedIn.hidden = YES;
	}
	else {
		[btnOpenLinkedIn setTitle:userlinkedin forState:UIControlStateNormal];
		btnOpenLinkedIn.hidden = NO;
		aryLinkedIn = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:userlinkedin, nil]];
	}
	[self.view addSubview:btnOpenLinkedIn];
	
	// for phone # **** end ****	
	UILabel *lblStatus = [UnsocialAppDelegate createLabelControl:@"Status:" frame:CGRectMake(lbllinkedIn.origin.x, btnOpenLinkedIn.origin.y + 20, btnOpenLinkedIn.frame.size.width + 16, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblStatus];
	
	statusmsg = [UnsocialAppDelegate createTextViewControl:statusmgs frame:CGRectMake(lbllinkedIn.frame.origin.x, lblStatus.frame.origin.y + 16, 300, 45) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:@"Helvetica-BoldOblique" fontsize:kPeopleTableContent returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	statusmsg.contentInset = UIEdgeInsetsMake(-8.00, -8.00, 0.00, 0.00);
	statusmsg.userInteractionEnabled = YES;
	statusmsg.bounces = NO;
	[self.view addSubview:statusmsg];
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, statusmsg.origin.y + 48, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	UILabel *lblfunction = [UnsocialAppDelegate createLabelControl:@"Function:" frame:CGRectMake(lblStatus.frame.origin.x, statusmsg.frame.origin.y + 50, 270, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblfunction];
	
	CGRect lablefunctionFrame = CGRectMake(lblStatus.frame.origin.x, lblfunction.frame.origin.y + 16, 270, 15);
	UILabel *lblFunction = [UnsocialAppDelegate createLabelControl:@"" frame:lablefunctionFrame txtAlignment:UITextAlignmentLeft numberoflines:3 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];	
	
	if ([userrole isEqualToString:@""])
		lblFunction.text = @"";
	else 
		lblFunction.text = userrole;
	[self.view addSubview:lblFunction];
	
	UILabel *lblwebsite = [UnsocialAppDelegate createLabelControl:@"Website:" frame:CGRectMake(lblfunction.frame.origin.x, lblFunction.frame.origin.y + 20, 270, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblwebsite];
	
	CGRect lableWebsiteFrame = CGRectMake(lblfunction.frame.origin.x, lblwebsite.frame.origin.y + 16, 270, 15);	
	UIButton *btnOpenTheWebsite = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnOpenTheWebsite_Click) frame:lableWebsiteFrame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor orangeColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnOpenTheWebsite.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	
	if ([userwebsite isEqualToString:@""])
		[btnOpenTheWebsite setTitle:@"" forState:UIControlStateNormal];
	else {
		[btnOpenTheWebsite setTitle:userwebsite forState:UIControlStateNormal];
		
		/*NSString* strWebsite = @"<a href=\"www\">www</a>";	
		NSArray *aryWebsite = [strWebsite componentsSeparatedByString:@"www"];
		strWebsite = [[[[[aryWebsite objectAtIndex:0] stringByAppendingString:userwebsite] stringByAppendingString:[aryWebsite objectAtIndex:1]] stringByAppendingString:userwebsite]  stringByAppendingString:[aryWebsite objectAtIndex:2]];*/
		
		/*TTStyledTextLabel* lblTTWebsite = [[[TTStyledTextLabel alloc] initWithFrame:lableWebsiteFrame] autorelease];
		[lblTTWebsite setFont:[UIFont fontWithName:kAppFontName size:11]];
		lblTTWebsite.textColor = [UIColor whiteColor];
		lblTTWebsite.backgroundColor = [UIColor clearColor];
		lblTTWebsite.text = [TTStyledText textFromXHTML:strWebsite lineBreaks:YES URLs:YES];
		lblTTWebsite.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
		[lblTTWebsite sizeToFit];
		[self.view addSubview:lblTTWebsite];*/
		
		NSLog(@"%@", userwebsite);
	}
	[self.view addSubview:btnOpenTheWebsite];
	
	UILabel *lblSmartTags = [UnsocialAppDelegate createLabelControl:@"Sample Tags: " frame:CGRectMake(lblfunction.frame.origin.x, btnOpenTheWebsite.frame.origin.y + 20, 105, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kPeopleTableContent txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblSmartTags];
	
	UITextView *tvMetaTags = [UnsocialAppDelegate createTextViewControl:ownerKeywords frame:CGRectMake(lblfunction.frame.origin.x, lblSmartTags.frame.origin.y + 16, 300, 30) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:kPeopleTableContent returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	tvMetaTags.userInteractionEnabled = YES;
	tvMetaTags.contentInset = UIEdgeInsetsMake(-8, -8, 0, 0);
	
	if([ownerKeywords isEqualToString:@""])
		tvMetaTags.text = @"";
	[self.view addSubview:tvMetaTags];

	if ([profileforwhichtab isEqualToString:@"bookmark"])
		self.navigationItem.rightBarButtonItem = nil;
	
	
#pragma mark Putting LinkedIn 1st Level and LinkedIn icon
	
		// started on 14 Jun 2011 - vaibhav
	UIImageView *linkedinico = [UnsocialAppDelegate createImageViewControl:CGRectMake(68, 71, 16, 16) imageName:@"linkedinIcon.png"];
	[self.view addSubview:linkedinico];
	linkedinico.hidden = YES;
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[linkedinico release];
	// end 3 august 2011 for fixing memory issue
	
	UIButton *btnFLevel = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnFLevel_click:) frame:CGRectMake(280, 68, 30, 16) imageStateNormal:@"1stlev.png" imageStateHighlighted:@"1stlev.png" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnFLevel];
	btnFLevel.hidden = YES;
	[btnFLevel release];
	
	btntip = [UnsocialAppDelegate createButtonControl:@"This user is your 1st level connection on LinkedIn\n\n" target:self selector:@selector(btnFLevel_click:) frame:CGRectMake(180, -100, 135, 63) imageStateNormal:@"btnNote.png" imageStateHighlighted:@"btnNote.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btntip.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
	[btntip.titleLabel setNumberOfLines:4];
		//UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>) 
	btntip.titleEdgeInsets = UIEdgeInsetsMake(-5, 5, 0, 5);
	[btntip.titleLabel setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:11]];
	[self.view addSubview:btntip];
	[btntip release];
	
	if ([userlevel isEqualToString:@"yes"]){
		btnFLevel.hidden = NO;
	}
	if ([userprefix isEqualToString:@"none"]){
		linkedinico.hidden = NO;
	}	
		// end on 14 Jun 2011 - vaibhav	
	
}

- (void) btnFLevel_click:(id)sender {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.20];
		//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:btntip cache:NO];
		//btntip.hidden = NO;
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	if(btntip.frame.origin.y == -100)
		btntip.frame = CGRectMake(180, 10, 135, 63);
	else
		btntip.frame = CGRectMake(180, -100, 135, 63);
	[UIView commitAnimations];	
}

- (void)btnOpenLinkedIn_Click {
	
	if ([btnOpenLinkedIn.titleLabel.text isEqualToString:@""] || btnOpenLinkedIn.titleLabel.text == nil)
		return;
	WebViewForWebsites *webViewForWebsites = [[WebViewForWebsites alloc]init];
	webViewForWebsites.webAddress = btnOpenLinkedIn.titleLabel.text;
	[self.navigationController pushViewController:webViewForWebsites animated:YES];
	[webViewForWebsites release];
}

- (void)btnOpenTheWebsite_Click {
	
	if(userwebsite == nil || [userwebsite isEqualToString:@""])
		return;
	
	WebViewForWebsites *webViewForWebsites = [[WebViewForWebsites alloc]init];
	webViewForWebsites.webAddress = userwebsite;		
	[self.navigationController pushViewController:webViewForWebsites animated:YES];
	[webViewForWebsites release];
}

- (void)callTheNumber {
	
	if([self.usercontact isEqualToString:@""]) {
		
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Phone currently not set." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertOnChoose show];
		[alertOnChoose release];
		return;
	}
	else {
		
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:usercontact delegate:self cancelButtonTitle:nil otherButtonTitles:@"Call", @"Cancel", nil];
		messageType = 2;
		[alertOnChoose show];
		[alertOnChoose release];
	}
}

- (void)btnMedia {
	
	/*UIActionSheet *actionSheet;
	 if ([userwebsite isEqualToString:@""]) 
	 {		
	 actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"unsocial Tile", @"unsocial Reel", @"Cancel", nil];
	 actionSheet.destructiveButtonIndex = 2;
	 }
	 else
	 {
	 actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"unsocial Tile", @"unsocial Reel", @"Website", @"Cancel",  nil];
	 actionSheet.destructiveButtonIndex = 3;
	 }
	 actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	 [actionSheet showInView:self.view];
	 // show from our table view (pops up in the middle of the table)
	 [actionSheet release];*/
	if (![userwebsite isEqualToString:@""])
		[self btnOpenTheWebsite_Click];
	else
	{
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Website currently not set." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertOnChoose show];
		[alertOnChoose release];
	}
	actionsheettype = 2;
}

- (void)sendEmail {
	
	if([self.useremail isEqualToString:@""]) {
		
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"E Mail currently not set." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertOnChoose show];
		[alertOnChoose release];
		return;
	}
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController") );
	if (mailClass != nil)
	{
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
		
		if (picker) {
			
		NSString *emailSubj;
		emailSubj = @"Mail via unsocial";
		[picker setSubject:emailSubj];
		
		NSArray *toRecipients = [NSArray arrayWithObject:useremail]; 
		[picker setToRecipients:toRecipients];
		picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		[[self navigationController] presentModalViewController:picker animated:YES];
		[picker release];
		}
	}
}

- (void)leftbtn_OnClick {
	
	WhereIam = 0;
	flagforcompinfo = 0;
	// added by pradeep on 11 july 2011 only for when user come here from inboxshowmessage and shownote
	int lastopenedctrl = [self.navigationController.viewControllers count];//-2;
	lastopenedctrl=lastopenedctrl-3;
	// logic end 11 july 2011 
	if(camefrom != 1)
		[self.navigationController popViewControllerAnimated:YES];
	else 
		// commented by pradeep on 11 july 2011 for when user come here from inboxshowmessage and shownote
		//[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
		[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:lastopenedctrl] animated:YES];
		// end 11 july 2011
}

- (BOOL) sendNow4Bookmark: (NSString *) flag {
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"addbookmark"];
	
	// commented added by pradeep on 6 july 2011 for adding NOTE feature
	//NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"addnote"];
	// end 6 july 2011
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	//NSString *deviceTocken;
	
	//NSString *usrabout;
		
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *usrid = [arrayForUserID objectAtIndex:0];
	usrid = [NSString stringWithFormat:@"%@\r\n",usrid];
	
	NSString *bookmarkedid = [NSString stringWithFormat:@"%@\r\n",userid];
	
	
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"bookmarkeduserid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",bookmarkedid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// added by pradeep on 6 july 2011 for adding NOTE feature
	
	NSLog(@"camefromwhichoption: %@", camefromwhichoption);
	
	NSString *notecategory = [NSString stringWithFormat:@"%@\r\n",camefromwhichoption];
	NSString *shortnote = [NSString stringWithFormat:@"%@\r\n",@""];
		
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"notecategory\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",notecategory] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"shortnote\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",shortnote] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	if (camefromwhichoption == @"liveattendeelist")
	{		
		NSString *eventid = [NSString stringWithFormat:@"%@\r\n",[liveNowEventID objectAtIndex:0]];
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",eventid] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	else if (camefromwhichoption == @"attendeelist")
	{		
		NSString *eventid = [NSString stringWithFormat:@"%@\r\n",eventid4attendeelistofnormalevent];
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",eventid] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	else 
	{
		NSString *eventid = [NSString stringWithFormat:@"%@\r\n",@""];
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",eventid] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
			
	}
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

	
	// end 6 july 2011
	
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
	alreadybookmark = nil;
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Userid"])
		{
			//userid = [dic objectForKey:key];
			
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				
				NSLog(@"\n\n\n\n\n\n#######################-- post for bookmaark added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				messageType = 0;
				break;
			}			
		}
		else if ([key isEqualToString:@"Notsuccess"])
		{
			//userid = [dic objectForKey:key];
			
			if ([[dic objectForKey:key] isEqualToString:@"Already bookmark!"])
			{
				
				NSLog(@"\n\n\n\n\n\n#######################-- post for bookmaark added successfully --#######################\n\n\n\n\n\n");
				messageType = 0;
				alreadybookmark = @"alreadybookmark";
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

- (void)btnOptions_Onclick {
	
	UIActionSheet *actionSheet;
	if ([profileforwhichtab isEqualToString:@"bookmark"])
	{
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Add to Phone", @"Smart Tag's", @"Refer", @"Note", @"Cancel",  nil];
		actionSheet.destructiveButtonIndex = 4;
	}
	else 
	{
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Add to Phone", @"Save Profile", @"Smart Tag's", @"Refer", @"Note", @"Cancel",  nil];
	actionSheet.destructiveButtonIndex = 5;
	}
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	// show from our table view (pops up in the middle of the table)
	[actionSheet release];
	actionsheettype = 1;
}

- (void)btnContact_Onclick {
	
	NSString *displayitem = userdisplayitem;
	isemailshow = [[displayitem substringFromIndex:0] substringToIndex:1];
	iscontactshow = [[displayitem substringFromIndex:3] substringToIndex:1];
	UIActionSheet *actionSheet;
	
		//if([userprefix isEqualToString:@"none"]) {
	
		// if Phone is not visible
	if(([isemailshow isEqualToString:@"0"]) && (![iscontactshow isEqualToString:@"0"])) {
		
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"EMail", @"Message", @"Connect via Linked    ", @"Cancel",  nil];
		actionSheet.destructiveButtonIndex = 3;
		clickedonforactionsheet3 = 2;
		flagLogoOnActionSheet = 1;
	}
	
		// if email is not visible
	else if((![isemailshow isEqualToString:@"0"]) && ([iscontactshow isEqualToString:@"0"])) {
		
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Phone", @"Message", @"Connect via Linked    ", @"Cancel",  nil];
		actionSheet.destructiveButtonIndex = 3;
		clickedonforactionsheet3 = 2;
		flagLogoOnActionSheet = 2;
	}
	
		// if Phone and mail are not visible
	else if((![isemailshow isEqualToString:@"0"]) && (![iscontactshow isEqualToString:@"0"])) {
		
			//if([btnCallTheNumber.titleLabel.text isEqualToString:@""]) {
			
			actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Message", @"Connect via Linked    ", @"Cancel",  nil];
			actionSheet.destructiveButtonIndex = 2;
			clickedonforactionsheet3 = 3;
			flagLogoOnActionSheet = 3;
			//}
	}
	
		// if all are visible
	else {
		
		actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"EMail", @"Phone", @"Message", @"Connect via Linked    ", @"Cancel",  nil];
		actionSheet.destructiveButtonIndex = 4;
		clickedonforactionsheet3 = 4;
		flagLogoOnActionSheet = 4;
	}
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	actionsheettype = 3;	
	[actionSheet release];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
	
	if (flagLogoOnActionSheet != 0) {

		UIImageView* df = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"linkedinlogo.png"]];
		df.contentMode = UIViewContentModeScaleAspectFit;
		
		if(flagLogoOnActionSheet == 1)
			df.frame = CGRectMake(245, 138, 25, 25);
		else if(flagLogoOnActionSheet == 2)
			df.frame = CGRectMake(245, 138, 25, 25);
		else if(flagLogoOnActionSheet == 3)
			df.frame = CGRectMake(245, 85, 25, 25);
		else if(flagLogoOnActionSheet == 4)
			df.frame = CGRectMake(245, 190, 25, 25);
		[actionSheet addSubview:df];
		flagLogoOnActionSheet = 0;
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(actionsheettype == 1) 
	{	
		if ([profileforwhichtab isEqualToString:@"bookmark"]) // added by pradeep on 26 july 2011 for removing saved option from "Option" is user come from "Saved" tab
		{
			if(buttonIndex == 0) 
			{
				
				// added by pradeep for fixing bug when phone is set as locked and user wants to add it to his address book on 24 nov 2010
				//**** start 24 nov 2010
				
				NSString *displayitem = userdisplayitem;
				NSLog(@"Which items are private n which are public %@", displayitem);
				iscontactshow = [[displayitem substringFromIndex:3] substringToIndex:1];
				
				if (isphoneavailable4referral) // company is private i.e. 1 [iscontactshow isEqualToString:@"0"]
				{
					//***** ent 24 nov 2010 also its else statement added on 24 nov 2010 by pradeep	
					
					ABRecordRef aRecord = ABPersonCreate(); 
					CFErrorRef  anError = NULL;
					
					// Username
					ABRecordSetValue(aRecord, kABPersonFirstNameProperty, username, &anError);
					
					// Phone Number.
					ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
					ABMultiValueAddValueAndLabel(multi, (CFStringRef)btnCallTheNumber.titleLabel.text, kABWorkLabel, NULL);
					ABRecordSetValue(aRecord, kABPersonPhoneProperty, multi, &anError);
					CFRelease(multi);
					
					// Company
					ABRecordSetValue(aRecord, kABPersonDepartmentProperty, lblCompny.text, &anError);
					
					// email
					NSLog(@"%@", useremail);
					ABMutableMultiValueRef multiemail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
					ABMultiValueAddValueAndLabel(multiemail, (CFStringRef)lblEmail.text, kABWorkLabel, NULL);
					ABRecordSetValue(aRecord, kABPersonEmailProperty, multiemail, &anError);
					CFRelease(multiemail);
					
					// website
					NSLog(@"%@", userwebsite);
					ABMutableMultiValueRef multiweb = ABMultiValueCreateMutable(kABMultiStringPropertyType);
					ABMultiValueAddValueAndLabel(multiweb, (CFStringRef)userwebsite, kABWorkLabel, NULL);
					ABRecordSetValue(aRecord, kABPersonURLProperty, multiweb, &anError);
					CFRelease(multiemail);
					
					// profile url
					NSLog(@"%@", userwebsite);
					ABMutableMultiValueRef multiweb2 = ABMultiValueCreateMutable(kABMultiStringPropertyType);
					ABMultiValueAddValueAndLabel(multiweb2, (CFStringRef)userlinkedin, kABWorkLabel, NULL);
					ABRecordSetValue(aRecord, kABPersonURLProperty, multiweb2, &anError);
					CFRelease(multiemail);
					
					// Function
					ABRecordSetValue(aRecord, kABPersonJobTitleProperty, userrole, &anError);
					
					if (anError != NULL)
						NSLog(@"error while creating..");
					
					CFStringRef personname, personcompind, personemail, personfunction,  personwebsite, personwebsite2, personcontact;
					
					personname = ABRecordCopyValue(aRecord, kABPersonFirstNameProperty); 
					personcompind = ABRecordCopyValue(aRecord, kABPersonDepartmentProperty); 
					personfunction = ABRecordCopyValue(aRecord, kABPersonJobTitleProperty); 
					personemail = ABRecordCopyValue(aRecord, kABPersonEmailProperty);
					personwebsite = ABRecordCopyValue(aRecord, kABPersonURLProperty);
					personwebsite2 = ABRecordCopyValue(aRecord, kABPersonURLProperty);
					personcontact  = ABRecordCopyValue(aRecord, kABPersonPhoneProperty); 
					
					ABAddressBookRef addressBook; 
					CFErrorRef error = NULL; 
					addressBook = ABAddressBookCreate(); 
					
					BOOL isAdded = ABAddressBookAddRecord (addressBook, aRecord, &error);
					
					if(isAdded){
						
						NSLog(@"added..");
					}
					if (error != NULL) {
						NSLog(@"ABAddressBookAddRecord %@", error);
					} 
					error = NULL;
					
					BOOL isSaved = ABAddressBookSave (addressBook, &error);
					
					if(isSaved) {
						
						NSLog(@"saved..");
						UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Phone added successfully to your address book." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
						messageType = 0;
						[alertOnChoose show];
						[alertOnChoose release];
					}
					
					if (error != NULL) {
						
						NSLog(@"ABAddressBookSave %@", error);
						UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle: nil message:@"Unable to save this time." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
						messageType = 0;
						[alertOnChoose show];
						[alertOnChoose release];
					} 
					
					CFRelease(aRecord); 
					CFRelease(personname);
					CFRelease(personcompind);
					CFRelease(personcontact);
					CFRelease(personemail);
					CFRelease(personfunction);
					CFRelease(personwebsite);  
					CFRelease(addressBook);
				}	
				// added by pradeep for fixing bug when phone is set as locked and user wants to add it to his address book on 24 nov 2010
				//**** start 24 nov 2010
				else // if phone is set as locked
				{
					NSString *errmsg = @"";
					if ([self.usercontact isEqualToString:@""]) // i.e. phone not set
						errmsg = @"Phone currently not set.";
					else errmsg = @"Unable to add phone to your address book due to privacy settings.";
					NSLog(@"Contact # is locked");
					UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle: nil message:errmsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
					[alertOnChoose show];
					[alertOnChoose release];
				}
				// **** end 24 nov 2010
			}
			else if(buttonIndex == 1) // for smart tagging
			{
				UIAlertView *alertOnChoose;
				if ([collectionAryKeywords count] >0)
				{
					alertOnChoose = [[UIAlertView alloc] initWithTitle:@"Adding following tags to your “interested in” tags list!" message:[collectionAryKeywords objectAtIndex:0] delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO", @"YES", nil];
				}
				else // if owner hasn't added any keyword for his "Who am i" section i.e. metatags
				{
					alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Tags not found for smart tagging!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
				}
				[alertOnChoose show];
				[alertOnChoose release];
				self.navigationItem.rightBarButtonItem = nil;
			}
			else if(buttonIndex == 2) 
			{ // for refer
				
				ReferPeople *referPeople = [[ReferPeople alloc]init];
				// added by pradeep on 2 august 2010 for referral feature
				if (!isemailavailable4referral) // email is private i.e. 1
				{
					referPeople.referralemail = @"";
				}
				else referPeople.referralemail = lblEmail.text;
				if (!isphoneavailable4referral) // phone is private i.e. 1
				{
					referPeople.referralphone = @"";
				}
				else referPeople.referralphone = btnCallTheNumber.titleLabel.text;
				if([ownerKeywords isEqualToString:@""])
					referPeople.referraltags = @"";
				else referPeople.referraltags = ownerKeywords;
				referPeople.referralname = heading.text;
				[self.navigationController pushViewController:referPeople animated:YES];
				[referPeople release];
			}
			else if(buttonIndex == 3) 
			{ // for Notes
				MyNotes *myNotes = [[MyNotes alloc]init];
				myNotes.comingfrom = 1;
				myNotes.userid4displayingnotes = userid;
				myNotes.notepurposeflag = @"singleuser";
				myNotes.camefromwhichoption = camefromwhichoption;
				myNotes.eventid4attendeelistofnormalevent = eventid4attendeelistofnormalevent;
				[self.navigationController pushViewController:myNotes animated:YES];
				[myNotes release];
			}
			else {
				
			}
		}
		else 
		{
			if(buttonIndex == 0) 
			{
				
				// added by pradeep for fixing bug when phone is set as locked and user wants to add it to his address book on 24 nov 2010
				//**** start 24 nov 2010
				
				NSString *displayitem = userdisplayitem;
				NSLog(@"Which items are private n which are public %@", displayitem);
				iscontactshow = [[displayitem substringFromIndex:3] substringToIndex:1];
				
				if (isphoneavailable4referral) // company is private i.e. 1 [iscontactshow isEqualToString:@"0"]
				{
					//***** ent 24 nov 2010 also its else statement added on 24 nov 2010 by pradeep	
					
					ABRecordRef aRecord = ABPersonCreate(); 
					CFErrorRef  anError = NULL;
					
					// Username
					ABRecordSetValue(aRecord, kABPersonFirstNameProperty, username, &anError);
					
					// Phone Number.
					ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
					ABMultiValueAddValueAndLabel(multi, (CFStringRef)btnCallTheNumber.titleLabel.text, kABWorkLabel, NULL);
					ABRecordSetValue(aRecord, kABPersonPhoneProperty, multi, &anError);
					CFRelease(multi);
					
					// Company
					ABRecordSetValue(aRecord, kABPersonDepartmentProperty, lblCompny.text, &anError);
					
					// email
					NSLog(@"%@", useremail);
					ABMutableMultiValueRef multiemail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
					ABMultiValueAddValueAndLabel(multiemail, (CFStringRef)lblEmail.text, kABWorkLabel, NULL);
					ABRecordSetValue(aRecord, kABPersonEmailProperty, multiemail, &anError);
					CFRelease(multiemail);
					
					// website
					NSLog(@"%@", userwebsite);
					ABMutableMultiValueRef multiweb = ABMultiValueCreateMutable(kABMultiStringPropertyType);
					ABMultiValueAddValueAndLabel(multiweb, (CFStringRef)userwebsite, kABWorkLabel, NULL);
					ABRecordSetValue(aRecord, kABPersonURLProperty, multiweb, &anError);
					CFRelease(multiemail);
					
					// profile url
					NSLog(@"%@", userwebsite);
					ABMutableMultiValueRef multiweb2 = ABMultiValueCreateMutable(kABMultiStringPropertyType);
					ABMultiValueAddValueAndLabel(multiweb2, (CFStringRef)userlinkedin, kABWorkLabel, NULL);
					ABRecordSetValue(aRecord, kABPersonURLProperty, multiweb2, &anError);
					CFRelease(multiemail);
					
					// Function
					ABRecordSetValue(aRecord, kABPersonJobTitleProperty, userrole, &anError);
					
					if (anError != NULL)
						NSLog(@"error while creating..");
					
					CFStringRef personname, personcompind, personemail, personfunction,  personwebsite, personwebsite2, personcontact;
					
					personname = ABRecordCopyValue(aRecord, kABPersonFirstNameProperty); 
					personcompind = ABRecordCopyValue(aRecord, kABPersonDepartmentProperty); 
					personfunction = ABRecordCopyValue(aRecord, kABPersonJobTitleProperty); 
					personemail = ABRecordCopyValue(aRecord, kABPersonEmailProperty);
					personwebsite = ABRecordCopyValue(aRecord, kABPersonURLProperty);
					personwebsite2 = ABRecordCopyValue(aRecord, kABPersonURLProperty);
					personcontact  = ABRecordCopyValue(aRecord, kABPersonPhoneProperty); 
					
					ABAddressBookRef addressBook; 
					CFErrorRef error = NULL; 
					addressBook = ABAddressBookCreate(); 
					
					BOOL isAdded = ABAddressBookAddRecord (addressBook, aRecord, &error);
					
					if(isAdded){
						
						NSLog(@"added..");
					}
					if (error != NULL) {
						NSLog(@"ABAddressBookAddRecord %@", error);
					} 
					error = NULL;
					
					BOOL isSaved = ABAddressBookSave (addressBook, &error);
					
					if(isSaved) {
						
						NSLog(@"saved..");
						UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Phone added successfully to your address book." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
						messageType = 0;
						[alertOnChoose show];
						[alertOnChoose release];
					}
					
					if (error != NULL) {
						
						NSLog(@"ABAddressBookSave %@", error);
						UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle: nil message:@"Unable to save this time." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
						messageType = 0;
						[alertOnChoose show];
						[alertOnChoose release];
					} 
					
					CFRelease(aRecord); 
					CFRelease(personname);
					CFRelease(personcompind);
					CFRelease(personcontact);
					CFRelease(personemail);
					CFRelease(personfunction);
					CFRelease(personwebsite);  
					CFRelease(addressBook);
				}	
				// added by pradeep for fixing bug when phone is set as locked and user wants to add it to his address book on 24 nov 2010
				//**** start 24 nov 2010
				else // if phone is set as locked
				{
					NSString *errmsg = @"";
					if ([self.usercontact isEqualToString:@""]) // i.e. phone not set
						errmsg = @"Phone currently not set.";
					else errmsg = @"Unable to add phone to your address book due to privacy settings.";
					NSLog(@"Contact # is locked");
					UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle: nil message:errmsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
					[alertOnChoose show];
					[alertOnChoose release];
				}
				// **** end 24 nov 2010
			}
			else if(buttonIndex == 1) {
				
				BOOL isuserbookmarked = [self sendNow4Bookmark:@""];
				if (isuserbookmarked)
				{
					UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:[[username stringByAppendingString:@" "] stringByAppendingString:@"saved successfully!"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
					[alertOnChoose show];
					[alertOnChoose release];
					self.navigationItem.rightBarButtonItem = nil;
				}
				else 
				{
					if ([alreadybookmark isEqualToString:@"alreadybookmark"])
					{
						UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:[[username stringByAppendingString:@" "] stringByAppendingString:@"is already saved!"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
						[alertOnChoose show];
						[alertOnChoose release];
						self.navigationItem.rightBarButtonItem = nil;
					}
				}
			}
			else if(buttonIndex == 2) // for smart tagging
			{
				UIAlertView *alertOnChoose;
				if ([collectionAryKeywords count] >0)
				{
					alertOnChoose = [[UIAlertView alloc] initWithTitle:@"Adding following tags to your “interested in” tags list!" message:[collectionAryKeywords objectAtIndex:0] delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO", @"YES", nil];
				}
				else // if owner hasn't added any keyword for his "Who am i" section i.e. metatags
				{
					alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Tags not found for smart tagging!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
				}
				[alertOnChoose show];
				[alertOnChoose release];
				self.navigationItem.rightBarButtonItem = nil;
			}
			else if(buttonIndex == 3) 
			{ // for refer
				
				ReferPeople *referPeople = [[ReferPeople alloc]init];
				// added by pradeep on 2 august 2010 for referral feature
				if (!isemailavailable4referral) // email is private i.e. 1
				{
					referPeople.referralemail = @"";
				}
				else referPeople.referralemail = lblEmail.text;
				if (!isphoneavailable4referral) // phone is private i.e. 1
				{
					referPeople.referralphone = @"";
				}
				else referPeople.referralphone = btnCallTheNumber.titleLabel.text;
				if([ownerKeywords isEqualToString:@""])
					referPeople.referraltags = @"";
				else referPeople.referraltags = ownerKeywords;
				referPeople.referralname = heading.text;
				[self.navigationController pushViewController:referPeople animated:YES];
				[referPeople release];
			}
			else if(buttonIndex == 4) 
			{ // for Notes
				MyNotes *myNotes = [[MyNotes alloc]init];
				myNotes.comingfrom = 1;
				myNotes.userid4displayingnotes = userid;
				myNotes.notepurposeflag = @"singleuser";
				myNotes.camefromwhichoption = camefromwhichoption;
				myNotes.eventid4attendeelistofnormalevent = eventid4attendeelistofnormalevent;
				[self.navigationController pushViewController:myNotes animated:YES];
				[myNotes release];
			}
			else {
				
			}
		}

	}
	else if(actionsheettype == 2) // for media click
	{
		
		if(buttonIndex == 0) { // billboard 
			
			[lastVisitedFeature removeAllObjects];
			[lastVisitedFeature addObject:@"viewdigitalbillboardfrmusrprofile"];
			NSLog(@"%@", [lastVisitedFeature objectAtIndex:0]);
			
			SettingsStep5 *viewcontroller = [[SettingsStep5 alloc] init];
			viewcontroller.comingfrom = 2;
			viewcontroller.userid4digiboard = userid;
			[self.navigationController pushViewController:viewcontroller animated:YES];
		}
		else if(buttonIndex == 1) { //video 
			
			UIAlertView *alerReel = [[UIAlertView alloc] initWithTitle:nil message:@"This feature is in progress." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alerReel show];
			[alerReel release];
		}
		else if(buttonIndex == 2) { //website
			
			if(![userwebsite isEqualToString:@""])
				[self btnOpenTheWebsite_Click];
			
		}
		else if(buttonIndex == 3) { // cancel
			
		}
	}
	else { 
		
		/*if([userprefix isEqualToString:@"none"]) {
		 // for contact btn click		
		 if(clickedonforactionsheet3 == 1)
		 {			
		 if(buttonIndex == 0)
		 [self callingMailClient];
		 
		 else if(buttonIndex == 1)
		 {
		 UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to send your business card also?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No", @"Yes", @"Cancel", nil];
		 [alertOnChoose show];
		 [alertOnChoose release];
		 messageType = 1;
		 }
		 }
		 else if (clickedonforactionsheet3 == 2)
		 {			
		 if(buttonIndex == 0)
		 [self callTheNumber];
		 
		 else if(buttonIndex == 1)
		 {
		 UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to send your business card also?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No", @"Yes", @"Cancel", nil];
		 [alertOnChoose show];
		 [alertOnChoose release];
		 messageType = 1;
		 }
		 }
		 else if (clickedonforactionsheet3 == 3)
		 {		
		 if(buttonIndex == 0)
		 {
		 UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to send your business card also?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No", @"Yes", @"Cancel", nil];
		 [alertOnChoose show];
		 [alertOnChoose release];
		 messageType = 1;
		 }			
		 }
		 else if (clickedonforactionsheet3 == 4)
		 {			
		 if(buttonIndex == 0)
		 [self callingMailClient];
		 
		 else if(buttonIndex == 1) 
		 [self callTheNumber];
		 
		 else if(buttonIndex == 2)
		 {
		 UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to send your business card also?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No", @"Yes", @"Cancel", nil];
		 [alertOnChoose show];
		 [alertOnChoose release];
		 messageType = 1;
		 }
		 }
		 }
		 else {*/
		
			//**************************** for contact btn click ********************************//
		if(clickedonforactionsheet3 == 1)
		{			
			if(buttonIndex == 0)
			{
				UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to send your business card also?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No", @"Yes", @"Cancel", nil];
				[alertOnChoose show];
				[alertOnChoose release];
				messageType = 1;
			}
		}
		else if (clickedonforactionsheet3 == 2)
		{			
			if(buttonIndex == 0)
				[self callTheNumber];
			
			else if(buttonIndex == 1)
			{
				UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to send your business card also?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No", @"Yes", @"Cancel", nil];
				[alertOnChoose show];
				[alertOnChoose release];
				messageType = 1;
			}
			else if(buttonIndex == 2)
			{
				[self sendLinkedInInvite];
			}
		}
		else if (clickedonforactionsheet3 == 3)
		{
			if(buttonIndex == 0)
			{
				UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to send your business card also?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No", @"Yes", @"Cancel", nil];
				[alertOnChoose show];
				[alertOnChoose release];
				messageType = 1;
			}			
			if(buttonIndex == 1)
			{
				[self sendLinkedInInvite];
			}			
		}
		else if (clickedonforactionsheet3 == 4)
		{			
			if(buttonIndex == 0)
				[self sendEmail];
			
			else if(buttonIndex == 1)
				[self callTheNumber];
			
			else if(buttonIndex == 2)
			{
				UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to send your business card also?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No", @"Yes", @"Cancel", nil];
				[alertOnChoose show];
				[alertOnChoose release];
				messageType = 1;
			}
			
			else if(buttonIndex == 3)
				[self sendLinkedInInvite];
		}
	}
}

- (void) sendLinkedInInvite {

	NSString *_EMail = self.useremail;
	NSArray *_arr = [self.userlinkedintoken componentsSeparatedByString:@"@"];
	NSArray *_arr2;
	NSString *linkedInToken = @"0"; // if 'mobi'
	
	if([_arr count] > 0)
	{	
		_arr2 = [[_arr objectAtIndex:1] componentsSeparatedByString:@"."]; // 'us' or 'mobi'
		
		if ([[_arr2 objectAtIndex:1] isEqualToString:@"us"]) { // is 'us'
			
			linkedInToken = [_arr objectAtIndex:0];
		}
	}	
	
	if ([useremail isEqualToString:@""]) {
		
		if (![[_arr2 objectAtIndex:1] isEqualToString:@"us"]) { // token is not updated to memberid
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email/LinkedIn member id not found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
	}
	NSMutableArray *arayUnsername = [[NSMutableArray alloc]init];
	[arayUnsername setArray:[username componentsSeparatedByString:@" "]];
	NSString *FName = [arayUnsername objectAtIndex:0];
	NSString *LName = @"";
	if ([arayUnsername count] > 1)
		LName = [arayUnsername objectAtIndex:1];

	NSArray *arraySignIn = [[NSArray alloc] initWithObjects:FName, LName, _EMail, linkedInToken, nil];
	
	webViewForLinkedIn *wvli = [[webViewForLinkedIn alloc]init];
	wvli.camefrom = @"UnsocialSendInvitation";
	wvli.arraySignIn = arraySignIn;
	[self.navigationController pushViewController:wvli animated:YES];
	[wvli release];
}

-(void)callingMailClient {
	
	if([self.useremail isEqualToString:@""]) {
		
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Email currently not set." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertOnChoose show];
		[alertOnChoose release];
		return;
	}
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController") );
	if (mailClass != nil)
	{
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
		
		if (picker) {
			
			NSString *emailSubj;
			emailSubj = @"Mail via unsocial";
			[picker setSubject:emailSubj];
			
			NSArray *toRecipients = [NSArray arrayWithObject:self.useremail]; 
			[picker setToRecipients:toRecipients];
			picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
			[[self navigationController] presentModalViewController:picker animated:YES];
		}
		[picker release];
	}
}

-(void)callingTTForMessage {
	
	TTPostController *postController = [[TTPostController alloc] init]; 
	postController.delegate = self; // self must implement the TTPostControllerDelegate protocol 
	self.popupViewController = postController; 
	postController.superController = self; // assuming self to be the current UIViewController 
	postController.navigationItem.rightBarButtonItem.title = @"Send";
	[postController showInView:self.view animated:YES]; 
	[postController release];
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {

	if(messageType == 1) {
		
			// there were only YES and NO in previous versionn
		if(buttonIndex == 0){ // dont Send bcard -vaibhav(V1.1)
			
			flg4rply2 = 0;
			[self callingTTForMessage];
		}
		else if(buttonIndex == 1) { // send bacrd -vaibhav(V1.1)
			
			flg4rply2 = 1;
			[self callingTTForMessage];
		}
		else { // dont do anything -vaibhav(V1.1)
			
		}
		messageType = 0;
	}
	else if (messageType == 2) {
		
		if(buttonIndex == 0){
			
			NSLog(@"\nDialing a Number- %@", self.usercontact);
			UIApplication *app = [UIApplication sharedApplication];
			NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel:%@", self.usercontact]];
			[app openURL:url];
			messageType = 0;
		}
	}
	else {
		
		NSLog(@"%@", [NSString stringWithFormat:@"selected alert: %i",buttonIndex]);
		if(buttonIndex == 0) // no, here nothing happen since this condition is fullfill for more than on options i.e. for smart tag, for save (bookmark)
		{
		}
		else if(buttonIndex == 1) // yes
		{
			NSLog(@"yes");
			[self sendNow4SmartTagging:@"managetags"]; // for smart tagging
			//tagsadded = NO;
		}
	}
}

- (BOOL) sendNow4SmartTagging: (NSString *) flag {
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
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"smarttagging"]; // here is the diffrence between normal adding tags and adding smart tags (in case of adding normal tags flag2=aaa, and smart tagging flag2=smarttagging
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	//NSString *deviceTocken;
	
	NSString *CollectionTags = [NSString stringWithFormat:@"%@\r\n",[collectionAryKeywords objectAtIndex:0]];
	
	/*if ([[strCollectionTags objectAtIndex:0] isEqualToString:nil])
		CollectionTags = [NSString stringWithFormat:@"%@\r\n",@""];
	else CollectionTags = [NSString stringWithFormat:@"%@\r\n",strCollectionTags];*/
	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
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
	
	if ([flag isEqualToString:@"managetags"])
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"tags\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",CollectionTags] dataUsingEncoding:NSUTF8StringEncoding]];
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
				NSLog(@"\n\n\n\n\n\n#######################-- post for tags added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;				
				//useridForTable = [dic objectForKey:key];
				
				UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Tags added successfully to your “interested in” tags list!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			
				[alertOnChoose show];
				[alertOnChoose release];
			
				
				break;
			}			
		}		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
	//return;
}

- (void) getKeywordsForUser:(NSString *)inid {
	// Time Formats
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	NSString *urlString;
	urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=getkeywords&userid=%@&datetime=%@", userid, usertime];
	urlString = [globalUrlString stringByAppendingString:urlString];
	NSLog(@"%@", urlString);
	[self parseXMLFileAtURL:urlString];
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
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"])
	{
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		keywordName = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"])
	{
		// save values to an item, then store that item into the array...
		[item setObject:keywordName forKey:@"keywords"]; 
		[stories addObject:[item copy]];
		NSLog(@"%d ^^", [stories count]);
		
		NSLog(@"adding story keywordName: %@", keywordName);
		/*[aryKeyword addObject:keywordName];
		NSLog(@"aryKeyword has %d itmes", [aryKeyword count]);*/
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([currentElement isEqualToString:@"keywords"])
	{
		[keywordName appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
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

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [super dealloc];
}


@end
