//
//  SplashScreen.h
//  Unsocial
//
//  Created by santosh khare on 8/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SplashScreen.h"
#import "LauncherViewTestController.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"

@implementation SplashScreen
@synthesize threadProgressView, imgBack;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {	
	
	/*CGRect lblFrameforimg = CGRectMake(0, 0, 320.0, 460.0);
	UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
	img.frame = lblFrameforimg;
	[self.view addSubview:img];*/
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
	
	bar.hidden = TRUE;
	
	//NSLog(@"\n\n\n\n#################Welcome Image name#################\n\n\n\n %@", splashImage);
	CGRect labelFrame = CGRectMake(0, 0, 320.0, 460.0);
	UIImage *splashimage = [[UIImage alloc] init];
	
	if(splashImage)
		splashimage = [splashImage objectAtIndex:0];
	else
		splashimage = [UIImage imageNamed:@"splashwelcome.png"];
	UIImageView *backImg = [[UIImageView alloc] initWithImage:splashimage];
	backImg.frame = labelFrame;
	[self.view addSubview:backImg];
	
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = splashimage;
	[self.view addSubview:imgBack];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"welcome2.png"];
	[self.view addSubview:imgBack];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Searching unsocial\nfinding location" frame:CGRectMake(25, 125 + 80, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:loading];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180 + 80, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
	
	//call the progress view - we eventually need to use the slider with hidden thumb and orange bar
	threadProgressView = [[PDColoredProgressView alloc] initWithFrame:CGRectMake(0.0, 452.0, 320.0, 10.0)];
	threadProgressView.progressViewStyle = UIProgressViewStyleDefault;
	[threadProgressView setTintColor: [UIColor orangeColor]];
	[self.view addSubview:threadProgressView];
	
	//and now start your actual processing in background
	[NSThread sleepForTimeInterval:1];  
	[NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
}

- (void)startTheBackgroundJob {  
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  
	// This is where rest of your calls go - such as sending data to server/retrieving status stuff etc.
	
	[NSThread sleepForTimeInterval:3];  
	[self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];  
	[pool release];  	       
}  

/*- (void)makeMyProgressBarMoving {  
	float actual = [threadProgressView progress];  
	if (actual < 1) {  
		threadProgressView.progress = actual + 0.05;  
		[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
	}  
	else { 
		threadProgressView.hidden = YES;
		//frontImg.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);	
		//[self dismissModalViewControllerAnimated:YES];
		[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval) 0.55 target:self selector:@selector(makeSplashMove) userInfo:nil repeats:NO];
	}
}

- (void) makeSplashMove {
	
	//theFGImageView.center = Zone5;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration:1.50f];
	frontImg.frame = CGRectMake(0.0f, -400.0f, 320.0f, 460.0f);
	//theFGImageView.center = Zone5;
	[UIView commitAnimations];
	
	//now hide
	frontImg.frame = CGRectMake(0.0f, -400.0f, 320.0f, 460.0f);		
	[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval) 3.55 target:self selector:@selector(makeSplashHide) userInfo:nil repeats:NO];
	
}

- (void) makeSplashHide {
	
	//theFGImageView.center = Zone5;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration:1.50f];
	frontImg.hidden = YES;
	//theFGImageView.center = Zone5;
	[UIView commitAnimations];
	
	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

	
	[self dismissModalViewControllerAnimated:YES];
	
	
}*/

- (void)makeMyProgressBarMoving {

	float actual = [threadProgressView progress];  
	if (actual < 1) {
		
		threadProgressView.progress = actual + 0.10;  
		[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
	}  
	else {
		
		threadProgressView.hidden = YES;
		[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval) 0.55 target:self selector:@selector(makeSplashMove) userInfo:nil repeats:NO];
	}
}

- (void) makeSplashMove {

	[activityView stopAnimating];
	loading.hidden = YES;

	//theFGImageView.center = Zone5;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration:0.50f];
	imgBack.frame = CGRectMake(0.0f, -400.0f, 320.0f, 460.0f);
	//theFGImageView.center = Zone5;
	[UIView commitAnimations];
	
	//now hide
	imgBack.frame = CGRectMake(0.0f, -400.0f, 320.0f, 460.0f);		
	[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval) 0.55 target:self
								   selector:@selector(makeSplashHide) userInfo:nil repeats:NO];
	
}

- (void) makeSplashHide {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationBeginsFromCurrentState: YES];
	[UIView setAnimationDuration:0.50f];
	imgBack.hidden = YES;
	//theFGImageView.center = Zone5;
	[UIView commitAnimations];
	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;	
	[self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
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
