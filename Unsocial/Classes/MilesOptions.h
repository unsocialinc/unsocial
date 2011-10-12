//
//  MilesOptions.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MilesOptions : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	
	UIImageView *imgHeadview;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack;
	UILabel *loading;
	UITableView *itemTableView;
	NSMutableArray *items;
	NSInteger comingfrom;
}

@property(nonatomic, assign)NSInteger comingfrom;
- (void)createControls;
- (NSMutableDictionary *) setOptions:(NSString *)itemName index: (int) i;
@end
