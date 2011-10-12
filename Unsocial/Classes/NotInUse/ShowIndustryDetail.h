//
//  ShowIndustryDetail.h
//  Unsocial
//
//  Created by vaibhavsaran on 16/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShowIndustryDetail : UIViewController {

	UILabel *loading;
	NSString *industryName, *subIndustryName, *jobRole;
	UIActivityIndicatorView *activityView;
}

@property(nonatomic, retain)	NSString *industryName, *subIndustryName, *jobRole;
@end
