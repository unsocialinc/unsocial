//
//  SearchViewControllerImproved.h
//  Unsocial
//
//  Created by santosh khare on 5/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyncimageview.h"

@interface SearchViewControllerImproved : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate, NSXMLParserDelegate>
{
	BOOL editing, isSaved;
	UIImageView *imgBack, *userImage;
	
	UIImageView *imgTBBack;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSString * currentElement;
	
	NSMutableDictionary * item;
	
	UITableView *itemTableView;
	//UILabel *lbltagsName, *lblNotags;
	UIActivityIndicatorView *activityView;
	UIButton *btnSettags;
	NSMutableArray *collectionAryKeywords;
	UITextField *txtsearch;	
	UISearchBar	*mySearchBar;
	
	NSArray *options;				
	
	/*NSMutableString *userid, *userdevicetocken, *userprefix, *username, *useremail, *userlastuse, *usercontact, *userwebsite, *usercompany, *userlinkedin, *userabout, *userind, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab, *userstatus;
	
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
	AsyncImageView* asyncImage;*/
	
	// added for new search concept by pradeep
	UISegmentedControl *segmentedControl;
	NSMutableString *occurance, *keywords;
	
	NSString *puserid;
	UILabel *loading;
	UIImageView *imgForOverlap;
	UILabel *recnotfound;
}
@property (nonatomic, retain) NSString	*puserid;
- (void)btnSearch_Click;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (void) getPeopleData:(NSString *) flg4whichtab;

- (BOOL) getDataFromFile;

// added by pradeep on 13 nov 2010 for search improvement
- (BOOL) getRecentSearchTagsDataFromFile;
- (void) updateRecentSearchDataFileOnSave:(NSString *)searchitem:(NSString *)str;
- (void) removeLocalFiles: (NSString *) filename;

@end
