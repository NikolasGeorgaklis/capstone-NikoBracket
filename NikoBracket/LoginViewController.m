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

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.password.secureTextEntry = 1;
    
}

- (IBAction)didTapLogin:(id)sender{
    
    //check for empty fields
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
                    [self performSegueWithIdentifier:@"loginSegue" sender:nil];

                }
            }];
    }
    
}
- (IBAction)didTapSignUp:(id)sender{
    
    //villanova.edu only register
    if ([self.username.text rangeOfString:@"villanova.edu"].location == NSNotFound) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                     message:@"You must have a villanova.edu email to register."
                                                     preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
         {}];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    //check for empty fields
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
       newUser.email = self.username.text;
       newUser.password = self.password.text;
       
       // call sign up function on the object
       [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
           if (error != nil) {
               NSLog(@"Error: %@", error.localizedDescription);
           } else {
               NSLog(@"User registered successfully");
               
               // notify user of successful registration
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!"
                                                            message:@"Please check your email for verification."
                                                            preferredStyle:UIAlertControllerStyleAlert];

               UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                {}];
               [alert addAction:ok];
               [self presentViewController:alert animated:YES completion:nil];
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
