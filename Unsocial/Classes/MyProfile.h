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

@interface MyProfile : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, TTPostControllerDelegate, NSXMLParserDelegate>{

	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *userImage;
	
	NSString *username, *userid, *userind, *userrole, *userprefix, *useremail, *usercontact, *userwebsite, *usercompany, *statusmgs, *usermetatags, *userlinkedin, *displayedSecurityItems, *isemailshow, *iscontactshow, *userlinkedinmail, *usertitle;
	UIImage *fullImg;
	UILabel *lblUser, *lblPhone, *lblEmail;
	BOOL tagsadded;
	UITextView *statusmsg, *tvLinkedIn, *heading;
	NSInteger actionsheettype, clickedonforactionsheet3, messageType;
	SystemSoundID beep;
	UIImageView *imgLockForEmail,*imgLockForPhone;
	//*****
	//for getting keywords of profile owner
	NSXMLParser * rssParser;
	NSMutableArray * stories, *aryContact, *aryLinkedIn;
	NSMutableArray * stories4digitalbillboard;
	NSString * currentElement;
	NSMutableString *keywordName, *digitalBillBoardImageURL;
	NSMutableDictionary * item;
	NSMutableArray *collectionAryKeywords;	
	NSMutableArray *userInfo;
	NSMutableDictionary *userInfoDic;
	UIButton *btnOpenLinkedIn;
}

@property(nonatomic,retain) NSString *username, *userid, *userind, *userrole, *userprefix, *useremail, *usercontact, *userwebsite, *usercompany, *statusmgs, *userlinkedin, *displayedSecurityItems, *userlinkedinmail, *usertitle;
@property(nonatomic, retain) UIImage *fullImg;

- (void)createControls;
- (void)getDataFromFile;
- (void)getData2FromFile;
- (void)getImageFromFile;
- (void)getStatusFromFile;
- (void) getPrivacyFromFile;
- (void)getMetaTags;
- (void) getKeywordsForUser:(NSString *)inid;
- (void)parseXMLFileAtURL:(NSString *)URL;
@end
