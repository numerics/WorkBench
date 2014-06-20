//
//  Playground.m
//  WorkBench
//
//  Created by John Basile on 1/12/14.
//
//

#import "Playground.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkBenchAppDelegate.h"
#import "WorkBenchViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation Playground

+ (NSString *)className
{
	return @"RAC";
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


- (void)setUpView
{
	self.backgroundColor = [UIColor whiteColor];
	
	//WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSArray *array = @[@(1), @(2), @(3), @(4), @(5), @(6), @(7)];
    
    RACSequence *stream = [array rac_sequence];
    
    [stream map:^id(id each) {
        return @(pow([each integerValue], 2));
    }];
    NSLog(@"%@", [stream array]);
    
    NSLog(@"%@", [[[ array rac_sequence] map: ^ id( id value) {
        return [value stringValue];
    }] foldLeftWithStart:@"" reduce: ^ id( id accumulator, id value) {
        return [accumulator stringByAppendingString:value];
    }]);
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 80, 220, 30)];
    self.textField.delegate = self;
    [self addSubview:self.textField];
    self.textField.backgroundColor = [UIColor grayColor];
    
    [self.textField.rac_textSignal subscribeNext: ^( id x) {
        NSLog(@" New value: %@", x);
		//    } error: ^( NSError *error) {
		//        NSLog(@" Error: %@", error);
		//    } completed: ^{
		//        NSLog(@" Completed.");
    }];
	
    RAC(self, createEnabled) = [RACSignal combineLatest:@[ RACObserve(self, password), RACObserve(self, passwordConfirmation) ]
												 reduce:^(NSString *password, NSString *passwordConfirm)
								{
									NSLog(@" Password: %@", self.password);
									NSLog(@" PasswordConfirmation: %@", self.passwordConfirmation);
									return @([passwordConfirm isEqualToString:password]);
								}];
	
	
	NSLog(@" createEnabled: %@", self.createEnabled);
	
	
	self.password = @"Rapcon77";
	self.passwordConfirmation = @"Yes";
	NSLog(@" createEnabled: %@", self.createEnabled);
}


@end
