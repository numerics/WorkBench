//
//  PieMenu.m
//  TouchPie
//
//  Created by Antonio Cabezuelo Vivo on 27/11/08.
//  Modified by John Basile on 6/20/12.
//  Copyright 2012 Numerics. All rights reserved.
//

#import "PieMenu.h"
#import "PieView.h"

/* JP: added SFX */
#import "BFSoundEffect.h"


#define kImageSize          64

static int contrapositions[] = { 5, 6, 6, 0, 0, 0, 1 };

NSInteger getposition(NSInteger origPosition, NSInteger origNum, NSInteger destNum)
{
	NSInteger oriGmapTo6 = origPosition * kMaxNumberOfItems / origNum;
	NSInteger contraPosIn6 = contrapositions[oriGmapTo6];
	return ceilf(1.0 * contraPosIn6 * destNum / kMaxNumberOfItems);
}

CGContextRef MyCreateBitmapContext (int pixelsWide, int pixelsHigh)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
	
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
    colorSpace = CGColorSpaceCreateDeviceRGB();
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
	{
        fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedLast);
    if (context== NULL)
	{
		CGColorSpaceRelease(colorSpace);
        free (bitmapData);
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    CGColorSpaceRelease( colorSpace );
	
    return context;
}



@interface PieMenu ()
@property (nonatomic, strong) PieView *pieView;
@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *path;
@end

@interface PieMenu (PrivateMethods)

- (void) showMenuAtPoint:(CGPoint)thePoint;
- (void) hideMenu;

@end

#ifdef kLimitPieMenu		//Tanoi-010710
CGRect	allowedRect;		//Frame in parent view to touch for pie menu
BOOL	checkLimits = NO;	//Flag to calculate this frame once
#endif

@implementation PieMenu

@synthesize leftHanded;
@synthesize fingerSize;
@synthesize pieView;
@synthesize parentView;
@synthesize items;
@synthesize path;
@synthesize on;

@synthesize centerImage;		//Tanoi-011910
@synthesize centerWheelColor;	//Tanoi-011910


- (id) init
{
	if (self = [super init])
	{
		self.items = [[NSArray alloc] init];
		self.path = [NSMutableArray arrayWithCapacity:2];
//		self.fingerSize = PieMenuFingerSizeNormal;
		self.fingerSize = PieMenuFingerSizeTiny;
	}
	return self;
}

#define	kAdjustPointBy 8.0

