//
//  SearchViewController.h
//  Unsocial
//
//  Created by santosh khare on 5/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyncimageview.h"

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate, NSXMLParserDelegate>
{
	BOOL editing, isSaved;
	UIImageView *imgBack, *userImage;
	
	UIImageView *imgTBBack;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSString * currentElement;
	//NSMutableString *tagsName;
	NSMutableDictionary * item;
	//UIButton *btnSkip;
	UITableView *itemTableView;
	UILabel *lbltagsName, *lblNotags;
	UIActivityIndicatorView *activityView;
	UIButton *btnSettags;
	NSMutableArray *collectionAryKeywords;
	UITextField *txtsearch;	
	UISearchBar	*mySearchBar;
	
	NSArray *options;				
	
	NSMutableString *userid, *userdevicetocken, *userprefix, *username, *useremail, *userlastuse, *usercontact, *userwebsite, *usercompany, *userlinkedin, *userabout, *userind, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab, *userstatus, *userlevel, *usertitle;
	
	NSMutableString *currentImageURL;
	UILabel *lblEvent;
	UILabel *loading;
	UIImageView *imgForOverlap;
	
	UILabel *lblUserName;	
	UILabel *recnotfound;
	UILabel *lblStatus, *lblCompanyName, *lblIndustryName, *lblFunctionName;
	
	NSString *puserid;
	//NSMutableString *userid
	
	// added by Pradeep for Lazy img feature on 17 sep 2010
	NSMutableArray *imageURLs4Lazy;
	AsyncImageView* asyncImage;
	
	// added by pradeep on 12 nov 2010 for search improvement feature
	NSString *searchkey;
}
@property (nonatomic, retain) NSString	*puserid, *searchkey;
- (void)btnSearch_Click;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (void) getPeopleData:(NSString *) flg4whichtab;
//- (void) getEventData:(NSString *) eventflg: (NSString *) eventsubflg;
- (BOOL) getDataFromFile;

- (BOOL) addSearchTagAsUsersAutoTag: (NSString *) flag;

@end
