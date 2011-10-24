//
//  VideoViewController.h
//  AppTango
//
//  Created by santosh khare on 6/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogWebViewController.h"


@interface BlogViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate> {
	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	// it parses through the document, from top to bottom...
	// we collect and cache each sub-element value, and then save each item to our array.
	// we use these to track each current item, until it's ready to be added to the "stories" array
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink, *currentDescription, *currentAppName;
	NSMutableString *currentImageURL;
	
	UITableView *blogTableView;
	BlogWebViewController *bwvc;
	UIImageView *imgHeadview, *imgBack;
	UIActivityIndicatorView *activityView;
	UILabel *labelTtl;
	UILabel *label, *loading;
	NSString *featid;
	NSString *urlString;
	NSString *urlfromnews, *redirectFromNews;
}
@property (nonatomic, retain) NSString *urlfromnews, *redirectFromNews;
@property(nonatomic,retain) BlogWebViewController *bwvc;
@property (nonatomic, retain) UILabel *labelTtl;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) NSString *featid;
// internal function to ease setting up label text
- (void) getBlogData:(NSString *)url;
- (void) parseXMLFileAtURL:(NSString *)URL;
@end
