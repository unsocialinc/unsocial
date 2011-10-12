//
//  PeopleSendMessage.m
//  Unsocial
//
//  Created by vaibhavsaran on 23/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PeopleSendMessage.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"

@implementation PeopleSendMessage
@synthesize userid, sendReply;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	activityView.hidden = YES;
	[self createControls];
}

- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"ShowIndustryDetail view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	//add background color
	self.view.backgroundColor = color;
	
	// Main Back Image
	mainBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 44, 320, 410)];
	mainBackImage.image = [UIImage imageNamed:@"BlankTemplate2.png"];
	[self.view addSubview:mainBackImage];
	
	UIImageView *imgNav = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBarmodel.png"]];
	[self.view addSubview:imgNav];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Send Message " frame:CGRectMake(0, 45, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	CGRect coachFrame = CGRectMake(5, 5, 36, 28);
	UIButton *backBtn = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(leftbtn_OnClick) frame:coachFrame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:backBtn];
	
	btnDone = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnDone_OnClick:) frame:CGRectMake(266, 5, 50, 31) imageStateNormal:@"done.png" imageStateHighlighted:@"done2.png" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	btnDone.hidden = YES;
	[self.view addSubview:btnDone];
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"Sending message\nplease standby" frame:CGRectMake(25, 170, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor darkGrayColor] backgroundcolor:[UIColor clearColor]];*/
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 255, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {
	
	UITextField *txtBackOnly = [UnsocialAppDelegate createTextFieldControl:CGRectMake(5, 118, 310, 175) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor clearColor] setFontSize:kTextFieldFont setPlaceholder:@"" backgroundColor:[UIColor whiteColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDefault];
	txtBackOnly.userInteractionEnabled = NO;
	[self.view addSubview:txtBackOnly];
	
	textViewSendMsg = [[[UITextView alloc] initWithFrame:CGRectMake(3, 118, 310, 175)] autorelease];
	textViewSendMsg.textColor = [UIColor blackColor];
	textViewSendMsg.font = [UIFont fontWithName:@"Arial" size:15];
	textViewSendMsg.delegate = self;
	textViewSendMsg.showsVerticalScrollIndicator = YES;
	textViewSendMsg.backgroundColor = [UIColor clearColor];
	textViewSendMsg.returnKeyType = UIReturnKeyDefault;
	textViewSendMsg.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
	textViewSendMsg.scrollEnabled = YES;
	
	// this will cause automatic vertical resize when the table is resized
	textViewSendMsg.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	// note: for UITextView, if you don't like autocompletion while typing use:
	// myTextView.autocorrectionType = UITextAutocorrectionTypeNo;
	
	[self.view addSubview:textViewSendMsg];	

	UIButton *btnSend = [UnsocialAppDelegate createButtonControl:@"Send" target:self selector:@selector(btnSend_Click) frame:CGRectMake(125, 330, 71, 30) imageStateNormal:@"plainblue.png" imageStateHighlighted:@"plainblue2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor blackColor] showsTouch:NO buttonBackgroundColor:[UIColor whiteColor]];
	[btnSend.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
	[self.view addSubview:btnSend];
}

- (void)btnSend_Click {

	if([textViewSendMsg.text compare:nil] == NSOrderedSame || [textViewSendMsg.text compare:@""] == NSOrderedSame)
	{
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please write message." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		return;
	}
	
	[self.view addSubview:mainBackImage];
	[self.view addSubview:activityView];
	loading.text = @"Sending message\nplease standby";
	loading.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Sending message\nplease standby" frame:CGRectMake(25, 170, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor darkGrayColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	activityView.hidden = NO;
	[activityView startAnimating];
	[NSTimer scheduledTimerWithTimeInterval:0.50 target:self selector:@selector(sendMessage) userInfo:self.view repeats:NO];
}

- (void)goBackToViewController {
	
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL) sendMessage {
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
	if(sendReply == 2) {
		bookmarkedid = [NSString stringWithFormat:@"%@\r\n",userid];
		usrid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];
	}
	usrid = [NSString stringWithFormat:@"%@\r\n",userid];
	bookmarkedid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];
	NSString *strMessage = [NSString stringWithFormat:@"%@\r\n",textViewSendMsg.text];
	
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
		if ([key compare:@"Userid"] == NSOrderedSame)			
		{
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				
				NSLog(@"\n\n\n\n\n\n#######################-- post for Send Message added successfully --#######################\n\n\n\n\n\n");
				loading.hidden = NO;
				loading.text = @"Message Sent Susseccfully";
				[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goBackToViewController) userInfo:self.view repeats:NO];
				successflg=YES;
				break;
			}			
		}
		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	//NSData *returnRes = [returnString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	//now see what the status came back as
	//TSXMLParser *myparser = [[TSXMLParser alloc] init];
	//[myparser parseXMLFileAtData:(NSData *)returnRes];
	
	//NSLog(myparser.status);
	//NSLog(returnString);
	
	NSLog(returnString);
	
	//NSString *strraffleid = raffleid;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
	//return;
}

- (void)leftbtn_OnClick {	
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)btnDone_OnClick:(id)sender {
	// finish typing text/dismiss the keyboard by removing it as the first responder
	//
	[textViewSendMsg resignFirstResponder];
	btnDone.hidden = YES;
	//self.navigationItem.rightBarButtonItem = nil;	// this will remove the "save" button
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	// provide my own Save button to dismiss the keyboard
	UIBarButtonItem* saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
	btnDone.hidden = NO;
//	self.navigationItem.rightBarButtonItem = saveItem;
	[saveItem release];
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
