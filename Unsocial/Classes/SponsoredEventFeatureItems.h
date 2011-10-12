//
//  SponsoredEventFeatureItems.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyncimageview.h"

@interface SponsoredEventFeatureItems : UIViewController <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>
{
	UIImageView *imgHeadview;
	UITableView *itemTableView;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack;
	NSMutableString *featureitemid, *name, *phone, *email, *company, *industry, *role, *about, *weburl, *description;//, *strReadMsg;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableDictionary * item;
	NSString *currentElement;
	UISegmentedControl *segmentedControl;
	UILabel *loading;
	NSString *eventid, *featureid, *featuretypeid, *featuretypename, *featuredispname;
	
	NSMutableArray *imageURLs4Lazy;
	AsyncImageView* asyncImage;
	NSMutableString *currentImageURL;
}

@property (nonatomic,retain) 	NSString *eventid, *featureid, *featuretypeid, *featuretypename, *featuredispname;

- (void)parseXMLFileAtURL:(NSString *)URL;
- (void) getSponsoredEventFeatureItems;
- (void)createControls;
@end
