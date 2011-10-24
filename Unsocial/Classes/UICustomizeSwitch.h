//
//  UICustomizeSwitch.h
//  CustomizeSwitch
//
//  Created by vaibhavsaran on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwitch (extended)
- (void) setAlternateColors:(BOOL) boolean;
@end

@interface _UISwitchSlider : UIView
@end

@interface UICustomSwitch : UISwitch
- (void) setLeftLabelText: (NSString *) labelText;
- (void) setRightLabelText: (NSString *) labelText;
- (_UISwitchSlider *) slider;
- (UIView *) textHolder;
- (UILabel *) leftLabel;
- (UILabel *) rightLabel;
@end

@interface UICustomizeSwitch : UIViewController {

	UICustomSwitch *switchView;
	UIView *contentView;
}
@end
