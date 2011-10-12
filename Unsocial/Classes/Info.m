//
//  Info.m
//  unsocial
//
//  Created by vaibhavsaran on 11/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Info.h"
#import "UnsocialAppDelegate.h"
#import "InviteUser.h"
#import "GlobalVariables.h"
#import "LinkedInNetworkUpdate.h"
#import "WebViewForWebsites.h"

int cnt4tips;

@implementation Info

- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"VC view will appear");
	
	UIImageView *imgBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 462)];
	imgBackgrnd.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBackgrnd];
	[imgBackgrnd release];
	
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	[imgHeadview release];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;
	[leftbtn release];
	[leftcbtnitme release];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"Info" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];

	/*activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 220, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];	*/

	//if (!itemTableView)
	{
	itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, 420) style:UITableViewStylePlain];
	itemTableView.delegate = self;
	itemTableView.dataSource = self;
	itemTableView.rowHeight = 75;
	itemTableView.backgroundColor = [UIColor clearColor];
	itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:itemTableView];	
	//[itemTableView release];
	}
	//else 
	{
		//[itemTableView reloadData];
	}

}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		// Set up the cell...	
	
	UILabel *lbl = [UnsocialAppDelegate createLabelControl:@"Version" frame:CGRectMake(15, 0, 290, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:14 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lbl];
	
	UIImageView *imgPplBack = [UnsocialAppDelegate createImageViewControl:CGRectMake(0, 20, 320, 55) imageName:@"mailboxrowback.png"];
	[cell.contentView addSubview:imgPplBack];
	
	UILabel *lbl2 = [UnsocialAppDelegate createLabelControl:@"unsocial version 1.8" frame:CGRectMake(15, 20, 290, 55) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:14 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lbl2];

	if (indexPath.row == 1)
	{
		lbl2.text = @"feedback@unsocial.mobi";
		lbl.text = @"Feedback";
	}
	
	else if (indexPath.row == 2)		
	{
		lbl2.text = @"events@unsocial.mobi";
		lbl.text = @"Events";		
	}
	
	else if (indexPath.row == 3)		
	{
		lbl2.text = @"info@apptango.com";
		lbl.text = @"General Inquiry";		
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	NSString *txtEmail;
	if (indexPath.row == 1) {
		
		txtEmail = @"feedback@unsocial.mobi";
	}
	else if (indexPath.row == 2) {
		
		txtEmail = @"events@unsocial.mobi";
	}
	else if (indexPath.row == 3) {
		
		txtEmail = @"info@apptango.com";
	}
	else
	{
		return;
	}

	Class mailClass = (NSClassFromString(@"MFMailComposeViewController") );
	if (mailClass != nil)
	{
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
		
		if (picker) {
			
			NSArray *toRecipients = [NSArray arrayWithObject:txtEmail]; 
			[picker setToRecipients:toRecipients];
			picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
			[[self navigationController] presentModalViewController:picker animated:YES];
			[toRecipients release];
		}
		//[picker release];
	}
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

- (void)viewDidAppear:(BOOL)animated {
	
	//[activityView stopAnimating];
}

- (void) leftbtn_OnClick {

	[self dismissModalViewControllerAnimated:YES];
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
	// added by pradeep on 29 june 2011
	//itemTableView.delegate = nil;
	// end 29 june 2011
    [super dealloc];
	//[tips release];
}


@end
