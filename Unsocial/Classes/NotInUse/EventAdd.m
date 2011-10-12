//
//  EventAdd.m
//  Unsocial
//
//  Created by vaibhavsaran on 29/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventAdd.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "SelectIndustryPicker.h"
#import "EventSelectIndustry.h"
#import "EventDatePicker.h"
#import "EventFromToTimePicker.h"

@implementation EventAdd
@synthesize eventDetails;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	activityView.hidden = YES;
	loading.hidden = YES;
	[self createControls];
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"SettingsStep4 view will appear");
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
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"use_case_311.png"];
	[self.view addSubview:imgBack];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Add Event" frame:CGRectMake(0, 0, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	/*loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];*/
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {

	dataSourceArray = [[NSArray alloc] initWithObjects:[self FillEName], [self FillAddress], [self FillIndustry], [self FillDate], [self FillFromTime], [self FillToTime], [self FillDescription], [self FillWebsite], [self FillContact], [self FillSwitch], [self None], [self None], [self None], nil];

	itemtableView = [[UITableView alloc] initWithFrame:CGRectMake(19, 39, 282, 252) style:UITableViewStylePlain];
	itemtableView.delegate = self;
	itemtableView.backgroundColor = [UIColor clearColor];
	itemtableView.dataSource = self;
	itemtableView.separatorStyle = UITableViewCellSelectionStyleNone;
	[itemtableView reloadData];
	[self.view addSubview:itemtableView];

	UIButton *btnAdd = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnAdd_Click) frame:CGRectMake(100, 365, 127, 34) imageStateNormal:@"add.png" imageStateHighlighted:@"add2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor blackColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnAdd];
	[btnAdd release];	
}

- (void)btnAdd_Click {
	
	if(([txtEName.text compare:@""] == NSOrderedSame) ||([txtAddress.text compare:@""] == NSOrderedSame) ||([txtInd.text compare:@""] == NSOrderedSame) ||([txtDate.text compare:@""] == NSOrderedSame) ||([txtTime.text compare:@""] == NSOrderedSame) ||([txtDescription.text compare:@""] == NSOrderedSame)) {
		
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Please fill the necessery fields" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
		return;
	}

	[self.view addSubview:imgBack];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	loading.hidden = NO;
	[activityView startAnimating];
	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
}

- (void)startProcess {
	
	[self sendNow:@"addeventstep1"];
	[activityView stopAnimating];
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) sendNow: (NSString *) flag {
	NSLog(@"Sending....");
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
	NSString *flg2 = [NSString stringWithFormat:@"%@\r\n",@"aaa"];
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@\r\n",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	NSString *vartxtEName = [NSString stringWithFormat:@"%@\r\n",txtEName.text];
	NSString *vartxtAddress = [NSString stringWithFormat:@"%@\r\n",txtAddress.text];
	NSString *vartxtInd = [NSString stringWithFormat:@"%@\r\n",[arrayAddEventID objectAtIndex:0]];
	NSString *vartxtDate = [NSString stringWithFormat:@"%@\r\n",txtDate.text];
	NSString *vartxtTime = [NSString stringWithFormat:@"%@\r\n",txtTime.text];
	NSString *vartxtToTime = [NSString stringWithFormat:@"%@\r\n",txtToTime.text];
	NSString *vartxtDescription = [NSString stringWithFormat:@"%@\r\n",txtDescription.text];
	NSString *vartxtWebsite = [NSString stringWithFormat:@"%@\r\n",txtWebsite.text];
	NSString *vartxtContact = [NSString stringWithFormat:@"%@\r\n",txtContact.text];
	NSString *varRecirring = [NSString stringWithFormat:@"%@\r\n",isReccuring];
	
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
	
	if ([flag compare:@"addeventstep1"] == NSOrderedSame)
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"\r\n%@",[NSString stringWithFormat:@"%@\r\n",[arrayForUserID objectAtIndex:0]]] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"devicetocken\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",deviceTocken] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventname\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",vartxtEName] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventaddress\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",vartxtAddress] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventind\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",vartxtInd] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventdate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",vartxtDate] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventfromtime\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",vartxtTime] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventtotime\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",vartxtToTime] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"lastlogindate\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",dt] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventdesc\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",vartxtDescription] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventwebsite\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",vartxtWebsite] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"eventcontact\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",vartxtContact] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"longitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlongitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"latitude\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",strlatitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"isrecurring\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",varRecirring] dataUsingEncoding:NSUTF8StringEncoding]];
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
				NSLog(@"\n\n\n\n\n\n#######################-- post For Add Event added successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				
				userid = [dic objectForKey:key];
				break;
			}			
		}
		
	}	
	
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(returnString);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return successflg;
	[pool release];
}

