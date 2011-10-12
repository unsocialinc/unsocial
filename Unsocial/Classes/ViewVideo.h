//
//  SettingsAddVideo.h
//  Unsocial
//
//  Created by vaibhavsaran on 28/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewVideo : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
	UIImageView *imgBack;
	UILabel *loading;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableDictionary * item;
	
	NSString * currentElement;
	NSMutableString *videoName, *videoTitleName;

	UITableView *itemTableView;
	UILabel *lblVideoName, *lblVideoTitle, *lblNoVideo;
	UIActivityIndicatorView *activityView;
	NSString *strCollectionVideo, *strCollectionVideoTitle,*userid;
	NSMutableArray *collectionAryVideo, *collectionAryVideoTitle;
	UITextField *txtVideo, *txtTitle;
}
- (void) getVideoForUser:(NSString *)inid;
- (void)parseXMLFileAtURL:(NSString *)URL;

@property (nonatomic,retain) NSString *userid, *videoName, *videoTitleName;
@end
