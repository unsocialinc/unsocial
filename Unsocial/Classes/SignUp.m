
#import "SignUp.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "UIDeviceHardware.h"
#import "Person.h"
#import "SettingsSelectPrefix.h"
#import "LauncherViewTestController.h"
#import "SettingsSelectPrefix.h"
#import "AppNotAvailable.h"
#import "webViewForLinkedIn.h"

#define klabelFontSize  13
static NSString *kSourceKey = @"sourceKey";
static NSString *kViewKey = @"viewKey";

const NSInteger kViewTag = 1;

@implementation SignUp

@synthesize FillLoginId, FillPassword, FillPassword2, FillPrefix, FillPersonName, FillContact, dataSourceArray, FillPhoto, FillBlank;

- (void) viewWillAppear:(BOOL)animated {
	
	[self defaultControls];
}

- (void)defaultControls {
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
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 463)];
	imgBack.image = [UIImage imageNamed:@"signupback.png"];
	[self.view addSubview:imgBack];
	
	heading = [UnsocialAppDelegate createLabelControl:@"Register" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];	
	
	lblLinkedIn = [[UILabel alloc]initWithFrame:CGRectMake(110, 7, 300, 35)];
	lblLinkedIn.text = @"or sign in using Linked";
	[lblLinkedIn setTextColor:[UIColor whiteColor]];
	[lblLinkedIn setFont:[UIFont fontWithName:kAppFontName size:klabelFontSize]];
	[lblLinkedIn setFont:[UIFont boldSystemFontOfSize:15]];
	[lblLinkedIn setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:lblLinkedIn];
	[lblLinkedIn release];
	
	btnLinkedIn = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnLinkedIn_Click) frame:CGRectMake(278, 7, 35, 35) imageStateNormal:@"linkedinlogo.png" imageStateHighlighted:@"linkedinlogo2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor orangeColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnLinkedIn];
}

- (void) btnLinkedIn_Click {	
	
	UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [NSString stringWithFormat:@"%@",[myDevice uniqueIdentifier]];
	NSString *deviceTocken;
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@",@"0"];
	else deviceTocken = [NSString stringWithFormat:@"%@",[devTocken objectAtIndex:0]];
	deviceTocken = [deviceTocken stringByReplacingOccurrencesOfString:@" " withString:@"$"];
	NSString *deviceType = [NSString stringWithFormat:@"%@",@"iphone"];
	
		//DEFAULT TERMS/////////////////////////////////////
	NSString *dt = [NSString stringWithFormat:@"%@", [UnsocialAppDelegate getLocalTime]];
	dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@"$"];
	NSLog(@"%@", dt);
	NSMutableArray *myArray = [[NSMutableArray alloc] init];
	[myArray setArray:[dt componentsSeparatedByString:@" "]];	
	NSString *userdatetime = [myArray objectAtIndex:0];
	userdatetime = dt;//[userdatetime stringByAppendingString:[@" %@",myArray objectAtIndex:1]];
	userdatetime = [NSString stringWithFormat:@"%@",userdatetime];
	
	NSString *strlongitude = [NSString stringWithFormat:@"%@",gbllongitude];
	NSString *strlatitude = [NSString stringWithFormat:@"%@",gbllatitude];
	NSString *allownotification = [NSString stringWithFormat:@"%@",@"0"];
	
	NSArray *arraySignIn = [[NSArray alloc] initWithObjects:deviceTocken, deviceUDID, deviceType, @"", @"LinkedIn", strlongitude, strlatitude, allownotification, userdatetime, nil];
	
	webViewForLinkedIn *wvli = [[webViewForLinkedIn alloc]init];
	wvli.camefrom = @"UnsocialSignInLinkedIn";
	wvli.arraySignIn = arraySignIn;
	[self.navigationController pushViewController:wvli animated:YES];
	[wvli release];
}

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 42, 310, 335) style:UITableViewStylePlain];
	itemTableView.delegate = self;
	itemTableView.dataSource = self;
	itemTableView.backgroundColor = [UIColor clearColor];
	itemTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	[self.view addSubview:itemTableView];
	[itemTableView flashScrollIndicators];
	[self createControls];
}

