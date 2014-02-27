//	 Copyright (c) 2011 Numerics and John Basile
//	 
//	 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	 THE SOFTWARE.


#import "LayerDrawing.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomLayer2 : CALayer 
{
}

@end

@implementation CustomLayer2

- (void)drawInContext:(CGContextRef)ctx 
{
	CGContextAddEllipseInRect(ctx, CGRectInset(self.bounds, 4., 4.));
	
	CGContextSetLineWidth(ctx, 2.);
	const CGFloat lineDashLengths[2] = { 6., 2. };
	CGContextSetLineDash(ctx, 0., lineDashLengths, 2);
	
	CGContextSetFillColorWithColor(ctx, [[UIColor greenColor] CGColor]);
	CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
	
	CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end

@implementation LayerDrawing

+ (NSString *)className 
{
	return @"Draw Your Own Content";
}

#pragma mark init and dealloc

#pragma mark Setup the View

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self setUpView];
	}
    return self;
}


- (void)setUpView 
{
	self.backgroundColor = [UIColor whiteColor];
	
	drawingLayer = [[CustomLayer2 alloc] init];
	
	[self.layer addSublayer:drawingLayer];
	
	drawingLayer.backgroundColor = [[UIColor clearColor] CGColor];
	drawingLayer.bounds = CGRectMake(0., 0., 300., 300.);
	drawingLayer.position = self.center;
	[drawingLayer setNeedsDisplay];
}

#pragma mark View drawing

- (void)dealloc 
{
	drawingLayer = nil;
}

@end

