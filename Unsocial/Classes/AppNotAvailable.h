//
//  AppNotAvailable.h
//  Unsocial
//
//  Created by vaibhavsaran on 07/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"


@interface AppNotAvailable : UIViewController <NSXMLParserDelegate>{

	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UIImageView *imgHeadview, *imgBack;
	NSString *userid;
	NSString *stronlocation;
}
@property(nonatomic, retain) NSString *stronlocation;
- (void)createControls;
@end