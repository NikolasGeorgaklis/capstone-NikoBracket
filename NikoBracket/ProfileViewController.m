//
//  ProfileViewController.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/15/22.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import <Foundation/Foundation.h>
#import "Parse/PFImageView.h"
#import "EditProfileViewController.h"


@interface ProfileViewController () <EditProfileViewControllerDelegate>

@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];
    
    self.pfp.file = self.user[@"profilePicture"];
    self.emailLabel.text = self.user[@"email"];
    self.displayName.text = self.user[@"displayName"];
    self.gradeAndMajor.text = [NSString stringWithFormat:@"%@ %@ Major", self.user[@"grade"], self.user[@"major"]];

    [self.pfp loadInBackground];
}

- (void)updateProfile{
    self.pfp.file = self.user[@"profilePicture"];
    self.displayName.text = self.user[@"displayName"];
    self.gradeAndMajor.text = [NSString stringWithFormat:@"%@ %@ Major", self.user[@"grade"], self.user[@"major"]];
    self.emailLabel.text = self.user[@"email"];

    [self.pfp loadInBackground];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editProfileSegue"]) {
            EditProfileViewController *editVC = [segue destinationViewController];
            editVC.delegate = self;
        }
        else if ([segue.identifier isEqualToString:@"createBracketSegue"]){

        }

}


@end
