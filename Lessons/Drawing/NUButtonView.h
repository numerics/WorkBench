//
//  NUButtonView.h
//  WorkBench
//
//  Created by John Basile on 7/15/13.
//
//

#import <UIKit/UIKit.h>
#import "NUButtonLayer.h"

@interface NUButtonView : UIView
{
	NUButtonLayer	*cButton;
	UIButton		*toggleBorderButton;
	UIButton		*toggleOpacityButton;
}
@property(nonatomic,strong)NUButtonLayer	*cButton;


@end
