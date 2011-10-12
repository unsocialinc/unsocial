//
//  SettingsSelectPrefix.h
//  Unsocial
//
//  Created by vaibhavsaran on 07/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsSelectPrefix : UIViewController <UIPickerViewDelegate>{
	
	UIImageView *imgHeadview;
	UIActivityIndicatorView *activityView;
	NSArray *pickerViewArray;
	UIPickerView *myPickerView;
	UIView *currentPicker;
	NSString *selectedComponent, *strPrefix;
	NSMutableArray *arySelected, *arySelectedPrefix;
	UIImageView *imgBack;
	BOOL levelChanged;
	UIButton *btnSelect;
}
- (void)saveAndGoback;
@property(nonatomic, retain) NSString *selectedComponent, *strPrefix;
- (void)createControls;
@end
