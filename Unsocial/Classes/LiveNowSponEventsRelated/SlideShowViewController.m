#import "SlideShowViewController.h"

@interface SlideShowView : UIView
{
	NSArray * mImages;
	
	UIImageView * mLeftImageView;
	UIImageView * mCurrentImageView;
	UIImageView * mRightImageView;
	
	NSUInteger mCurrentImage;
	
	BOOL mSwiping;
	CGFloat mSwipeStart;
}

- (id)initWithImages:(NSArray *)inImages;

@end // SlideShowView


#pragma mark -


@implementation SlideShowView

- (UIImageView *)createImageView:(NSUInteger)inImageIndex
{
	if (inImageIndex >= [mImages count])
	{
		return nil;
	}
	
	UIImageView * result = [[UIImageView alloc] initWithImage:[mImages objectAtIndex:inImageIndex]];
	result.opaque = YES;
	result.userInteractionEnabled = NO;
	result.backgroundColor = [UIColor clearColor];
	result.contentMode = UIViewContentModeScaleAspectFit;
	result.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	return result;
}

- (id)initWithImages:(NSArray *)inImages inImageIndex:(NSUInteger) inImageIndex
{
	if (self = [super initWithFrame:CGRectZero])
	{
		mImages = [inImages retain];
		
		NSUInteger imageCount = [inImages count];
		if (imageCount > 0)
		{
			mCurrentImageView = [self createImageView:0];
			[self addSubview:mCurrentImageView];
			
			if (imageCount > 1)
			{
				mRightImageView = [self createImageView:1];
				[self addSubview:mRightImageView];
			}
			
		}
		
		self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}
	
	return self;
}

- (void)dealloc
{
	[mImages release];
	[super dealloc];
}



- (void)layoutSubviews
{
	if (mSwiping)
		return;
	
	CGSize contentSize = self.frame.size;
	mLeftImageView.frame = CGRectMake(-contentSize.width, 0.0f, contentSize.width, contentSize.height);
	mCurrentImageView.frame = CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height);
	mRightImageView.frame = CGRectMake(contentSize.width, 0.0f, contentSize.width, contentSize.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([touches count] != 1)
		return;
	
	mSwipeStart = [[touches anyObject] locationInView:self].x;
	mSwiping = YES;
	
	mLeftImageView.hidden = NO;
	mCurrentImageView.hidden = NO;
	mRightImageView.hidden = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (! mSwiping || [touches count] != 1)
		return;
	
	CGFloat swipeDistance = [[touches anyObject] locationInView:self].x - mSwipeStart;
	
	CGSize contentSize = self.frame.size;
	
	mLeftImageView.frame = CGRectMake(swipeDistance - contentSize.width, 0.0f, contentSize.width, contentSize.height);
	mCurrentImageView.frame = CGRectMake(swipeDistance, 0.0f, contentSize.width, contentSize.height);
	mRightImageView.frame = CGRectMake(swipeDistance + contentSize.width, 0.0f, contentSize.width, contentSize.height);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (! mSwiping)
		return;
	
	CGSize contentSize = self.frame.size;
	
	NSUInteger count = [mImages count];
	
	CGFloat swipeDistance = [[touches anyObject] locationInView:self].x - mSwipeStart;
	if (mCurrentImage > 0 && swipeDistance > 50.0f)
	{
		[mRightImageView removeFromSuperview];
		[mRightImageView release];
		
		mRightImageView = mCurrentImageView;
		mCurrentImageView = mLeftImageView;
		
		mCurrentImage--;
		if (mCurrentImage > 0)
		{
			mLeftImageView = [self createImageView:mCurrentImage - 1];
			mLeftImageView.hidden = YES;
			
			[self addSubview:mLeftImageView];
		}
		else
		{
			mLeftImageView = nil;
		}
	}
	else if (mCurrentImage < count - 1 && swipeDistance < -50.0f)
	{
		[mLeftImageView removeFromSuperview];
		[mLeftImageView release];
		
		mLeftImageView = mCurrentImageView;
		mCurrentImageView = mRightImageView;
		
		mCurrentImage++;
		if (mCurrentImage < count - 1)
		{
			mRightImageView = [self createImageView:mCurrentImage + 1];
			mRightImageView.hidden = YES;
			
			[self addSubview:mRightImageView];
		}
		else
		{
			mRightImageView = nil;
		}
	}
	
	[UIView beginAnimations:@"swipe" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3f];
	
	mLeftImageView.frame = CGRectMake(-contentSize.width, 0.0f, contentSize.width, contentSize.height);
	mCurrentImageView.frame = CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height);
	mRightImageView.frame = CGRectMake(contentSize.width, 0.0f, contentSize.width, contentSize.height);
	
	[UIView commitAnimations];
	
	mSwiping = NO;
}


@end // SlideShowView


#pragma mark -


@implementation SlideShowViewController


- (id)initWithImages:(NSArray *)inImages imageIndex:(NSUInteger)inImageIndex{
	
	if (self = [super initWithNibName:nil bundle:nil])
	{
		self.view = [[[SlideShowView alloc] initWithImages:inImages inImageIndex:inImageIndex] autorelease];
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	
	//NSLog(@"RV view will appear");
	
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor grayColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	//add background color
	self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"mainbackground.png"]];
	
	/*imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];
	[self.view addSubview:imgBack];*/
	
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	 [leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	 [leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	 UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	 itemNV.leftBarButtonItem = leftcbtnitme;
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	// added by pradeep on 1 june 2011 for returning to dashboard requirement
	
	UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(285.0, 0.0, 33, 30)];
	[rightbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[rightbtn addTarget:self action:@selector(rightbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightbtnitme = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
	itemNV.rightBarButtonItem = rightbtnitme;
	//rightbtn.hidden = YES;
	
	// end 1 june 2011
}

- (void)leftbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	//[lastVisitedFeature addObject:@"message"];
	[self.navigationController popViewControllerAnimated:YES];
}

// added by pradeep on 1 june 2011 for returning to dashboard requirement
- (void)rightbtn_OnClick{
	
	//[lastVisitedFeature removeAllObjects];
	[self dismissModalViewControllerAnimated:YES];
}
// end 1 june 2011



@end
