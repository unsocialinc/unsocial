//
//  WebViewForWebsites.h
//  Unsocial
//
//  Created by vaibhavsaran on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewForWebsites : UIViewController {

	UIActivityIndicatorView * activityIndicator;
	UINavigationItem *itemNV;
	UIImageView *imgHeadview, *imgBack, *imgBack1;
	NSString *urlstring;
	IBOutlet UIToolbar *toolbar;
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UIWebView *webView;
	NSString *webAddress;
}
@property (nonatomic, retain) NSString *webAddress;
-(IBAction)btnBack_Click:(id)sender;
-(IBAction)btnBackWebView_Click:(id)sender;
-(IBAction)btnRefWebView_Click:(id)sender;

@end
