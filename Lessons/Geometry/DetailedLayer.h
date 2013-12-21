//
//  SimpleLayer.h
//  WorkBench
//
//  Created by John Basile on 1/9/11.
//  Copyright 2011 Numerics. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@interface DetailedLayer : CALayer 
{
	BOOL	showAnchor;
	BOOL	smallAnchor;
	BOOL	brownAnchor;
}
@property (nonatomic, getter=showAnchor) BOOL showAnchor;
@property (nonatomic, getter=smallAnchor) BOOL smallAnchor;
@property (nonatomic, getter=brownAnchor) BOOL brownAnchor;

@end
