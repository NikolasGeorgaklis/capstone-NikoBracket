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
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *gradeAndMajor;


@end

NS_ASSUME_NONNULL_END
