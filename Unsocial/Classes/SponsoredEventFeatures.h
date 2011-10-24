//
//  SponsoredEventFeatures.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SponsoredEventFeatures : UIViewController <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>
{
	UIImageView *imgHeadview;
	UITableView *itemTableView;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack;
	NSMutableString *featureid, *eventidoffeat, *featuretypeid, *featuretypename, *featuredispname;// , *strDescription, *strFromName, *strDateTime, *strMsgId, *strReadMsg;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableDictionary * item;
	NSString *currentElement;
	UISegmentedControl *segmentedControl;
	
	NSString *eventid;
}

@property (nonatomic,retain) 	NSString *eventid;

- (void)parseXMLFileAtURL:(NSString *)URL;
- (void) getSponsoredEventFeatures;
- (void)createControls;
@end
