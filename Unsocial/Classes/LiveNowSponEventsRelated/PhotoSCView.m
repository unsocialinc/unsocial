//
//  PhotoSCView.m
//  AppTango
//
//  Created by santosh khare on 7/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PhotoSCView.h"
#import "UnsocialAppDelegate.h"
#import "PhotoViewController.h"


@implementation PhotoSCView


- (id)initWithFrame:(CGRect)frame NVView: (PhotoViewController *) vc{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		pv = vc;
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];
	
	CGPoint location = [touch locationInView:self];
	NSLog(@"Touched Location from view %f %f", location.x, location.y);
	int photoIndex = (int) location.x / 74 + 4 * ((int) location.y / 74);
	NSLog(@"Photo index %d", photoIndex);
	[pv photoSelect:photoIndex];

}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
