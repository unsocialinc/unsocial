//
//  WelcomeViewController.h
//  Unsocial
//
//  Created by vaibhavsaran on 27/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WelcomeViewController : UIViewController {

	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UIImageView *imgHeadview, *imgBack;
	NSString *userid;
	IBOutlet UIButton *btnLogin, *btnSignUp, *btnLinkedIn, *btnLearnMore, *btnLinkedInLogo;
}
- (IBAction) btnLearnMore_Click;
- (IBAction) btnLinkedIn_Click;
- (IBAction) btnLinkedInLogo_Click;
- (IBAction) btnLogin_Click;
- (IBAction) btnSignUp_Click;
@property(nonatomic, retain) NSString *userid;

@end