- (void) showInView:(UIView *)theView atPoint:(CGPoint)thePoint
{
	self.parentView = theView;
	if (pieView == nil)
	{
		self.pieView = [[PieView alloc] initWithFrame:CGRectZero];
		pieView.userInteractionEnabled = YES;
		for (PieMenuItem *item in items)
		{
			[pieView addItem:item];
		}
		pieView.leftHanded = self.leftHanded;
		pieView.menu = self;
		pieView.fingerSize = self.fingerSize;
		pieView.centerImage = centerImage;
		pieView.innerWheelColor = nil;//So if nothing is passed, it should still work
		pieView.innerWheelColor = centerWheelColor;
	}
	pieView.frame = CGRectZero;
	pieView.center = thePoint;
	
	// 1/15/10 TW: PieMenu's caller should specifiy the center image.
	//	[pieView loadCenterImage:@"Icon.png"]; //Tanoi-010910
	
#ifdef kLimitPieMenu //Tanoi-010910
	pieView.frame = CGRectMake(thePoint.x - [pieView minimumSize] / 2.0, thePoint.y - [pieView minimumSize] / 2.0, [pieView minimumSize], [pieView minimumSize]);
	
	if(checkLimits == NO)
	 {
		 CGRect pieMenuRect = pieView.frame;
		 allowedRect = [theView frame];
		 allowedRect = CGRectInset(allowedRect, 0.50*pieMenuRect.size.width, 0.50*pieMenuRect.size.height);
		 checkLimits = YES;
	 }
	
	if(!CGRectContainsPoint(allowedRect, thePoint))
	{
		float 	newX = thePoint.x, 
		newY = thePoint.y;
		BOOL pointChanged = NO;
		
		if(thePoint.x < allowedRect.origin.x)
		{
			newX = allowedRect.origin.x + kAdjustPointBy;
			pointChanged = YES;
		}
		else if(thePoint.x > (allowedRect.origin.x + allowedRect.size.width))
		{
			newX = (allowedRect.origin.x + allowedRect.size.width) - kAdjustPointBy;
			pointChanged = YES;
		}
		
		if(thePoint.y < allowedRect.origin.y)
		{
			newY = allowedRect.origin.y + kAdjustPointBy;
			pointChanged = YES;
		}
		else if(thePoint.y > (allowedRect.origin.y + allowedRect.size.height))
		{
			newY = (allowedRect.origin.y + allowedRect.size.height) - kAdjustPointBy;
			pointChanged = YES;
		}
		
		if(pointChanged)
		{
			thePoint = CGPointMake(newX, newY);			
			pieView.frame = CGRectMake(thePoint.x - [pieView minimumSize] / 2.0, thePoint.y - [pieView minimumSize] / 2.0, [pieView minimumSize], [pieView minimumSize]);
		}		

	}
	
	[self.parentView addSubview:pieView];
	[self showMenuAtPoint:thePoint];
	[[BFSoundEffect soundEffectWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"miss" ofType:@"wav"]] playAudio];
	on = YES;
#else
	[self.parentView addSubview:pieView];
	[self showMenuAtPoint:thePoint];
	on = YES;
	
	/* TW */
	//	[pieView becomeFirstResponder];

	/* JP: added SFX */
	[[BFSoundEffect soundEffectWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"miss" ofType:@"wav"]] playAudio];
#endif
}

#ifdef kLimitPieMenu //Tanoi-010910

- (void) showMenuAtPoint:(CGPoint)thePoint
{
	[UIView beginAnimations:nil	context:NULL];
	[UIView setAnimationDuration:0.15];
	[UIView commitAnimations];
	on = YES;
}

#else

- (void) showMenuAtPoint:(CGPoint)thePoint
{
	[UIView beginAnimations:nil	context:NULL];
	[UIView setAnimationDuration:0.15];
	pieView.frame = CGRectMake(thePoint.x - [pieView minimumSize] / 2.0, thePoint.y - [pieView minimumSize] / 2.0, [pieView minimumSize], [pieView minimumSize]);
	[UIView commitAnimations];
	on = YES;
}
#endif

- (void) hideMenu
{
	[UIView beginAnimations:nil	context:NULL];
	[UIView setAnimationDuration:0.5];
	[self.pieView removeFromSuperview];
	[UIView commitAnimations];
	on = NO;
}

