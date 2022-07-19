//
//  EditProfileViewController.h
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/15/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditProfileViewControllerDelegate

-(void)updateProfile;

@end

@interface EditProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)id<EditProfileViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
