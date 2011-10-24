//
//  SettingsStep5.h
//  Unsocial
//
//  Created by vaibhavsaran on 19/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@interface SettingsStep5 : TTViewController <UITextFieldDelegate, UINavigationControllerDelegate, TTScrollViewDataSource, UIAlertViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, NSXMLParserDelegate> {

	NSArray* _colors;
	UILabel *loading;
	UIImage *imgHead;
	UIImageView *imgHeadview, *imageGrabed;
	UIImageView *imgBack, *imgBack2;
	UIActivityIndicatorView *activityView;
	UIImagePickerController *imgPicker;
	BOOL cameraUse, savingProfile, iscemera;
	NSMutableArray *capturedImage, *capturedText;
	UIAlertView *alertOnChoose;
	NSString *videourl, *userid, *controlCamefrom;
	NSString *deviceString;
	NSInteger comingfrom;
	NSString *userid4digiboard;
	UIButton *btnSave;
	
	TTScrollView* _scrollView;
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableArray * stories4digitalbillboard;
	NSString *strFrom,  *strFromName, *strMsgDescription, *strDateTime, *strMsgId, *strReadMsg, *strPurpose;//, *userid;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	NSString * currentElement;
	NSMutableString *currentImageURL, *digitalBillBoardImageURL;
}
- (BOOL) checkForFlagUnsocialTile:(NSString *)filename;
- (void)btnSave_Click;
- (void)createControls;
- (void)dialogSelection;
- (void) switchTouched;
- (IBAction)recordNow;
-(void) captureImage;
- (BOOL) getDataFromFile;
- (BOOL) sendNow4DigiBill: (NSString *) flag;
- (void) updateDataFileOnSave:(NSString *)uid;
- (void) updateDataFileOnSave4Img:(NSString *)uid;
- (BOOL) getImageFromFile;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (void) getUnsocialTile:(NSString *)userid;
- (void) saveLocalBillBoardFromRSS:(UIImage *)userimage;

@property (assign, nonatomic) NSInteger comingfrom;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic,retain) NSString *videourl, *userid, *controlCamefrom, *userid4digiboard;
@end
