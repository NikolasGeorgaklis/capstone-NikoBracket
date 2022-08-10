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

static NSMutableArray *teamsInTournament;
static int numOfPastGames;

@interface ProfileViewController () <EditProfileViewControllerDelegate>

@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    [self.user fetch];
    self.pfp.file = self.user[@"profilePicture"];
    self.emailLabel.text = self.user[@"email"];
    self.displayName.text = self.user[@"displayName"];
    self.gradeAndMajor.text = self.user[@"grade"] == NULL ? @"Grade Major" : [NSString stringWithFormat:@"%@ %@ Major", self.user[@"grade"], self.user[@"major"]];
    self.pfp.layer.cornerRadius = self.pfp.frame.size.height/2.0;
    if ([self.user[@"createdBracket"] isEqual:@(true)]){
        [self getUserBracketStats:5];//final round is round 5
        self.rank.text = [self.user[@"rank"] stringValue];
        self.correctPicksLabel.text = self.user[@"ratio"];
        self.correctPicksAsPercent.text = [NSString stringWithFormat:@"%@%@" , self.user[@"correctPicksPercent"], @"%"];
    }
    else {
        self.rank.text = @"N/A";
        self.correctPicksLabel.text = @"N/A";
        self.correctPicksAsPercent.text = @"N/A";
    }

    [self.pfp loadInBackground];
}

- (void)viewWillAppear:(BOOL)animated{
    self.user = [PFUser currentUser];
    [self.user fetch];
    self.pfp.file = self.user[@"profilePicture"];
    self.emailLabel.text = self.user[@"email"];
    self.displayName.text = self.user[@"displayName"];
    self.gradeAndMajor.text = self.user[@"grade"] == NULL ? @"Grade Major" : [NSString stringWithFormat:@"%@ %@ Major", self.user[@"grade"], self.user[@"major"]];
    self.pfp.layer.cornerRadius = self.pfp.frame.size.height/2.0;
    if ([self.user[@"createdBracket"] isEqual:@(true)]){
        [self getUserBracketStats:5];//final round is round 5
        self.rank.text = [self.user[@"rank"] stringValue];
        self.correctPicksLabel.text = self.user[@"ratio"];
        self.correctPicksAsPercent.text = [NSString stringWithFormat:@"%@%@" , self.user[@"correctPicksPercent"], @"%"];
    }
    else {
        self.rank.text = @"N/A";
        self.correctPicksLabel.text = @"N/A";
        self.correctPicksAsPercent.text = @"N/A";
    }

    [self.pfp loadInBackground];
}

- (void)updateProfile:(PFImageView *)pfp{
    self.pfp.file = pfp.file;
    [self.pfp setImage:pfp.image];
    self.displayName.text = self.user[@"displayName"];
    self.gradeAndMajor.text = [NSString stringWithFormat:@"%@ %@ Major", self.user[@"grade"], self.user[@"major"]];
    self.emailLabel.text = self.user[@"email"];

    [self.pfp loadInBackground];
}

- (IBAction)didLongPressOnPfp:(id)sender {
    UILongPressGestureRecognizer *profileImageExpand = sender;
       CGRect profileImageframe = profileImageExpand.view.frame;
       profileImageframe.size.height = profileImageExpand.view.frame.size.height * 1.7;
       profileImageframe.size.width = profileImageExpand.view.frame.size.width * 1.7;
       if(profileImageExpand.state == UIGestureRecognizerStateBegan){
           [UIView animateWithDuration:0.3 animations:^{
               profileImageExpand.view.layer.zPosition = MAXFLOAT;
               profileImageExpand.view.frame = profileImageframe;
               profileImageExpand.view.transform = CGAffineTransformMakeTranslation(self.view.center.x - profileImageExpand.view.center.x, self.view.center.y - profileImageExpand.view.center.y);
           } completion:nil];
       }
       profileImageframe.size.height = profileImageExpand.view.frame.size.height / 1.7;
       profileImageframe.size.width = profileImageExpand.view.frame.size.width / 1.7;
       if(profileImageExpand.state == UIGestureRecognizerStateEnded){
           [UIView animateWithDuration:0.3 animations:^{
               profileImageExpand.view.frame = profileImageframe;
               profileImageExpand.view.transform = CGAffineTransformMakeTranslation(1.f, 1.f);
           } completion:nil];
       }
}

