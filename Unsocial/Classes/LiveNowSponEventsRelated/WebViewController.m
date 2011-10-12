    //
//  twitterWebViewController.m
//  ESET_V1
//
//  Created by santosh khare on 7/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController
@synthesize twitType, activityView, title1, videourl;
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
	
	/*UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];*/
	
	// added by pradeep on 1 june 2011 for returning to dashboard requirement
	
	UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(285.0, 0.0, 33, 30)];
	[rightbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[rightbtn addTarget:self action:@selector(rightbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
	itemNV.rightBarButtonItem = rightbtnitme;
	//rightbtn.hidden = YES;
	
	// end 1 june 2011
	
	activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,30,30)];
	activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	//[activityView setBackgroundColor:[UIColor grayColor]];
	[self.view addSubview:activityView];
	//[activityView startAnimating];
	
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	
	// finished loading, hide the activity indicator in the status bar
	//UIColor *color = [UIColor colorWithRed:105/255 green:105/255 blue:105/255 alpha:0.0];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	/*imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];*/
	
	
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,150,30,30)];
	[loadingView addSubview:activityView];
	UINavigationItem *item = self.navigationItem;
	item.titleView = loadingView;
	[activityView startAnimating];
	
}



- (void) viewDidAppear:(BOOL)animated
{
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	CGRect webFrame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	webView = [[UIWebView alloc] initWithFrame:webFrame];
	[webView setBackgroundColor:[UIColor whiteColor]];
	webView.scalesPageToFit = YES;
	webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	webView.delegate = self;
	NSURL *url = [NSURL URLWithString:videourl];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		
	[webView loadRequest:requestObj];
	
	[self.view addSubview:webView];
	[self becomeFirstResponder];
	
}

- (void) leftbtn_OnClick{
	
	//[self dismissModalViewControllerAnimated:YES];
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
	// added by pradeep on 29 june 2011
	//webView.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
}


@end
