//
//  SignIn.h
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForgetPwd : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>{

	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UIImageView *imgHeadview, *imgBack;
	NSString *userid, *useremail;
	UITextField *txtUsername;
}
@property(nonatomic, retain) NSString *userid, *useremail;
- (void)createControls;
- (BOOL) sendRequest4ForgotPwd: (NSString *) flag;
@end
