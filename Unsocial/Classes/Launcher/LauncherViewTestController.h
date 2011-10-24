#import <Three20/Three20.h>
#import "Peoples.h"
#import "PeopleAutoTagged.h"
#import "Events.h"
#import "InBox.h"
#import "Settings.h"
#import "BIMeter.h"
#import "Referrals.h"
#import "Invites.h"
//#import "Tips.h"
#import "About.h"
#import "SponsoredEvents.h"
#import "SettingsTableView.h"
#import "ViewVideo.h"
//*************************
// commneted by pradeep on 24 july 2010 and added search in place of tags
//#import "Tags.h"
#import "SearchViewControllerImproved.h"
//*************************
#import "SettingsStep5.h"

@interface LauncherViewTestController : TTViewController <TTLauncherViewDelegate, UITextFieldDelegate, TTPostControllerDelegate, UIImagePickerControllerDelegate, NSXMLParserDelegate> {
	
  TTLauncherView* _launcherView;
	
	Peoples *peoples;
	PeopleAutoTagged *peopleautotagged;
	Events *events;
	InBox *inBox;
	Settings *settings;
	BIMeter *biMeter;
	Referrals *referrals;
	NSInteger alertFrom;
	Invites *invites;
	//Tips *tips;
	About *about;
	//Tags *tags;
	SearchViewControllerImproved *search;
	SponsoredEvents *sponsoredEvents;
	ViewVideo *viewVideo;
	SettingsStep5 *viewDigitalBillBoard;
	
	UITextField *txtStatus;
	SettingsTableView *settingsTableView;
	UISearchBar	*mySearchBar;
	
	UIScrollView*   _scrollView;
	
	NSMutableArray * springBoardTabsAry, *strStatusText;
	
	UIButton *imgBack, *imgBack2, *btnSetStatus;
	UIActivityIndicatorView *activityView;
	UILabel *loading, *lblUsername;
	UITextView *status;
	
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories, *stories4sponevent, *stories4useraddfeature;
	//NSArray * sortedArray;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item, *item4sponevent, *item4useraddfeature;
	NSMutableString *currentImageURL;
	
	NSString * currentElement, *userid, *strsetstatus;
	NSMutableString *eventid, *eventname, *eventdesc, *eventaddress, *eventindustry, *eventdate, *fromtime, *totime, *eventcontact, *eventwebsite, *isrecurring, *eventcurrentdistance, *eventtype, *eventlongitude, *eventlatitude, *eventdateto;//, *usersubind, *userrole, *userallownotification, *userinterestind, *userinterestsubind, *userinterestrole, *userprofilecomplete, *userdisplayitem, *usersecuritylevel, *usercurrentdistance, *userforwhichtab;
	
	UIImageView *imgBackgrnd;
	NSMutableString *sponeventexist, *useraddfeaturevalue, *totsponevents; // added by pradeep on 22 sep 2010 for checking total spon events and if it will be 1 then we have to open splash directly on click of "Live" on springboard;
	
	//************ splash start
	UIProgressView *threadProgressView;  
	UIImageView *frontImg;
	float wipeout;
	//************ splash end
	
	// *** 18 dec 2010 for userlocation on springboard
	NSMutableDictionary *item4usercurrentlocation4springboard;
	NSMutableString *usercurrentlocation4springboard;
	NSMutableArray *stories4usercurrentlocation4springboard;
	NSMutableArray *usercurrentlocationdeep;
	UILabel *userlocation;
	
	// added by pradeep on 7 june 2011
	UIImageView *loadingBack;
	UILabel *loading2;
	
}

@property (nonatomic, retain) Peoples *peoples;
@property (nonatomic, retain) PeopleAutoTagged *peopleautotagged;
@property (nonatomic, retain) Events *events;
@property (nonatomic, retain) InBox *inBox;
@property (nonatomic, retain) Settings *settings;
@property (nonatomic, retain) BIMeter *biMeter;
@property (nonatomic, retain) Referrals *referrals;
@property (nonatomic, retain) Invites *invites;
//@property (nonatomic, retain) Tips *tips;
@property (nonatomic, retain) About *about;
@property (nonatomic, retain) SponsoredEvents *sponsoredEvents;
@property (nonatomic, retain) ViewVideo *viewVideo;
@property (nonatomic, retain) SettingsStep5 *viewDigitalBillBoard;
@property (nonatomic, retain) SettingsTableView *settingsTableView;
@property (nonatomic, retain) NSString *userid;

//********* splash
@property (nonatomic, retain) UIProgressView *threadProgressView;  
@property (nonatomic, retain) UIImageView *frontImg; 
//********* splash

// commented on 17 march 2011 by pradeep for removing warning incomplete implimentation of LVTC, since this method is defined in delegate
//- (NSString *)getNumberOfPreEvents;
- (void)openLinedInWebView:(NSString *)strStatus;
- (void)startProcess: (NSString *) stsmsg;
- (void) getStatusFromFile;
- (BOOL) getNameFromFile;
- (void)getTabs;
- (void) updateStatusOnSave:(NSString *)uid:(NSString *)stsmsg;
- (void)getImageLocally;
+ (BOOL) isFileExist: (NSString *) filename;
- (void) getEventData:(NSString *) eventflg: (NSString *) eventsubflg;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (BOOL) sendNowStatus: (NSString *) flag: (NSString *) stsmsg;
- (void)reLoadLauncherView;
- (BOOL) getDataFromFile: (NSString *) filename;
- (void) removeLocalFiles: (NSString *) filename;
- (void) createSplashExperience;
- (void) callspringboard;
- (BOOL) sendForLogoff: (NSString *) flag:(NSString *)stsmsg;

//added by pradeep on 5th jan 2011
// prompting alert during logout
- (void)alertSimpleAction:(NSString *)alertMsg:(NSString *)instrc;
- (void) logout_Click;

// added by pradeep on 14 may 2011 for improving springboard response listed in RTH issue # 16
- (void) updateBadges4InboxNEventsAsync;
// end 14 may 2011

// added by pradeep on 27 may 2011 for refreshing locationlabel when app comes active
- (void) reloadData4LocationLabelBySeperateThread;
// end 27 may 2011

- (void) createSpringBoard;

@end
