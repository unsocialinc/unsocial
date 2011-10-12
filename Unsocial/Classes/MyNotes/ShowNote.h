//
//  ShowNote.h
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

@interface ShowNote : UIViewController <UITextViewDelegate, UIAlertViewDelegate, TTPostControllerDelegate, UIActionSheetDelegate, NSXMLParserDelegate, UITextViewDelegate> {

	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *userImage;
	UILabel *fromName, *loading;
	UITextView *msgDescription;
	NSString *strAssociatedUserID,  *strNoteHeader, *strAssociatedUserName, *strNoteCreationDate, *strNoteId, *strIsNoteRead, *strAtEvent, *strNoteCategory, *strShortNote, *strSavedAt, *strPurpose;
	UIAlertView *errorAlert;
	TTSearchlightLabel* label;
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	UILabel *lblFrom;
	SystemSoundID beep;
	
	UILabel *savedAt, *savedDate, *savedTime, *lblNote, *lblAtEvent;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	NSString * currentElement, *camefromwhichoption, *eventid4attendeelistofnormalevent;
	NSMutableString *userid, *userdevicetocken, *userprefix, *username, *useremail, *userlastuse, *usercontact, *userwebsite, *usercompany, *userlinkedin, *userabout, *userind, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab, *userlinkedinemailid, *usertitle;
	
	NSMutableString *currentImageURL;
	
	NSMutableArray *userInfo;
	NSMutableDictionary *userInfoDic;
	UITextView *tvNoteDecr;
	UITextView *tvNote;
	
	UIButton *btnDeleteNote;
	NSInteger alertviewtype;
}
- (void)btnReply_Click;
- (BOOL) sendMessage:(NSString *)msgSentText;
- (NSInteger) sendNow4DeleteNUpdateNote: (NSString *) flag;
- (void)createControls;
- (void) parseXMLFileAtURL:(NSString *)URL;
//- (void) getProfile:(NSString *) flg4whichtab;
- (BOOL) getDataFromFile1;
- (BOOL) getDataFromFile2;
- (void) playSound;
- (BOOL) updateNoteRequest: (NSString *) notetxt;

@property(nonatomic, retain) NSString *strAssociatedUserID,  *strNoteHeader, *strAssociatedUserName, *strNoteCreationDate, *strNoteId, *strIsNoteRead, *strAtEvent, *strNoteCategory, *strShortNote, *strSavedAt, *strPurpose, *camefromwhichoption, *eventid4attendeelistofnormalevent;
@end
