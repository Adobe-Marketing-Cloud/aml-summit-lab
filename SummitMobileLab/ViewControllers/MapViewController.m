/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2016 Adobe Systems Incorporated
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
}

#pragma mark - UI Helper methods
- (void) setupMapPins {
    [self setButtonState:_btnLab329 enabled:![_user.trip.currentLocation.name isEqualToString:@"Lab 329"]];
    [self setButtonState:_btnLab330 enabled:![_user.trip.currentLocation.name isEqualToString:@"Lab 330"]];
    [self setButtonState:_btnRestrooms enabled:![_user.trip.currentLocation.name isEqualToString:@"Restrooms"]];
    [self setButtonState:_btnCasino enabled:![_user.trip.currentLocation.name isEqualToString:@"Casino"]];
    [self setButtonState:_btnBar enabled:![_user.trip.currentLocation.name isEqualToString:@"Bar"]];
}

- (void) setButtonState:(UIButton *)button enabled:(BOOL)enabled {
    [button setBackgroundImage:[UIImage imageNamed:enabled ? @"mapPin.png" : @"mapHere.png"] forState:UIControlStateNormal];
    [button setEnabled:enabled];
}

- (IBAction) setDestination:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (button == _btnLab329) {
        _user.trip.destination = [AppDelegate destinations][@"Lab 329"];
        _lblDestination.text = @"Take me to Lab 329";
    }
    else if (button == _btnLab330) {
        _user.trip.destination = [AppDelegate destinations][@"Lab 330"];
        _lblDestination.text = @"Take me to Lab 330";
    }
    else if (button == _btnRestrooms) {
        _user.trip.destination = [AppDelegate destinations][@"Restrooms"];
        _lblDestination.text = @"Take me to the restrooms";
    }
    else if (button == _btnCasino) {
        _user.trip.destination = [AppDelegate destinations][@"Casino"];
        _lblDestination.text = @"Take me to the casino";
    }
    else if (button == _btnBar) {
        _user.trip.destination = [AppDelegate destinations][@"Bar"];
        _lblDestination.text = @"Take me to the bar";
    }
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