- (void)getUserBracketStats:(NSInteger *)round{
    //pull api key from Keys.plist
    NSString *pListPath = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: pListPath];
    NSString *key = [dict objectForKey: @"API_Key"];
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"%@%@",  @"https://api.sportsdata.io/v3/cbb/scores/json/Tournament/2022?key=", key];
    
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSMutableDictionary *tempDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSArray *allMatchups = tempDictionary[@"Games"];
    
    //put 6 arrays into teamsInTournament, one for each round
    teamsInTournament = [[NSMutableArray alloc] init];
    for (int i = 0; i<6; i++) {
        [teamsInTournament addObject:[[NSMutableArray alloc] init]];
    }
    
    //separate teams by round; round key returns inaccurate data in free version of API so we separate rounds by date
    for (NSDictionary *game in allMatchups) {
        //round 1 happened 3/17-18 in 2022
        if ([game[@"Day"] containsString:@"2022-03-17"]
            || [game[@"Day"] containsString:@"2022-03-18"]){
            [teamsInTournament[0] addObject:game[@"HomeTeam"]];
            [teamsInTournament[0] addObject:game[@"AwayTeam"]];
        }
        //round 2 happened 3/19-20 in 2022
        if ([game[@"Day"] containsString:@"2022-03-19"]
            || [game[@"Day"] containsString:@"2022-03-20"]){
            [teamsInTournament[1] addObject:game[@"HomeTeam"]];
            [teamsInTournament[1] addObject:game[@"AwayTeam"]];
        }
        //round 3 happened 3/24-25 in 2022
        if ([game[@"Day"] containsString:@"2022-03-24"]
            || [game[@"Day"] containsString:@"2022-03-25"]){
            [teamsInTournament[2] addObject:game[@"HomeTeam"]];
            [teamsInTournament[2] addObject:game[@"AwayTeam"]];
        }
        //round 4 happened 3/26-27 in 2022
        if ([game[@"Day"] containsString:@"2022-03-26"]
            || [game[@"Day"] containsString:@"2022-03-27"]){
            [teamsInTournament[3] addObject:game[@"HomeTeam"]];
            [teamsInTournament[3] addObject:game[@"AwayTeam"]];
        }
        //semifinals/final4 happened 4/2 in 2022
        if ([game[@"Day"] containsString:@"2022-04-02"]){
            [teamsInTournament[4] addObject:game[@"HomeTeam"]];
            [teamsInTournament[4] addObject:game[@"AwayTeam"]];
        }
        //championship happened 4/4 in 2022
        if ([game[@"Day"] containsString:@"2022-04-04"]){
            [teamsInTournament[5] addObject:game[@"HomeTeam"]];
            [teamsInTournament[5] addObject:game[@"AwayTeam"]];
        }
    }
    
    NSArray *westPicks = self.user[@"westPicks"];
    NSArray *southPicks = self.user[@"southPicks"];
    NSArray *eastPicks = self.user[@"eastPicks"];
    NSArray *midwestPicks = self.user[@"midwestPicks"];
    NSArray *finalsPicks = self.user[@"finalsPicks"];

    //correct picks and number of past games initialized to 0
    int correctPicks = 0;
    numOfPastGames = 0;
        
    //i is initialized to 1 because user's picks begin in round 2, everyone's round 1 looks the same
    for (int i = 1; i<=round; i++) {
        if (i < 4) {//4 is semi finals round
            for (NSArray *game in westPicks[i]){
                if ([teamsInTournament[i] containsObject:game[0]] &&  [teamsInTournament[i] containsObject:game[1]]){
                    correctPicks+=2;
                }
                else if ([teamsInTournament[i] containsObject:game[0]] ||  [teamsInTournament[i] containsObject:game[1]]){
                    correctPicks++;
                }
                numOfPastGames++;
            }
            for (NSArray *game in southPicks[i]){
                if ([teamsInTournament[i] containsObject:game[0]] &&  [teamsInTournament[i] containsObject:game[1]]){
                    correctPicks+=2;
                }
                else if ([teamsInTournament[i] containsObject:game[0]] ||  [teamsInTournament[i] containsObject:game[1]]){
                    correctPicks++;
                }
                numOfPastGames++;
            }
            for (NSArray *game in eastPicks[i]){
                if ([teamsInTournament[i] containsObject:game[0]] &&  [teamsInTournament[i] containsObject:game[1]]){
                    correctPicks+=2;
                }
                else if ([teamsInTournament[i] containsObject:game[0]] ||  [teamsInTournament[i] containsObject:game[1]]){
                    correctPicks++;
                }
                numOfPastGames++;
            }
            for (NSArray *game in midwestPicks[i]){
                if ([teamsInTournament[i] containsObject:game[0]] &&  [teamsInTournament[i] containsObject:game[1]]){
                    correctPicks+=2;
                }
                else if ([teamsInTournament[i] containsObject:game[0]] ||  [teamsInTournament[i] containsObject:game[1]]){
                    correctPicks++;
                }
                numOfPastGames++;
            }
        }
        else {
            for (NSArray *game in finalsPicks[i-4]){
                if ([teamsInTournament[i] containsObject:game[0]] &&  [teamsInTournament[i] containsObject:game[1]]){
                    correctPicks+=2;
                }
                else if ([teamsInTournament[i] containsObject:game[0]] || [teamsInTournament[i] containsObject:game[1]]){
                    correctPicks++;
                }
                numOfPastGames++;
            }
        }
    }
    
    //store data in parse
    self.user[@"correctPicks"] = [NSNumber numberWithInt:correctPicks];
    //storing ratio of (teams that were correctly chosen to win in a certain round)/(actual winners)
    //I multiply number of past games by 2 because there's 2 teams per game
    NSString *ratio = [NSString stringWithFormat: @"%d/%d",  correctPicks, numOfPastGames * 2];
    self.user[@"ratio"] = ratio;
    //calculate percentage of picks user correctly made and store in parse
    int percent = floor(100 * (correctPicks / (float)(numOfPastGames * 2)));
    self.user[@"correctPicksPercent"] = [NSNumber numberWithInt:percent];
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
    }];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editProfileSegue"]) {
        EditProfileViewController *editVC = [segue destinationViewController];
        editVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"createBracketSegue"]){
        
    }

}


@end
