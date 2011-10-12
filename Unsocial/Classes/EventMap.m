//
//  EventMap.m
//  Unsocial
//
//  Created by vaibhavsaran on 29/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventMap.h"
#import "LocationPlaceMark.h"
#import <MapKit/MapKit.h>

@implementation EventMap
@synthesize getLatitude, getLongitude, nsstrPlacemark;
@synthesize coordinate, eventaddress;
@synthesize activityView;

- (void)createDesignView
{
	//add background color
	UIColor *bkcolor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"mainbackground.png"]];
	self.view.backgroundColor = bkcolor;
	
	//Top Image
	UIImage *imgHead = [UIImage imageNamed: @"headlogo.png"];
	UIImageView *imgHeadview = [[UIImageView alloc] initWithImage: imgHead];
	UINavigationItem *itemNV = self.navigationItem;
	itemNV.titleView = imgHeadview;
	[self.navigationItem setTitleView:imgHeadview];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(leftbtn_OnClick)] autorelease];
	
	mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	mapView.showsUserLocation=TRUE;
	mapView.mapType=MKMapTypeStandard;
	mapView.delegate=self;
	mapView.showsUserLocation = FALSE;
	
	/*Region and Zoom*/
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.5;
	span.longitudeDelta=0.5;
	
	CLLocationCoordinate2D location=mapView.userLocation.coordinate;
	
	location.latitude =  [getLatitude floatValue]; //29.70114;//	47.70871
	location.longitude = [getLongitude floatValue]; //-95.40896;// -122.19053
	region.span=span;
	region.center=location;
	
	/*Geocoder Stuff*/
	
	LocationPlaceMark *placemark=[[LocationPlaceMark alloc] initWithCoordinate:location];
	placemark.nsstrPlacemark = eventaddress;
	[mapView addAnnotation:placemark];
	
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	[self.view insertSubview:mapView atIndex:0];
}

- (void)showRoute_Click
{
	[self alertSimpleAction:@"This will close the Application.":@"Are you sure you want to continue?"];
}

- (void)alertSimpleAction:(NSString *)alertMsg:(NSString *)instrc
{
	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertMsg message:instrc delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
	}
	else
	{
		// Create your query ...
		// Be careful to always URL encode things like spaces and other symbols that aren't URL friendly
		NSString *searchQuery =  [@"7401 South Main Street, Houston, Texas, 77030" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
		// Now create the URL string ...
		NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", searchQuery];
		// An the final magic ... openURL!
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
	}
}

- (void)backButton_OnClick
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
	[self displayAnimation];
}

# pragma mark displayAnimation
- (void) viewDidAppear:(BOOL)animated
{
	// for disappearing activityvew at the header
	[activityView stopAnimating];	
	[super viewDidAppear:animated];
	activityView.hidden = YES;
	[self createDesignView];
}

- (void) displayAnimation
{
	activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 260,18,18)];
	activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	
	[self.view addSubview:activityView];
	[activityView startAnimating];	
}

- (void) leftbtn_OnClick{
	
	[self.navigationController popViewControllerAnimated:YES];//s pushViewController:bdc animated:YES];
}

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
	// added by pradeep on 29 june 2011
	//mapView.delegate = nil;
	// end 29 june 2011
	
    [super dealloc];
}

- (IBAction)changeType:(id)sender{
	if(mapType.selectedSegmentIndex==0){
		mapView.mapType=MKMapTypeStandard;
	}
	else if (mapType.selectedSegmentIndex==1){
		mapView.mapType=MKMapTypeSatellite;
	}
	else if (mapType.selectedSegmentIndex==2){
		mapView.mapType=MKMapTypeHybrid;
	}
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	NSLog(@"Reverse Geocoder Errored");
	
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	NSLog(@"Reverse Geocoder completed");
	mPlacemark=placemark;
	[mapView addAnnotation:placemark];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	if ([[annotation title] compare:nsstrPlacemark] == NSOrderedSame)
	{
		annView.canShowCallout = YES;
		annView.animatesDrop=TRUE;
	}
	return annView;
}

@end
