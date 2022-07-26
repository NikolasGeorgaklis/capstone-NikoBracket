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
- (IBAction)didLongPressOnPfp:(id)sender {
    UILongPressGestureRecognizer *profileImageExpand = sender;
       CGRect profileImageframe = profileImageExpand.view.frame;
       profileImageframe.size.height = profileImageExpand.view.frame.size.height * 2;
       profileImageframe.size.width = profileImageExpand.view.frame.size.width * 2;
       if(profileImageExpand.state == UIGestureRecognizerStateBegan){
           [UIView animateWithDuration:0.3 animations:^{
               profileImageExpand.view.layer.zPosition = MAXFLOAT;
               profileImageExpand.view.frame = profileImageframe;
               profileImageExpand.view.transform = CGAffineTransformMakeTranslation(self.view.center.x - profileImageExpand.view.center.x, self.view.center.y - profileImageExpand.view.center.y);
           } completion:nil];
       }
       profileImageframe.size.height = profileImageExpand.view.frame.size.height / 2;
       profileImageframe.size.width = profileImageExpand.view.frame.size.width / 2;
       if(profileImageExpand.state == UIGestureRecognizerStateEnded){
           [UIView animateWithDuration:0.3 animations:^{
               profileImageExpand.view.frame = profileImageframe;
               profileImageExpand.view.transform = CGAffineTransformMakeTranslation(1.f, 1.f);
           } completion:nil];
       }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditProfileViewController *editVC = [segue destinationViewController];
    editVC.delegate = self;
}


@end
