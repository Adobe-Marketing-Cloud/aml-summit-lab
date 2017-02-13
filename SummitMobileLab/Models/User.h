/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2016 Adobe Systems Incorporated
All Rights Reserved.
 
NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import <Foundation/Foundation.h>

@class Trip;

@interface User : NSObject

@property (strong) NSString *name;
@property (strong) NSString *creditCard;
@property (strong) Trip *trip;

+ (instancetype) userWithName:(NSString *)newName creditCard:(NSString *)newCc;

@end
