/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2017 Adobe Systems Incorporated
All Rights Reserved.
 
NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import "Destination.h"

@implementation Destination

+ (instancetype) destinationWithName:(NSString *)newName destinations:(NSDictionary *)newDestinations lat:(float)newLat lon:(float)newLon mapX:(float)mapX mapY:(float)mapY {
    Destination *destination = [[Destination alloc] init];
    
    destination.name = newName;
    destination.location = [[CLLocation alloc] initWithLatitude:newLat longitude:newLon];
    
    destination.otherDestinations = newDestinations;
	
	destination.mapCoords = CGPointMake(mapX, mapY);
    
    return destination;
}

@end
