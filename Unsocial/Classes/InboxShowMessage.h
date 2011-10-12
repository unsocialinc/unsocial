//
//  InboxShowMessage.h
//  Unsocial
//
//  Created by vaibhavsaran on 28/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import <Three20UICommon/UIViewControllerAdditions.h>
#import <Three20UI/UIViewAdditions.h>
#import <AudioToolbox/AudioServices.h>

@interface InboxShowMessage : UIViewController <UITextViewDelegate, UIAlertViewDelegate, TTPostControllerDelegate, UIActionSheetDelegate, NSXMLParserDelegate> {

	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *userImage;
	UILabel *fromName, *loading;
	UITextView *msgDescription;
	NSString *strFrom,  *strFromName, *strMsgDescription, *strDateTime, *strMsgId, *strReadMsg, *strPurpose, *currentusername;
	UIAlertView *errorAlert;
	TTSearchlightLabel* label;
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	UILabel *lblFrom, *lblMsgDecr;
	SystemSoundID beep;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	NSString * currentElement;
	NSMutableString *userid, *userdevicetocken, *userprefix, *username, *useremail, *userlastuse, *usercontact, *userwebsite, *usercompany, *userlinkedin, *userabout, *userind, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab, *userlinkedinemailid, *usertitle;
	
	NSMutableString *currentImageURL;
	
	NSMutableArray *userInfo;
	NSMutableDictionary *userInfoDic;
}
- (void)btnReply_Click;
- (BOOL) sendMessage:(NSString *)msgSentText;
- (NSInteger) sendNow: (NSString *) flag;
- (void)createControls;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (void) getProfile:(NSString *) flg4whichtab;
- (BOOL) getDataFromFile1;
- (BOOL) getDataFromFile2;
- (void) playSound;

@property(nonatomic, retain)NSString *strFrom, *strFromName, *strMsgDescription, *strDateTime, *strReadMsg, *strMsgId, *strPurpose;
@end
