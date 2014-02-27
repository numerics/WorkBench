//
//  CustomDrawView.h
//  WorkBench
//
//  Created by Basile, John on 8/20/13.
//
//

#import <UIKit/UIKit.h>

@interface CustomDrawView : UIView<UITableViewDataSource,UITableViewDelegate>
{
}

@property(nonatomic, strong) NSString   *clanTag;
@property(nonatomic, strong) NSString   *customContainer;

- (void)drawRect_1;

@end
