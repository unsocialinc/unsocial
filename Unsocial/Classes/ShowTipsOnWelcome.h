//
//  ShowTips.h
//  Unsocial
//
//  Created by vaibhavsaran on 11/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowTipsOnWelcome : UIViewController {
	
	NSString *tip1, *tip2, *tip3, *tip4, *tip5, *tip6, *tip7, *tip8, *tip9;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *imgProfileBack, *imgTipsBackgrnd, *imgTipsHor;
	UILabel *loading, *lblTips, *heading;
	NSMutableArray *arrayAllTips;
	UILabel *tips, *heading2;
	UITextView *learnMore;
	UIButton *btnNextTips, *btnPrevTips, *btnTips;
}
@property(nonatomic, retain)NSString *tip1, *tip2, *tip3, *tip4, *tip5, *tip6, *tip7, *tip8, *tip9;

@end
