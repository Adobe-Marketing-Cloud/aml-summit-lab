/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2017 Adobe Systems Incorporated
All Rights Reserved.
 
NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "User.h"
#import "Trip.h"
#import "ADBMobile.h"

static NSString *const SummitInitialLocationName	= @"Lab 3882";

@implementation ProfileViewController

#pragma mark - UIViewController methods
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	/* Adobe Analytics
	 *
	 * 1. track the user viewing this page
	 */
    [ADBMobile trackState:@"User Profile" data:nil];
}

#pragma mark - UI Helper methods
- (void) showMissingInfoAlert {
	// show an alert view requesting all fields be filled in
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Missing Information" message:@"Please fill out all required fields before beginning your trip!" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:cancelAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Navigation methods
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// create our user
	User *user = [User userWithName:_txtName.text creditCard:_txtCreditCard.text];
	
	/* Adobe Analytics
	 *
	 * 1. track our new user "logging in"
	 */
	[ADBMobile trackAction:@"User Login" data:@{@"user.name":user.name, @"user.fakeCreditCard":user.creditCard}];
	
	
	// send our user object to the next screen
	MapViewController *mapVC = [segue destinationViewController];
	mapVC.user = user;
	
	// initialize the trip starting with location of Lab 3882
	Trip *trip = [[Trip alloc] init];
	trip.currentLocation = [AppDelegate destinations][SummitInitialLocationName];
	mapVC.user.trip = trip;
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	// verify that there are values for both name and credit card fields before proceeding
    if (!_txtCreditCard.text.length || !_txtName.text.length) {
        [self showMissingInfoAlert];
        return NO;
    }
    return YES;
}

@end
