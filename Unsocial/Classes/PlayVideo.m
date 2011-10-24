//
//  SingleWebsiteWebViewController.m
//  AppTango
//
//  Created by santosh khare on 7/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PlayVideo.h"
#import "GlobalVariables.h"
#import "UnsocialAppDelegate.h"

@implementation PlayVideo
@synthesize webView, websUrl;

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"ViewVideo view will appear");
	NSLog(@"User's Userid- %@", [arrayForUserID objectAtIndex:0]);
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
	
	UIImageView *imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"use_case_311.png"];
	[self.view addSubview:imgBack];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"My Videos" frame:CGRectMake(0, 0, 300, 43) txtAlignment:UITextAlignmentRight numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:24 txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	loading = [UnsocialAppDelegate createLabelControl:@"Saving...\nplease standby" frame:CGRectMake(25, 125 + yAxisForSettingControls, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180 + yAxisForSettingControls, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	UIImage *image = [UIImage imageNamed: @"headlogo.png"];
	UIImageView *imageview = [[UIImageView alloc] initWithImage: image];
	UINavigationItem *item1 = self.navigationItem;
	item1.titleView = imageview;	
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,150,30,30)];
	[loadingView addSubview:activityView];
	UINavigationItem *item1 = self.navigationItem;
	item1.titleView = loadingView;
	[activityView startAnimating];
	
}
- (void)viewDidAppear:(BOOL)animated {

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,30,30)];
	activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	[self.view addSubview:activityView];
	[activityView startAnimating];
	
	[self becomeFirstResponder];
	[super viewDidAppear:animated];	
	activityView.hidden = YES;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
	
	//websUrl = [NSString stringWithFormat:@"http://rstrings.com"];
	CGRect webFrame = CGRectMake(19, 45, 282, 355);
	
	webView = [[UIWebView alloc] initWithFrame:webFrame];
	[webView setBackgroundColor:[UIColor whiteColor]];
	webView.scalesPageToFit = YES;
	webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	webView.delegate = self;
	NSURL *url = [NSURL URLWithString:websUrl];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
	[self.view addSubview:webView];		
	[activityView stopAnimating];
}

- (void)leftbtn_OnClick {
	
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}


@end
