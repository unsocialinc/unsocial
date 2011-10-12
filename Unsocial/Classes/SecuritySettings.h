//
//  SecuritySettings.h
//  Unsocial
//
//  Created by vaibhavsaran on 16/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecuritySettings : UIViewController {
	
	UIImageView *imgBack, *imgSelectedSeg1, *imgSelectedSeg2;
	UIActivityIndicatorView *activityView;
	UISegmentedControl *segmentedControl;
	NSInteger selectedSegment;
	UIButton *btnEdit;
	NSMutableArray *arrayForSelectedIndex;
	NSString *varSelectedLevel, *varSecurityItems, *varUserid, *userid;
	UILabel *loading;
}
- (void) updateDataFileOnSave:(NSString *)uid:(NSString *)level:(NSString *)securityItems;
- (BOOL)sendSecurityLevel:(NSString *)selsecurity:(NSString *)selectedLevel;
- (void)createControls;
- (BOOL) getDataFromFile;
@property(retain, nonatomic) NSString *varSelectedLevel, *varSecurityItems, *varUserid, *userid;
@end
