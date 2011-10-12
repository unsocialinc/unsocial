//
//  SignIn.h
//  Unsocial
//
//  Created by vaibhavsaran on 17/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <EventKit/EventKit.h>

@interface PollSelect : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, NSXMLParserDelegate>{

	NSArray *options;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	// it parses through the document, from top to bottom...
	// we collect and cache each sub-element value, and then save each item to our array.
	// we use these to track each current item, until it's ready to be added to the "stories" array
	NSString * currentElement;
	//NSMutableString * currentTitle, * currentSummary, * currentLink, *currentDescription, *currentAppName;
	
	NSMutableString * currentquestionsoption, * pollquestionsid, *pollquestionoptionid;
	
	UIActivityIndicatorView *activityView;
	UILabel *loading;
	UIImageView *imgHeadview, *imgBack;
	//NSString *userid, *caldesc, *caltitle;
	UITextField *txtUsername;
	NSString *userid, *pollquestionid, *sponfeatid, *sponeventid, *questions, *noofoptions;
	UIButton *btnSave;
	
	NSMutableArray *pollresult;
	
	// added by pradeep on 4 jan 2011
	NSMutableString *alreadyvoted, *result;
	NSMutableDictionary * item4result;
	NSMutableArray * stories4result;

}
@property(nonatomic, retain) NSString *userid, *pollquestionid, *sponfeatid, *sponeventid, *questions, *noofoptions;
- (void)createControls;
- (void) getpollquestionoptions;
- (void) parseXMLFileAtURL:(NSString *)URL;
- (BOOL) sendRequest4VoteNGetResult: (NSString *) flag: (NSString *) quesoptionid;

@end
