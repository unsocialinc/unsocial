//
//  ShowUnsocialMilesTips.m
//  Unsocial
//
//  Created by vaibhavsaran on 11/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShowUnsocialMilesTips.h"
#import "UnsocialAppDelegate.h"
#import "InviteUser.h"
#import "GlobalVariables.h"

int intX = 50;

@implementation ShowUnsocialMilesTips

@synthesize selectedoption;

- (void)viewDidAppear:(BOOL)animated {

	[activityView stopAnimating];
	
	
	NSString *tip1;
	if ([selectedoption compare:@"0"] == NSOrderedSame)
	{
		tip1 = @"Earn 200 miles each time you refer a friend. With refer a friend button.\n\nEarn 20 miles each time you start the application for frequently using this application, You will not earn extra miles if you’ve opened the app once in last 4 hours.\n\nEarn miles each time you change your location and start the application in a new location. You earn miles if you have moved and opend the app in a new location even within 4 hours.";
		tips = [UnsocialAppDelegate createTextViewControl:tip1 frame:CGRectMake(5, 50, 300, 350) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:kEventTableContent returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
	}
	else
	{
		tips.hidden = YES;
		//tip1 = @"Your unsocial miles will display miles earned so far with breakup: \n\n\n    Travel miles – \n\n     Referral miles – \n\n     Frequent use miles – \n\n     Total miles – ";
		//tips = [UnsocialAppDelegate createTextViewControl:tip1 frame:CGRectMake(5, 50, 300, 350) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:12 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];
		UILabel *subHeading = [UnsocialAppDelegate createLabelControl:@"Miles earned so far with breakup" frame:CGRectMake(15, 42, 290, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:12 txtcolor:[UIColor lightGrayColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:subHeading];
		// 13 may 2011 by pradeep //[subHeading release];
		
		lblMiles = [UnsocialAppDelegate createLabelControl:@"Travel Miles: " frame:CGRectMake(15, 50 + intX, 270, 25) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:lblMiles];
		// 13 may 2011 by pradeep //[lblMiles release];
		
		lblMiles = [UnsocialAppDelegate createLabelControl:@"Referral Miles: " frame:CGRectMake(15, 100 + intX, 270, 25) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:lblMiles];
		// 13 may 2011 by pradeep //[lblMiles release];
		
		lblMiles = [UnsocialAppDelegate createLabelControl:@"Frequent Miles: " frame:CGRectMake(15, 150 + intX, 270, 25) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:lblMiles];
		// 13 may 2011 by pradeep //[lblMiles release];
		
		lblMiles = [UnsocialAppDelegate createLabelControl:@"Total Miles: " frame:CGRectMake(15, 200 + intX, 270, 25) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:lblMiles];
		
		lblMilesValue1 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(170, 50 + intX, 270, 25) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:lblMilesValue1];
		// 13 may 2011 by pradeep //[lblMilesValue1 release];
		
		lblMilesValue2 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(170, 100 + intX, 270, 25) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:lblMilesValue2];
		// 13 may 2011 by pradeep //[lblMilesValue2 release];
		
		lblMilesValue3 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(170, 150 + intX, 270, 25) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:lblMilesValue3];
		// 13 may 2011 by pradeep //[lblMilesValue3 release];
		
		lblMilesValue4 = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(170, 200 + intX, 270, 25) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
		[self.view addSubview:lblMilesValue4];
		// 13 may 2011 by pradeep //[lblMilesValue4 release];
		[self getUnsocialMiles];
	}
			
	
	[self.view addSubview:tips];
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
	
	UIImageView *imgProfileBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 320, 359)];
	imgProfileBack.image = [UIImage imageNamed:@"peopleprofileback.png"];
	[self.view addSubview:imgProfileBack];
	
	NSString *strheading;
	if ([selectedoption compare:@"0"] == NSOrderedSame)
		strheading = @"Learn how to earn miles";
	else strheading = @"Your unsocial miles";
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:strheading frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(15, 40, 290, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor]];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	
}

