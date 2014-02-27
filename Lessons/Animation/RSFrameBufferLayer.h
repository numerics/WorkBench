//
//  RSFrameBufferLayer.h
//  WorkBench
//
//  Created by John Basile on 9/1/13.
//
//

#import <QuartzCore/QuartzCore.h>

@interface RSFrameBufferLayer : CALayer

// Class method to create a new layer with an underlying
// bitmap. Both will have the size set by the frame
+ (RSFrameBufferLayer *)layerWithFrame:(CGRect)frame;
// Same as above
- (id)initWithFrame:(CGRect)frame;

// Draw bitmap to screen
- (void)blit;

// Get the underlying context to use for higher-level
// drawing operations in Quartz
@property(readonly) CGContextRef context;

// Get the raw "frame buffer"
@property(readonly) uint32_t *framebuffer;


@end
