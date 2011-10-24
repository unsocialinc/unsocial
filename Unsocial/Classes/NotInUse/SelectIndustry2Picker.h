//
//  SelectIndustry2Picker.h
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectIndustry2Picker: UIViewController <UIPickerViewDelegate, NSXMLParserDelegate>
{
	UILabel *loading;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSString * currentElement;
	NSMutableString * currentTitle, *subIndustryName, *subIndustryID;
	NSMutableDictionary * item;

	UIImageView *imgHeadview;
	UIActivityIndicatorView *activityView;
	NSArray *pickerViewArray;
	UIPickerView *myPickerView;
	UIView *currentPicker;
	NSMutableArray *arySelected;
	NSString *selectedComponent;
}
- (void) getSubIndustryList;//:(NSInteger )page:(NSString *)comicid;
- (void)parseXMLFileAtURL:(NSString *)URL;
- (void)createControls;
@end
