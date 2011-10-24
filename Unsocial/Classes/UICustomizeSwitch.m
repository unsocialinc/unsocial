//
//  UICustomizeSwitch.m
//  CustomizeSwitch
//
//  Created by vaibhavsaran on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UICustomizeSwitch.h"
#include "time.h"

@implementation UICustomSwitch
- (_UISwitchSlider *) slider { 
	return [[self subviews] lastObject]; 
}
- (UIView *) textHolder { 
	return [[[self slider] subviews] objectAtIndex:2]; 
}
- (UILabel *) leftLabel { 
	return [[[self textHolder] subviews] objectAtIndex:0]; 
}
- (UILabel *) rightLabel {
//	rightLabel.bounds.size = 
	return [[[self textHolder] subviews] objectAtIndex:1]; 
}
- (void) setLeftLabelText: (NSString *) labelText { 
	[[self leftLabel] setText:labelText]; 
}
- (void) setRightLabelText: (NSString *) labelText { 
	[[self rightLabel] setText:labelText]; 
}
@end

@implementation UICustomizeSwitch

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
