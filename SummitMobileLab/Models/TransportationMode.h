/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2017 Adobe Systems Incorporated
All Rights Reserved.
 
NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import <Foundation/Foundation.h>

@interface TransportationMode : NSObject

@property (strong) NSString *name;
@property (strong) NSString *textDescription;
@property (strong) NSNumber *costPerUnitTraveled;
@property (strong) NSString *imageFile;
@property (strong) NSNumber *duration;

+ (instancetype) transporationModeWithName:(NSString *)newName description:(NSString *)newDescription costPerUnitTraveled:(NSNumber *)newCost image:(NSString *)newImageFile duration:(NSNumber *)newDuration;

@end