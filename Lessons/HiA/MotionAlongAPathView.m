//
// File:       MotionAlongAPathViewController.m
//
// Abstract:   We'll animate the blue rectangle (_thumbnail) in this UIViewController subclass
//
// Version:    1.0


#import "MotionAlongAPathView.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"

#define PICTURE_X 160
#define PICTURE_Y 210

#define TRASH_X 620
#define TRASH_Y 500

@implementation MotionAlongAPathView
@synthesize drawPath;

+ (NSString *)className 
{
	return @"Motion Along A PathView";
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

- (void)thumbnailPressed:(id)sender
{
     
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, PICTURE_X, PICTURE_Y);
    CGPathAddQuadCurveToPoint(path, NULL, TRASH_X, PICTURE_Y, TRASH_X, TRASH_Y);
    
    if (pathSwitch.on )				// Uncomment this to draw the path the thumbnail will fallow
		[self setPath:path];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = path;
    pathAnimation.duration = 1.0;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t = CATransform3DMakeScale(0.1, 0.1, 1.0);
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:t];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.5f];    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:pathAnimation, scaleAnimation, alphaAnimation, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = 1.0;
    
    [_thumbnail.layer addAnimation:animationGroup forKey:nil];
    
    CFRelease(path);
}

- (void)setUpView 
{
	self.backgroundColor = [UIColor whiteColor];
	self.drawPath = NO;
        
	_trash = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
	[_trash setBackgroundColor:[UIColor darkGrayColor]];
	[_trash setCenter:CGPointMake(TRASH_X, TRASH_Y)];
	[self addSubview:_trash];
	
	_thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 220)];
	[_thumbnail setBackgroundColor:[UIColor blueColor]];
	[_thumbnail setCenter:CGPointMake(PICTURE_X, PICTURE_Y)];
	[self addSubview:_thumbnail];

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbnailPressed:)];
	[_thumbnail addGestureRecognizer:tapGestureRecognizer];
	[_thumbnail setUserInteractionEnabled:YES];
	
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	UILabel *instruct = [[UILabel alloc]init];
	instruct.backgroundColor = [UIColor clearColor];
	instruct.text = @"Click the Blue Square";
	instruct.frame = CGRectMake(10, 60, 220, 44.);
	[evDelegate.benchViewController.parametersView addSubview:instruct];
	
	
	pathSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	CGRect rect = CGRectMake(10, 110., 145., 44.);
	CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
	pathSwitch.center = center;
	pathSwitch.on = self.drawPath;
	[pathSwitch addTarget:self action:@selector(toggleCumulative:) forControlEvents:UIControlEventValueChanged];
	[evDelegate.benchViewController.parametersView addSubview:pathSwitch];
	
}
- (void)toggleCumulative:(id)sender 
{
	self.drawPath = [(UISwitch *)sender isOn];
}

- (void)setPath:(CGPathRef)path
{
    if (path != _path) 
	{
        if (_path)
            CFRelease(_path);
        _path = CFRetain(path);
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    if (!_path)
        return;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);    
    CGContextAddPath(ctx, _path);
    
    CGContextSetLineWidth(ctx, 2);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextDrawPath(ctx, kCGPathStroke);    
}

- (void)dealloc 
{
	if (_path)
        CFRelease(_path);

    
}

@end

