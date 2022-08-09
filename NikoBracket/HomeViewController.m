//
//  HomeViewController.m
//  NikoBracket
//
//  Created by Nikolas Georgaklis on 7/13/22.
//

#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "HomeViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "viewBracketViewController.h"

static int numOfPastGames;
static int kRound1 = 0;
static int kRound2 = 1;
static int kRound3 = 2;
static int kRound4 = 3;
static int kSemiFinal = 4;
static int kFinal = 5;

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic)NSArray *accountsArray;
@property (strong, nonatomic)NSMutableArray *filteredAccounts;
@property BOOL isFiltered;
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSMutableArray *teamsInTournament;
@property (strong, nonatomic) NSMutableDictionary *teams;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    
    self.isFiltered = false;
    self.searchBar.delegate = self;
    
    // parse teams json file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"teams" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.teams = [[NSMutableDictionary alloc] init];
    NSArray *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for (int i = 0; i < temp.count; i++) {
        self.teams[temp[i][@"Key"]] = temp[i];
    }

    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    self.homeTableView.rowHeight = 80;
    [self getAccounts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getAccounts) forControlEvents:UIControlEventValueChanged];
    [self.homeTableView insertSubview:self.refreshControl atIndex:0];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        self.isFiltered = false;
    }
    else{
        self.isFiltered = true;
        self.filteredAccounts = [[NSMutableArray alloc] init];
        
        for (PFUser *account in self.accountsArray) {
            NSRange nameRange = [account[@"displayName"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [self.filteredAccounts addObject:account];
            }
        }
    }
    
    [self.homeTableView reloadData];
}

-(void)getAccounts{
    PFQuery *query = [PFUser query];
    [query orderByDescending:@"correctPicks"];
    [query whereKey:@"createdBracket" equalTo:@(YES)];

    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *accounts, NSError *error) {
        if (accounts != nil) {
            self.accountsArray = accounts;
            [self.homeTableView reloadData];
            for (int i = 0; i < accounts.count; i++) {
                [self getUserBracketStats: kFinal withUser: accounts[i] withRank:[NSNumber numberWithInt:i+1]];//using final round for now
                accounts[i][@"rank"] = [NSNumber numberWithInt:i+1];
            }
            

        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeViewCell *cell = [self.homeTableView dequeueReusableCellWithIdentifier:@"HomeViewCell"];
    if (self.isFiltered) {
        cell.user = self.filteredAccounts[indexPath.row];
    }
    else {
        cell.user = self.accountsArray[indexPath.row];
    }
    NSString *selectedChampion = cell.user[@"finalsPicks"][1][0][[cell.user[@"finalsPicks"][1][0][2] intValue]];
    [cell.selectedChampionLogo setImageWithURL:[NSURL URLWithString:self.teams[selectedChampion][@"TeamLogoUrl"]]];
    [cell setUserInfo];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isFiltered) {
        return self.filteredAccounts.count;
    }
    else{
        return self.accountsArray.count;
    }
}

