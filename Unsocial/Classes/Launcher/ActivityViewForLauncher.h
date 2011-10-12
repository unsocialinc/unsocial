//
//  ActivityViewForLauncher.h
//  Unsocial
//
//  Created by pradeepKsrivastava on 16/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActivityViewForLauncher : UIViewController <NSXMLParserDelegate>{

	UIImageView *imgBack;
	UIActivityIndicatorView *activityView;
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableArray * stories4digitalbillboard;
	NSString *strFrom,  *strFromName, *strMsgDescription, *strDateTime, *strMsgId, *strReadMsg, *strPurpose;//, *userid;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	UILabel *loading;
	
	NSString * currentElement;
	NSMutableString *userid, *userdevicetocken, *userprefix, *username, *useremail, *userlastuse, *usercontact, *userwebsite, *usercompany, *userlinkedin, *userabout, *userind, *userindid, *usersubind, *userrole, *userroleid, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab, *userstatus, *userhasmetatags, *userhastags, *userlinkedinmailid, *usertitle; // userhastags is tags of an user which helps for autotagging where as userhasmetatags is keywords which is defined to an user set under my profile section
	
	NSMutableString *currentImageURL, *digitalBillBoardImageURL;
}
- (void) getProfile:(NSString *) flg4whichtab;
- (void) btnProfile_Click;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (void) updateDataFile4GeneralInfo:(NSString *)uid;
- (void) updateDataFile4CompanyInfo:(NSString *)uid;
- (void) updateDataFile4SecuritySettings:(NSString *)uid;
- (void) updateDataFile4Img:(NSString *)uid;
	//- (void) getDigitalBillboardImage;
- (void) updateDataFile4DigitalBillboardImg:(NSString *)uid;
- (void) updateDataFile4Status;
- (void) updateDataFile4MetaTags:(NSString *)uid:(NSString *)str;
- (void) updateDataFile4Tags:(NSString *)uid:(NSString *)str;

@property(nonatomic, retain)NSString *strFrom, *strFromName, *strMsgDescription, *strDateTime, *strReadMsg, *strMsgId, *strPurpose;

@end
