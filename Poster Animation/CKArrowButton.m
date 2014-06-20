//
//  CKArrowButton.m
//  Mozart
//
//  Created by John Basile on 4/29/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "CKArrowButton.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat angles[4] = {0.0f, 90.0f, 180.0f, 270.0f};

@interface CKArrowButton()
{
    CAShapeLayer *_arrowShape;
}

@end

@implementation CKArrowButton


-(id)initWithFrame:(CGRect)frame andTouchCallback:(void (^)(void))touchCallback
{
    if(self = [super initWithFrame:frame andTouchCallback:touchCallback])
    {
        self.backgroundColor = [UIColor clearColor];
        
        _normalColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        _highlightedColor = [UIColor colorWithHexString:@"DCBE0E"];
        _direction = CKArrowButtonDirectionRight;
        
        _arrowShape = [[CAShapeLayer alloc] init];
        _arrowShape.path =  [self createPath];
        _arrowShape.fillColor = _normalColor.CGColor;
        [self.layer addSublayer:_arrowShape];
        
        [self addTarget:self action:@selector(onTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(onTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(onTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    }
    
    return self;
}

-(void) setDirection:(CKArrowButtonDirection)direction
{
    _direction = direction;
    _arrowShape.path = [self createPath];
}

-(CGPathRef)createPath
{
    return [self createPathRotatedAroundBoundingBoxCenter:[self chevronWithRect:self.bounds] withAngle:angles[_direction]];
}

-(void)onTouchDown
{
    _arrowShape.fillColor = _highlightedColor.CGColor;
}

-(void)onTouchUp
{
    _arrowShape.fillColor = _normalColor.CGColor;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (self.highlighted)
    {
        _arrowShape.fillColor = _highlightedColor.CGColor;
    }
    else
    {
        _arrowShape.fillColor = _normalColor.CGColor;
    }
}

-(CGPathRef) chevronWithRect:(CGRect)chevRect
{
    CGMutablePathRef path = CGPathCreateMutable();
    const CGFloat x = 0;
	const CGFloat y = 0;
    const CGFloat w = CGRectGetWidth(chevRect);
    const CGFloat h = CGRectGetHeight(chevRect);
    
    const CGFloat w_third = w / 2;
    const CGFloat h_half = h / 2;
	
    CGPathMoveToPoint(path, NULL, x, y);
    CGPathAddLineToPoint(path, NULL, x + w_third, y);
    CGPathAddLineToPoint(path, NULL, w, y + h_half);
    CGPathAddLineToPoint(path, NULL, x + w_third, y + h);
    CGPathAddLineToPoint(path, NULL, x, y + h);
    CGPathAddLineToPoint(path, NULL, x + w_third, y + h_half);
    CGPathCloseSubpath(path);
    

    return CGPathCreateCopy(path);
}

-(CGPathRef) createPathRotatedAroundBoundingBoxCenter:(CGPathRef) path withAngle:(CGFloat)degrees
{
    CGFloat rads = degrees * M_PI / 180.0f;
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, center.x, center.y);
    transform = CGAffineTransformRotate(transform, rads);
    transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
    return CGPathCreateCopyByTransformingPath(path, &transform);
}


@end
