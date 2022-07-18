//
//  EditProfileViewController.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/15/22.
//

#import "EditProfileViewController.h"
#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import <Foundation/Foundation.h>
#import "Parse/PFImageView.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *user = [PFUser currentUser];
    
    self.pfp.file = user[@"profilePicture"];
    [self.pfp loadInBackground];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
