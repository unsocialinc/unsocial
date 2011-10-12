//
//  Settings.h
//  Unsocial
//
//  Created by vaibhavsaran on 07/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SettingsPopUp.h"

@interface Settings : UIViewController <UIAlertViewDelegate, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
	
	NSMutableArray *capturedImage, *allInfo2;
	UIImageView *imgHeadview, *imgBack, *imageGrabed, *roundedView, *imgHorSep, *loadingBack;
	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UITextField *txtPrefix, *txtPersonName;
	NSString *deviceString;
	BOOL cameraUse, iscemera, savingProfile;
	UIImagePickerController *imgPicker;
	UIAlertView *alertOnChoose;
	NSInteger whereClicked, matchemail;
	NSString *username, *userid, *userprefix, *useremail, *usercontact, *userlinkedinmailid;
	NSInteger comingfrom;
	UIButton *btnSave;
	UITextField *txtPersonEmail, *txtPersonContact, *txtPersonLinkedInEmail;
	UIButton *btnSelPrefix, *btnAddPhoto;
	UILabel *personName, *personEmail, *personContact, *namePrefix, *lblProfilePic, *heading;
	NSArray *aray1;
}
- (void)resignAll;
- (void)checkForLeftNavClick;
@property (nonatomic, retain) NSArray *aray1;
- (void) getPrefixFromFile;
@property (assign, nonatomic) NSInteger comingfrom;
@property(nonatomic, retain) NSString *username, *userid, *userprefix, *useremail, *usercontact, *userlinkedinmailid;
@property (nonatomic, retain) UIImagePickerController *imgPicker;

- (void)saveAndSendData;
- (void) viewMovedUp:(NSInteger) yAxis;
- (BOOL) send4GeneralInfo: (NSString *) flag;
- (void) updateDataFileOnSave:(NSString *)uid;
- (void) updateDataFileOnSave4Img:(NSString *)uid;
- (UIImageView *)getImageFromFile;
- (BOOL)getDataFromFile;
- (void)storeToMutableArray;
- (void)dialogSelection;
- (void)captureImage;
- (void)recordNow;
- (void)createControls;
- (void)switchTouched;
@end
