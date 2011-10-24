//
//  VideoViewController.m
//  AppTango
//
//  Created by santosh khare on 6/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BlogWebViewController.h"
#import "UnsocialAppDelegate.h"
#import "GlobalVariables.h"

@implementation BlogWebViewController

@synthesize webView, description;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
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
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
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
	
	UIImageView *imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"signupback.png"];
	[self.view addSubview:imgBack];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 215, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	activityView.hidden = NO;
	[activityView startAnimating];
}

- (void)leftbtn_OnClick {
	
	[self.navigationController popViewControllerAnimated:YES];
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
- (void)rightbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"poll"];
	[self dismissModalViewControllerAnimated:YES];
}
// end 1 june 2011

- (void)viewDidAppear:(BOOL)animated {	
	[super viewDidAppear:animated];	
	activityView.hidden = YES;
	[self dispWebView];
	[activityView stopAnimating];	
}

- (void) dispWebView {
	
	CGRect webFrame = CGRectMake(0.0, 5.0, 320.0, 400);
	webView = [[UIWebView alloc] initWithFrame:webFrame];
	webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);	
	webView.delegate = self;
	
	NSString *blogUrl = self.description;
	NSString *htmlstring = [NSString stringWithFormat:@"%@", blogUrl];
	NSString *newhtmlstring = [htmlstring stringByReplacingOccurrencesOfString: @"img src=\"images" withString: @"img src=\"http://www.torahbright.com/blog/images"];
	NSString *strFont = [NSString stringWithFormat:@"<span style=\"color:white; font-family:%@;font-size:12px;\"", kAppFontName];
	newhtmlstring = [strFont stringByAppendingString:newhtmlstring];
	newhtmlstring = [newhtmlstring stringByAppendingString:@"</span>"];
	[webView loadHTMLString:newhtmlstring baseURL:nil];
	webView.backgroundColor = [UIColor clearColor];
	webView.opaque = NO;
	webView.userInteractionEnabled = YES;
	[self.view addSubview:webView];
}

@end