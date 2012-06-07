//
//  CustomButton.h
//  GlossyButtonTest
//
//  Created by Dmitry Suhorukov on 11/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAGradientLayer;

typedef enum
{
    ROUNDED_BORDERED,
    ROUNDED_UNBORDERED,
    SQUARE_BORDERED,
    SQUARE_UNBORDERED
} GRADIENT_BUTTON_TYPE;

@interface iGoGradientButton : UIButton {
@private
	UIColor* _gradientStartColor;
	UIColor* _gradientEndColor;
	
	CAGradientLayer* _gradientLayer;
	CAGradientLayer* _glossyLayer;
}
@property (assign) GRADIENT_BUTTON_TYPE type;
@property (nonatomic, retain) UIColor* gradientStartColor;
@property (nonatomic, retain) UIColor* gradientEndColor;

@end
