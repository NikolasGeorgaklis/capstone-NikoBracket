//
//  CommentsViewController.h
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 8/12/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentsViewController : UIViewController

@property (nonatomic, strong) PFUser *user;

@end

NS_ASSUME_NONNULL_END
