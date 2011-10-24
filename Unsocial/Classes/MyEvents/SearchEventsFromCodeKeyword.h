//
//  SearchEventsFromCodeKeyword.h
//  Unsocial
//
//  Created by santosh khare on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyncimageview.h"

@interface SearchEventsFromCodeKeyword : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate> {
	UIImageView *imgHeadview;
	UITableView *itemTableView;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *userImage;
	UISegmentedControl *segmentedControl;
	UIButton *btnAll, *btnInterest, *addEvent;
	
	NSString *strAll, *strInrst, *strAll2, *strInrst2;
	
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	//NSArray * sortedArray;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	NSString * currentElement;
	NSMutableString *eventid, *eventname, *eventdesc, *eventaddress, *eventindustry, *eventdate, *fromtime, *totime, *eventcontact, *eventwebsite, *isrecurring, *eventcurrentdistance, *eventtype, *eventlongitude, *eventlatitude, *eventdateto;//, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab;
	UILabel *lblEventDt, *lblEventDtFrom, *lblEventDtTo, *lblEventDistance;
	NSMutableString *currentImageURL;
	UILabel *lblEvent;
	UILabel *recnotfound;
	
	NSMutableArray *imageURLs4Lazy;
	AsyncImageView* asyncImage;
	
	NSString *searchkey;
	UILabel *loading;
}

@property (nonatomic, retain) NSString *searchkey;

- (void) createControls;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (void) getEventData:(NSString *) eventflg: (NSString *) eventsubflg;
- (BOOL) getDataFromFile;
//- (BOOL) getDataFromFile4EventDistance;

@end
