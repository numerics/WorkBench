//
//  RSFrameBufferLayer.m
//  WorkBench
//
//  Created by John Basile on 9/1/13.
//
//

#import "RSFrameBufferLayer.h"

@implementation RSFrameBufferLayer

@synthesize context = _context;

+ (RSFrameBufferLayer *)layerWithFrame:(CGRect)frame
{
    return [[RSFrameBufferLayer alloc] initWithFrame:frame];
    
}

- (id)initWithFrame:(CGRect)frame
{
    if (self=[super init]){
        self.opaque = YES;
        self.frame=frame;
    }
    return self;
}

- (void)dealloc
{
    CGContextRelease(_context);
}

- (void)blit
{
    CGImageRef img = CGBitmapContextCreateImage(_context);
    self.contents = (__bridge id)img;
    CGImageRelease(img);
}


-(void)setFrame:(CGRect)frame
{
    CGRect oldframe = self.frame;
    [super setFrame:frame];
    if (frame.size.width != oldframe.size.width || frame.size.height != oldframe.size.height)
	{
        if (_context)
		{
            CGContextRelease(_context);
        }
        CGColorSpaceRef csp = CGColorSpaceCreateDeviceRGB();
        _context = CGBitmapContextCreate(NULL,
										 (size_t)frame.size.width,
										 (size_t)frame.size.height, 8,
										 4*(size_t)frame.size.width, csp,
										 kCGImageAlphaNoneSkipFirst);
        CGColorSpaceRelease(csp);
    }
}

-(uint32_t *)framebuffer
{
    return CGBitmapContextGetData(_context);
}

@end
