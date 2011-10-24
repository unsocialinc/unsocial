//
//  SlideShowViewController.h
//  SlideShow
//
//  Created by Lieven Dekeyser on 03/10/08.
//  Copyright Lieven Dekeyser 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

//this view controller is used for photo feature. It displays the full image in the form of slide show.

@interface SlideShowViewController : UIViewController
{
	UIImageView *imgHeadview;
	UIImageView *imgBack;
}

- (id)init;
- (id)initWithImages:(NSArray *)inImages imageIndex:(NSUInteger) inImageIndex;

@end

