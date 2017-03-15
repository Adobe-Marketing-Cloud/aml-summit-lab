/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2017 Adobe Systems Incorporated
All Rights Reserved.
 
NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import "TipDriverViewController.h"
#import "MapViewController.h"
#import "Trip.h"
#import "User.h"
#import "Destination.h"
#import "TransportationMode.h"
#import "ADBMobile.h"
#import "AppDelegate.h"

@implementation TipDriverViewController

#pragma mark - UIViewController methods
- (void) viewWillAppear:(BOOL)animated {
	/* Adobe Analytics
	 *
	 * 1. track the user viewing this page
	 * 2. track the location of the user after they arrive
	 */
	[ADBMobile trackState:@"Tip Driver" data:nil];
	[ADBMobile trackLocation:_user.trip.destination.location data:@{@"summit.year":@"2017"}];
	
	
	// update the labels in our UI
	[self updateTextForLabels];
	
	// change the color of our segment control when a segment is selected
	[self setupTipControl];
}

#pragma mark - UI Helper methods
- (IBAction) setTipAmount:(id)sender {
	UISegmentedControl *segment = (UISegmentedControl *)sender;
	NSString *tipAmount = [segment titleForSegmentAtIndex:segment.selectedSegmentIndex];
	
	/* Adobe Analytics
	 *
	 * 1. track the tip amount selected by the user
	 */
	[ADBMobile trackAction:@"SetTipAmount" data:@{@"tipAmount":tipAmount}];
}

- (void) updateTextForLabels {
	_lblArrived.text = [NSString stringWithFormat:@"Arrived at %@", _user.trip.destination.name];
	_lblCost.text = [NSString stringWithFormat:@"$%.2f", [_user.trip.distance floatValue] * [_user.trip.tranportationMode.costPerUnitTraveled floatValue]];
	_lblTripCompletion.text = [NSString stringWithFormat:@"Thank you for choosing us for your travel needs, %@.  Services will be charged to your credit card (%@).  Would you like to tip your driver?",
							   _user.name, _user.creditCard];
	
}

- (void) setupTipControl {
	NSDictionary *fontAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
	[_segmentTip setTitleTextAttributes:fontAttributes forState:UIControlStateSelected];
}

#pragma mark - Navigation methods
- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	// only allow completion after selecting a tip amount
    return _segmentTip.selectedSegmentIndex >= 0;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// track the completion of our trip
	[self trackTripCompletion];
	
	// update the user's information
    _user.trip.currentLocation = _user.trip.destination;
    _user.trip.destination = nil;
    
    MapViewController *mapVC = [segue destinationViewController];
    mapVC.user = _user;
}

- (void) trackTripCompletion {
	/* Adobe Analytics
	 *
	 * 1. track the completion of the trip with relevant details
	 */
	NSMutableDictionary *tripData = [NSMutableDictionary dictionary];
	tripData[@"user.name"] = _user.name;
	tripData[@"trip.origin"] = _user.trip.currentLocation.name;
	tripData[@"trip.destination"] = _user.trip.destination.name;
	tripData[@"trip.transportationMode"] = _user.trip.tranportationMode.name;
	tripData[@"trip.tipAmount"] = [_segmentTip titleForSegmentAtIndex:_segmentTip.selectedSegmentIndex];
	
	[ADBMobile trackAction:@"Trip Complete" data:tripData];
}

- (IBAction) linkToBeardcons:(id)sender {
	
}

@end
