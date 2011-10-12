//
//  PeopleEventSetDistance.h
//  Unsocial
//
//  Created by vaibhavsaran on 27/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PeopleEventSetDistance : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {

	UIActivityIndicatorView *activityView;
	UIImageView *imgBack, *userImage;
	UILabel *loading;
	UIPickerView *myPickerView;
	UIView *currentPicker;
	NSArray *pickerViewArray; 
	NSString *selectedComponent, *varSetMilesPeoples, *varSetMilesEvents;
	NSInteger peopleOrEvent;
	BOOL levelChanged;
}
@property (assign, nonatomic) NSInteger peopleOrEvent;
@property (nonatomic, retain)  NSString *varSetMilesPeoples, *varSetMilesEvents;

- (BOOL) getDataFromFile;
- (void) updateDataFileOnSave;
- (void)createControls;
@end
