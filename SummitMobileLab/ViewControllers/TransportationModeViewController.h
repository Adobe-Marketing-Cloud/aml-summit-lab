/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2016 Adobe Systems Incorporated
All Rights Reserved.
 
NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import <UIKit/UIKit.h>

@class User;

@interface TransportationModeViewController : UIViewController

@property (strong) User *user;

@property (assign) IBOutlet UILabel *lblDestinationName;
@property (assign) IBOutlet UILabel *lblTravelDistance;
@property (assign) IBOutlet UILabel *lblHeading;

@end