- (void)createControls {
	
	if([allInfoNewUser count] > 0) {
		
		FillLoginId.text = [allInfoNewUser objectAtIndex:0];
		FillPassword.text = [allInfoNewUser objectAtIndex:1];
		FillPassword2.text = [allInfoNewUser objectAtIndex:2];
		FillPrefix.text = [allInfoNewUser objectAtIndex:3];
		FillPersonName.text = [allInfoNewUser objectAtIndex:4];
		FillContact.text = [allInfoNewUser objectAtIndex:5];
	}
	if ([capturedImageNewUser count] > 0) {
		
		FillPhoto.image = [capturedImageNewUser objectAtIndex:0];
	}
	[itemTableView flashScrollIndicators];
	
	btnAdd = [UnsocialAppDelegate createButtonControl:@"Save" target:self selector:@selector(btnAdd_Click) frame:CGRectMake(128, 380, 64, 29) imageStateNormal:@"button1.png" imageStateHighlighted:@"button2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnAdd];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Saving details, please standby..." frame:CGRectMake(10, 380, 300, 30) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor colorWithRed:83.0/255 green:85.0/255 blue:82.0/255 alpha:1.0]];
	loading.hidden = YES;
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(280, 386, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
}

- (void)viewDidLoad {
	
	self.dataSourceArray = [NSArray arrayWithObjects:
							[NSDictionary dictionaryWithObjectsAndKeys:
							 @"E-Mail*:", kSourceKey,
							 self.FillLoginId, kViewKey,
							 nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:
							 @"Password*:", kSourceKey,
							 self.FillPassword, kViewKey,
							 nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:
							 @"Re-enter Password*:", kSourceKey,
							 self.FillPassword2, kViewKey,
							 nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:
							 @"Prefix*:", kSourceKey,
							 self.FillPrefix, kViewKey,
							 nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:
							 @"Name*:", kSourceKey,
							 self.FillPersonName, kViewKey,
							 nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:
							 @"Phone*:", kSourceKey,
							 self.FillContact, kViewKey,
							 nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:
							 @"Photo:", kSourceKey,
							 self.FillPhoto, kViewKey,
							 nil],
							
							[NSDictionary dictionaryWithObjectsAndKeys:
							 @"", kSourceKey,
							 self.FillBlank, kViewKey,
							 nil],
							
							nil];
	
		// we aren't editing any fields yet, it will be in edit when the user touches an edit field
	self.editing = NO;
}

