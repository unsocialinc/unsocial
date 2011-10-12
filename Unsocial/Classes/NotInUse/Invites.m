//
//  Invites.m
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Invites.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"

@implementation Invites

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	activityView.hidden = YES;
	//[self.view addSubview:loading];
	//loading.hidden = NO;
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
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	UIImageView *imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"use_case_311.png"];
	[self.view addSubview:imgBack];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Invite Others" frame:CGRectMake(0, 0, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];	
	
	// commneted and added by pradeep on 17 august 2011 for fixing memory issue for retailed object
	//loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	loading = [UnsocialAppDelegate createLabelControlWithoutAutoRelease:@"Searching unsocial\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	// end 17 august 2011
	
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{	
	//	message.hidden = NO;
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

- (void)createControls {
	
	loading.hidden = YES;
	
	UIButton *btnInvite  = [UnsocialAppDelegate createButtonControl:@"" target:self selector:@selector(btnInvite_Click) frame:CGRectMake(34, 280, 250, 45) imageStateNormal:@"invite.png" imageStateHighlighted:@"invite2.png" TextColorNormal:[UIColor whiteColor] TextColorHighlighted:[UIColor blackColor] showsTouch:NO buttonBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:btnInvite];
	[btnInvite release];
}

- (void)btnInvite_Click {
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController") );
	if (mailClass != nil)
	{
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];picker.mailComposeDelegate = self;
		
		NSString *emailBody, *emailSubj;
		emailSubj = @"Invitation to join unsocial";
		emailBody = [[@"Hello, <br /> " stringByAppendingString:[myName objectAtIndex:0]] stringByAppendingString:@" is using this application and want you to join unsocial."];
		[picker setSubject:emailSubj];
		[picker setMessageBody:emailBody isHTML:YES];
		
		//		NSArray *toRecipients = [NSArray arrayWithObject:@"gartsmanfasttrack@gmail.com"]; 
		//		[picker setToRecipients:toRecipients];
		picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		[[self navigationController] presentModalViewController:picker animated:YES];
		[picker release];
	}
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
