//
//  SingleWebsiteWebViewController.h
//  AppTango
//
//  Created by santosh khare on 7/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// its used for single web site feature (as soon as we click on single website feature tab, web view displays a selected web site)
@interface PlayVideo : UIViewController <UIWebViewDelegate> {
	
	NSArray *options;
	UIWebView *webView;
	UIActivityIndicatorView *activityView;
	NSString *websUrl;
	UILabel *loading;
}
@property (nonatomic, retain) NSString *websUrl;
@property (nonatomic, retain) UIWebView *webView;
@end
