//
//  SignIn.h
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppNotAvailable.h"

@interface SignIn : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>{

	UIActivityIndicatorView *activityView;
	UILabel *loading, *lblLinkedIn;
	UIImageView *imgHeadview, *imgBack;
	NSString *userid;
	UIButton *btnLinkedIn;
}
@property(nonatomic, retain) NSString *userid;
- (void) resignAll;
- (void) createControls;
- (void) viewMovedUp:(NSInteger) yAxis;
- (BOOL) sendUserLogingInfo: (NSString *) flag;
- (void) updateDataFileOnSave:(NSString *)uid;
@end
