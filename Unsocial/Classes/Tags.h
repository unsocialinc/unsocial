//
//  Tags.h
//  Unsocial
//
//  Created by vaibhavsaran on 28/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Tags : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate> {
	
	UIImageView *imgHeadview, *imgSelectedSeg1, *imgSelectedSeg2;
	UITableView *itemTableView;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *userImage;
	UISegmentedControl *segmentedControl;
	UIButton *btnAll, *btnInterest;
	Tags *tags;
	NSString *strAll, *strInrst, *strAll2, *strInrst2;
	
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	//NSArray * sortedArray;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	//NSMutableDictionary * item4whichtab;
	
	//NSMutableString *userforwhichtab
	
	NSString * currentElement;
	NSMutableString *userid, *userdevicetocken, *userprefix, *username, *useremail, *userlastuse, *usercontact, *userwebsite, *usercompany, *userlinkedin, *userabout, *userind, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab, *userlevel;
	
	NSMutableString *currentImageURL;
	UILabel *lblEvent;
	UILabel *loading;
	UIImageView *imgForOverlap;
	
	UILabel *lblUserName;	
	UILabel *recnotfound;
	
	NSString *puserid;

}

@property (nonatomic, retain) NSString	*puserid;
- (void)segmenteHoverImage:(BOOL)seg1: (BOOL)seg2;
- (void)createControls;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (void) getPeopleData:(NSString *) flg4whichtab;
//- (void) getEventData:(NSString *) eventflg: (NSString *) eventsubflg;
- (BOOL) getDataFromFile;
@end
