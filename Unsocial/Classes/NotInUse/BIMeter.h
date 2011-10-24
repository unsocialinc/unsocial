//
//  BIMeter.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIMeter : UIViewController <UITextFieldDelegate>
{
	UIImageView *imgHeadview;
	UITextField *tf, *tf2;
	NSMutableArray * stories;
	NSXMLParser * rssParser;
	NSMutableDictionary * item;
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink, *currentDescription, *currentAppName;
	NSMutableString *currentImageURL;
	
	NSArray *wordsDict;
	NSMutableSet *words;	
	
	UILabel *scoreLabel, *scoreLabel2;
	UISegmentedControl *segmentedControl;
	
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain, readonly) UITextField *tf, *tf2;
@property (nonatomic, retain) UILabel *scoreLabel, *scoreLabel2;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (void) analyzeStories: (int) index;

@end