- (void) itemSelected:(PieMenuItem *)item
{
	[self hideMenu];
	[pieView clearItems];
	for (PieMenuItem *myitem in items)
	{
		[pieView addItem:myitem];
	}
	if (item)
	{
		[item performAction];
		/* JP: added SFX */
		[[BFSoundEffect soundEffectWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tick" ofType:@"wav"]] playAudio];
	}
}

- (void) addItem:(PieMenuItem *)item
{
	if (item == nil)
	{
		NSException *exception = [NSException exceptionWithName:@"NSInvalidArgumentException"
														 reason:@"the item suplied is nil"  userInfo:nil];
		@throw exception;
	}
	if ([items count] >= kMaxNumberOfItems)
	{
		NSException *exception = [NSException exceptionWithName:@"RangeException"
														 reason:@"maximus number of subitems reached"  userInfo:nil];
		@throw exception;
	}
	if ([items indexOfObject:item] != NSNotFound)
	{
		NSException *exception = [NSException exceptionWithName:@"DuplicatedItemException"
														 reason:@"the item is allready a subitem"  userInfo:nil];
		@throw exception;
	}
	self.items = [items arrayByAddingObject:item];
}

- (UIView *) view
{
	return pieView;
}

- (void) setFingerSize:(PieMenuFingerSize)theFingerSize
{
	fingerSize = theFingerSize;
	if (pieView != nil)
	{
		pieView.fingerSize = fingerSize;
	}
}

- (void) setLeftHanded:(BOOL)theLeftHanded
{
	leftHanded = theLeftHanded;
	if (pieView != nil)
	{
		pieView.leftHanded = leftHanded;
	}
}

- (void) itemWithSubitemsSelected:(PieMenuItem *)theItem withIndex:(NSInteger)theIndex atPoint:(CGPoint)thePoint
{
	CGContextRef myContext = MyCreateBitmapContext(kImageSize, kImageSize);
	CGContextScaleCTM(myContext, 1.0, -1.0);
	CGContextTranslateCTM(myContext, 0.0, -kImageSize);
	CGContextScaleCTM(myContext, kImageSize / [pieView minimumSize], kImageSize / [pieView minimumSize]);
	[pieView.layer renderInContext:myContext];
	CGImageRef myImage = CGBitmapContextCreateImage(myContext);
	CGContextRelease(myContext);
	UIImage *image = [UIImage imageWithCGImage:myImage];
	CGImageRelease(myImage);
	
	CGPoint point = [parentView convertPoint:thePoint fromView:pieView];
	[self hideMenu];
	[pieView clearItems];
	
	NSInteger pos;
	if (theItem.parentItem != nil)
	{
		pos = getposition([theItem indexInParent], [theItem.parentItem  numberOfSubitems], [theItem numberOfSubitems]);
	}
	else
	{
		pos = getposition([items indexOfObject:theItem], items.count, [theItem numberOfSubitems]);
	}
	
	NSLog(@"POS: %i", pos);

	for (NSUInteger i = 0; i < [theItem numberOfSubitems] + 1; i++)
	{
		if (i == pos)
		{
			PieMenuItem *parentItem = [[PieMenuItem alloc] init];
			parentItem.title = @"< back";
			parentItem.icon = image;
			parentItem.type = PieMenuItemTypeBack;
			parentItem.parentItem = theItem;
			[pieView addItem:parentItem];
			[path addObject:parentItem];
		}
		if ([theItem subitemAtIndex:i])
			[pieView addItem:[theItem subitemAtIndex:i]];
	}
	[self showInView:parentView atPoint:point];
}


- (void) parentItemSelected:(PieMenuItem *)theItem withIndex:(NSInteger)theIndex atPoint:(CGPoint)thePoint
{
	CGPoint point = [parentView convertPoint:thePoint fromView:pieView];
	[self hideMenu];
	[pieView clearItems];

	PieMenuItem *item = theItem.parentItem;
	PieMenuItem *parentItem = item.parentItem;
	NSArray *subitems = items;
	NSInteger pos = -1;
	if (parentItem != nil)
	{
		subitems = parentItem.subItems;
		if (parentItem.parentItem != nil)
		{
			pos = getposition([parentItem indexInParent], [parentItem.parentItem  numberOfSubitems], [parentItem numberOfSubitems]);
		}
		else
		{
			pos = getposition([items indexOfObject:parentItem], items.count, [parentItem numberOfSubitems]);
		}
	}
	
	NSLog(@"POS: %i", pos);	
	[path removeLastObject];

	for (NSUInteger i = 0; i < subitems.count + 1; i++)
	{
		if (i == pos)
		{
			[pieView addItem:[path lastObject]];
		}
		@try
		{
			[pieView addItem:[subitems objectAtIndex:i]];
		} 
		@catch (NSException *exception)
		{
		}
	}
	[self showInView:parentView atPoint:point];
}




@end
