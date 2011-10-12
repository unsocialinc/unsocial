//
//  UIDeviceHardware.m
//  Sloppy Border
//
//  Created by santosh khare on 3/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIDeviceHardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDeviceHardware

- (NSString *) platform{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine];
	free(machine);
	return platform;
}

- (NSString *) platformString{
	NSString *platform = [self platform];
	if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
	if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
	if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
	if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
	if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
	if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
	return platform;
}

@end
