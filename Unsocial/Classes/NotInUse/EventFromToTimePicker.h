//
//  RelationPickerController.h
//  CLINIC App
//
//  Created by santosh khare on 11/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventFromToTimePicker : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
	
	UIActivityIndicatorView *activityView;
	UIImageView *imgBack;
	UILabel *loading;
	NSArray *pickerViewArray;
	UIDatePicker *myPickerView;
	UIButton *saveButton;
	UILabel *hiddenLabel;
	NSMutableArray *dateArray;
	NSInteger timeToFrom;
}
@property (assign, nonatomic) NSInteger timeToFrom;
-(void)createPicker;
- (CGRect)pickerFrameWithSize:(CGSize)size;
@end
