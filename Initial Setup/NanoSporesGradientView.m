//
//  NanoSporesGradientView.m
//  NanoSporesiPad
//
//  Created by Brad Larson on 5/1/2010.
//
//  This is a rough port of the Mac sample application NanoSpores ( http://groups.google.com/group/des-moines-cocoaheads/browse_thread/thread/f0fd4863b03793d4?pli=1 ) by Hari Wiguna
//  which was based on Scott Stevenson's NanoLife sample application ( http://theocacao.com/document.page/555/ )

#import "NanoSporesGradientView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NanoSporesGradientView

+ (Class) layerClass 
{
	return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
    }
    return self;
}



@end
