//
//  AddExtraFeature.h
//  Unsocial
//
//  Created by vaibhavsaran on 20/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddExtraFeature : UIViewController {

	UIImageView *imgBack, *imgHeadview;
	UISwitch *switchCtl1, *switchCtl2;
	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UIButton *btnSave;
}

- (void) btnSave_Click;
- (BOOL) sendReq4AddExtraFeature:(NSString *)featurevalue:(NSString *)futureflg;
- (void) createControls;
@end
