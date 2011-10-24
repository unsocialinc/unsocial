//
//  InvitePeople.m
//  Unsocial
//
//  Created by vaibhavsaran on 24/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InvitePeople.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"

@implementation InvitePeople

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	[imgHeadview release];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(btnLeft_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	self.navigationItem.leftBarButtonItem = leftcbtnitme;
	[leftbtn release];
	[leftcbtnitme release];
	
		//lblHeading.frame = CGRectMake(15, 0, 290, 43);
		//[lblHeading setFont:[UIFont fontWithName:kAppFontName size:kAppMainHeadingFontSize]];
		//lblHeading.textColor = [UIColor orangeColor];
		//lblHeading.backgroundColor = [UIColor clearColor];
	/*
	UIImageView *imgTipsBackgrnd2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 225-100, 320, 135)];
	imgTipsBackgrnd2.image = [UIImage imageNamed:@"tipsback2.png"];
	[self.view addSubview:imgTipsBackgrnd2];
	*/
	/*UIImageView *imgTipsHor = [[UIImageView alloc]initWithFrame:CGRectMake(50, 252-100, 225, 2)];
	imgTipsHor.image = [UIImage imageNamed:@"dashboardhorizontal.png"];
	[self.view addSubview:imgTipsHor];
	
	UILabel *lblTipsInv = [UnsocialAppDelegate createLabelControl:@"Invite Friends" frame:CGRectMake(40, 230-100, 255, 20) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:13 txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:lblTipsInv];
	
	tipsInvite = [UnsocialAppDelegate createTextViewControl:@"You can easily invite friends and family to join unsocial." frame:CGRectMake(42, 120, 240, 90) txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor] fontwithname:kAppFontName fontsize:15 returnKeyType:UIReturnKeyDefault keyboardType:UIKeyboardTypeDefault scrollEnabled:YES editable:NO];*/

	lblHeading.text = @"Invite People";
	[lblHeading setFont:[UIFont fontWithName:kAppFontName size:kAppMainHeadingFontSize]];
	lblHeading.textColor = [UIColor orangeColor];
	lblHeading.backgroundColor = [UIColor clearColor];
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(10, 40, 300, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	
	tipsInvite.text = @"You can easily invite friends and family to join unsocial.";
	tipsInvite.contentInset = UIEdgeInsetsMake(-4, -8, 0, 0);
	[self.view addSubview:tipsInvite];
	
	[btnEmail addTarget:self action:@selector(btnEmail_Click) forControlEvents:UIControlEventTouchUpInside];
	
	// commented by pradeep on 9 june 2011 for disabling inviteuser via linked-in also hide btn on xib file
	//[btnLinkedIn addTarget:self action:@selector(btnLinkedIn_Click) forControlEvents:UIControlEventTouchUpInside];
}

- (void) btnEmail_Click {
	
	printf("Hello");
	inviteuser = [[InviteUser alloc]init];
	[self.navigationController pushViewController:inviteuser animated:YES];
	[inviteuser release];
}

- (void) btnLinkedIn_Click {
	
	LinkedInNetworkUpdate *linkedInNetworkUpdate = [[LinkedInNetworkUpdate alloc]init];
	[self.navigationController pushViewController:linkedInNetworkUpdate animated:YES];
	[linkedInNetworkUpdate release];
}

- (void)btnLeft_OnClick {
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
