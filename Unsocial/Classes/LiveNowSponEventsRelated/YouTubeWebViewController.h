//
//  twitterWebViewController.h
//  ESET_V1
//
//  Created by santosh khare on 7/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YouTubeWebViewController : UIViewController <UIWebViewDelegate>{
	NSString *twitType;
	NSString *title1;
	UIWebView *webView;	
	UILabel *heading;
	UIActivityIndicatorView *activityView;
	UIImageView *imgHeadview;
	UIImageView *imgBack;
}

@property (nonatomic, retain) NSString	*twitType, *title1;
@property (nonatomic, retain)	UIActivityIndicatorView *activityView;
@end
