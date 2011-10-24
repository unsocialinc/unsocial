//
//  SignIn.h
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChangePwd : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>{

	UIActivityIndicatorView *activityView;
	UILabel *loading, *lblCurrPwd, *lblNewPwd, *lblRePwd, *heading;
	UIImageView *imgHeadview, *imgBack, *imgHorSep;
	NSString *userid;
	UITextField *txtCurrPwd, *txtNewPwd, *txtRePwd;
}
@property(nonatomic, retain) NSString *userid;
- (BOOL) sendRequest4ChangePwd: (NSString *) flag;
- (void)createControls;
@end
