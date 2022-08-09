//
//  viewBracketViewController.h
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 8/5/22.
//

#import <UIKit/UIKit.h>
#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "HomeViewCell.h"
#import "UIImageView+AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface viewBracketViewController : UIViewController

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSArray *finals;
@property (strong, nonatomic) NSMutableDictionary *teamLogoURLs;

@end

NS_ASSUME_NONNULL_END
