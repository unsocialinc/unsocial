//
//  EventAdd.h
//  Unsocial
//
//  Created by vaibhavsaran on 29/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventAdd : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {

	NSArray *dataSourceArray;
	UITableView *itemtableView;
	UILabel *loading;
	UIImageView *imgHeadview, *imgBack;
	UIActivityIndicatorView *activityView;
	UITextField *txtEName, *txtAddress, *txtInd, *txtDate, *txtTime, *txtToTime, *txtWebsite, *txtContact;
	UITextView *txtDescription;
	UISwitch *switchCtl;
	UIButton *btnDone;
	NSMutableArray *eventDetails;
	NSString *userid, *isReccuring;
}
- (BOOL) sendNow: (NSString *) flag;
@property(nonatomic, retain)NSMutableArray *eventDetails;
- (void)restoreToArray;
-(NSMutableDictionary *)FillIndustry;
-(NSMutableDictionary *)FillDate;
-(NSMutableDictionary *)FillFromTime;
-(NSMutableDictionary *)FillToTime;
-(NSMutableDictionary *)FillDescription;
-(NSMutableDictionary *)FillWebsite;
-(NSMutableDictionary *)FillEName;
-(NSMutableDictionary *)FillAddress;
-(NSMutableDictionary *)FillContact;
-(NSMutableDictionary *)FillSwitch;
-(NSMutableDictionary *)None;
- (void)createControls;
@end
