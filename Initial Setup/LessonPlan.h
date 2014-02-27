//	 Copyright (c) 2011 Numerics and John Basile
//	 


#import <Foundation/Foundation.h>
#import "LayerTree.h"

@interface Lesson : UIViewController 
{
}

+ (NSString *)name;

@end


@interface LessonPlan : NSObject 
{
	NSArray *Lessons;
	NSArray *groups;
}

@property (nonatomic, strong)  NSArray *Lessons;
@property (nonatomic, strong)  NSArray *groups;


- (NSUInteger)groupCount;
- (NSUInteger)LessonCountForGroup:(NSUInteger)group;
- (NSArray *)LessonsForGroup:(NSUInteger)group;
- (NSString *)LessonNameAtIndexPath:(NSIndexPath *)indexPath;
- (UIViewController *)LessonForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)groupTitleAtIndex:(NSUInteger)index;
- (UIView *)LessonViewForIndexPath:(NSIndexPath *)indexPath withFrame:(CGRect)frame;

@end
