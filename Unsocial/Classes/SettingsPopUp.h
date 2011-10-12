//
//  PatientDetail2ViewController.h
//  CLINIC App
//
//  Created by santosh khare on 18/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsStep2.h"

@interface SettingsPopUp : UIView <UITextFieldDelegate>
{
	UITextField *txtPersonEmail, *txtPersonContact;
	UIImageView *imgBack;
	UIBarButtonItem *btnDone1;
	SettingsStep2 *settingsStep2;
}
@property (nonatomic, retain)	UITextField *txtPersonEmail, *txtPersonContact;
- (void) setViewMovedUp:(BOOL)movedUp:(NSInteger) setOrigin;
@end
