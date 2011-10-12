//
//  EventDetails.h
//  Unsocial
//
//  Created by vaibhavsaran on 28/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyncimageview.h"
#import <EventKit/EventKit.h>
@interface EventDetails : UIViewController <UIActionSheetDelegate>
{

	UIActivityIndicatorView *activityView;
	UIImageView *imgBack;
	UIImage  *eventImage;
	UILabel *eventWhen, *eventSuggst, *eventWhere;
	NSString *strEventTopic, *strEventWhen, *strEventWhere, *strEventSuggst, *strEventDecscrip;
	UITextView *eventTopic, *eventDecscrip, *tvEventWhere, *tvEventWebsite;
	
	NSString *eventid, *eventname, *eventdesc, *eventaddress, *eventindustry, *eventdate, *fromtime, *totime, *eventcontact, *eventwebsite, *isrecurring, *eventcurrentdistance, *fromwhichsegment, *eventtype;
	NSInteger comingfrom, liveNow, clickedOn;
	UILabel *lblOn, *lblFrom, *lblTo, *lblPlace, *lblReletedto, *lblPhone, *lblWebsite, *lblDescription, *lblToForDt;
	UIButton *btntvEventWebsite;
	AsyncImageView* asyncImage;
	
	// added by pradeep on 16 dec 2010 for event improvement i.e. calendar
	NSString *calendarselectedindex;
	BOOL flagforalreadyintend;
}

- (void) saveToCalendar;
- (void) entendToAttend;
- (void) btnOptions_Click;
- (void) reportAbuse;
- (void) entendedUsers;
- (void) applyBookmark;
- (void) createControls;
- (BOOL) sendNow4Event: (NSString *) flag;
- (BOOL) sendNow4Bookmark: (NSString *) flag;
@property (assign, nonatomic) NSInteger comingfrom, liveNow;
@property(nonatomic, retain) UIImage *eventImage;
@property(nonatomic, retain)NSString *strEventTopic, *strEventWhen, *strEventWhere, *strEventSuggst, *strEventDecscrip;
@property (nonatomic, retain) NSString *eventid, *eventname, *eventdesc, *eventaddress, *eventindustry, *eventdate, *fromtime, *totime, *eventcontact, *eventwebsite, *isrecurring, *eventcurrentdistance, *fromwhichsegment, *eventtype;

// added by pradeep on 16 dec 2010 for event improvement i.e. calendar
@property(nonatomic, retain) NSString *calendarselectedindex;

@end
