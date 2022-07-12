//
//  LoginViewController.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/12/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic)IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *didTapLogin;
@property (weak, nonatomic) IBOutlet UIButton *didTapSignUp;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)didTapLogin:(id)sender{
    if (self.username.text.length == 0 || self.password.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                     message:@"Empty Field(s)"
                                                     preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
         {}];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        NSString *username = self.username.text;
            NSString *password = self.password.text;
            
            [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
                if (error != nil) {
                    NSLog(@"User log in failed: %@", error.localizedDescription);
                } else {
                    NSLog(@"User logged in successfully");
                    
                    // display view controller that needs to shown after successful login
                }
            }];
    }
    
}
- (IBAction)didTapSignUp:(id)sender{
    if (self.username.text.length == 0 || self.password.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                     message:@"Empty Field(s)"
                                                     preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
         {}];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        // initialize a user object
        PFUser *newUser = [PFUser user];
           
       // set user properties
       newUser.username = self.username.text;
       newUser.password = self.password.text;
       
       // call sign up function on the object
       [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
           if (error != nil) {
               NSLog(@"Error: %@", error.localizedDescription);
           } else {
               NSLog(@"User registered successfully");
               
               // manually segue to logged in view
           }
       }];
    }
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
