//
//  SelectIndustryPicker.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventSelectIndustry : UIViewController <UIPickerViewDelegate, NSXMLParserDelegate>
{
	UILabel *loading;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSString * currentElement;
	NSMutableString * currentTitle, *eventIndustryName, *eventIndustryID;
	NSMutableDictionary * item;
	UIImageView *imgHeadview;
	UIActivityIndicatorView *activityView;
	NSArray *pickerViewArray;
	UIPickerView *myPickerView;
	UIView *currentPicker;
	NSString *selectedComponent;
	UIImageView *imgBack;
	NSMutableArray *arySelected, *arySelectedID, *eventIndustryNames, *eventIndustryIDs;
}
- (void) getIndustryList;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (void)createControls;
@end
