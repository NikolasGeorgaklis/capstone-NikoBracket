//
//  ProfileViewController.h
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/15/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *pfp;

@end

NS_ASSUME_NONNULL_END