- (void)getUserBracketStats:(NSInteger *)round withUser:(PFUser *)user withRank: (NSNumber *) rank{
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
    self.teamsInTournament = [[NSMutableArray alloc] init];
    for (int i = 0; i<6; i++) {
        [self.teamsInTournament addObject:[[NSMutableArray alloc] init]];
    }

    //separate teams by round; round key returns inaccurate data in free version of API so we separate rounds by date
    for (NSDictionary *game in allMatchups) {
        //round 1 happened 3/17-18 in 2022
        if ([game[@"Day"] containsString:@"2022-03-17"]
            || [game[@"Day"] containsString:@"2022-03-18"]){
            [self.teamsInTournament[0] addObject:game[@"HomeTeam"]];
            [self.teamsInTournament[0] addObject:game[@"AwayTeam"]];
        }
        //round 2 happened 3/19-20 in 2022
        if ([game[@"Day"] containsString:@"2022-03-19"]
            || [game[@"Day"] containsString:@"2022-03-20"]){
            [self.teamsInTournament[1] addObject:game[@"HomeTeam"]];
            [self.teamsInTournament[1] addObject:game[@"AwayTeam"]];
        }
        //round 3 happened 3/24-25 in 2022
        if ([game[@"Day"] containsString:@"2022-03-24"]
            || [game[@"Day"] containsString:@"2022-03-25"]){
            [self.teamsInTournament[2] addObject:game[@"HomeTeam"]];
            [self.teamsInTournament[2] addObject:game[@"AwayTeam"]];
        }
        //round 4 happened 3/26-27 in 2022
        if ([game[@"Day"] containsString:@"2022-03-26"]
            || [game[@"Day"] containsString:@"2022-03-27"]){
            [self.teamsInTournament[3] addObject:game[@"HomeTeam"]];
            [self.teamsInTournament[3] addObject:game[@"AwayTeam"]];
        }
        //semifinals/final4 happened 4/2 in 2022
        if ([game[@"Day"] containsString:@"2022-04-02"]){
            [self.teamsInTournament[4] addObject:game[@"HomeTeam"]];
            [self.teamsInTournament[4] addObject:game[@"AwayTeam"]];
        }
        //championship happened 4/4 in 2022
        if ([game[@"Day"] containsString:@"2022-04-04"]){
            [self.teamsInTournament[5] addObject:game[@"HomeTeam"]];
            [self.teamsInTournament[5] addObject:game[@"AwayTeam"]];
        }
    }

    NSArray *westPicks = user[@"westPicks"];
    NSArray *southPicks = user[@"southPicks"];
    NSArray *eastPicks = user[@"eastPicks"];
    NSArray *midwestPicks = user[@"midwestPicks"];
    NSArray *finalsPicks = user[@"finalsPicks"];

    //correct picks and number of past games initialized to 0
    int correctPicks = 0;
    numOfPastGames = 0;

    //i is initialized to 1 because user's picks begin in round 2, everyone's round 1 looks the same
    for (int i = 1; i<=round; i++) {
        if (i < 4) {//4 is semi finals round
            for (NSArray *game in westPicks[i]){
                if ([self.teamsInTournament[i] containsObject:game[0]] &&  [self.teamsInTournament[i] containsObject:game[1]]){
                    correctPicks+=2;
                }
                else if ([self.teamsInTournament[i] containsObject:game[0]] ||  [self.teamsInTournament[i] containsObject:game[1]]){
                    correctPicks++;
                }
                numOfPastGames++;
            }
            for (NSArray *game in southPicks[i]){
                if ([self.teamsInTournament[i] containsObject:game[0]] &&  [self.teamsInTournament[i] containsObject:game[1]]){
                    correctPicks+=2;
                }
                else if ([self.teamsInTournament[i] containsObject:game[0]] ||  [self.teamsInTournament[i] containsObject:game[1]]){
                    correctPicks++;
                }
                numOfPastGames++;
            }
            for (NSArray *game in eastPicks[i]){
                if ([self.teamsInTournament[i] containsObject:game[0]] &&  [self.teamsInTournament[i] containsObject:game[1]]){
                    correctPicks+=2;
                }
                else if ([self.teamsInTournament[i] containsObject:game[0]] ||  [self.teamsInTournament[i] containsObject:game[1]]){
                    correctPicks++;
                }
                numOfPastGames++;
            }
            for (NSArray *game in midwestPicks[i]){
                if ([self.teamsInTournament[i] containsObject:game[0]] &&  [self.teamsInTournament[i] containsObject:game[1]]){
                    correctPicks+=2;
                }
                else if ([self.teamsInTournament[i] containsObject:game[0]] ||  [self.teamsInTournament[i] containsObject:game[1]]){
                    correctPicks++;
                }
                numOfPastGames++;
            }
        }
        else {
            for (NSArray *game in finalsPicks[i-4]){
                if ([self.teamsInTournament[i] containsObject:game[0]] &&  [self.teamsInTournament[i] containsObject:game[1]]){
                    correctPicks+=2;
                }
                else if ([self.teamsInTournament[i] containsObject:game[0]] || [self.teamsInTournament[i] containsObject:game[1]]){
                    correctPicks++;
                }
                numOfPastGames++;
            }
        }
    }
    
    
    //storing ratio of (teams that were correctly chosen to win in a certain round)/(actual winners)
    //I multiply number of past games by 2 because there's 2 teams per game
    NSString *ratio = [NSString stringWithFormat: @"%d/%d",  correctPicks, numOfPastGames * 2];
    //calculate percentage of picks user correctly made
    int percent = floor(100 * (correctPicks / (float)(numOfPastGames * 2)));
    
    NSDictionary *params = @{@"username":user[@"username"],
                                 @"rank": rank,
                             @"correctPicks": [NSNumber numberWithInt:correctPicks],
                             @"ratio": ratio,
                             @"correctPicksPercent": [NSNumber numberWithInt:percent]
    };
        
    //store data in parse using cloud code
    [PFCloud callFunctionInBackground:@"rankUsers" withParameters:params block:^(id  _Nullable object, NSError * _Nullable error) {}];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    viewBracketViewController *viewBracketVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.homeTableView indexPathForCell:sender];
    
    HomeViewCell *cell = [self.homeTableView cellForRowAtIndexPath:indexPath];
    viewBracketVC.user = cell.user;
    viewBracketVC.finals = cell.user[@"finalsPicks"];
    NSString *westChampion = viewBracketVC.finals[0][0][0];
    NSString *eastChampion = viewBracketVC.finals[0][0][1];
    NSString *southChampion = viewBracketVC.finals[0][1][0];
    NSString *midwestChampion = viewBracketVC.finals[0][1][1];

    viewBracketVC.teamLogoURLs = [[NSMutableDictionary alloc] init];
    viewBracketVC.teamLogoURLs[westChampion] = self.teams[westChampion][@"TeamLogoUrl"];
    viewBracketVC.teamLogoURLs[eastChampion] = self.teams[eastChampion][@"TeamLogoUrl"];
    viewBracketVC.teamLogoURLs[southChampion] = self.teams[southChampion][@"TeamLogoUrl"];
    viewBracketVC.teamLogoURLs[midwestChampion] = self.teams[midwestChampion][@"TeamLogoUrl"];

}


@end
