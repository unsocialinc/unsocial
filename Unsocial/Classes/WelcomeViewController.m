//
//  WelcomeViewController.m
//  Unsocial
//
//  Created by vaibhavsaran on 27/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "GlobalVariables.h"
#import "WelcomeViewController.h"
#import "UnsocialAppDelegate.h"
#import "ShowTipsOnWelcome.h"
#import "SignIn.h"
#import "SignUp.h"
#import "SplashScreen.h"
#import "webViewForLinkedIn.h"


@implementation WelcomeViewController
@synthesize userid;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    [super viewDidLoad];
	NSLog(@"VC view will appear");
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	[imgHeadview release];

	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 64, 29)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	itemNV.leftBarButtonItem = leftcbtnitme;
	leftbtn.hidden = YES;

	
		//*********************** splash start
	
	if([lastVisitedFeature count] >0)
	{
		NSLog(@"%@", [lastVisitedFeature objectAtIndex:0]);
		if ([[lastVisitedFeature objectAtIndex:0] isEqualToString:@"welcome"])
		{
			[lastVisitedFeature removeAllObjects];
				// i am just removing the all aojects from lastvisitedfeature array, nothing else since during this case welcome view is showing 
		}
		else
		{
				//and now start your actual processing in background
			
				// commented by pradeep on 25 may 2011 for disabling splashexperience
				//[NSThread detachNewThreadSelector:@selector(createSplashExperience) toTarget:self withObject:nil];
			
				//[NSThread sleepForTimeInterval:3]; 
				// 25 may 2011 end
		}
	}
	else
	{
			//and now start your actual processing in background
		
			// commented by pradeep on 25 may 2011 for disabling splashexperience
			//[NSThread detachNewThreadSelector:@selector(createSplashExperience) toTarget:self withObject:nil];
		
			//[NSThread sleepForTimeInterval:6]; 
		
			// end 25 may 2011
		
		
		[lastVisitedFeature removeAllObjects];
		[lastVisitedFeature addObject:@"welcome"];		
	}	
		//*********************** splash end	
}

- (IBAction)btnLearnMore_Click {
	
	ShowTipsOnWelcome *vc = [[ShowTipsOnWelcome alloc]init];
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
}

- (IBAction) btnLinkedIn_Click {
	
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

-(IBAction)btnLogin_Click {
	
	SignIn *vc = [[SignIn alloc]init];
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
}

-(IBAction)btnSignUp_Click {
	
	SignUp *vc = [[SignUp alloc]init];
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
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
