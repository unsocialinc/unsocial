//
//  ShowNote.m
//  Unsocial
//
//  Created by vaibhavsaran on 28/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShowNote.h"
#import "ActivityViewForPeople.h"
#import "UnsocialAppDelegate.h"
#import "PeopleSendMessage.h"
#import "PeoplesUserProfile.h"
#import "GlobalVariables.h"
#import "Person.h"

int flg4rply;
//int isfirsttimeload;

@implementation ShowNote
@synthesize strAssociatedUserID,  strNoteHeader, strAssociatedUserName, strNoteCreationDate, strNoteId, strIsNoteRead, strAtEvent, strNoteCategory, strShortNote, strSavedAt, strPurpose, camefromwhichoption, eventid4attendeelistofnormalevent;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated 
//- (void) viewDidLoad
{
	NSLog(@"call viewDidAppear load");
	[super viewDidAppear:animated];
	//[super viewDidLoad];
	
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	activityView.hidden = YES;
	loading.hidden = YES;
	//if (isfirsttimeload==0)
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
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(btnDelete_Click)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(btnEditNote_Click)] autorelease];
	
	UIImageView *imgMsgBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 5, 320, 363) imageName:@"notedetail.png"];
	[self.view addSubview:imgMsgBack];
	
	NSString *frmto;	
	//if ([strPurpose compare:@"inbox"] == NSOrderedSame)
	{
		frmto = [strNoteHeader stringByAppendingString:@": "];
		//if([strIsNoteRead compare:@"1"] == NSOrderedSame)
			//[self sendNow4DeleteNUpdateNote:@"updatereadmsg"]; // for updating msg as read
	}
	//else frmto = @"To: ";
	
	if ([strNoteHeader compare:@"Profile Saved"] == NSOrderedSame)
	{
		// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
		//lblFrom = [UnsocialAppDelegate createLabelControl:frmto frame:CGRectMake(15, imgMsgBack.frame.origin.y + 7, 290, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		lblFrom = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:frmto frame:CGRectMake(15, imgMsgBack.frame.origin.y + 7, 290, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		// end 17 august 2011
		
	}
	else {
		// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
		//lblFrom = [UnsocialAppDelegate createLabelControl:@"My Note" frame:CGRectMake(15, imgMsgBack.frame.origin.y + 7, 290, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		lblFrom = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"My Note" frame:CGRectMake(15, imgMsgBack.frame.origin.y + 7, 290, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		// end 17 august 2011
	}
	
	[self.view addSubview:lblFrom];	
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 135, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor darkGrayColor] backgroundcolor:[UIColor clearColor]];*/

	// Load the sound
    /*id sndpath = [[NSBundle mainBundle] pathForResource:@"mailsent" ofType:@"wav"];
	CFURLRef baseURL = (CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpath];
	AudioServicesCreateSystemSoundID (baseURL, &beep);*/
	
	// commented by pradeep on 3 august 2011 for fixing memory issue
	//[imgMsgBack release];
	// end 3 august 2011 for fixing memory issue
}

/*- (void) playSound {
	AudioServicesPlaySystemSound (beep);
}*/

// added by pradeep on 20 april 2011 for getting height of dynamic text for label
/*- (CGFloat)HeightOfText:(NSString *)textToMesure widthOfLabel:(CGFloat)width
{
    UIFont *textFont = [UIFont systemFontOfSize:12];
    CGSize ts = [textToMesure sizeWithFont:textFont constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    return ts.height+5.0; //you can change the last number to fit the space you wish to have between the labels.
}*/

// added by pradeep on 13 july 2011 for add (+) btn for adding note feature start
#pragma mark add note feature start

