//
//  Playground.h
//  WorkBench
//
//  Created by John Basile on 1/12/14.
//
//

#import <UIKit/UIKit.h>

@interface Playground : UIView<UITextFieldDelegate>
{
	
}
@property(nonatomic, strong)UITextField      *textField;

@property(nonatomic, strong)NSString         *password;
@property(nonatomic, strong)NSString         *passwordConfirmation;

@property(nonatomic, strong)NSNumber         *createEnabled;

@end
