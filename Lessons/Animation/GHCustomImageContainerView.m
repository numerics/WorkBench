//
//  GHCustomImageContainerView.m
//  WorkBench
//
//  Created by Basile, John on 8/16/13.
//
//

#import "GHCustomImageContainerView.h"
#import "UIColor+EliteKit.h"

@implementation GHCustomImageContainerView
{
    BOOL isHighlighting;
    UIColor  *saveFillColor;
}

- (id)initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        self.fillColor = [UIColor clearColor];
        
        if (!self.borderColor)
            self.borderColor =  [UIColor colorWithHexString:@"0x666666"];
        
        self.sizeImageToFrame = NO;
        self.notchSize = 10;
        self.alpha = 1.0;
        self.lineWidth = 1.0;
    }
	
    return self;
}

- (id)initWithFrame:(CGRect)frame withImage:(UIImageView *)containedImage
{
    self = [self initWithFrame: frame];
	self.containedImage = containedImage;
    self.imageFrame = frame;
   // self.sizeImageToFrame = YES;

    return self;
    
}

- (id)initWithFrame:(CGRect)frame withImage:(UIImageView *)containedImage andImageFrame:(CGRect)iFrame
{
    self = [self initWithFrame: frame];
    self.sizeImageToFrame = YES;
    self.imageFrame = iFrame;
	self.containedImage = containedImage;
    return self;
    
}

- (id)initWithImage:(UIImageView *)containedImage
{
    CGSize imSize = containedImage.image.size;
    CGRect frame = CGRectMake(0, 0, imSize.width, imSize.height);
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        self.containedImage = containedImage;
        
        if (!self.borderColor)
            self.borderColor = [UIColor colorWithHexString:@"0x666666"];
        
        self.notchSize = 10.0;
        self.lineWidth = 1.0;
        self.lineAlpha = 1.0;
    }
    
    return self;
    
}

- (void) drawRect:(CGRect)rect
{
    CGFloat left = rect.origin.x;
    CGFloat right = rect.origin.x + rect.size.width;
    CGFloat top = rect.origin.y;
    CGFloat bottom = rect.origin.y + rect.size.height;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat topLeftEdgeInset = 0.0, topRightEdgeInset = 0.0, bottomLeftEdgeInset = 0.0, bottomRightEdgeInset = 0.0;
    
    if (self.addTopLeftNotch)
        topLeftEdgeInset = self.notchSize;
    
    if (self.addTopRightNotch)
        topRightEdgeInset = self.notchSize;
    
    if (self.addBottomRightNotch)
        bottomRightEdgeInset = self.notchSize;
    
    if (self.addBottomLeftNotch)
        bottomLeftEdgeInset = self.notchSize;
    
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextSaveGState(context);
    
    self.imageLayer = [CALayer layer];
    self.imageLayer.anchorPoint  = CGPointMake(0., 0.);
    [self.layer addSublayer:self.imageLayer];
    
//    CGRect c = CGRectMake(self.imageFrame.origin.x + self.lineWidth, self.imageFrame.origin.y + self.lineWidth, self.imageFrame.size.width, self.imageFrame.size.height);
    CGRect c = CGRectMake(self.lineWidth,self.lineWidth, self.imageFrame.size.width, self.imageFrame.size.height);
    //CGRect r = CGRectInset (self.imageFrame, 0, 0);

    if(self.sizeImageToFrame)
        self.imageLayer.frame = c;
    else
        self.imageLayer.frame = rect;
    
    
    self.imageLayer.contents = (id)[self.containedImage.image CGImage];
	self.maskLayer = [[CAShapeLayer alloc] init];
    
    //self.imageLayer.position = self.center;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetAlpha(context, self.alpha);
    
    if( self.lineWidth > 1.0)                           /// this will higlite out the border
    {
        left += self.lineWidth - 1.0;
        top  += self.lineWidth - 1.0;
        right -= self.lineWidth - 1.0;
        bottom -= self.lineWidth - 1.0;
    }
    
    CGPathMoveToPoint(   path, NULL, left  + topLeftEdgeInset,top);
    CGPathAddLineToPoint(path, NULL, right - topRightEdgeInset,top);
    CGPathAddLineToPoint(path, NULL, right,  top + topRightEdgeInset);
    CGPathAddLineToPoint(path, NULL, right,  bottom - bottomRightEdgeInset);
    CGPathAddLineToPoint(path, NULL, right - bottomRightEdgeInset , bottom);
    CGPathAddLineToPoint(path, NULL, left  + bottomLeftEdgeInset , bottom);
    CGPathAddLineToPoint(path, NULL, left,   bottom - bottomLeftEdgeInset) ;
    CGPathAddLineToPoint(path, NULL, left, top + topLeftEdgeInset);
    CGPathCloseSubpath(path);
    
    self.maskLayer.path = path;
    
    self.imageLayer.mask = self.maskLayer;
    
    CGContextAddPath (context, path);
    
    CGContextRestoreGState(context);
    
    CGContextAddPath (context, path);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetAlpha(context, 1.0);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGPathRelease (path);
}

@end