- (void) btnEditNote_Click {
	
	/*alertviewtype = 1;
	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Update Note"];
	[dialog setMessage:@"\n\n\n\n\n"];
	[dialog addButtonWithTitle:@"Cancel"];
	[dialog addButtonWithTitle:@"Update"];
	
	tvNote = [[UITextView alloc] initWithFrame:CGRectMake(20.0, 40.0, 245.0, 110.0)];
	//if ([strShortNote compare:@""]==NSOrderedSame)
	//{
	//	tvNote.text = [[[[[@"added " stringByAppendingString:strAssociatedUserName] stringByAppendingString:@" at "] stringByAppendingString:strSavedAt] stringByAppendingString:@" on "] stringByAppendingString:strNoteCreationDate];
	//}
	//else {
	tvNote.text = strShortNote;
	//}

	//tvNote.text = @"";
	tvNote.delegate = self;
	tvNote.returnKeyType = UIReturnKeyDefault;
	tvNote.keyboardType = UIKeyboardTypeDefault;
	tvNote.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
	tvNote.layer.cornerRadius = 5;
	[tvNote setBackgroundColor:[UIColor whiteColor]];
	[dialog addSubview:tvNote];
	[tvNote becomeFirstResponder];
	//CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, -100.0);
	//[dialog setTransform: moveUp];
	[dialog show];
	[dialog release];
	//[tvNote release];
	//messageType = 3;*/
	
	TTPostController *postController = [[TTPostController alloc] init]; 
	postController.delegate = self; // self must implement the TTPostControllerDelegate protocol 
	self.popupViewController = postController; 
	postController.navigationItem.rightBarButtonItem.title = @"Update";
	postController.textView.text = strShortNote;
	postController.superController = self; // assuming self to be the current UIViewController 
	[postController showInView:self.view animated:YES]; 
	[postController release];
}

// added by pradeep on 9 august 2011 for making save notes UI similar to send msg UI of Inbox feature

- (BOOL) postController:	(TTPostController *) 	postController willPostText: (NSString *) text {
	
	//NSLog(@"Text: %@", text); 
	/*if([text compare:nil] == NSOrderedSame || [text compare:@""] == NSOrderedSame)
	 {
	 errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Please write message." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	 [errorAlert show];
	 [errorAlert release];
	 return NO;
	 }
	 else*/ {
		 return YES;
	 }
}

- (void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result { 
	
	//NSString *updatedtxt = text;
	BOOL isuserbookmarked = [self updateNoteRequest:text];
	if (isuserbookmarked)
	{
		UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Note updated successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alertOnChoose show];
		[alertOnChoose release];
		
		strShortNote = text;
		
		//isfirsttimeload=1;
		//self.navigationItem.rightBarButtonItem = nil;
		
		//tvNoteDecr.text = updatedtxt;		
		// since after disappearing ttviewcontrol, viewdidappear calls
	}
	else 
	{
		//if ([alreadybookmark isEqualToString:@"alreadybookmark"])
		{
			UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Note has not updated successfully, please try again later!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alertOnChoose show];
			[alertOnChoose release];
			self.navigationItem.rightBarButtonItem = nil;
		}
	}
}

// end 9 august 2011

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	//printf("\nshouldChangeTextInRange\n");
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 200) ? NO : YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	printf("\nDid begin editing\n");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	printf("\nDid end editing\n");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
    [textField resignFirstResponder];
	printf("\nClearing Keyboard\n");
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	// provide my own Save button to dismiss the keyboard
	
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex 
{	
	if (alertviewtype == 1)
	{
		if(buttonIndex == 0)
		{
			
			//[tvNote resignFirstResponder];
		}
		else 
		{
			
			BOOL isuserbookmarked = [self updateNoteRequest:@""];
			if (isuserbookmarked)
			{
				UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Note updated successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
				[alertOnChoose show];
				[alertOnChoose release];
				self.navigationItem.rightBarButtonItem = nil;
				
				tvNoteDecr.text = tvNote.text;				
			}
			else 
			{
				//if ([alreadybookmark isEqualToString:@"alreadybookmark"])
				{
					UIAlertView *alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"Note has not updated successfully, please try again later!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
					[alertOnChoose show];
					[alertOnChoose release];
					self.navigationItem.rightBarButtonItem = nil;
				}
			}
			
			[tvNote resignFirstResponder];
			self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(btnEditNote_Click)] autorelease];
		}
	}
	else if (alertviewtype ==2) // for deleting notes
	{
		if(buttonIndex == 0) // for NO
		{
		}
		else // for YES
		{
			
			[self.view addSubview:imgBack];
			[self.view addSubview:activityView];
			activityView.hidden = NO;
			
			// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
			//loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 135, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor darkGrayColor] backgroundcolor:[UIColor clearColor]];
			loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 135, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor darkGrayColor] backgroundcolor:[UIColor clearColor]];
			// end 17 august 2011
			
			loading.hidden = NO;
			[self.view addSubview:loading];
			
			
			[activityView startAnimating];
			[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
		}
		
	}
}

