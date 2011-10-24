//
//  SplashScreen.h
//  Unsocial
//
//  Created by santosh khare on 8/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDColoredProgressView.h"


@interface SplashScreen : UIViewController {
	UIImageView *imgBack;
	float wipeout;
	UILabel *loading;
	PDColoredProgressView *threadProgressView;
	UIActivityIndicatorView *activityView;	
}
@property (nonatomic, retain) PDColoredProgressView *threadProgressView;  
@property (nonatomic, retain) UIImageView *imgBack;  
@end
