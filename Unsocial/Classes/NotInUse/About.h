//
//  About.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface About : UIViewController
{
	UIImageView *imgHeadview;
	UIActivityIndicatorView *activityView;
}

- (void)createControls;
@end
