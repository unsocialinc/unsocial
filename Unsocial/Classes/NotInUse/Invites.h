//
//  Invites.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface Invites : UIViewController <MFMailComposeViewControllerDelegate>
{
	UIImageView *imgHeadview;
	UIActivityIndicatorView *activityView;
	UILabel *loading;
}

- (void)createControls;
@end
