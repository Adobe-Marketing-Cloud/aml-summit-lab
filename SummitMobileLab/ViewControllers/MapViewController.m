/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2017 Adobe Systems Incorporated
All Rights Reserved.
 
NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import "MapViewController.h"
#import "TransportationModeViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "Trip.h"
#import "Destination.h"
#import "ADBMobile.h"
#import "AppDelegate.h"

@implementation MapViewController

#pragma mark - UIViewController methods
- (void) viewWillAppear:(BOOL)animated {
	/* Adobe Analytics
	 *
	 * 1. track the user viewing this page
	 */
	[ADBMobile trackState:@"Destination Select" data:nil];
	
    [super viewWillAppear:animated];
    [self setupMapPins];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(checkForSecretOffer:)
												 name:UIApplicationDidBecomeActiveNotification
											   object:nil];
}

#pragma mark - UI Helper methods
- (void) setupMapPins {
    [self setButtonState:_btnLab3882 enabled:![_user.trip.currentLocation.name isEqualToString:@"Lab 3882"]];
    [self setButtonState:_btnLab3881 enabled:![_user.trip.currentLocation.name isEqualToString:@"Lab 3881"]];
    [self setButtonState:_btnRestrooms enabled:![_user.trip.currentLocation.name isEqualToString:@"Restrooms"]];
    [self setButtonState:_btnCasino enabled:![_user.trip.currentLocation.name isEqualToString:@"Casino"]];
    [self setButtonState:_btnBar enabled:![_user.trip.currentLocation.name isEqualToString:@"Bar"]];
	[self setButtonState:_btnSecretLounge enabled:![_user.trip.currentLocation.name isEqualToString:@"Secret Lounge"]];
	
	[self checkForSecretOffer:nil];
}

- (void) setButtonState:(UIButton *)button enabled:(BOOL)enabled {
    [button setBackgroundImage:[UIImage imageNamed:enabled ? @"mapPin.png" : @"mapHere.png"] forState:UIControlStateNormal];
    [button setEnabled:enabled];
}

- (IBAction) setDestination:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (button == _btnLab3882) {
        _user.trip.destination = [AppDelegate destinations][@"Lab 3882"];
    }
    else if (button == _btnLab3881) {
        _user.trip.destination = [AppDelegate destinations][@"Lab 3881"];
    }
    else if (button == _btnRestrooms) {
        _user.trip.destination = [AppDelegate destinations][@"Restrooms"];
    }
    else if (button == _btnCasino) {
        _user.trip.destination = [AppDelegate destinations][@"Casino"];
    }
    else if (button == _btnBar) {
        _user.trip.destination = [AppDelegate destinations][@"Bar"];
    }
	else if (button == _btnSecretLounge) {
		_user.trip.destination = [AppDelegate destinations][@"Secret Lounge"];
	}
	
	[self updateDestinationLabelWithExistingDestination];
}

- (void) updateDestinationLabelWithExistingDestination {
	if (_user.trip.destination) {
		_lblDestination.text = _user.trip.destination.travelText;
	}
}

- (void) checkForSecretOffer:(NSNotification *)notification {
	// only show secret lounge if they opened from a deeplink
	[_btnSecretLounge setHidden:![AppDelegate hasSpecialOffer]];
	
	[self updateDestinationLabelWithExistingDestination];
}

#pragma mark - Navigation methods
- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	// prevent going to next page without selecting a destination
    return _user.trip.destination;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TransportationModeViewController *modeVC = [segue destinationViewController];
    modeVC.user = self.user;
}

@end
