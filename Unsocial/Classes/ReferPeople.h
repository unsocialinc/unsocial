//
//  SignIn.h
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ReferPeople : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, ABPeoplePickerNavigationControllerDelegate>{

	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UIImageView *imgHeadview, *imgBack;
	NSString *userid, *eventid, *referralemail, *referralphone, *referraltags, *referralname;
	UITextField *txtUsername;
	UITextField *txtUseremail;
}
@property(nonatomic, retain) NSString *userid, *eventid, *referralemail, *referralphone, *referraltags, *referralname;
- (void)createControls;
- (BOOL) sendRequest4ShareEvent: (NSString *) flag;
@end
