//
//  Events.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Events.h"
#import "asyncimageview.h"

@interface Events : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, UIScrollViewDelegate, UIActionSheetDelegate> {
	UIImageView *imgHeadview, *usrImage, *premiumeventico;
	UITableView *itemTableView;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *userImage;
	UISegmentedControl *segmentedControl;
	UIButton *btnAll, *btnInterest, *addEvent;
	Events *events;
	NSString *strAll, *strInrst, *strAll2, *strInrst2;
	
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableArray *stories4cal;
	//NSArray * sortedArray;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	NSString * currentElement;
	NSMutableString *eventid, *eventname, *eventdesc, *eventaddress, *eventindustry, *eventdate, *fromtime, *totime, *eventcontact, *eventwebsite, *isrecurring, *eventcurrentdistance, *eventtype, *eventlongitude, *eventlatitude, *eventdateto;//, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab;
	NSInteger comingfrom;
	NSMutableString *currentImageURL;
	UILabel *lblEvent, *loading;
	UILabel *recnotfound;
	UILabel *lblEventDt, *lblEventDtFrom, *lblEventDtTo, *lblEventDistance, *lblEventInd;
	
	NSMutableArray *imageURLs4Lazy;
	AsyncImageView* asyncImage;
	BOOL editing;
	UIToolbar *toolbar;

#pragma mark CalendarVaribles
	NSMutableDictionary * daysitems;
	NSMutableString *dates, *month, *year, *day, *datefrmtstr;
	NSMutableArray *stories2;
	NSMutableArray *dateDisp, *dayDisp, *monthDisp, *yearDisp, *imgArray, *dateFrmat;
	
	UILabel *lblMonthYear;
	
	UISegmentedControl *segmentedControlday, *segmentedControlcal;
	UIImageView *caltop;
	
	UIPageControl *pageControl;
	UIScrollView *scrollView;
	UIButton *btnFilter;
	int kNumberOfPages;
	
	//#pragma mark ToggleEvent
	//NSMutableArray *eventtogglelistary;
}
- (void) get120days;
-(UIImage *)addText:(UIImage *)img text:(NSString *)text1  text2:(NSString *)text2 text3:(NSString *)text3 text4:(NSString *)text4 text5:(NSString *)text5;
@property (nonatomic, retain) UIToolbar	*toolbar;
@property(nonatomic, assign)NSInteger comingfrom;
- (NSInteger) sendReqForDeleteSavedEvent:(NSInteger) storyIndex;
- (void)createControls;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (void) getEventData:(NSString *) eventflg: (NSString *) eventsubflg;
- (BOOL) getDataFromFile;
- (BOOL) getDataFromFile4EventDistance;
- (void)startProcess4ChangedSegment;
- (void) get120days4segmentchange;
- (void) pickOneDate;
//- (void) releaseAll;
@end
