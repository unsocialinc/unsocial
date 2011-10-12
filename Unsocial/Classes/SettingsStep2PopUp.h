//
//  PatientDetail2ViewController.h
//  CLINIC App
//
//  Created by santosh khare on 18/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsStep2PopUp : UIView <UITextFieldDelegate>
{
	UITextField *txtPersonPublicProfile;
	UIImageView *imgBack;
	UIBarButtonItem *btnDone1;
	BOOL numberPadShowing;
	UIButton *doneButton;
}
@property (nonatomic, retain)	UITextField *txtPersonPublicProfile;
- (void) setViewMovedUp:(BOOL)movedUp:(NSInteger) setOrigin;
@end
