//
//  AddTags.h
//  Unsocial
//
//  Created by vaibhavsaran on 28/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddTags : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSXMLParserDelegate>
{
	BOOL editing, isSaved, checkAlertType;
	UIImageView *imgBack;
	UILabel *loading;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSString * currentElement;
	NSMutableString *tagsName;
	NSMutableDictionary * item;
	//UIButton *btnSkip;
	UITableView *itemTableView;
	UILabel *lbltagsName;
	UIActivityIndicatorView *activityView;
	NSString *strCollectionTags,*userid;
	NSMutableArray *collectionAryKeywords;
	UITextField *txttags;	
	NSInteger traceClick;
	UIButton *btnSave;
}
- (void) getTagsForUser:(NSString *)inid;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (void) updateDataFileOnSave:(NSString *)uid:(NSString *)str;

- (BOOL) sendNow: (NSString *) flag;
- (void)btnNext_Click;
//- (BOOL) getDataFromFile;
//- (void) updateDataFileOnSave:(NSString *)uid;
@property (nonatomic,retain) NSString *userid, *tagsName;
@end
