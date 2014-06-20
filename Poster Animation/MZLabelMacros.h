//
//  MZLabelMacros.h
//  Mozart
//
//  Created by John Basile on 5/4/14.
//  CopyriMZt (c) 2014 Needly. All riMZts reserved.
//

// ************************ LABELS
// **** LEGEND *******
// AB - AVENIR BLACK
// AM - AVENIR MEDIUM
// AR - AVENIR ROMAN
// AH - AVENIR HEAVY
// AN - AVENIR NEXT


typedef enum  {
    kMZLabelShadow75_2_120 = 1,
    kMZLabelShadow50_2_120 = 2,
    kMZLabelShadow85_2_120 = 3,
    kMZLabelShadow75_2_90  = 4,
    kMZLabelShadow50_2_90 = 5,
    kMZLabelShadow85_2_90 = 6,
    kMZLabelShadow70_4_90 = 7,
    kMZLabelShadow70_2_90 = 8
} kMZLabelType;

#define kMZStyleForLabels @"labels"

#define getTextColorForLabel(label) [UIColor colorWithHexString:[MZStyleManager getTextColorForLabelType:label]]

#define getTextSizeForLabel(label) [MZStyleManager getTextSizeForLabelType:label]

#define getBackgroundColorForLabel(label) [UIColor colorWithHexString:[MZStyleManager getBackgroundColorForLabelType:label]]

#define getFontTypeForLabel(label) [MZStyleManager getFontTypeLabelType:label]