#import "LauncherNewUserController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation LauncherNewUserController
@synthesize settings;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
	if (self = [super init]) {
		//self.title = @"Launcher";
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (CGFloat)rowHeight {
	//  if (UIInterfaceOrientationIsPortrait(TTInterfaceOrientation())) {
    return 103;
	//  } else {
	//    return 74;
	//  }
	
} 

- (void)viewWillAppear:(BOOL)animated {	
	
	// for aesthetic reasons (the background is black), make the nav bar black for this particular page
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	// match the status bar with the nav bar
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
	
	//add background color
	self.view.backgroundColor = [UIColor grayColor];
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	[imgHeadview release];
}

- (void) getTabs {
	NSMutableDictionary *items = [[NSMutableDictionary alloc] init];
	springBoardTabsAry = [[NSMutableArray alloc] init];
	for (int i=0; i < 2; i++)
	{
		if (i==0)
		{
			[items setObject:@"LinkedIn" forKey:@"title"];
			[items setObject:@"bundle://linkedin.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",i+1]]  forKey:@"URL"];			
			[items setObject:@"NO" forKey:@"candelete"];
		}
		else if (i==1)
		{
			[items setObject:@"Sign Up" forKey:@"title"];
			[items setObject:@"bundle://signup.png" forKey:@"image"];
			[items setObject:[@"fb://item" stringByAppendingString:[NSString stringWithFormat:@"%i",i+1]]  forKey:@"URL"];
			[items setObject:@"NO" forKey:@"candelete"];
		}
		[springBoardTabsAry addObject:[items copy]];
	}
	
}
///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
	[super loadView];
	imgBackgrnd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBackgrnd.image = [UIImage imageNamed:@"imgback.png"];
	[self.view addSubview:imgBackgrnd];
	[imgBackgrnd release];
	
	_launcherView = [[TTLauncherView alloc] initWithFrame:CGRectMake(0, 35, 320, 320)]; //CGRectMake(0.0, 0.0, 320, 103)];//
	//_launcherView.backgroundColor = [UIColor grayColor];
	_launcherView.delegate = self;
	_launcherView.columnCount = 3;
	
	[self getTabs];
	
	int totitem = [springBoardTabsAry count];
	int totpage = (totitem%9==0)?(totitem/9):((totitem/9)+1);
	int cnt4innerloop1 = 0, cnt4innerlooplast = 0;
	if (totitem%9==0)
	{
		cnt4innerloop1 = 9;
		cnt4innerlooplast = 9;
	}
	else 
	{
		if (totitem < 9)
		{
			cnt4innerloop1 = totitem%9;
			cnt4innerlooplast = totitem%9;
		}
		else {
			cnt4innerloop1 = 9;
			cnt4innerlooplast = totitem%9;
		}
		
	}
	
	NSMutableArray *ary2 = [[NSMutableArray alloc] init];
	int cntpg=0;	
	int temptotitem = 0;
	
	for (int i=0; i<totpage; i++)
	{
		cntpg++;
		NSLog(@"Hello");
		NSMutableArray *ary1 = [[NSMutableArray alloc] init];
		
		if (cntpg < totpage)
			temptotitem = cnt4innerloop1;
		else temptotitem = cnt4innerlooplast;
		
		
		for (int j=0; j < temptotitem; j++) 
		{				
			//[ary1 addObject:[[[TTLauncherItem alloc] initWithTitle:@"People" image:@"bundle://tabbar_people.png" URL:@"fb://item1" canDelete:YES] autorelease]];
			BOOL candelete;
			if([[[springBoardTabsAry objectAtIndex:j] objectForKey:@"candelete"] compare:@"YES"] == NSOrderedSame)
				candelete = NO;
			[ary1 addObject:[[[TTLauncherItem alloc] initWithTitle:[[springBoardTabsAry objectAtIndex:j] objectForKey:@"title"] image:[[springBoardTabsAry objectAtIndex:j] objectForKey:@"image"] URL:[[springBoardTabsAry objectAtIndex:j] objectForKey:@"URL"] canDelete:NO] autorelease]];
		}
		[ary2 addObject:ary1];
		_launcherView.pages = ary2;
		[ary1 release];
		[ary2 release];
	}
	
	[self.view addSubview:_launcherView];
	[_launcherView release];
	
	UIImageView *imgBottomTemp = [[UIImageView alloc]initWithFrame:CGRectMake(0, 373, 320, 44)];
	imgBottomTemp.image = [UIImage imageNamed:@"bottomTemp.png"];
	[self.view addSubview:imgBottomTemp];
	[imgBottomTemp release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTLauncherViewDelegate

- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {

	TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	NSLog(@"%@", [NSString stringWithFormat:@"%@", item.title]);
	if ([item.title compare:@"LinkedIn"] == NSOrderedSame)
	{

	}
	else if ([item.title compare:@"Sign Up"] == NSOrderedSame)
	{
		[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://settings"] applyAnimated:YES]];
//		settings  = [[Settings alloc]init];
//		[self.navigationController pushViewController:settings animated:YES];
	}
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] 
												 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
												 target:_launcherView action:@selector(endEditing)] autorelease] animated:YES];
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
}

@end

