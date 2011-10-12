//
//  PhotoSCView.h
//  AppTango
//
//  Created by santosh khare on 7/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoViewController.h"


@interface PhotoSCView : UIScrollView {
	PhotoViewController *pv;
	
}

- (id)initWithFrame:(CGRect)frame NVView: (PhotoViewController *)vc;

@end
