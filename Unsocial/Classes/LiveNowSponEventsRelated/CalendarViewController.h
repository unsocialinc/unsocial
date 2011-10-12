//
//  CalendarViewController.h
//  Unsocial
//
//  Created by Ashutosh Srivastava on 25/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "asyncimageview.h"
#import <EventKit/EventKit.h>


@interface CalendarViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>
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
	
	NSString *eventid, *featureid, *featuretypeid, *featuretypename, *featuredispname;
	UILabel *loading;
	NSMutableArray *imageURLs4Lazy;
	AsyncImageView* asyncImage;
	NSMutableString *currentImageURL;
	UIButton *btnSave;
}

@property (nonatomic,retain) 	NSString *eventid, *featureid, *featuretypeid, *featuretypename, *featuredispname;

- (void)parseXMLFileAtURL:(NSString *)URL;
- (void) getSponsoredEventFeatureItems;
- (void)createControls;

@end
