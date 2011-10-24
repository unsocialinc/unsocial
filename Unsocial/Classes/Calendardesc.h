//
//  SignIn.h
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <EventKit/EventKit.h>

@interface Calendardesc : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>{

	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UIImageView *imgHeadview, *imgBack;
	//NSString *userid, *caldesc, *caltitle;
	UITextField *txtUsername;
	NSString *userid, *caldesc, *caltitle, *calfrom, *calto, *caldate;
	UIButton *btnSave;

}
@property(nonatomic, retain) NSString *userid, *caldesc, *caltitle, *calfrom, *calto, *caldate;
- (void)createControls;
- (BOOL) sendRequest4ForgotPwd: (NSString *) flag;
@end
