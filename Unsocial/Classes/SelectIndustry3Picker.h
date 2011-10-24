//
//  SelectIndustry3Picker.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectIndustry2Picker.h"

@interface SelectIndustry3Picker: UIViewController <UIPickerViewDelegate, NSXMLParserDelegate>
{
	UILabel *loading;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSString * currentElement;
	NSMutableString * currentTitle, *roleName, *roleID;
	NSMutableDictionary * item;
	
	UIImageView *imgHeadview;
	NSArray *pickerViewArray;
	UIPickerView *myPickerView;
	UIView *currentPicker;
	NSMutableArray *arySelected;
	NSString *selectedComponent;
	UIActivityIndicatorView *activityView;
	SelectIndustry2Picker *selectIndustry2Picker;
	UIImageView *imgBack;
}
- (void) getRolesList;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (void)createControls;
@end
