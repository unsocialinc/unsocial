//
//  EventMap.h
//  Unsocial
//
//  Created by vaibhavsaran on 29/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EventMap : UIViewController <MKReverseGeocoderDelegate,MKMapViewDelegate, MKAnnotation> {

	NSString *eventaddress;
	MKMapView *mapView;
	MKReverseGeocoder *geoCoder;
	MKPlacemark *mPlacemark;
	NSString *getLongitude, *getLatitude, *nsstrPlacemark;
	CLLocationCoordinate2D coordinate;
	IBOutlet UISegmentedControl *mapType;
	UIActivityIndicatorView *activityView;
}
- (void)alertSimpleAction:(NSString *)alertMsg:(NSString *)instrc;
-(void)createDesignView;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain)NSString *getLongitude, *getLatitude, *nsstrPlacemark, *eventaddress;
- (void) displayAnimation;
@property (nonatomic, retain)UIActivityIndicatorView *activityView;
@end
