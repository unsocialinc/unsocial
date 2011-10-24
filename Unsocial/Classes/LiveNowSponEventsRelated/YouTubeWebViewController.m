    //
//  twitterWebViewController.m
//  ESET_V1
//
//  Created by santosh khare on 7/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YouTubeWebViewController.h"
#import "YouTubeView.h"
#import "UnsocialAppDelegate.h"

@implementation YouTubeWebViewController
@synthesize twitType, activityView, title1;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor clearColor];
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
	//rightbtn.hidden = YES;
	
	// end 1 june 2011
	
	/*UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];*/
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	
	// finished loading, hide the activity indicator in the status bar
	/*[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	//activityView.hidden = TRUE;
	//UIImage *image = [UIImage imageNamed: @"Header4.png"];
	//UIImageView *imageview = [[UIImageView alloc] initWithImage: image];
	UINavigationItem *item = self.navigationItem;
	UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
	tv.backgroundColor = [UIColor clearColor];
	tv.textColor = [UIColor whiteColor];
	tv.textAlignment = UITextAlignmentCenter;
	[tv setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
	tv.text = title1;
	
	item.titleView = tv;*/
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:title1 frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,30,30)];
	activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,150,30,30)];
	[loadingView addSubview:activityView];
	UINavigationItem *item = self.navigationItem;
	item.titleView = loadingView;
	[activityView startAnimating];
	
}



- (void) viewDidAppear:(BOOL)animated
{
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:title1 frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	if ([twitType compare:@""] == NSOrderedSame) {
		//[self dialogSelection];
		
		CGRect labelFrame = CGRectMake(5, 30, 320.0, 15);
		UILabel *recnotfound = [[UILabel alloc] initWithFrame:labelFrame];
		recnotfound.textColor = [UIColor blackColor];
		recnotfound.font = [UIFont systemFontOfSize:14];
		recnotfound.backgroundColor = [UIColor clearColor];
		recnotfound.text = @"Records not found."; //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page_submit.png"]];
		//img4novisitedpropertyrec.frame = labelFrame;
		recnotfound.hidden = NO;
		[self.view addSubview:recnotfound];		
	}
	
	else if (!webView) {
		webView = [[YouTubeView alloc] 
									initWithStringAsURL:twitType 
									frame:CGRectMake(10, 45, 300, 300)];
		
		
	}
	
	[self.view addSubview:webView];
	[self becomeFirstResponder];	
	 
}

- (BOOL)hidesBottomBarWhenPushed{
	return TRUE;
}

-(void)leftbtn_OnClick
{
	//DashboardViewController *dvc = [[DashboardViewController alloc] init];
	//[self.navigationController pushViewController:dvc animated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
- (void)rightbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	[self dismissModalViewControllerAnimated:YES];
}
// end 1 june 2011


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
