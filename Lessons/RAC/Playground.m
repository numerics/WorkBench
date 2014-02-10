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

//-(void)RAC_KVO:(id)modelName propertyName:(id)propName
//{
//	RAC(self, propName) = [[RACObserve(self, modelName) distinctUntilChanged] deliverOn:[RACScheduler mainThreadScheduler]];
//}

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
	WorkBenchAppDelegate *evDelegate = (WorkBenchAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    self.nameField = [[UILabel alloc]initWithFrame:CGRectMake(50, 140, 220, 30)];
    [self addSubview:self.nameField];
    self.nameField.backgroundColor = [UIColor clearColor];
	self.nameField.textColor = [UIColor blackColor];

	self.sButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.sButton.frame = CGRectMake(10., 10., 145., 44.);
	[self.sButton setTitle:@"Test RAC" forState:UIControlStateNormal];
	//[self.sButton addTarget:self action:@selector(testKVO:) forControlEvents:UIControlEventTouchUpInside];
	[evDelegate.benchViewController.parametersView addSubview:self.sButton];
	
	
	RACSignal *updateLabel = [self.sButton rac_signalForControlEvents:UIControlEventTouchUpInside];
	[updateLabel subscribeNext:^(id sender) {
		self.password = @"KVO Changed";
	}];
	RACSignal *nameSignal = [RACObserve(self, self.password) distinctUntilChanged];
	RAC(self, self.nameField.text) = [nameSignal deliverOn:[RACScheduler mainThreadScheduler]];
	
	
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

- (void)testKVO:(id)sender
{
	self.password = @"KVO Changed";
	
}

@end
