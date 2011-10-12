//
//  UnsocialAppDelegate.h
//  Unsocial
//
//  Created by vaibhavsaran on 03/05/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Peoples.h"
#import "Events.h"
#import "InBox.h"
#import "Settings.h"
#import "BIMeter.h"
#import "Referrals.h"
#import "Invites.h"
#import "PeopleAutoTagged.h"
#import "ShowTips.h" 
#import "Info.h" 
#import "About.h"
#import "SettingsTableView.h"
#import "EventDetails.h"
#import "SignIn.h"
#import "SignUp.h"
#import "MilesOptions.h"
#import "AddExtraFeature.h"
#import "WelcomeViewController.h"
#import "ForgetPwd.h"
#import "AppNotAvailable.h"
#import "SponsoredSplash.h"
#import "PeopleLiveNow.h"
#import "InvitePeople.h"
// added by pradeep on 9 june 2011 for a new springboard item "MY EVENTS"
#import "MyEvents.h"
// end 9 june 2011
// added by pradeep on 15 july 2011 for a new springboard item "MY EVENTS"
#import "MyNotes.h"
// end 9 june 2011

@interface UnsocialAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
	
	UIWindow *window;
	//UITabBarController *tabBarController;
	Peoples *peoples;
	PeopleAutoTagged *peopleautotagged;
	Events *events;
	InBox *inBox;
	Settings *settings;
	BIMeter *biMeter;
	Referrals *referrals;
	Invites *invites;
	//Tips *tips;
	MilesOptions *milesOptions;
	About *about;
	SettingsTableView *settingsTableView;
	//AddExtraFeature *addExtraFeatures;
	
	NSString *username, *userid;
	CLLocationManager *locationManager;
	CLLocation *bestEffortAtLocation;
	
	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UIImageView *imgBack;
	EventDetails *eventDetails;
}
//+ (NSInteger) sendNow: (NSString *) flag :(NSString *)uid;
+(BOOL)checkInternet:(NSString *)weburl;

+ (UIImageView *)createImageViewControl:(CGRect)frame imageName:(NSString *)imageName;

+ (UITextField *)createTextFieldControl:(CGRect)frame borderStyle:(UITextBorderStyle)borderStyle setTextColor:(UIColor *)setTextColor setFontSize:(NSInteger)setFontSize setPlaceholder:(NSString *)setPlaceholder backgroundColor:(UIColor *)backgroundColor keyboard:(UIKeyboardType)keyboard returnKey:(UIReturnKeyType)returnKey; 

+ (UILabel *)createLabelControl: (NSString *)title frame:(CGRect)frame txtAlignment:(UITextAlignment )txtAlignment numberoflines:(NSInteger)numberoflines linebreakmode:(UILineBreakMode)linebreakmode fontwithname:(NSString *)fontwithname fontsize:(NSInteger)fontsize txtcolor:(UIColor *)txtcolor backgroundcolor:(UIColor *)backgroundcolor;

+ (UIButton *)createButtonControl:	(NSString *)title target:(id)target selector:(SEL)selector frame:(CGRect)frame imageStateNormal:(NSString *)imageStateNormal imageStateHighlighted:(NSString *)imageStateHighlighted TextColorNormal:(UIColor *)TextColorNormal TextColorHighlighted:(UIColor *)TextColorHighlighted showsTouch:(BOOL) showsTouch buttonBackgroundColor:(UIColor *)buttonBackgroundColor;

+ (UIActivityIndicatorView *)createActivityView: (CGRect)frame activityViewStyle:(UIActivityIndicatorViewStyle)activityViewStyle;

+ (UITextView *)createTextViewControl: (NSString *)description frame:(CGRect)frame txtcolor:(UIColor *)txtcolor  backgroundcolor:(UIColor *)backgroundcolor  fontwithname:(NSString *)fontwithname fontsize:(NSInteger)fontsize returnKeyType:(UIReturnKeyType)returnKeyType keyboardType:(UIKeyboardType)keyboardType scrollEnabled:(BOOL)scrollEnabled editable:(BOOL)editable;

+ (NSString *) getLinkedInPrefixFromFile;

// added by pradeep on 3 august 2011 for creating new method that will create imageviewcontroller without auto release
+ (UIImageView *)createImageViewControlWithoutAutoRelease:(CGRect)frame imageName:(NSString *)imageName;
// end 3 august 2011 without auto release

// added by pradeep on 3 august 2011 for creating new method that will create createLabelControl without auto release
+ (UILabel *)createLabelControlWithoutAutoRelease: (NSString *)title frame:(CGRect)frame txtAlignment:(UITextAlignment )txtAlignment numberoflines:(NSInteger)numberoflines linebreakmode:(UILineBreakMode)linebreakmode fontwithname:(NSString *)fontwithname fontsize:(NSInteger)fontsize txtcolor:(UIColor *)txtcolor backgroundcolor:(UIColor *)backgroundcolor;
// end 3 august 2011 without auto release

- (void)addFeaturesToWindow;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) Peoples *peoples;
@property (nonatomic, retain) PeopleAutoTagged *peopleautotagged;
@property (nonatomic, retain) Events *events;
@property (nonatomic, retain) InBox *inBox;
@property (nonatomic, retain) Settings *settings;
@property (nonatomic, retain) BIMeter *biMeter;
@property (nonatomic, retain) Referrals *referrals;
@property (nonatomic, retain) Invites *invites;
@property (nonatomic, retain) MilesOptions *milesOptions;
@property (nonatomic, retain) About *about;
@property (nonatomic, retain) SettingsTableView *settingsTableView;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;
//@property (nonatomic, retain) AddExtraFeature *addExtraFeatures;

@property (nonatomic, retain) NSString	*username, *userid;
@property (nonatomic, retain) CLLocationManager *locationManager;
+ (NSString *)getLocalTime;
+ (NSString *) getLinkedInMailFromFile;
+(void)playClick;
- (BOOL) getDataFromFile;
- (void) CreateFile;
- (void)startUpdates;
-(void) recalliflatlongnotset;
+ (void) sendNow4UnreadMessages;
+ (NSInteger)getNumberOfPreEvents;
+ (void) getStatus2;
- (BOOL) getLocationLock; 

// added by vaibhav on 10 feb 2011
+ (BOOL)validateEmail:(NSString *)emailid;
+ (BOOL) validateUrl:(NSString *)url;
// end 10 feb 2011

//+ (void) release_used_memory;

// added by pradeep on 17 may 2011 for implementing app shouldn't kill on home btn press

- (void) startUpdatesDuringApplicationDidBecomeActive;

// end 17 may 2011

// added by pradeep on 31 may 2011
+ (NSInteger) getNumberOfNewlyTaggedUsers;
// end 31 may 2011

@end