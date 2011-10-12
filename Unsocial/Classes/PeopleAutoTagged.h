//
//  PeopleAutoTagged.h
//  Unsocial
//
//  Created by vaibhavsaran on 18/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyncimageview.h"
#import "PeoplesUserProfile.h"

@interface PeopleAutoTagged : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate> {

	PeoplesUserProfile *peoplesUserProfile;
	UIImageView *imgBack, *userImage;
	UITableView *itemTableView;
	UIActivityIndicatorView *activityView;
	AsyncImageView* asyncImage;
	UILabel *lblUserName, *lblCompanyName, *lblIndustryName, *lblFunctionName, *lblStatus, *heading;
	UILabel *recnotfound;
	UILabel *loading;
	NSInteger comingfrom;
	UIButton *btnAddTags, *btnDeletePeople4Auto;
	BOOL editing;

	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableDictionary * item;
	NSString * currentElement;
	NSMutableString *userid, *userdevicetocken, *userprefix, *username, *useremail, *userlastuse, *usercontact, *userwebsite, *usercompany, *userlinkedin, *userabout, *userind, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab, *userstatus, *userlinkedinemailid, *usertitle, *userlevel;
	
	NSMutableString *currentImageURL;
}
- (BOOL) getDataFromFile4Tags;
- (NSInteger) sendReqForDeleteAutoTaggedPeople:(NSInteger) storyIndex;
- (void) getPeopleData:(NSString *) flg4whichtab;
- (void)parseXMLFileAtURL:(NSString *)URL;

// added by pradeep on 2 june 2011
- (NSInteger) updateNewlyTaggedUserAsViewed4Badge: (NSString *) flag: (NSString *) taggedUserID;
// end 2 june 2011

@property (nonatomic, assign)NSInteger comingfrom;
@end