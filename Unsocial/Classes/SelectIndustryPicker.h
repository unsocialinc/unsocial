//
//  SelectIndustryPicker.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectIndustry2Picker.h"


@interface SelectIndustryPicker : UIViewController <UIPickerViewDelegate, NSXMLParserDelegate>
{
	UILabel *loading;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSString * currentElement;
	NSMutableString * currentTitle, *industryName, *industryID;
	NSMutableDictionary * item;
	UIImageView *imgHeadview;
	UIActivityIndicatorView *activityView;
	NSArray *pickerViewArray;
	UIPickerView *myPickerView;
	UIView *currentPicker;
	NSString *selectedComponent;
	NSMutableArray *arySelected;
	SelectIndustry2Picker *viewController;
	UIImageView *imgBack;
	NSMutableString *strcompany, *strwebsite, *strindustry, *strfunction, *strroleid, *strindid;
}
@property(nonatomic, retain)NSMutableString *strcompany, *strwebsite, *strindustry, *strfunction, *strroleid, *strindid;
- (void) getIndustryList;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (void)createControls;
@end
