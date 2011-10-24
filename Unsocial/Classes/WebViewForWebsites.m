//
//  WebViewForWebsites.m
//  Unsocial
//
//  Created by vaibhavsaran on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewForWebsites.h"


@implementation WebViewForWebsites
@synthesize webAddress;


- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	NSLog(@"WebViewForWebsites");
	self.view.backgroundColor = [UIColor whiteColor];
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(btnBack_Click:)] autorelease];

	UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activity];
	[self navigationItem].rightBarButtonItem = barButton;
	[self navigationItem].rightBarButtonItem.style = UIBarButtonItemStyleBordered;
	[activity release];
	[barButton release];
}

- (IBAction)btnBack_Click:(id)sender {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [webView stopLoading];
    webView.delegate = nil;
    [webView release];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
	NSString *properWebsite = self.webAddress;	
	if ([properWebsite rangeOfString:@"https"].location == NSNotFound) {
		
		properWebsite= [@"http://" stringByAppendingString:properWebsite];
		NSLog(@"properWebsite1 - %@", properWebsite);	
		if ([properWebsite rangeOfString:@"http://http://"].location != NSNotFound)
		{
			properWebsite = [properWebsite stringByReplacingOccurrencesOfString:@"http://http://" withString:@"http://"];
			NSLog(@"properWebsite2 - %@", properWebsite);	
		}
	}
	NSURL *url = [NSURL URLWithString:properWebsite];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];	
	[webView loadRequest:requestObj];
}

-(IBAction)btnRefWebView_Click:(id)sender {
	
	printf("reload\n");
	[webView reload];
}
-(IBAction)btnBackWebView_Click:(id)sender{
	
	printf("goBack\n");
	[webView goBack];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[activity stopAnimating];
	[activity setHidden:YES];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	[activity startAnimating];
	[activity setHidden:NO];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	
	return YES;
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
