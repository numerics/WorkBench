//
//  CKCustomActivityIndicator.m
//  Mozart
//
//  Created by John Basile on 4/28/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//

#import "CKCustomActivityIndicator.h"

#pragma mark - CKGlobalActivityIndicator

@implementation MZGlobalActivityIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.tag = 1000;
    }
    return self;
}


static CKCustomActivityIndicator *_activityViewIndicator;
static UIView *_overlayView;
static UIView *_containerView;
static int _showCount = 0;

+(void)setContainer:(UIView *)containerView
{
    if(_containerView != nil)
    {
        [MZGlobalActivityIndicator removeViewsFromContainer:_containerView];
    }
    
    _containerView = containerView;
    
    _containerView.userInteractionEnabled = NO;
    _showCount = 0;
}

+(void)showProcessingLabel:(NSString *)label
{
    [_activityViewIndicator.processingLabel setHidden:NO];
    _activityViewIndicator.processingLabel.text = label;
    [_activityViewIndicator setNeedsDisplay];
}

+(CKCustomActivityIndicator *) createCustomActivityIndicator
{
    return [[CKCustomActivityIndicator alloc] initWithActivityIndicatorType:MZCustomActivityIndicatorTypeLarge];
}

+(void)addViewsToContainer:(UIView *)containerView
{
    if(_overlayView == nil)
    {
        _overlayView = [[UIView alloc] init];
        _overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    if(_activityViewIndicator == nil)
    {
        _activityViewIndicator = [MZGlobalActivityIndicator createCustomActivityIndicator];
    }
    
    [containerView addSubview:_overlayView];
    [containerView addSubview:_activityViewIndicator];
    
    _overlayView.frame = containerView.bounds;
    
    _overlayView.hidden = YES;
    
    _activityViewIndicator.center = containerView.center;
    _activityViewIndicator.hidden = YES;
}

+(void)removeViewsFromContainer:(UIView *)containerView
{
    [_overlayView removeFromSuperview];
    
    [_activityViewIndicator stopAnimating];
    [_activityViewIndicator removeFromSuperview];
    
}

+(void)show
{
    [_activityViewIndicator.processingLabel setHidden:YES];
    [_activityViewIndicator setNeedsDisplay];
    [MZGlobalActivityIndicator showAnimated:NO];
}

+(void)showAnimated:(BOOL)animated
{
    if(_containerView == nil)
        return;
	
    [MZGlobalActivityIndicator addViewsToContainer:_containerView];
    [_activityViewIndicator.processingLabel setHidden:YES];
    [_activityViewIndicator setNeedsDisplay];
    
    NSLog(@"[CKGlobalActivityIndicator:showAnimated] Showing indicator. Count %d->%d", _showCount, (_showCount + 1));
    
    if(_showCount == 0)
    {
        _overlayView.hidden = NO;
        
        _overlayView.center = _activityViewIndicator.center = _containerView.center;
        
        _activityViewIndicator.hidden = NO;
        [_activityViewIndicator startAnimating];
        
        void (^animationBlock)(void) = ^
        {
            _overlayView.alpha = 1;
            _activityViewIndicator.alpha = 1;
            [_activityViewIndicator scale:1.0];
        };
        
        if(animated)
        {
            _overlayView.alpha = 0;
            _activityViewIndicator.alpha = 0;
            [_activityViewIndicator scale:0.8];
            
            [UIView animateWithDuration:0.3 animations:animationBlock];
        }
        else
        {
            animationBlock();
        }
        
    }
    
    _showCount++;
}

- (void) dealloc {
    _activityViewIndicator = nil;
    _overlayView = nil;
    _containerView = nil;
}

+(void)hide
{
    [MZGlobalActivityIndicator hideAnimated:NO];
}

+(void)hideAnimated:(BOOL)animated
{
    if(_containerView == nil)
        return;
    [_activityViewIndicator.processingLabel setHidden:YES];
    [_activityViewIndicator setNeedsDisplay];
    NSLog(@"[CKGlobalActivityIndicator:hideAnimated] Hiding indicator. Count %d->%d ", _showCount, (_showCount - 1));
    
    if (_showCount - 1 <= 0)
    {
        void (^completionBlock)(BOOL) = ^(BOOL finished)
        {
            _overlayView.hidden = YES;
            
            [_activityViewIndicator stopAnimating];
            _activityViewIndicator.hidden = YES;
            
            _containerView.userInteractionEnabled = NO;
            
            _showCount = 0;
        };
        
        
        if(animated)
        {
            [UIView animateWithDuration:0.3 animations:^{
                _overlayView.alpha = 0;
                _activityViewIndicator.alpha = 0;
                [_activityViewIndicator scale:0.8];
            } completion:completionBlock];
        }
        else
        {
            completionBlock(YES);
        }
    }
    
    _showCount = MAX(0, _showCount - 1);
}

@end
#pragma mark - CKCustomActivityIndicator

//////// ******* CKCustomActivityIndicator ******** ////////////

@interface CKCustomActivityIndicator ()

@property (nonatomic, strong) UIImageView *spinnerImageView;

@end

@implementation CKCustomActivityIndicator


- (id) initWithActivityIndicatorType:(MZCustomActivityIndicatorType) type
{
    if (type == MZCustomActivityIndicatorTypeLarge)
	{
        self = [super initWithFrame:CGRectMake(0, 0, 130, 130)];
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.center = self.center;
        [self addSubview: self.activityIndicator];
     }
    else
	{
        self = [super initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityIndicator.center = self.center;
        [self addSubview: self.activityIndicator];
    }

    return self;
}

- (void) startAnimating
{
    [self.activityIndicator startAnimating];
}

- (void) stopAnimating
{
    [self.activityIndicator stopAnimating];
}

- (void) dealloc
{
    self.spinnerImageView = nil;
    self.labelText = nil;
    self.isAnimating = NO;
    self.processingLabel = nil;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.processingLabel.center = self.spinnerImageView.center;
    self.processingLabel.top = self.spinnerImageView.bottom + 20;
}

@end
