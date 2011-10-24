//
//  VideoViewController.h
//  AppTango
//
//  Created by santosh khare on 6/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BlogWebViewController : UIViewController <UIWebViewDelegate> {
	NSArray *options;
	NSXMLParser * rssParser;
	UIWebView *webView;
	UIActivityIndicatorView *activityView;
	NSMutableArray * stories;
	NSString *description;
	
}
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *description;
- (void) dispWebView;
@end
