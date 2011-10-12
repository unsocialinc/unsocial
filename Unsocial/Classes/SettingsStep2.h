	//
	//  SettingsStep2.h
	//  Unsocial
	//
	//  Created by vaibhavsaran on 14/04/10.
	//  Copyright 2010 __MyCompanyName__. All rights reserved.
	//

#import <UIKit/UIKit.h>

@interface SettingsStep2  : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, NSXMLParserDelegate>
{
	NSXMLParser *rssParser;
	NSMutableArray *stories;
	NSMutableDictionary *item;
	NSMutableString *currentElement, *userdevicetocken, *userlastuse, *userlinkedin, *userind, *userprefix;
	NSString *strFrom;
	
	UIImageView *imgBack, *loadingBack, *topImgHorSep;
	UILabel *loading;
	UIImageView *imgHeadview;
	UITextField *txtCompany, *txtWebsite, *txtIndustry, *txtFunction, *txtPublicProfile, *txtTitle;
	UIButton *btnNext, *btnSave, *btnSelectIndustry;
	NSMutableString *usercompany, *userwebsite, *userindustry, *userfunction, *userid,*userindid, *userroleid;
	UIActivityIndicatorView *activityView;
	UITextField *txtPersonContact;
	UIBarButtonItem *btnDone1;
	NSMutableArray *allInfo, *arrayIndId, *arrayRoleId;
	NSArray *aray1;
	UILabel *lblPublicProfile, *lblCompany, *lblWebsite, *heading;
	UILabel *lblTitle, *lblIndustry, *FillBlank;
	UIView *uv;
	NSArray			*dataSourceArray;
	UITableView *itemTableView;
}
- (void)createControls;
- (UILabel *)FillBlank;
- (UITextField *)txtFunction;
- (UITextField *)txtFunction;
- (UITextField *)txtPublicProfile;
- (UITextField *)txtWebsite;
- (UITextField *)txtTitle;
- (UITextField *)txtCompany;

- (void) viewMoveToUpDown:(NSInteger) yAxis;
- (void)createTableView;
- (void) getPrefixFromFile;
- (void) updateDataFile4CompanyInfo;
- (void) getProfile;
- (void) parseXMLFileAtURL:(NSString *)URL;
@property (nonatomic, retain) NSArray *dataSourceArray;
@property(nonatomic, retain) NSMutableString *currentElement, *userdevicetocken, *userlastuse, *userlinkedin, *userind, *userprefix;
@property(nonatomic, retain) NSString *strFrom;
@property(nonatomic, retain)UITextField *txtCompany, *txtWebsite, *txtIndustry, *txtFunction, *txtPublicProfile, *txtTitle;
@property(nonatomic, retain)UILabel *FillBlank;
@property (nonatomic,retain) NSArray *aray1;
-(void)resignAll;
- (void)checkForLeftNavClick;
- (void)storeToMutableArray;
- (BOOL) getDataFromFile;
- (BOOL) send4CompanyInfo: (NSString *) flag;
- (void) updateDataFileOnSave:(NSString *)uid;
@property (nonatomic,retain) NSMutableString *usercompany, *userwebsite, *userindustry, *userfunction, *userid, *userindid, *userroleid;
@end
