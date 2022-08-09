//
//  CreateBracketViewController.h
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/26/22.
//

#import <UIKit/UIKit.h>
#import "CreateBracketViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface CreateBracketViewController : UIViewController

- (void)changePick:(int) index inSection:(int) section inCell:(UITableViewCell *) cell;


@end

NS_ASSUME_NONNULL_END
