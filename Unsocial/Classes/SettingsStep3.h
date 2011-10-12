//
//  SettingsStep3.h
//  Unsocial
//
//  Created by vaibhavsaran on 15/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsStep3 : UIViewController <UITextViewDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate>
{
	UILabel *loading;
	UIImagePickerController *imgPicker;
	UITextView *textViewAbout;
	UIImageView *imageGrabed, *imgBack;
	BOOL cameraUse, iscemera;
	NSMutableArray *capturedImage, *capturedText;
	UIAlertView *alertOnChoose;
	UIActivityIndicatorView *activityView;
	NSString *userid, *deviceString;
	NSString *userabout, *controlCamefrom;
}

//- (void) displayAnimation;
- (void)dialogSelection;
- (void) switchTouched;
- (IBAction)recordNow;
-(void) captureImage;
- (void)createControls;

- (BOOL) getDataFromFile;
- (BOOL) sendNow: (NSString *) flag;
- (void) updateDataFileOnSave:(NSString *)uid;
- (void) updateDataFileOnSave4Img:(NSString *)uid;
- (BOOL) getImageFromFile;

@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic,retain) NSString *userid, *userabout, *controlCamefrom;
@end