#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSourceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 6) {
		return 100;
	} else {
		return 40;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];	
	cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	int itemIndex = indexPath.row;
	if(itemIndex== 6)
	{
		UILabel *lableNone = [[UILabel alloc] initWithFrame:CGRectMake(135, 5, 135, 90)];
		lableNone.text = @"";
		lableNone.backgroundColor = [UIColor whiteColor];
		[cell.contentView addSubview:lableNone];
	}
	[cell.contentView addSubview:[[dataSourceArray objectAtIndex:itemIndex] objectForKey:@"lebelcontrol"]];
	[cell.contentView addSubview:[[dataSourceArray objectAtIndex:itemIndex] objectForKey:@"control"]];
	[cell.contentView addSubview:[[dataSourceArray objectAtIndex:itemIndex] objectForKey:@"btncontrol"]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
}

 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }


 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }


- (void)showIndustries {
	
	[self restoreToArray];
	EventSelectIndustry *selectIndustryPicker = [[EventSelectIndustry alloc]init];
	[self.navigationController pushViewController:selectIndustryPicker animated:YES];
	[selectIndustryPicker release];
}

- (void)showDate {
	
	[self restoreToArray];
	EventDatePicker *dobPickerController = [[EventDatePicker alloc]init];
	[self.navigationController pushViewController:dobPickerController animated:YES];
	[dobPickerController release];
}

- (void)selectFromTime_Click {
	
	[self restoreToArray];
	EventFromToTimePicker *eventFromToTimePicker = [[EventFromToTimePicker alloc]init];
	eventFromToTimePicker.timeToFrom = 1;
	[self.navigationController pushViewController:eventFromToTimePicker animated:YES];
	[eventFromToTimePicker release];
}

- (void)selectToTime_Click {
	
	[self restoreToArray];
	if([txtTime.text compare:@""] == NSOrderedSame) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Select From Date First." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		return;
	}
	EventFromToTimePicker *eventFromToTimePicker = [[EventFromToTimePicker alloc]init];
	eventFromToTimePicker.timeToFrom = 2;
	[self.navigationController pushViewController:eventFromToTimePicker animated:YES];
	[eventFromToTimePicker release];
}

