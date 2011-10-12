//
//  SettingsAddVideo.h
//  Unsocial
//
//  Created by vaibhavsaran on 28/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsAddVideo : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSXMLParserDelegate>
{
	BOOL editing, isSaved;
	UIImageView *imgBack;
	UILabel *loading;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSString * currentElement;
	NSMutableString *videoName, *videoTitleName;
	NSMutableDictionary * item;
	//UIButton *btnSkip;
	UITableView *itemTableView;
	UILabel *lblVideoName, *lblVideoTitle, *lblNoVideo;
	UIActivityIndicatorView *activityView;
	NSString *strCollectionVideo, *strCollectionVideoTitle,*userid;
	NSMutableArray *collectionAryVideo, *collectionAryVideoTitle;
	UITextField *txtVideo, *txtTitle;
	NSInteger traceClick;
	NSInteger comingfrom;
}
- (void) updateDataFileOnSave;
- (void) getVideoForUser:(NSString *)inid;
- (void)parseXMLFileAtURL:(NSString *)URL;

- (BOOL) sendNow: (NSString *) flag;
@property (assign, nonatomic) NSInteger comingfrom;
@property (nonatomic,retain) NSString *userid, *videoName, *videoTitleName;
@end
