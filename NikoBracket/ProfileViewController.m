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

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];
    
    self.pfp.file = self.user[@"profilePicture"];
    [self.pfp loadInBackground];
}

- (void)updateProfile{
    self.pfp.file = self.user[@"profilePicture"];
    self.displayName.text = self.user[@"displayName"];
    NSLog(@"gardee %@", self.user[@"grade"]);
    self.gradeAndMajor.text = [NSString stringWithFormat:@"%@ %@ Major", self.user[@"grade"], self.user[@"major"]];

    [self.pfp loadInBackground];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditProfileViewController *editVC = [segue destinationViewController];
    editVC.delegate = self;
}


@end
