//
//  DetailData.h
//  WorkBench
//
//  Created by John Basile on 8/19/12.
//
//

#import <Foundation/Foundation.h>

@interface DetailData : NSObject
{
	NSObject				*target;
	NSString				*title;
	NSString				*imageName;
	SEL						action;
}
@property (nonatomic,strong) 	NSString	*title;
@property (nonatomic,strong) 	NSString	*imageName;
@property (nonatomic,strong)	NSObject	*target;
@property (nonatomic,assign)	SEL			action;

+(DetailData*) initWithTarget:(NSObject*)t action:(SEL)s imageNamed:(NSString*)imgName title:(NSString*)text;

@end
