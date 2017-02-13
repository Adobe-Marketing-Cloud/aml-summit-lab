/*************************************************************************
 
ADOBE SYSTEMS INCORPORATED
Copyright 2016 Adobe Systems Incorporated
All Rights Reserved.
 
NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
 
**************************************************************************/

#import "TransportationModeView.h"
#import "TransportationMode.h"

@implementation TransportationModeView

- (void) setTransporationMode:(TransportationMode *)transporationMode {
    _transporationMode = transporationMode;
    
    _lblTitle.text = _transporationMode.name;
    _lblDescription.text = _transporationMode.textDescription;
    _lblCost.text = [NSString stringWithFormat:@"$%.2f/unit", [_transporationMode.costPerUnitTraveled doubleValue]];
    _btnMode.titleLabel.text = _transporationMode.name;
    
    _imgPrettyPicture.image = [UIImage imageNamed:_transporationMode.imageFile];
}

@end