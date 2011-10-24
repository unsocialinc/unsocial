//
//  People2.h
//  Unsocial
//
//  Created by vaibhavsaran on 18/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeoplesUserProfile.h"
#import "asyncimageview.h"

@interface Peoples : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, UIScrollViewDelegate> {
	
	PeoplesUserProfile *peoplesUserProfile;
	UITableView *itemTableView;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *userImage;
	UISegmentedControl *segmentedControl;
	UIButton *btnSetMiles;
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	UILabel *lblStatus;
	NSInteger comingfrom;
	
	
		// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
		//NSMutableDictionary * item4whichtab;
	
		//NSMutableString *userforwhichtab
	
	NSString * currentElement;
	NSMutableString *userid, *userdevicetocken, *userprefix, *username, *useremail, *userlastuse, *usercontact, *userwebsite, *usercompany, *userlinkedin, *userabout, *userind, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab, *userstatus, *userlinkedinemailid, *usertitle, *userlevel, *usernote;
	
	NSMutableString *currentImageURL;
	
	NSString *pusername, *puserid, *puserind, *pusersubind, *puserrole, *puserindid, *pusersubindid, *puserroleid, *puserprefix, *puseremail; // for personfile
	
	UIImageView *TSImageView, *imgSelectedSeg1, *imgSelectedSeg2;
	
	UILabel *lblUserName, *lblCompanyName, *lblIndustryName, *lblFunctionName;
	UILabel *recnotfound;
	
	UILabel *loading;
	UIImageView *imgForOverlap;
		//UIButton *btnReload;
		//UIImageView *imgRefresh;
	UIButton *btnAddTags, *btnDeletePeople, *btnDeletePeople4Auto;
	BOOL editing;
	
		// added by Pradeep for Lazy img feature on 26 Aug 2010
	AsyncImageView* asyncImage;
}

@property (nonatomic, retain) NSString	*pusername, *puserid, *puserind, *pusersubind, *puserrole, *puserindid, *pusersubindid, *puserroleid, *puserprefix, *puseremail;
@property (nonatomic, retain) UIImageView *TSImageView;
@property (nonatomic, retain)	UIActivityIndicatorView *activityView;
@property (nonatomic, assign)NSInteger comingfrom;

- (NSInteger) sendReqForDeleteSavedPeople:(NSInteger) storyIndex;
- (NSInteger) sendReqForDeleteAutoTaggedPeople:(NSInteger) storyIndex;
- (void)createControls;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (void) getPeopleData:(NSString *) flg4whichtab;
- (BOOL) getDataFromFile;
- (BOOL) getDataFromFile4CheckingIsProfileSet;
- (BOOL) getDataFromFile4PeopleDistance;
- (BOOL) getDataFromFile4Tags;
//-(NSString *)dateDiff:(NSString *)origDate;
@end
