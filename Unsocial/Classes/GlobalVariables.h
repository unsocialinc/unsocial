/*
 *  GlobalVariables.h
 *  Unsocial
 *
 *  Created by vaibhavsaran on 15/04/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#define kAppFontName @"Helvetica-Bold"
#define kAppMainHeadingFontSize 20
#define kAppTBFontSize 17
#define kTableCellHeading 14
#define kEventTableContent 13
#define kLoadingFont 17
#define kTextFieldFont 14
#define kPeopleTableContent 11
#define kPeopleStatus 12
#define kButtonFont 11.5
#define kTableItemNotFound 18

// added by pradeep on 1 june 2011 for shake feature
#define kAccelerationThreshold        2.2
#define kUpdateInterval               (1.0f/10.0f)
// end 1 june 2011

NSMutableArray *capturedImageNewUser;
NSString *loginmailid;
int whichsegmentselectedlasttime4msg, gblTotalnumberofsponevents;
int flagforcompinfo, flagforlinkedinmailset, flagforlinkedincaompanynavigation;
NSMutableArray *splashImage;
NSMutableArray *arrayForUserID, *allInfo, *allInfoNewUser;
NSString *globalUrlString;
NSMutableArray *userEntries, *userEntries2, *industryArray1, *industryArray2, *industryArray3;
NSMutableArray *gbllongitudeary, *gbllatitudeary;
NSMutableArray *industryNames, *industryIDs, *roleNames, *roleIDs, *subIndustryNames, *subIndustryIDs;
NSString *gbllongitude, *gbllatitude, *gbluserid;
int flg4navigation, unreadmsg;
BOOL addIndustry, saveLevel1, editedLevel1, gblRecordExists;
NSString *idOfSelectedInd,*idOfSelectedSubInd,*idOfSelectedFunction, *useridForTable;
NSString *selectedLevels;
NSString *IdOfIndustry4Step1, *IdOfSubIndustry4Step1, *IdOfRole4Step1;

NSMutableArray *searchtxt, *aryCompanyInfo, *aryUsrStatus;
NSMutableArray *interestedIndustryIds1, *interestedIndustryIds2,  *interestedIndustryIds3;
NSMutableArray  *interestedIndustry1, *interestedIndustry2,  *interestedIndustry3;
NSMutableArray *arrayAddEvent, *arrayAddDateEvent, *arrayAddFromTime, *arrayAddToTime, *arrayAddEventID;
UINavigationController *inBoxviewcontroller;
//UITabBarController *tabBarController;
NSMutableArray *myName, *lastVisitedFeature, *arySelectedPrefix, *aryEventDetails, *aryLoggedinUserName, *aryIsLiveNowEventsExist, *devTocken;
UIButton *doneButton;
NSMutableArray *stories4peoplemyinterest, *stories4peoplearoundme, *stories4peoplebookmark;
NSMutableArray *startLogicSponSplashCameFrom;

int cntTotTabs, yAxisForSettingControls, WhereIam;
NSInteger checklocation;

NSMutableArray *aryKeyword, *aryTags, *aryVideo, *aryVideoTitle, *capturedScreen, *liveNowEventID;

// for implementing lazy img for people by pradeep on 16 sep 2010
NSMutableArray *imageURLs4Lazyall, *imageURLs4Lazyauto, *imageURLs4Lazysaved, *photoFullImgs;

// added by pradeep on 13 nov 2010 for search improvement
NSMutableArray *aryRecentSearchTags;

// added by pradeep on 24 dec 2010 for toggleevent feature
#pragma mark ToggleEvent
NSMutableArray *eventtoggledateary, *eventtogglelistary;


// added by pradeep on 31 may 2011
int gblTotalNewlyTaggedUsers4Badge;
// end 31 may 2011

// added by pradeep on 25 july 2011 for fixing issue syncronization failed message display multiple times
BOOL issyncfailedmsgdisplayed;
BOOL issyncfailedmsgdisplayed4premiumeventlauncher;
// end 25 july 2011 issue syncronization failed message display multiple times

// added by pradeep on 1 aug 2011 for fixing issue for launcherview, in which reloadData4LocationLabel calls 3 times
BOOL isreloadData4LocationLabelCall;
// end 1 aug 2011 


