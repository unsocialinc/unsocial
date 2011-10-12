//
//  SettingsAddKeywords.h
//  Unsocial
//
//  Created by vaibhavsaran on 28/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsAddKeywords : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSXMLParserDelegate>
{
	BOOL editing, isSaved;
	UIImageView *imgBack;
	UILabel *loading;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSString * currentElement;
	NSMutableString *keywordName;
	NSMutableDictionary * item;
	UIButton *btnSave;
	UITableView *itemTableView;
	UILabel *lblKeywordName, *lblNoKeyword;
	UIActivityIndicatorView *activityView;
	NSString *strCollectionKeywords,*userid;
	NSMutableArray *collectionAryKeywords;
	UITextField *txtKeyword;	
	NSInteger traceClick;
}
- (void) getKeywordsForUser:(NSString *)inid;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (BOOL) sendNow: (NSString *) flag;
- (void) updateDataFileOnSave:(NSString *)uid:(NSString *)str;
- (void)btnNext_Click;
@property (nonatomic,retain) NSString *userid, *keywordName;
@end