- (void)leftbtn_OnClick {
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) getUnsocialMiles 
{
	NSLog(@"Sending 4 getUnsocialmiles....");
	//NSData *imageData1;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
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
	
	NSString *flg1 = [NSString stringWithFormat:@"%@\r\n",@"getunsocialmiles"];
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	NSString *varuserid = [NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]];	
	NSString *dt = [NSString stringWithFormat:@"%@\r\n", [UnsocialAppDelegate getLocalTime]];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = [userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@\r\n",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@\r\n",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@\r\n",gbllatitude];
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varuserid] dataUsingEncoding:NSUTF8StringEncoding]];
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
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//[activityView startAnimating];
	
    NSHTTPURLResponse *response11;
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response11 error:nil];
	
	NSLog(@"response header: %@", [response11 allHeaderFields]);
	
	NSDictionary *dic = [response11 allHeaderFields];
	BOOL successflg=NO;
	NSString *frequentmiles=@"0", *travelmiles=@"0", *referralmiles=@"0";
	
	for (id key in dic)
	{
		// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		/*if ([key compare:@"Userid"] == NSOrderedSame)			
		{
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				NSLog(@"\n\n\n\n\n\n#######################-- user unsocialmiles got successfully --#######################\n\n\n\n\n\n");
				if ([aryUsrStatus count] > 0)
					[aryUsrStatus removeAllObjects];
				[aryUsrStatus addObject:[dic objectForKey:key]];
				
			}
		}*/
		if ([key compare:@"Travelmiles"] == NSOrderedSame)			
		{
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				NSLog(@"\n\n\n\n\n\n#######################-- user travelmiles got successfully --#######################\n\n\n\n\n\n");
				travelmiles = [dic objectForKey:key];
				successflg = YES;
				
			}
		}
		if ([key compare:@"Referralmiles"] == NSOrderedSame)			
		{
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				NSLog(@"\n\n\n\n\n\n#######################-- user referralmiles got successfully --#######################\n\n\n\n\n\n");
				referralmiles = [dic objectForKey:key];
				successflg = YES;
			}
		}
		if ([key compare:@"Frequentmiles"] == NSOrderedSame)			
		{
			if ([[dic objectForKey:key] compare:@""] != NSOrderedSame)
			{
				NSLog(@"\n\n\n\n\n\n#######################-- user frequentmiles got successfully --#######################\n\n\n\n\n\n");
				frequentmiles = [dic objectForKey:key];
				successflg = YES;
			}
		}
		
		//break;
	}
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(returnString);
	int	totmile = [travelmiles intValue] + [referralmiles intValue] + [frequentmiles intValue];
	if (successflg)
	{
		lblMilesValue1.text = travelmiles;
		lblMilesValue2.text = referralmiles;
		lblMilesValue3.text = frequentmiles;
		lblMilesValue4.text = [NSString stringWithFormat:@"%i",totmile];
		
		imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(15, 240, 290, 2) imageName:@"dashboardhorizontal.png"];
		[self.view addSubview:imgHorSep];
		// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
		//[imgHorSep release];
		// end 3 august 2011 for fixing memory issue

		imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(30, 80, 260, 2) imageName:@"dashboardhorizontal.png"];
		[self.view addSubview:imgHorSep];
		// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
		//[imgHorSep release];
		// end 3 august 2011 for fixing memory issue
		
	}
		
//	tips.text = [NSString stringWithFormat:@"Your unsocial miles will display miles earned so far with breakup: \n\n\n    Travel miles – %@ \n\n     Referral miles – %@ \n\n     Frequent use miles – %@ \n\n     Total miles – %i",travelmiles,referralmiles,frequentmiles,totmile];
//	else tips.text = @"Information not available!";
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//return unreadmsg;
	[pool release];
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