- (void)btnAdd_Click {
	
	[UnsocialAppDelegate playClick];
	
	NSString *_strLoginid = [FillLoginId.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	NSString *_strPassword = [FillPassword.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	NSString *_strPrefix = [FillPrefix.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	NSString *_strPersonname = [FillPersonName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	NSString *_strContact = [FillContact.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	
	NSLog(@"\n%@,\n%@,\n%@,\n%@,\n%@",_strLoginid, _strPassword, _strPrefix, _strPersonname, _strContact);
	
	if(([_strLoginid isEqualToString:@""]) || ([_strPassword isEqualToString:@""]) || ([_strPrefix isEqualToString:@""]) || ([_strPersonname isEqualToString:@""]) || ([_strContact isEqualToString:@""])) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the required fields." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		whereClicked = 1;
		return;
	}
	
	if(!_strLoginid || !_strPassword || !_strPrefix || !_strPersonname || !_strContact) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill the required fields." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		whereClicked = 1;
		return;
	}
	
	BOOL myStringMatchesRegEx = [UnsocialAppDelegate validateEmail:[FillLoginId.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
	
	if(!myStringMatchesRegEx) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Invalid E-Mail Address." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		whereClicked = 1;
		return;
	}
	if([[FillLoginId.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] > 80) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"E-Mail is too long to accept." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		whereClicked = 1;
		return;
	}
	if([[FillPassword.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] > 80) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Password can't be more than 80 characters." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		whereClicked = 1;
		return;
	}
	if([[FillPersonName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] > 80) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Name can't be more than 80 characters." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		whereClicked = 1;
		return;
	}
	if([[FillContact.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] > 20) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Phone number is too long to accept." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		whereClicked = 1;
		return;
	}
	if(![[FillPassword.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] isEqualToString:[FillPassword2.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]]) {
		
		UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Password should be the same." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[alertView show];
		[alertView release];
		whereClicked = 1;
		return;
	}
	/*if(![UnsocialAppDelegate checkInternet:@"http://www.google.com"]) {
		
		UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Synchronization failed." message:@"Error during sign up. Your internet connection may be down." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			//[[UIAlertView alloc] initWithTitle:@"Synchronization failed." message:@"Error during sign up. Your internet connection may be down" delegate:self self cancelButtonTitle:nil otherButtonTitles:@"OK"];
		[errorAlert show];
		[errorAlert release];
		whereClicked = 1;
		return;
	}*/
	
	[btnAdd setHidden:YES];
	loading.hidden = NO;
	[activityView startAnimating];

	[NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(startProcess) userInfo:self.view repeats:NO];
}

- (void)startProcess {
	
	[self sendReqForSignUp:@"addprofilestep1"];	
}

- (void)leftbtn_OnClick {
	
	[UnsocialAppDelegate playClick];
	[self storeToMutableArray];
	[self resignAll];

	// added by pradeep on 7 august 2010
	//allInfoNewUser = nil;
	[lastVisitedFeature removeAllObjects];
	[lastVisitedFeature addObject:@"welcome"];
	[self.navigationController popViewControllerAnimated:YES];
}

	// called after the view controller's view is released and set to nil.
	// For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
	// So release any properties that are loaded in viewDidLoad or can be recreated lazily.
	//
- (void)viewDidUnload
{
	[super viewDidUnload];
	
		// release the controls and set them nil in case they were ever created
		// note: we can't use "self.xxx = nil" since they are read only properties
		//
	[FillLoginId release];
	[FillPassword release];
	[FillPassword2 release];
	[FillPrefix release];
	[FillPersonName release];
	[FillContact release];	
	
	self.dataSourceArray = nil;
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.dataSourceArray count];
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 return @"Register";
 }*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

	// to determine specific row height for each cell, override this.
	// In this example, each row is determined by its subviews that are embedded.
	//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger rowHeight;
	if(indexPath.section == 7)
		rowHeight = 28;
	else if(indexPath.section == 6)
		rowHeight = 125;
	else
		rowHeight = 55;
	return rowHeight;
}

	// to determine which UITableViewCell to be used on a given row.
	//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = nil;
	NSInteger row = indexPath.section;
	static NSString *kSourceCell_ID = @"SourceCell_ID";
	cell = [tableView dequeueReusableCellWithIdentifier:kSourceCell_ID];
	
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCell_ID] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	lblControl = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(30, 0, 167, 15) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:klabelFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	lblControl.text = [[self.dataSourceArray objectAtIndex: indexPath.section] valueForKey:kSourceKey];
	[cell.contentView addSubview:lblControl];
	
	UITextField *textField = [[self.dataSourceArray objectAtIndex: indexPath.section] valueForKey:kViewKey];
	[cell.contentView addSubview:textField];
	
	if(row == 3) {
		
		UIButton *btnPrefix = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnPrefix_Click) frame:FillPrefix.frame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor clearColor] TextColorHighlighted:[UIColor clearColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
		[cell.contentView addSubview:btnPrefix];
	}
	if(row == 6) {
		
		UIButton *btnAddPhoto = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnGrab_Click:) frame:FillPhoto.frame imageStateNormal:@"" imageStateHighlighted:@"" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor whiteColor] showsTouch:YES buttonBackgroundColor:[UIColor clearColor]];
		[cell.contentView addSubview:btnAddPhoto];
	}
	[tableView setSeparatorColor:[UIColor clearColor]];
	[itemTableView flashScrollIndicators];
    return cell;
}

