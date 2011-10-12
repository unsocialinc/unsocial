//
//  ActivityViewForPeople.h
//  Unsocial
//
//  Created by vaibhavsaran on 16/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActivityViewForPeople : UIViewController <NSXMLParserDelegate>{

	UIImageView *imgBack;
	UIActivityIndicatorView *activityView;
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSString *strFrom,  *strFromName, *strMsgDescription, *strDateTime, *strMsgId, *strReadMsg, *strPurpose;//, *userid;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	NSString * currentElement;
	NSMutableString *userid, *userdevicetocken, *userprefix, *username, *useremail, *userlastuse, *usercontact, *userwebsite, *usercompany, *userlinkedin, *userabout, *userind, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab, *userstatus, *userlinkedinemailid, *usertitle, *userlevel;
	
	NSMutableString *currentImageURL;
}
- (void) getProfile:(NSString *) flg4whichtab;
- (void)btnProfile_Click;
- (void)parseXMLFileAtURL:(NSString *)URL;
@property(nonatomic, retain)NSString *strFrom, *strFromName, *strMsgDescription, *strDateTime, *strReadMsg, *strMsgId, *strPurpose;

@end
