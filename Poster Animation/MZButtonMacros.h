//
//  MZButtonMacros.h
//  Mozart
//
//  Created by John Basile on 5/4/14.
//  CopyriMZt (c) 2014 Needly. All riMZts reserved.
//


// ************************ BUTTONS

typedef enum  {
    kMZButtonTypeOrangeRnd = 1,			// Orange-flat Button, on Table Headers, ()
    kMZButtonTypeHdrSwitch = 2,			// Table Header Switch Button, ()
    kMZButtonTypeC = 3,
    kMZButtonTypeOrangeSign = 4,		// Login Style Orange Button
    kMZButtonTypeClearSign = 5,			// Login Style Clear Button
    kMZButtonTypeCellArrow = 6,			// Table Cell complex (4 stage) gradient
    kMZButtonTypeCellBtn = 7,			// Table Cell round button, orange/white, gradient, (Contacts screen) - uses gradient Line for Plus Symbol
    kMZButtonTypeBlueRnd = 8,
} kMZButtonType;

#define kMZStyleForButtons @"buttons"

#define getTextColorForButton(button) [UIColor colorWithHexString:[MZStyleManager \
getTextColorForButtonType:button]]

#define getTextSizeForButton(button) [MZStyleManager \
getTextSizeForButtonType:button] 

#define getBackgroundColorForButton(button) [UIColor colorWithHexString:[MZStyleManager \
getBackgroundColorForButtonType:button]]

#define getFontTypeForButton(button) [MZStyleManager \
getFontTypeForButtonType:button]

#define getBorderColorForButton(button) [UIColor colorWithHexString:[MZStyleManager \
getBorderColorForButtonType:button]]

#define getTextAlignmentForButton(button) [MZStyleManager \
getTextAlignmentForButtonType:button]