- (void)btnGrab_Click:(id)sender {
	
	self.navigationItem.rightBarButtonItem = nil;
	[self resignAll];
	savingProfile = NO;
	[self storeToMutableArray];
	[self dialogSelection];
}

- (void)dialogSelection {
	
		// open an alert with two custom buttons
	UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
	deviceString=[h platformString];
	NSLog(@"%@", deviceString);
	
		// open an alert with two custom buttons
	if(!capturedImageNewUser)
		capturedImageNewUser = [[NSMutableArray alloc] init];
	
		// checking for device in which camera feature is enabled
	if ([deviceString isEqualToString:@"iPod Touch 1G"] || [deviceString isEqualToString:@"iPod Touch 2G"] || [deviceString isEqualToString:@"iPhone Simulator"])
	{
		iscemera = NO;
		alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:
						 @"From Gallery" otherButtonTitles:
						 @"Cancel", nil];
	}
	else
	{
		iscemera = YES;
		alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:
						 nil otherButtonTitles:
						 @"Choose From Gallery", 
						 @"Take Photo",
						 @"Cancel", nil];
	}
	whereClicked = 2;
	[alertOnChoose show];
	[alertOnChoose release];
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
	if(whereClicked != 1)
	{
		if(iscemera){
			cameraUse = YES;
			if (buttonIndex == 0)
			{
				NSLog(@"chose existing photo");
				[self switchTouched];
			}
			else if (buttonIndex == 1)
			{
				NSLog(@"take photo from camera");
				[self recordNow];
			}
			else if (buttonIndex == 2)
			{
				NSLog(@"Cancel");
			}
		}
		else {
			if (buttonIndex == 0)
			{
				NSLog(@"chose existing photo");
				[self switchTouched];
			}
			else if (buttonIndex == 1)
			{
				NSLog(@"Cancel");
			}
		}
	}
	else
	{
		if (buttonIndex == 0)
		{
			whereClicked = 2;
		}
	}
}

- (void) switchTouched {
	cameraUse = NO;
	printf("switch touched - %d", cameraUse);
	[self recordNow];
}

- (IBAction)recordNow {
	
	[self captureImage];
		//set this flag back to yes for the next time.
	cameraUse = YES;
}

