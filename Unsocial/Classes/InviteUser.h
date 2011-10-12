//InviteUser
//  InviteUser.h
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface InviteUser : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, ABPeoplePickerNavigationControllerDelegate>{

	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UIImageView *imgHeadview, *imgBack;
	NSString *userid;
	UITextField *txtFriendName, *txtEmail;
	NSInteger alertFor;
}
@property(nonatomic, retain) NSString *userid;
- (void)createControls;
- (BOOL) sendInvitation: (NSString *) flag;
//- (void) updateDataFileOnSave:(NSString *)uid;
@end
