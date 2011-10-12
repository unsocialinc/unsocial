//
//  EventIntendedUsers.h
//  Unsocial
//
//  Created by vaibhavsaran on 01/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyncimageview.h"

@interface EventIntendedUsers : UIViewController <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>{

	UIImageView *imgHeadview;
	UITableView *itemTableView;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableDictionary * item;
	NSString *currentElement;
	UIImageView *userImage;
	UILabel *lblStatus, *loading;
		
	NSMutableString *userid, *userdevicetocken, *userprefix, *username, *useremail, *userlastuse, *usercontact, *userwebsite, *usercompany, *userlinkedin, *userabout, *userind, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab, *userstatus, *userlinkedinemailid, *usertitle, *userlevel;
	
	NSMutableString *currentImageURL;
	UILabel *lblUserName, *lblCompanyName, *lblIndustryName, *lblFunctionName;
	
	NSString *eventid;	
	
	// added by Pradeep for Lazy img feature on 17 sep 2010
	NSMutableArray *imageURLs4Lazy;
	AsyncImageView* asyncImage;
}
@property(nonatomic,retain) NSString *eventid;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (void) getUserList;
- (void)createControls;
@end