-(void) captureImage {
	
	imgPicker = [[UIImagePickerController alloc] init];
	imgPicker.allowsEditing = YES;
	imgPicker.delegate = self;		
	
	if (cameraUse) {
		imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	else {
		imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	[self presentModalViewController:imgPicker animated:YES];
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {	
	if ([capturedImageNewUser count] > 0)
	{
		capturedImageNewUser = nil;
		capturedImageNewUser = [[NSMutableArray alloc] init];
	}
	[capturedImageNewUser addObject:img];	
	imageGrabed.image = [capturedImageNewUser objectAtIndex:0];
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)btnPrefix_Click {
	
	self.navigationItem.rightBarButtonItem = nil;
	CGSize contentSize = CGSizeMake(320, 480);	
	UIGraphicsBeginImageContext(contentSize);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	capturedScreen = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:UIGraphicsGetImageFromCurrentImageContext(), nil]];
	UIGraphicsEndImageContext();	
	[self resignAll];
	[self storeToMutableArray];
	SettingsSelectPrefix *settingsSelectPrefix = [[SettingsSelectPrefix alloc]init];
	settingsSelectPrefix.strPrefix = FillPrefix.text;
	[self.navigationController presentModalViewController:settingsSelectPrefix animated:YES];
	//[allInfo release];
	[allInfo removeAllObjects];
	[settingsSelectPrefix release];
}

- (void)storeToMutableArray {
	
	allInfoNewUser = [[NSMutableArray alloc]init];
	
	if([FillLoginId.text compare:nil] == NSOrderedSame)
		[allInfoNewUser addObject:@""];
	else [allInfoNewUser addObject:FillLoginId.text];
	
	if([FillPassword.text compare:nil] == NSOrderedSame)
		[allInfoNewUser addObject:@""];
	else [allInfoNewUser addObject:FillPassword.text];
	
	if([FillPassword2.text compare:nil] == NSOrderedSame)
		[allInfoNewUser addObject:@""];
	else [allInfoNewUser addObject:FillPassword2.text];
	
	if([FillPrefix.text compare:nil] == NSOrderedSame)
		[allInfoNewUser addObject:@""];
	else [allInfoNewUser addObject:FillPrefix.text];
	
	if([FillPersonName.text compare:nil] == NSOrderedSame)
		[allInfoNewUser addObject:@""];
	else [allInfoNewUser addObject:FillPersonName.text];
	
	if([FillContact.text compare:nil] == NSOrderedSame)
		[allInfoNewUser addObject:@""];
	else [allInfoNewUser addObject:FillContact.text];
}

- (void)resignAll {
	
	[FillLoginId resignFirstResponder];
	[FillPassword resignFirstResponder];
	[FillPassword2 resignFirstResponder];
	[FillPersonName resignFirstResponder];
	[FillContact resignFirstResponder];
}

#pragma mark -
#pragma mark Text Fields

- (UITextField *)FillLoginId
{
	if (FillLoginId == nil)
	{
		FillLoginId = [UnsocialAppDelegate createTextFieldControl:CGRectMake(30, 18, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"email" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeEmailAddress returnKey:UIReturnKeyDone];
		[FillLoginId setDelegate:self];
		FillLoginId.backgroundColor = [UIColor clearColor];
		FillLoginId.autocapitalizationType = UITextAutocapitalizationTypeNone;
		FillLoginId.autocorrectionType = UITextAutocorrectionTypeNo;
		[FillLoginId setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return FillLoginId;
}

- (UITextField *)FillPassword
{
	if (FillPassword == nil)
	{
		FillPassword = [UnsocialAppDelegate createTextFieldControl:CGRectMake(30, 18, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"enter password" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		[FillPassword setDelegate:self];
		FillPassword.secureTextEntry = YES;
		FillPassword.backgroundColor = [UIColor clearColor];
		FillPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
		FillPassword.autocorrectionType = UITextAutocorrectionTypeNo;
		[FillPassword setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return FillPassword;
}

- (UITextField *)FillPassword2
{
	if (FillPassword2 == nil)
	{
		FillPassword2 = [UnsocialAppDelegate createTextFieldControl:CGRectMake(30, 18, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"re enter password" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		[FillPassword2 setDelegate:self];
		FillPassword2.secureTextEntry = YES;
		FillPassword2.backgroundColor = [UIColor clearColor];
		FillPassword2.autocapitalizationType = UITextAutocapitalizationTypeNone;
		FillPassword2.autocorrectionType = UITextAutocorrectionTypeNo;
		[FillPassword2 setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return FillPassword2;
}

- (UITextField *)FillPrefix
{
	if (FillPrefix == nil)
	{
		FillPrefix = [UnsocialAppDelegate createTextFieldControl:CGRectMake(30, 18, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"Mr/Mrs/Miss" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeEmailAddress returnKey:UIReturnKeyDone];
		[FillPrefix setDelegate:self];
		FillPrefix.backgroundColor = [UIColor clearColor];
		FillPrefix.autocapitalizationType = UITextAutocapitalizationTypeNone;
		FillPrefix.autocorrectionType = UITextAutocorrectionTypeNo;
		[FillPrefix setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return FillPrefix;
}

- (UITextField *)FillPersonName
{
	if (FillPersonName == nil)
	{
		FillPersonName = [UnsocialAppDelegate createTextFieldControl:CGRectMake(30, 18, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"e.g. John Smith" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeDefault returnKey:UIReturnKeyDone];
		[FillPersonName setDelegate:self];
		FillPersonName.backgroundColor = [UIColor clearColor];
		FillPersonName.autocapitalizationType = UITextAutocapitalizationTypeWords;
		FillPersonName.autocorrectionType = UITextAutocorrectionTypeNo;
		[FillPersonName setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return FillPersonName;
}

- (UITextField *)FillContact
{
	if (FillContact == nil)
	{
		FillContact = [UnsocialAppDelegate createTextFieldControl:CGRectMake(30, 18, 260, 30) borderStyle:UITextBorderStyleRoundedRect setTextColor:[UIColor blackColor] setFontSize:kTextFieldFont setPlaceholder:@"phone number" backgroundColor:[UIColor clearColor] keyboard:UIKeyboardTypeNumberPad returnKey:UIReturnKeyDone];
		[FillContact setDelegate:self];
		FillContact.backgroundColor = [UIColor clearColor];
		FillContact.autocapitalizationType = UITextAutocapitalizationTypeNone;
		FillContact.autocorrectionType = UITextAutocorrectionTypeNo;
		[FillContact setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return FillContact;
}

-(UIImageView *)FillPhoto {
	
	if (FillPhoto == nil)
	{
		FillPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(30, 18, 100, 100)];
		if ([capturedImageNewUser count] > 0)
			FillPhoto.image = [capturedImageNewUser objectAtIndex:0];
		else 
			FillPhoto.image = [UIImage imageNamed:@"imgNoUserImage.png"];
		
			// Get the Layer of any view
		CALayer * l = [FillPhoto layer];
		[l setMasksToBounds:YES];
		[l setCornerRadius:10.0];
		
			// You can even add a border
		[l setBorderWidth:1.0];
		[l setBorderColor:[[UIColor blackColor] CGColor]];
		[self.view addSubview:FillPhoto];
	}
	return FillPhoto;
}

- (UILabel *)FillBlank
{
	if (FillBlank == nil)
	{
		FillBlank = [UnsocialAppDelegate createLabelControl:@"" frame:CGRectMake(30, 18, 260, 30) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor clearColor] backgroundcolor:[UIColor clearColor]];
		[FillBlank setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];
	}	
	return FillBlank;
}

- (void) updateDataFileOnSave:(NSString *)uid {
	
	NSMutableArray *userInfo;
	userInfo = [[NSMutableArray alloc] init];
	Person *newPerson = [[Person alloc] init];
	newPerson.useremail = FillLoginId.text;
	newPerson.userpassword = FillPassword.text;
	newPerson.userprefix = FillPrefix.text;
	newPerson.username = FillPersonName.text;
	newPerson.usercontact = FillContact.text;
	newPerson.userid = uid;
	[userInfo insertObject:newPerson atIndex:0];
	[newPerson release];
	
	NSMutableData *theData;
	NSKeyedArchiver *encoder;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"settingsinfo4Unsocial"];	
	theData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:theData];	
	[encoder encodeObject:userInfo forKey:@"userInfo"];
	[encoder finishEncoding];	
	[theData writeToFile:path atomically:YES];
	[encoder release];
}

	// for saving an image inside document forder
- (void) updateDataFileOnSave4Img:(NSString *)uid {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataFilePath = [[documentsDirectory stringByAppendingPathComponent:@"1.png"] retain];
	NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation([capturedImageNewUser objectAtIndex:0], 1.0)];
	[imageData writeToFile:dataFilePath atomically:YES];
}

- (BOOL) sendReqForSignUp: (NSString *) flag {
	
	NSLog(@"Sending....");
	NSData *imageData1 = [[NSData alloc] init];;
	NSString *isimg1exist = [NSString stringWithFormat:@"%@\r\n", @"no"];
	NSString *isimgexist = @"no";
	
	if ([capturedImageNewUser count] > 0)
	{		
		isimg1exist = [NSString stringWithFormat:@"%@\r\n", @"yes"];
		isimgexist = @"yes";
		imageData1 = UIImageJPEGRepresentation([capturedImageNewUser objectAtIndex:0], 1.0);
	}
	
	
		// setting up the URL to post to
	NSString *urlString = [globalUrlString stringByAppendingString:@"/iphone/iPhoneReqPage1_1.aspx"];
	
	NSLog(@"%@", urlString);
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
	NSString *deviceType = [NSString stringWithFormat:@"%@\r\n",@"iphone"];
	
	NSLog(@"%@", [devTocken objectAtIndex:0]);
	if ([devTocken count] == 0)
		deviceTocken = [NSString stringWithFormat:@"%@\r\n",@""];
	else deviceTocken = [NSString stringWithFormat:@"%@\r\n",[devTocken objectAtIndex:0]];
	
	NSString *email = [NSString stringWithFormat:@"%@\r\n",[FillLoginId.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
	NSString *password = [NSString stringWithFormat:@"%@\r\n",[FillPassword.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
	NSString *prefix = [NSString stringWithFormat:@"%@\r\n",[FillPrefix.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
	NSString *usrname = [NSString stringWithFormat:@"%@\r\n",[FillPersonName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
	NSString *contact = [NSString stringWithFormat:@"%@\r\n",[FillContact.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
	
	
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
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"devicetype\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",deviceType] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"useremail\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",email] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userpassword\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",password] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"prefix\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",prefix] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",usrname] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"usercontact\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",contact] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"pic1exist\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n%@",isimg1exist] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	if ([isimgexist compare:@"yes"] == NSOrderedSame)
	{
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"pic1\"; filename=\"pic1.jpg\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[NSData dataWithData:imageData1]];
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
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
	
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	for (id key in dic)
	{
			// reading from response header
		NSLog(@"key: %@, value: %@", key, [dic objectForKey:key]);
		if ([key isEqualToString:@"Userid"])			
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				[self updateDataFileOnSave:[dic objectForKey:key]];
				if ([capturedImageNewUser count] > 0)
					[self updateDataFileOnSave4Img:[dic objectForKey:key]];
				NSLog(@"\n\n\n\n\n\n#######################-- post For new user executed successfully --#######################\n\n\n\n\n\n");
				
				successflg=YES;
				userid = [dic objectForKey:key];
				arrayForUserID = [[NSMutableArray alloc]init];
				[arrayForUserID addObject:userid];
				//[allInfoNewUser release];
				[allInfoNewUser removeAllObjects];
				[capturedImageNewUser release];
				
#pragma mark Setting lastVisitedFeature array as signup for not opening splash during LauncherViewTestController
				[lastVisitedFeature removeAllObjects];
				[lastVisitedFeature addObject:@"signup"];
				
				if(checklocation == 1) {
					
					AppNotAvailable *ana = [[AppNotAvailable alloc]init];
					ana.stronlocation = @"Thanks for signing up, ";
					[self.navigationController pushViewController:ana animated:YES];
					[ana release];
				}
				else {
					
					TTURLMap* map = navigator.URLMap;
					[map from:@"tt://launcherTest" toModalViewController:[LauncherViewTestController class]transition:1];
					[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://launcherTest"] applyAnimated:YES]];
					break;
				}
			}
		}
		if ([key isEqualToString:@"Useridexist"])			
		{
			if (![[dic objectForKey:key] isEqualToString:@""])
			{
				whereClicked = 1;
				alertOnChoose = [[UIAlertView alloc] initWithTitle:nil message:@"E-Mail already exists, please try another one!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
				[alertOnChoose show];
				[alertOnChoose release];
				activityView.hidden = YES;
					//[self.view addSubview:loading];
				loading.hidden = YES;
				[activityView stopAnimating];
				btnAdd.hidden = NO;
				[self storeToMutableArray];
				[self createControls];
				
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

- (void)addButtonToKeyboard {
	
		// create custom button
	doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(0, 163, 106, 53);
	doneButton.adjustsImageWhenHighlighted = NO;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) {
		[doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
	} else {        
		[doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
	}
	[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
		// locate keyboard view
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView* keyboard;
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
			// keyboard found, add the button
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
				[keyboard addSubview:doneButton];
		} else {
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
				[keyboard addSubview:doneButton];
		}
	}
}

- (void)keyboardWillShow:(NSNotification *)note {
		// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2) {
		[self addButtonToKeyboard];
	}
}

- (void)keyboardDidShow:(NSNotification *)note {
		// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		[self addButtonToKeyboard];
    }
}

- (void)doneButton:(id)sender {
	
	[FillContact resignFirstResponder];
	[UnsocialAppDelegate playClick];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	/*if(textField == FillContact)
	 doneButton.hidden = YES;*/
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	if (textField == FillPassword2) {
		
		self.navigationItem.rightBarButtonItem = nil;
		[self moveToUpDownAnimation:2:-3];
	}
	else if (textField == FillPersonName) {
		
		self.navigationItem.rightBarButtonItem = nil;
		[self moveToUpDownAnimation:2:-115];
	}
	else if(textField == FillContact)
	{
		[self moveToUpDownAnimation:2:-170];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightbtn_OnClick)] autorelease];
	}
	else
		self.navigationItem.rightBarButtonItem = nil;
	[textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	if (textField == FillPassword2) {
		
		[self moveToUpDownAnimation:2:+3];
	}
	else if (textField == FillPersonName) {
		
		[self moveToUpDownAnimation:1:+115];
	}
	else if(textField == FillContact){
		
		[self moveToUpDownAnimation:1:+170];
	}
}

- (void) moveToUpDownAnimation:(NSInteger) upOrDown:(NSInteger) yAxis {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	btnLinkedIn.frame = CGRectMake(btnLinkedIn.frame.origin.x, (btnLinkedIn.frame.origin.y + yAxis), btnLinkedIn.frame.size.width, btnLinkedIn.frame.size.height);
	lblLinkedIn.frame = CGRectMake(lblLinkedIn.frame.origin.x, (lblLinkedIn.frame.origin.y + yAxis), lblLinkedIn.frame.size.width, lblLinkedIn.frame.size.height);
	itemTableView.frame = CGRectMake(itemTableView.frame.origin.x, (itemTableView.frame.origin.y + yAxis), itemTableView.frame.size.width, 330);
	imgBack.frame = CGRectMake(imgBack.frame.origin.x, (imgBack.frame.origin.y + yAxis), imgBack.frame.size.width, imgBack.frame.size.height);
	heading.frame = CGRectMake(heading.frame.origin.x, (heading.frame.origin.y + yAxis), heading.frame.size.width, heading.frame.size.height);
	[UIView commitAnimations];
}

-(void)rightbtn_OnClick {
	
	self.navigationItem.rightBarButtonItem = nil;
	[self resignAll];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
    [textField resignFirstResponder];
	self.navigationItem.rightBarButtonItem = nil;
	[UnsocialAppDelegate playClick];
    return YES;
}

- (void)dealloc {
	
	[FillLoginId release];
	[FillPassword release];
	[FillPassword2 release];
	[FillPrefix release];
	[FillPersonName release];
	[FillContact release];	
	[dataSourceArray release];	
	
	// added by pradeep on 29 june 2011
	//itemTableView.delegate = nil;
	//imgPicker.delegate = nil;
	// end 29 june 2011
	
	[super dealloc];
}

@end

