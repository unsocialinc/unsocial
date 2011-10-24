//
//  InBox.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InBox : UIViewController <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>
{
	UILabel *noMessage, *loading;
	UIImageView *imgHeadview, *imgForOverlap, *imgSelectedSeg1, *imgSelectedSeg2;
	UITableView *itemTableView;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *imgBack2;
	NSMutableString *strFrom, *strDescription, *strFromName, *strDateTime, *strMsgId, *strReadMsg;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableDictionary * item;
	NSString *currentElement;
	UISegmentedControl *segmentedControl;
	BOOL editing;
}

- (NSInteger) sendReqForDeleteMessage:(NSInteger) storyIndex;
//- (void)segmenteHoverImage:(BOOL)seg1: (BOOL)seg2;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (void) getInboxMsg;
- (void) getSentMsg;
- (void)createControls;
@end
