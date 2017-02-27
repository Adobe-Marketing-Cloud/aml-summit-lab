/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2017 Adobe Systems Incorporated
All Rights Reserved.
 
NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import "TransportationModeViewController.h"
#import "AppDelegate.h"
#import "TipDriverViewController.h"
#import "User.h"
#import "Trip.h"
#import "Destination.h"
#import "TransportationMode.h"
#import "TransportationModeView.h"
#import "ADBMobile.h"

@implementation TransportationModeViewController

#pragma mark - UIViewController methods
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	/* Adobe Analytics
	 *
	 * 1. track the user viewing this page
	 */
	[ADBMobile trackState:@"Transportation Mode Select" data:nil];
	
	// update our ui
	[self updateTextForLabels];
    [self createTransportationViews];
}

#pragma mark - UI Helper methods
- (void) updateTextForLabels {
	_lblDestinationName.text = _user.trip.destination.name;
	_lblTravelDistance.text = [NSString stringWithFormat:@"%@ units", _user.trip.distance];
}

- (void) createTransportationViews {
    CGFloat currentY = 140;
    NSDictionary *transporationModes = [AppDelegate transportationModes];
    for (NSString *modeName in [transporationModes allKeys]) {
        TransportationMode *currentMode = transporationModes[modeName];
        
        TransportationModeView *view = [[[NSBundle mainBundle] loadNibNamed:@"TransportationModeView" owner:self options:nil] objectAtIndex:0];
        [view setTransporationMode:currentMode];
        
        // setup click-through to do segue
        [view.btnMode addTarget:self action:@selector(selectTransporationMode:) forControlEvents:UIControlEventTouchUpInside];
        [view setFrame:CGRectMake(0, currentY, self.view.frame.size.width, 100)];
        [self.view addSubview:view];
		
		// update y for next view
		currentY += view.frame.size.height;
    }
}

#pragma mark - Navigation methods
- (void) selectTransporationMode:(id)sender {
	[self performSegueWithIdentifier:@"modeToTravelSegue" sender:sender];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *selectedTransportationMode = button.titleLabel.text;
    
    _user.trip.tranportationMode = [AppDelegate transportationModes][selectedTransportationMode];
        
    TipDriverViewController *tipVC = [segue destinationViewController];
    tipVC.user = _user;
	
	/* Adobe Analytics
	 *
	 * 1. track the selection of the transportation mode
	 */
	[ADBMobile trackAction:@"TransportationSelect" data:@{@"trip.transportationMode":_user.trip.tranportationMode.name}];
}

@end
