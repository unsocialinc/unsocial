//
//  twitterWebViewController.h
//  ESET_V1
//
//  Created by santosh khare on 7/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate>{
	NSString *twitType;
	NSString *title1, *videourl;
	UIWebView *webView;	
	UIActivityIndicatorView *activityView;
	UIImageView *imgheader;
	UIImageView *imgHeadview;
	UIImageView *imgBack;
	UILabel *loading;
}

@property (nonatomic, retain) NSString	*twitType, *title1, *videourl;
@property (nonatomic, retain)	UIActivityIndicatorView *activityView;
@end
