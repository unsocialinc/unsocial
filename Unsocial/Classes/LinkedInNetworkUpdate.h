//
//  LinkedInNetworkUpdate.h
//  Unsocial
//
//  Created by vaibhavsaran on 13/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LinkedInNetworkUpdate : UIViewController {

	UIActivityIndicatorView *activityView;
	UIImageView *imgBack;
	UILabel *loading;
	UIImageView *imgHeadview;
	UIButton *btnInvite;
}
- (void)createControls;
@end