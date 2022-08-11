//
//  viewBracketViewController.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 8/5/22.
//

#import "viewBracketViewController.h"

@interface viewBracketViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *selectedChampionLogo;
@property (weak, nonatomic) IBOutlet UIImageView *selectedSvMChampionLogo;
@property (weak, nonatomic) IBOutlet UIImageView *selectedEvWChampionLogo;
@property (weak, nonatomic) IBOutlet UIImageView *selectedSouthChampion;
@property (weak, nonatomic) IBOutlet UIImageView *selectedMidwestChampion;
@property (weak, nonatomic) IBOutlet UIImageView *selectedWestChampion;
@property (weak, nonatomic) IBOutlet UIImageView *selectedEastChampion;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UILabel *major;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *correctPicks;
@property (weak, nonatomic) IBOutlet UILabel *accuracy;


@end

@implementation viewBracketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set final 4 to final 4 selected by user
    NSString *selectedChampion = self.user[@"finalsPicks"][1][0][[self.user[@"finalsPicks"][1][0][2] intValue]];
    NSString *selectedEvWChampion = self.user[@"finalsPicks"][1][0][0];
    NSString *selectedSvMChampion = self.user[@"finalsPicks"][1][0][1];
    NSString *westChampion = self.user[@"finalsPicks"][0][0][0];
    NSString *eastChampion = self.user[@"finalsPicks"][0][0][1];
    NSString *southChampion = self.user[@"finalsPicks"][0][1][0];
    NSString *midwestChampion = self.user[@"finalsPicks"][0][1][1];
    
    //set final 4 logos on user profile
    [self.selectedChampionLogo setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[selectedChampion]]];
    [self.selectedEvWChampionLogo setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[selectedEvWChampion]]];
    [self.selectedSvMChampionLogo setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[selectedSvMChampion]]];
    [self.selectedWestChampion setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[westChampion]]];
    [self.selectedEastChampion setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[eastChampion]]];
    [self.selectedSouthChampion setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[southChampion]]];
    [self.selectedMidwestChampion setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[midwestChampion]]];
    
    //display user info
    self.profilePicture.file = self.user[@"profilePicture"];
    self.emailLabel.text = self.user[@"username"];
    self.displayName.text = self.user[@"displayName"];
    self.grade.text = self.user[@"grade"] == NULL ? @"Grade: " : [NSString stringWithFormat:@"Grade: %@", self.user[@"grade"]];
    self.major.text = self.user[@"major"] == NULL ? @"Major: " : [NSString stringWithFormat:@"Major: %@", self.user[@"major"]];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2.0;
    self.rank.text = [self.user[@"rank"] stringValue];
    self.correctPicks.text = self.user[@"ratio"];
    self.accuracy.text = [NSString stringWithFormat:@"%@%@" , self.user[@"correctPicksPercent"], @"%"];
    
    [self.profilePicture loadInBackground];

}

- (IBAction)didLongPressOnPfp:(id)sender {
    UILongPressGestureRecognizer *profileImageExpand = sender;
       CGRect profileImageframe = profileImageExpand.view.frame;
       profileImageframe.size.height = profileImageExpand.view.frame.size.height * 3.5;
       profileImageframe.size.width = profileImageExpand.view.frame.size.width * 3.5;
       if(profileImageExpand.state == UIGestureRecognizerStateBegan){
           [UIView animateWithDuration:0.3 animations:^{
               profileImageExpand.view.layer.zPosition = MAXFLOAT;
               profileImageExpand.view.frame = profileImageframe;
               profileImageExpand.view.transform = CGAffineTransformMakeTranslation(self.view.center.x - profileImageExpand.view.center.x, self.view.center.y - profileImageExpand.view.center.y);
           } completion:nil];
       }
       profileImageframe.size.height = profileImageExpand.view.frame.size.height / 3.5;
       profileImageframe.size.width = profileImageExpand.view.frame.size.width / 3.5;
       if(profileImageExpand.state == UIGestureRecognizerStateEnded){
           [UIView animateWithDuration:0.3 animations:^{
               profileImageExpand.view.frame = profileImageframe;
               profileImageExpand.view.transform = CGAffineTransformMakeTranslation(1.f, 1.f);
           } completion:nil];
       }
}

- (IBAction)didTapDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
