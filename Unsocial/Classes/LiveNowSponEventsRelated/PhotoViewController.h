//
//  PhotoViewController.h
//  AppTango
//
//  Created by santosh khare on 6/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideShowViewController.h"

// this view controller is used for photo feature. It displays all the thumbnails from photobucket rss feed in the form of 4*n matrix

@interface PhotoViewController : UIViewController <NSXMLParserDelegate> {
	
	UILabel *loading;
	UITableView *ApptableView;
	UIActivityIndicatorView * activityIndicator;
	
	NSXMLParser * rssParser, *rssParser2;
	NSMutableArray * stories;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	// it parses through the document, from top to bottom...
	// we collect and cache each sub-element value, and then save each item to our array.
	// we use these to track each current item, until it's ready to be added to the "stories" array
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;
	NSMutableString *currentImageURL, *currentImageURL2;
	NSMutableString *currimgurl4fullimg;
	NSMutableArray *images;
	UIActivityIndicatorView *activityView;
	SlideShowViewController *ssvc;
	UIImageView *TSImageView;
	UIImageView *imgHeadview;
	UIImageView *imgBack;
	NSString *geturl;
}
@property (nonatomic, retain) SlideShowViewController *ssvc;
@property (nonatomic, retain)	UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UIImageView *TSImageView;
@property (nonatomic, retain) NSMutableArray *images;
@property (copy, nonatomic) NSMutableArray *stories;
@property (copy, nonatomic) NSMutableDictionary *item;
@property (nonatomic, retain) NSMutableString *currimgurl4fullimg;
@property (nonatomic, retain) 	NSString *geturl;


- (void) displayAnimation;
- (void) getFlickrData;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (void) addGridNow;
- (void) displayAnimation2duringFullImgPrepared;

- (void) photoSelect: (int) photIndex;
- (void) photoSelect2;
- (void) getNow;
@end
