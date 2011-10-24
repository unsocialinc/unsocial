//
//  ShowUnsocialMilesTips.h
//  Unsocial
//
//  Created by vaibhavsaran on 11/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShowUnsocialMilesTips : UIViewController <NSXMLParserDelegate>{

	UIImageView *imgHeadview;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack;
	UILabel *loading;
	//UIImageView *imgHeadview;
	UITextView *tips;
	UILabel *lblMiles, *lblMilesValue1, *lblMilesValue2, *lblMilesValue3, *lblMilesValue4;
	NSString *selectedoption;
UIImageView *imgHorSep;
}

@property (nonatomic,retain) NSString *selectedoption;
- (void) getUnsocialMiles;

@end
