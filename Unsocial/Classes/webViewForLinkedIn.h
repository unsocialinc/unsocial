//
//  webViewForLinkedIn.h
//  Unsocial
//
//  Created by vaibhavsaran on 06/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface webViewForLinkedIn : UIViewController <UIWebViewDelegate>{

	UIWebView *webView;
	NSString *status, *camefrom;
	UIActivityIndicatorView *activityView, *pactivityView;
	UINavigationItem *itemNV;
	NSArray *arraySignIn, *arrayUseridFromWebview;
	UIAlertView *progressAlert;
	UIImageView *imgHeadview;
	NSString *deviceTocken, *deviceUDID, *deviceType, *ursprefix, *urspassword, *urslastlogindate, *urslongitude, *urslatitude, *ursisallow, *usrid, *fname, *lname, *useremail, *doctitle, *linkedInToken;
}
- (BOOL) getLocationLock;
- (BOOL) sendUserLogingInfo: (NSString *) flag;
- (void) updateDataFileOnSave:(NSString *)uid;
@property (nonatomic, retain) NSArray *arraySignIn;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *status, *camefrom;
@property (nonatomic, retain) NSString *deviceTocken, *deviceUDID, *deviceType, *ursprefix, *urspassword, *urslastlogindate, *urslongitude, *urslatitude, *ursisallow, *usrid, *fname, *lname, *useremail, *linkedInToken;
@end