#pragma mark Creation of all Controls-
-(NSMutableDictionary *)FillEName {
	NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
	{
		UILabel *lblEName = [UnsocialAppDelegate createLabelControl:@"Event Name*" frame:CGRectMake(0, 5, 130, 30) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		
		
		txtEName = [UnsocialAppDelegate createTextFieldControl:CGRectMake(135, 5, 135, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"Event" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		if([eventDetails count] > 0)
			txtEName.text = [eventDetails objectAtIndex:0];
		[txtEName setDelegate:self];
		[item setObject:lblEName forKey:@"lebelcontrol"];
		[item setObject:txtEName forKey:@"control"];
		// 13 may 2011 by pradeep //[lblEName release];
		[txtEName release];
	}
	return item;
}

-(NSMutableDictionary *)FillAddress {
	NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
	{
		UILabel *reoccuringLabel = [UnsocialAppDelegate createLabelControl:@"Address*" frame:CGRectMake(0, 5, 130, 30) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		
		txtAddress = [UnsocialAppDelegate createTextFieldControl:CGRectMake(135, 5, 135, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"Address" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		if([eventDetails count] > 0)
		txtAddress.text = [eventDetails objectAtIndex:1];
		[txtAddress setDelegate:self];
		[item setObject:reoccuringLabel forKey:@"lebelcontrol"];
		[item setObject:txtAddress forKey:@"control"];
		// 13 may 2011 by pradeep //[reoccuringLabel release];
		[txtAddress release];
	}
	return item;
}

-(NSMutableDictionary *)FillIndustry {
	NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
	{
		UILabel *indName = [UnsocialAppDelegate createLabelControl:@"Industry*" frame:CGRectMake(0, 5, 130, 30) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		
		txtInd = [UnsocialAppDelegate createTextFieldControl:CGRectMake(135, 5, 135, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"Industry" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		if([arrayAddEvent count] > 0)
		txtInd.text = [arrayAddEvent objectAtIndex:0];
		[txtInd setDelegate:self];

		UIButton *selectIndustry = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(showIndustries) frame:CGRectMake(135, 5, 135, 30) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
		
		[item setObject:indName forKey:@"lebelcontrol"];
		[item setObject:txtInd forKey:@"control"];
		[item setObject:selectIndustry forKey:@"btncontrol"];
		[txtInd release];
		// 13 may 2011 by pradeep //[indName release];
		[selectIndustry release];
	}
	return item;
}

-(NSMutableDictionary *)FillDate {
	NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
	{
		UILabel *dateLabel = [UnsocialAppDelegate createLabelControl:@"Date*" frame:CGRectMake(0, 5, 130, 30) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		
		txtDate = [UnsocialAppDelegate createTextFieldControl:CGRectMake(135, 5, 135, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"Date" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeNumbersAndPunctuation returnKey:UIReturnKeyDone];
		[txtDate setDelegate:self];
		txtDate.autocorrectionType = UITextAutocorrectionTypeNo;
		txtDate.autocapitalizationType = UITextAutocapitalizationTypeNone;
		if([arrayAddDateEvent count] > 0)
		txtDate.text = [arrayAddDateEvent objectAtIndex:0];

		UIButton *selectDate = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(showDate) frame:CGRectMake(135, 5, 135, 30) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
		
		[item setObject:dateLabel forKey:@"lebelcontrol"];
		[item setObject:txtDate forKey:@"control"];
		[item setObject:selectDate forKey:@"btncontrol"];
		// 13 may 2011 by pradeep //[dateLabel release];
		[txtDate release];
		[selectDate release];
	}
	return item;
}

-(NSMutableDictionary *)FillFromTime {
	NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
	{
		UILabel *timeLabel = [UnsocialAppDelegate createLabelControl:@"From Time*" frame:CGRectMake(0, 5, 130, 30) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		
		txtTime = [UnsocialAppDelegate createTextFieldControl:CGRectMake(135, 5, 135, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"From Time" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		[txtTime setDelegate:self];
		if([arrayAddFromTime count] > 0)
			txtTime.text = [arrayAddFromTime objectAtIndex:0];
		
		UIButton *selectFromTime = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(selectFromTime_Click) frame:CGRectMake(135, 5, 135, 30) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
		
		[item setObject:timeLabel forKey:@"lebelcontrol"];
		[item setObject:txtTime forKey:@"control"];
		[item setObject:selectFromTime forKey:@"btncontrol"];
		// 13 may 2011 by pradeep //[timeLabel release];
		[txtTime release];
		[selectFromTime release];
	}
	return item;
}

-(NSMutableDictionary *)FillToTime {
	NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
	{
		UILabel *toTimeLabel = [UnsocialAppDelegate createLabelControl:@"To Time*" frame:CGRectMake(0, 5, 130, 30) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		
		txtToTime = [UnsocialAppDelegate createTextFieldControl:CGRectMake(135, 5, 135, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"To Time" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		[txtToTime setDelegate:self];
		if([arrayAddToTime count] > 0)
			txtToTime.text = [arrayAddToTime objectAtIndex:0];

		UIButton *selectToTime = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(selectToTime_Click) frame:CGRectMake(135, 5, 135, 30) imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
		
		[item setObject:toTimeLabel forKey:@"lebelcontrol"];
		[item setObject:txtToTime forKey:@"control"];
		[item setObject:selectToTime forKey:@"btncontrol"];
		// 13 may 2011 by pradeep //[toTimeLabel release];
		[selectToTime release];
		[txtToTime release];
	}
	return item;
}

-(NSMutableDictionary *)FillDescription {
	NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
	{
		UILabel *descripLabel = [UnsocialAppDelegate createLabelControl:@"Description*" frame:CGRectMake(0, 5, 130, 30) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		
		txtDescription = [UnsocialAppDelegate createTextViewControl:@"" frame:CGRectMake(135, 5, 135, 90) txtcolor:[UIColor blackColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:14 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:YES];
		if([eventDetails count] > 0)
			txtDescription.text = [eventDetails objectAtIndex:6];
		txtDescription.delegate = self;
		txtDescription.autocapitalizationType = UITextAutocapitalizationTypeNone;
		txtDescription.autocorrectionType = UITextAutocorrectionTypeNo;
		txtDescription.scrollEnabled = YES;
		[item setObject:descripLabel forKey:@"lebelcontrol"];
		[item setObject:txtDescription forKey:@"control"];
		// 13 may 2011 by pradeep //[descripLabel release];
		[txtDescription release];
	}
	return item;
}

-(NSMutableDictionary *)FillWebsite {
	NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
	{
		UILabel *websiteLabel = [UnsocialAppDelegate createLabelControl:@"Website" frame:CGRectMake(0, 5, 130, 30) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		
		txtWebsite = [UnsocialAppDelegate createTextFieldControl:CGRectMake(135, 5, 135, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"Website" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeURL returnKey:UIReturnKeyDone];
		[txtWebsite setDelegate:self];
		txtWebsite.autocorrectionType = UITextAutocorrectionTypeNo;
		txtWebsite.autocapitalizationType = UITextAutocapitalizationTypeNone;
		if([eventDetails count] > 0)
		txtWebsite.text = [eventDetails objectAtIndex:7];
		[item setObject:websiteLabel forKey:@"lebelcontrol"];
		[item setObject:txtWebsite forKey:@"control"];
		// 13 may 2011 by pradeep //[websiteLabel release];
		[txtWebsite release];
	}
	return item;
}

-(NSMutableDictionary *)FillContact {
	NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
	{
		UILabel *contactLabel = [UnsocialAppDelegate createLabelControl:@"Phone" frame:CGRectMake(0, 5, 130, 30) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		
		txtContact = [UnsocialAppDelegate createTextFieldControl:CGRectMake(135, 5, 135, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"Phone" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeNumberPad returnKey:UIReturnKeyDone];
		[txtContact setDelegate:self];
		txtContact.text = [eventDetails objectAtIndex:8];
		[item setObject:contactLabel forKey:@"lebelcontrol"];
		[item setObject:txtContact forKey:@"control"];
		[txtContact release];
		// 13 may 2011 by pradeep //[contactLabel release];
	}
	return item;
}

-(NSMutableDictionary *)FillSwitch {
	NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
	{
		UILabel *recurringLabel = [UnsocialAppDelegate createLabelControl:@"Event Recurrence" frame:CGRectMake(0, 5, 140, 30) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:17 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
		
		switchCtl = [[UISwitch alloc] initWithFrame:CGRectMake(145, 5, 94.0, 27.0)];
		switchCtl.on = NO;
		[switchCtl addTarget:self action:@selector(eventReccuring:) forControlEvents:UIControlEventValueChanged];
		switchCtl.backgroundColor = [UIColor colorWithRed:9.00/255.0 green:94.0/255.0 blue:140.0/255.0 alpha:1.0];
		if([eventDetails count] > 0) {
			if([[eventDetails objectAtIndex:9] compare:@"1"] == NSOrderedSame) switchCtl.on = YES; 
			else switchCtl.on = NO;
		}
		[item setObject:recurringLabel forKey:@"lebelcontrol"];
		[item setObject:switchCtl forKey:@"control"];
		[txtContact release];
		// 13 may 2011 by pradeep //[recurringLabel release];
	}
	return item;
}

-(NSMutableDictionary *)None
{
	NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
	{
		UILabel *lableNone = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.0, 320.0, 30)];
		lableNone.text = @"";
		lableNone.backgroundColor = [UIColor clearColor];
		[item setObject:lableNone forKey:@"lebelcontrol"];
		[lableNone release];
	}
	return item;
}

- (void)leftbtn_OnClick {
	
	[self.navigationController popViewControllerAnimated:YES];
	//[self.navigationController popViewController Animated:YES];
}

- (void)eventReccuring:(id)sender {
	
	if([sender isOn])
	{
		isReccuring = @"1";
	}
	else 
	{
		isReccuring = @"0";
	}
}

- (void)btnDone_OnClick:(id)sender {
	[txtDescription resignFirstResponder];
	[txtContact resignFirstResponder];
	btnDone.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	if(textField == txtContact) {
		UIBarButtonItem* saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
		self.navigationItem.rightBarButtonItem = saveItem;
		[saveItem release];
	}
	else 
		self.navigationItem.rightBarButtonItem = nil;
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

	btnDone.hidden = NO;
	printf("\nTextView Did begin editing\n");
	UIBarButtonItem* saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
	self.navigationItem.rightBarButtonItem = saveItem;
	[saveItem release];
}

- (void)saveAction:(id)sender {
	// finish typing text/dismiss the keyboard by removing it as the first responder
	//
	[txtContact resignFirstResponder];
	[txtDescription resignFirstResponder];
	self.navigationItem.rightBarButtonItem = nil;	// this will remove the "save" button
}

- (void)restoreToArray {
	
	if([txtEName.text compare:nil] == NSOrderedSame) txtEName.text = @"";	
	if([txtAddress.text compare:nil] == NSOrderedSame) txtAddress.text = @"";	
	if([txtInd.text compare:nil] == NSOrderedSame) txtInd.text = @"";	
	if([txtDate.text compare:nil] == NSOrderedSame) txtDate.text = @"";	
	if([txtTime.text compare:nil] == NSOrderedSame) txtTime.text = @"";	
	if([txtToTime.text compare:nil] == NSOrderedSame) txtToTime.text = @"";	
	if([txtDescription.text compare:nil] == NSOrderedSame) txtDescription.text = @"";	
	if([txtWebsite.text compare:nil] == NSOrderedSame) txtWebsite.text = @"";	
	if([txtContact.text compare:nil] == NSOrderedSame) txtContact.text = @"";	
	if(switchCtl.on) isReccuring = @"1";
	else isReccuring = @"0";
	
	eventDetails = [[NSMutableArray alloc]init];
	[eventDetails addObject:txtEName.text];
	[eventDetails addObject:txtAddress.text];
	[eventDetails addObject:txtInd.text];
	[eventDetails addObject:txtDate.text];
	[eventDetails addObject:txtTime.text];
	[eventDetails addObject:txtToTime.text];
	[eventDetails addObject:txtDescription.text];
	[eventDetails addObject:txtWebsite.text];
	[eventDetails addObject:txtContact.text];
	[eventDetails addObject:isReccuring];
	
	[txtEName resignFirstResponder];
	[txtAddress resignFirstResponder];
	[txtDescription resignFirstResponder];
	[txtWebsite resignFirstResponder];
	[txtContact resignFirstResponder];
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
	[dataSourceArray dealloc];
	[itemtableView release];
	// 13 may 2011 by pradeep //[loading release];
	[activityView release];
	[eventDetails  release];
}


@end
