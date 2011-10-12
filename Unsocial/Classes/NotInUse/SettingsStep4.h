//
//  SettingsStep4.h
//  Unsocial
//
//  Created by vaibhavsaran on 15/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsStep4 : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>
{
	UIImageView *imgBack;
	UILabel *loading;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSString * currentElement;
	NSMutableString * currentTitle, *indNameFromServer, *industryID, *industryName, *subIndustryID, *subIndustryName, *roleID, *roleName;
	NSMutableDictionary * item;
	UIButton *btnSkip;
	UITableView *itemTableView;
	UILabel *lblIndustryName, *noIndustry;
	UIActivityIndicatorView *activityView;
	NSString *collectionindustry, *collectionsubindustry, *collectionrole,*userid;
	NSMutableArray *collectionindustryAry, *collectionsubindustryAry, *collectionroleAry;
	
}
- (void) getIndustryNames:(NSString *)inid;
- (void)parseXMLFileAtURL:(NSString *)URL;

- (BOOL) sendNow: (NSString *) flag;
- (BOOL) getDataFromFile;
- (void) updateDataFileOnSave:(NSString *)uid;
@property (nonatomic,retain) NSString *userid, *industryID, *industryName, *subIndustryID, *subIndustryName, *roleID, *roleName;
@end
