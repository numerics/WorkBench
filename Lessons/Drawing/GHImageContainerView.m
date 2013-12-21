//
//  GHImageContainerView.m
//  WorkBench
//
//  Created by Basile, John on 8/16/13.
//
//

#import "GHImageContainerView.h"

@implementation GHImageContainerView
@synthesize containedImage,maskLayer,imageLayer;

+ (NSString *)className
{
	return @"GHImageContainerView";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpView:frame];
    }
    return self;
}

- (void)setUpView:(CGRect)rect
{
    CGFloat left = rect.origin.x;
    CGFloat right = rect.origin.x + rect.size.width;
    CGFloat top = rect.origin.y;
    CGFloat bottom = rect.origin.y + rect.size.height;

//    CGFloat left = 0.0;
//    CGFloat right = 290;
//    CGFloat top = 0.0;
//    CGFloat bottom = 125.0;
    
	CGFloat topLeftEdgeInset = 10.0;
    CGFloat topRightEdgeInset = 10.0, bottomLeftEdgeInset = 10.0, bottomRightEdgeInset = 10.0;
    
	imageLayer = [CALayer layer];
	[self.layer addSublayer:imageLayer];
    
	maskLayer = [CAShapeLayer layer];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint   (path, NULL, left  + topLeftEdgeInset,top           );
    CGPathAddLineToPoint(path, NULL, right - topRightEdgeInset,top          );
    CGPathAddLineToPoint(path, NULL, right,  top + topRightEdgeInset        );
    CGPathAddLineToPoint(path, NULL, right,  bottom - bottomRightEdgeInset  );
    CGPathAddLineToPoint(path, NULL, right - bottomRightEdgeInset , bottom  );
    CGPathAddLineToPoint(path, NULL, left  + bottomLeftEdgeInset , bottom   );
    CGPathAddLineToPoint(path, NULL, left ,  bottom - bottomLeftEdgeInset   );
    CGPathAddLineToPoint(path, NULL, left,   top + topLeftEdgeInset         );
    CGPathCloseSubpath(path);
    
    
    maskLayer.path = path;
    imageLayer.masksToBounds = YES;
	imageLayer.backgroundColor = [[UIColor greenColor] CGColor];
	imageLayer.bounds = CGRectMake(0., 0., 290  , 125);
	imageLayer.position = self.center;
	[imageLayer setNeedsDisplay];
	imageLayer.mask  = maskLayer;
 	imageLayer.contents = (id)[[UIImage imageNamed:@"Ben"] CGImage];
    
}

@end
