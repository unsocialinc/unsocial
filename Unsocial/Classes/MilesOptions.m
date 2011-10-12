//
//  MilesOptions.m
//  Unsocial
//
//  Created by vaibhavsaran on 14/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MilesOptions.h"
#import"GlobalVariables.h"
#import "UnsocialAppDelegate.h"
#import "ShowUnsocialMilesTips.h"

@implementation MilesOptions
@synthesize comingfrom;

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// for disappearing activityvew at the header
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityView stopAnimating];
	activityView.hidden = YES;
	[self createControls];
}

- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"VC view will appear");
	UIColor *color = [UIColor blackColor];
	UINavigationBar *bar = [self.navigationController navigationBar];
	[bar setBarStyle:(UIBarStyleDefault)];
	[bar setTintColor:color];
	
	//add background color
	self.view.backgroundColor = color;
	
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 33, 30)];
	[leftbtn setImage:[UIImage imageNamed:@"9dots.png"] forState:(UIControlState) nil];
	[leftbtn addTarget:self action:@selector(leftbtn_OnClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftcbtnitme = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
	
	if(comingfrom == 0) {
		self.navigationItem.leftBarButtonItem = leftcbtnitme;
	}
	else {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	}
	
	imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	imgBack.image = [UIImage imageNamed:@"mainbackground.png"];	
	[self.view addSubview:imgBack];
	
	UILabel *heading = [UnsocialAppDelegate createLabelControl:@"unsocial Miles" frame:CGRectMake(15, 0, 290, 43) txtAlignment:UITextAlignmentLeft numberoflines:1 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppMainHeadingFontSize txtcolor:[UIColor orangeColor] backgroundcolor:[UIColor clearColor]];
	[self.view addSubview:heading];
	// 13 may 2011 by pradeep //[heading release];
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(5, 40, 310, 2) imageName:@"dashboardhorizontal.png"];
	[self.view addSubview:imgHorSep];
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	// end 3 august 2011 for fixing memory issue
	
	loading = [UnsocialAppDelegate createLabelControl:@"Saving\nplease standby" frame:CGRectMake(25, 125, 280, 60) txtAlignment:UITextAlignmentCenter numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kLoadingFont txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	
	activityView = [UnsocialAppDelegate createActivityView:CGRectMake(150, 180, 20, 20) activityViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityView];
	[activityView startAnimating];
}

- (void)createControls {
	
	NSMutableDictionary *item1, *item2;
	item1 = [self setOptions:@"Learn how to earn miles" index:0];
	item2 = [self setOptions:@"Your unsocial miles" index:1];
	
	items = [[NSMutableArray alloc] initWithObjects:item1, item2, nil];
	
	itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, 480) style:UITableViewStylePlain];
	itemTableView.delegate = self;
	itemTableView.dataSource = self;
	itemTableView.rowHeight = 70;
	itemTableView.backgroundColor = [UIColor clearColor];
	itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:itemTableView];	
}

- (NSMutableDictionary *) setOptions:(NSString *)itemName index: (int) i {
	NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
	[item setObject:itemName forKey:@"Name"];
	return item;
}

- (void)leftbtn_OnClick{
	
	[lastVisitedFeature removeAllObjects];
	[lastVisitedFeature addObject:@"milesoptions"];
	
	if(comingfrom != 1)
		[self dismissModalViewControllerAnimated:YES];
	else {
		
		[self.navigationController popViewControllerAnimated:YES];
		comingfrom = 0;
	}
}

- (void)btnTips_Click {
	
	TTNavigator* navigator = [TTNavigator navigator];
	//navigator.delegate = self;
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	TTURLMap* map = navigator.URLMap;
	[map from:@"tt://pkTest" toModalViewController:[ShowUnsocialMilesTips class]transition:0];
	[navigator openURLAction:[[TTURLAction actionWithURLPath:@"tt://pkTest"] applyAnimated:YES]];
	
	/*ShowTips *showTips = [[ShowTips alloc]init];
	[self.navigationController presentModalViewController:showTips animated:YES];
	[showTips release];*/
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
	// Set up the cell
	UILabel *lblOptions = [UnsocialAppDelegate createLabelControl:[[items objectAtIndex: indexPath.row] objectForKey: @"Name"] frame:CGRectMake(25, 0.00, 290, itemTableView.rowHeight) txtAlignment:UITextAlignmentLeft numberoflines:2 linebreakmode:UILineBreakModeWordWrap fontwithname:kAppFontName fontsize:kAppTBFontSize txtcolor:[UIColor whiteColor] backgroundcolor:[UIColor clearColor]];
	[cell.contentView addSubview:lblOptions];
	// 13 may 2011 by pradeep //[lblOptions release];
	
	UIImageView *imgHorSep = [UnsocialAppDelegate createImageViewControl:CGRectMake(5, itemTableView.rowHeight - 2, 310, 2) imageName:@"dashboardhorizontal.png"];
		[cell.contentView addSubview:imgHorSep];
	
	UIImageView *imgDisclouser = [UnsocialAppDelegate createImageViewControl:CGRectMake(300, (itemTableView.rowHeight - 36)/2, 18, 36) imageName:@"disclouser.png"];
	[cell.contentView addSubview:imgDisclouser];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	[activityView stopAnimating];
	activityView.hidden = YES;
	// commented by pradeep on 3 august 2011 for fixing memory issue using auto release method
	//[imgHorSep release];
	//[imgDisclouser release];
	// end 3 august 2011 for fixing memory issue
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	ShowUnsocialMilesTips *viewcontroller = [[ShowUnsocialMilesTips alloc]init]; // security
	viewcontroller.selectedoption = [NSString stringWithFormat:@"%i", indexPath.row];
	[self.navigationController pushViewController:viewcontroller animated:YES];
	[viewcontroller release];
	
	}

/*- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCellAccessoryType uITableViewCellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return uITableViewCellAccessoryType;
}*/

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
