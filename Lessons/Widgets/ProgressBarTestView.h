//
//  ProgressBarTestView.h
//  WorkBench
//
//  Created by John Basile on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressBar.h"

@interface ProgressBarTestView : UIView 
{
    ProgressBar     *progressBar;
}
@property (nonatomic, strong) ProgressBar     *progressBar;
@end
