//
//  CKCustomActivityIndicator.h
//  Mozart
//
//  Created by John Basile on 4/28/14.
//  Copyright (c) 2014 Needly. All rights reserved.
//
typedef enum
{
    MZCustomActivityIndicatorTypeSmall,
    MZCustomActivityIndicatorTypeLarge
} MZCustomActivityIndicatorType;

#import <UIKit/UIKit.h>

@interface MZGlobalActivityIndicator : UIView

+(void)setContainer:(UIView *)containerView;

+(void)show;
+(void)showAnimated:(BOOL)animated;

+(void)hide;
+(void)hideAnimated:(BOOL)animated;

+(void)showProcessingLabel:(NSString *)label;

@end


@interface CKCustomActivityIndicator : UIView
@property (nonatomic, strong) NSString *labelText;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) UILabel *processingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

- (id) initWithActivityIndicatorType:(MZCustomActivityIndicatorType) type;

- (void) startAnimating;
- (void) stopAnimating;
@end
