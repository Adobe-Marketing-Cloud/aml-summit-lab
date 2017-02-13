/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2016 Adobe Systems Incorporated
All Rights Reserved.
 
NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import "TravelViewController.h"
#import "TipDriverViewController.h"
#import "User.h"
#import "Trip.h"
#import "Destination.h"
#import "TransportationMode.h"
#import "ADBMobile.h"

@implementation TravelViewController

#pragma mark - UIViewController methods
- (void) viewDidAppear:(BOOL)animated {
	[self updateTransporationImage];
	[self performAnimations];
}

#pragma mark - UI Helper methods
- (void) updateTransporationImage {
	// set the appropriate image
	_transportationImage.image = [UIImage imageNamed:_user.trip.tranportationMode.imageFile];
	
	// move the image to the correct starting location
	[_transportationImage setFrame:CGRectMake(_user.trip.currentLocation.mapCoords.x, _user.trip.currentLocation.mapCoords.y, _transportationImage.frame.size.width, _transportationImage.frame.size.height)];
}

- (void) performAnimations {
	// animate moving the image to the destination
	[UIView animateWithDuration:[_user.trip.tranportationMode.duration floatValue] animations:^{
		[_transportationImage setFrame:CGRectMake(_user.trip.destination.mapCoords.x, _user.trip.destination.mapCoords.y, _transportationImage.frame.size.width, _transportationImage.frame.size.height)];
	} completion:^(BOOL finished) {
		[self navigateToTipViewController];
	}];
}

#pragma mark - Navigation methods
- (void) navigateToTipViewController {
	[self performSegueWithIdentifier:@"travelToTipSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	TipDriverViewController *tipVC = [segue destinationViewController];
	tipVC.user = _user;
}

@end