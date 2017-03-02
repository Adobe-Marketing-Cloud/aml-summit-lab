/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2017 Adobe Systems Incorporated
All Rights Reserved.
 
NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import "TransportationMode.h"

@implementation TransportationMode

+ (instancetype) transporationModeWithName:(NSString *)newName description:(NSString *)newDescription costPerUnitTraveled:(NSNumber *)newCost image:(NSString *)newImageFile duration:(NSNumber *)newDuration {
    TransportationMode *transportationMode = [[TransportationMode alloc] init];
    
    transportationMode.name = newName;
    transportationMode.textDescription = newDescription;
    transportationMode.costPerUnitTraveled = newCost;
    transportationMode.imageFile = newImageFile;
	transportationMode.duration = newDuration;
    
    return transportationMode;
}

@end
