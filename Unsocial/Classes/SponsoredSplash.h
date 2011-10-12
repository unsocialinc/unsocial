//
//  SponsoredSplash.h
//  Unsocial
//
//  Created by santosh khare on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyncimageview.h"
#import <Three20/Three20.h>

@interface SponsoredSplash : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate> { //, TTScrollViewDelegate, TTScrollViewDataSource> {
	
	UIImageView *imgHeadview;
	UITableView *itemTableView;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *userImage, *asyncImage2;
	UISegmentedControl *segmentedControl;
	UIButton *btnAll, *btnInterest, *addEvent;
		//TScrollView *_scrollView;
	NSString *strAll, *strInrst, *strAll2, *strInrst2;
	
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	//NSArray * sortedArray;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	NSString * currentElement;
	NSMutableString *eventid, *eventname, *eventdesc, *eventaddress, *eventindustry, *eventdate, *fromtime, *totime, *eventcontact, *eventwebsite, *isrecurring, *eventcurrentdistance, *eventtype, *eventlongitude, *eventlatitude;//, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab;
	UILabel *lblEventDt, *lblEventDtFrom, *lblEventDtTo, *lblEventDistance;
	NSMutableString *currentImageURL;
	UILabel *lblEvent;
	UILabel *recnotfound, *loading;
	
	NSMutableArray *imageURLs4Lazy;
	AsyncImageView* asyncImage;
	
	// added by pradeep on 16 dec 2010 for event improvement i.e. calendar
	NSString *calendarselectedindex;
}
- (void)createScrollView;
- (void)createControls;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (void) getEventData:(NSString *) eventflg: (NSString *) eventsubflg;
//- (BOOL) getDataFromFile;
//- (BOOL) getDataFromFile4EventDistance;

-(void)entendToAttend;
- (BOOL) sendNow4Event: (NSString *) flag;

// added by pradeep on 16 dec 2010 for event improvement i.e. calendar
@property(nonatomic, retain) NSString *calendarselectedindex;

@end
