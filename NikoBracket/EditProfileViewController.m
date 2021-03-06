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

@property (weak, nonatomic) IBOutlet PFImageView *pfp;
@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UITextField *displayNameField;
@property (weak, nonatomic) IBOutlet UITextField *gradeField;
@property (weak, nonatomic) IBOutlet UITextField *majorField;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];
    
    self.pfp.file = self.user[@"profilePicture"];
    [self.pfp loadInBackground];
    
    self.displayNameField.text = self.user[@"displayName"];
    self.gradeField.text = self.user[@"grade"];
    self.majorField.text = self.user[@"major"];

    
}

- (IBAction)changePfp:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    [self resizeImage:editedImage withSize:self.pfp.bounds.size];
    self.pfp.image = editedImage;
    NSData *imageData = UIImagePNGRepresentation(self.pfp.image);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"image.png" data:imageData]; //self.pfp.file.name
        
    self.user[@"profilePicture"] = imageFile;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"it worked!");
        }
    }];
    
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (IBAction)doneEditing:(id)sender {
    if (self.displayNameField.text.length == 0 || self.gradeField.text.length == 0 || self.majorField.text.length == 0) {     //check for empty fields
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                     message:@"Empty Field(s)"
                                                     preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
         {}];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        //set values in parse
        self.user[@"displayName"] = self.displayNameField.text;
        self.user[@"grade"] = self.gradeField.text;
        self.user[@"major"] = self.majorField.text;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"success");
            }
        }];

        //set values in profileviewcontroller
        [self.delegate updateProfile];
        
        [self dismissViewControllerAnimated:YES completion:nil];
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
