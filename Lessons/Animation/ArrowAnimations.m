//
//  ArrowAnimations.m
//  WorkBench
//
//  Created by John Basile on 4/30/15.
//
//

#import "ArrowAnimations.h"
#import "Arrow.h"

@interface ArrowAnimations ()
@property (nonatomic,strong) Arrow *arrow;
@property (nonatomic, assign) CGMutablePathRef pathNoAnimation;
@property (nonatomic, assign) CGMutablePathRef pathAnimated;
@end

@implementation ArrowAnimations

+ (NSString *)className
{
    return @"Arrow Animation";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpView];
    }
    return self;
}

#pragma mark Setup the View

- (void)setUpView
{
    self.backgroundColor = [UIColor grayColor];
    self.arrow = [[Arrow alloc]init];
    self.arrow.tail = CGPointMake(200, 100);
    self.arrow.head = CGPointMake(200, 400);
    self.arrow.curved = NO;
    self.arrow.direction = ArrowDirectionTH;
    
    [self addArrow:self.arrow];

    
}
- (void)addArrow:(Arrow *)arrow
{
    [self generatePath:arrow];
    [self setNeedsDisplay];
}

- (void)generatePath:(Arrow *)arrow
{
    CGMutablePathRef pAnimated = CGPathCreateMutable();
    CGPathAddPath(pAnimated, nil, arrow.path);
    CGPathRelease(self.pathAnimated);
    self.pathAnimated = pAnimated;
    [self drawPath];
}

- (void)drawPath
{
    if (!self.arrow)
    {
        return;
    };
    //Remove old layers
    for(CALayer *layer in self.layer.sublayers)
        if([layer isMemberOfClass:[CAShapeLayer class]])
            [layer removeFromSuperlayer];
    
    bool drawAnimatedPath = true;
    
    if (drawAnimatedPath)
    {
        /*
         * Animated Arrows
         */
        
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.bounds;
        pathLayer.path = self.pathAnimated;
        pathLayer.strokeColor = ARROW_COLOR;
        pathLayer.fillColor = nil;
        pathLayer.drawsAsynchronously = DRAWS_ASYNC;
        pathLayer.lineWidth = LINE_WIDTH;
        pathLayer.lineJoin = kCALineJoinBevel;
        [self.layer addSublayer:pathLayer];
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = DRAW_ANIMATION_SPEED;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        
    }
    

    
}
@end
