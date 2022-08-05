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

@end

@implementation viewBracketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *selectedChampion = self.user[@"finalsPicks"][1][0][[self.user[@"finalsPicks"][1][0][2] intValue]];
    NSString *selectedEvWChampion = self.user[@"finalsPicks"][1][0][0];
    NSString *selectedSvMChampion = self.user[@"finalsPicks"][1][0][1];
    NSString *westChampion = self.user[@"finalsPicks"][0][0][0];
    NSString *eastChampion = self.user[@"finalsPicks"][0][0][1];
    NSString *southChampion = self.user[@"finalsPicks"][0][1][0];
    NSString *midwestChampion = self.user[@"finalsPicks"][0][1][1];

    [self.selectedChampionLogo setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[selectedChampion]]];
    [self.selectedEvWChampionLogo setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[selectedEvWChampion]]];
    [self.selectedSvMChampionLogo setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[selectedSvMChampion]]];
    [self.selectedWestChampion setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[westChampion]]];
    [self.selectedEastChampion setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[eastChampion]]];
    [self.selectedSouthChampion setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[southChampion]]];
    [self.selectedMidwestChampion setImageWithURL:[NSURL URLWithString:self.teamLogoURLs[midwestChampion]]];

}

@end