- (BOOL) updateNoteRequest: (NSString *) notetxt {
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"updatenotetext"];
	
	// commented added by pradeep on 6 july 2011 for adding NOTE feature
	//NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
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
	
	NSString *strnoteid = [NSString stringWithFormat:@"%@\r\n",strNoteId];
	
	
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
	
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"noteid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strnoteid] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// added by pradeep on 6 july 2011 for adding NOTE feature
	
	if ([camefromwhichoption compare:NULL]==NSOrderedSame)
		camefromwhichoption = @"mynote";
	
	NSLog(@"camefromwhichoption: %@", camefromwhichoption);	
	
	
	NSString *shortnote = [NSString stringWithFormat:@"%@\r\n",notetxt];
	
	/*NSString *notecategory;
	
	notecategory = [NSString stringWithFormat:@"%@\r\n",camefromwhichoption];
		
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"notecategory\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",notecategory] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];*/
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"shortnote\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",shortnote] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	/*if (camefromwhichoption == @"liveattendeelist")
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
		
	}*/
	
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
	//alreadybookmark = nil;
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Userid"])
		{
			//userid = [dic objectForKey:key];
			
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				
				NSLog(@"\n\n\n\n\n\n#######################-- post for note added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				//messageType = 0;
				break;
			}			
		}
		else if ([key isEqualToString:@"Notsuccess"])
		{
			//userid = [dic objectForKey:key];
			
			if ([[dic objectForKey:key] isEqualToString:@"Note has not added successfully"])
			{
				
				NSLog(@"\n\n\n\n\n\n#######################-- post for note has not added successfully --#######################\n\n\n\n\n\n");
				//messageType = 0;
				//alreadybookmark = @"alreadybookmark";
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

#pragma mark end note feature

#pragma mark delete note start


 - (void)startProcess {
 
 		
 [self sendNow4DeleteNUpdateNote:@"deletenote"];
 //isfirsttimeload=0;
 [activityView stopAnimating];
 [self.navigationController popViewControllerAnimated:YES];
 }
 
 - (NSInteger) sendNow4DeleteNUpdateNote: (NSString *) flag 
{
	NSLog(@"Sending 4 DeleteNUpdateNote....");
	//NSData *imageData1;
	
	
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
	
	NSString *varNoteId = [NSString stringWithFormat:@"%@\r\n",strNoteId];	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"noteid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varNoteId] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
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
		if ([key isEqualToString:@"Totunreadmsg"])
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				if ([flag compare:@"deletemessage"] == NSOrderedSame)
					NSLog(@"\n\n\n\n\n\n#######################-- post For Delete Note Executed successfully --#######################\n\n\n\n\n\n");
				else if ([flag compare:@"updatereadmsg"] == NSOrderedSame)
					NSLog(@"\n\n\n\n\n\n#######################-- post For updating read note Executed successfully --#######################\n\n\n\n\n\n");
				unreadmsg = [[dic objectForKey:key] intValue];				
				successflg=YES;				
				//userid = [dic objectForKey:key];
				
				NSString *strbadgevalue = [NSString stringWithFormat:@"%i", unreadmsg];
				if(unreadmsg != 0)
					inBoxviewcontroller.tabBarItem.badgeValue = strbadgevalue;
				else if (unreadmsg==0)
					inBoxviewcontroller.tabBarItem.badgeValue= nil;
				
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

#pragma mark delete note end

// end by pradeep on 13 july 2011 for add (+) btn for adding note feature

- (void)createControls {

	fromName = [UnsocialAppDelegate createLabelControl:strAssociatedUserName frame:CGRectMake(lblFrom.frame.origin.x, lblFrom.frame.origin.y + 15, 290, 15) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:fromName];
	
	//CGFloat lblSavedAtHeight = [self HeightOfText:[@"At: " stringByAppendingString:strSavedAt] widthOfLabel:290.0]+lblFrom.frame.origin.y + 25;
	
	savedAt = [UnsocialAppDelegate createLabelControl:[@"At: " stringByAppendingString:strSavedAt] frame:CGRectMake(lblFrom.frame.origin.x, fromName.frame.origin.y+30, 290, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	//[savedAt sizeToFit];
	[self.view addSubview:savedAt];
	
	//CGFloat lblSavedDateHeight = [self HeightOfText:[@"On: " stringByAppendingString:strNoteCreationDate] widthOfLabel:290.0]+60;
	
	
	savedDate = [UnsocialAppDelegate createLabelControl:[@"On: " stringByAppendingString:strNoteCreationDate] frame:CGRectMake(lblFrom.frame.origin.x, savedAt.frame.origin.y+30, 290, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	//[savedDate sizeToFit];
	[self.view addSubview:savedDate];
	
	if ([strAtEvent compare:@""]!=NSOrderedSame)
	{
		//CGFloat lblEventHeight = [self HeightOfText:[@"At Event: " stringByAppendingString:strAtEvent] widthOfLabel:290.0]+lblSavedDateHeight;
		
		lblAtEvent = [UnsocialAppDelegate createLabelControl:[@"Event: " stringByAppendingString:strAtEvent] frame:CGRectMake(lblFrom.frame.origin.x, savedDate.frame.origin.y+30, 290, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		//[lblAtEvent sizeToFit];
		[self.view addSubview:lblAtEvent];
		
		//CGFloat lblNoteHeight = [self HeightOfText:@"Note:" widthOfLabel:290.0]+lblEventHeight;
		
		lblNote = [UnsocialAppDelegate createLabelControl:@"Note:" frame:CGRectMake(lblFrom.frame.origin.x, lblAtEvent.frame.origin.y+30, 290, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		//[lblNote sizeToFit];
		[self.view addSubview:lblNote];
		
		NSString *strnote;
		if ([strShortNote compare:@""]==NSOrderedSame)
		{
			strnote = [[[[[@"added " stringByAppendingString:strAssociatedUserName] stringByAppendingString:@" at "] stringByAppendingString:strSavedAt] stringByAppendingString:@" on "] stringByAppendingString:strNoteCreationDate];
		}
		else {
			strnote = strShortNote;
		}
		//CGFloat lblNoteDecrHeight = [self HeightOfText:strnote widthOfLabel:290.0]+lblNoteHeight;
		
		NSLog(@"desc: %@", strnote);
		tvNoteDecr = [UnsocialAppDelegate createTextViewControl:strnote frame:CGRectMake(lblFrom.frame.origin.x, lblNote.frame.origin.y+30, 290, 180) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:12 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
		tvNoteDecr.contentInset = UIEdgeInsetsMake(-4.00, -8.00, 0.00, 0.00);
		[self.view addSubview:tvNoteDecr];
	}
	else 
	{
		//CGFloat lblNoteHeight = [self HeightOfText:@"Note:" widthOfLabel:290.0]+lblSavedDateHeight;
		
		lblNote = [UnsocialAppDelegate createLabelControl:@"Note:" frame:CGRectMake(lblFrom.frame.origin.x, savedDate.frame.origin.y+30, 290, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		//[lblNote sizeToFit];
		[self.view addSubview:lblNote];
		
		NSString *strnote;
		if ([strShortNote compare:@""]==NSOrderedSame)
		{
			strnote = [[[[[@"added " stringByAppendingString:strAssociatedUserName] stringByAppendingString:@" at "] stringByAppendingString:strSavedAt] stringByAppendingString:@" on "] stringByAppendingString:strNoteCreationDate];
		}
		else {
			strnote = strShortNote;
		}

		
		//CGFloat lblNoteDecrHeight = [self HeightOfText:strnote widthOfLabel:290.0]+lblNoteHeight;
		
		tvNoteDecr = [UnsocialAppDelegate createTextViewControl:strnote frame:CGRectMake(lblFrom.frame.origin.x, lblNote.frame.origin.y+30, 290, 180) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:12 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
		tvNoteDecr.contentInset = UIEdgeInsetsMake(-4.00, -8.00, 0.00, 0.00);
		[self.view addSubview:tvNoteDecr];
	}

	
	
	
	
	
	/*msgDescription = [UnsocialAppDelegate createTextViewControl:strMsgDescription frame:CGRectMake(lblFrom.frame.origin.x, lblMsgDecr.frame.origin.y + 15, 290, 255) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:13 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	msgDescription.contentInset = UIEdgeInsetsMake(-4.00, -8.00, 0.00, 0.00);
	[self.view addSubview:msgDescription];*/
	
	// user profile button	
	UIButton *btnProfile1 = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnProfile_Click) frame:CGRectMake(lblFrom.frame.origin.x, lblFrom.frame.origin.y + 15, 290, 50) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor blackColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	
	
	UIButton *btnProfile = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnProfile_Click) frame:CGRectMake(280, 5, 30, 50) imageStateNormal:@"tipsright1.png" imageStateHighlighted:@"tipsright2.png" TextColorNormal:[UIColor blackColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	
	
	if ([strPurpose compare:@"singleuser"] == NSOrderedSame) // if user landed from userprofile > mynote > show note then no need to show btn by which user see the profile of profile saved user
	{
		
	}
	else // user can see saved person's profile i.e. user come here from dashboard's icon "MY NOTE"
	{
		if ([strAssociatedUserName compare:@""] != NSOrderedSame) 
		{
			[self.view addSubview:btnProfile1];
			[self.view addSubview:btnProfile];
		}
	}
	
	btnDeleteNote = [UnsocialAppDelegate createButtonControl:@"Delete Note" target:self selector:@selector(btnDelete_Click) frame:CGRectMake(110, 385, 100, 29) imageStateNormal:@"longbutton1.png" imageStateHighlighted:@"longbutton2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnDeleteNote.titleLabel setFont:[UIFont fontWithName:kAppFontName size:11.5]];
	
	[self.view addSubview:btnDeleteNote];	
	
	/*UIButton *btnReply = [UnsocialAppDelegate createButtonControl:@"Reply" target:self selector:@selector(btnReply_Click) frame:CGRectMake(128, 380, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnReply];
	[btnReply release];
	
	UIButton *btnDelete = [UnsocialAppDelegate createButtonControl:@"Reply with business card" target:self selector:@selector(btnReplyWithBusinessCard_Click) frame:CGRectMake(70, 375, 180, 26) imageStateNormal:@"btnBack.png" imageStateHighlighted:@"btnBack.png" TextColorNormal:[UIColor blackColor] TextColorHighlighted:[UIColor redColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[btnDelete.titleLabel setFont:[UIFont fontWithName:kAppFontName size:13]];
	
	NSString *strbadgevalue = [NSString stringWithFormat:@"%i", unreadmsg];
	if(unreadmsg != 0)
		inBoxviewcontroller.tabBarItem.badgeValue = strbadgevalue;
	else if (unreadmsg==0)
		inBoxviewcontroller.tabBarItem.badgeValue= nil;*/
}

/*- (void)willPresentAlertView:(UIAlertView *)alertView {
	
	[[[alertView subviews] objectAtIndex:1] setBackgroundColor:[UIColor colorWithRed:0.5 green:0.0f blue:0.0f alpha:1.0f]];
}*/

- (void)btnProfile_Click {
	
//	[self getProfile:@""];
	
	ActivityViewForPeople *peoplesUserProfile = [[ActivityViewForPeople alloc]init];
	peoplesUserProfile.strFrom = strAssociatedUserID;
	
	/*peoplesUserProfile.userid = [[stories objectAtIndex:0] objectForKey:@"guid"];
	peoplesUserProfile.username = [[stories objectAtIndex:0] objectForKey:@"username"];
	peoplesUserProfile.myname  = [myName objectAtIndex:0];
	peoplesUserProfile.userprefix = [[stories objectAtIndex:0] objectForKey:@"prefix"];
	
	peoplesUserProfile.useremail = [[stories objectAtIndex:0] objectForKey:@"email"];
	peoplesUserProfile.usercontact = [[stories objectAtIndex:0] objectForKey:@"contact"];	
	peoplesUserProfile.usercompany = [[stories objectAtIndex:0] objectForKey:@"company"];	
	peoplesUserProfile.userwebsite = [[stories objectAtIndex:0] objectForKey:@"userwebsite"];
	peoplesUserProfile.userlinkedin = [[stories objectAtIndex:0] objectForKey:@"linkedinprofile"];	
	peoplesUserProfile.userabout = [[stories objectAtIndex:0] objectForKey:@"aboutu"];	
	peoplesUserProfile.userind = [[stories objectAtIndex:0] objectForKey:@"industry"];	
	peoplesUserProfile.usersubind = [[stories objectAtIndex:0] objectForKey:@"subindustry"];
	peoplesUserProfile.userrole = [[stories objectAtIndex:0] objectForKey:@"role"];	
	peoplesUserProfile.userintind = [[stories objectAtIndex:0] objectForKey:@"interestind"];
	
	peoplesUserProfile.userintsubind = [[stories objectAtIndex:0] objectForKey:@"interestsubind"];	
	peoplesUserProfile.userintrole = [[stories objectAtIndex:0] objectForKey:@"interestrole"];
	peoplesUserProfile.userdisplayitem = [[stories objectAtIndex:0] objectForKey:@"displayitem"];	
	peoplesUserProfile.userintind = [[stories objectAtIndex:0] objectForKey:@"interestind"];
	peoplesUserProfile.fullImg = [[stories objectAtIndex:0] objectForKey:@"itemPicture"];
	//peoplesUserProfile.profileforwhichtab = [[stories objectAtIndex:0] objectForKey:@"forwhichtab"];*/
	
	[self.navigationController pushViewController:peoplesUserProfile animated:YES];
	[peoplesUserProfile release];
}

// added comment by pradeep on 15 march 2011
// not in use getProfile method written below
/*- (void) getProfile:(NSString *) flg4whichtab {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	// Time Formats
	
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	//dt = [[dt substringFromIndex:0] substringToIndex:19];
	
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *usertime = [myArray objectAtIndex:0];
	
	//[collectionindustry stringByAppendingString:@","] stringByAppendingString:[interestedIndustryIds1 objectAtIndex:i]
	
	// since blank space etc occurs problem in sending request to perticular url
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:1]];
	usertime = [[usertime stringByAppendingString:@"$"] stringByAppendingString:[myArray objectAtIndex:2]];
	
	//NSString *distance = @"1"; // it should be retrieved from file that contains the set value
	
	// retreiving HH:MM from HH:MM:SS using substring
	//usertime = [[usertime substringFromIndex:0] substringToIndex:5];
	
	//if ( [gbluserid compare:@""] == NSOrderedSame || !gbluserid)
	//	gbluserid = @"none";
	gbluserid = [arrayForUserID objectAtIndex:0];
	
	NSLog(@"Sending....");
	NSString *urlString = [NSString stringWithFormat:@"/iphone/iPhoneReqPage1_1.aspx?flag=%@&latitude=%@&longitude=%@&userid=%@&datetime=%@&flag2=%@",@"getuserprofile",gbllatitude,gbllongitude,gbluserid,usertime,strFrom];
	urlString = [globalUrlString stringByAppendingString:urlString];
	
	NSLog(@"%@", urlString);
	
	//old request format
	//NSString *urlString = [NSString stringWithFormat:@"http://rstrings.com/eatngo/iPhone/IPhoneEatNGoRSS.aspx?flg=%@&latitude=%@&longitude=%@",@"bestdeal",latstr,longstr];
	//new request format
	//NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.10/eatngo/iPhone/IPhoneEatNGoRSS.aspx?flg=%@&latitude=%@&longitude=%@&reqtime=%@&location=%@&searchfilter=%@",@"opennow",latstr,longstr,usertime,currentlocation,searchcriteria];
	//NSString *urlString = [NSString stringWithFormat:@"http://rstrings.com/eatngo/iPhone/IPhoneEatNGoRSS.aspx?flg=%@&latitude=%@&longitude=%@&reqtime=%@&location=%@&searchfilter=%@",@"opennow",latstr,longstr,usertime,currentlocation,searchcriteria];
	//NSString *urlString = [NSString stringWithFormat:@"http://rstrings.com/eatngo/iPhone/IPhoneEatNGoRSS.aspx?flg=%@&latitude=%@&longitude=%@&reqtime=%@&location=%@&searchfilter=%@",@"opennow",latstr,longstr,usertime,currentlocation,searchcriteria];
	[self parseXMLFileAtURL:urlString];	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//return successflg;
	[pool release];
}*/

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
	errorAlert = [[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		userid = [[NSMutableString alloc] init];
		userdevicetocken= [[NSMutableString alloc] init];
		userprefix = [[NSMutableString alloc] init];
		username = [[NSMutableString alloc] init];
		useremail = [[NSMutableString alloc] init];
		userlastuse = [[NSMutableString alloc] init];
		usercontact = [[NSMutableString alloc] init];
		
		usercompany = [[NSMutableString alloc] init];
		userwebsite = [[NSMutableString alloc] init];
		userlinkedin = [[NSMutableString alloc] init];
		userabout = [[NSMutableString alloc] init];
		userind = [[NSMutableString alloc] init];
		usersubind = [[NSMutableString alloc] init];
		userrole = [[NSMutableString alloc] init];
		userallownotification = [[NSMutableString alloc] init];
		userinterestind = [[NSMutableString alloc] init];
		userinterestsubind = [[NSMutableString alloc] init];
		userinterestrole = [[NSMutableString alloc] init];		
		userprofilecomplete = [[NSMutableString alloc]init];
		userdisplayitem = [[NSMutableString alloc]init];
		usersecuritylevel = [[NSMutableString alloc]init];
		userlinkedinemailid = [[NSMutableString alloc]init];
		usertitle = [[NSMutableString alloc]init];
	}
	if ([elementName isEqualToString:@"enclosure"]) {
		currentImageURL = [attributeDict valueForKey:@"url"];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		// save values to an item, then store that item into the array...
		[item setObject:userprefix forKey:@"prefix"];
		[item setObject:userid forKey:@"guid"];
		[item setObject:userdevicetocken forKey:@"devicetocken"]; 
		[item setObject:username forKey:@"username"]; // for blog description also date but not rite now
		[item setObject:useremail forKey:@"email"];
		
		[item setObject:userlastuse forKey:@"logindate"];
		[item setObject:usercontact forKey:@"contact"];
		[item setObject:usercompany forKey:@"company"];
		[item setObject:userwebsite forKey:@"userwebsite"];
		[item setObject:userlinkedin forKey:@"linkedinprofile"];
		[item setObject:userabout forKey:@"aboutu"];
		
		[item setObject:userind forKey:@"industry"];
		[item setObject:usersubind forKey:@"subindustry"];
		[item setObject:userrole forKey:@"role"];
		[item setObject:userallownotification forKey:@"allownotification"];
		[item setObject:userinterestind forKey:@"interestind"];		
		[item setObject:userinterestsubind forKey:@"interestsubind"];		
		[item setObject:userinterestrole forKey:@"interestrole"];		
		[item setObject:userprofilecomplete forKey:@"profilecomplete"];
		[item setObject:userdisplayitem forKey:@"displayitem"];		
		[item setObject:usersecuritylevel forKey:@"securitylevel"];
		[item setObject:userlinkedinemailid forKey:@"linkedinemailid"];
		[item setObject:usertitle forKey:@"usertitle"];
		
		//add the actual image as well right now into the stories array
		
		NSURL *url = [NSURL URLWithString:currentImageURL];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *y1 = [[UIImage alloc] initWithData:data];
		if (y1) {
			[item setObject:y1 forKey:@"itemPicture"];		
		}
		
		[stories addObject:[item copy]];
		
		NSLog(@"adding story: %@", username);		
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"prefix"]) {
		[userprefix appendString:string];
	}else if ([currentElement isEqualToString:@"guid"]) {
		[userid appendString:string];
	}else if ([currentElement isEqualToString:@"devicetocken"]) {
		[userdevicetocken appendString:string];
	}else if ([currentElement isEqualToString:@"username"]) {
		[username appendString:string];
	} 
	
	else if ([currentElement isEqualToString:@"email"]) {
		[useremail appendString:string];
	}else if ([currentElement isEqualToString:@"logindate"]) {
		[userlastuse appendString:string];
	}else if ([currentElement isEqualToString:@"contact"]) {
		[usercontact appendString:string];
	}else if ([currentElement isEqualToString:@"company"]) {
		[usercompany appendString:string];
	}else if ([currentElement isEqualToString:@"userwebsite"]) {
		[userwebsite appendString:string];
	}else if ([currentElement isEqualToString:@"linkedinprofile"]) {
		[userlinkedin appendString:string];
	}else if ([currentElement isEqualToString:@"aboutu"]) {
		[userabout appendString:string];
	}else if ([currentElement isEqualToString:@"industry"]) {
		[userind appendString:string];
	}else if ([currentElement isEqualToString:@"subindustry"]) {
		[usersubind appendString:string];
	}else if ([currentElement isEqualToString:@"role"]) {
		[userrole appendString:string];
	}else if ([currentElement isEqualToString:@"allownotification"]) {
		[userallownotification appendString:string];
	}else if ([currentElement isEqualToString:@"interestind"]) {
		[userinterestind appendString:string];
	}else if ([currentElement isEqualToString:@"interestsubind"]) {
		[userinterestsubind appendString:string];
	}else if ([currentElement isEqualToString:@"interestrole"]) {
		[userinterestrole appendString:string];
	}else if ([currentElement isEqualToString:@"profilecomplete"]) {
		[userprofilecomplete appendString:string];
	}else if ([currentElement isEqualToString:@"displayitem"]) {
		[userdisplayitem appendString:string];
	}else if ([currentElement isEqualToString:@"securitylevel"]) {
		[usersecuritylevel appendString:string];
	}else if ([currentElement isEqualToString:@"currentdistance"]) {
		[usercurrentdistance appendString:string];
	}else if ([currentElement isEqualToString:@"forwhichtab"]) {
		[userforwhichtab appendString:string];
	}else if ([currentElement isEqualToString:@"linkedinemailid"]) {
		[userlinkedinemailid appendString:string];
	}else if ([currentElement isEqualToString:@"usertitle"]) {
		[usertitle appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {		
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	//[itemTableView reloadData];
}

- (void)btnDelete_Click {
	
	alertviewtype = 2;
	
	errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to delete this note?" delegate:self cancelButtonTitle:
				  @"NO" otherButtonTitles:
				  @"YES", nil];
	[errorAlert show];
	[errorAlert release];
}

- (void)btnReply_Click {
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to send your Business Card also?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"No", @"Yes", @"Cancel",  nil];
	actionSheet.cancelButtonIndex = 1;
	actionSheet.destructiveButtonIndex = 2;
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];
	// show from our table view (pops up in the middle of the table)
	[actionSheet release];

}

- (void)btnReplyWithBusinessCard_Click {	
}

/*- (BOOL) getDataFromFile1 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
		//open it and read it 
		NSLog(@"data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];
		//[self setPersonArray:tempArray];
		
		NSLog(@"%@", [[tempArray objectAtIndex:0] usersubind]);
		if ( [[[tempArray objectAtIndex:0] usersubind] compare:@""] == NSOrderedSame)
		{
			NSLog(@"subind blank");
		}
			
		
		currentusername = [[tempArray objectAtIndex:0] username];
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
		
		//if ( [username compare:@""] == NSOrderedSame || !username)
		if ( [[[tempArray objectAtIndex:0] userid] compare:@""] == NSOrderedSame || ![[tempArray objectAtIndex:0] userid])
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
}*/

- (BOOL) getDataFromFile2 {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial2"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]) {
		//open it and read it 
		NSLog(@"data file found. reading into memory");
		NSMutableData *theData;
		NSKeyedUnarchiver *decoder;
		NSMutableArray *tempArray;
		
		theData = [NSData dataWithContentsOfFile:path];
		decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:theData];
		tempArray = [decoder decodeObjectForKey:@"userInfo"];	
		
		NSLog(@"%@", [[tempArray objectAtIndex:0] username]);
		NSLog(@"%@", [[tempArray objectAtIndex:0] userid]);

		userInfoDic = [[NSMutableDictionary alloc] init];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] usercompany] forKey:@"usrcompany" ];// insertObject:newPerson atIndex:0];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userwebsite] forKey:@"usrwebsite" ];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userindustry] forKey:@"usrind" ];
		[userInfoDic setValue:[[tempArray objectAtIndex:0] userfunction] forKey:@"usrfunc"];
		
		[userInfo addObject:[userInfoDic copy]];
		
		NSLog(@"%@", [[userInfo objectAtIndex:0] objectForKey:@"usrcompany"]);
		
		if ([[[tempArray objectAtIndex:0] userid] compare:@""] == NSOrderedSame || ![[tempArray objectAtIndex:0] userid])
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

- (void)leftbtn_OnClick {
	//isfirsttimeload=0;
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
	[activityView release];
	//[loading release];
}


@end
