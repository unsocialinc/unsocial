//
//  Raffle.m
//  Unsocial
//
//  Created by Pradeep on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "Raffle.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "Person.h"

#define klabelFontSize  13

@implementation Raffle
@synthesize userid, featureid, eventid, featuretypeid, featuretypename, featuredispname;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	[activityView stopAnimating];
	[self createControls];
	activityView.hidden = loading.hidden = YES;
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
		
	// end 1 june 2011
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	[imgBack release];
			
	UILabel *heading = [UnsocialAppDelegate createLabelControl:featuredispname frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(20, 150, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	// 13 may 2011 by pradeep //[loading release];
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
- (void)rightbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	[self dismissModalViewControllerAnimated:YES];
}
// end 1 june 2011

- (void)createControls {
	
	NSString *raffleresult = [self getRaffleTicket:@"getraffleticket" :featureid];
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 40, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	//imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 107, 260, 2) imageName:@"dashboardhorizontal.png"];
	//[self.view addSubview:imgHorSep];
	//[imgHorSep release];
	
	
	//[NSString stringWithFormat:@"Your ticket id is %@ waiting for results.", [aryraffleticketid objectAtIndex:0]]
	if ([aryraffledesc count] > 0) // added by pradeep on 15 oct 2010 for raffle desc has not added yet by admin
	{
		//UILabel *lblRaffleDesc = [UnsocialAppDelegate createLabelControl:[aryraffledesc objectAtIndex:0] frame:CGRectMake(20, 20, 280, 180) txtAlignment:UITextAlignmentLeft numberoflines:10 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:14 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		//[self.view addSubview:lblRaffleDesc];
		
		UITextView *lblRaffleDesc = [UnsocialAppDelegate createTextViewControl:[aryraffledesc objectAtIndex:0] frame:CGRectMake(20, 50, 290, 150) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:14 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
		lblRaffleDesc.showsVerticalScrollIndicator = YES;
		lblRaffleDesc.scrollsToTop = YES;
		//lblRaffleDesc.contentInset = UIEdgeInsetsMake(-4, -8, 0, 0);
		[lblRaffleDesc flashScrollIndicators];
		[self.view addSubview:lblRaffleDesc];
	}
	
	UILabel *lblRaffleTicket = [UnsocialAppDelegate createLabelControl:raffleresult frame:CGRectMake(20, 210, 280, 80) txtAlignment:UITextAlignmentCenter numberoflines:4 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:15 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblRaffleTicket];
	
}

- (NSString *) getRaffleTicket: (NSString *) flag : (NSString *) featid {
	NSLog(@"Sending.... 4 getRaffleTicket");
	//NSData *imageData1;
	
	
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
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",featid];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	//NSString *varMessageId = [NSString stringWithFormat:@"%@\r\n",strMsgId];	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
	NSString *strLiveNowEventID = [NSString stringWithFormat:@"%@\r\n",[liveNowEventID objectAtIndex:0]];
	
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
	
	/*[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventfeatid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	 [body appendData:[[NSString stringWithFormat:@"\r\n%@",varMessageId] dataUsingEncoding:NSUTF8StringEncoding]];
	 [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];*/
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"strlivenoweventid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strLiveNowEventID] dataUsingEncoding:NSUTF8StringEncoding]];
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
	BOOL raffledesc = NO;
	NSString *raffleticketid = @"";
	aryraffledesc = [[NSMutableArray alloc] init];
	aryraffleticketid = [[NSMutableArray alloc] init];
	aryraffleresult = [[NSMutableArray alloc] init];
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Result"])			
		{
			if ([[dic objectForKey:key] compare:@"Reported"] == NSOrderedSame)
			{
				NSLog(@"\n\n\n\n\n\n#######################-- Request submitted and ticket generated successfully --#######################\n\n\n\n\n\n");
				raffleticketid = [dic objectForKey:key];				
				successflg=YES;				
				raffledesc = YES;
				//break;
			}
			if ([[dic objectForKey:key] isEqualToString:@"Already reported"])
			{
				NSLog(@"\n\n\n\n\n\n#######################-- Request already submitted --#######################\n\n\n\n\n\n");
				//raffleticketid = [dic objectForKey:key];				
				successflg=YES;				
				raffledesc = YES;
				
				//break;
			}
			if ([[dic objectForKey:key] isEqualToString:@"Raffleticket not generated"])
			{
				NSLog(@"\n\n\n\n\n\n#######################-- some issue arrises during creating raffle ticket --#######################\n\n\n\n\n\n");
				//raffleticketid = [dic objectForKey:key];				
				successflg=NO;	
				raffledesc = YES;
				
				
				//break;
			}
			if ([[dic objectForKey:key] isEqualToString:@"Raffledesc has not added yet"])
			{
				NSLog(@"\n\n\n\n\n\n#######################-- some issue arrises during creating raffle ticket --#######################\n\n\n\n\n\n");
				//raffleticketid = [dic objectForKey:key];				
				successflg=NO;				
				
				
				//break;
			}
		}
		if ([key isEqualToString:@"Raffleticketid"])			
		{
			[aryraffleticketid addObject:[dic objectForKey:key]]; 
		}
		if ([key isEqualToString:@"Raffledesc"])			
		{
			[aryraffledesc addObject:[dic objectForKey:key]]; 
		}
		if ([key isEqualToString:@"Raffleresult"])			
		{
			if ([[dic objectForKey:key] isEqualToString:@"Winner"])
			{
				[aryraffleresult addObject:[dic objectForKey:key]]; 
			}
			else if ([[dic objectForKey:key] isEqualToString:@"Looser"])
			{
				[aryraffleresult addObject:[dic objectForKey:key]]; 
			}
		}
	}
	NSString *resultdisplay = @"";
	if (successflg)
	{
		if ([aryraffleresult count] > 0)
		{
			if ([[aryraffleresult objectAtIndex:0] isEqualToString:@"Winner"])
				resultdisplay = [NSString stringWithFormat:@"Congratulations! You are the winner. Your ticket id is %@.", [aryraffleticketid objectAtIndex:0]];
			else resultdisplay = [NSString stringWithFormat:@"You are not a winner. Better luck next time.", [aryraffleticketid objectAtIndex:0]];
		}
		else {
			resultdisplay = [NSString stringWithFormat:@"Your ticket id is %@. Waiting for results.", [aryraffleticketid objectAtIndex:0]];
		}
	}
	else 
	{
		if (raffledesc)
			resultdisplay = [NSString stringWithFormat:@"Server is busy, your ticket is not generated. Please try again later."];
		else resultdisplay = [NSString stringWithFormat:@"There are no Raffle items to display right now!"];

	}


	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return resultdisplay;
	[pool release];
}
	
	


- (void)leftbtn_OnClick {
	
	//[self dismissModalViewControllerAnimated:YES];
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
