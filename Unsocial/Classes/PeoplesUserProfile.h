//
//  PeoplesUserProfile.h
//  Unsocial
//
//  Created by vaibhavsaran on 23/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import <Three20UICommon/UIViewControllerAdditions.h>
#import <Three20UI/UIViewAdditions.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AudioToolbox/AudioServices.h>
#import "asyncimageview.h"

@interface PeoplesUserProfile : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, TTPostControllerDelegate, NSXMLParserDelegate>{

	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *userImage;
	
	NSString *username, *userid, *userind, *usersubind, *userrole, *userintind, *userintsubind, *userintrole, *userprefix, *useremail, *usercontact, *userwebsite, *usercompany, *userlinkedin, *userabout, *userdisplayitem, *profileforwhichtab, *myname, *statusmgs, *strdistance, *isemailshow, *iscontactshow, *imgurl, *usertitle, *userlinkedintoken, *userlevel, *usernote; // imgurl is added for implementing lazi img for people by pradeep on 17 sep 2010
	
	// added by pradeep on 7 dec 2010 for autotagged feature implementation start
	NSString *taggedon;
	// added by pradeep on 7 dec 2010 for autotagged feature implementation end
	
	// camefromwhichoption is added for implementing lazi img for people by pradeep on 17 sep 2010
	NSString *camefromwhichoption;
	AsyncImageView* asyncImage;
	
	UIImage *fullImg;
	UILabel *lblUser, *lblPhone, *lblEmail, *lblCompny;
	BOOL tagsadded;
	UITextView *statusmsg, *tvLinkedIn, *heading;
	NSInteger actionsheettype, clickedonforactionsheet3, messageType;
	SystemSoundID beep;
	UIImageView *imgLockForEmail,*imgLockForPhone;
	//*****
	//for getting keywords of profile owner
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableArray * stories4digitalbillboard;
	NSString * currentElement;
	NSMutableString *keywordName, *digitalBillBoardImageURL;
	NSMutableDictionary * item;
	NSMutableArray *collectionAryKeywords;
	NSInteger camefrom;
	NSMutableArray *userInfo, *aryLinkedIn;
	NSMutableDictionary *userInfoDic;
	UIButton *btnCallTheNumber, *btnOpenLinkedIn;
	UIButton *btntip;
	
	// added by pradeep on 15 may 2011 for getting eventid for note, when user came from attendeelist of normal event's detail section
	NSString *eventid4attendeelistofnormalevent;
}

@property(nonatomic,retain) NSString *username, *userid, *userind, *usersubind, *userrole, *userintind, *userintsubind, *userintrole, *userprefix, *useremail, *usercontact, *userwebsite, *usercompany, *userlinkedin, *userabout, *userdisplayitem, *profileforwhichtab, *myname, *statusmgs, *strdistance, *imgurl, *usertitle, *userlinkedintoken, *userlevel, *usernote; // imgurl is added for implementing lazi img for people by pradeep on 17 sep 2010

// added by pradeep on 7 dec 2010 for autotagged feature implementation start
@property(nonatomic,retain) NSString *taggedon;
// added by pradeep on 7 dec 2010 for autotagged feature implementation end

// camefromwhichoption is added for implementing lazi img for people by pradeep on 17 sep 2010
@property(nonatomic,retain) NSString *camefromwhichoption;

@property(assign, nonatomic)NSInteger camefrom;
@property(nonatomic, retain) UIImage *fullImg;

// added by pradeep on 15 may 2011 for getting eventid for note, when user came from attendeelist of normal event's detail section
@property (nonatomic,retain) NSString *eventid4attendeelistofnormalevent;
//end 15 july 2011

- (void) sendLinkedInInvite;
- (void) callingMailClient;
- (void) callingTTForMessage;
- (BOOL) sendMessage:(NSString *)msgSentText;
- (void) btnOpenTheWebsite_Click;
- (void) createControls;
- (BOOL) sendNow4Bookmark: (NSString *) flag;
- (void) playSound;
- (void) getKeywordsForUser:(NSString *)inid;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (BOOL) sendNow4SmartTagging: (NSString *) flag;
- (BOOL) getDataFromFile1;
- (BOOL) getDataFromFile2;
@end
