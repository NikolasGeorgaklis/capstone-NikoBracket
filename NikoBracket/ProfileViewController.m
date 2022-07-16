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


@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *user = [PFUser currentUser];
    
    
    
//    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:user.]];
//    self.pfp.image = [UIImage imageWithData:imageData];
    
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
