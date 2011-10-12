//
//  Info.h
//  Unsocial
//
//  Created by vaibhavsaran on 11/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleAutoTagged.h"
#import "Events.h"
#import "InBox.h"
#import "Settings.h"
#import "SettingsStep5.h"
#import "Referrals.h"
#import "Invites.h"
#import <Three20/Three20.h>
#import "About.h"
#import "SettingsTableView.h"
#import "EventDetails.h"
#import "SignIn.h"
#import "SignUp.h"
#import "MilesOptions.h"
#import "AddExtraFeature.h"
#import "SettingsAddKeywords.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface Info : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate> {
	
	UITableView *itemTableView;
	NSString *tip1, *tip2, *tip3, *tip4, *tip5, *tip6, *tip7, *tip8, *tip9;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack;
	UILabel *loading, *lblTips;
	NSMutableArray *arrayAllTips;
	UITextView *tips;
	UIButton *btnNextTips, *btnPrevTips, *btnInvite, *btnMiles, *btnEvents, *btnMetaTags, *btnPeople, *btnWebsite, *btnBillBoard;
}

@end
