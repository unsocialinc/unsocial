//
//  SettingsCurrentStatus.h
//  Unsocial
//
//  Created by vaibhavsaran on 02/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsCurrentStatus : UIViewController  <UITextViewDelegate, UIAlertViewDelegate, NSXMLParserDelegate>{

	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSString * currentElement;
	NSMutableDictionary * item;
	
	UILabel *loading;
	UIImagePickerController *imgPicker;
	UITextView *textViewAbout;
	UIActivityIndicatorView *activityView;
	NSString *userid, *deviceString;
	NSString *userabout;
	UIImageView *imgHeadview, *imgBack;
	UIButton *btnEdit;
	NSMutableString *statusUser;
	NSMutableArray *aryStatus;
	
	NSString *strsetstatus;
}
- (BOOL) getDataFromFile;
- (void) updateDataFileOnSave;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (void) getStatusOfUser:(NSString *)inid;
@property (nonatomic, retain) NSString *strsetstatus;
@property (nonatomic, retain) NSString *userid;
- (BOOL) sendNowStatus: (NSString *) flag;
- (void)createControls;
@end
