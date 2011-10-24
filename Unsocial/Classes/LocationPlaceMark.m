//
//  LocationPlaceMark.m
//  Clinics
//
//  Created by Vaibhav Saran on 12/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocationPlaceMark.h"

@implementation LocationPlaceMark
@synthesize coordinate, nsstrPlacemark;

- (NSString *)subtitle
{
	return @"Restaurant";
}
- (NSString *)title{
	return nsstrPlacemark;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}
@end