//
//  MyNotes.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import <Three20UICommon/UIViewControllerAdditions.h>
#import <Three20UI/UIViewAdditions.h>

@interface MyNotes : UIViewController <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate, UITextViewDelegate, TTPostControllerDelegate>
{
	UILabel *noMessage, *loading;
	UIImageView *imgHeadview, *imgForOverlap, *imgSelectedSeg1, *imgSelectedSeg2;
	UITableView *itemTableView;
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *imgBack2;
	NSMutableString *strAssociatedUserID, *strNoteHeader, *strAssociatedUserName, *strNoteCreationDate, *strNoteId, *strIsNoteRead, *strAtEvent, *strNoteCategory, *strShortNote, *strSavedAt;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableDictionary * item;
	NSString *currentElement;
	UISegmentedControl *segmentedControl;
	BOOL editing;
	NSInteger comingfrom;
	UILabel *heading;
	NSString *userid4displayingnotes, *notepurposeflag, *camefromwhichoption, *eventid4attendeelistofnormalevent;
	UITextView *tvNote;
}

@property (nonatomic, assign)NSInteger comingfrom;
@property (nonatomic, retain) NSString *userid4displayingnotes, *notepurposeflag, *camefromwhichoption, *eventid4attendeelistofnormalevent;

- (NSInteger) sendReqForDeleteMessage:(NSInteger) storyIndex;
//- (void)segmenteHoverImage:(BOOL)seg1: (BOOL)seg2;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (void) getNotes;
//- (void) getSentMsg;
- (BOOL) addNoteRequest: (NSString *) shortnotetxt;
- (void)createControls;
@end
