//
//  LocationPlaceMark.h
//  Clinics
//
//  Created by Vaibhav Saran on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationPlaceMark : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *nsstrPlacemark;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *nsstrPlacemark;
-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;
- (NSString *)subtitle;
- (NSString *)title;

@end
