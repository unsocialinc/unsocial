//
//  SettingsTableView.h
//  Unsocial
//
//  Created by vaibhavsaran on 03/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsTableView : UIViewController <UITableViewDataSource, UITableViewDelegate>{

	UILabel *loading;
	UIImageView *imgHeadview, *imgBack;
	UITableView *itemTableView;
	NSArray *dataSourceArray;
	NSMutableArray *items;
	UIActivityIndicatorView *activityView;
	NSString *userid;
}
@property(retain, nonatomic)NSString *userid;
- (void) getCompanyInfoForLinkedIn;
- (NSInteger)lookRecordIntoFile:(NSString *)fileName;
- (void)ifDataExists;
- (void)createTableView;
- (NSMutableDictionary *) setOptions:(NSString *)itemName index: (int) i;
@end
