//
//  SignIn.h
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShareEvent : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>{

	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UIImageView *imgHeadview, *imgBack;
	NSString *userid, *eventid;
	UITextField *txtUsername;
	UITextField *txtUseremail;
}
@property(nonatomic, retain) NSString *userid, *eventid;
- (void)createControls;
- (BOOL) sendRequest4ShareEvent: (NSString *) flag;
@end
